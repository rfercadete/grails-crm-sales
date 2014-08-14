<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales')}"/>
    <title><g:message code="crmSalesProject.list.title" args="[entityName]"/></title>
</head>

<body>

<crm:header title="crmSalesProject.list.title" subtitle="Sökningen resulterade i ${crmSalesProjectTotal} st affärer"
            args="[entityName]">
</crm:header>

<table class="table table-striped">
    <thead>
    <tr>
        <g:sortableColumn property="customer.name"
                          title="${message(code: 'crmSalesProject.customer.label', default: 'Customer')}"/>
        <g:sortableColumn property="name"
                          title="${message(code: 'crmSalesProject.name.label', default: 'Deal')}"/>

        <g:sortableColumn property="status.name"
                          title="${message(code: 'crmSalesProject.status.label', default: 'Status')}"/>

        <g:sortableColumn property="date2"
                          title="${message(code: 'crmSalesProject.date2.label', default: 'Order Date')}"/>

        <th class="money"><g:message code="crmSalesProject.value.label" default="Value"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${crmSalesProjectList}" var="crmSalesProject">
        <tr>

            <td>
                <select:link action="show" id="${crmSalesProject.id}" selection="${selection}">
                    ${fieldValue(bean: crmSalesProject, field: "customer")}
                </select:link>
            </td>

            <td>
                <select:link action="show" id="${crmSalesProject.id}" selection="${selection}">
                    ${fieldValue(bean: crmSalesProject, field: "name")}
                </select:link>
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

<crm:paginate total="${crmSalesProjectTotal}"/>

<g:form class="form-actions btn-toolbar">
    <input type="hidden" name="offset" value="${params.offset ?: ''}"/>
    <input type="hidden" name="max" value="${params.max ?: ''}"/>
    <input type="hidden" name="sort" value="${params.sort ?: ''}"/>
    <input type="hidden" name="order" value="${params.order ?: ''}"/>

    <g:each in="${selection.selectionMap}" var="entry">
        <input type="hidden" name="${entry.key}" value="${entry.value}"/>
    </g:each>

    <crm:selectionMenu visual="primary"/>

    <g:if test="${crmSalesProjectTotal}">
        <select:link action="export" accesskey="p" selection="${selection}" class="btn btn-info">
            <i class="icon-print icon-white"></i>
            <g:message code="crmSalesProject.button.export.label" default="Print/Export"/>
        </select:link>
    </g:if>

    <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                label="crmSalesProject.button.create.label" permission="crmSalesProject:create"/>
</g:form>

</body>
</html>
