<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %><%
%><%@ page import="com.openmarket.xcelerate.controlpanel.InSiteEditingUtil"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Scripts/ControlPanel
//
// INPUT
//
// OUTPUT
//
%>
<%--
 [2007-09-13 KGF]
   added getAssignment request, for AJAX-izing
    workflow assignments list.  This will actually help tackle
    2 bugs at once (#15586, #15802).
 [2007-11-05 KGF]
   added workaround for a bug which emerged upon removing render:stream
   from rich text editor behavior for insite editing. (:1398)
--%>
<cs:ftcs>

	<% 
        boolean inWemFramework = false;
		if(ics.GetVar("wem") != null) {
			inWemFramework = true;
		}
	%>

<satellite:link pagename="fatwire/insitetemplating/request" outstring="urlGetTemplatesForType" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="getTemplateLists"/>
</satellite:link>
<satellite:link pagename="fatwire/insitetemplating/request" outstring="urlSearchContentForSlot" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="search"/>
</satellite:link>
<satellite:link pagename="fatwire/insitetemplating/request" outstring="urlPreviewSlot" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="viewTemplate"/>
</satellite:link>
<satellite:link pagename="fatwire/insitetemplating/request" outstring="urlSaveSlotEdits" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="saveSlots"/>
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/Request" outstring="urlSearchContent" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="SearchResults"/>
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/Request" outstring="urlGetAssignments" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="ShowAssignments"/>
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/Request" outstring="urlGetTemplatesForAsset" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="GetTemplatesForAsset"/>
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/Request" outstring="urlDisassemble" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="Disassemble" />
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/ControlPanel/IsAssetCheckedOutByOther" outstring="urlIsAssetCheckedOut" assembler="query"/>

<satellite:link pagename="fatwire/wem/ui/Ping" outstring="wemcheckLogin" assembler="query"/>

<satellite:link outstring="stuburl"/>

<ics:getproperty name="xcelerate.enableinsite" file="futuretense_xcel.ini" output="enableinsite"/>
<ics:getproperty name="wem.enabled" file="futuretense_xcel.ini" output="wemenabled"/>

<xlat:lookup key="dvin/UI/Common/NotApplicableAbbrev" varname="_NA_" encode="false" escape="true"/>

<%

String userAgent = ics.ResolveVariables("CS.Header.User-Agent");
boolean isInsiteEnabled = "true".equals(ics.GetVar("enableinsite"));
boolean wemEnabled = "true".equals(ics.GetVar("wemenabled"));
boolean isBrowserSupported = InSiteEditingUtil.isBrowserSupported( ics );
//[KGF 2008-08-14] add boolean for whether user can use Page Layout features.
//This is based solely on sufficient ACLs; historically, isInsiteEnabled
//is also checked when enabling or disabling the Page Layout tab.
boolean isPageBuilderAllowed =
  ics.UserIsMember("ElementEditor") && ics.UserIsMember("PageEditor");
%>



// added this function to do the endswith functionality.
String.prototype.endsWith = function(suffix) {
    var startPos = this.length - suffix.length;
    if (startPos < 0) {
        return false;
    }
    return (this.lastIndexOf(suffix, startPos) == startPos);
}

// namespace
if (fw == undefined) var fw = new Object();

// Constants for panel modes
fw.MODE_PREVIEW     = "preview";
fw.MODE_EDITING     = "editing";
fw.MODE_PAGEBUILDER = "pagebuilder";
fw.MODE_SEARCH      = "insitesearch";
fw.MODE_WORKFLOW    = "workflow";

// Constants for CS rendermode
fw.RENDERMODE_NOINSITE      = "previewnoinsite";
fw.RENDERMODE_INSITE= "preview-<ics:getvar name="thisusername"/>-<string:stream variable="pubid"/>";
fw.RENDERMODE_PAGEBUILDER   = "insite_templating-<ics:getvar name="thisusername"/>-<string:stream variable="pubid"/>";

// Page titles
fw.TITLE_PREVIEW        = '<xlat:stream key="dvin/Common/Preview" encode="false" escape="true"/>';
fw.TITLE_PAGEBUILDER    = '<xlat:stream key="fatwire/InSite/PageLayout" encode="false" escape="true"/>';
fw.TITLE_EDITING        = '<xlat:stream key="fatwire/InSite/Editing" encode="false" escape="true"/>';

// Frame names
fw.FRAME_HEADER         = "Header";
fw.FRAME_TEMPLATESELECT = "TemplateSelect";
fw.FRAME_WORK           = "Work";

// Cursor styles
fw.CURSOR_WAIT = "wait";
fw.CURSOR_NORMAL = "auto";

// Constants for Ajax requests URLs
fw.REQUEST_DISASSEMBLE      = "disassemble";
fw.REQUEST_GETTEMPLATES_TYPE  = "getTemplatesForType";
fw.REQUEST_SEARCHCONTENT_SLOT = "searchContentForSlot";
fw.REQUEST_SAVESLOTEDITS    = "saveSlotEdits";
fw.REQUEST_PREVIEW_SLOT     = "previewSlot";
fw.REQUEST_SEARCHCONTENT    = "searchContent";
fw.REQUEST_GETASSIGNMENTS   = "getAssignments";
fw.REQUEST_GETTEMPLATES_ASSET = "getTemplatesForAsset";
fw.REQUEST_INITTEMPLATELIST   = "initTemplateList";
fw.REQUEST_CHANGEWRAPPER    = "changeWrapper";

fw.URL_DISASSEMBLE          = "<ics:getvar name="urlDisassemble"/>";
fw.URL_GETTEMPLATES_TYPE    = "<ics:getvar name="urlGetTemplatesForType"/>";
fw.URL_GETTEMPLATES_ASSET   = "<ics:getvar name="urlGetTemplatesForAsset"/>";
fw.URL_PREVIEW_SLOT         = "<ics:getvar name="urlPreviewSlot" />";
fw.URL_SAVESLOTEDITS        = "<ics:getvar name="urlSaveSlotEdits"/>";
fw.URL_SEARCHCONTENT        = "<ics:getvar name="urlSearchContent"/>";
fw.URL_SEARCHCONTENT_SLOT   = "<ics:getvar name="urlSearchContentForSlot" />";
fw.URL_GETASSIGNMENTS       = "<ics:getvar name="urlGetAssignments"/>";
fw.URL_ISASSETCHECKEDOUT    = "<ics:getvar name="urlIsAssetCheckedOut"/>";
fw.URL_WEMCHECKLOGIN    = "<ics:getvar name="wemcheckLogin"/>";

// Content type for requests
fw.contentType = "application/x-www-form-urlencoded; charset=<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini"/>";
fw.charset="<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini"/>";
//
// Class representing a tab in the control panel
//

//
// Builds a new tab
//     mode             a string identifying the current mode
//                      (preview | editing | pagebuilder | insitesearch | workflow)
//     rendermode       CS rendermode to set when mode is active
//     title            page title to set when tab is active
//     onclickhandler   (optional) handler for bar onclick event
//
fw.Tab = function(mode, rendermode, title, onclickhandler) {
    this._title = title;
    this._rendermode = rendermode;
    // naming convention is as follows:
    //   - <mode> is the div id containing the tab handle
    //   - <mode>Tab is the div id containing the tab itself
    this._bar = document.getElementById(mode);
    if (onclickhandler)
        this._bar.onclick = onclickhandler;
    this._tab = document.getElementById(mode + "Tab");
}

fw.Tab.prototype = {
    hide: function() {
        this._tab.style.display = "none";
    },

    show: function() {
        var panelDiv = document.getElementById("controlPanel");
        var nextBar = this._bar.nextSibling;
        if (nextBar) {
            panelDiv.insertBefore(this._tab, nextBar);
        } else {
            panelDiv.appendChild(this._tab);
        }
        this._tab.style.display = "block";
    },

    getRenderMode: function() {
        return this._rendermode;
    },

    getTitle: function() {
        return this._title;
    },

    setCursor: function(cursorStyle) {
        this._tab.style.cursor = cursorStyle;
    },

    getTabElement: function() {
        return this._tab;
    },

    getBarElement: function() {
        return this._bar;
    }
}

// -------------------------------------------------
// Helper class for managing all control panel tabs
// -------------------------------------------------
fw.TabManager = function() {
    this._tabs = new Object();
    this._positions = new Array();
}

fw.TabManager.prototype = {
    //
    // registers a new tab
    //     mode             a string identifying the current mode
    //     rendermode       rendermode to set when tab is active
    //     title            page title when tab is active
    //     onclickhandler   handler when tab handle is clicked
    //
    addTab: function(mode, rendermode, title, onclickhandler) {
        this._tabs[mode] = new fw.Tab(mode, rendermode, title, onclickhandler);
        this._positions[this._positions.length] = mode;
    },

    getTab: function(mode) {
        return this._tabs[mode];
    },

    //
    // close all tabs
    //
    closeAllTabs: function() {
        for (mode in this._tabs) {
            var tab = this._tabs[mode];
            tab.hide();
        }
    },

    //
    // reorder tabs - active tab is always shown first
    //
    reorder: function(mode) {
        var activeTabId = mode;
        var newPositions = new Array();
        newPositions[0] = activeTabId;
        var currentPosition = 1;
        // loop through tabs in the order they were initially inserted in the panel
        // through the addTab method.
        for (var i = 0; i < this._positions.length; i++) {
            var tabId = this._positions[i];
            if (tabId != activeTabId) {
                newPositions[currentPosition] = tabId;
                currentPosition++;
            }
        }
        var panelElement = document.getElementById("controlPanel");
        // ignore first child TODO remove sitename from panel div
        for (var i = 1; i < panelElement.childNodes.length; i++) {
            var node = panelElement.childNodes[i];
            panelElement.removeChild(node);
        }
        for (var i = 0; i< newPositions.length; i++) {
            var current = newPositions[i];
            panelElement.appendChild(this.getTab(current).getBarElement());
        }
    },

    //
    // returns rendermode for a given mode
    //
    getRenderMode: function(mode) {
        var tab = this._tabs[mode];
        var rendermode = "previewnoinsite";
        if (tab) {
            rendermode = tab.getRenderMode();
        }
        return rendermode;
    },

    //
    // shows tab corresponding to given mode
    //
    showTab: function(mode) {
        var tab = this._tabs[mode];
        tab.show();
    }
}

// ------------------------------------------------------
// Control Panel
// ------------------------------------------------------
//
// Builds a new control panel instance
//        c     previewed asset type
//        cid   previewed asset id
//        mode  active mode when control panel opens
//        target  (optional) pub target
//
fw.ControlPanel = function(c, cid, mode, target) {
    this._tabManager = new fw.TabManager();
    this._requestEngine = new fw.RequestEngine();
    this._assetType = c;
    this._assetId = cid;
    if (mode != fw.MODE_PREVIEW && mode != fw.MODE_EDITING
        && mode != fw.MODE_PAGEBUILDER && mode != fw.MODE_SEARCH
        && mode != fw.MODE_WORKFLOW)
        mode = fw.MODE_PREVIEW;

    this._mode = mode;
    this._target = target;
    this._rendermode = null;
    this._currentURL = null;
    this._isDirty = false;
    this._siteid = "<string:stream variable="pubid"/>";
    this._iscspage = true;
    this._editingEnabled = <%=isInsiteEnabled && isBrowserSupported %>;
    this._pageBuilderEnabled = <%= isInsiteEnabled && isPageBuilderAllowed %>;
    this._editedAssets = new Array();
    this._tname = null;

    // UI elements
    //    - TemplateSelect frame
    this._mainTitleArea = null;
    this._wrappersDropDown = null;
    this._templatesDropDown = null;
    //      - page builder
    this._pageBuilderTypesDropDown = null;
    this._pageBuilderTemplatesDropDown = null;
    this._pageBuilderSaveBtn = null;
    this._pageBuilderCancelBtn = null;
    this._pageBuilderStatus = null;
    //    - insite editor
    this._assetName = null;
    this._assetField = null;
    this._editingSaveBtn = null;
    this._editingCancelBtn = null;
    this._insiteSearchBtn = null;
    this._insiteForm = null;
    this._insiteFrame = null;
    this._editingStatus = null;
    //    - frames
    this._templateFrame = null;
    this._headerFrame = null;
    //    - preview
    this._templateName = null;
    this._templateDescription = null;
    this._assetTypeDescription = null;
    //    - top frame
    this._username = null;
    this._userarea = null;
	<%if(session.getAttribute("X-CSRF-Token") != null){%>
		this.authticket='<%=session.getAttribute("X-CSRF-Token")%>';
	<%} else {%>
		this.authticket=null;
	<%}%>
}

fw.ControlPanel.prototype = {
    // -----------------------
    // Panel "public" methods
    // -----------------------
    init: function() {
        var panel = fw.controlPanel;
        panel._initTabs();
        if (!panel._isReady()) {
            window.setTimeout(fw.controlPanel.init, 500);
            return;
        }
        panel._rendermode = fw.RENDERMODE_NOINSITE;
        panel._initUIElements();
        panel._currentURL = panel.getSelectedTemplateURL();
        panel._tabManager.reorder(panel._mode);
        panel.showTab(panel._mode);
        panel.refreshPreviewArea(panel._mode);
        panel.setTitle(panel.getTab(panel._mode).getTitle());
        panel._registerRequests();
        panel._registerEvents();
        panel.setUsername("<ics:getvar name="thisusername"/>");
        panel.initTemplateList();
    },

    cancelContentEdits: function() {
        this.resetEditForm();
        this.refreshMainArea();
    },

    cancelSlotEdits: function() {
        this.setDirty(false);
        this.refreshMainArea();
    },

    disassemble: function() {
        var params = "cs_url=" + encodeURIComponent(this.getCurrentURL());
        this._sendRequest(fw.REQUEST_DISASSEMBLE, params);
    },

    getTemplateList: function(startMenuId) {
        var params = "siteid=" + fw.controlPanel._siteid + "&startmenuid=" + startMenuId;
        fw.controlPanel._sendRequest(fw.REQUEST_GETTEMPLATES_TYPE, params);
    },

    getTemplates: function() {
        var params = "AssetType=" + this._assetType + "&id=" + this._assetId + "&rendermode=" + this._rendermode;
        if (this._target)
            params += "&target=" + this._target;
        if (this._wrappersDropDown && this._wrappersDropDown.options
                && this._wrappersDropDown.options.length > 0) {
            params += "&currentWrapper=" + this._wrappersDropDown.options[this._wrappersDropDown.selectedIndex].value;
        }

        this._sendRequest(fw.REQUEST_GETTEMPLATES_ASSET, params);
    },

    getSelectedTemplateURL: function() {
        var selectedTemplateUrl = "about:blank";
        try {
            selectedTemplateUrl = this._templatesDropDown.options[this._templatesDropDown.selectedIndex].value;
        } catch(e) {}
        return selectedTemplateUrl;
    },

    setCurrentURL: function(currentURL) {
        this._currentURL = currentURL;
    },

    getCurrentURL: function() {
        return this._currentURL;
    },

    getPreviewURL: function() {
        var url =
             "http://<%=request.getServerName()%>:<%=request.getServerPort()%><ics:getproperty name="ft.cgipath"/>Satellite?"
            + "pagename=OpenMarket/Xcelerate/UIFramework/ShowPreviewFrames"
            + "&id=" + this._assetId
            + "&AssetType=" + this._assetType
            + "&pubid=" + this._siteid
            + "&mode=" + this._mode;
        return url;
    },

    search: function(start) {
        if (!start) {
            var start = 1;
        }
        document.getElementById("searchResults").innerHTML = "";
        var params = "start=" + start +"&siteid=" + this._siteid;
        var atbox = document.getElementById( "searchAssetType" );

        params = params + "&startmenuid=" + atbox.options[ atbox.selectedIndex ].value;
        var nameinput = document.getElementById( "searchforname" );
        /*
        if ( nameinput.value == "") {
           alert("<xlat:stream key="dvin/UI/Inputvalidsearchcriteria" encode="false"  escape="true"/>");
            return;
        }
        */

        params = params + "&aname=" + encodeURI(nameinput.value);
        var tbox;

        tbox = document.getElementById( "TemplatesForType" );
        //if ( tbox.options[ tbox.selectedIndex ].value == "" ) {
        //   alert("<xlat:stream key="dvin/UI/PleaseSelectTemplateBeforeSearchingAsset" encode="false"  escape="true"/>");
        //    return;
        //}
        params = params + "&tname=" + tbox.options[ tbox.selectedIndex ].value;
        this._sendRequest(fw.REQUEST_SEARCHCONTENT_SLOT, params);
    },

    setDirty: function(isDirty) {
        this._isDirty = isDirty;
    },

    isDirty: function() {
        return this._isDirty;
    },

    saveContentEdits: function() {
        var editingTab = this.getTab(fw.MODE_EDITING);
        editingTab.setCursor(fw.CURSOR_WAIT);
        this.setEditingStatus("<xlat:stream key="fatwire/InSite/Saving" escape="true"/>");
        this.updateCurrentURL();
        this._insiteFrame.controlPanel = document.getElementById('controlPanel');
        this._gatherData();
        errorMsg = this._validateData();
        if (errorMsg == undefined)
        {
            this._insiteForm.submit();
        }
        else
        {
            editingTab.setCursor(fw.CURSOR_NORMAL);
            this.setEditingStatus("<xlat:stream key="dvin/Common/Error" escape="true"/>: "+errorMsg);
            this.resetEditForm(true); //reset form without resetting dirty/fields
        }
    },

    saveSlotEdits: function() {
        var panel = fw.controlPanel;
        var pageBuilderTab = this.getTab(fw.MODE_PAGEBUILDER);
        pageBuilderTab.setCursor(fw.CURSOR_WAIT);
        this.setPageBuilderStatus("<xlat:stream key="fatwire/InSite/Saving" escape="true"/>");
        var divs = window.parent.frames['Work'].document.getElementsByTagName("div");
        var slotname;
        var slotinfo;
        var slotargs;
        var total = 0;
        var data = "";
        // gather the insite-inner divs, the slotname is the parent id
        for (i=0; i < divs.length; i++) {
            var innerSlot = divs.item(i);
            if ( innerSlot.className=='insite-inner' ) {
                var parent = innerSlot.parentNode;
                slotname = parent.id;
                slotinfo = innerSlot.id;
                slotargs = innerSlot.args;
                slotcontext = parent.getAttribute("context");
                data += "&slotname" + total + "=" + slotname;
                data += "&slotinfo" + total + "=" + slotinfo;
                data += "&slotargs" + total + "=" + slotargs;
                data += "&slotcontext" + total + "=" + slotcontext;
                total = total + 1;
            }
        }
        data += "&slottotal=" + total;
        data += "&primaryType="+panel._assetType+"&primaryId="+panel._assetId;
        this._sendRequest(fw.REQUEST_SAVESLOTEDITS, data);
    },

    searchContent: function(start) {
        var selectBox = document.getElementById("insiteSearchAssetType");
        var assettype = selectBox.options[selectBox.selectedIndex].value;
        var inputBox = document.getElementById("insiteSearchText");
        var searchTerm = inputBox.value;
        var params = "searchAssetType=" + assettype + "&searchText=" + encodeURI(searchTerm);
        if (start)
            params += "&start=" + start;
        this._sendRequest(fw.REQUEST_SEARCHCONTENT, params);
    },

    getAssignments: function(start) {
        var params = '';
        if (start) params = 'start=' + start;
        this._sendRequest(fw.REQUEST_GETASSIGNMENTS, params);
    },

    timeout: function() {
        parent.location.href=this.getPreviewURL();
    },

    updateCurrentURL: function() {
        var hasChanged = false;
        var mainAreaFrame = parent.frames["Work"];
        var frameLocation;
        try {
            frameLocation = mainAreaFrame.location.href;
            if (this.getCurrentURL() != mainAreaFrame.location.href) {
                this.setCurrentURL(mainAreaFrame.location.href);
                hasChanged = true;
            }
        } catch(e) {
            // user has most likely navigated to an external URL
            this.clearAsset();
            this.clearTemplate();
        }
        return hasChanged;
    },

    // --------------
    // Event handlers
    // --------------

    selectTemplateForTypeHandler: function() {
        var panel = fw.controlPanel;
        var selectedType = panel._pageBuilderTypesDropDown.options[ panel._pageBuilderTypesDropDown.selectedIndex ].value;
        if (selectedType) {
            panel.getTemplateList(selectedType);
            panel._pageBuilderNameTextInput.disabled = "";
            panel._pageBuilderTemplatesDropDown.disabled = "";
        }
    },

    processSaveEdits: function() {
        var insiteFrame = this._insiteFrame;

        if (insiteFrame.contentDocument) {
            var doc = insiteFrame.contentDocument;
        } else if (insiteFrame.contentWindow) {
            var doc = insiteFrame.contentWindow.document;
        } else {
            var doc = window.frames[id].document;
        }
        if (doc.location.href == "about:blank") {
            return;
        }
        var responseText = doc.body.innerHTML;
        if (responseText == "-3") {
            this.timeout();
        } else {
            if (responseText.indexOf("SUCCESS") != -1) {
                this.setDirty(false);
                this.resetEditForm();
                this.resetEditedAssets();
                this.refreshPreviewArea(fw.MODE_EDITING);
                this.setEditingStatus( "<xlat:stream key="dvin/Common/Done" escape="true"/>" );
            } else {
                this.setEditingStatus( "<xlat:stream key="dvin/Common/Error" escape="true"/>: " + responseText );
            }
            var editingTab = this.getTab(fw.MODE_EDITING);
            editingTab.setCursor(fw.CURSOR_NORMAL);
        }
    },

    tabClickHandler: function() {
        var mode = this.id;
        var panel = fw.controlPanel;

        <% if ("true".equals(System.getProperty("insite.usemarkerassets")))
        {
            //var set for xlat stream
            ics.SetVar("errAssetType", "Page");
            %>
            if (mode == fw.MODE_PAGEBUILDER && dojo.xhrGet({url: fw.URL_ISASSETCHECKEDOUT+'&id='+panel._assetId+'&AssetType='+panel._assetType+'<%="&username="+ics.GetVar("thisusername")%>', handleAs: 'json-comment-optional', sync: true}).results[0]){
                alert('<xlat:stream key="dvin/UI/Error/Templateischeckedoutbyanotheruser" encode="false" escape="true"/>');
                return false;
            }
            <%
            ics.RemoveVar("errAssetType");
        }
        %>

        if (panel.isDirty() && confirm("<xlat:stream key="fatwire/InSite/UnsavedEditsContinue" encode="false" escape="true"/>")) {
            panel.setDirty(false);
        }

        if (!panel.isDirty()) {
            panel.closeAllTabs();
            panel._mode = mode;
            panel._tabManager.reorder(mode);
            panel.showTab(mode);
            if (panel._iscspage)
                panel.refreshPreviewArea(mode);
        }
    },

    keypress: function(e) {
        if ( (window.event && window.event.keyCode == 13)
            || (e && e.which == 13)) {
            this.search();
        }
    },

    update: function() {
        var hasChanged = this.updateCurrentURL();
        if (hasChanged) {
            this.disassemble();
        }
    },

    // ---------------
    // Private methods
    // ---------------
    _initTabs: function() {
        this.addTab(fw.MODE_PREVIEW, fw.RENDERMODE_NOINSITE, fw.TITLE_PREVIEW, this.tabClickHandler);
        // editing tab not clickable if insite editing is off
        if (this._editingEnabled)
        {
            this.addTab(fw.MODE_EDITING, fw.RENDERMODE_INSITE, fw.TITLE_EDITING, this.tabClickHandler);
        }
        else
        {
            this.addTab(fw.MODE_EDITING, fw.RENDERMODE_INSITE, fw.TITLE_EDITING);
            this._disableImg(fw.MODE_EDITING);
        }

        if (this._pageBuilderEnabled)
        {
            this.addTab(fw.MODE_PAGEBUILDER, fw.RENDERMODE_PAGEBUILDER, fw.TITLE_PAGEBUILDER, this.tabClickHandler);
        }
        else
        {
            this.addTab(fw.MODE_PAGEBUILDER, fw.RENDERMODE_PAGEBUILDER, fw.TITLE_PAGEBUILDER);
            this._disableImg(fw.MODE_PAGEBUILDER);
        }
        this.addTab(fw.MODE_SEARCH, fw.RENDERMODE_NOINSITE, fw.TITLE_PREVIEW, this.tabClickHandler);
        this.addTab(fw.MODE_WORKFLOW, fw.RENDERMODE_NOINSITE, fw.TITLE_PREVIEW, this.tabClickHandler);
        this.closeAllTabs();
    },

    //[KGF] added for easy replacement of tab title image with _unavail version
    _disableImg: function(tab) {
        if (this.getTab(tab))
            var img = this.getTab(tab).getBarElement().getElementsByTagName('img')[0];
        if (img)
            img.src = img.src.substr(0, img.src.length - 4) + '_unavail.gif';
    },
    
    _initUIElements: function() {
        // page builder UI elements
        this._pageBuilderSearchBtn = document.getElementById("searchBtn");
        this._pageBuilderSaveBtn = document.getElementById("saveSlotsBtn");
        this._pageBuilderCancelBtn = document.getElementById("cancelSlotsBtn");
        this._pageBuilderTypesDropDown = document.getElementById("searchAssetType");
        this._pageBuilderNameTextInput = document.getElementById("searchforname");
        this._pageBuilderNameTextInput.disabled = true;
        this._pageBuilderTemplatesDropDown = document.getElementById("TemplatesForType");
        this._pageBuilderTemplatesDropDown.disabled=true;
        // Insite editor
        this._editingSaveBtn = document.getElementById("ctrlSaveId");
        this._editingCancelBtn = document.getElementById("ctrlCancelId");
        this._insiteFrameLocation = document.getElementById("insiteFrameLocation");
        if (this._insiteFrameLocation)
        {
            //src='spacer.gif' is workaround for IE6 - http://support.microsoft.com/?scid=kb%3Ben-us%3B261188&x=8&y=10
            this._insiteFrameLocation.innerHTML = "<iframe id='insiteFrame' name='insiteFrame' onload='fw.controlPanel.processSaveEdits();' src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/logo/spacer.gif"%>' style='display: none;'></iframe>";
        }
        this._insiteFrame = document.getElementById("insiteFrame");
        this._insiteForm = document.getElementById("form1");
        if (this._insiteForm)
            this._insiteForm.style.display = 'none';
        this._editingStatus = document.getElementById("editStatus");
        this._pageBuilderStatus = document.getElementById("pageBuilderStatusLine");
        this._pageBuilderStatus = document.getElementById("pageBuilderStatusLine");
        this._insiteSearchBtn = document.getElementById("insiteSearchBtn");
        this._assetName = document.getElementById("assetName");
        this._assetField = document.getElementById("assetField");
        // Preview tab
        this._previewedAssetName = document.getElementById("previewedAssetName");
        this._previewedAssetDescription = document.getElementById("previewedAssetDescription");
        this._templateName = document.getElementById("templateName");
        this._templateDescription = document.getElementById("templateDescription");
        this._assetTypeDescription = document.getElementById("assetTypeDescription");
    },

    _registerRequests: function() {
        this._registerRequest(fw.REQUEST_CHANGEWRAPPER,      fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processChangeWrapper);
        this._registerRequest(fw.REQUEST_DISASSEMBLE,        fw.URL_DISASSEMBLE,        "POST", this, this.processDisassemble);
        this._registerRequest(fw.REQUEST_GETTEMPLATES_ASSET, fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processGetTemplatesForAsset);
        this._registerRequest(fw.REQUEST_GETTEMPLATES_TYPE,  fw.URL_GETTEMPLATES_TYPE,  "POST", this, this.processGetTemplatesForType);
        this._registerRequest(fw.REQUEST_INITTEMPLATELIST,   fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processInitTemplateList);
        this._registerRequest(fw.REQUEST_PREVIEW_SLOT,       fw.URL_PREVIEW_SLOT,       "POST", this, this.processPreviewSlot);
        this._registerRequest(fw.REQUEST_SAVESLOTEDITS,      fw.URL_SAVESLOTEDITS,      "POST", this, this.processSaveSlotEdits);
        this._registerRequest(fw.REQUEST_SEARCHCONTENT,      fw.URL_SEARCHCONTENT,      "POST", this, this.processSearchContent);
        this._registerRequest(fw.REQUEST_SEARCHCONTENT_SLOT, fw.URL_SEARCHCONTENT_SLOT, "POST", this, this.processSearchContentForSlot);
        this._registerRequest(fw.REQUEST_GETASSIGNMENTS,     fw.URL_GETASSIGNMENTS,      "POST", this, this.processGetAssignments);		
    },

    _registerRequest: function(requestId, requestURL, requestMethod, requestTarget, requestHandler) {
        var errorHandler = null;
        this._requestEngine.register(requestId, requestURL, requestMethod, requestTarget, requestHandler, errorHandler, fw.contentType);
    },

    _registerEvents: function() {
        var panel = this;
        this._pageBuilderTypesDropDown.onchange    = function() {panel.selectTemplateForTypeHandler();};
           this._pageBuilderSearchBtn.onclick         = function() {panel.search();};
        this._pageBuilderSaveBtn.onclick         = function() {panel.saveSlotEdits();};
        this._pageBuilderCancelBtn.onclick        = function() {panel.cancelSlotEdits();};
        this._pageBuilderNameTextInput.onkeypress = function(e) {panel.keypress(e);};
        this._insiteSearchBtn.onclick            = function() {panel.searchContent();};
        if (this._editingSaveBtn)
          this._editingSaveBtn.onclick        = function() {panel.saveContentEdits();};
        if (this._editingCancelBtn)
            this._editingCancelBtn.onclick         = function() {panel.cancelContentEdits();};
        this._templatesDropDown.onchange        = function() {panel.setSelectedTemplate();};
        this._wrappersDropDown.onchange            = function() {panel.changeWrapper();};
    },

    _isReady: function() {
        var panel = fw.controlPanel;
        // get template frame (the frame containing the template and wrapper dropdowns)
        if (!panel._templateFrame)
            panel._templateFrame = parent.frames[fw.FRAME_TEMPLATESELECT];
        if (!panel._headerFrame)
            panel._headerFrame = parent.frames[fw.FRAME_HEADER];

        // we need a valid handle to the title area and the template select box
        var titleDiv = panel._templateFrame.document.getElementById("title");
        var templatesDropdown = panel._templateFrame.document.getElementById("templateSelect");
        var wrappersDropdown = panel._templateFrame.document.getElementById("wrapperSelect");
        var userarea = panel._headerFrame.document.getElementById("userarea");
        var username = panel._headerFrame.document.getElementById("username");
        // if we don't have them
        if (!titleDiv && !templatesDropdown && !userarea && !username) {
            // we can't init the panel now
            return false;
        } else {
            // remember handle to those two elements
            panel._mainTitleArea = titleDiv;
            panel._templatesDropDown = templatesDropdown;
            panel._wrappersDropDown = wrappersDropdown;
            panel._username = username;
            panel._userarea = userarea;
            return true;
        }
    },

    _replaceRenderMode: function(url, rendermode) {
        var i1 = url.indexOf('rendermode=');
        var fixedUrl;
           if (i1 == -1)  {  // no rendermode
               // and no query string
               if(url.indexOf('?') == -1 ) {
                   // add rendermode as query string
                   fixedUrl = url + "?" + "rendermode=" + rendermode;
               } else {
                   // add rendermode as an argument
                   fixedUrl = url + "&" + "rendermode=" + rendermode;
               }
           }
           else {
            var regexp = /\brendermode=([^&]+)/;
            fixedUrl = url.replace(regexp, "rendermode=" + rendermode);
        }
        return fixedUrl;
    },

    _getScrollTop: function(theWindow) {
      if (theWindow && theWindow.document) {
          if (theWindow.document.documentElement && theWindow.document.documentElement.scrollTop)
              return theWindow.document.documentElement.scrollTop;
          else
            return theWindow.document.body.scrollTop;
       } else
           return 0;
    },

    _getScrollLeft: function(theWindow) {
       if (theWindow && theWindow.document) {
        if (theWindow.document.documentElement && theWindow.document.documentElement.scrollLeft)
            return theWindow.document.documentElement.scrollLeft;
          else
          return theWindow.document.body.scrollLeft;
      } else
          return 0;
    },

    // PR#11927: Shared assets may not be previewable on ISE
    // Displays alert to user if there is no selected template for the current asset.
    // Possible causes:
    //     - no default template set at asset level
    //     - template is set but not found in dropdown: template is not shared
    _checkDefaultTemplate: function(defaultTemplate) {
        var selectedTemplate = this._templatesDropDown.options[this._templatesDropDown.selectedIndex].value;
        
        if (selectedTemplate == "None") {
            if (defaultTemplate == "") {
                alert("<xlat:stream key="dvin/UI/NoDefaultTemplateFound" encode="false" escape="true" />");                
            } else {
                // merge for
                var replacestr=/Variables.defTemplate/ ;
                var xlatstr ='<xlat:stream key="dvin/UI/DefaultTemplateNotShared" encode="false" escape="true" />';
                alert(xlatstr.replace(replacestr, defaultTemplate));
            }
        }
    },

    _checkLogin: function(request) {	
	<%
		if(wemEnabled) 
		{ 
		%>
			var sessionAlive = true;
			dojo.xhrGet({
			url: fw.URL_WEMCHECKLOGIN,						
			sync: true,
			handleAs: "json",
			error: function(err) {
				var panel = fw.controlPanel;
				var url = panel.removeTicket(window.top.location.href,"ticket");			
				window.top.location.href= url;
				sessionAlive = false;
				return false;
			}
		});			
		if(!sessionAlive)
		{
			return false;
		}
		<%	}	%>
        if (request && request.responseText == "-3") {
            return false;
        }		
        return true;
    } ,
	
	removeTicket: function ( url, parameter ) {

		if( typeof parameter == "undefined" || parameter == null || parameter == "" )
		{	
			return url;
		}
		url = url.replace( new RegExp( "\\b" + parameter + "=[^&;]+[&;]?", "gi" ), "" ); 
		// remove any leftover crud
		url = url.replace( /[&;]$/, "" );
		return url;
	} ,
	
    // -----------------
    // Request handlers
    // -----------------
    processGetTemplatesForType: function(request) {
        var panel = fw.controlPanel;
        if (panel._checkLogin(request)) {
            if ( request.responseText == "-101" ) {
                panel._pageBuilderTemplatesDropDown.options.length = 0;
                panel._pageBuilderTemplatesDropDown.options[0] = new Option( "No Templates Associated with this Assettype", "-101" );
            } else {
                var templates = request.responseText;
                var index = templates.indexOf( "<name>" );
                var index2 = templates.indexOf( "</name>" );
                var i = 0;
                panel._pageBuilderTemplatesDropDown.options.length = 0;
                if ( index < 0 )
                    panel._pageBuilderTemplatesDropDown.options[0] = new Option( "No Template Available", "" );
                while ( index > -1 && index2 > -1 ) {
                    panel._pageBuilderTemplatesDropDown.options[i] = new Option( templates.substring(index+6, index2 ), templates.substring(index+6, index2 ) );
                    i = i + 1;
                    index = templates.indexOf( "<name>", index2 );
                    index2 = templates.indexOf( "</name>", index2+7 );
                }
            }
        } else {
            panel.timeout();
        }
    },

    processSearchContentForSlot: function(request) {
        if (this._checkLogin(request)) {
            document.getElementById("searchResults").innerHTML = request.responseText;
        } else {
            this.timeout();
        }
    },

    processPreviewSlot: function(request) {
        if (this._checkLogin(request)) {
            var previewDiv = fw.controlPanel.getPreviewArea();
            // the preview div should appear at a visible spot
            // position needs to take scrolling into account.
            // (workaround for position: fixed nok on IE6)
            var hSpace = 30;
            var vSpace = 100;
            if (window.navigator.appName=='Microsoft Internet Explorer') {
               previewDiv.style.position = "absolute";
               previewDiv.style.top = vSpace + this._getScrollTop(parent.frames["Work"]);
               previewDiv.style.left = hSpace + this._getScrollLeft(parent.frames["Work"]);
            } else {
               previewDiv.style.position = "absolute";
               var x = hSpace + parent.frames["Work"].pageXOffset;
               var y = vSpace + parent.frames["Work"].pageYOffset;
               previewDiv.style.top = y + "px"
               previewDiv.style.left = x + "px"
            }
            // TODO hardcoded style
            previewDiv.style.backgroundColor="#fff";
            previewDiv.style.filter="alpha(opacity=90)";
            previewDiv.style.opacity="0.9";
            previewDiv.innerHTML = request.responseText;
            fw.controlPanel.setPageBuilderStatus("<xlat:stream key="dvin/Common/Done" escape="true"/>");
         } else {
             this.timeout();
         }
    },

    processSaveSlotEdits: function(request) {
        if (this._checkLogin(request)) {
            var pageBuilderTab = this.getTab(fw.MODE_PAGEBUILDER);
            pageBuilderTab.setCursor(fw.CURSOR_NORMAL);
            this.setDirty(false);
            this.setPageBuilderStatus( request.responseText );
        } else {
            this.timeout();
        }
    },

    processSearchContent: function(request) {
        if (this._checkLogin(request)) {
            var searchResults = document.getElementById("searchContentResults");
            searchResults.innerHTML = request.responseText;
        } else {
            this.timeout();
        }
    },

    processGetAssignments: function(request) {
        if (this._checkLogin(request)) {
            //getElementById("workflowResults") doesn't work when requested from popup
            var wfdiv = this.getTab(fw.MODE_WORKFLOW).getTabElement().getElementsByTagName('div')[0];
            if (wfdiv) wfdiv.innerHTML = request.responseText;
        } else
            this.timeout();
    },

    processGetTemplatesForAsset: function(request) {
        if (this._checkLogin(request)) {
            var jsonResponse = request.responseText;
            var data = dojo.fromJson(jsonResponse);
            this.updateTemplateList(data);
        } else {
            this.timeout();
        }
    },

    processDisassemble: function(request) {
        if (this._checkLogin(request)) {
            var jsonResponse = request.responseText;
            var data = dojo.fromJson(jsonResponse);
            this.updatePreviewTab(data);
        } else {
            this.timeout();
        }
    },

    processChangeWrapper: function(request) {
        if (this._checkLogin(request)) {
            var jsonResponse = request.responseText;
            var data = dojo.fromJson(jsonResponse);
            this.updateTemplateList(data);
            var selectedTemplateUrl = this._templatesDropDown.options[this._templatesDropDown.selectedIndex].value;
            if (selectedTemplateUrl == "None") {
                this.setMainArea("about:blank");
            }
            else {
                this.setCurrentURL(selectedTemplateUrl);
                this.setMainArea();
            }
        } else {
            this.timeout();
        }
    },

    processInitTemplateList: function(request) {
        if (this._checkLogin(request)) {
            var jsonResponse = request.responseText;
            var data = dojo.fromJson(jsonResponse);
            this.updateTemplateList(data, true);
            var selectedTemplateUrl = this._templatesDropDown.options[this._templatesDropDown.selectedIndex].value;
            if (selectedTemplateUrl == "None") {
                this.setMainArea("about:blank");
            }
            else {
                this.setCurrentURL(selectedTemplateUrl);
                this.setMainArea();
                this.disassemble();
            }
        } else {
            this.timeout();
        }
    },

    // -------------
    // UI management
    // -------------

    closeAllTabs: function() {
        this._tabManager.closeAllTabs();
    },

    showTab: function(mode) {
        this._tabManager.showTab(mode);
    },

    addTab: function(mode, rendermode, title, onclickhandler) {
        this._tabManager.addTab(mode, rendermode, title, onclickhandler);
    },

    getTab: function(tabid) {
        return this._tabManager.getTab(tabid);
    },

    resetEditForm: function(preserveDirty) {
    try {
            var editform = document.forms["form1"];
			if (editform) {
				editform.style.display = 'none';
				// cleanup
				while (editform.firstChild) {
				  editform.removeChild(editform.firstChild);
				}
				// add _charset_ input
				var oNewNode = document.createElement("INPUT");
				editform.appendChild(oNewNode);
				oNewNode.style.display = 'none';
				oNewNode.name="_charset_";
				oNewNode.type="text";
				oNewNode.value=fw.charset;
				
				// add pagename input
				var oNewNode = document.createElement("INPUT");
				editform.appendChild(oNewNode);
				oNewNode.style.display = 'none';
				oNewNode.name="pagename";
				oNewNode.type="text";
				oNewNode.value="OpenMarket/Xcelerate/ControlPanel/ControlPanelSubmit";

                if (!preserveDirty)
                {
                    // panel is not dirty any more
                    fw.controlPanel.setDirty(false);
                    // reset list of edited assets
                    fw.controlPanel.resetEditedAssets();
                }
            }
        } catch (error)
		{
			// error in resetting the form
		}
    },

    setSelectedTemplate: function() {
        var currentUrl = this._templatesDropDown.options[this._templatesDropDown.selectedIndex].value;
        if (currentUrl == "None") {
            currentUrl = "about:blank";
            this.clearTemplate();
            this._tname = null;
        }
        this.setCurrentURL(currentUrl);
        this.setMainArea(currentUrl);
    },

    updateEditedAssets: function(assettype, assetname, startdate, enddate) {
        var panel = fw.controlPanel;
        panel._editingStatus.innerHTML = "";
        var asset = new Object();
        asset.type = assettype;
        asset.name = assetname;
        asset.startdate = startdate;
        asset.enddate = enddate;
        panel._editedAssets[panel._editedAssets.length] = asset;
        /* apparently unused
        var msg = "";
        for (var i = 0; i < panel._editedAssets.length; i++) {
            msg += panel._editedAssets[i].type + " - " + panel._editedAssets[i].name + "\n";
        }
        */
        var editedAssetTable = document.getElementById("editedAssets");
        while (editedAssetTable.firstChild) {
            editedAssetTable.removeChild(editedAssetTable.firstChild);
        }

        var tableBody = document.createElement("tbody");
        editedAssetTable.appendChild(tableBody);


            var tableRow = document.createElement("tr");
            tableBody.appendChild(tableRow);

            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableCell.setAttribute('width','1%');
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode(" "));

            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode("<xlat:stream key="dvin/AT/Common/Name" encode="false" escape="true"/>"));

            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableCell.setAttribute('width','1%');
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode("<xlat:stream key="dvin/Common/AT/Map/type" encode="false" escape="true"/>"));

        for (var i = 0; i < panel._editedAssets.length;i++) {
            var asset = panel._editedAssets[i];
            var tableRow = document.createElement("tr");
            tableRow.className = (i%2==0?"highlightOn":"highlightOff");
            tableBody.appendChild(tableRow);
            var tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            var imgElement = document.createElement("img");
            tableCell.appendChild(imgElement);
            imgElement.onerror = function()
            {
                this.src = "<ics:getvar name="cs_imagedir"/>/OMTree/TreeImages/default.png";
            };
            imgElement.src="<ics:getvar name="cs_imagedir"/>/OMTree/TreeImages/AssetTypes/" + asset.type + ".png";
            tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            
            var shortspan = document.createElement("span");
            shortspan.title = (asset.startdate ? asset.startdate : '<ics:getvar name="_NA_"/>') + ' - ' +
                (asset.enddate ? asset.enddate : '<ics:getvar name="_NA_"/>') + ' | ' + asset.name;
            var shortname = asset.name;
            if (shortname.length > 25)
                shortname = shortname.substr(0, 25) + '...';
            shortspan.innerHTML = shortname;
            tableCell.appendChild(shortspan);

            var tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode(asset.type));
        }
    },

