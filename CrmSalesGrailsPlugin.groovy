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
            link controller: "crmSalesProject", action: "index"
            permissions {
                guest "crmSalesProject:index,list,show,createFavorite,deleteFavorite,clearQuery,autocompleteUsername"
                partner "crmSalesProject:index,list,show,createFavorite,deleteFavorite,clearQuery,autocompleteUsername"
                user "crmSalesProject:*"
                admin "crmSalesProject,crmSalesProjectStatus,crmSalesProjectRelationType:*"
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

}
