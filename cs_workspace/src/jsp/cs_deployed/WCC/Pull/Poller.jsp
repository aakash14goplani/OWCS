<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>

<%@ page import="oracle.stellent.ucm.poller.Constants" %>
<%@ page import="oracle.stellent.ucm.poller.FileBasedProps" %>
<%@ page import="oracle.stellent.ucm.poller.Poller" %>
<%@ page import="oracle.stellent.ucm.poller.WccQueueWorker" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccEnum" %>
<%@ page import="oracle.stellent.ucm.poller.record.WccPollerRecord" %>
<%@ page import="oracle.wcs.util.LogPropertyDescriptions" %>
<%@ page import="oracle.wcs.util.PollDate" %>
<%@ page import="oracle.wcs.util.WorkTime" %>
<%@ page import="oracle.wcs.util.WorkTimePerDoc" %>
<%@ page import="com.fatwire.cs.core.db.PreparedStmt" %>
<%@ page import="com.openmarket.xcelerate.util.XcelProperties" %>
<%@ page import="org.apache.commons.logging.Log" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Util.ftMessage" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>

<%!
private String formatMillis (long millis) {
    int ms = (int)(millis % 1000);
    int s = (int)(millis / 1000);
    int h = 0, m = 0;
    if (s > 59) {
        m = s / 60;
        s = s % 60;
        if (m > 59) {
            h = m / 60;
            m = m % 60;
        }
    }
    return String.format("%d Hour %2d Min %2d Sec %3d ms", h, m, s, ms);
}

private void printDeleteTimeList (Log wccLog, List<WorkTimePerDoc> docTimeList) throws IOException {
    for (WorkTimePerDoc docTime : docTimeList) {
    	wccLog.debug(docTime.getAction() + String.format(", %,3d ms, ", docTime.totalTime.getTotalMillis()) + docTime.getDDocName());
    }
}

private void printUpdateTimeList (Log wccLog, List<WorkTimePerDoc> docTimeList) throws IOException {
    for (WorkTimePerDoc docTime : docTimeList) {
    	wccLog.debug(docTime.getAction()
                    + String.format("%,7d KB zip size", docTime.getZippedSizeInKb())
                    + String.format("%,13d ms total", docTime.totalTime.getTotalMillis())
                    + String.format("%,11d ms %2d%% download", docTime.downloadTime.getTotalMillis(), docTime.downloadTime.getTotalMillis() * 100 / docTime.totalTime.getTotalMillis())
                    + String.format("%,11d ms %2d%% unzip", docTime.unzipTime.getTotalMillis(), docTime.unzipTime.getTotalMillis() * 100 / docTime.totalTime.getTotalMillis())
                    + String.format("%,11d ms %2d%% AssetAPI", docTime.assetTime.getTotalMillis(), docTime.assetTime.getTotalMillis() * 100 / docTime.totalTime.getTotalMillis())
                    + String.format("%,11d ms %2d%% database", docTime.dbTime.getTotalMillis(), docTime.dbTime.getTotalMillis() * 100 / docTime.totalTime.getTotalMillis())
                    + "      "
                    + String.format("other %2d%%", (docTime.totalTime.getTotalMillis() 
                                                     - docTime.downloadTime.getTotalMillis()
                                                     - docTime.unzipTime.getTotalMillis()
                                                     - docTime.assetTime.getTotalMillis()
                                                     - docTime.dbTime.getTotalMillis()
                                                   ) * 100 / docTime.totalTime.getTotalMillis())
                    + "      " + docTime.getDDocName()
                );
    }
}
%>

<cs:ftcs>
<%--
INPUT
OUTPUT
--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
ics.SetObj ("wccLog", LogFactory.getLog(LogPropertyDescriptions.LOG_NAME));
Log wccLog = (Log)ics.GetObj("wccLog");

WorkTime totalPollingTime = new WorkTime("total-polling");
WorkTime ucmSyncUpTime = new WorkTime("ucm-sync-up");

totalPollingTime.start();

