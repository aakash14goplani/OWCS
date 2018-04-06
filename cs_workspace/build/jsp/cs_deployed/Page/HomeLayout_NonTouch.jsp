<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<cs:ftcs><!DOCTYPE html>
	<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
		</ics:then>
	</ics:if>
	<html lang="en">
	<head>
		<render:calltemplate tname="/Head" args="c,cid,d" />
	</head>
	<body id="avisports">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" args="d" />
		</div>
		<div id="section">
			<div id="banner">
				<render:calltemplate tname="Banner/Home2" args="c,cid,d" />
			</div>
			<div id="post-wrap">
				<render:calltemplate tname="Detail/Home2" args="c,cid,d" />
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer_NonTouch" />
		</div>
	</body>
	</html>
</cs:ftcs>