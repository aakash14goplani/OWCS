<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="device" uri="futuretense_cs/device.tld" %>
<%//
// avisports/Page/GetHomePageID
// Usage:- Given name of a siteplan "siteplanname" in current site, this element returns the home page id "assetid" of that siteplan, if it exists. 

// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

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
					<ics:listget listname="childPages" fieldname="oid" output="assetid" />		
					</ics:listloop>
				</ics:then>
			</ics:if>
  </ics:then>
</ics:if>

</cs:ftcs>