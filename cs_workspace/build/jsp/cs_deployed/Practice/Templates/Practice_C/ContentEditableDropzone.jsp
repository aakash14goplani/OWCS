<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
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
	<assetset:setasset name="fetchDropzoneAssetDetails" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' /> 
	<assetset:getattributevalues name="fetchDropzoneAssetDetails" typename="Practice_A" attribute="practice_title" listvarname="titleList"/>
	<assetset:getattributevalues name="fetchDropzoneAssetDetails" typename="Practice_A" attribute="non_editable_assets" listvarname="assetList"/>
	<ics:listget fieldname="value" listname="titleList" output="title"/><%
	String title = Utilities.goodString(ics.GetVar("title")) ? ics.GetVar("title") : "Title";
	%><div class="col-sm-12">
		<ics:setvar name="context" value='<%=ics.GetVar("c")+":ContentEditableDropzone:"+ics.GetVar("cid") %>'/>
		Context Content Editable Dropzone Edit: <ics:getvar name="context"/>
	</div>
	<div class="col-sm-12">
		<strong class="text-center"><%=title %></strong>
	</div>
	<ics:if condition='<%=null != ics.GetList("assetList") && ics.GetList("assetList").hasData() %>'>
		<ics:then>
			<insite:slotlist field="non_editable_assets" slotname="NonEditableAssetDropzone_1">
			  	<ics:listloop listname="assetList">
			    	<ics:listget listname="assetList" fieldname="value" output="articleId" />
			    	<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("articleId")%>'/>
			    	<asset:get name="loadCurrentAsset" field="template" output="templateName" />
			    	<insite:calltemplate tname='<%=ics.GetVar("templateName")%>' c="Practice_C" cid='<%=ics.GetVar("articleId")%>' />
			    	<ics:removevar name="articleId"/>
					<ics:removevar name="templateName"/>
			  	</ics:listloop>
			</insite:slotlist>
		</ics:then>
	</ics:if>	
</cs:ftcs>