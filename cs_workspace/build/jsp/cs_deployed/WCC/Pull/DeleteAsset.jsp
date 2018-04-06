<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>

<%@ page import="oracle.stellent.ucm.poller.Constants" %>
<%@ page import="oracle.stellent.ucm.poller.FileBasedProps" %>
<%@ page import="oracle.stellent.ucm.poller.Poller" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccBatchRecord" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccEnum" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccOrphanRecord" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccPollerRecord" %>
<%@ page import="oracle.wcs.util.PollDate" %>
<%@ page import="com.fatwire.assetapi.data.AssetDataManager" %>
<%@ page import="com.fatwire.assetapi.data.AssetDataManagerImpl" %>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<%@ page import="com.fatwire.cs.core.db.PreparedStmt" %>
<%@ page import="com.fatwire.cs.core.search.data.ResultRow" %>
<%@ page import="com.fatwire.search.util.LogPropertyDescriptions" %>
<%@ page import="com.fatwire.services.SearchService" %>
<%@ page import="com.fatwire.services.ServicesManager" %>
<%@ page import="com.fatwire.system.Session" %>
<%@ page import="com.fatwire.system.SessionFactory" %>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>

<cs:ftcs>
<%--
INPUT
OUTPUT
--%> 

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" /></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" /></ics:then></ics:if>

	<%
        Log wccLog = (Log)ics.GetObj("wccLog");
        if (wccLog == null) {
            wccLog = LogFactory.getLog (LogPropertyDescriptions.LOG_NAME);
        }

try {

    ics.CallElement("WCC/Util/LoadIntegrationIni", null); 
    FileBasedProps wccProps = (FileBasedProps) ics.GetObj ("wcc.integration.ini");
	String dDocNameField = wccProps.getProperty (Constants.KeyField);

	WccBatchRecord batchRec = (WccBatchRecord) ics.GetObj ("wcc.batchRecord");
	WccPollerRecord pollerRec = (WccPollerRecord) ics.GetObj ("wcc.pollerRecord");
	String dDocName = batchRec.getDDocName();
    long wcctoken = batchRec.getWcctoken ();
    PollDate polldate = batchRec.getPollDate ();

	//Search setup
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();
	AssetDataManager adm = new AssetDataManagerImpl(ics);
	
	//keep track of what happens in our loops so we can mark the batchRecord page later
	boolean hasErrorBeenDetected = false;
	boolean hasDeleteActionHappened = false;
	boolean isPresent = false;
	
	//Loop through all possible sites
    PreparedStmt stmt = new PreparedStmt ("SELECT name, id FROM Publication", Collections.singletonList ("Publication"));
    IList sqlResult = ics.SQL(stmt, null, false);

	for (int sqlrow = 1; sqlrow <= sqlResult.numRows(); sqlrow++) {
	    sqlResult.moveTo(sqlrow);
	    long siteId = Long.parseLong(sqlResult.getValue("id"));
	    String siteName = sqlResult.getValue("name");
	    
	    //Now, do a search on the selected site
		List<ResultRow> searchResults = null;
		searchResults = searchService.search(siteId, dDocName, "EQUALS", null, dDocNameField, -1, null);

		//For all the matches found, perform a delete action
		for (ResultRow row : searchResults) {
			isPresent = true;
			String assetType = row.getIndexData("AssetType").getData();
			long assetId = Long.parseLong(row.getIndexData("id").getData());

			//Delete
			try {
				AssetId assetToDelete = new AssetIdImpl (assetType, assetId);
				adm.delete(Collections.singletonList(assetToDelete));
				hasDeleteActionHappened = true;
				
				batchRec.setAssetid (assetId);
				batchRec.addRemarkProgress ("wcc/pdb/poller/assetdeletedfromsite", Long.toString (assetId), siteName);
                batchRec.save ();
	        } catch (Exception e) {
	            batchRec.setAssetid (assetId);
	            batchRec.addRemarkProgress ("wcc/pdb/poller/assetdeletefailed", Long.toString (assetId), siteName, e.getMessage ());
                batchRec.save ();
                WccOrphanRecord orphanRecord = new WccOrphanRecord (ics, polldate);
                orphanRecord.setAssetid (assetId);
                orphanRecord.setAssetType (assetType);
                orphanRecord.setWcctoken (wcctoken);
                orphanRecord.setDDocName (dDocName);
                orphanRecord.addRemarkProgress ("wcc/pdb/poller/assetorphaned", e.getClass().getName(), e.getMessage ());
                orphanRecord.addProgressStackTrace(e);
	            orphanRecord.save();
	            hasErrorBeenDetected = true;
	        }

			} //End of search on selected site
		} //End of loop through all possible sites

	if (!isPresent) { 
		batchRec.setStatus (WccEnum.NotPresent);
		batchRec.addRemarkProgress ("wcc/pdb/poller/assetnotfound");
        batchRec.save ();
	} else if (hasErrorBeenDetected) {
		batchRec.setStatus (WccEnum.Error);
        batchRec.save ();
	} else if (hasDeleteActionHappened) {
		batchRec.setStatus (WccEnum.Deleted);
		batchRec.addRemarkProgress ("wcc/pdb/poller/assetdeleted");
        batchRec.save ();
	} else {
		//No additional progress to report
	}

} catch (Exception t) {
    wccLog.info (Poller.getStackTrace (t));
    throw (t);
}

%>


</cs:ftcs>
