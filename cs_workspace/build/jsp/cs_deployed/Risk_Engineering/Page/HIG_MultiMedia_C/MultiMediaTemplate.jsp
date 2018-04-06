<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
<%
	String assetId = ics.GetVar("cid");
	String assetType = ics.GetVar("c");
	ics.ClearErrno();
	if(assetId != null && assetType != null){
 %>
 		<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ"> 
			<ics:argument name="assetId" value='<%=assetId %>'/>
			<ics:argument name="assetType" value='<%=assetType %>'/>
		</ics:callelement>
<%
		int errorNo = ics.GetErrno();
		out.println("Error : "+errorNo);
	}
 %>

</cs:ftcs>