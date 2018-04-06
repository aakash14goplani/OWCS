<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %><%
%><%@ page import="com.openmarket.xcelerate.controlpanel.InSiteEditingUtil"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Scripts/EditPanel
//
// 		A stripped-down version of the control panel, suitable in a portal environment
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs><ics:getproperty name="xcelerate.enableinsite" file="futuretense_xcel.ini" output="enableinsite"/><%
String userAgent = ics.ResolveVariables("CS.Header.User-Agent");
boolean isInsiteEnabled = "true".equals(ics.GetVar("enableinsite"));
boolean isBrowserSupported = InSiteEditingUtil.isBrowserSupported( ics );
%>
if (fw == undefined) var fw = new Object();

fw.EditPanel = function() {
    this._tabManager = new fw.TabManager();
	this._requestEngine = new fw.RequestEngine();
    this._mode = fw.MODE_EDITING;
    this._rendermode = null;
    this._isDirty = false;
    this._siteid = "<ics:getssvar name="pubid"/>";
    this._editingEnabled = <%=isInsiteEnabled && isBrowserSupported %>;
    this._editedAssets = new Array();
    
	// UI elements
    this._editingSaveBtn = null;
    this._editingCancelBtn = null;
    this._insiteSearchBtn = null;
    this._insiteForm = null;
    this._insiteFrame = null;
    this._editingStatus = null;
}

fw.EditPanel.prototype = new fw.ControlPanel();

fw.EditPanel.prototype.init = function() {
    var panel = this;
    // initialize all tabs
	panel.initTabs();
	panel._rendermode = fw.RENDERMODE_INSITE;
	panel.initUIElements();
    panel.showTab(panel._mode);
	panel.registerEvents();
}

fw.EditPanel.prototype.initTabs = function() {
	// editing tab not clickable if insite editing is off
	if (this._editingEnabled)
		this.addTab(fw.MODE_EDITING, fw.RENDERMODE_INSITE, fw.TITLE_EDITING, this.tabClickHandler);
	else
		this.addTab(fw.MODE_EDITING, fw.RENDERMODE_INSITE, fw.TITLE_EDITING);
	this.closeAllTabs();
}

fw.EditPanel.prototype.initUIElements = function() {
	this._editingSaveBtn = document.getElementById("ctrlSaveId");
    this._editingCancelBtn = document.getElementById("ctrlCancelId");
    this._insiteFrameLocation = document.getElementById("insiteFrameLocation");
    if (this._insiteFrameLocation)
    	this._insiteFrameLocation.innerHTML = "<iframe id='insiteFrame' name='insiteFrame' onload='fw.controlPanel.processSaveEdits();' src='about:blank' style='display: none;'></iframe>";
    this._insiteFrame = document.getElementById("insiteFrame");
    this._insiteForm = document.getElementById("form1");
    this._editingStatus = document.getElementById("editStatus");
    this._assetName = document.getElementById("assetName");
	this.resetEditForm(); //make sure pagename gets added
}

// overrides - in this context, content window is the opener
fw.EditPanel.prototype.getContentWindow = function() {
		return window.opener;
}

fw.EditPanel.prototype.tabClickHandler = function() {
		var mode = this.id;
		var panel = fw.controlPanel;
		panel.closeAllTabs();
		panel._mode = mode;
		panel.showTab(mode);
}

fw.EditPanel.prototype.registerEvents = function() {
	var panel = this;
	if (this._editingSaveBtn)
		this._editingSaveBtn.onclick = function() { panel.saveContentEdits(); };
	if (this._editingCancelBtn)
       	this._editingCancelBtn.onclick = function() { panel.cancelContentEdits(); };
}

// overrides method - does not do anything in this context
fw.EditPanel.prototype.updateCurrentURL = function() {}
fw.EditPanel.prototype.setTitle = function() {}
fw.EditPanel.prototype.getCurrentURL = function() {
	return this.getContentWindow().location.href;
}

// override time out
fw.EditPanel.prototype.timeOut = function() {
	this.refreshPreviewArea(fw.MODE_PREVIEW);
	window.location.reload();
}

// override onload
window.onload = function() {
    if (!fw.controlPanel) {
        fw.controlPanel = new fw.EditPanel();
        fw.controlPanel.init();
        <%-- reload after a successful login only--%>
<ics:if condition='<%=ics.GetVar("action") != null %>'>
<ics:then>fw.controlPanel.refreshPreviewArea(fw.MODE_EDITING);</ics:then>
</ics:if>
    }
    // emulate document 'readyState' flag for browsers other than IE
    if (!document.readyState)
    	document.readyState = "complete";
}
</cs:ftcs>
