<%@ page import="grails.plugins.crm.core.DateUtils; grails.plugins.crm.sales.CrmSalesProject" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmSalesProject.label', default: 'Sales Opportunity')}"/>
    <title><g:message code="crmSalesProject.show.title" args="[entityName, crmSalesProject]"/></title>
    <r:script>
        $(document).ready(function () {
            $("a.crm-change-status").click(function(ev) {
                ev.preventDefault();
                var status = $(this).data('crm-id');
                $.post("${createLink(action: 'changeStatus', id: crmSalesProject.id)}", {status: status}, function(data) {

                });
            });
        });
    </r:script>
</head>

<body>

<div class="row-fluid">
<div class="span9">

<header class="page-header clearfix">
    <h1>
        ${crmSalesProject.encodeAsHTML()}
        <crm:favoriteIcon bean="${crmSalesProject}"/>
        <small>${crmSalesProject.customer?.encodeAsHTML()}</small>
    </h1>
</header>

<div class="tabbable">
<ul class="nav nav-tabs">
    <li class="active"><a href="#main" data-toggle="tab"><g:message code="crmSalesProject.tab.main.label"/></a>
    </li>
    <crm:pluginViews location="tabs" var="view">
        <crm:pluginTab id="${view.id}" label="${view.label}" count="${view.model?.totalCount}"/>
    </crm:pluginViews>
</ul>

<div class="tab-content">
<div class="tab-pane active" id="main">
<div class="row-fluid">
    <div class="span3">
        <dl>

            <g:if test="${crmSalesProject.name}">
                <dt><g:message code="crmSalesProject.name.label" default="Name"/></dt>

                <dd><g:fieldValue bean="${crmSalesProject}" field="name"/></dd>

            </g:if>

            <g:if test="${crmSalesProject.number}">
                <dt><g:message code="crmSalesProject.number.label" default="Number"/></dt>

                <dd><g:fieldValue bean="${crmSalesProject}" field="number"/></dd>

            </g:if>

            <g:if test="${crmSalesProject.product}">
                <dt><g:message code="crmSalesProject.product.label" default="Product"/></dt>

                <dd><g:fieldValue bean="${crmSalesProject}" field="product"/></dd>

            </g:if>

        </dl>
    </div>

    <div class="span3">
        <dl>

            <g:if test="${crmSalesProject.customer}">
                <dt><g:message code="crmSalesProject.customer.label" default="Customer"/></dt>

                <dd>
                    <g:link mapping="crm-contact-show" id="${crmSalesProject.customer?.id}">
                        <g:fieldValue bean="${crmSalesProject}" field="customer"/>
                    </g:link>
                    <div class="muted">
                        <g:fieldValue bean="${crmSalesProject.customer}" field="address"/>
                    </div>
                </dd>

            </g:if>

            <g:if test="${crmSalesProject.contact}">
                <dt><g:message code="crmSalesProject.contact.label" default="Contact"/></dt>

                <dd>
                    <g:link mapping="crm-contact-show" id="${crmSalesProject.contact?.id}">
                        <g:fieldValue bean="${crmSalesProject}" field="contact"/>
                    </g:link>
                    <div class="muted">
                        <g:fieldValue bean="${crmSalesProject.contact}" field="telephone"/>
                    </div>
                </dd>

            </g:if>

            <g:if test="${crmSalesProject.username}">
                <dt><g:message code="crmSalesProject.username.label" default="Responsible"/></dt>
                <dd><crm:user username="${crmSalesProject.username}">${name}</crm:user></dd>

            </g:if>

        </dl>

    </div>

    <div class="span3">

        <dl>

            <g:if test="${crmSalesProject.status}">
                <dt><g:message code="crmSalesProject.status.label" default="Status"/></dt>

                <dd><g:fieldValue bean="${crmSalesProject}" field="status"/></dd>

            </g:if>

            <dt><g:message code="crmSalesProject.probability.label" default="Probability"/></dt>
            <dd><g:formatNumber type="percent" number="${crmSalesProject.probability}"/></dd>

            <dt><g:message code="crmSalesProject.value.label" default="Value"/></dt>

            <dd>
                <g:formatNumber number="${crmSalesProject.value}"
                                type="currency"
                                currencyCode="${crmSalesProject.currency ?: 'EUR'}"
                                maxFractionDigits="0"/>
                <div class="muted">
                    <g:formatNumber type="currency" currencyCode="${crmSalesProject.currency}"
                                    number="${crmSalesProject.weightedValue}" maxFractionDigits="0"/>
                </div>
            </dd>
        </dl>

    </div>

    <div class="span3">
        <dl>

            <g:if test="${crmSalesProject.date1}">
                <dt><g:message code="crmSalesProject.date1.label" default="Date 1"/></dt>

                <dd><g:formatDate date="${crmSalesProject.date1}" type="date"/></dd>

            </g:if>

            <g:if test="${crmSalesProject.date2}">
                <dt><g:message code="crmSalesProject.date2.label" default="Date 2"/></dt>

                <dd>
                    <g:formatDate date="${crmSalesProject.date2}" type="date"/>
                </dd>

            </g:if>

            <g:if test="${crmSalesProject.date3}">
                <dt><g:message code="crmSalesProject.date3.label" default="Date 2"/></dt>

                <dd><g:formatDate date="${crmSalesProject.date3}" type="date"/></dd>

            </g:if>

            <g:if test="${crmSalesProject.date4}">
                <dt><g:message code="crmSalesProject.date4.label" default="Date 4"/></dt>

                <dd><g:formatDate date="${crmSalesProject.date4}" type="date"/></dd>

            </g:if>
        </dl>
    </div>

