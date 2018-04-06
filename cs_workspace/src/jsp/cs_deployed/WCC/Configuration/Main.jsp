<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="oracle.stellent.ucm.poller.*,
                   oracle.wcs.util.WcsLocale,
                   java.io.*,
                   java.util.*,
                   oracle.stellent.ridc.model.*"
%><%!
private String nonNull (String value) {
    if (value == null) {
        return "";
    } else {
        return value.trim();
    }
}

private boolean xssCharFound (String value) {
    if (value != null) {
        for (int i = 0; i < value.length (); i++) {
            char ch = value.charAt (i);
            if (ch == '\'' || ch == '"' || ch == '<' || ch == '>') {
                return true;
            }
        }
    }
    return false;
}

private void removePrefixed (FileBasedProps wccProps, String prefix) {
	ArrayList<Object> keyList = new ArrayList<Object>(wccProps.keySet());
	for (Object key : keyList) {
		if (key.toString().startsWith(prefix)) {
			wccProps.remove(key);
		}
	}
}

private String getFriendlyMessage (WcsLocale wcsLocale, String errorMessage, String url) {
	if (url.startsWith("idc")) {
        if (errorMessage == null) {
            return wcsLocale.translates("wcc/config/test/InvalidHost");
        } else if (errorMessage.contains("Unable to initialize connection")) {
			return wcsLocale.translates("wcc/config/test/InvalidHostOrPort");
		} else if (errorMessage.contains("Expected SIRunTime value")) {
			return wcsLocale.translates("wcc/config/test/InvalidIdcPort");
		} else if (errorMessage.contains("For input string")) {
			return wcsLocale.translates("wcc/config/test/InvalidPath");
        } else if (errorMessage.contains("does not have sufficient privileges")) {
            return wcsLocale.translates("wcc/config/test/InvalidUserOrPassword");
		}
	} else if (url.startsWith("http")) {
		if (errorMessage == null) {
		    return wcsLocale.translates("wcc/config/test/InvalidHost");
		} else if (errorMessage.contains("UnknownHostException")) {
            return wcsLocale.translates("wcc/config/test/InvalidHost");
        } else if (errorMessage.contains("URI does not specify a valid host name")) {
            return wcsLocale.translates("wcc/config/test/MissingHost");
        } else if (errorMessage.contains("refused")) {
            return wcsLocale.translates("wcc/config/test/InvalidPort");
        } else if (errorMessage.contains("Connection reset")) {
            return wcsLocale.translates("wcc/config/test/InvalidPort");
        } else if (errorMessage.contains("Input terminated before being able to read line")) {
            return wcsLocale.translates("wcc/config/test/InvalidPort");
        } else if (errorMessage.contains("404 Not Found")) {
            return wcsLocale.translates("wcc/config/test/InvalidPath");
        } else if (errorMessage.contains("Form validation failed")) {
            return wcsLocale.translates("wcc/config/test/InvalidUserOrPassword");
        } else if (errorMessage.contains("does not have sufficient privileges") && !url.contains("idcplg")) {
            return wcsLocale.translates("wcc/config/test/InvalidPath");
        }
	}
	return errorMessage;
}
%><cs:ftcs><%--

INPUT 

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
String KeyInSession = "encoded_ucm_user_password";
String KeyToken = "********";

WcsLocale wcsLocale = new WcsLocale(ics);

ics.CallElement("WCC/Util/LoadIntegrationIni", null);
FileBasedProps wccProps = (FileBasedProps) ics.GetObj ("wcc.integration.ini");

String errorMsg = null;
String infoMsg = null;

boolean handleRequest = false;

String action = ics.GetVar("ini.action");
String serverUrl = null, serverUser = null, rawPassword = null, encodedPwd = null;
List<String> rendNames = null;

if ("test".equals(action) || "save".equals(action)) {
    serverUrl = nonNull(ics.GetVar("ini.serverUrl"));
    serverUser = nonNull(ics.GetVar("ini.serverUser"));
    rawPassword = nonNull(ics.GetVar("ini.serverPassword"));
    rendNames = new ArrayList<String>();
    try {
        int rendCount = Integer.parseInt(ics.GetVar("ini.rendition.count"));
        for (int i = 0; i < rendCount; i++) {
            String rend = nonNull(ics.GetVar("ini.rendition." + i));
            if (rend.length() > 0 && !rendNames.contains(rend)) {
                rendNames.add(rend);
            }
        }
    } catch (Exception e) {
        // continue
    }
    
    handleRequest = !xssCharFound(serverUrl) && !xssCharFound(serverUser);
    for (int i = 0; handleRequest && i < rendNames.size(); i++) {
        handleRequest = !xssCharFound(rendNames.get(i));
    }
}

