<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProjectStatus.label', default: 'Sales Status')}"/>
    <title><g:message code="crmSalesProjectStatus.edit.title" args="[entityName, crmSalesProjectStatus]"/></title>
</head>

<body>

<crm:header title="crmSalesProjectStatus.edit.title" args="[entityName, crmSalesProjectStatus]"/>

<div class="row-fluid">
    <div class="span9">

        <g:hasErrors bean="${crmSalesProjectStatus}">
            <crm:alert class="alert-error">
                <ul>
                    <g:eachError bean="${crmSalesProjectStatus}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                error="${error}"/></li>
                    </g:eachError>
                </ul>
            </crm:alert>
        </g:hasErrors>

        <g:form class="form-horizontal" action="edit"
                id="${crmSalesProjectStatus?.id}">
            <g:hiddenField name="version" value="${crmSalesProjectStatus?.version}"/>

            <f:with bean="crmSalesProjectStatus">
                <f:field property="name" input-autofocus=""/>
                <f:field property="description"/>
                <f:field property="param"/>
                <f:field property="icon"/>
                <f:field property="orderIndex"/>
                <f:field property="enabled"/>
            </f:with>

            <div class="form-actions">
                <crm:button visual="primary" icon="icon-ok icon-white" label="crmSalesProjectStatus.button.update.label"/>
                <crm:button action="delete" visual="danger" icon="icon-trash icon-white"
                            label="crmSalesProjectStatus.button.delete.label"
                            confirm="crmSalesProjectStatus.button.delete.confirm.message"
                            permission="crmSalesProjectStatus:delete"/>
                                <crm:button type="link" action="list"
                            icon="icon-remove"
                            label="crmSalesProjectStatus.button.cancel.label"/>
            </div>
        </g:form>
    </div>

    <div class="span3">
        <crm:submenu/>
    </div>
</div>
</body>
</html>
