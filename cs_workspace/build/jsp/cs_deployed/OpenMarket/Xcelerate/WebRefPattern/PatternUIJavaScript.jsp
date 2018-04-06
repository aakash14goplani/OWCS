<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternUIJavaScript
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urlstring"></satellite:link>
<script>
	function updateTrees(keys) {
		<% if("true".equals(ics.GetVar("showSiteTree"))) { %>
			parent.frames["XcelTree"].document.TreeApplet.updateTrees(keys);
		<% } %>	
	}
	(function() {		
		dojo.style(dojo.body(), {"overflow": "hidden"});
		dojo.require("dijit.form.Form");
	})();
	// action can be new or details or copy
	var action = "<%=ics.GetVar("action")%>";
	var createWebRefPattern = function (pattern, hostName, subtype, template, wrapper, dgroup, patternName, pubName, blobHeadersName, field){
		var patternVal = dijit.byId(pattern).get('value');
		var isClean  = isCleanString(patternVal,'\'\\;',true);
		if(!isClean) 
		{
			showMessage('<xlat:stream key="UI/Forms/InvalidCharactersNotAllowedURLPattern"/>', 'warning');
			return false;
		}
		var nameVal = dijit.byId(patternName).get('value');
		isClean  = isCleanString(nameVal,'<\'">%\\&?;:',true);
		if(!isClean) 
		{
			showMessage('<xlat:stream key="UI/Forms/InvalidCharactersNotAllowedURLName"/>', 'warning');
			return false;
		}
		if(dojo.trim(nameVal) === "") {
			showMessage('<xlat:stream key="dvin/UI/Admin/Error/specifyaname"/>', 'warning');
			return false;
		}
		if(dojo.trim(patternVal) === "") {
			showMessage('<xlat:stream key="UI/Forms/SpecifyTheURLPattern"/>', 'warning');
			return false;
		}
		var pubVal = dijit.byId(pubName).get('displayedValue');
		var hostNameVal = dijit.byId(hostName).get('value');
		if(dojo.trim(hostNameVal) === "") {
			showMessage('<xlat:stream key="UI/Forms/SpecifyHost"/>', 'warning');
			return false;
		}
		var DGroupVal = dijit.byId(dgroup).get("value");
		var subtypeVal = dijit.byId(subtype).get('value');
		var wrapperVal = dijit.byId(wrapper).get('value');		
		var assetTypeVal = '<%=ics.GetVar("assettype")%>';
		var argumentContentPane = dijit.byId("argumentContentPane");
		var params = "";
		var patternType = "";		
		dojo.query('input[name=FieldType]').forEach(function(node){
			if (node.checked) patternType = node.value;
		});
		if(argumentContentPane) {
			var widgets = dijit.findWidgets(argumentContentPane.domNode),
				form, values, name;
			if (widgets && widgets[0]) {
				// Form is assumed to be the only widget in the advanced pane
				// (TODO there has to be a better way to get a handle to the form widget)
				form = widgets[0];
				values = form.get('value');
				for (name in values) {
					if (values.hasOwnProperty(name)) {
						//values[name] = [values[name]];
						params += name +"=" + values[name] +"&";
					}
				}
				if(params.length > 1) {
					params = params.substring(0,params.length-1);
				}
			}
		}
		var widgetsRequired = validateParams();
		if (dojo.isArray(widgetsRequired) && widgetsRequired.length > 0) {
			var names = ""; 
			for (var j = 0; j < widgetsRequired.length ; j++) {
				widgetsRequired[j].validate();
				if (j !== 0)
					names = names + ", ";
				var widgetDomNode = widgetsRequired[j].domNode; 
				var labelNodes = dojo.query('label', widgetDomNode.parentNode.parentNode);
				names = names + labelNodes[0].title;
			}
			showMessage(names + '<br/>' + '<xlat:stream key="UI/Forms/SpecifyTemplateParams"/>', 'warning');
			return false;
		}
		var pattern = {
			"id": dojo.byId("patternID").value !== "" ? dojo.byId("patternID").value : "-1" ,
			"assettype": assetTypeVal,
			"subtype": subtypeVal,
			"pattern": patternVal,
			"name": nameVal,
			"publication": pubVal,
			"webroot": hostNameVal
		};
		
		if (patternType === "Asset") {
			pattern["wrapper"] = wrapperVal;
			pattern["dgroup"] = DGroupVal;			
			pattern["template"] = dijit.byId(template).store.getValue(dijit.byId(template).item, 'value', '');
			pattern["params"] = params;
		}
		
		if (patternType === "Blob") {
			var fieldVal = dijit.byId(field).get('value');
			if(dojo.trim(fieldVal) === "") {
				showMessage('<xlat:stream key="UI/Forms/SpecifyField"/>', 'warning');
				return false;
			}
			var blobHeaders = dijit.byId(blobHeadersName).get("value");
			var isDownloadable = dojo.byId("isDownloadable").checked;
			if(isDownloadable) {				
				if (dojo.trim(blobHeaders).length > 0) {
					blobHeaders = dojo.trim(blobHeaders);
					var headLength = blobHeaders.length;
					if (blobHeaders.charAt(headLength - 1) === ",")
						blobHeaders =  blobHeaders + "content-disposition=attachment";
					else
						blobHeaders =  blobHeaders +  ",content-disposition=attachment";
				}
				else
					blobHeaders = "content-disposition=attachment";
			}
			if (dojo.trim(blobHeaders).length > 0) {
				blobHeaders = blobHeaders.replace(/\r\n/g, "").replace(/\n/g, ""); 
			}
			pattern["field"] = fieldVal;
			pattern["params"] = blobHeaders;
		}
		if (!pattern.template) showMessage('<xlat:stream key="dvin/UI/displaynameisrequiredfield"/>'.replace("Variables.displayname", '<xlat:stream key="dvin/UI/Template"/>'), 'error');
		if (!pattern.pattern) showMessage('<xlat:stream key="dvin/UI/displaynameisrequiredfield"/>'.replace("Variables.displayname", '<xlat:stream key="UI/Forms/Pattern"/>'), 'error');
		var	data = [pattern];
		var xhrArgs = {
			url: "ContentServer",
			content: {
				pagename: "OpenMarket/Xcelerate/WebRefPattern/PatternSave",
				patterns: dojo.toJson(data),
				responseType: "json"
			},
			preventCache: true,					
			handleAs: "json"
		};
		showMessage('<xlat:stream key="fatwire/InSite/Saving"/>', 'info');
		dojo.xhrPost(xhrArgs).then(function(res) {
			if (res.error && res.error === "TimeOut") {
				parent.parent.location="<%=ics.GetVar("urlstring")%>";
				return;
			}
			dijit.byId('assetID')._clearInput();
			dojo.byId('vanityURLEval').innerHTML = '';
			dojo.byId('evalBlobHeader').innerHTML = '';
			if (res.status === "success") 
			{
				showMessage('<xlat:stream key="UI/Forms/PatternSaveSuccess"/>', 'info');
				dojo.byId('patternID').value = res.patternId;				
				updateTrees('Self:<%=ics.GetVar("assettype")%>_WebRefPattern');
			}
			else 
			{
				showMessage(res.message, 'error');
			}	
				
		}, function(err){
			showMessage('<xlat:stream key="UI/UC1/Layout/InsiteMessage1"/>', 'error');
		});
		return false;
	};
	var createWebreferencePattern = function (pattern, hostName, subtype, template, wrapper, dgroup, assetID,  patternName, pubName, blobHeadersName, field){
		var patternVal = dijit.byId(pattern).get('value');
		var nameVal = dijit.byId(patternName).get('value');
		var pubVal = dijit.byId(pubName).get('displayedValue');
		var hostNameVal = dijit.byId(hostName).get('value');
		var subtypeVal = dijit.byId(subtype).get('value');
		var wrapperVal = dijit.byId(wrapper).get('value');
		var DGroupVal = dijit.byId(dgroup).get("value");
		var filteringSelect = dijit.byId(assetID);
		var assetTypeVal = '<%=ics.GetVar("assettype")%>';		
		var patternType = "";
		dojo.query('input[name=FieldType]').forEach(function(node){
			if (node.checked) patternType = node.value;
		});
		var pattern = {
			"id": dojo.byId("patternID").value !== "" ? dojo.byId("patternID").value : "-1" ,
			"assettype": assetTypeVal,
			"subtype": subtypeVal,
			"pattern": patternVal,
			"name": nameVal,
			"publication": pubVal
		};
		
		if (patternType === "Asset") {
			pattern["wrapper"] = wrapperVal;
			pattern["dgroup"] = DGroupVal;
			pattern["webroot"] = hostNameVal;
			pattern["template"] = dijit.byId(template).store.getValue(dijit.byId(template).item, 'value', '');
		}
		
		if (patternType === "Blob") {
			var fieldVal = dijit.byId(field).get('value');
			var blobHeaders = dijit.byId(blobHeadersName).get("value");
			pattern["field"] = fieldVal;
			pattern["params"] = blobHeaders;
		}
		if (!patternVal) showMessage('<xlat:stream key="UI/Forms/SpecifyTheURLPattern"/>', 'error');
		var	data = [pattern];
		var xhrArgs = {
			url: "ContentServer",
			content: {
				pagename: "OpenMarket/Xcelerate/WebRefPattern/PatternEvaluate",
				patterns: dojo.toJson(data),
				assetId: filteringSelect.store.getValue(filteringSelect.item, 'id', ''),
				responseType: "json"
			},
			preventCache: true,					
			handleAs: "json",
			action: "eval"
		};
		if (patternVal)
		{
			showMessage('<xlat:stream key="dvin/UI/Loadingdotdotdot"/>', 'info');
			dojo.xhrPost(xhrArgs).then(function(res) {
				if (res.error && res.error === "TimeOut") {
					parent.parent.location="<%=ics.GetVar("urlstring")%>";
					return;
				}
				var host;
				if (dijit.byId(hostName)) 
					host = dijit.byId(hostName).get('displayedValue');			
				if (res.pattern) {
					dojo.byId('vanityURLEval').innerHTML = resolveURL(res.pattern, host);
					showMessage('<xlat:stream key="dvin/Common/Success"/>', 'info');
				}
				else if (dojo.isArray(res.patterns) && res.patterns.length > 0) {
					var patternArray = res.patterns;
					for (var ij = 0; ij < patternArray.length; ij++) {
						patternArray[ij] = resolveURL(patternArray[ij], host);
					}
					dojo.byId('vanityURLEval').innerHTML = res.patterns.join("<br/>");
					showMessage('<xlat:stream key="dvin/Common/Success"/>', 'info');
				}
				else
					showMessage('<xlat:stream key="UI/Forms/PatternEvaluationFailed"/>', 'error');
					
				if (res.blobHeaders)
					dojo.byId('evalBlobHeader').innerHTML = res.blobHeaders;				
				
			}, function(err){
				showMessage('<xlat:stream key="UI/Forms/PatternEvaluationFailed"/>', 'error');
			});
		}
	};
	var getAssetAttributes = function (filteringSelect) { 
		var value = filteringSelect.get('value'),
			contentQuery = {
				assetType: '<%=ics.GetVar("assettype")%>',
				subtype: filteringSelect.store.getIdentity(filteringSelect.item)
			};
		dijit.byId("searchGrid_contentAttr").set("query", contentQuery);
		dijit.byId("searchGrid_contentAttr")._fetch(0, false);
	};
	var refreshTemplateSelect = function (subtypeSelect, templateSelect, publicationSelect){
		var queryObject = {},
			templateStore = templateSelect.store;
		if (subtypeSelect && subtypeSelect.get('value') && subtypeSelect.get('value') !== '<xlat:stream key="dvin/Common/Any" escape="true"/>') {
			queryObject.subtype = subtypeSelect.get('value');
		}
		queryObject.publicationId = publicationSelect.get('value');
		queryObject.publicationName = publicationSelect.get('displayedValue');
		templateSelect.set('query', queryObject);
		templateStore.close();
		templateSelect.reset();
	};
	var refreshFieldSelect = function (subtypeSelect, fieldSelect, publicationSelect){
		var queryObject = {},
			fieldStore = fieldSelect.store;
		if (subtypeSelect && subtypeSelect.get('value') && subtypeSelect.get('value') !== '<xlat:stream key="dvin/Common/Any" escape="true"/>') {
			queryObject.subtype = subtypeSelect.get('value');
		}
		queryObject.publicationId = publicationSelect.get('value');
		queryObject.publicationName = publicationSelect.get('displayedValue');
		fieldSelect.set('query', queryObject);
		fieldStore.close();
		fieldSelect.reset();
	};
	var showMessage = function(message, type) {
		var msgBox = dojo.byId('msgBoxWrapper');
		var msgContent = dojo.byId('msgBoxForPattern');
		if(message) {
			dojo.removeClass(msgBox, "message-info message-error message-warning");
			if(type) {
				dojo.addClass(msgBox, "message-" + type);
			} else {
				dojo.addClass(msgBox, "message-info");
			}
			msgContent.innerHTML = message;
			msgBox.style.display = "block";
		}
		
	};
	var closeMessage = function() {
		var msgBox = dojo.byId('msgBoxWrapper');
		var msgContent = dojo.byId('msgBoxForPattern');
		msgContent.innerHTML = "";
		msgBox.style.display = "none";
	};
	
	var showArguments = function (templateSelect, KeyValObj) {
		var argumentPane = dijit.byId("argumentContentPane");	
		var tname = templateSelect.get("displayedValue");		
		dojo.xhrPost({
			url: 'ContentServer',
			content: {
				pagename: 'OpenMarket/Xcelerate/WebRefPattern/ShowTemplateParams',
				responseType: 'html',
				tname: tname.charAt(0) === '/' ? tname.slice(1) : tname,
				assetType: tname.charAt(0) === '/' ? '' :'<%=ics.GetVar("assettype")%>'
			},			
			load: function(data) {
				if(data.indexOf("dijit.form.Form") >0) {
					if (dojo.isObject(KeyValObj)) {
						var paramSetterHandler = dojo.connect(argumentPane, "onLoad", function(){
							var formWidgets = getTemplateParamsWidgets(this);
							if (dojo.isArray(formWidgets) && formWidgets.length > 0) {
								for (var i = 0; i < formWidgets.length; i++) {
									var widgetName = formWidgets[i].name; 
									if (KeyValObj[widgetName]) 
										formWidgets[i].set("value", KeyValObj[widgetName]);
								}
							}					
							dojo.disconnect(paramSetterHandler);
						});
					}
					dojo.style(argumentPane.domNode, {"display": "inline-block"});
					argumentPane.set("content",data);					
				} else	{					
					argumentPane.set("content","");
					dojo.style(argumentPane.domNode, {"display": "none"});
				}
		}});
		return false;
	};

	var makeButtonActive = function(button, index) {
		var stack = dijit.byId("webRefTabContainer");
		stack.selectChild(stack.getChildren()[index]);
		for(var i=0;i<2;i++) {
			dijit.byId('tabButton'+i).set('selected', false);
		}
		button.set('selected', true);
	};
	
	var getTemplateParamsWidgets = function(cPane){
		var widgets = dijit.findWidgets(cPane.domNode),
			paramWidgets = [];
		if (dojo.isArray(widgets) && widgets.length === 1 && widgets[0].declaredClass === "dijit.form.Form")
			paramWidgets = dijit.findWidgets(widgets[0].domNode);
		return paramWidgets;
	};
	
	var validateParams = function(){
		var formWidgets = getTemplateParamsWidgets(dijit.byId("argumentContentPane"));
		var requiredWidgets = [];
		var index = 0;
		if (dojo.isArray(formWidgets) && formWidgets.length > 0) {
			for (var i = 0; i < formWidgets.length; i++) {
				var widgetName = formWidgets[i].name;
				var isRequired = formWidgets[i].required;
				if (isRequired && dojo.trim(formWidgets[i].get("value")) === "") {
					requiredWidgets[index] = formWidgets[i];
					index ++;
				}
			}
		}
		return requiredWidgets;
	};
	
	var showRelevantFormFields = function(value) {
		if (value === "Blob") {
			showBlobPatternFields();
			hideAssetPatternFields();
			updateSubtypeSelect(true);
		}
		else {
			showAssetPatternFields();
			hideBlobPatternFields();
			updateSubtypeSelect(false);
			
		}
		return false;
	};
	
	var showBlobPatternFields = function (){
		dojo.style(dojo.byId("fieldSelect").parentNode, {"display": ""});
		dojo.style(dojo.byId("blobHeaders").parentNode, {"display": ""});
		dojo.style(dojo.byId("blobPatternHelpText"), {"display": ""});
		dojo.style(dojo.byId("evalBlobHeader").parentNode, {"display": ""});		
	};
	
	var hideBlobPatternFields = function (){
		dojo.style(dojo.byId("fieldSelect").parentNode, {"display": "none"});
		dojo.style(dojo.byId("blobHeaders").parentNode, {"display": "none"});
		dojo.style(dojo.byId("blobPatternHelpText"), {"display": "none"});
		dojo.style(dojo.byId("evalBlobHeader").parentNode, {"display": "none"});
	};
	
	var showAssetPatternFields = function (){
		dojo.style(dojo.byId("templateSelect").parentNode, {"display": ""});
		dojo.style(dojo.byId("wrapperSelect").parentNode, {"display": ""});
		dojo.style(dojo.byId("deviceGroupSelect").parentNode, {"display": ""});
		dojo.style(dojo.byId("argumentContentPane"), {"display": ""});
		dojo.style(dojo.byId("assetPatternHelpText"), {"display": ""});
	};
	
	var hideAssetPatternFields = function (){
		dojo.style(dojo.byId("templateSelect").parentNode, {"display": "none"});
		dojo.style(dojo.byId("wrapperSelect").parentNode, {"display": "none"});
		dojo.style(dojo.byId("deviceGroupSelect").parentNode, {"display": "none"});
		dojo.style(dojo.byId("argumentContentPane"), {"display": "none"});
		dojo.style(dojo.byId("assetPatternHelpText"), {"display": "none"});
	};
	
	var updateSubtypeSelect = function (isBlobType) {
		var subtypeSelect = dijit.byId('subtypeSelect');
		var publicationSelect = dijit.byId("pubSelect");
		var queryobj = {};
		if (isBlobType)
			queryobj = {
				'publicationId': publicationSelect.get('value'),
				'isBlobURLType': "true"
			}
		else
			queryobj = {
				'publicationId': publicationSelect.get('value')
			}
		subtypeSelect.set('query', queryobj);	
		subtypeSelect.store.fetch({
			query: queryobj,
			onComplete: function(items) {
				if (items.length > 0) {					
					subtypeSelect.set("value", subtypeSelect.store.getValue(items[0], 'value'));				
				}
				else {
					subtypeSelect.set("value", "");
				}
				getAssetAttributes(subtypeSelect); 
				dijit.byId('assetID').set('query', {
					'assetSubType': subtypeSelect.get('value') && subtypeSelect.get('value') !== 'Any' ? subtypeSelect.get('value') : '',
					'publicationId': publicationSelect.get('value')
				});
				refreshTemplateSelect(subtypeSelect, dijit.byId('templateSelect'), dijit.byId('pubSelect'));
				refreshFieldSelect(subtypeSelect, dijit.byId('fieldSelect'), dijit.byId('pubSelect'));
			}
		});		
	};
	
	var resolveURL = function (pattern, webRoot) {
		var displayWebreferenceurl,
			webreferenceurl = pattern;
		if(!webRoot) {
			if(!(webreferenceurl.charAt(0) === "/")) {
				webreferenceurl = "/" + webreferenceurl;
			}
			displayWebreferenceurl = webreferenceurl;
		} else {
			if((webRoot.charAt(webRoot.length) === "/")) {
				displayWebreferenceurl = webRoot + webreferenceurl;
			} else {
				displayWebreferenceurl = webRoot + "/" + webreferenceurl;
			}
		}
		return displayWebreferenceurl;
	};
</script>
</cs:ftcs>