package grails.plugins.crm.sales

import grails.events.Listener
import grails.plugins.crm.core.DateUtils
import grails.plugins.crm.contact.CrmContact
import grails.plugins.crm.core.SearchUtils
import grails.plugins.crm.core.TenantUtils
import org.apache.commons.lang.StringUtils
import org.codehaus.groovy.grails.web.metaclass.BindDynamicMethod
import grails.plugins.selection.Selectable

import java.text.DecimalFormat

/**
 * Sales Management service methods.
 */
class CrmSalesService {

    def grailsApplication
    def crmSecurityService
    def crmTagService
    def messageSource

    @Listener(namespace = "crmSales", topic = "enableFeature")
    def enableFeature(event) {
        println "crmSales.enableFeature $event"
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

            createSalesProjectRoleType(name: messageSource.getMessage("crmSalesProjectRoleType.name.customer", null, "Customer", locale), param: "customer", true)
            createSalesProjectRoleType(name: messageSource.getMessage("crmSalesProjectRoleType.name.contact", null, "Contact", locale), param: "contact", true)
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

    List<CrmSalesProjectStatus> listSalesProjectStatus(String name, Map params = [:]) {
        CrmSalesProjectStatus.createCriteria().list(params) {
            eq('tenantId', TenantUtils.tenant)
            if (name) {
                or {
                    ilike('name', SearchUtils.wildcard(name))
                    eq('param', name)
                }
            }
        }
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
        def locale = new Locale("sv", "SE")
        def timezone = TimeZone.getTimeZone("MET")
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
            if (query.value) {
                doubleQuery(delegate, 'value', query.value, locale)
            }
            if (query.date1) {
                sqlDateQuery(delegate, 'date1', query.date1, locale, timezone)
            }
            if (query.date2) {
                sqlDateQuery(delegate, 'date2', query.date2, locale, timezone)
            }
            if (query.date3) {
                sqlDateQuery(delegate, 'date3', query.date3, locale, timezone)
            }
            if (query.date4) {
                sqlDateQuery(delegate, 'date4', query.date4, locale, timezone)
            }
        }
    }

    /**
     * Parse a query string and apply criteria for a Double property.
     *
     * @param criteriaDelegate
     * @param prop the property to query
     * @param query the query string, can contain &lt; &gt and -
     * @param locale the locale to use for number parsing
     */
    private void doubleQuery(Object criteriaDelegate, String prop, String query, Locale locale) {
        if (!query) {
            return
        }
        final DecimalFormat format = DecimalFormat.getNumberInstance(locale)
        if (query[0] == '<') {
            criteriaDelegate.lt(prop, format.parse(query.substring(1)).doubleValue())
        } else if (query[0] == '>') {
            criteriaDelegate.gt(prop, format.parse(query.substring(1)).doubleValue())
        } else if (query.contains('-')) {
            def (from, to) = query.split('-').toList()
            criteriaDelegate.between(prop, format.parse(from).doubleValue(), format.parse(to).doubleValue())
        } else if (query.contains(' ')) {
            def (from, to) = query.split(' ').toList()
            criteriaDelegate.between(prop, format.parse(from).doubleValue(), format.parse(to).doubleValue())
        } else {
            criteriaDelegate.eq(prop, format.parse(query).doubleValue())
        }
    }

    /**
     * Parse a query string and apply criteria for a java.sql.Date property.
     *
     * @param criteriaDelegate
     * @param prop the property to query
     * @param query the query string, can contain &lt &gt and -
     * @param locale the locale to use for date parsing
     * @param timezone the timezone to use for date parsing
     */
    private void sqlDateQuery(Object criteriaDelegate, String prop, String query, Locale locale, TimeZone timezone) {
        if (!query) {
            return
        }
        if (query[0] == '<') {
            criteriaDelegate.lt(prop, DateUtils.parseSqlDate(query.substring(1), timezone))
        } else if (query[0] == '>') {
            criteriaDelegate.gt(prop, DateUtils.parseSqlDate(query.substring(1), timezone))
        } else if (query.contains(' ')) {
            def (from, to) = query.split(' ').toList()
            criteriaDelegate.between(prop, DateUtils.parseSqlDate(from, timezone), DateUtils.parseSqlDate(to, timezone))
        } else {
            criteriaDelegate.eq(prop, DateUtils.parseSqlDate(query, timezone))
        }
    }


    CrmSalesProject getSalesProject(Long id) {
        CrmSalesProject.findByIdAndTenantId(id, TenantUtils.tenant)
    }

    CrmSalesProject createSalesProject(Map params, boolean save = false) {
        def tenant = TenantUtils.tenant
        def currentUser = crmSecurityService.currentUser
        def customer = createSalesProjectRoleType(name: "Customer", true)
        def contact = createSalesProjectRoleType(name: "Contact", true)
        def m = new CrmSalesProject()
        def args = [m, params, [include: CrmSalesProject.BIND_WHITELIST]]
        new BindDynamicMethod().invoke(m, 'bind', args.toArray())
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
            m.currency = grailsApplication.config.crm.currency.default ?: "EUR"
        }
        if (m.probability == null) {
            def probability = grailsApplication.config.crm.sales.probability.default
            m.probability = probability != null ? probability : 1.0
        }
        if (m.value == null) {
            m.value = 0.0
        }
        if (!m.date1) {
            m.date1 = new java.sql.Date(System.currentTimeMillis())
        }
        if (params.customer) {
            def role = new CrmSalesProjectRole(project: m, contact: params.customer, type: customer)
            if (!role.hasErrors()) {
                m.addToRoles(role)
            }

        }
        if (params.contact) {
            def role = new CrmSalesProjectRole(project: m, contact: params.contact, type: contact)
            if (!role.hasErrors()) {
                m.addToRoles(role)
            }
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

    CrmSalesProjectRoleType getSalesProjectRoleType(String param) {
        CrmSalesProjectRoleType.findByParamAndTenantId(param, TenantUtils.tenant, [cache: true])
    }

    CrmSalesProjectRoleType createSalesProjectRoleType(params, boolean save = false) {
        if (!params.param) {
            params.param = StringUtils.abbreviate(params.name?.toLowerCase(), 20)
        }
        def tenant = TenantUtils.tenant
        def m = CrmSalesProjectRoleType.findByParamAndTenantId(params.param, tenant)
        if (!m) {
            m = new CrmSalesProjectRoleType()
            def args = [m, params, [include: CrmSalesProjectRoleType.BIND_WHITELIST]]
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

    List<CrmSalesProject> findProjectsByContact(CrmContact contact, String role = null, Map params = [:]) {
        CrmSalesProject.createCriteria().list(params) {
            eq('tenantId', contact.tenantId) // This is not necessary, but hopefully it helps the query optimizer
            roles {
                eq('contact', contact)
                if (role) {
                    type {
                        or {
                            ilike('name', SearchUtils.wildcard(role))
                            eq('param', role)
                        }
                    }
                }
            }
        }
    }
}
