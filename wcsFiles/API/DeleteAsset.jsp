<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
<%
	try{
		Session sessionFactory = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionFactory.getManager(AssetDataManager.class.getName());
		String assetType = "Article_C", assetId = "1374098706334";
        assetDataManager.delete(Arrays.<AssetId>asList( new AssetIdImpl(assetType, Long.valueOf(assetId)))); 
	}
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage() + "<br/>" + e);
	}
 %>
</cs:ftcs>