if (handleRequest) {
    removePrefixed (wccProps, Constants.RenditionPrefix);
    for (int i = 0; i < rendNames.size(); i++) {
        String rend = rendNames.get(i);
        wccProps.setProperty(Constants.RenditionPrefix + rend, rend);
    }
    
    wccProps.setProperty(Constants.ServerUrl, serverUrl);
    wccProps.setProperty(Constants.ServerUser, serverUser);
    
    if (KeyToken.equals(rawPassword)) {
    	encodedPwd = nonNull(ics.GetSSVar(KeyInSession));
        wccProps.setProperty(Constants.ServerPassword, encodedPwd);
    } else {
        wccProps.setPassword(Constants.ServerPassword, rawPassword);
    }

    if ("test".equals (action)) {
        try {
            IdcService idcService = new IdcService (ics);
            DataBinder cbinder = idcService.getConfigInfo ();
            if (Constants.ExpectedSIRunTime.equals (cbinder.getLocal ("SIRunTime"))) {
                infoMsg = wcsLocale.translates ("wcc/config/validation/testok");
                String warningMsg = cbinder.getLocal ("siWarningMessage");
                if (warningMsg != null && warningMsg.length () > 0) {
                    infoMsg += "<br/>" + warningMsg;
                }
            } else {
                errorMsg = wcsLocale.translates ("wcc/config/validation/testfailed");
            }
        } catch (Exception e) {
            errorMsg = getFriendlyMessage (wcsLocale, e.getMessage (), wccProps.getProperty (Constants.ServerUrl));
        }
    } else if ("save".equals (action)) {
        wccProps.save ();
        infoMsg = wcsLocale.translates ("wcc/config/validation/saveok");
    }
}

serverUrl  = nonNull(wccProps.getProperty(Constants.ServerUrl));
serverUser = nonNull(wccProps.getProperty(Constants.ServerUser));
encodedPwd = nonNull(wccProps.getProperty(Constants.ServerPassword));

if (encodedPwd.length() == 0) {
    ics.RemoveSSVar(KeyInSession);
} else {
	ics.SetSSVar(KeyInSession, encodedPwd);
	encodedPwd = KeyToken;
}

rendNames = new ArrayList<String>();
for (Object key : wccProps.keySet()) {
    String name = (String)key;
    if (name.startsWith(Constants.RenditionPrefix)) {
        rendNames.add(name.substring(Constants.RenditionPrefix.length()));
    }
}
if (rendNames.isEmpty()) {
    rendNames.add("primary");
    rendNames.add("web");
} else {
    Collections.sort(rendNames);
}
%>

<script type="text/javascript">
renditionCount = 0;

function addRendition (renditionName) {
    var uiTable = dojo.byId("param-table");
    
    var uiTR = dojo.create("tr", {
        id : "rendition-tr-" + renditionCount,
        'class' : "tile-row-normal"
    }, uiTable);
    
    dojo.create("td", {
    }, uiTR);
    dojo.create("td", {
    }, uiTR);

    var uiTD = dojo.create("td", {
    }, uiTR);

    var thisIndex = renditionCount;
    var inputTag = new fw.dijit.UIInput (
            {   id: "rendition-text-" + renditionCount, type: "text", style: "width: 24em;",value: renditionName
            }).placeAt(uiTD);
    inputTag.focus();

    var removeSpan = dojo.create("span", {
    }, uiTD);

    var aTag = dojo.create("a", {
        href : "javascript:removeRendition('" + renditionCount + "')"
    }, removeSpan);

    var imgTag = dojo.create("img", {
        src : "<%=ics.GetVar("cgipath")%>js/fw/images/ui/ui/search/closeIcon.png",
        title : '<xlat:stream key="dvin/Common/Delete"/>',
        border : "0",
        hspace : "2"
    }, aTag);

    renditionCount++;
}

function removeRendition (renditionIndex) {
    var rendTextWidget = dijit.byId("rendition-text-" + renditionIndex);
    rendTextWidget.destroy();
    
    var rendTR = dojo.byId("rendition-tr-" + renditionIndex);
    dojo.destroy(rendTR);
}

