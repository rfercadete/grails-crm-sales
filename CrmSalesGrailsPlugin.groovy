import grails.plugins.crm.sales.CrmSalesProject

class CrmSalesGrailsPlugin {
    def groupId = ""
    def version = "2.0.0"
    def grailsVersion = "2.2 > *"
    def dependsOn = [:]
    def pluginExcludes = [
            "grails-app/conf/ApplicationResources.groovy",
            "src/groovy/grails/plugins/crm/sales/CrmSalesTestSecurityDelegate.groovy",
            "grails-app/views/error.gsp"
    ]
    def title = "Grails CRM Sales Management Plugin"
    def author = "Goran Ehrsson"
    def authorEmail = "goran@technipelago.se"
    def description = '''\
Sales and lead management for Grails CRM.
'''
    def documentation = "http://gr8crm.github.io/plugins/crm-sales/"
    def license = "APACHE"
    def organization = [name: "Technipelago AB", url: "http://www.technipelago.se/"]
    def issueManagement = [system: "github", url: "https://github.com/goeh/grails-crm-sales/issues"]
    def scm = [url: "https://github.com/goeh/grails-crm-sales"]

    def features = {
        crmSales {
            description "Sales Management"
            link controller: "crmSales", action: "index"
            permissions {
                guest "crmSales:index,list,show,createFavorite,deleteFavorite"
                user "crmSales:*"
                admin "crmSales,crmSalesProjectStatus"
            }
            statistics { tenant ->
                def total = CrmSalesProject.countByTenantId(tenant)
                def updated = CrmSalesProject.countByTenantIdAndLastUpdatedGreaterThan(tenant, new Date() - 31)
                def usage
                if (total > 0) {
                    def tmp = updated / total
                    if (tmp < 0.1) {
                        usage = 'low'
                    } else if (tmp < 0.3) {
                        usage = 'medium'
                    } else {
                        usage = 'high'
                    }
                } else {
                    usage = 'none'
                }
                return [usage: usage, objects: total]
            }
        }
    }

    def doWithApplicationContext = { applicationContext ->
        def crmPluginService = applicationContext.crmPluginService
        def crmContactService = applicationContext.containsBean('crmContactService') ? applicationContext.crmContactService : null
        crmPluginService.registerView('crmMessage', 'index', 'tabs',
                [id: "crmSalesProject", index: 300, label: "crmSalesProject.label",
                        template: '/crmSalesProject/messages', plugin: "crm-sales"]
        )
        if (crmContactService) {
            crmPluginService.registerView('crmContact', 'show', 'tabs',
                    [id: "opportunities", permission: "crmSalesProject:list", label: "crmSalesProject.list.label", template: '/crmSalesProject/projects', plugin: "crm-sales", model: {
                        def result
                        if (crmContact.company) {
                            result = CrmSalesProject.findAllByCustomer(crmContact, [sort: 'number', order: 'asc'])
                        } else {
                            result = CrmSalesProject.findAllByContact(crmContact, [sort: 'number', order: 'asc'])
                        }
                        [result: result, totalCount: result.size()]
                    }]
            )
        }
    }
}
