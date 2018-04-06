<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %><%
%><%@ page import="com.openmarket.xcelerate.controlpanel.InSiteEditingUtil"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Scripts/PreviewHelper
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
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

<satellite:link pagename="fatwire/insitetemplating/request" outstring="urlPreviewSlot" assembler="query">
	<%if(inWemFramework) {%>
			<satellite:argument name="wem" value='<%=ics.GetVar("wem")%>' />
	<%}%>
    <satellite:argument name="request" value="viewTemplate"/>
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

<satellite:link pagename="fatwire/wem/ui/Ping" outstring="wemcheckLogin" assembler="query"/>

<satellite:link outstring="stuburl"/>

<ics:getproperty name="xcelerate.enableinsite" file="futuretense_xcel.ini" output="enableinsite"/>
<ics:getproperty name="wem.enabled" file="futuretense_xcel.ini" output="wemenabled"/>

<xlat:lookup key="dvin/UI/Common/NotApplicableAbbrev" varname="_NA_" encode="false" escape="true"/>

<%

String userAgent = ics.ResolveVariables("CS.Header.User-Agent");
boolean wemEnabled = "true".equals(ics.GetVar("wemenabled"));
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

// Constants for CS rendermode
fw.RENDERMODE_NOINSITE      = "previewnoinsite";

// Page titles
fw.TITLE_PREVIEW        = '<xlat:stream key="dvin/Common/Preview" encode="false" escape="true"/>';

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
fw.REQUEST_GETTEMPLATES_ASSET = "getTemplatesForAsset";
fw.REQUEST_INITTEMPLATELIST   = "initTemplateList";
fw.REQUEST_CHANGEWRAPPER    = "changeWrapper";

fw.URL_DISASSEMBLE          = "<ics:getvar name="urlDisassemble"/>";
fw.URL_GETTEMPLATES_TYPE    = "<ics:getvar name="urlGetTemplatesForType"/>";
fw.URL_GETTEMPLATES_ASSET   = "<ics:getvar name="urlGetTemplatesForAsset"/>";
fw.URL_PREVIEW_SLOT         = "<ics:getvar name="urlPreviewSlot" />";

fw.URL_WEMCHECKLOGIN    = "<ics:getvar name="wemcheckLogin"/>";

