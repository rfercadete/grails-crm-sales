import grails.plugins.crm.sales.CrmSalesProject

class CrmSalesGrailsPlugin {
    def groupId = ""
    def version = "2.4.1-SNAPSHOT"
    def grailsVersion = "2.2 > *"
    def dependsOn = [:]
    def pluginExcludes = [
            "grails-app/conf/ApplicationResources.groovy",
            "src/groovy/grails/plugins/crm/sales/CrmSalesTestSecurityDelegate.groovy",
            "grails-app/views/error.gsp"
    ]
    def title = "GR8 CRM Sales/Lead Management Plugin"
    def author = "Goran Ehrsson"
    def authorEmail = "goran@technipelago.se"
    def description = '''\
Sales and lead management for GR8 CRM applications.
'''
    def documentation = "http://gr8crm.github.io/plugins/crm-sales/"
    def license = "APACHE"
    def organization = [name: "Technipelago AB", url: "http://www.technipelago.se/"]
    def issueManagement = [system: "github", url: "https://github.com/technipelago/grails-crm-sales/issues"]
    def scm = [url: "https://github.com/technipelago/grails-crm-sales"]

    def features = {
        crmSales {
            description "Sales Management"
            link controller: "crmSalesProject", action: "index"
            permissions {
                guest "crmSalesProject:index,list,show,createFavorite,deleteFavorite,clearQuery,autocompleteUsername,autocompleteContact"
                partner "crmSalesProject:index,list,show,createFavorite,deleteFavorite,clearQuery,autocompleteUsername,autocompleteContact"
                user "crmSalesProject:*"
                admin "crmSalesProject,crmSalesProjectStatus,crmSalesProjectRoleType:*"
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
