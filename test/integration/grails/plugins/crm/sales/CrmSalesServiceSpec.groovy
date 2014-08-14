package grails.plugins.crm.sales

import grails.plugin.spock.IntegrationSpec

/**
 * Created by goran on 2014-08-14.
 */
class CrmSalesServiceSpec extends IntegrationSpec {

    def crmSalesService
    def crmContactService

    def "create sales project"() {
        given:
        def status = crmSalesService.createSalesProjectStatus(name: "Negotiation", true)

        when:
        def project1 = crmSalesService.createSalesProject(name: "Test project", status: status, probability: 0.5f, value: 100000, true)
        def project2 = crmSalesService.createSalesProject(name: "Dummy project", status: status, value: 100000, true)

        then:
        project1.ident()
        project1.currency == "SEK" // Defined in Config.groovy
        project1.weightedValue == 50000
        project2.probability == 0.2f // Defined in Config.groovy
        project2.weightedValue == 20000
        project1.customer == null

        when:
        def company = crmContactService.createRelationType(name: "Company", true)
        def technipelago = crmContactService.createCompany(name: "Technipelago AB", true)
        def goran = crmContactService.createPerson(firstName: "Goran", lastName: "Ehrsson", related: [technipelago, company], true)
        def customer = crmSalesService.createSalesProjectRoleType(name: "Customer", true)
        def contact = crmSalesService.createSalesProjectRoleType(name: "Contact", true)

        then:
        technipelago.ident()
        goran.ident()
        customer.ident()
        contact.ident()

        when:
        project1.addToRoles(contact: technipelago, type: customer)
        project1.addToRoles(contact: goran, type: contact)
        project1.save(flush:true)

        then:
        project1.customer.name == "Technipelago AB"
        project1.contact.name == "Goran Ehrsson"
        crmSalesService.findProjectsByContact(technipelago).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(technipelago, "bogusRole").isEmpty()
        crmSalesService.findProjectsByContact(goran).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(goran, "bogusRole").isEmpty()
        crmSalesService.list().size() == 2
    }
}