updateEditedAssets: function(assettype, assetname, attributename, startdate, enddate) {
    //new function modified by Greg to include attributename
        var panel = fw.controlPanel;
        panel._editingStatus.innerHTML = "";
        var asset = new Object();
        asset.type = assettype;
        asset.name = assetname;
        asset.startdate = startdate;
        asset.enddate = enddate;
        if(attributename==null)//added by Greg
        {
            attributename = "-";
        }
        asset.attr = attributename;
        panel._editedAssets[panel._editedAssets.length] = asset;
        /* apparently unused
        var msg = "";
        for (var i = 0; i < panel._editedAssets.length; i++) {
            //msg += panel._editedAssets[i].type + " - " + panel._editedAssets[i].name + "\n";
            //modified by Greg
            msg += panel._editedAssets[i].type + " - " + panel._editedAssets[i].name + panel._editedAssets[i].attr + "\n";
        }
        */
        var editedAssetTable = document.getElementById("editedAssets");
        while (editedAssetTable.firstChild) {
            editedAssetTable.removeChild(editedAssetTable.firstChild);
        }

        var tableBody = document.createElement("tbody");
        editedAssetTable.appendChild(tableBody);


            var tableRow = document.createElement("tr");
            tableBody.appendChild(tableRow);
            
            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableCell.setAttribute('width','1%');
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode(" "));
            
            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode("<xlat:stream key="dvin/Common/Name" encode="false" escape="true"/>"));
            
            //added by Greg to accommodate attribute column
            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode("<xlat:stream key="dvin/AT/Flex/Attribute" encode="false" escape="true"/>"));
            
