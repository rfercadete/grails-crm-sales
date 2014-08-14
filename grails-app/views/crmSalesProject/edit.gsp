<%@ page import="grails.plugins.crm.sales.CrmSalesProject" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales Opportunity')}"/>
    <title><g:message code="crmSalesProject.edit.title" args="[entityName, crmSalesProject]"/></title>
    <r:require modules="datepicker,autocomplete"/>
    <r:script>
    $(document).ready(function() {

        <crm:datepicker selector=".date"/>

        $("input[name='customer.name']").autocomplete("${createLink(action: 'autocompleteContact', params: [company: true])}", {
            remoteDataType: 'json',
            preventDefaultReturn: true,
            selectFirst: true,
            queryParamName: 'name',
            useCache: false,
            filter: false,
            onItemSelect: function(item) {
                var id = item.data[0];
                var name = item.data[3];
                $("input[name='customer.id']").val(id);
                $("input[name='customer.name']").val(name);
                $("header h1 small").text(name);
                var ac = $("input[name='contact.name']").data('autocompleter');
                if(ac) {
                    ac.setExtraParam('parent', id);
                    ac.cacheFlush();
                }
            },
            onNoMatch: function() {
                $("input[name='customer.id']").val('');
                $("header h1 small").text($("input[name='customer.name']").val());
                var ac = $("input[name='contact.name']").data('autocompleter');
                if(ac) {
                    ac.setExtraParam('parent', '');
                    ac.cacheFlush();
                }
            }
        });
        $("input[name='contact.name']").autocomplete("${createLink(action: 'autocompleteContact', params: [person: true])}", {
            remoteDataType: 'json',
            preventDefaultReturn: true,
            minChars: 1,
            /*selectFirst: true,*/
            queryParamName: 'name',
            useCache: false,
            filter: false,
            extraParams: {},
            onItemSelect: function(item) {
                $("input[name='contact.id']").val(item.data[0]);
                $("input[name='contact.name']").val(item.data[3]);
            },
            onNoMatch: function() {
                $("input[name='contact.id']").val('');
            }
        });

    });
    </r:script>
</head>

<body>

<crm:header title="crmSalesProject.edit.title" subtitle="${crmSalesProject.customer?.encodeAsHTML()}"
            args="[entityName, crmSalesProject]"/>

<g:hasErrors bean="${crmSalesProject}">
    <crm:alert class="alert-error">
        <ul>
            <g:eachError bean="${crmSalesProject}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                        error="${error}"/></li>
            </g:eachError>
        </ul>
    </crm:alert>
</g:hasErrors>

