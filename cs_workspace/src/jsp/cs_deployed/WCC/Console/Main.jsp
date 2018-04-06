<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="oracle.stellent.ucm.poller.Constants,
                   oracle.stellent.ucm.poller.FileBasedProps,
                   oracle.stellent.ucm.poller.record.WccEnum,
                   oracle.wcs.matching.GroupMatcher,
                   oracle.wcs.util.PollDate,
                   oracle.wcs.util.WcsLocale,
                   com.fatwire.cs.core.db.PreparedStmt,
                   com.fatwire.cs.core.db.StatementParam,
                   com.openmarket.Batch.Client,
                   com.openmarket.Batch.IClient,
                   com.openmarket.Batch.RequestItem,
                   com.openmarket.xcelerate.util.XcelProperties,
                   COM.FutureTense.Interfaces.FTValList,
                   COM.FutureTense.Interfaces.ICS,
                   COM.FutureTense.Util.ftMessage,
                   java.util.Collections,
                   java.util.List,
                   java.util.Map"
%>
<%!
private String nonNull (String value) {
    if (value == null) {
        return "";
    } else {
        return value.trim();
    }
}

private boolean hasValidRule (ICS ics) {
    ics.CallElement("WCC/Rule/ParseRuleFiles", null);
    Map<String, GroupMatcher> groupMatcherMap = (Map<String, GroupMatcher>) ics.GetObj ("wcc.groupMatcherMap");
	
    for (GroupMatcher groupMatcher : groupMatcherMap.values()) {
    	if (groupMatcher.isEnabled() && groupMatcher.getGroupMapper() != null) {
    		return true;
    	}
    }
    
    return false;
}
 
private boolean submitBatch (ICS ics, String runWithToken) {
    IClient client;
    
    String batchhost = XcelProperties.getProperty(ics, XcelProperties.BATCHHOST);
    if (batchhost == null || batchhost.length() == 0) {
        client = Client.getClient(ics);
        client.initClient(null, null, null, IClient.PAGE);
    } else {
        String batchuser = XcelProperties.getProperty(ics, XcelProperties.BATCHUSER);
        String batchpass = XcelProperties.getProperty(ics, XcelProperties.BATCHPASS);
        String batchProtocol = XcelProperties.getProperty(ics, XcelProperties.BATCHPROTOCOL);
        String zone = ics.GetProperty(ftMessage.cgipath);
        if (zone.startsWith("/")) {
            zone = zone.substring(1);
        }
        if (zone.endsWith("/")) {
            zone = zone.substring(0, zone.length() - 1);
        }

        client = Client.getClient(null);
        client.initClient(batchhost, batchuser, batchpass, IClient.PAGE, false, zone, batchProtocol);
    }

    String jobName = "WccConsole";
    
    List<RequestItem> jobList = (List<RequestItem>) client.getList();
    if (jobList != null && jobList.size() > 0) {
        for (RequestItem job : jobList) {
            if (jobName.equals(job.getKey())) {
                return false;
            }
        }
    }

    String pollDateDbFormat = new PollDate ().getDatabaseFormat ();
    String launcherName = ics.GetSSVar("_DISPLAYNAME_");

    PreparedStmt stmt = new PreparedStmt (
            String.format("INSERT INTO %s (id, polldate, launcher, state, wcctoken) VALUES (?, ?, ?, ?,'n/a')",  Constants.PollerTable),
            Collections.singletonList (Constants.PollerTable));
    stmt.setElement (0, Constants.PollerTable, "id");
    stmt.setElement (1, Constants.PollerTable, "polldate");
    stmt.setElement (2, Constants.PollerTable, "launcher");
    stmt.setElement (3, Constants.PollerTable, "state");

    StatementParam param = stmt.newParam ();
    param.setLong   (0, Long.parseLong (ics.genID(false)));
    param.setString (1, pollDateDbFormat);
    param.setString (2, launcherName);
    param.setString (3, WccEnum.Submitted.getEnumName ());

    ics.SQL (stmt, param, false);

    FTValList paramList = new FTValList();
    paramList.setValString("runWithToken", runWithToken);
    paramList.setValString("pollStamp", pollDateDbFormat);
    paramList.setValString("pollLauncher", launcherName);

    return client.dispatch("WCC/Pull", jobName, paramList, null);
}
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
String errorMsg = null;
String infoMsg = null;

