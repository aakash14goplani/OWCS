<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%>
<%@ taglib prefix="device" uri="futuretense_cs/device.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<cs:ftcs>
<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/>
    <!-- Based on 'd', load the appropriate site plan -->
	<device:siteplan output="targetSitePlanId" />
	<ics:if condition='<%=ics.GetVar("targetSitePlanId") != null%>'>
 <ics:then>
			<asset:load name="sitePlanOject" type="SitePlan" objectid='<%=ics.GetVar("targetSitePlanId")%>'/>
			<asset:getsitenode name="sitePlanOject" output="sitePlanId"/>
			
			<siteplan:load name="targetSPlan" nodeid='<%=ics.GetVar("sitePlanId") %>' />
			<siteplan:children name="targetSPlan" code="Placed" list="childPages" />

			<!-- Get the home page ID of given site plan. -->
			<ics:if condition='<%=(ics.GetErrno() == 0) %>' >
				<ics:then>		
					<ics:listloop listname="childPages" >
					<ics:listget listname="childPages" fieldname="oid" output="AVIHomeId" />		
					</ics:listloop>
				</ics:then>
			</ics:if>
  </ics:then>
</ics:if>
<ics:ifnotempty variable="AVIHomeId">
<ics:then>
	<render:callelement elementname="avisports/Page/GetLink" scoped="global">
		<render:argument name="assetid" value='<%=ics.GetVar("AVIHomeId")%>' />
	</render:callelement>
	<a href="<ics:getvar name="pageUrl" />">HOME</a>
</ics:then>
</ics:ifnotempty>
</cs:ftcs>