dojo.addOnLoad(function () {
    var parentTag;
    var inputTag;
    
    parentTag = dojo.byId("test-link");
    inputTag = new fw.ui.dijit.Button (
            {   label: '<xlat:stream key="fatwire/SystemTools/FSTest/test" escape="true" encode="false"/>',
            	title: '<xlat:stream key="wcc/config/info/testnosave" escape="true" encode="false"/>'
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("save-link");
    inputTag = new fw.ui.dijit.Button (
            {   label: '<xlat:stream key="dvin/UI/Save" escape="true" encode="false"/>',
            	title: '<xlat:stream key="wcc/config/info/savenotest" escape="true" encode="false"/>'
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("server-url-div");
    inputTag = new fw.dijit.UIInput (
            {   id: "server-url-text", type: "text", style: "width: 30em;", value: "<%=serverUrl%>"
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("server-user-div");
    inputTag = new fw.dijit.UIInput (
            {   id: "server-user-text", type: "text", style: "width: 30em;", value: "<%=serverUser%>"
            }).placeAt(parentTag);
    
    parentTag = dojo.byId("server-password-div");
    inputTag = new fw.dijit.UIInput (
            {   id: "server-password-text", type: "password", style: "width: 30em;", value: "<%=encodedPwd%>"
            }).placeAt(parentTag);
    
<%
    for (String rendName : rendNames) {
        out.println("addRendition ('" + rendName + "');");
    }
%>
});

function submitAction (action) {
    var mUrl = dojo.trim(dijit.byId("server-url-text").value);
    var mUser = dojo.trim(dijit.byId("server-user-text").value);
    var mPass = dojo.trim(dijit.byId("server-password-text").value);
    var mRNames = new Array();
    for (var i = 0; i < renditionCount; i++) {
        var rendTextWidget = dijit.byId("rendition-text-" + i);
        if (rendTextWidget) {
            var rendName = dojo.trim(rendTextWidget.value);
            if (rendName && dojo.indexOf(mRNames, rendName) == -1) {
            	mRNames.push(rendName);
            }
        }
    }
    
    if (mUrl == "") {
    	alert('<xlat:stream key="wcc/config/validation/missurl" escape="true" encode="false"/>');
    	return;
    }
    
    if (!mUrl.match(/(idc:|http:|https:)/i)) {
        alert('<xlat:stream key="wcc/config/validation/invalidprotocol" escape="true" encode="false"/>');
        return;
    }
    
    if (xssCharFound(mUrl)) {
    	var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
    	var field = '<xlat:stream key="wcc/console/label/server/url" escape="true" encode="false"/>';
    	alert(msg.replace("{0}", field));
    	return;
    }
    
    if (mUser == "") {
        alert('<xlat:stream key="wcc/config/validation/missuser" escape="true" encode="false"/>');
        return;
    }
    
    if (xssCharFound(mUser)) {
        var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
        var field = '<xlat:stream key="wcc/console/label/server/user" escape="true" encode="false"/>';
        alert(msg.replace("{0}", field));
        return;
    }
    
    if (mUrl.match(/(http)/i) && !mPass) {
        alert('<xlat:stream key="wcc/config/validation/misspassword" escape="true" encode="false"/>');
        return;
    }
    
    if (mRNames.length == 0) {
        alert('<xlat:stream key="wcc/config/validation/missrendition" escape="true" encode="false"/>');
        return;
    }
    
    for (var i = 0; i < mRNames.length; i++) {
    	var rName = mRNames[i];
        if (xssCharFound(rName)) {
            var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
            var field = '<xlat:stream key="wcc/console/label/renditionname" escape="true" encode="false"/>';
            alert(msg.replace("{0}", field));
            return;
        }
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
        value : "WCC/Configuration"
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "ini.action",
        value : action
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "ini.serverUrl",
        value : mUrl
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "ini.serverUser",
        value : mUser
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "ini.serverPassword",
        value : mPass
    }, reqForm);

    dojo.create("input", {
        type : "hidden",
        name : "ini.rendition.count",
        value : mRNames.length
    }, reqForm);

    for (var i = 0; i < mRNames.length; i++) {
        dojo.create("input", {
            type : "hidden",
            name : "ini.rendition." + i,
            value : mRNames[i]
        }, reqForm);
    }
    
    reqForm.submit();
}

function closeMsg() {
	dojo.destroy("msg-tag");
}

function xssCharFound(value) {
	if (typeof value == "string") {
	    for (var i = 0; i < value.length; i++) {
	        var ch = value.charAt(i);
	        if (ch == "'" || ch == '"' || ch == "<" || ch == ">") {
	            return true;
	        }
	    }
	}
	return false;
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
        </div></td></tr>
<%
}
%>
    <tr><td>
        <span class="title-text"><xlat:stream key="wcc/config/title/long"/></span></td></tr>
    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<table id="param-table" class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
    <tr class="tile-row-normal">
        <td class="form-label-text">
            <span class="alert-color">*</span>
            <xlat:stream key="wcc/console/label/server/url"/>:</td><td></td>
            <td id="server-url-div"></td>
    </tr>
    <tr class="tile-row-normal">
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr class="tile-row-normal">
        <td class="form-label-text">
            <span class="alert-color">*</span>
            <xlat:stream key="wcc/console/label/server/user"/>:</td>
        <td></td>
        <td id="server-user-div"></td>
    </tr>
    <tr class="tile-row-normal">
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr class="tile-row-normal">
        <td class="form-label-text">
            <xlat:stream key="wcc/console/label/server/password"/>:</td><td></td>
        <td id="server-password-div"></td>
    </tr>
    <tr class="tile-row-normal">
        <td colspan="3">&nbsp;</td>
    </tr>
    <tr class="tile-row-normal">
        <td class="form-label-text">
            <span class="alert-color">*</span>
            <xlat:stream key="wcc/console/label/renditionname"/>:</td>
        <td></td>
        <td>
            <a href="javascript:void(0)" onclick="addRendition('');">
                + <xlat:stream key="wcc/console/label/button/addrenditionname"/>
            </a></td>
    </tr>
</table>

<br/>

<div class="width-outer-70">
    <a id="test-link" href="javascript:void(0)" onclick="submitAction('test');"></a>
    <a id="save-link" href="javascript:void(0)" onclick="submitAction('save');"></a>
</div>

</cs:ftcs>
