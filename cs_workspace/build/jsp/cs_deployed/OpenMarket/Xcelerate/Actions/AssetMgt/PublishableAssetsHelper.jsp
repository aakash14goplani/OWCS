<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/PublishableAssetsHelper
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
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<cs:ftcs>
<%if("removeFromSearchList".equals(ics.GetVar("pubAssetsAction"))){
	List<AssetId> searchResultsList = (List<AssetId>)session.getAttribute("SearchAssets:" + ics.GetVar("target"));
	long id = Long.parseLong(ics.GetVar("id"));
	if(searchResultsList != null){
		for (AssetId assetId : searchResultsList)
        {
            if (id == (assetId.getId()))
            {
                searchResultsList.remove(assetId);
				break;
            }
        }
	}
} else if("setDepMapInICS".equals(ics.GetVar("pubAssetsAction"))){
	HashMap<String,List> odMap = (HashMap)session.getAttribute("ODQueue:" + ics.GetVar("target"));
	if(odMap != null){
		ics.SetObj("ODQueue:" + ics.GetVar("target"),odMap);
		ics.SetVar("ODQueue:Length",odMap.size());
	} else {
		ics.SetVar("ODQueue:Length",0);
	}
} else if("setSearchListInICS".equals(ics.GetVar("pubAssetsAction"))){
	List<AssetId> searchResultsList = (List<AssetId>)session.getAttribute("SearchAssets:" + ics.GetVar("target"));
	if(searchResultsList != null){
		ics.SetObj("SearchAssets:" + ics.GetVar("target"),searchResultsList);
		ics.SetVar("SearchAssets:Length",searchResultsList.size());
	} else {
		ics.SetVar("SearchAssets:Length",0);
	}
} else if("checkDependency".equals(ics.GetVar("pubAssetsAction"))){
if("true".equals(ics.GetVar("hasDep:" + ics.GetVar("assetid")))){%>
<tr><td colspan="3"></td><td colspan="16"><div class="ODPanel" id="dep:<%=ics.GetVar("assetid")%>"></div></td><td></td></tr>
<%}else{%>
<tr><td colspan="20"></td></tr>
<%}
}%>
</cs:ftcs>