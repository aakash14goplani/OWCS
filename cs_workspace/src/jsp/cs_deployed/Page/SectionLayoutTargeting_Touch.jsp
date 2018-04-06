<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs>
	<ics:callelement element="avisports/getdata">
		<ics:argument name="attributes" value="banner,recommendation" />
	</ics:callelement>
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
			<div id="post-wrap" class='<ics:getvar name="bg-color" />'>
				<insite:calltemplate slotname="RecSlotTouch" c="AdvCols" cid="${asset.recommendation.id}" tname="Detail" />
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer_NonTouch" />
		</div>
	</body>
	</html>
</cs:ftcs>