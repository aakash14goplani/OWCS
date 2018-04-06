<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" 
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
%><%@ page import="java.util.*"
%><cs:ftcs>
<div data-dojo-type="fw.dijit.UIMenu"><%
	int count = 0; %>
	<c:forEach var="menuItem" items='${menuItems}'>
		<c:choose>
			<c:when test="${not empty menuItem.deferred}">
				<div data-dojo-type="fw.dijit.UIPopupMenuItem" data-dojo-props='deferred: "true", action: "${menuItem.action}"'>
					<span>${menuItem.label}</span>
					<div data-dojo-type="fw.dijit.DeferredDeclarativeMenu" data-dojo-props='action: "${menuItem.action}", cache: "${menuItem.cache ? menuItem.cache : false}", src: "${menuItem.deferred}"'></div>
				</div>
			</c:when>
			<c:when test="${not empty menuItem.action && empty menuItem.children && empty menuItem.popup}">
				<div data-dojo-type="fw.dijit.UIMenuItem" data-dojo-props='action: "${menuItem.action}"'>
					<span>${menuItem.label}</span>
				</div>
			</c:when>
			<c:when test="${not empty menuItem.popup}">
				<div data-dojo-type="fw.dijit.UIPopupMenuItem" data-dojo-props='action: "${menuItem.action}"'>
					<span>${menuItem.label}</span>
					<controller:callelement elementname="${menuItem.popup}" responsetype="${menuItem.responsetype}" />
				</div>
			</c:when>
			<c:when test="${not empty menuItem.children}">
				<div data-dojo-type="fw.dijit.UIPopupMenuItem" data-dojo-props='action: "${menuItem.action}"'>
					<span>${menuItem.label}</span>
					<c:set var="tmp" scope="page" value="${menuItems}" />
					<c:set var="menuItems" value="${menuItem.children}" scope="request" />
					<controller:callelement elementname="UI/Layout/Header/Menu" />
					<c:set var="menuItems" value="${tmp}" />
				</div>
			</c:when>
			<c:when test='${menuItem.label == "separator"}'>
				<div data-dojo-type="fw.dijit.UIMenuSeparator"></div>
			</c:when>
		</c:choose><%
		count++;%>
	</c:forEach>
</div>
</cs:ftcs>