<%-- Taken out by Greg, Type is moved to the ALT tag
            var tableCell = document.createElement("td");
            tableCell.className = "tableHeader";
            tableCell.setAttribute('width','1%');
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode("Type"));
--%>
        for (var i = 0; i < panel._editedAssets.length;i++) {
            var asset = panel._editedAssets[i];
            var tableRow = document.createElement("tr");
            tableRow.className = (i%2==0?"highlightOn":"highlightOff");
            tableBody.appendChild(tableRow);
            var tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            var imgElement = document.createElement("img");
            tableCell.appendChild(imgElement);
            imgElement.onerror = function()
             {
              this.src = "<ics:getvar name="cs_imagedir"/>/OMTree/TreeImages/default.png";
             };
            imgElement.src="<ics:getvar name="cs_imagedir"/>/OMTree/TreeImages/AssetTypes/" + asset.type + ".png";
            imgElement.setAttribute('alt',asset.type);
            imgElement.setAttribute('title',asset.type);
            tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            
            var shortspan = document.createElement("span");
            shortspan.title = (asset.startdate ? asset.startdate : '<ics:getvar name="_NA_"/>') + ' - ' +
                (asset.enddate ? asset.enddate : '<ics:getvar name="_NA_"/>') + ' | ' + asset.name;
            var shortname = asset.name;
            if (shortname.length > 25)
                shortname = shortname.substr(0, 25) + '...';
            shortspan.innerHTML = shortname;
            tableCell.appendChild(shortspan);
            
            //added by Greg to accommodate attribute column
            tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode(asset.attr));
