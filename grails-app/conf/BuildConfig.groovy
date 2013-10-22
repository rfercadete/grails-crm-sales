grails.project.work.dir = "target"
grails.project.target.level = 1.6

grails.project.repos.default = "crm"

grails.project.dependency.resolution = {
    inherits("global") {}
    log "warn"
    legacyResolve false
    repositories {
        grailsHome()
        grailsCentral()
        mavenRepo "http://labs.technipelago.se/repo/crm-releases-local/"
        mavenRepo "http://labs.technipelago.se/repo/plugins-releases-local/"
    }
    dependencies {
        test "org.spockframework:spock-grails-support:0.7-groovy-2.0"
    }

    plugins {
        build(":tomcat:$grailsVersion",
                ":release:2.2.1",
                ":rest-client-builder:1.0.3") {
            export = false
        }
        runtime ":hibernate:$grailsVersion"

        test(":codenarc:0.18.1") { export = false }
        test(":spock:0.7") { export = false }

        compile "grails.crm:crm-core:latest.integration"
        compile "grails.crm:crm-security:latest.integration"
        compile "grails.crm:crm-contact-lite:latest.integration"
        compile "grails.crm:crm-product-ui:latest.integration"

        runtime "grails.crm:crm-ui-bootstrap:latest.integration"
        runtime "grails.crm:crm-tags:latest.integration"
        runtime ":user-tag:latest.integration"

        compile ":sequence-generator:latest.integration"
        compile ":selection:latest.integration"
        runtime ":selection-repository:latest.integration"
    }
}

codenarc {
    reports = {
        CrmXmlReport('xml') {
            outputFile = 'CodeNarcReport.xml'
            title = 'Grails CRM CodeNarc Report'
        }
        CrmHtmlReport('html') {
            outputFile = 'target/test-reports/CodeNarcReport.html'
            title = 'Grails CRM CodeNarc Report'
        }
    }
    processTestUnit = false
    processTestIntegration = false
}
