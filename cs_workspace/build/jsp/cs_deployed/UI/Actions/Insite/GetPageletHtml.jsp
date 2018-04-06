<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs>
<ics:setvar name="rendermode" value="${cs.rendermode}" />
<c:choose>
	<c:when test="${cs.c == 'CSElement'}">
		<render:callelement elementname='${cs.elementname}'>
			<c:forEach var="entry" items="${cs.pageletArgs}">
				<render:argument name="${entry.key}" value="${entry.value}"/>
			</c:forEach>
		</render:callelement>
	</c:when>
	<c:when test="${cs.c == 'SiteEntry'}">
		<render:satellitepage pagename='${cs.pagename}'>
			<c:forEach var="entry" items="${cs.pageletArgs}">
				<render:argument name="${entry.key}" value="${entry.value}"/>
			</c:forEach>
		</render:satellitepage>
	</c:when>
	<c:otherwise>
		<c:if test="${not empty cs.pagename}">
			<render:satellitepage pagename="${cs.pagename}">
				<render:argument name="c" value="${cs.c}" />
				<render:argument name="cid" value="${cs.cid}" />
				<c:forEach var="entry" items="${cs.pageletArgs}">
					<render:argument name="${entry.key}" value="${entry.value}"/>
				</c:forEach>
			</render:satellitepage>
		</c:if>
	</c:otherwise>
</c:choose>
</cs:ftcs>