<g:form action="edit">

    <f:with bean="crmSalesProject">

        <g:hiddenField name="id" value="${crmSalesProject?.id}"/>
        <g:hiddenField name="version" value="${crmSalesProject?.version}"/>

        <g:hiddenField name="currency" value="${crmSalesProject.currency}"/>


        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#main" data-toggle="tab"><g:message
                        code="crmSalesProject.tab.main.label"/></a>
                </li>
                <li><a href="#desc" data-toggle="tab" accesskey="d"><g:message
                        code="crmSalesProject.tab.desc.label"/></a></li>

            </ul>

            <div class="tab-content">
                <div class="tab-pane active" id="main">
                    <div class="row-fluid">

                        <div class="span3">
                            <div class="row-fluid">
                                <f:field property="customer" label="crmSalesProject.customer.label">
                                    <g:textField name="customer.name" value="${crmSalesProject.customer?.name}"
                                                 autocomplete="off" autofocus="" class="span11"/>
                                    <g:hiddenField name="customer.id" value="${crmSalesProject.customer?.id}"/>
                                </f:field>
                                <f:field property="contact" label="crmSalesProject.contact.label">
                                    <g:textField name="contact.name"
                                                 value="${crmSalesProject.contact?.name}"
                                                 autocomplete="off"
                                                 class="span11"/>
                                    <g:hiddenField name="contact.id"
                                                   value="${crmSalesProject.contact?.id}"/>
                                </f:field>

                                <f:field property="username">
                                    <g:select name="username" from="${metadata.userList}" optionKey="username"
                                              optionValue="name"
                                              noSelection="${['': '']}"
                                              value="${crmSalesProject.username}" class="span11"/>
                                </f:field>
                            </div>
                        </div>

                        <div class="span3">
                            <div class="row-fluid">
                                <f:field property="name" label="crmSalesProject.name.label" input-class="span11"/>
                                <f:field property="product" label="crmSalesProject.product.label" input-class="span11"/>
                                <f:field property="number" label="crmSalesProject.number.label" input-class="span6"/>
                            </div>
                        </div>

                        <div class="span3">
                            <div class="row-fluid">
                                <f:field property="status">
                                    <g:select name="status.id" from="${metadata.statusList}"
                                              optionKey="id"
                                              value="${crmSalesProject.status?.id}" class="span11"/>
                                </f:field>
                                <f:field property="probability">
                                    <g:select name="probability" from="${metadata.probabilityList}"
                                              optionKey="${{ formatNumber(number: it, maxFractionDigits: 1) }}"
                                              optionValue="${{ formatNumber(number: it, type: 'percent') }}"
                                              value="${formatNumber(number: crmSalesProject.probability, maxFractionDigits: 1)}"
                                              class="span11"/>
                                </f:field>

                                <f:field property="value" label="crmSalesProject.value.label">
                                    <g:textField name="value"
                                                 value="${fieldValue(bean: crmSalesProject, field: 'value')}"
                                                 class="span10"/>
                                </f:field>
                            </div>
                        </div>

                        <div class="span3">
                            <div class="row-fluid">

                                <f:field property="date1" label="crmSalesProject.date1.label">
                                    <div class="input-append date"
                                         data-date="${formatDate(type: 'date', date: crmSalesProject.date1 ?: new Date())}">
                                        <g:textField name="date1" class="span11" size="10"
                                                     value="${formatDate(type: 'date', date: crmSalesProject.date1)}"/><span
                                            class="add-on"><i class="icon-th"></i></span>
                                    </div>
                                </f:field>
                                <f:field property="date2" label="crmSalesProject.date2.label">
                                    <div class="input-append date"
                                         data-date="${formatDate(type: 'date', date: crmSalesProject.date2 ?: new Date())}">
                                        <g:textField name="date2" class="span11" size="10"
                                                     value="${formatDate(type: 'date', date: crmSalesProject.date2)}"/><span
                                            class="add-on"><i class="icon-th"></i></span>
                                    </div>
                                </f:field>

                                <f:field property="date3" label="crmSalesProject.date3.label">
                                    <div class="input-append date"
                                         data-date="${formatDate(type: 'date', date: crmSalesProject.date3 ?: new Date())}">
                                        <g:textField name="date3" class="span11" size="10"
                                                     value="${formatDate(type: 'date', date: crmSalesProject.date3)}"/><span
                                            class="add-on"><i class="icon-th"></i></span>
                                    </div>
                                </f:field>

                                <f:field property="date4" label="crmSalesProject.date4.label">
                                    <div class="input-append date"
                                         data-date="${formatDate(type: 'date', date: crmSalesProject.date4 ?: new Date())}">
                                        <g:textField name="date4" class="span11" size="10"
                                                     value="${formatDate(type: 'date', date: crmSalesProject.date4)}"/><span
                                            class="add-on"><i class="icon-th"></i></span>
                                    </div>
                                </f:field>

                            </div>
                        </div>

                    </div>
                </div>

                <div class="tab-pane" id="desc">
                    <f:field property="description">
                        <g:textArea name="description" rows="10" cols="80"
                                    value="${crmSalesProject.description}" class="span11"/>
                    </f:field>
                </div>
            </div>
        </div>

        <div class="form-actions">
            <crm:button visual="warning" icon="icon-ok icon-white" label="crmSalesProject.button.update.label"/>
            <crm:button action="delete" visual="danger" icon="icon-trash icon-white"
                        label="crmSalesProject.button.delete.label"
                        confirm="crmSalesProject.button.delete.confirm.message" permission="crmSalesProject:delete"/>
            <crm:button type="link" action="show" id="${crmSalesProject.id}"
                        icon="icon-remove"
                        label="crmSalesProject.button.cancel.label"/>
        </div>

    </f:with>

</g:form>

</body>
</html>