// Content type for requests
fw.contentType = "application/x-www-form-urlencoded; charset=<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini"/>";
fw.charset="<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini"/>";
//
// Class representing a tab in the control panel
//



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
    this._requestEngine = new fw.RequestEngine();
    this._assetType = c;
    this._assetId = cid;
    mode = fw.MODE_PREVIEW;
    this._mode = mode;
    this._target = target;
    this._rendermode = null;
    this._currentURL = null;
    this._isDirty = false;
    this._siteid = "<string:stream variable="pubid"/>";
    this._iscspage = true;
    this._tname = null;

    // UI elements
    //    - TemplateSelect frame
    this._mainTitleArea = null;
    this._wrappersDropDown = null;
    this._templatesDropDown = null;
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
		console.log(' Starting ');
        var panel = fw.controlPanel;
        if (!panel._isReady()) {
            window.setTimeout(fw.controlPanel.init, 500);
            return;
        }
        panel._rendermode = fw.RENDERMODE_NOINSITE;
		panel._currentURL = panel.getSelectedTemplateURL();
        panel._registerRequests();
        panel._registerEvents();
        panel.initTemplateList();
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
            params += "&currentWrapper=" + this._wrappersDropDown.get('value');
        }

        this._sendRequest(fw.REQUEST_GETTEMPLATES_ASSET, params);
    },

    getSelectedTemplateURL: function() {
        var selectedTemplateUrl = "about:blank";
        try {
            selectedTemplateUrl = this._templatesDropDown.get('value');
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

    setDirty: function(isDirty) {
        this._isDirty = isDirty;
    },

    isDirty: function() {
        return this._isDirty;
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

    update: function() {
        var hasChanged = this.updateCurrentURL();
        if (hasChanged) {
            this.disassemble();
        }
    },
    
	_registerRequests: function() {
        this._registerRequest(fw.REQUEST_CHANGEWRAPPER,      fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processChangeWrapper);
        this._registerRequest(fw.REQUEST_DISASSEMBLE,        fw.URL_DISASSEMBLE,        "POST", this, this.processDisassemble);
        this._registerRequest(fw.REQUEST_GETTEMPLATES_ASSET, fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processGetTemplatesForAsset);
        this._registerRequest(fw.REQUEST_GETTEMPLATES_TYPE,  fw.URL_GETTEMPLATES_TYPE,  "POST", this, this.processGetTemplatesForType);
        this._registerRequest(fw.REQUEST_INITTEMPLATELIST,   fw.URL_GETTEMPLATES_ASSET, "POST", this, this.processInitTemplateList);
    },

    _registerRequest: function(requestId, requestURL, requestMethod, requestTarget, requestHandler) {
        var errorHandler = null;
        this._requestEngine.register(requestId, requestURL, requestMethod, requestTarget, requestHandler, errorHandler, fw.contentType);
    },

    _registerEvents: function() {
        var panel = this;
        this._templatesDropDown.onChange        = function() {panel.setSelectedTemplate();};
        this._wrappersDropDown.onChange            = function() {panel.changeWrapper();};
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
        var templatesDropdown = panel._templateFrame.dijit.byId("templateSelect");
        var wrappersDropdown = panel._templateFrame.dijit.byId("wrapperSelect");
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

    // PR#11927: Shared assets may not be previewable on ISE
    // Displays alert to user if there is no selected template for the current asset.
    // Possible causes:
    //     - no default template set at asset level
    //     - template is set but not found in dropdown: template is not shared
    _checkDefaultTemplate: function(defaultTemplate) {
        var selectedTemplate = this._templatesDropDown.get('value');
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
            //this.updatePreviewTab(data);
        } else {
            this.timeout();
        }
    },

    processChangeWrapper: function(request) {
        if (this._checkLogin(request)) {
            var jsonResponse = request.responseText;
            var data = dojo.fromJson(jsonResponse);
            //this.updateTemplateList(data);
            var selectedTemplateUrl = this._templatesDropDown.get('value');
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
            var selectedTemplateUrl = this._templatesDropDown.get('value');
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

    setSelectedTemplate: function() {
        var currentUrl = this._templatesDropDown.get('value');
        if (currentUrl == "None") {
            currentUrl = "about:blank";
            this._tname = null;
        }
        this.setCurrentURL(currentUrl);
        this.setMainArea(currentUrl);
    },

    getPreviewArea: function() {
        var previewFrame = parent.frames["Work"];
        var previewDiv = previewFrame.document.getElementById("fw_it_preview");
        if (previewDiv)
            previewDiv.style.visibility="visible";
        return previewDiv;
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
        var wrapper = this._wrappersDropDown.get('value');
        params += "&currentWrapper=" + wrapper;
        if (this._tname)
            params += "&defTemplate=" + this._tname;
        this._sendRequest(fw.REQUEST_CHANGEWRAPPER, params);
    },

    updateTemplateList: function(data, checkDefault) {
        if (checkDefault == null)
            checkDefault = false;
        // delete all options in selectbox            
        var selectTemplate = this._templatesDropDown.get('value');
        selectTemplate = this._templatesDropDown.store.root;
        selectTemplate.length = 0;
        this._templatesDropDown.reset();
        
        var selectWrapper = this._wrappersDropDown.get('value');
        selectWrapper = this._wrappersDropDown.store.root;
        selectWrapper.length = 0;
        this._wrappersDropDown.reset();
            
        var option;
        option = new Option("--<xlat:stream key="dvin/UI/SelectTemplate" encode="false" escape="true"/>--", "None", false, false);
        selectTemplate.options[0] = option;
        option = new Option("<xlat:stream key="dvin/UI/SelectWrapperpage" encode="false" escape="true"/>", "None", false, false);
        if (data) {
            var current;
            for (var i = 0; i < data.templates.length; i++) {
                current = data.templates[i];
                option = new Option(current.tname, current.url, false, current.selected);
                if (current.selected) {this._tname=current.tname; }
                selectTemplate.options[i + 1] = option;
               	if (current.selected) this._templatesDropDown.set('item',option);
            }
            if (data.wrappers && data.wrappers.length > 0) {
            	current = data.wrappers[0];
                option = new Option(current.name, current.name, false, true);
                selectWrapper.options[0] = option;
               	this._wrappersDropDown.set('item',option);
                for (var i = 1; i < data.wrappers.length; i++) {
                    current = data.wrappers[i];
                    option = new Option(current.name, current.name, false, current.selected);
                    selectWrapper.options[i] = option;
                   	if(current.selected) this._wrappersDropDown.set('item',option);
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

    _sendRequest: function(requestId, params) {
        this._requestEngine.send(requestId, params);
    },


    getContentWindow: function() {
        return parent.frames['Work'];
    }

} // end ControlPanel prototype


window.onload = function() {
    if (!fw.controlPanel) {
        fw.controlPanel = new fw.ControlPanel('<string:stream variable="AssetType"/>', '<string:stream variable="id"/>', '<string:stream variable="mode"/>', '<string:stream variable="target"/>');
    }
    setPanelReady();
}

function setPanelReady() 
{
    if (!document.readyState)
        document.readyState = "complete";
}
</cs:ftcs>
