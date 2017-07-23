<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<assetset:setasset name="fetchNonEditableAssetDetails" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' /> 
	<assetset:getattributevalues name="fetchNonEditableAssetDetails" typename="Practice_A" attribute="practice_title" listvarname="titleList"/>
	<assetset:getattributevalues name="fetchNonEditableAssetDetails" typename="Practice_A" attribute="body_text" listvarname="bodyTextList"/>
	<div class="col-sm-12">
		<ics:setvar name="context" value='<%=ics.GetVar("c")+":NonEditableAsset:"+ics.GetVar("cid") %>'/>
		Context Non Editable: <ics:getvar name="context"/>
	</div>
	<div class="col-sm-12">
		<strong><ics:listget fieldname="value" listname="titleList"/> </strong>
		<ics:listget listname="bodyTextList" fieldname="value" output="BodyText" />
		<render:stream list="bodyTextList" column="value" />
	</div>
</cs:ftcs>