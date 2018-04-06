<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%//
// OpenMarket/Xcelerate/PrologActions/Publish/csdt/ShareAsset
//
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
<%@ page import="com.fatwire.csdt.service.valueobject.ServiceQueryValueObject" %>
<%@ page import="com.fatwire.csdt.service.factory.CSDTServicefactory" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.fatwire.csdt.service.CSDTService" %>
<%@ page import="com.fatwire.realtime.idmapping.IdMappingFacilitator" %>
<%@ page import="com.fatwire.realtime.util.Util" %>
<%@ page import="com.fatwire.cs.core.realtime.ResourceType" %>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<cs:ftcs>

<user:login username='<%=request.getParameter("username") %>' password='<%=request.getParameter("password") %>'/>
<%
	if ( ics.GetErrno() == 0 ){
		boolean isMember = ics.UserIsMember("xceladmin");
		if ( isMember ) {
            IdMappingFacilitator idMapper = new IdMappingFacilitator();
            AssetId assetid = (AssetId)idMapper.getLocalIdForUid(Util.getContext(ics), request.getParameter("uid"), ResourceType.ASSETDATA, request.getParameter("assettype"));
            if (null!=assetid) {
%>
                <asset:load type='<%=assetid.getType()%>' objectid='<%=String.valueOf(assetid.getId())%>' name="theCurrentAsset" editable="true"/>
                <asset:share name="theCurrentAsset" publist='<%=request.getParameter("publist")%>'/>
                <asset:save name="theCurrentAsset"/>
<%
			    if ( ics.GetErrno() != 0 ){
%>
				    Save Error:<%=ics.GetErrno() %>
<%
                } else {
				    ServiceQueryValueObject valueObject = new ServiceQueryValueObject();
%>
					<assetid><%=assetid.getType()%>:<%=String.valueOf(assetid.getId())%></assetid>
                    Success
<%
			    }
            } else {
%>
                Save Error:Asset does not exist on system
<%                    
            }
        } else {
%>
		    Insufficient Privileges
<%
		}
	} else {
%>
		Login Error:<%=ics.GetErrno() %>
<%
	}
%>
</cs:ftcs>