package grails.plugins.crm.sales

import grails.plugins.crm.contact.CrmContact
import grails.plugins.crm.core.AuditEntity
import grails.plugins.crm.core.TenantEntity
import grails.plugins.sequence.SequenceEntity

/**
 * This domain class represents a lead or business deal.
 */
@TenantEntity
@AuditEntity
@SequenceEntity
class CrmSalesProject {
    String number
    String name
    String product
    String description
    CrmSalesProjectStatus status
    String username
    CrmContact customer
    CrmContact contact
    String currency
    Double value
    Float probability
    java.sql.Date date1
    java.sql.Date date2
    java.sql.Date date3
    java.sql.Date date4

    static constraints = {
        number(maxSize: 20, blank: false, unique: 'tenantId')
        name(maxSize: 80, blank: false)
        product(maxSize: 80, nullable: true)
        description(maxSize: 2000, nullable: true, widget: 'textarea')
        status()
        username(maxSize: 80, nullable: true)
        customer()
        contact(nullable: true)
        currency(maxSize: 4, blank: false)
        value(min:-999999999d, max:999999999d, scale:2)
        probability(min: 0f, max: 1f, scale: 2)
        date1(nullable: true)
        date2(nullable: true)
        date3(nullable: true)
        date4(nullable: true)
    }

    static mapping = {
        sort 'number': 'asc'
        number index: 'crm_sales_number_idx'
        name index: 'crm_sales_name_idx'
        product index: 'crm_sales_product_idx'
    }

    static transients = ['weightedValue']

    static taggable = true
    static attachmentable = true
    static dynamicProperties = true
    static relatable = true
    static auditable = true

    Double getWeightedValue() {
        (value && probability) ? value * probability : 0
    }

    String toString() {
        name.toString()
    }
}
