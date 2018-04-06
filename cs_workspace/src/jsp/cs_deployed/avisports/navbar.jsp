<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs>
<ics:ifnotempty variable="seid"><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:ifnotempty>
<ics:ifnotempty variable="eid"><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:ifnotempty>

<% //returns home Page id in variable 'AVIHomeId' %>
<ics:callelement element="avisports/Page/GetHome" />
<insite:setlocale locale="en_US" />
<div class="header-bar">
	<h1 class="logo"><a href="#">AviSports logo</a></h1>
</div>
<ul class="navigation">
	<li class="active">
		<render:callelement elementname="avisports/Page/GetHomeLink" />
	</li>
	<render:callelement elementname="avisports/Page/RenderChildren">
		<render:argument name="pageId" value='<%=ics.GetVar("AVIHomeId") %>' />
	</render:callelement>
</ul>
</cs:ftcs>