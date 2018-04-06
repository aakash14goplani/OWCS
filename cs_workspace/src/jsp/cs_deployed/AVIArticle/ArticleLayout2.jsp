<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<html lang="en">
<head>
	<render:calltemplate tname="/Head" args="c,cid" style="element" />
</head>
<body class="article-layout left-col">
	<div id="main">
		<div id="header">
			<render:callelement elementname="avisports/navbar" />
		</div>
		<div id="container">
			<div class="content">
				<render:calltemplate tname="Detail" args="c,cid" style="element" />
			</div>
			<div class="sidebar">
				<render:calltemplate tname="SideBar" args="c,cid" style="element" />
			</div>
		</div>
		<div id="footer">
			<render:callelement elementname="avisports/footer" />
		</div>
	</div>
</body>
</html>
</cs:ftcs>