<%-- Taken out by Greg, Type is moved to the ALT tag
            var tableCell = document.createElement("td");
            tableCell.className = "tableCell";
            tableRow.appendChild(tableCell);
            tableCell.appendChild(document.createTextNode(asset.type));
--%>
        }
    },


    resetEditedAssets: function() {
        var panel = fw.controlPanel;
        var editedAssetTable = document.getElementById("editedAssets");
        if (editedAssetTable) {
            while (editedAssetTable.firstChild) {
                editedAssetTable.removeChild(editedAssetTable.firstChild);
            }
        }
        panel._editedAssets.length = 0;
        panel.setEditingStatus("<xlat:stream key="dvin/UI/AssetMgt/Therearenoasset" escape="true"/>");
    },

    setUsername: function(username) {
        try {
            this._username.innerHTML=username;
            this._userarea.style.visibility="visible";
        } catch(e) {}
    },

    refreshPreviewArea: function(mode) {
        if (mode) {
            var tab = this.getTab(mode);
            var rendermode;
            if (tab) {
                rendermode = tab.getRenderMode();
                fw.controlPanel.setTitle(tab.getTitle());
            }
            if (rendermode == null)
                rendermode = fw.RENDERMODE_NOINSITE;
            fw.controlPanel._rendermode = rendermode;
            var currentURL = this.getCurrentURL();
            if (currentURL && currentURL != "about:blank" && currentURL != "None" && !currentURL.endsWith('<ics:getvar name="stuburl"/>')) {
                currentURL = this._replaceRenderMode(currentURL, rendermode);
                this.getContentWindow().location.href=currentURL;
            }
        } else {
            if (!this.getCurrentURL().endsWith('<ics:getvar name="stuburl"/>'))
                this.getContentWindow().location.replace=this.getCurrentURL();
        }
    },

    getPreviewArea: function() {
        var previewFrame = parent.frames["Work"];
        var previewDiv = previewFrame.document.getElementById("fw_it_preview");
        if (previewDiv)
            previewDiv.style.visibility="visible";
        return previewDiv;
    },

    setEditingStatus: function(status) {
        this._editingStatus.innerHTML = status;
    },

    setPageBuilderStatus: function(status) {
        document.getElementById("pageBuilderStatusLine").style.display = 'block';
        this._pageBuilderStatus.innerHTML = status;
    },

    setTitle: function(title) {
        try {
            this._mainTitleArea.innerHTML = title;
        } catch(e) {alert(e.name + ":" + e.message);}
    },

    updatePreviewTab: function(data) {
        if (data && data.iscspage) {
            if (this._assetId != data.asset.id
                || this._assetType != data.asset.type) {
                this._assetId = data.asset.id;
                this._assetType = data.asset.type;
                this.getTemplates();
            }

            this.setAsset(data.asset);
            this.setTemplate(data.template);
            this._tname=data.template.name;
            this._iscspage=true;
        } else {
            this.clearAsset();
            this.clearTemplate();
            this._iscspage=false;
        }
    },

    initTemplateList: function() {
        var params = "AssetType=" + this._assetType + "&id=" + this._assetId + "&rendermode=" + this._rendermode;
        if (this._target)
            params += "&target=" + this._target;
        this._sendRequest(fw.REQUEST_INITTEMPLATELIST, params);
    },

    changeWrapper: function() {
        var params = "AssetType=" + this._assetType + "&id=" + this._assetId + "&rendermode=" + this._rendermode;
        if (this._target)
            params += "&target=" + this._target;
        var wrapper = this._wrappersDropDown.options[this._wrappersDropDown.selectedIndex].value;
        params += "&currentWrapper=" + wrapper;
        if (this._tname)
            params += "&defTemplate=" + this._tname;
        this._sendRequest(fw.REQUEST_CHANGEWRAPPER, params);
    },

    updateTemplateList: function(data, checkDefault) {
        if (checkDefault == null)
            checkDefault = false;
        // delete all options in selectbox
        while (this._templatesDropDown.options.length > 0)
            this._templatesDropDown.options[this._templatesDropDown.options.length-1] = null;
        while (this._wrappersDropDown.options.length > 0)
            this._wrappersDropDown.options[this._wrappersDropDown.options.length-1] = null;

        var option;
        option = new Option("--<xlat:stream key="dvin/UI/SelectTemplate" encode="false" escape="true"/>--", "None", false, false);
        this._templatesDropDown.options[0] = option;
        option = new Option("<xlat:stream key="dvin/UI/SelectWrapperpage" encode="false" escape="true"/>", "None", false, false);
        if (data) {
            var index;
            var current;
            for (var i = 0; i < data.templates.length; i++) {
                current = data.templates[i];
                option = new Option(current.tname, current.url, false, current.selected);
                if (current.selected) {this._tname=current.tname; }
                index = this._templatesDropDown.options.length;
                this._templatesDropDown.options[index] = option;
            }
            if (data.wrappers && data.wrappers.length > 0) {
                for (var i = 0; i < data.wrappers.length; i++) {
                    current = data.wrappers[i];
                    option = new Option(current.name, current.name, false, current.selected);
                    index = this._wrappersDropDown.options.length;
                    this._wrappersDropDown.options[index] = option;
                }
                if (data.wrappers.length > 1)
                    this._templateFrame.document.getElementById("wrapperArea").style.visibility="visible";
             } else {
                 this._templateFrame.document.getElementById("wrapperArea").style.visibility="hidden";
             }
             if (checkDefault)
                 this._checkDefaultTemplate(data.defaultTemplate);
        } // end if
    },

    //
    // Reloads the main content window
    //
    refreshMainArea: function() {
        this.getContentWindow().location.reload();
    },

    // Sets main content window
    //     url: (optional) URL to set in main content window
    //          if not present, use panel current URL
    setMainArea: function(url) {
        if (url)
            parent.frames["Work"].location.href=url;
        else
            parent.frames["Work"].location.href=this.getCurrentURL();
    },

    // Sets asset name/description in preview tab
    setAsset: function(asset) {
        this._previewedAssetName.innerText=asset.name;
        this._previewedAssetDescription.innerHTML=asset.description;
        this._assetTypeDescription.innerHTML=asset.typeDescription;
    },

    // Sets template name/description in preview tab
    setTemplate: function(template) {
        if (template) {
            this._templateName.innerHTML=template.name;
            this._templateDescription.innerHTML=template.description;
            //alert("template.tname=" + template.tname);
            //this._tname = template.tname;
        } else {
            clearTemplate();
        }
    },

    // Clears asset/name in preview tab
    clearAsset: function() {
        this._previewedAssetName.innerText="";
        this._previewedAssetDescription.innerText="";
        this._assetTypeDescription.innerText="";
    },

    // Clears asset/name in preview tab
    clearTemplate: function() {
        this._templateName.innerText="";
        this._templateDescription.innerText="";
        this._tname = null;
    },



    _sendRequest: function(requestId, params) {
        this._requestEngine.send(requestId, params);
    },


    getContentWindow: function() {
        return parent.frames['Work'];
    },

    //
    // Insite editor:
    // this method examines editable spans in the work area
    // and dynamically updates the editing form.
    //
    _gatherData: function() {
        var curid = null;
        var curvalue = null;
        var contentWindow = this.getContentWindow();        
        var fieldManager = contentWindow.insite.FieldManager;
        // make sure all fields are updated with most current value
        fieldManager.saveAll();        
        var formData = fieldManager.getFormData();
        var names = formData.keys();
        for ( var i = 0; i < names.length; i++ ) {
            this._addToForm(  names[ i ], formData.get( names[ i ] ) );
        }
    
        var colArr = contentWindow.colArr;
        var parentArr = new Array();
        var oNewNode;
        for(i=0; i < colArr.length; i++) {
            var reorderArr = new Array();
            var delArr = new Array();
            var col = colArr[i];
            parentArr[parentArr.length] = col.parentid + ";" + col.parenttype + ";" + col.parentfield;

            var childArr = col.childArr;

            var j;
            for (j=0; j < childArr.length; j++) {
                var child = childArr[j];
                if (child.status == 1) {
                    delArr[delArr.length] = child.assetid;
                } else {
                    if (child.assetid != child.old_assetid) {
                        reorderArr[reorderArr.length] = child.assetid + ":" + child.old_assetid;
                    }
                }
            }

            var reorderStr = reorderArr.toString();
            if (reorderStr != null && reorderStr.length > 0) {
                oNewNode = document.createElement("INPUT");
                document.forms["form1"].appendChild(oNewNode);
                oNewNode.type = 'text';
                oNewNode.style.display = 'none';
                oNewNode.value = reorderStr;
                oNewNode.name = 'col_reorder_' + col.parentid + "_" + col.parentfield;
                oNewNode.id = 'col_reorder_' + col.parentid + "_" + col.parentfield;
            }

            var delStr = delArr.toString();
            if (delStr != null && delStr.length > 0) {
                oNewNode = document.createElement("INPUT");
                document.forms["form1"].appendChild(oNewNode);
                oNewNode.type = 'text';
                oNewNode.style.display = 'none';
                oNewNode.value = delStr;
                oNewNode.name = 'col_delete_' + col.parentid + "_" + col.parentfield;
                oNewNode.id = 'col_delete_' + col.parentid + "_" + col.parentfield;
            }
        }

        var parentStr = parentArr.toString();
        if (parentStr != null && parentStr.length > 0) {
            oNewNode = document.createElement("INPUT");
            document.forms["form1"].appendChild(oNewNode);
            oNewNode.type = 'text';
            oNewNode.style.display = 'none';
            oNewNode.value = parentStr;
            oNewNode.name = 'col_parent';
            oNewNode.id = 'col_parent';
        }
    }, // end _gatherData

    _validateData: function() {
        var fieldsValidated = this.getContentWindow().insite.FieldManager.validateAll();
        if (typeof fieldsValidated != 'undefined')
        {
            return fieldsValidated;
        }
        
        
        //validate refs (not fields)
        var colArr = this.getContentWindow().colArr;
        for (i=0; i < colArr.length;i++)
        {
            var col = colArr[i];
            var childArr = col.childArr;
            //we don't actually remove child from childArr when deleting, we mark childAttr.status = 1
            //so we should validate against the status.
            if (col.isrequired)
            {
                var totalMarkForDelete = 0;
                for (j=0; j < childArr.length; j++)
                {
                    var child = childArr[j];
                    if (child.status == 1)
                    {
                        totalMarkForDelete++;
                    }
                }
                if (totalMarkForDelete == childArr.length)
                {
                    var replacestr=/Variables.displayname/ ;
                    return( "<xlat:stream key="dvin/UI/displaynameisrequiredfield" encode="false" escape="true"/>".replace( replacestr, col.parentfielddesc ) );
                }
            }
        }
    },

    setEditedAsset: function( name, field ) {
        this._assetName.innerHTML = name;
        document.getElementById("assetField").innerHTML = field;
    },
    
    _addToForm: function( name, value ) {       
        var node = document.createElement("INPUT");
        document.forms["form1"].appendChild(node);
        node.type = 'text';
        node.style.display = 'none';
        node.value = value;
        node.name = name;
        node.id = name;             
    }
} // end ControlPanel prototype

