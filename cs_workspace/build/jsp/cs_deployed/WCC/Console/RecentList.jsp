<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   com.fatwire.cs.core.db.PreparedStmt,
                   com.fatwire.cs.core.db.StatementParam,
                   oracle.stellent.ucm.poller.*,
                   oracle.stellent.ucm.poller.record.*,
                   oracle.wcs.util.*,
                   java.text.*,
                   java.util.*"
%>
<cs:ftcs><%--

INPUT        

OUTPUT 

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
String cancelNow = ics.GetVar("cancelNow");
List<String> stable = Collections.singletonList(Constants.SignalTable);
if (cancelNow != null && cancelNow.length() > 0) {
    PreparedStmt stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE id = 1 AND signal = 'running'", Constants.SignalTable), stable);
    IList resultList = ics.SQL (stmt, null, false);

    if (resultList != null && resultList.numRows() > 0) {
        stmt = new PreparedStmt (String.format ("UPDATE %s SET signal = 'stop' WHERE id = 1 AND signal = 'running'", Constants.SignalTable), stable);
        ics.SQL (stmt, null, false);

        WccPollerRecord cancelRec = new WccPollerRecord (ics, new PollDate());
        cancelRec.setBatch(0);
        cancelRec.setWcctokenstr("n/a");
        cancelRec.setLauncher (ics.GetSSVar("_DISPLAYNAME_"));
        cancelRec.setState(WccEnum.Canceled);
        cancelRec.save();
    }
}

WcsLocale wcsLocale = new WcsLocale(ics);
Locale sessionLocale = wcsLocale.getSessionLocale();
TimeZone sessionTimeZone = wcsLocale.getSessionTimeZone();

DateFormat shortDateFmt = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.MEDIUM, sessionLocale);
shortDateFmt.setTimeZone(sessionTimeZone);

DateFormat longDateFmt = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, sessionLocale);
longDateFmt.setTimeZone(sessionTimeZone);

int number_of_record = 10;
PollDate startDate = new PollDate (-86400000L); //1000 * 60 * 60 * 24 (or one day)

PreparedStmt stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE polldate > ? ORDER BY polldate DESC", Constants.PollerTable), Collections.singletonList (Constants.PollerTable));
stmt.setElement (0, Constants.PollerTable, "polldate");
StatementParam param = stmt.newParam ();
param.setString (0, startDate.getDatabaseFormat ());
IList resultList = ics.SQL(stmt, param, false);

int totalNum = resultList == null ? 0 : resultList.numRows();

int row = 0;
    TreeMap<String, WccPollerRecord> pollerMap = new TreeMap<String, WccPollerRecord>();

for (row = 1; row <= totalNum && row <= number_of_record; row++) {
    resultList.moveTo(row);
    
    WccPollerRecord pollerRecord = new WccPollerRecord(ics,
                                                       resultList.getValue("polldate"),
                                                       resultList.getValue("launcher"),
                                                       resultList.getValue("state"),
                                                       resultList.getValue("batch"),
                                                       resultList.getValue("success"),
                                                       resultList.getValue("miss"),
                                                       resultList.getValue("error"),
                                                       resultList.getValue("wcctoken"),
                                                       resultList.getValue("progress"));

    pollerMap.put(pollerRecord.getPollDate ().getDatabaseFormat (), pollerRecord);
}
%>

