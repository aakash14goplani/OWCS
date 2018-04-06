<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="device" uri="futuretense_cs/device.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.fatwire.assetapi.query.Query"
%><%@ page import="com.fatwire.assetapi.query.Condition"
%><%@ page import="com.fatwire.assetapi.query.ConditionFactory"
%><%@ page import="com.fatwire.assetapi.query.OpTypeEnum"
%><%@ page import="com.fatwire.assetapi.query.SimpleQuery"
%><%@ page import="java.util.*"
%><%@ page import="com.openmarket.xcelerate.asset.*"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<%
Session ses = SessionFactory.getSession();
AssetDataManager mgr = (AssetDataManager) ses.getManager( AssetDataManager.class.getName() );
Condition c = ConditionFactory.createCondition( "tag", OpTypeEnum.EQUALS, ics.GetVar("cid") );
// We are searching through all the pages to get the page that is associated to the current article category
Query query = new SimpleQuery( "Page", null, c, Collections.singletonList( "title" ) );
AttributeData attrData = null;
boolean found = false;
for ( AssetData assetData : mgr.read( query ) ) {
	attrData = assetData.getAttributeData("title");%>
	<render:callelement elementname="avisports/Page/GetLink" scoped="global">
		<render:argument name="assetid" value='<%=String.valueOf(assetData.getAssetId().getId())%>' />
	</render:callelement>
	
	<!-- Based on 'd', load the appropriate site plan -->
	<device:siteplan output="curSitePlanId" />
	<asset:load name="currentPage" type="Page" objectid='<%=String.valueOf(assetData.getAssetId().getId())%>' />
	<asset:getsitenode name="currentPage" output="pageNodeId" />
	<siteplan:load name="siteplanNode" nodeid='<%= ics.GetVar("pageNodeId")%>' />
	<siteplan:nodepath name="siteplanNode" list="pathList" />
	<ics:listloop listname="pathList">
		<ics:listget listname="pathList" fieldname="oid" output="_oid" />
		<%
			if(ics.GetVar("curSitePlanId").equalsIgnoreCase(ics.GetVar("_oid")))
			{
				found = true;
				%>
					<a href="<ics:getvar name="pageUrl" />"><%=attrData.getData() %></a> 
				<%
				// in case more there is more than 1 page tied to the parent category
			}
		%>
	</ics:listloop>
<%
}
if (!found) {
	// link back to home
	%>
	<render:callelement elementname="avisports/Page/GetHomeLink" />
	<%
}
%>
</cs:ftcs>