//
// page builder search results:
// handler for onclick event
//
function previewTemplate(assetid, assettype) {
    var panel = fw.controlPanel;
    if (panel.getPreviewArea()) {
        panel.setPageBuilderStatus("<xlat:stream key="fatwire/InSite/Previewingcontent" escape="true"/>");
        var params = "siteid=" + fw.controlPanel._siteid;
        var tbox = document.getElementById( "TemplatesForType" );
        var tname = tbox.options[ tbox.selectedIndex ].value;
        params = params + "&tname=" + tname + "&cid=" + assetid + "&c="  + assettype;
        panel._requestEngine.send(fw.REQUEST_PREVIEW_SLOT, params);
    } else {
        alert("<xlat:stream key="dvin/UI/TemplateCantEditedWithPageBuilder" encode="false" escape="true"/>");
    }
}

window.onload = function() {
    if (!fw.controlPanel) {
        fw.controlPanel = new fw.ControlPanel('<ics:getvar name="AssetType"/>', '<ics:getvar name="id"/>', '<ics:getvar name="mode"/>', '<ics:getvar name="target"/>');
        // assignment tab contains standard html forms (panel is reloaded for every form submit)
        if (fw.MODE_WORKFLOW == "<ics:getvar name="mode"/>") {
            fw.controlPanel.init();
        }
    }
    setPanelReady();
}