try {

String batchuser = XcelProperties.getProperty (ics, XcelProperties.BATCHUSER);
String batchpass = XcelProperties.getProperty (ics, XcelProperties.BATCHPASS);

FTValList ftvalList = new FTValList ();
ftvalList.put (ftMessage.verb, ftMessage.login);
ftvalList.put (ftMessage.username, batchuser);
ftvalList.put (ftMessage.password, batchpass);

ics.CatalogManager (ftvalList);

PreparedStmt stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE id = 1", Constants.SignalTable), Collections.singletonList (Constants.SignalTable));
IList resultList = ics.SQL (stmt, null, false);

if (resultList != null && resultList.numRows() > 0) {
    stmt = new PreparedStmt (String.format ("UPDATE %s SET signal = 'running' WHERE id = 1", Constants.SignalTable), Collections.singletonList (Constants.SignalTable));
    ics.SQL (stmt, null, false);
} else {
    stmt = new PreparedStmt (String.format ("INSERT INTO %s (id, signal) VALUES (1, 'running'", Constants.SignalTable), Collections.singletonList (Constants.SignalTable));
    ics.SQL (stmt, null, false);
}

ics.CallElement("WCC/Rule/ParseRuleFiles", null);
ics.CallElement("WCC/Rule/RetrieveFieldDef", null);

ics.CallElement("WCC/Util/LoadTokenIni", null);
FileBasedProps tokenProps = (FileBasedProps) ics.GetObj ("wcc.token.ini");

ics.CallElement("WCC/Util/LoadIntegrationIni", null);

// Poller parameters
String token = ics.GetVar ("runWithToken");
if (token == null || token.isEmpty ()) {
    token = tokenProps.getProperty (Constants.QueueToken);
} else if (token.equals("use-empty-token")) {
    token = "";
}

if (ics.GetVar ("pollLauncher") == null) {
    ics.SetVar("pollLauncher", "auto");
}

PollDate pollDate = null;
if (ics.GetVar ("pollStamp") == null || ics.GetVar ("pollStamp").isEmpty()) {
    pollDate = new PollDate ();
} else {
    pollDate = new PollDate (ics.GetVar ("pollStamp"));
    ics.SetVar("pollStamp", "");
}
    
WccQueueWorker queueWorker = new WccQueueWorker (ics, out);
WccPollerRecord pollerRec;

try {
    while (true) {
        ucmSyncUpTime.start();
        queueWorker.callWccQueueSync(pollDate, token);
        ucmSyncUpTime.stop();
        
        pollerRec = queueWorker.getPollerRec();
        
        //Check to make sure we are using the correct queue token
        if (queueWorker.isReset ()) {
            pollerRec.setWcctokenstr(queueWorker.getNextToken());
            pollerRec.setState(WccEnum.Reset);
            pollerRec.save();
        } else {
            pollerRec.setWcctokenstr(queueWorker.getNextToken());
            pollerRec.addRemarkProgress("wcc/pdb/poller/tokengood", token, queueWorker.getNextToken());
            pollerRec.save();

            List<WorkTimePerDoc> timeList;
            
            timeList = queueWorker.deleteDocs  ("WCC/Pull/DeleteAsset");
            if (wccLog.isDebugEnabled()) {
                printDeleteTimeList(wccLog, timeList);
            }
            
            timeList = queueWorker.checkinDocs ("WCC/Pull/CreateAsset");
            if (wccLog.isDebugEnabled()) {
                printUpdateTimeList(wccLog, timeList);
            }

            pollerRec.setState(WccEnum.Finished);
            pollerRec.save();
        }

        pollDate = new PollDate();

        //Save token for next time
        token = queueWorker.getNextToken();
        tokenProps.setProperty (Constants.QueueToken, token);
        tokenProps.save ();

        if (!queueWorker.isMoreAvailable()) {
            break;
        }

        stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE id = 1 AND signal = 'stop'", Constants.SignalTable), Collections.singletonList (Constants.SignalTable));
        resultList = ics.SQL (stmt, null, false);
        if (resultList != null && resultList.numRows() == 1) {
            break;
        }

        pollerRec.addProgress ("|!|", String.format ("Poller complete for id %s", queueWorker.getPollStamp ().getAsID ()));
    }
} catch (Exception e) {
    pollerRec = queueWorker.getPollerRec();
    pollerRec.setState(WccEnum.Error);
    pollerRec.addRemarkProgress ("wcc/pdb/common/exception/message", e.getMessage ());
    pollerRec.addProgressStackTrace (e);
    pollerRec.save ();
}

pollerRec.addProgress ("|!|", String.format ("Poller complete for id %s", queueWorker.getPollStamp ().getAsID ()));

stmt = new PreparedStmt (String.format ("UPDATE %s SET signal = 'idle' WHERE id = 1", Constants.SignalTable), Collections.singletonList (Constants.SignalTable));
ics.SQL (stmt, null, false);

} catch (Exception t) {
	wccLog.info (Poller.getStackTrace (t));
    throw (t);
} finally {
    totalPollingTime.stop();
    if (wccLog.isDebugEnabled()) {
        wccLog.debug("");
        wccLog.debug("Total time of the polling: " + formatMillis(totalPollingTime.getTotalMillis()));
        wccLog.debug("Time of all sync up calls: " + formatMillis(ucmSyncUpTime.getTotalMillis()));
    }
}
%>

</cs:ftcs>
