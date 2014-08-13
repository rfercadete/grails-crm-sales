package grails.plugins.crm.sales

import grails.events.Listener
import grails.plugins.crm.core.SearchUtils
import grails.plugins.crm.core.TenantUtils
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.web.metaclass.BindDynamicMethod
import grails.plugins.selection.Selectable

/**
 * Sales Management service methods.
 */
class CrmSalesService {

    def crmSecurityService
    def crmTagService
    def messageSource

    @Listener(namespace = "crmSales", topic = "enableFeature")
    def enableFeature(event) {
        // event = [feature: feature, tenant: tenant, role:role, expires:expires]
        def tenant = crmSecurityService.getTenantInfo(event.tenant)
        def locale = tenant.locale
        TenantUtils.withTenant(tenant.id) {

            crmTagService.createTag(name: CrmSalesProject.name, multiple: true)

            // Create default sales statuses.
            createSalesProjectStatus([orderIndex: 10, param: "1", name: getStatusName('1', 'Interest', locale)], true)
            createSalesProjectStatus([orderIndex: 20, param: "2", name: getStatusName('2', 'Presentation', locale)], true)
            createSalesProjectStatus([orderIndex: 30, param: "3", name: getStatusName('3', 'Negotiation', locale)], true)
            createSalesProjectStatus([orderIndex: 40, param: "4", name: getStatusName('4', 'Deal', locale)], true)
            createSalesProjectStatus([orderIndex: 50, param: "5", name: getStatusName('5', 'Delivered', locale)], true)
            createSalesProjectStatus([orderIndex: 90, param: "9", name: getStatusName('9', 'Lost', locale)], true)
        }
    }

    private String getStatusName(String key, String label, Locale locale) {
        messageSource.getMessage("crmSalesProjectStatus.name." + key, null, label, locale)
    }

    CrmSalesProjectStatus getSalesProjectStatus(String param) {
        CrmSalesProjectStatus.findByParamAndTenantId(param, TenantUtils.tenant, [cache: true])
    }

    CrmSalesProjectStatus createSalesProjectStatus(params, boolean save = false) {
        if (!params.param) {
            params.param = StringUtils.abbreviate(params.name?.toLowerCase(), 20)
        }
        def tenant = TenantUtils.tenant
        def m = CrmSalesProjectStatus.findByParamAndTenantId(params.param, tenant)
        if (!m) {
            m = new CrmSalesProjectStatus()
            def args = [m, params, [include: CrmSalesProjectStatus.BIND_WHITELIST]]
            new BindDynamicMethod().invoke(m, 'bind', args.toArray())
            m.tenantId = tenant
            if (params.enabled == null) {
                m.enabled = true
            }
            if (save) {
                m.save()
            } else {
                m.validate()
                m.clearErrors()
            }
        }
        return m
    }

    /**
     * Empty query = search all records.
     *
     * @param params pagination parameters
     * @return List or CrmSalesProject domain instances
     */
    @Selectable
    def list(Map params = [:]) {
        list([:], params)
    }

    /**
     * Find CrmSalesProject instances filtered by query.
     *
     * @param query filter parameters
     * @param params pagination parameters
     * @return List or CrmSalesProject domain instances
     */
    @Selectable
    def list(Map query, Map params) {
        def tagged

        if (query.tags) {
            tagged = crmTagService.findAllByTag(CrmSalesProject, query.tags).collect { it.id }
            if (!tagged) {
                tagged = [0L] // Force no search result.
            }
        }

        CrmSalesProject.createCriteria().list(params) {
            eq('tenantId', TenantUtils.tenant)
            if (tagged) {
                inList('id', tagged)
            }
            if (query.number) {
                ilike('number', SearchUtils.wildcard(query.number))
            }
            if (query.name) {
                ilike('name', SearchUtils.wildcard(query.name))
            }
            if (query.product) {
                ilike('product', SearchUtils.wildcard(query.product))
            }
            if (query.username) {
                ilike('username', SearchUtils.wildcard(query.username))
            }
            if (query.status) {
                status {
                    ilike('name', SearchUtils.wildcard(query.status))
                }
            }
            if (query.customer) {
                or {
                    customer {
                        ilike('name', SearchUtils.wildcard(query.customer))
                    }
                    contact {
                        ilike('name', SearchUtils.wildcard(query.customer))
                    }
                }
            }
        }
    }

    CrmSalesProject getSalesProject(Long id) {
        CrmSalesProject.findByIdAndTenantId(id, TenantUtils.tenant)
    }

    CrmSalesProject createSalesProject(Map params, boolean save = false) {
        def tenant = TenantUtils.tenant
        def currentUser = crmSecurityService.currentUser
        def m = new CrmSalesProject(params)
        m.tenantId = tenant
        if (!m.username) {
            m.username = currentUser?.username
        }
        if (!m.status) {
            m.status = CrmSalesProject.withNewSession {
                CrmSalesProjectStatus.createCriteria().get() {
                    eq('tenantId', tenant)
                    order 'orderIndex', 'asc'
                    maxResults 1
                }
            }
        }
        if (!m.currency) {
            m.currency = "SEK"
        }
        if (m.probability == null) {
            m.probability = 0.2
        }
        if (m.value == null) {
            m.value = 0.0
        }
        if (!m.date1) {
            m.date1 = new java.sql.Date(System.currentTimeMillis())
        }
        if (save) {
            m.save(failOnError: true, flush: true)
            event(for: "crmSalesProject", topic: "created", fork: false,
                    data: [id: m.id, tenant: m.tenantId, crmSalesProject: m, user: m.username])
        } else {
            m.validate()
            m.clearErrors()
        }
        return m
    }
}
