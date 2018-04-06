<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<html lang="en">
<head>
	<render:calltemplate tname="/Head" args="c,cid" style="element" />
</head>
<body class="home">
	<div id="main">
		<div id="header">
			<render:satellitepage pagename="avisports/navbar" />
		</div>
		<div id="container">
			<div class="content">
				<div class="banner">
					<render:calltemplate tname="Banner/Home2" args="c,cid" style="element" />
				</div>
			</div>
			<div class="center-column">
				<div class="post-wrapper">
					<render:calltemplate tname="Detail/Home" args="c,cid" style="element" />
				</div>
			</div>
		</div>
		<div id="footer">
			<render:calltemplate tname="DesktopFooter" style="pagelet" args="c,cid" />
		</div>
	</div>
</body>
</html>
</cs:ftcs>