</div>


<g:if test="${crmSalesProject.description}">
    <div class="row-fluid">
        <div class="span7">
            <p style="background-color: #fefefe; border: 1px solid #f0f0f0; border-radius: 3px;">
                <g:decorate include="markdown">${crmSalesProject.description}</g:decorate>
            </p>
        </div>
    </div>
</g:if>

<g:form>
    <g:hiddenField name="id" value="${crmSalesProject.id}"/>
    <div class="form-actions btn-toolbar">

        <crm:selectionMenu location="crmSalesProject" visual="primary">
            <crm:button type="link" controller="crmSalesProject" action="index"
                        visual="primary" icon="icon-search icon-white"
                        label="crmSalesProject.find.label" permission="crmSalesProject:show"/>
        </crm:selectionMenu>

        <crm:button type="link" group="true" action="edit" id="${crmSalesProject.id}" visual="warning"
                    icon="icon-pencil icon-white"
                    label="crmSalesProject.button.edit.label" permission="crmSalesProject:edit">
            <button class="btn btn-warning dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <g:each in="${metadata.statusList}" var="status">
                    <li><a href="#" data-crm-id="${status.ident()}" class="crm-change-status">${status.encodeAsHTML()}</a></li>
                </g:each>
            </ul>
        </crm:button>

        <crm:button type="link" group="true" action="create"
                    visual="success" icon="icon-file icon-white"
                    label="crmSalesProject.button.create.label"
                    title="crmSalesProject.button.create.help"
                    permission="crmSalesProject:create">
        </crm:button>

        <div class="btn-group">
            <button class="btn btn-info dropdown-toggle" data-toggle="dropdown">
                <i class="icon-info-sign icon-white"></i>
                <g:message code="crmSalesProject.button.view.label" default="View"/>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <g:if test="${selection}">
                    <li>
                        <select:link action="list" selection="${selection}" params="${[view: 'list']}">
                            <g:message code="crmSalesProject.show.result.label" default="Show result in list view"/>
                        </select:link>
                    </li>
                </g:if>
                <crm:hasPermission permission="crmSalesProject:createFavorite">
                    <crm:user>
                        <g:if test="${crmSalesProject.isUserTagged('favorite', username)}">
                            <li>
                                <g:link action="deleteFavorite" id="${crmSalesProject.id}"
                                        title="${message(code: 'crmSalesProject.button.favorite.delete.help', args: [crmSalesProject])}">
                                    <g:message
                                            code="crmSalesProject.button.favorite.delete.label"/></g:link>
                            </li>
                        </g:if>
                        <g:else>
                            <li>
                                <g:link action="createFavorite" id="${crmSalesProject.id}"
                                        title="${message(code: 'crmSalesProject.button.favorite.create.help', args: [crmSalesProject])}">
                                    <g:message
                                            code="crmSalesProject.button.favorite.create.label"/></g:link>
                            </li>
                        </g:else>
                    </crm:user>
                </crm:hasPermission>
            </ul>
        </div>
    </div>

    <crm:timestamp bean="${crmSalesProject}"/>

</g:form>

</div>

<crm:pluginViews location="tabs" var="view">
    <div class="tab-pane tab-${view.id}" id="${view.id}">
        <g:render template="${view.template}" model="${view.model}" plugin="${view.plugin}"/>
    </div>
</crm:pluginViews>

</div>
</div>

</div>

<div class="span3">

    <div class="alert alert-info">
        <g:render template="summary" model="${[bean: crmSalesProject]}"/>
    </div>

    <g:render template="/tags" plugin="crm-tags" model="${[bean: crmSalesProject]}"/>

</div>
</div>

</body>
</html>