<script type="text/javascript">
dojo.addOnLoad(function () {
    var parentTag;
    var inputTag;
    var alt;
    
    parentTag = dojo.byId("refresh-link");
    alt = '<xlat:stream key="UI/Forms/Refresh" escape="true" encode="false"/>';
    inputTag = new fw.ui.dijit.Button (
            {   label: alt, title: alt 
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("cancel-link");
    alt = '<xlat:stream key="dvin/UI/Cancel" escape="true" encode="false"/>';
    inputTag = new fw.ui.dijit.Button (
            {   label: alt, title: alt 
            }).placeAt(parentTag);
});

function submitForm (key, value) {
    var reqForm = dojo.create("form", {
        action : "ContentServer",
        method : "post"
    }, document.AppForm, "after");

    dojo.create("input", {
        type : "hidden",
        name : "_authkey_",
        value : "<%=session.getAttribute("_authkey_")%>"
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "pagename",
        value : "WCC/Console"
    }, reqForm);
    
    dojo.create("input", {
        type : "hidden",
        name : key,
        value : value
    }, reqForm);

    reqForm.submit();
}
</script>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
    <tr><td>
        <span class="title-text"><xlat:stream key="wcc/progress/current/title"></xlat:stream></span></td></tr>
    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<div id="token-div" class="width-outer-70">
    <a id="refresh-link" href="javascript:void(0)" onclick="submitForm('refreshConsole', 'true');"></a>
    <a id="cancel-link" href="javascript:void(0)" onclick="submitForm('cancelNow', 'true');"></a>
</div>

<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">
    <tr>
        <td></td>
        <td class="tile-dark" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td><td></td>
    </tr>
    <tr>
        <td class="tile-dark" VALIGN="top" WIDTH="1"></td>
        <td>
            <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
                <tr>
                    <td colspan="17" class="tile-highlight">
                        <IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
                </tr>
                <tr>
                    <td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/timestamp"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/launcher"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/state"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/batchsize"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/successful"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/history/col/state/miss"></xlat:stream></DIV></td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/error"></xlat:stream></DIV></td>
                    <td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td colspan="17" class="tile-dark">
                        <IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif ' /></td>
                </tr>
<%
if (totalNum == 0) {
%>
                <tr class="tile-row-normal">
                    <td></td>
                    <td colspan="12" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset">
                            <xlat:stream key="wcc/progress/noactivity"></xlat:stream>
                        </DIV></td>
                </tr>
<%
} else {
	String inspectAlt = wcsLocale.translates("dvin/Common/InspectThisItem");
    row = -1;
    for (String dbPollDate : pollerMap.descendingKeySet()) {
        row++;
        WccPollerRecord pollerRecord = pollerMap.get(dbPollDate);
        PollDate pollDate = pollerRecord.getPollDate ();

        String errorColorCnt = pollerRecord.getError () > 0 ? "color:red" : "";
        String errorColor = pollerRecord.hasError () ? "color:red" : "";
        
        String shortDateStr = pollDate.getFormattedDate (shortDateFmt);
        String longDateStr = pollDate.getFormattedDate (longDateFmt);

        if (row != 0) {
%>
                <tr>
                    <td colspan="17" class="light-line-color">
                        <img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
                </tr>
<%
        }
%>
                <tr class='<%=row % 2 == 0 ? "tile-row-normal" : "tile-row-highlight"%>'>
                    <td></td>
                    <td VALIGN="bottom">
<%
		if (pollerRecord.getBatch () == 0L) {
%>		                    
						&nbsp;
<%
		} else {
%>						
                        <a title="<%=inspectAlt%>" href="ContentServer?pagename=WCC/HistoryDetail&backpage=WCC/Console&polldate=<%=pollDate.getDatabaseFormat ()%>&screendate=<%=longDateStr%>">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContent.gif"  border="0"/>
                        </a></td>
<%
		}
%>                        
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV title="<%=longDateStr%>" class="small-text-inset"><%=shortDateStr%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset"><%=pollerRecord.getI18nLauncher (wcsLocale)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset" style="<%=errorColor%>"><%=pollerRecord.getState ().getI18nName(wcsLocale)%></DIV></td>
                    <td></td>
<%
        if (pollerRecord.getState ().isDone () && pollerRecord.getBatch () == 0L) {
            String message = "";
            if (pollerRecord.getState () == WccEnum.Reset) {
                message = wcsLocale.translates("wcc/pdb/poller/tokenreset");
            } else if (pollerRecord.getState () == WccEnum.Finished) {
                message = wcsLocale.translates("wcc/pdb/poller/noupdates");
            }
%>
                    <td colspan="7" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset"><%=message%></DIV>
<%
        } else {
%>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset"><%=pollerRecord.getBatch ()%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset"><%=pollerRecord.getSuccess (false)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset"><%=pollerRecord.getMiss (false)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset" style="<%=errorColorCnt%>"><%=pollerRecord.getError (false)%></DIV></td>
<%
        }
%>
                    <td></td>
                </tr>
<% if (pollerRecord.hasProgress() && pollerRecord.hasError()) { %>
                    <tr class='<%=row % 2 == 0 ? "tile-row-normal" : "tile-row-highlight"%>'>
                        <td colspan="7"></td>
                        <td colspan="10" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset" style="<%=errorColor%>"><%=pollerRecord.getI18nFullProgress (wcsLocale)%></DIV></td>
                    </tr>
<% } %>

<%
    }
}
%>
            </table></td>
        <td class="tile-dark" VALIGN="top" WIDTH="1"></td>
    </tr>
    <tr>
        <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
    </tr>
    <tr>
        <td></td>
        <td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'>
            <IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
        <td></td>
    </tr>
</table>

</cs:ftcs>
