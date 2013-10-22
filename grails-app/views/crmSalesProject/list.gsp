<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales')}"/>
    <title><g:message code="crmSalesProject.list.title" args="[entityName]"/></title>
    <r:script>
        $(document).ready(function () {
            $("button[name='_action_print']").click(function (ev) {
                $(this).button('loading');
            });
        });
    </r:script>
</head>

<body>

<crm:header title="crmSalesProject.list.title" subtitle="Sökningen resulterade i ${crmSalesProjectTotal} st affärer"
            args="[entityName]">
</crm:header>

<div class="row-fluid">
    <div class="span9">
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
                        <g:link action="show" id="${crmSalesProject.id}">
                            ${fieldValue(bean: crmSalesProject, field: "customer")}
                        </g:link>
                    </td>

                    <td>
                        <g:link action="show" id="${crmSalesProject.id}">
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

        <crm:paginate total="${crmSalesProjectTotal}"/>

        <div class="form-actions  btn-toolbar">
            <g:form>
                <input type="hidden" name="offset" value="${params.offset ?: ''}"/>
                <input type="hidden" name="max" value="${params.max ?: ''}"/>
                <input type="hidden" name="sort" value="${params.sort ?: ''}"/>
                <input type="hidden" name="order" value="${params.order ?: ''}"/>

                <g:each in="${selection.selectionMap}" var="entry">
                    <input type="hidden" name="${entry.key}" value="${entry.value}"/>
                </g:each>

                <crm:selectionMenu visual="primary"/>

                <g:if test="${crmSalesProjectTotal}">
                    <div class="btn-group">
                        <button class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                            <i class="icon-print icon-white"></i>
                            <g:message code="crmSalesProject.button.print.label" default="Print"/>
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu">
                            <crm:hasPermission permission="crmSalesProject:print">
                                <li>
                                    <select:link action="print" accesskey="p" target="pdf" selection="${selection}">
                                        <g:message code="crmSalesProject.button.print.pdf.label" default="Print to PDF"/>
                                    </select:link>
                                </li>
                            </crm:hasPermission>
                            <crm:hasPermission permission="crmSalesProject:export">
                                <li>
                                    <select:link action="export" accesskey="e" selection="${selection}">
                                        <g:message code="crmSalesProject.button.export.calc.label"
                                                   default="Print to spreadsheet"/>
                                    </select:link>
                                </li>
                            </crm:hasPermission>
                        </ul>
                    </div>
                </g:if>

                <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                            label="crmSalesProject.button.create.label" permission="crmSalesProject:create"/>
            </g:form>
        </div>

        <div class="span3">

        </div>

    </div>
</div>

</body>
</html>
