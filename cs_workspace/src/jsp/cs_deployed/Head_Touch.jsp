<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<cs:ftcs>
	<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
		</ics:then>
	</ics:if>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<script src="<%= request.getContextPath() + "/avisports/mobility/js/avisports.js" %>" ></script>
	<link rel="stylesheet" href="<%= request.getContextPath() + "/avisports/mobility/css/style-touch.css" %>" />
	<link rel="stylesheet" href="avisports/mobility/css/media-queries.css" />
	<assetset:setasset name="page" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>' />
	<assetset:getattributevalues name="page" attribute="metaTitle" listvarname="metaTitle" typename="PageAttribute" />
	<assetset:getattributevalues name="page" attribute="metaDescription" listvarname="metaDescription" typename="PageAttribute" />
	<title>
		<ics:listget listname="metaTitle" fieldname="value" />
	</title>
	<meta name="description" content='<ics:listget listname="metaDescription" fieldname="value" />' />
</cs:ftcs>