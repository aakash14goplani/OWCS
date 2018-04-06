<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<cs:ftcs><!DOCTYPE html>
	<html lang="en">
	<head>
		<render:calltemplate tname="/Head" args="c,cid,d" />
	</head>
	<body id="avisports">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" args="d" />
		</div>
		<div id="section">
			<div id="article" class="article-detail">
				<render:calltemplate tname="Detail2" args="c,cid,d" style="pagelet" />
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer_Touch" />
		</div>
	</body>
	</html>
</cs:ftcs>