String runWithToken = ics.GetVar("runWithToken");
if (runWithToken != null && runWithToken.length() > 0) {
	try {
        WcsLocale wcsLocale = new WcsLocale(ics);
        
	    if (hasValidRule(ics)) {
	    	if (submitBatch(ics, runWithToken)) {
	            infoMsg = wcsLocale.translates("wcc/history/col/state/submitted");
	    	} else {
	            errorMsg = wcsLocale.translates("wcc/console/message/pollerrunning");
	    	}
	    } else {
	    	errorMsg = wcsLocale.translates("wcc/console/message/novalidrulefound");
	    }
	} catch (Exception e) {
		errorMsg = e.toString();
	}
}

ics.CallElement("WCC/Util/LoadTokenIni", null);
FileBasedProps tokenProps = (FileBasedProps) ics.GetObj ("wcc.token.ini");

String nextToken = tokenProps.getProperty(Constants.QueueToken);

ics.CallElement("WCC/Util/LoadIntegrationIni", null);
FileBasedProps wccProps = (FileBasedProps) ics.GetObj ("wcc.integration.ini");

String serverUrl = nonNull(wccProps.getProperty(Constants.ServerUrl));
String serverUser = nonNull(wccProps.getProperty(Constants.ServerUser));
%>

<script type="text/javascript">
dojo.addOnLoad(function () {
    var parentTag;
    var inputTag;
    var alt;
    
    parentTag = dojo.byId("run-link");
    alt = '<xlat:stream key="wcc/console/button/runpoller" escape="true" encode="false"/>';
    inputTag = new fw.ui.dijit.Button (
            {   label: alt, title: alt
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("token-div");
    inputTag = new fw.dijit.UIInput (
            {   id: "token-text", type: "text", style: "width: 20em;", value: "<%=nextToken%>"
            }).placeAt(parentTag);
			
    dojo.connect(document.AppForm, 'onsubmit', function(evt) {
         dojo.stopEvent(evt);
         submitRunForm();
        return false;
    });
});

function submitRunForm() {
    var token = dojo.trim(dijit.byId("token-text").value);
    if (!token) {
        token = "use-empty-token";
    }

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
        name : "runWithToken",
        value : token
    }, reqForm);

    reqForm.submit();
}

function closeMsg() {
    dojo.destroy("msg-tag");
}
</script>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
<%
if (errorMsg != null || infoMsg != null) {
%>
    <tr id="msg-tag"><td>
        <div class="message-<%=errorMsg != null ? "error" : "info"%>">
            <img class="icon-img" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/msg/<%=errorMsg != null ? "error.png" : "info.png"%>'>
            <div class="msg-txt">
                <%=errorMsg != null ? errorMsg : infoMsg%>
            </div>
            <div class="right close-img" onclick="closeMsg();"></div>
        </div>
    </td></tr>
<%
}
%>
    <tr><td><span class="title-text">
        <xlat:stream key="wcc/console/title/long"/>
    </span></td></tr>
    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<table id="param-table" class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
    <tr class="tile-row-normal">
        <td class="form-label-text"><xlat:stream key="wcc/console/label/server/url"/>:</td>
        <td><%=serverUrl%></td>
    </tr>
    <tr class="tile-row-normal">
        <td class="form-label-text"><xlat:stream key="wcc/console/label/server/user"/>:</td>
        <td><%=serverUser%></td>
    </tr>
</table>

<div id="token-div" class="width-outer-70">
    <a id="run-link" href="javascript:void(0)" onclick="submitRunForm();"></a>
</div>

<br/><br/>

<ics:callelement element="WCC/Console/RecentList"></ics:callelement>

</cs:ftcs>
