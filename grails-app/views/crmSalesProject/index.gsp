<%@ page import="grails.plugins.crm.core.TenantUtils; grails.plugins.crm.sales.CrmSalesProject; grails.plugins.crm.sales.CrmSalesProjectStatus" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales')}"/>
    <title><g:message code="crmSalesProject.find.title" args="[entityName]"/></title>
    <r:require modules="datepicker,autocomplete,select2"/>
    <r:script>
        $(document).ready(function () {
            <crm:datepicker selector="form .date"/>

        $("input[name='product']").autocomplete("${createLink(controller: 'crmProduct', action: 'autocomplete', params: [max: 20])}", {
                remoteDataType: 'json',
                useCache: false,
                filter: false,
                minChars: 1,
                preventDefaultReturn: true,
                selectFirst: true
            });
            $("input[name='customer']").autocomplete("${createLink(controller: 'crmContact', action: 'autocompleteContact', params: [max: 20])}", {
                remoteDataType: 'json',
                useCache: false,
                filter: false,
                minChars: 1,
                preventDefaultReturn: true,
                selectFirst: true,
                processData: function(data) {
                    return $.map(data, function(v, i) {
                        return {label: v.name, value: v.name};
                    });
                }
            });
            $("input[name='username']").autocomplete("${createLink(action: 'autocompleteUsername', params: [max: 20])}", {
                remoteDataType: 'json',
                useCache: false,
                filter: false,
                minChars: 1,
                preventDefaultReturn: true,
                selectFirst: true,
                processData: function(data) {
                    return $.map(data.results, function(v, i) {
                        return {label: v.text, value: v.id};
                    });
                }
            });
            $("input[name='tags']").autocomplete("${createLink(controller: 'crmTag', action: 'autocomplete', params: [entity: CrmSalesProject.name, max: 20])}", {
                remoteDataType: 'json',
                useCache: false,
                filter: false,
                minChars: 1,
                preventDefaultReturn: true,
                selectFirst: true
            });
        });
    </r:script>

    <style type="text/css">
    .select2-container {
        margin-bottom: 18px;
    }
    </style>
</head>

<body>

<crm:header title="crmSalesProject.find.title" args="[entityName]"/>

<g:form action="list">

    <div class="row-fluid">

        <div class="span3">
            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.name.label"/>
                </label>

                <div class="controls">
                    <g:textField name="name.label" value="${cmd.name}" class="span12" autofocus=""/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.number.label"/>
                </label>

                <div class="controls">
                    <g:textField name="number" value="${cmd.number}" class="span12"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.product.label"/>
                </label>

                <div class="controls">
                    <g:textField name="product" value="${cmd.product}" class="span12"/>
                </div>
            </div>
        </div>

        <div class="span3">
            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.customer.label"/>
                </label>

                <div class="controls">
                    <g:textField name="customer" value="${cmd.customer}" class="span12"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.username.label"/>
                </label>

                <div class="controls">
                    <g:textField name="username" value="${cmd.username}" class="span12"/>
                </div>
            </div>

        </div>

        <div class="span3">
            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.status.label"/>
                </label>

                <div class="controls">
                    <g:select from="${CrmSalesProjectStatus.findAllByTenantId(TenantUtils.tenant)}"
                              name="status"
                              optionKey="name" class="span12" noSelection="['': '']"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.value.label"/>
                </label>

                <div class="controls">
                    <g:textField name="value" value="${cmd.value}" class="span12"/>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProjectQueryCommand.tags.label"/>
                </label>

                <div class="controls">
                    <g:textField name="tags" value="${cmd.tags}" class="span12"/>
                </div>
            </div>
        </div>

        <div class="span3">
            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.date1.label"/>
                </label>

                <div class="controls">
                    <div class="inline input-append date">
                        <g:textField name="date1" class="span12" size="10" value="${cmd.date1}"/><span
                            class="add-on"><i class="icon-th"></i></span>
                    </div>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.date2.label"/>
                </label>

                <div class="controls">
                    <div class="inline input-append date">
                        <g:textField name="date2" class="span12" size="10" value="${cmd.date2}"/><span
                            class="add-on"><i class="icon-th"></i></span>
                    </div>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.date3.label"/>
                </label>

                <div class="controls">
                    <div class="inline input-append date">
                        <g:textField name="date3" class="span12" size="10" value="${cmd.date3}"/><span
                            class="add-on"><i class="icon-th"></i></span>
                    </div>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">
                    <g:message code="crmSalesProject.date4.label"/>
                </label>

                <div class="controls">
                    <div class="inline input-append date">
                        <g:textField name="date4" class="span12" size="10" value="${cmd.date4}"/><span
                            class="add-on"><i class="icon-th"></i></span>
                    </div>
                </div>
            </div>
        </div>

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
