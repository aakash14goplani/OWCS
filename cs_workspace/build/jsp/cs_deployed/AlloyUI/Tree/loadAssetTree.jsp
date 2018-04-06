<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// AlloyUI/Tree/loadAssetTree
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
<cs:ftcs>
<%
	// This element is invoked through URL connection. The session is set to the URL connection when this element is invoked.
	// So no need to pass username , pubid,password
	ics.SetSSVar("pubid",ics.GetVar("pubid"));
	ics.SetSSVar("username",ics.GetVar("username"));


    if(ics.GetVar("populateUrl") != null && ics.GetVar("AssetType") != null && ics.GetVar("op") != null && ics.GetVar("id") != null )
	{
%>
		<ics:callelement element='<%=ics.GetVar("populateUrl")%>'> 
		<!--ics:callelement element="OpenMarket/Xcelerate/AssetType/Document_C/LoadTree"-->
				<ics:argument name = "AssetType" value ='<%=ics.GetVar("AssetType")%>'/>
				<ics:argument name = "op" value ='<%=ics.GetVar("op")%>'/>
				<ics:argument name = "id" value ='<%=ics.GetVar("id")%>'/>
				<ics:argument name = "dashUI" value ='true'/>
        </ics:callelement>

<%
	}//end of if(ics.GetVar(""....
%>
</cs:ftcs>
