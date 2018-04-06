<%@	taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Random"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.DataInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="com.fatwire.realtime.messaging.PubsessionStatusFacade"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<%@ page import="COM.FutureTense.Common.ContentServerException"%>
<cs:ftcs>
<%
/*check that the user is still logged in */
if(ics.UserIsMember("xceleditor")){
	String _action = ics.GetVar("action");
	String _pubSessionID = ics.GetVar("pubSessionID");
	PubsessionStatusFacade f = null;
	String _jsonResp= null;
	/*If stored in session the PubsessionStatusFacade nullifies the ftapplogic which results in 
	null pointer exception so here we are instantiating it everytime the request is received.*/
	f = new PubsessionStatusFacade(ics);
	if(_pubSessionID != null) {
		if(_action.equals("getProgressStatus")){
			_jsonResp=f.getPubsessionStatus(_pubSessionID);
		} else if(_action.equals("getLogData")){
			int _rowsPerPage = Integer.parseInt(ics.GetVar("rowsPerPage"));
			int _displayPage = Integer.parseInt(ics.GetVar("displayPage"));
			String _status = ics.GetVar("status");
			String _search = ics.GetVar("search");
			int count = 0;
			String _jsonTempResp ="";
			if(_search == null || _search.equals("null")){
				_jsonResp = f.getPubsessionHistory(_pubSessionID,_status,null,_rowsPerPage,_displayPage);
			} else {
				_jsonResp = f.getPubsessionHistory(_pubSessionID,_status,_search,_rowsPerPage,_displayPage);
			}
		} else if(_action.equals("cancelSession")){
			f.cancel(_pubSessionID);
		} else if(_action.equals("cancelDelayedSession")){
			f.cancelDelayed(_pubSessionID);
		} else if(_action.equals("restartSession")){
			_jsonResp = f.restart(_pubSessionID,true);
		} else if(_action.equals("resumeSession")){
			_jsonResp = f.resume(_pubSessionID);
		} else if(_action.equals("downloadLog")){
			_jsonResp = f.dumpPubsessionHistoryAsBlob(_pubSessionID);
		}
		if(_jsonResp != null){
			out.write(_jsonResp);
		}
	} else if(_action != null) {
		if(_action.equals("getDependentAssets")){
			String assetIds = ics.GetVar("assetIds");
			String target = ics.GetVar("target");
			LinkedHashMap<String,List<AssetId>> odMap = (LinkedHashMap<String,List<AssetId>>)session.getAttribute("ODQueue:" + target);
			if(odMap == null){
				odMap = new LinkedHashMap<String,List<AssetId>>();
				session.setAttribute("ODQueue:" + target,odMap);
			} 
			_jsonResp = f.getPublishableAssetGroups(target,assetIds,true,odMap);
			out.write(_jsonResp);
		} else if(_action.equals("removeFromSession")){
			String assetIds = ics.GetVar("assetIds");
			String target = ics.GetVar("target");
			LinkedHashMap<String,List<AssetId>> odMap = (LinkedHashMap<String,List<AssetId>>)session.getAttribute("ODQueue:" + target);
			if(odMap != null){
				String[] assetIdArray = assetIds.split(";");
				for(String assetId : assetIdArray)
				odMap.remove(assetId);
			}
		} else if(_action.equals("getPubTargetStatus")){
			String target = ics.GetVar("target");
			_jsonResp = f.testConnection(target);
			out.write(_jsonResp);
		} else if(_action.equals("populateSearchedAssets")){
			String target = ics.GetVar("target");
			String matchThis = ics.GetVar("matchThis");
			List<AssetId> assetIds = f.getMatchingPubkeys(target,matchThis);
			session.setAttribute("SearchAssets:" + target,assetIds);
		}
	} 
} else {
	//Set header that the login is invalid.
    ics.StreamHeader("userAuth","false");
}
%>
</cs:ftcs>