<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><cs:ftcs>
<%
	String viewId = GenericUtil.cleanString(ics.GetVar("viewId"));
%>
<div id='viewContainer_<%= viewId%>' dojoType='dijit.layout.BorderContainer'>
	<xlat:lookup key="UI/UC1/JS/WebView" varname="label"/>
	<controller:callelement elementname='UI/Layout/CenterPane/Toolbar' responsetype='html'>
		<controller:argument name="showRefresh" value="true" />
		<controller:argument name="isWebMode" value="true" />
		<controller:argument name="label" value='<%=ics.GetVar("label")%>' />
	</controller:callelement>
	<div dojoType="dijit.layout.ContentPane" region="center" class="insiteArea">
		<div id='loadingWrapper_<ics:getvar name="viewId" />' class='loadingWrapper'>
			<div class='loadingContent'>
				<xlat:lookup key="dvin/UI/Loadingdotdotdot" varname="loadingtext"/>
				<img src="js/fw/images/ui/wem/loading.gif" alt='<%=ics.GetVar("loadingtext")%>' height="32" width="32" /><br />
				<ics:getvar name="loadingtext"/>
			</div>
		</div>
		<iframe id='contentPane_<ics:getvar name="viewId" />' src="about:blank" frameborder="0"></iframe>
		<iframe id='hiddenPane_<ics:getvar name="viewId" />' src="about:blank" frameborder="0" style="top: -10000px"></iframe>
	</div>
</div></cs:ftcs>