<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<assetset:setasset name="fetchBodyTextAssetDetails" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' /> 
	<assetset:getattributevalues name="fetchBodyTextAssetDetails" typename="Practice_A" attribute="practice_title" listvarname="titleList"/>
	<assetset:getattributevalues name="fetchBodyTextAssetDetails" typename="Practice_A" attribute="body_text" listvarname="bodyTextList"/>
	<div class="col-sm-12">
		<ics:setvar name="context" value='<%=ics.GetVar("c")+":BodyText:"+ics.GetVar("cid") %>'/>
		Context Body Text Edit: <ics:getvar name="context"/>
	</div>
	<div class="col-sm-12">
		<strong>
			Title: <insite:edit field="practice_title" list="titleList" column="value" params="{noValueIndicator: '[ Enter title here ]', width: '50%', regExp: '[a-zA-Z][a-zA-Z ]+[a-zA-Z]$', invalidMessage: 'only alphabets allowed'}" />
		</strong>
		<ics:listget listname="bodyTextList" fieldname="value" output="BodyText" />
		Editor: <insite:edit field="body_text" variable="BodyText" editor="ckeditor" params="{noValueIndicator: '[ Enter body_text here ]', width: '400px'}" />			
		<%-- <render:stream list="bodyTextList" column="value" /> --%>
	</div>
</cs:ftcs>