function goFinishAssignment(id, type)
{
    var url = "ContentServer?pagename=OpenMarket/Xcelerate/ControlPanel/ControlPanel";
    url = url + "&id=" + id;
    url = url + "&AssetType=" + type;
    url = url + "&mode=workflow&wfAction=AssignmentFront";
    url = url + "&assignmentAction=FinishAssignment";
    window.location = url;

}

function doFinishAssignment()
{
    AssignmentConsole.submit();
}

function cancelFinishAssignment(id, type) {
    var url = "ContentServer?pagename=OpenMarket/Xcelerate/ControlPanel/ControlPanel";
    url = url + "&id=" + id;
    url = url + "&AssetType=" + type;
    url = url + "&mode=workflow&wfAction=AssignmentFront";
    window.location = url;
}


function swap(currentImage, newImageName)
{
    if (document.images)
    {
        currentImage.src = newImageName;
    }
}

//added this for insite left nav, alert to say tab only works in IE
function checkBrowserForEditingTab()
{
    if(!<%= isBrowserSupported %>)
    {
        <% 
        StringBuffer list = new StringBuffer("\\n");
        for ( InSiteEditingUtil.SupportedBrowser browser : InSiteEditingUtil.SupportedBrowser.values() ) 
        {
            list.append( browser.getDescription() ).append( "\\n" );
        }    
        ics.SetVar( "supportedBrowsers", list.toString() );
        %>              
        alert('<xlat:stream key="dvin/UI/TheInsiteEditingtabonlyworksIE" encode="false" escape="true" evalall="true" />');
    } else
    {
        return;
    } 
}

