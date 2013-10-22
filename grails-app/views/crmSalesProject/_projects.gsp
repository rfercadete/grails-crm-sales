<table class="table table-striped">
    <thead>
    <tr>
        <th><g:message code="crmSalesProject.customer.label" default="Customer"/></th>

        <g:sortableColumn property="name"
                          title="${message(code: 'crmSalesProject.name.label', default: 'Name')}"/>

        <g:sortableColumn property="status.name"
                          title="${message(code: 'crmSalesProject.status.label', default: 'Status')}"/>

        <g:sortableColumn property="date2"
                          title="${message(code: 'crmSalesProject.date2.label', default: 'Order Date')}"/>

        <th class="money"><g:message code="crmSalesProject.value.label" default="Value"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${result}" var="crmSalesProject">
        <tr>

            <td>
                <g:link controller="crmSalesProject" action="show" id="${crmSalesProject.id}">
                    ${fieldValue(bean: crmSalesProject, field: "customer")}
                </g:link>
            </td>

            <td>
                <g:link controller="crmSalesProject" action="show" id="${crmSalesProject.id}">
                    ${fieldValue(bean: crmSalesProject, field: "name")}
                </g:link>
            </td>

            <td>

                ${fieldValue(bean: crmSalesProject, field: "status")}

            </td>

            <td class="nowrap">

                <g:formatDate type="date" date="${crmSalesProject.date2}"/>

            </td>

            <td class="money nowrap">
                <g:formatNumber number="${crmSalesProject.value}" maxFractionDigits="0"
                                type="currency" currencyCode="${crmSalesProject.currency ?: 'EUR'}"/>
            </td>

        </tr>
    </g:each>
    </tbody>
</table>

<div class="form-actions btn-toolbar">
    <crm:button type="link" group="true" action="create" visual="success"
                icon="icon-file icon-white"
                label="crmSalesProject.button.create.label"
                title="crmSalesProject.button.create.help"
                permission="crmSalesProject:create"
                params="${createParams}">
    </crm:button>
</div>
