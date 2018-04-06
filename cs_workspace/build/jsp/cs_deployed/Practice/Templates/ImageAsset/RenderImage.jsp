<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
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
	<asset:load name="loadImageAsset" type='<%=ics.GetVar("c") %>' objectid='<%=ics.GetVar("cid") %>'/>
	<asset:scatter name="loadImageAsset" prefix="image"/>
	<ics:getvar name="image:name" output="imageName"/>
	<ics:getvar name="image:width" output="imageWidth"/>
	<ics:getvar name="image:height" output="imageHeight"/>
	<ics:getvar name="image:alt" output="imageAltName"/>
	<render:getbloburl outstr="image_url" c='<%=ics.GetVar("c") %>' cid='<%=ics.GetVar("cid") %>' field="urlpicture" /><%
	String imageName = ics.GetVar("imageName");
	String imageWidth = Utilities.goodString(ics.GetVar("imageWidth")) ? ics.GetVar("imageWidth") : "100%";
	String imageHeight = Utilities.goodString(ics.GetVar("imageHeight")) ? ics.GetVar("imageHeight") : "auto";
	String imageAltName = Utilities.goodString(ics.GetVar("imageAltName")) ? ics.GetVar("imageAltName") : "Image";
	String imageURL = Utilities.goodString(ics.GetVar("image_url")) ? ics.GetVar("image_url") : "#";
	%><div class="col-sm-6">
		<strong>Edit Image Parameters</strong>
		<div>Width : <insite:edit field="width" value='<%=imageWidth%>' params="{noValueIndicator: '[ Enter width ]', width: '300px', regExp: '[0-9 ]+', invalidMessage: 'only numbers allowed'}"/></div>		
		<div>Height : <insite:edit field="height" value='<%=imageHeight%>' params="{noValueIndicator: '[ Enter height ]', width: '300px', regExp: '[0-9 ]+', invalidMessage: 'only numbers allowed'}"/></div>
		<div>Alternate Text : <insite:edit field="alt" value='<%=imageAltName%>' params="{noValueIndicator: '[ Enter Alternate Text ]', width: '300px'}"/></div>
	</div>
	<div class="col-sm-6">
		<strong><%=imageAltName%> <%=imageName %></strong>
		<insite:edit field="urlpicture" variable="image_url" assetid='<%=ics.GetVar("cid") %>' assettype='<%=ics.GetVar("c") %>' editor="upload">
			Image : <img src='<%=imageURL%>' alt="<%=imageAltName%>" width="<%=imageWidth%>" height="<%=imageHeight%>" />
		</insite:edit><br/>
	</div>
	<ics:removevar name="image:name" />
	<ics:removevar name="image:width" />
	<ics:removevar name="image:height" />
	<ics:removevar name="image:alt" />
	<ics:removevar name="image_url" />
</cs:ftcs>