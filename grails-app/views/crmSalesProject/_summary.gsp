<%@ page import="grails.plugins.crm.core.DateUtils" defaultCodec="html" %>

<p>

    Affären <strong>${bean.name}</strong><br/>

    <g:if test="${bean.customer}">
        ... med <strong>${bean.customer}</strong>.<br/>
    </g:if>
    <g:else>
        ... <span class="label label-important">saknar kund!</span><br/>
    </g:else>

    <g:if test="${bean.date2}">
        ... beräknas landa <g:formatDate date="${bean.date2}" type="date" style="long"/>.
    </g:if>
    <g:else>
        ... har inget orderdatum.
    </g:else>

</p>
