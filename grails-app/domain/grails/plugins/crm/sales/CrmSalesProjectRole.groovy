package grails.plugins.crm.sales

import grails.plugins.crm.contact.CrmContact

/**
 * Created by goran on 2014-08-14.
 */
class CrmSalesProjectRole {

    CrmContact contact
    CrmSalesProjectRoleType type
    String description

    static belongsTo = [project: CrmSalesProject]

    static constraints = {
        contact(unique: ['type', 'project'])
        type()
        description(maxSize: 2000, nullable: true, widget: 'textarea')
    }

    String toString() {
        contact.toString()
    }

}
