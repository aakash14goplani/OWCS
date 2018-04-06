<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="device" uri="futuretense_cs/device.tld" %>
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
					<ics:listget listname="childPages" fieldname="oid" output="HomePageId" />		
					</ics:listloop>
				</ics:then>
			</ics:if>
  </ics:then>
</ics:if>

	<render:callelement elementname="avisports/Page/DeviceLink" scoped="global" >
		<render:argument name="assetid" value='<%=ics.GetVar("HomePageId") %>' />
	</render:callelement>

	<div id="top-bar">
		<div id="logo">
			<a href='<%=ics.GetVar("pageUrl") %>'><div></div></a>
		</div>
		<div id="nav-icon-wrap" onClick='toggleNavigationBar();'>
			<a><div id="nav-icon" class="close"></div></a>
		</div>
	</div>
	<ics:if condition='<%= null != ics.GetVar("HomePageId") %>'>
		<ics:then>
			<div id="nav-container">
				<asset:load name="page" type="Page" objectid='<%=ics.GetVar("HomePageId") %>' />
				<asset:getsitenode name="page" output="pageNodeId"/>
				<siteplan:load name="pageNode" nodeid='<%=ics.GetVar("pageNodeId") %>' />
				<siteplan:children name="pageNode" list="homePageChildren" code="Placed" order="nrank"  />	
				<ics:listloop listname="homePageChildren">
					<ics:listget listname="homePageChildren" fieldname="oid" output="childId" />
					<assetset:setasset name="child" type="Page" id='<%=ics.GetVar("childId")%>' />
					<assetset:getattributevalues name="child" attribute="banner" listvarname="banner" typename="PageAttribute" />			
							
					<render:callelement elementname="avisports/Page/DeviceLink" scoped="global">
						<render:argument name="assetid" value='<%=ics.GetVar("childId") %>' />
					</render:callelement>	
					<ics:listget listname="banner" fieldname="value" output="bannerImageId" />
					<a href='<ics:getvar name="pageUrl" />' > 
						<render:calltemplate tname="Detail" c="AVIImage" cid='<%=ics.GetVar("bannerImageId") %>' />
					</a>
				</ics:listloop>
			</div>
		</ics:then>
	</ics:if>
</cs:ftcs>