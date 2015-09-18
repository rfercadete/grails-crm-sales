package grails.plugins.crm.sales

import grails.test.spock.IntegrationSpec
import grails.plugins.crm.core.CrmValidationException

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
        crmSalesService.addRole(project1, technipelago, customer)
        crmSalesService.addRole(project1, goran, "contact", "Nice guy")
        project1.save(flush: true)

        then:
        project1.customer.name == "Technipelago AB"
        project1.contact.name == "Goran Ehrsson"
        crmSalesService.findProjectsByContact(technipelago).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(technipelago, "bogusRole").isEmpty()
        crmSalesService.findProjectsByContact(goran).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(goran, "bogusRole").isEmpty()
        crmSalesService.list().size() == 2
    }

    def "save sales project"() {
        given:
        def status = crmSalesService.createSalesProjectStatus(name: "Negotiation", true)

        when:
        def project1 = crmSalesService.save(new CrmSalesProject(), [name: "Test project", status: status, probability: 0.5f, value: 100000])
        def project2 = crmSalesService.save(new CrmSalesProject(), [name: "Dummy project", status: status, value: 100000])

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
        crmSalesService.save(project1, [customer: technipelago, contact: goran])
        //crmSalesService.addRole(project1, technipelago, customer)
        //crmSalesService.addRole(project1, goran, "contact", "Nice guy")
        //project1.save(flush:true)

        then:
        project1.customer.name == "Technipelago AB"
        project1.contact.name == "Goran Ehrsson"
        crmSalesService.findProjectsByContact(technipelago).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(technipelago, "bogusRole").isEmpty()
        crmSalesService.findProjectsByContact(goran).iterator().next().toString() == "Test project"
        crmSalesService.findProjectsByContact(goran, "bogusRole").isEmpty()
        crmSalesService.list().size() == 2

        when:
        def pivotal = crmContactService.createCompany(name: "Pivotal", true)
        def grails = crmContactService.createPerson(firstName: "Grails", lastName: "Framework", related: [pivotal, company], true)

        then:
        pivotal.ident()
        grails.ident()

        when:
        crmSalesService.save(project1, [customer: pivotal, contact: grails])

        then:
        project1.customer.name == "Pivotal"
        project1.contact.name == "Grails Framework"

        when:
        crmSalesService.save(project1, [name: "Updated project"])

        then:
        project1.name == "Updated project"
        project1.customer.name == "Pivotal"
        project1.contact.name == "Grails Framework"

        when:
        crmSalesService.save(project1, [date1: "Not a date"])

        then:
        def e = thrown(CrmValidationException)
        e.message == "crmSalesProject.invalid.date.message"
        e.domainInstance == project1
        e.domainInstance.errors
    }

    def "find sales project"() {
        given:
        def company = crmContactService.createRelationType(name: "Company", true)
        def technipelago = crmContactService.createCompany(name: "Technipelago AB", true)
        def goran = crmContactService.createPerson(firstName: "Goran", lastName: "Ehrsson", related: [technipelago, company], true)
        def customer = crmSalesService.createSalesProjectRoleType(name: "Customer", true)
        def contact = crmSalesService.createSalesProjectRoleType(name: "Contact", true)
        def status = crmSalesService.createSalesProjectStatus(name: "Negotiation", true)

        when:
        def project1 = crmSalesService.createSalesProject(customer: technipelago, contact: goran, name: "Test project", status: status, probability: 0.5f, value: 100000, true)
        def project2 = crmSalesService.createSalesProject(customer: technipelago, name: "Dummy project", status: status, value: 100000, true)

        then:
        project1.ident()
        project1.currency == "SEK" // Defined in Config.groovy
        project1.weightedValue == 50000
        project1.customer != null
        project1.contact != null
        project2.probability == 0.2f // Defined in Config.groovy
        project2.weightedValue == 20000
        project2.customer != null
        project2.contact == null

        when:
        def result1 = crmSalesService.list([customer: 'Technipelago'], [sort: 'number', order: 'asc'])

        then:
        result1.size() == 2

        when:
        def result2 = crmSalesService.list([customer: 'Goran'], [sort: 'number', order: 'asc'])

        then:
        result2.size() == 1

        when:
        def result3 = crmSalesService.list([customer: 'Sven'], [sort: 'number', order: 'asc'])

        then:
        result3.size() == 0
    }
}