//[KGF 2008-08-14] This function is modeled after the one above, but it is
//for the Page Layout tab button.
function checkPageLayoutPrivileges()
{
    if (!<%= isPageBuilderAllowed %>)
    {
        alert('<xlat:stream key="dvin/UI/InsufficientPrivilegesforPageLayout" encode="false" escape="true"/>');
    }
}

//[2008-01-02 KGF] Added for XHTML compatibility improvements.

//fixHTML: fixes stuff that IE likes to mess up in its innerHTML.
function fixHTML(curvalue)
{
    //undo URL mutilation for embedded links:
    curvalue = curvalue.replace(/href=\"http.*?_CSEMBEDTYPE_/g, 'href="_CSEMBEDTYPE_');
    
    //(for FCKeditor image insertion) do the same for imgs.
    //for this we need to do a bit more work...
    var docpath = window.location.href;
    docpath = docpath.substr(0, docpath.indexOf('/', 7));
    //at this point, docpath should be e.g. http://host:port
    //now construct a regexp to replace all and execute:
    docrx = new RegExp('(src=[\'"]?)' + docpath, 'g');
    curvalue = curvalue.replace(docrx, '$1');
    
    var m; //used for storing regex match results below
    if (m = curvalue.match(/<[^>]+=[^>]+>/g))
    {
        for (var i = 0; i < m.length; i++)
        {
            var newstr = '';
            var pairs = m[i].split(' ');
            var tagName = (pairs.shift()).toLowerCase();
            newstr += tagName;
            tagName = tagName.substr(1); //remove <
            for (var j = 0; j < pairs.length; j++)
            {
                if (j == pairs.length - 1) //remove tag ending
                    pairs[j] = pairs[j].replace(/\s*\/?>$/, '');
                if (pairs[j].indexOf('=') < 0)
                { //attribute has no value attached.
                    newstr += ' ' + pairs[j].toLowerCase();
                    continue;
                }
                //manually split by = only once
                var attrname = pairs[j].substr(0, pairs[j].indexOf('='));
                var attrval = pairs[j].substr(pairs[j].indexOf('=') + 1);
                //enclose value in quotes:
                if (attrval.substr(0, 1) != '"')
                    attrval = '"' + attrval;
                if (attrval.substr(attrval.length - 1) != '"')
                    attrval += '"';
                newstr += ' ' + attrname.toLowerCase() + '=' + attrval;
            }
            if (tagName == 'hr' || tagName == 'br' ||
                tagName == 'input' || tagName == 'link' ||
                tagName == 'meta' || tagName == 'img')
                newstr += ' />'; //elements with no end tag
            else
                newstr += '>';
            curvalue = curvalue.replace(m[i], newstr);
        }
    }
    //lowercase end-tags and attribless begin-tags
    while (m = curvalue.match(/<\/?[A-Z]+[\s\/:>]/))
        curvalue = curvalue.replace(m[0], m[0].toLowerCase());
    return curvalue;
}

function setPanelReady() 
{
    if (!document.readyState)
        document.readyState = "complete";
}
</cs:ftcs>
