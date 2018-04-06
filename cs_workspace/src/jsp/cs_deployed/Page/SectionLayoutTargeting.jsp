<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<ics:callelement element="avisports/getdata">
	<ics:argument name="attributes" value="banner,recommendation" />
</ics:callelement>

<asset:load name="PageAsset" type="Page" objectid='<%=ics.GetVar("cid")%>' flushonvoid="true" />
<asset:get name="PageAsset" field="name" output="outputNameVariable"/>

<html lang="en">
<head>
	<render:calltemplate tname="/Head" args="c,cid" style="element" />
</head>
<body class="section">
	<div id="main">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" />
		</div>
		<div id="container">
			<div class="content">
				<ics:listget listname="section:banner" fieldname="value" output="bannerId" />
				<insite:calltemplate tname="Detail" c="AVIImage" cid='${asset.banner.id}'
									 field="banner"
									 cssstyle="aviSectionBanner" emptytext="[ Drop Banner Image ]"  />
			</div>
			
			<div class="center-column blue">
				<insite:calltemplate tname="Detail" field="recommendation" c="AdvCols" cid="${asset.recommendation.id}" slotname="RecSlot" >
					<insite:argument name="ArticleName" value='<%=ics.GetVar("outputNameVariable")%>'/>
				</insite:calltemplate>	
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer" />
		</div>
	</div>
</body>
</html>
</cs:ftcs>