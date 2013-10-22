<%@ page import="grails.plugins.crm.core.TenantUtils; grails.plugins.crm.sales.CrmSalesProjectStatus" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales')}"/>
    <title><g:message code="crmSalesProject.find.title" args="[entityName]"/></title>
    <r:require module="datepicker"/>
    <r:script>
        $(document).ready(function () {
            $("form .date").datepicker({weekStart: 1});
        });
    </r:script>
</head>

<body>

<crm:header title="crmSalesProject.find.title" args="[entityName]"/>

<g:form action="list">

    <div class="row-fluid">

        <f:with bean="cmd">
            <div class="span3">
                <f:field property="name" label="crmSalesProject.name.label" input-autofocus=""
                         input-class="span12"
                         input-placeholder="${message(code: 'crmSalesProjectQueryCommand.name.placeholder', default: '')}"/>
                <f:field property="number" label="crmSalesProject.number.label" input-class="span12"
                         input-placeholder="${message(code: 'crmSalesProjectQueryCommand.number.placeholder', default: '')}"/>
                <f:field property="product" label="crmSalesProject.product.label" input-class="span12"
                         input-placeholder="${message(code: 'crmSalesProjectQueryCommand.product.placeholder', default: '')}"/>
            </div>

            <div class="span3">
                <f:field property="customer" label="crmSalesProject.customer.label" input-class="span12"
                         input-placeholder="${message(code: 'crmSalesProjectQueryCommand.customer.placeholder', default: '')}"/>
                <f:field property="username" label="crmSalesProjectQueryCommand.username.label">
                    <g:textField name="username" value="${cmd.username}" class="span12"
                                 placeholder="${message(code: 'crmSalesProjectQueryCommand.username.placeholder', default: '')}"/>
                </f:field>

            </div>

            <div class="span3">
                <f:field property="status" label="crmSalesProject.status.label"
                         input-placeholder="${message(code: 'crmSalesProjectQueryCommand.status.placeholder', default: '')}">
                    <g:select from="${CrmSalesProjectStatus.findAllByTenantId(TenantUtils.tenant)}"
                              name="status"
                              optionKey="name" class="span12" noSelection="['': 'Alla statusar']"/>
                </f:field>
            </div>

            <div class="span3">
                <f:field property="fromDate">
                    <div class="inline input-append date"
                         data-date="${formatDate(format: 'yyyy-MM-dd', date: cmd.fromDate ?: new Date())}">
                        <g:textField name="fromDate" class="span12" size="10" placeholder="ÅÅÅÅ-MM-DD"
                                     value="${formatDate(format: 'yyyy-MM-dd', date: cmd.fromDate)}"/><span
                            class="add-on"><i
                                class="icon-th"></i></span>
                    </div>
                </f:field>
                <f:field property="toDate">
                    <div class="inline input-append date"
                         data-date="${formatDate(format: 'yyyy-MM-dd', date: cmd.toDate ?: new Date())}">
                        <g:textField name="toDate" class="span12" size="10" placeholder="ÅÅÅÅ-MM-DD"
                                     value="${formatDate(format: 'yyyy-MM-dd', date: cmd.toDate)}"/><span
                            class="add-on"><i
                                class="icon-th"></i></span>
                    </div>
                </f:field>

                <f:field property="tags" label="crmSalesProjectQueryCommand.tags.label">
                    <g:textField name="tags" class="span11" value="${cmd.tags}"
                                 placeholder="${message(code: 'crmSalesProjectQueryCommand.tags.placeholder', default: '')}"/>
                </f:field>
            </div>
        </f:with>

    </div>

    <div class="form-actions btn-toolbar">
        <crm:selectionMenu visual="primary">
            <crm:button action="list" icon="icon-search icon-white" visual="primary"
                        label="crmSalesProject.button.search.label"/>
        </crm:selectionMenu>
        <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                    label="crmSalesProject.button.create.label" permission="crmSalesProject:create"/>
        <g:link action="clearQuery" class="btn btn-link"><g:message
                code="crmSalesProject.button.query.clear.label"
                default="Reset fields"/></g:link>
    </div>

</g:form>

</body>
</html>
