<%@page import="com.fatwire.ics.jsp.GetVar"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
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

	<asset:load name="loadPageAsset" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' />
	<asset:get name="loadPageAsset" field="name" output="pageAssetName" />
	
	<assetset:setasset name="fetchPageAssetDetails" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' /> 
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="practice_page_title" listvarname="titleList"/>
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="practice_insite_asset_dropzone" listvarname="insiteDropzoneList"/>
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="practice_page_bodyText_dropzone" listvarname="bodyTextDropzoneList"/>
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="practice_page_date_price_dropzone" listvarname="priceDateDropzoneList"/>
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="practice_page_image_dropzone" listvarname="inmageDropzoneList"/>
	<assetset:getattributevalues name="fetchPageAssetDetails" typename="PageAttribute" attribute="content_editable_dropzone" listvarname="contentEditableDropzoneList"/>
	
	<html>
		<head>
			<title><ics:getvar name="pageAssetName"/></title>
			<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<ics:setvar name="context" value='<%=ics.GetVar("c")+":"+ics.GetVar("cid")+":"+ics.GetVar("pageAssetName")+":PresentationEditing" %>'/>
						Context Presentation Edit: <ics:getvar name="context"/>
					</div>
					<div class="col-sm-12">
						<h1 class="text-center">											
							<ics:if condition='<%= null != ics.GetList("titleList") && ics.GetList("titleList").hasData() && Utilities.goodString(ics.GetList("titleList").getValue("value").trim())%>'>
								<ics:then><ics:listget listname="titleList" fieldname="value"/></ics:then>
								<ics:else><ics:getvar name="pageAssetName"/></ics:else>
							</ics:if>
						</h1>
					</div>
				</div>
				<div class="row">
					<ics:if condition='<%= null != ics.GetList("contentEditableDropzoneList") && ics.GetList("contentEditableDropzoneList").hasData()%>'>
						<ics:then>
							<hr/><h2 class="text-center">Content Editable Dropzone</h2><hr/>
							<ics:listloop listname="contentEditableDropzoneList">
								<ics:listget listname="contentEditableDropzoneList" fieldname="value" output="assetId"/>
								<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("assetId")%>'/>
	    						<asset:get name="loadCurrentAsset" field="template" output="templateName" />
	    						<insite:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' slotname="ContentEditableDropzone"/>
	    						<%-- <render:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' /> --%>
								<ics:removevar name="templateName"/>
								<ics:removevar name="assetId"/>
							</ics:listloop>
						</ics:then>
					</ics:if>
				</div>
				<div class="row">
					<ics:if condition='<%= null != ics.GetList("insiteDropzoneList") && ics.GetList("insiteDropzoneList").hasData()%>'>
						<ics:then>
							<hr/><h2 class="text-center">In-Site Drop Zone</h2><hr/>
							<ics:listloop listname="insiteDropzoneList">
								<ics:listget listname="insiteDropzoneList" fieldname="value" output="assetId"/>
								<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("assetId")%>'/>
	    						<asset:get name="loadCurrentAsset" field="template" output="templateName" />
	    						<insite:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' slotname="InsiteDropZone" />
	    						<%-- <render:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' /> --%>
								<ics:removevar name="templateName"/>
								<ics:removevar name="assetId"/>
							</ics:listloop>
						</ics:then>
					</ics:if>
				</div>
				<div class="row">
					<ics:if condition='<%= null != ics.GetList("bodyTextDropzoneList") && ics.GetList("bodyTextDropzoneList").hasData()%>'>
						<ics:then>
							<hr/><h2 class="text-center">Body Text Drop Zone</h2><hr/>
							<ics:listloop listname="bodyTextDropzoneList">
								<ics:listget listname="bodyTextDropzoneList" fieldname="value" output="assetId"/>
								<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("assetId")%>'/>
	    						<asset:get name="loadCurrentAsset" field="template" output="templateName" />
	    						<insite:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' slotname="BodyTextDropzone" />
	    						<%-- <render:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' /> --%>
								<ics:removevar name="templateName"/>
								<ics:removevar name="assetId"/>
							</ics:listloop>
						</ics:then>
					</ics:if>
				</div>
				<div class="row">
					<ics:if condition='<%= null != ics.GetList("priceDateDropzoneList") && ics.GetList("priceDateDropzoneList").hasData()%>'>
						<ics:then>
							<hr/><h2 class="text-center">Price-Date Drop Zone</h2><hr/>
							<ics:listloop listname="priceDateDropzoneList">
								<ics:listget listname="priceDateDropzoneList" fieldname="value" output="assetId"/>
								<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("assetId")%>'/>
	    						<asset:get name="loadCurrentAsset" field="template" output="templateName" />
	    						<insite:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' slotname="PriceDateDropzone" />
	    						<%-- <render:calltemplate tname='<%=ics.GetVar("templateName") %>' c="Practice_C" cid='<%=ics.GetVar("assetId") %>' /> --%>
								<ics:removevar name="templateName"/>
								<ics:removevar name="assetId"/>
							</ics:listloop>
						</ics:then>
					</ics:if>
				</div>
				<div class="row">
					<ics:if condition='<%= null != ics.GetList("inmageDropzoneList") && ics.GetList("inmageDropzoneList").hasData()%>'>
						<ics:then>
							<hr/><h2 class="text-center">Image Drop Zone</h2><hr/>
							<ics:listloop listname="inmageDropzoneList">
								<ics:listget listname="inmageDropzoneList" fieldname="value" output="assetId"/>
								<asset:load name="loadCurrentAsset" type="ImageAsset" objectid='<%=ics.GetVar("assetId")%>'/>
	    						<asset:get name="loadCurrentAsset" field="template" output="templateName" />
	    						<insite:calltemplate tname='<%=ics.GetVar("templateName") %>' c="ImageAsset" cid='<%=ics.GetVar("assetId") %>' slotname="ImageDropzone" />
	    						<%-- <render:calltemplate tname='<%=ics.GetVar("templateName") %>' c="ImageAsset" cid='<%=ics.GetVar("assetId") %>' /> --%>
								<ics:removevar name="templateName"/>
								<ics:removevar name="assetId"/>
							</ics:listloop>
						</ics:then>
					</ics:if>
				</div>
				<div class="row">
					<hr/><h2 class="text-center">CSElement Drop Zone</h2><hr/>
					<insite:calltemplate slotname="GetAssetInfoElement" clegal="CSElement" emptytext="CSElement Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Site Entry Drop Zone</h2><hr/>
					<insite:calltemplate slotname="GetAssetInfoSiteEntry" clegal="SiteEntry" emptytext="SiteEntry Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Trial Drop Zone</h2><hr/>
					<insite:calltemplate tname="RenderImage" slotname="ImageDropzoneTrial" />
				</div>
			</div>
		</body>
	</html>
</cs:ftcs>