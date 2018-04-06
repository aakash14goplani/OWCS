<%@page import="com.openmarket.xcelerate.asset.WebReferencesManager"%>
<%@page import="com.fatwire.services.beans.asset.basic.template.ArgumentBean"%>
<%@page import="com.fatwire.services.TemplateService"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.fatwire.assetapi.data.BlobObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.fatwire.assetapi.data.AssetData"%>
<%@page import="com.fatwire.assetapi.query.Query"%>
<%@page import="com.fatwire.assetapi.query.SimpleQuery"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManagerImpl"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManager"%>
<%@page import="com.openmarket.xcelerate.asset.WebRootsManager"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.fatwire.cs.core.db.Util"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="COM.FutureTense.Interfaces.IList"%>
<%@page import="com.openmarket.xcelerate.interfaces.ITemplateAssetManager"%>
<%@page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>
<%@page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// OpenMarket/Gator/AttributeTypes/WebReferences
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>

<xlat:lookup varname="urlalreadyexists" key="UI/Forms/URLAlreadyExistsForTheAsset"/>
<xlat:lookup varname="urlalreadyexistsasredirect" key="UI/Forms/URLAlreadyExistsAsRirect"/>
<xlat:lookup varname="specifyurl" key="UI/Forms/SpecifyUrl"/>
<xlat:lookup varname="invalidCharactersinURL" key="UI/Forms/InvalidCharactersNotAllowedURL"/>
<xlat:lookup varname="selectaTemplate" key="UI/Forms/SelectATemplate"/>
<xlat:lookup varname="selectaurlforredirect" key="UI/Forms/SelectAURLForRedirect"/>

<%
	String webreferencePrefix = "ContentDetails:Webreferences:";
	String assetPrefix =  ics.GetVar("Prefix");
	String inputWebreferencePrefix = assetPrefix +":Webreferences:";
	String webreference = ":Webreference:";	
	String id = ics.GetVar("id");		
%>
<script>
	dojo.require("dijit.form.Form");
	var webRefTimer;

	function deleteWebreference(index) {
		var hiddenPrefix = '<%=inputWebreferencePrefix%>'+index+'<%=webreference%>';
		var webreferenceurl = document.forms[0].elements[hiddenPrefix+'webreferenceurl'].value;
		var webrootName = document.forms[0].elements[hiddenPrefix+'webroot'].value;
		var isValid = true;
		var length = document.forms[0].elements["<%=assetPrefix%>:Webreferences:Total"].value;
		for(var i=0;i<length;i++) {
			hiddenPrefix = '<%=inputWebreferencePrefix%>'+ i +'<%=webreference%>';
			var redirectHidden = document.forms[0].elements[hiddenPrefix+'redirecturl'];
			if(redirectHidden) {
				var urlvalue = redirectHidden.value;
				var hostvalue = document.forms[0].elements[hiddenPrefix+'redirectwebroot'].value;
				if(urlvalue === webreferenceurl && webrootName === hostvalue) {
					isValid = false;
					break;
				}
			}
		}
		if(!isValid) {
			alert('<%=ics.GetVar("urlalreadyexistsasredirect")%>');
			return;
		}	
		
		var xhrArgs = {
			url: "ContentServer",
			content: {
				pagename: 'OpenMarket/Gator/Util/ValidateWebReference',
				webreferenceurl: webreferenceurl,
				host:webrootName
			},
			preventCache: true,
			handleAs: "json"
		};
		dojo.xhrPost(xhrArgs).then(function(res) {
			if(res && res.status === "success") {
				dojo.destroy(dojo.byId("WebRefTableRow1_"+index));
				dojo.destroy(dojo.byId("WebRefTableRow2_"+index));
				var doc = SitesApp.getActiveDocument();
				{
					// mark doc dirty
					doc.set('dirty', true);
				}	
				clearTable();				
			} else {
				alert(res.message);
			}
		});

		return false;
	}

	function clearTable() {
		var table, tableBody, noData;
			tableBody = dojo.byId('WebRefRecentEditTableBody');
			table = 'WebRefRecentEditTable';
			noData = 'recentEditTableNoData';
		if(tableBody) {
			var len = tableBody.getElementsByTagName('tr').length;
			if(len === 0) {
				tableBody.innerHTML = "";
				dojo.style(table, "display", "none")
				dojo.style(noData, "display", "");
			}
		}
	}

	function changeStatus(index) {
		var row = dojo.byId("WebreferencesTableRedirectRow_"+index);
		var length = document.forms[0].elements["<%=assetPrefix%>:Webreferences:Total"].value;
		var inputHiddenPrefix = '<%=inputWebreferencePrefix%>'+index +'<%=webreference%>';
		var inputStatus = document.forms[0].elements[inputHiddenPrefix +'httpstatus'].value;
		var inputRedirectUrl = document.forms[0].elements[inputHiddenPrefix +'redirecturl'].value;
		var inputinputRedirectWebRoot = document.forms[0].elements[inputHiddenPrefix +'redirectwebroot'].value;
		var radioButtondiv = dojo.byId("redirecturlcontainerdiv_"+index);
		radioButtondiv.innerHTML = "";
		dojo.query(".webRefFormRedirect").forEach(function(node) {
			node.style.display = "none";
		});
		var foundMatchingRedirect = false;
		for(var i=0;i<length;i++) {
			if(i === index) {
				continue;
			}
			var hiddenPrefix = '<%=inputWebreferencePrefix%>'+i +'<%=webreference%>';
			var element = document.forms[0].elements[hiddenPrefix+'webreferenceurl'];
			if(!element) {
				continue;
			}
			var url = element.value;
			var webroot = document.forms[0].elements[hiddenPrefix+'webroot'].value;
			var displayURL = dojo.byId("WebreferencesTableWebreferenceUrl_"+i).innerHTML;
			var urlValue = url + "__" + webroot + "::" + displayURL;
			var params = {};			
			if(inputRedirectUrl === url && inputRedirectWebRoot === webroot) {
				params = {type:"radio", name:"redirecturl_"+index, id: "redirecturl_"+index+"_"+i, value:urlValue, checked:""};
				foundMatchingRedirect = true;
			} else {
				params = {type:"radio", name:"redirecturl_"+index, id: "redirecturl_"+index+"_"+i, value:urlValue};
			}
			dojo.create("input", params, radioButtondiv);
			dojo.create("label", {innerHTML: " " + displayURL, "htmlFor": "redirecturl_"+index+"_"+i}, radioButtondiv);
			dojo.create("br", {}, radioButtondiv);			
		}
		if(!foundMatchingRedirect && inputRedirectUrl && inputRedirectUrl.length > 0) {
			if(document.forms[0].elements["redirecturl_"+index].length)	{
				document.forms[0].elements["redirecturl_"+index][i-1].checked = true;
			} else {
				document.forms[0].elements["redirecturl_"+index].checked = true;
			}	
			document.forms[0].elements["customRedirectURl_"+index].value = inputRedirectUrl;
		}
		var statusSelect = dijit.byId("httpStatusSelect_"+index);
		statusSelect.set('value',inputStatus);
		row.style.display = "block";

		return false;
	}
	
	function cancelStatusChange(index) {
		var row = dojo.byId("WebreferencesTableRedirectRow_"+index);
		var radioButtondiv = dojo.byId("redirecturlcontainerdiv_"+index);
		radioButtondiv.innerHTML = "";
		row.style.display = "none";
	}
	
	function applyStatusChange(index) {
		var row = dojo.byId("WebreferencesTableRedirectRow_"+index);
		var hiddenPrefix = '<%=inputWebreferencePrefix%>'+index +'<%=webreference%>';
		var newStatus = dijit.byId("httpStatusSelect_"+index).value;
		document.forms[0].elements[hiddenPrefix +'httpstatus'].value = newStatus;
		var statusCell = dojo.byId("WebreferencesTableHttpStatusCell_"+index);
		statusCell.innerHTML = "<img src='js/fw/images/ui/wem/" + newStatus + ".png' alt='' title='' width='28' height='45' />";
		var	displayRedirectURL;
		if(newStatus === "200") {
			document.forms[0].elements[hiddenPrefix+'redirecturl'].value = "";
		} else {
			var redirectRadios = document.forms[0].elements["redirecturl_"+index],
				redirectURL = "custom";
			for(var i=0, len = redirectRadios.length; i < len; i++) {
				if(redirectRadios[i].checked) {
					redirectURL = redirectRadios[i].value;
				}
			}
			if(redirectURL === "custom") {
				// get the value from text field
				redirectURL = document.forms[0].elements["customRedirectURl_"+index].value;
				document.forms[0].elements[hiddenPrefix+'redirectwebroot'].value = "";
				displayRedirectURL = redirectURL;
			} else {
				if(redirectURL.indexOf("::") > 0) {
					var redirectURLDisplayURL = redirectURL.split("::");
					redirectURL = redirectURLDisplayURL[0];
					displayRedirectURL = redirectURLDisplayURL[1];
					if(redirectURL.indexOf("__")) {
						var redirectURLHost = redirectURL.split("__");
						redirectURL = redirectURLHost[0];
						document.forms[0].elements[hiddenPrefix+'redirectwebroot'].value = redirectURLHost[1];
					}
				} else	{
					alert('<%=ics.GetVar("selectaurlforredirect")%>');
					return;
				}
			}
			statusCell.title = displayRedirectURL;
			document.forms[0].elements[hiddenPrefix+'redirecturl'].value = redirectURL;
		}
		row.style.display = "none";
	}
	
	function createWebreference() {
		var webreferenceurl = document.forms[0].elements["vanityURL"].value;
		var isClean  = isCleanString(webreferenceurl,'<\'">%\\&?;:',true);
		if(!isClean) 
		{
			alert('<%=ics.GetVar("invalidCharactersinURL")%>');
			return false;
		}
		var template = dijit.byId("webreferenceTemplateSelect") ? dijit.byId("webreferenceTemplateSelect").value : "";
		if(!template || template.length ==0)	{
			alert('<%=ics.GetVar("selectaTemplate")%>');			
			return;
		}
		if(dojo.trim(webreferenceurl) === "") {
			alert('<%=ics.GetVar("specifyurl")%>');
			return;
		}
		var host = "", webrootName = "Any";
		if(dijit.byId("hostSelect")) {
			host = dijit.byId("hostSelect").displayedValue;
			webrootName = dijit.byId("hostSelect").value;
		}
		var displayWebreferenceurl;
		if("Any" === webrootName) {
			if(!(webreferenceurl.charAt(0) === "/")) {
				webreferenceurl = "/" + webreferenceurl;
			}
			displayWebreferenceurl = webreferenceurl;
			webrootName = "";
		} else {
			if((host.charAt(host.length-1) === "/")) {
				displayWebreferenceurl = host + webreferenceurl;
			} else {
				displayWebreferenceurl = host + "/" + webreferenceurl;
			}
			// Host might have trailing "/" or the webreference may have leading "/""
			displayWebreferenceurl.replace("//","/");
		}
		var xhrArgs = {
				url: "ContentServer",
				content: {
					pagename: 'OpenMarket/Gator/Util/ValidateWebReference',
					webreferenceurl: webreferenceurl,
					host:webrootName,
					action:"new"
				},
				preventCache: true,
				handleAs: "json"
			};
		var isValid = true;
		var length = document.forms[0].elements["<%=assetPrefix%>:Webreferences:Total"].value;
		for(var i=0;i<length;i++) {
			var hiddenPrefix = '<%=inputWebreferencePrefix%>'+i+'<%=webreference%>';
			var element = document.forms[0].elements[hiddenPrefix+'webreferenceurl'];
			if(!element) {
				continue;
			}
			var urlvalue = element.value;
			var webrootvalue = document.forms[0].elements[hiddenPrefix+'webroot'].value;
			if(urlvalue === webreferenceurl && webrootName === webrootvalue) {
				isValid = false;
			}
		}
		if(!isValid) {
			alert('<%=ics.GetVar("urlalreadyexists")%>');
			return;
		}
		
		
		
		
		dojo.xhrPost(xhrArgs).then(function(res) {
			if(res && res.status === "success") {
				var table = dojo.byId("WebRefRecentEditTableBody");
				var index = document.forms[0].elements["<%=assetPrefix%>:Webreferences:Total"].value;
				var assetURLTotal = document.forms[0].elements["assetURLTotal"].value;
				var deviceGroupAvailable = false;
				var wrapperAvailable = false;
				var deviceGroup ="";
				if(dijit.byId("webreferenceDeviceGroupSelect"))
				{
					deviceGroup = dijit.byId("webreferenceDeviceGroupSelect").value;
					deviceGroupAvailable = true;
				}
				var argumentContentPane = dijit.byId("argumentContentPane");
				var params = "";
				if(argumentContentPane) {
					var widgets = dijit.findWidgets(argumentContentPane.domNode),
						form, values, name,paramWidgets = [], requiredWidgets = [];
					if (widgets && widgets[0]) {
						// Form is assumed to be the only widget in the advanced pane
						// (TODO there has to be a better way to get a handle to the form widget)
						form = widgets[0];
						values = form.get('value');
						paramWidgets = dijit.findWidgets(form.domNode);
						var index = 0;
						if (dojo.isArray(paramWidgets) && paramWidgets.length > 0) {
							for (var i = 0; i < paramWidgets.length; i++) {
								var widgetName = paramWidgets[i].name;
								var isRequired = paramWidgets[i].required;
								if (isRequired && dojo.trim(paramWidgets[i].get("value")) === "") {
									requiredWidgets[index] = paramWidgets[i];
									index ++;
								}
							}
						}						
						if (dojo.isArray(requiredWidgets) && requiredWidgets.length > 0) {
							var names = ""; 
							for (var j = 0; j < requiredWidgets.length ; j++) {
								requiredWidgets[j].validate();
								if (j !== 0)
									names = names + ", ";
								var widgetDomNode = requiredWidgets[j].domNode; 
								var labelNodes = dojo.query('label', widgetDomNode.parentNode.parentNode);
								names = names + labelNodes[0].title;
							}
							alert(names + '<br/>' + '<xlat:stream key="UI/Forms/SpecifyTemplateParams"/>', 'error');
							return false;
						}					
						
						for (name in values) {
							if (values.hasOwnProperty(name)) {
								//values[name] = [values[name]];
								params += name +"=" + values[name] +"&";
							}
						}
						if(params.length >1) {
							params = params.substring(0,params.length-1);
						}
					}
				}
				var wrapper ="";
				if(dijit.byId("wrapperSelect")) {
					wrapper = dijit.byId("wrapperSelect").value;
					wrapperAvailable = true;
				}
				var hiddenPrefix = '<%=inputWebreferencePrefix%>'+index +'<%=webreference%>';
				var status= "200";				
				var row = dojo.create("tr", {id: "WebRefTableRow1_"+ index, className: "tableRow" + (assetURLTotal%2)}, table);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"id", value:"-1"}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"webreferenceurl", value:webreferenceurl, className: "webreferencehiddenurl"}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"template", value:template}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"wrapper", value:wrapper}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"httpstatus", value:status}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"redirecturl", value:""}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"redirectwebroot", value:""}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"params", value:params}, row);
				dojo.create("input", {type: "hidden",name:hiddenPrefix+"webroot", value:webrootName}, row);
				if(deviceGroupAvailable) {
					dojo.create("input", {type: "hidden",name:hiddenPrefix+"dgroup", value:deviceGroup}, row);
				}
				var action = "<a href='#' onclick='changeStatus("+index+")'><xlat:stream key='UI/Forms/ChangeStatus'/></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='#' onclick='deleteWebreference("+index+")'><xlat:stream key='dvin/Common/Delete'/></a>"
				dojo.create("td", {innerHTML: action, 'class': 'nowrap'}, row);
				dojo.create("td", {innerHTML: "<xlat:stream key='dvin/Common/No'/>", className: "center"}, row);
				dojo.create("td", {innerHTML: "<img src='js/fw/images/ui/wem/"+status+".png' alt='' title='' />",  id: "WebreferencesTableHttpStatusCell_"+index, className:"center"}, row);
				var td = dojo.create("td");
				td.innerHTML = "<strong><xlat:stream key='dvin/UI/CSAdminForms/URL'/>:</strong> <span id='WebreferencesTableWebreferenceUrl_"+index+"'>"+displayWebreferenceurl+"</span>";
				var div = dojo.create("div", {id: "webRefTableDetail_"+index, className: "webRefTableDetail"});
				div.innerHTML = "<strong><xlat:stream key='dvin/UI/Template'/>:</strong>" + template;
				if(wrapperAvailable)  {
					div.innerHTML += "<br /><strong><xlat:stream key='dvin/UI/Wrapper'/>:</strong> " + wrapper;
				}
				if(deviceGroupAvailable)  {					
					div.innerHTML += "<br /><strong><xlat:stream key='dvin/UI/Admin/DeviceGroup'/>:</strong> " + dijit.byId("webreferenceDeviceGroupSelect").displayedValue;
				}
				dojo.place(div, td);
				dojo.place(td, row);
				dojo.create("div", {innerHTML: "<a href='#' onclick='updateTableDetailView("+index+", this, true,\"webref\")'><xlat:stream key='UI/Forms/ViewMore'/></a>", 'class': 'viewLink'}, td);

				var row1 = dojo.create("tr", {id: "WebRefTableRow2_"+index, className: "tableRow" + (index%2)}, table);
				var td1 = dojo.create("td", {colspan: 4, className: "webRefFormRedirectCell"}, row1);
				var div1 = dojo.create("div", {id: "WebreferencesTableRedirectRow_"+index, className: "webRefFormRedirect"}, td1);
				var div2 = dojo.create("div", {className: "webRefFormField"}, div1);
				var label1 = dojo.create("label", {className: "webRefFormLabel", innerHTML: "<xlat:stream key='UI/Forms/HttpStatus'/>:"}, div2);
				var span1 = dojo.create("span", {}, div2);
				var select = new dijit.form.Select({
					id: "httpStatusSelect_" + index,
					placeHolder: "<xlat:stream key='dvin/Common/Select'/>",
					options: [
								{label: "200", value: "200"},
								{label: "301", value: "301"},
								{label: "302", value: "302"}
							]
				}, span1);
				select.startup();
				var div3 =  dojo.create("div", {className: "webRefFormField"}, div1);
				var label2 = dojo.create("label", {className: "webRefFormLabel", innerHTML: "<xlat:stream key='UI/Forms/RedirectTo'/>:"}, div3);
				var span2 = dojo.create("span", {className: "inlineBlock"}, div3);
				dojo.create("span", {id: "redirecturlcontainerdiv_"+index}, span2);
				dojo.create("input", {type: "radio", name: "redirecturl_"+index, value: "custom"}, span2);
				dojo.create("input", {type: "text", name: "customRedirectURl_"+index, length: "70", 'class': "redirectTextBox"}, span2);
				var div4 = dojo.create("div", {className: "webRefFormButton"}, div1);
				new fw.ui.dijit.Button({
					title: "<xlat:stream key='dvin/AdminForms/Apply'/>",
					label: "<xlat:stream key='dvin/AdminForms/Apply'/>",
					onClick: function() {
						applyStatusChange(index);
					}
				}).placeAt(div4);
				new fw.ui.dijit.Button({
					title: "<xlat:stream key='UI/Forms/Cancel'/>",
					label: "<xlat:stream key='UI/Forms/Cancel'/>",
					onClick: function() {
						cancelStatusChange(index);
					}
				}).placeAt(div4);
				
				document.forms[0].elements["<%=assetPrefix%>:Webreferences:Total"].value = parseInt(index, 10) + 1;
				document.forms[0].elements["assetURLTotal"].value = parseInt(assetURLTotal, 10) + 1;
				dojo.style('WebRefRecentEditTable', 'display', 'table');
				dojo.style('recentEditTableNoData', 'display', 'none');
				clearForm();
			} else {
				alert(res.message);
			}
		});
	}

	function clearForm () {
		document.forms[0].elements["vanityURL"].value = "";
	}
	
	function showArguments() {
		var argumentPane = dijit.byId("argumentContentPane");	
		var tname = dijit.byId("webreferenceTemplateSelect").displayedValue;		
		dojo.xhrPost({
			url: 'ContentServer',
			content: {
				pagename: 'fatwire/ui/controller/controller',
				elementName: 'UI/Actions/Insite/SlotArgsPrompt',
				responseType: 'html',
				tname: tname.charAt(0) === '/' ? tname.slice(1) : tname,
				assetType: tname.charAt(0) === '/' ? '' :'<%=ics.GetVar("AssetType")%>'
			},			
			load: function(data) {
				if(data.indexOf("dijit.form.Form") >0)	{
					argumentPane.set("content",data);
				} else	{
					argumentPane.set("content","");
				}
		}});
		return false;
	}

	function updateTableDetailView(index, elem, show,tablename) {
		if(tablename == "webref") {
			var detail = dojo.byId('webRefTableDetail_'+index);
		} else {
			var detail = dojo.byId('blobRefTableDetail_'+index);
		}
		if(show) {
			detail.style.display = "block";
			elem.innerHTML = "<xlat:stream key='UI/Forms/ViewLess'/>";
			elem.onclick = function() {
				updateTableDetailView(index, this, false,tablename);
			}
		} else {
			detail.style.display = "none";
			elem.innerHTML = "<xlat:stream key='UI/Forms/ViewMore'/>";
			elem.onclick = function() {
				updateTableDetailView(index, this, true,tablename);
			}
		}
		return false;
	}

</script>
<%
	int total = Integer.parseInt(StringUtils.defaultIfEmpty(ics.GetVar("ContentDetails:Webreferences:Total"), "0"));
%>

<div class="webRefWrapper">
<div class="webRefForm">
	<div class="webRefFormField">
		<label class="webRefFormLabel"><xlat:stream key='dvin/UI/CSAdminForms/URL'/>:</label>
		<span>
			<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
				<ics:argument name="inputName" value="vanityURL"/>
				<ics:argument name="inputValue" value=''/>
				<ics:argument name="inputSize" value='32'/>
				<ics:argument name="inputMaxlength" value='128'/>
			</ics:callelement>
		</span>
	</div>
<%

	AssetDataManager adm = new AssetDataManagerImpl(ics);
	Query query = new SimpleQuery("WebRoot", null);
	query.getProperties().setIsImmediateOnly(true);
	query.getProperties().setReadAll(true);
	query.getProperties().setIsBasicSearch(true);
	Iterable<AssetData> data = adm.read(query);
	Map<String,String> hostnameMap = new HashMap<String,String>();
	Iterator<AssetData> iterator =   data.iterator();
	while (data != null && iterator.hasNext()) {
		AssetData assetdata = iterator.next();
		BlobObject current = (BlobObject)assetdata.getAttributeData("publication", false).getData();
		if(current != null)
		{
			InputStream is = current.getBinaryStream();
			if(is != null) {
				byte[] blob = new byte[ is.available() ];
				is.read( blob );
				String virtualWebRootsString =new String( blob );
				String[] publicationString = virtualWebRootsString.split(",");
				List<String> publication = Arrays.asList(publicationString);		
				if(publication.contains(ics.GetSSVar("PublicationName")) || publication.contains("0"))
				{
					String hostName = (String) assetdata.getAttributeData("name", true).getData();
					String webRoot = (String) assetdata.getAttributeData("rooturl", false).getData();
					hostnameMap.put(hostName,webRoot);
				}
			}
		}
	}
%>
<ics:if condition='<%=hostnameMap.size() >0 %>' >
<ics:then>
	<div class="webRefFormField">
		<label class="webRefFormLabel"><xlat:stream key='UI/Forms/Host'/>:</label>
		<span>
			<select dojotype="fw.dijit.UISimpleSelect" 
					id="hostSelect" 
					name="hostSelect" 
					placeHolder="<xlat:stream key='dvin/Common/Select'/>">					
					<%for (Map.Entry<String, String> entry : hostnameMap.entrySet()) {
					    String name = entry.getKey();
					    String webroot = entry.getValue(); %>
					  <option value='<%=name%>'><%=webroot%></option>
					<% } %>
			</select>
		</span>
	</div>
</ics:then>

</ics:if>	
<%	
	List<DeviceGroupBean> deviceGroupList = MobilityUtils.getDeviceGroups(ics);
	Collections.reverse(deviceGroupList);	
	Map<String,List<String>> deviceGroupMap = new HashMap<String,List<String>>();
	for(DeviceGroupBean deviceGroup:deviceGroupList)
	{
		String deviceSuffix = deviceGroup.getDeviceGroupSuffix();
		String deviceGroupName = org.apache.commons.lang.StringEscapeUtils.escapeHtml(deviceGroup.getName());
		if(deviceGroupMap.get(deviceSuffix) == null)
		{
			deviceGroupMap.put(deviceSuffix, new LinkedList<String>());
		}
		deviceGroupMap.get(deviceSuffix).add(deviceGroupName);
	}
	if(deviceGroupMap.size() >0) {
	%>

	 <div class="webRefFormField">
		<label class="webRefFormLabel"><xlat:stream key='dvin/UI/Admin/DeviceGroup'/>:</label>
		<span>			
 			<select dojotype="fw.dijit.UISimpleSelect" 
					id="webreferenceDeviceGroupSelect" 
					name="webreferenceDeviceGroupSelect"
					placeHolder="<xlat:stream key='dvin/Common/Select'/>">
				<%
					for(String deviceSuffix:deviceGroupMap.keySet()) {
						List<String> deviceGroupNameList = deviceGroupMap.get(deviceSuffix);											
					%>
						<option value='<%=deviceSuffix%>'><%=StringUtils.join(deviceGroupNameList,", ")%></option>
						<% 
					}%>
			</select>
		</span>
	</div>
	<%} %>
<div class="webRefFormField">
	<div class="webRefFormTemplateField">
		<label class="webRefFormLabel"><xlat:stream key='dvin/UI/Template'/>:</label>
		<span> 
			<asset:getlegalsubtypes type='<%=ics.GetVar("AssetType")%>' list="subtypes" pubid='<%=ics.GetVar("pubid")%>'/>
			<ics:if condition='<%=ics.GetList("subtypes")!=null && ics.GetList("subtypes").hasData()%>' >
				<ics:listloop listname="subtypes">
					<ics:listget listname="subtypes" fieldname="subtype" output="subtype"/>
				</ics:listloop>
			</ics:if>
<%  
	IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
	ITemplateAssetManager tam = (ITemplateAssetManager)atm.locateAssetManager("Template");
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TemplateService templateDataService = servicesManager.getTemplateService();
	if(ics.GetList("templates") == null) {	
		// get all templates legal for this assettype, subtype and pubid
		IList templates = tam.listUniqueNames(ics.GetVar("AssetType"), ics.GetVar("subtype"), ics.GetSSVar("pubid"), "l", null, true);
		IList filteredTemplates = MobilityUtils.getTemplates(ics, templates, ics.GetVar("AssetType"), null);
		ics.RegisterList("templates",filteredTemplates);
	}
	if(ics.GetList("templates")!=null && ics.GetList("templates").hasData()) {
 %>
	<select dojotype="fw.dijit.UISimpleSelect" 
					id="webreferenceTemplateSelect" 
					name="webreferenceTemplateSelect"
					onChange="showArguments()"
					placeHolder="<xlat:stream key='dvin/Common/Select'/>">
				<ics:if condition='<%=ics.GetList("templates")!=null && ics.GetList("templates").hasData()%>' >
					<ics:listloop listname='templates'>
						<ics:listget listname='templates' fieldname='name' output='name' />
						<ics:listget listname='templates' fieldname='tname' output='tname' />
						<option value='<%=tam.getPageName(ics.GetSSVar("PublicationName"),ics.GetVar("AssetType"),ics.GetVar("tname"))%>' <%=ics.GetVar("tname").equals(ics.GetVar("ContentDetails:template")) ? "selected=" : "" %>><%=ics.GetVar("tname")%></option>
					</ics:listloop>
				</ics:if>
				<script type="dojo/connect" event="startup">
					showArguments();
				</script>
			</select>
		</span>		
	</div>
	<div id="argumentContentPane" class="argContentPane" data-dojo-type="dijit.layout.ContentPane"></div>
	<%
	} else { %>
		<xlat:stream key='dvin/UI/Notemplatesfound'/></div>
	<% }%>
</div>
<asset:list type="SiteEntry" list="wrapperList"  field1="cs_wrapper" value1="y" pubid='<%=ics.GetSSVar("pubid") %>' excludevoided="true" order="name" />
<%if(ics.GetList("wrapperList")!=null && ics.GetList("wrapperList").hasData()) {%>
	<div class="webRefFormField">
		<label class="webRefFormLabel"><xlat:stream key='dvin/UI/Wrapper'/>:</label>
		<span>
			<select dojotype="fw.dijit.UISimpleSelect"" 
					id="wrapperSelect" 
					name="wrapperSelect" 
					placeHolder="<xlat:stream key='dvin/Common/Select'/>">
				<ics:listloop listname='wrapperList'>	
					<ics:listget listname='wrapperList' fieldname='name' output='name' />
					<option value='<%=ics.GetVar("name")%>'><%=ics.GetVar("name")%></option>
				</ics:listloop>
			</select>
		</span>
	</div>
<% } %>
	<div class="webRefFormButton">
		<div data-dojo-type='fw.ui.dijit.Button'
			data-dojo-props="
				onClick: function() {
					if (webRefTimer) clearTimeout(webRefTimer);
					webRefTimer = setTimeout(function() { createWebreference(); }, 250);
				},
				title: '<xlat:stream key='UI/Forms/Add'/>',
				label: '<xlat:stream key='UI/Forms/Add'/>'"></div>
	</div>
</div>
<input type="hidden" name='<%=assetPrefix%>:Webreferences:Total' value='<%=total%>'/>
<%
WebRootsManager webrootsManager = new WebRootsManager(ics);
Map<String,String> urlMapforDisplay = new HashMap<String, String>();
List<Integer> assetURLindexes = new ArrayList<Integer>();
List<Integer> blobURLindexes = new ArrayList<Integer>();
for (int i = 0; i < total; i++) {
		String webreferencePrefixComputed = webreferencePrefix + i +webreference;
		String inputWebreferencePrefixComputed = inputWebreferencePrefix+i+webreference;
		String webroot = ics.GetVar(webreferencePrefixComputed+"webroot");
		String webRootURL = webrootsManager.getWebRoot(webroot,null);
		String field = ics.GetVar(webreferencePrefixComputed+"field");
		String url = ics.GetVar(webreferencePrefixComputed+"webreferenceurl");
		String deviceGroup = ics.GetVar(webreferencePrefixComputed+"dgroup");
		String wrapper = ics.GetVar(webreferencePrefixComputed+"wrapper");
		if(!StringUtils.isEmpty(webRootURL)) {
			url =  webRootURL.endsWith("/") ? webRootURL + url: webRootURL +"/"+ url;
		}	
		urlMapforDisplay.put(webroot+ics.GetVar(webreferencePrefixComputed+"webreferenceurl"),url);
		if(StringUtils.isEmpty(field)) {
			assetURLindexes.add(i);
		} else {
			blobURLindexes.add(i);
		}
}%>
<input type="hidden" name='assetURLTotal' value='<%=assetURLindexes.size()%>'/>
<input type="hidden" name='blobURLTotal' value='<%=blobURLindexes.size()%>'/>
<%if(assetURLindexes.size() == 0) {%>
	<div id="recentEditTableNoData" class='webRefTableNoData'><xlat:stream key='UI/Forms/NoURL'/></div>
	<table class="webRefTable" id="WebRefRecentEditTable" style="display: none">
<% } else { %>
	<div id="recentEditTableNoData" class='webRefTableNoData' style="display: none"><xlat:stream key='UI/Forms/NoURL'/></div>
	<table class="webRefTable" id="WebRefRecentEditTable">
<% } %>
<thead>
	<tr>
		<th width="160"><xlat:stream key='dvin/UI/Admin/Action'/></th>
		<th width="120" class="center"><xlat:stream key='UI/Forms/AutoGenerated'/></th>
		<th width="70" class="center"><xlat:stream key='UI/Forms/Status'/></th>
		<th><xlat:stream key='UI/Forms/Info'/></th>
	</tr>
</thead>
<tbody id="WebRefRecentEditTableBody">
<%if(assetURLindexes.size()  > 0) {
	for (int i = 0; i < assetURLindexes.size() ; i++) {
			int index = assetURLindexes.get(i);
			String webreferencePrefixComputed = webreferencePrefix + index +webreference;
			String inputWebreferencePrefixComputed = inputWebreferencePrefix+index+webreference;
			String httpStatus = ics.GetVar(webreferencePrefixComputed+"httpstatus");
			String template = ics.GetVar(webreferencePrefixComputed+"template");
			String wrapper = ics.GetVar(webreferencePrefixComputed+"wrapper");
			String webreferenceURL = ics.GetVar(webreferencePrefixComputed+"webreferenceurl");
			String webroot = ics.GetVar(webreferencePrefixComputed+"webroot");
			String field = ics.GetVar(webreferencePrefixComputed+"field");
			String fieldIndex = ics.GetVar(webreferencePrefixComputed+"fieldindex");
			String fieldValue = ics.GetVar(webreferencePrefixComputed+"fieldvalue");
			String redirectURL = ics.GetVar(webreferencePrefixComputed+"redirecturl");
			String redirectWebRoot = ics.GetVar(webreferencePrefixComputed+"redirectwebroot");
			String deviceGroup = ics.GetVar(webreferencePrefixComputed+"dgroup");
			String params = ics.GetVar(webreferencePrefixComputed+"params");
			long patternid = Long.parseLong(ics.GetVar(webreferencePrefixComputed+"patternid"));
			boolean isRedirect = !"200".equals(httpStatus) ;		
			List<String> deviceGroupNameList = deviceGroupMap.get(deviceGroup);
			// Decode the URL for the display	
			String displayWebreferenceURL =  WebReferencesManager.decodeURL(urlMapforDisplay.get(webroot+webreferenceURL));
			String displayRedirectURL = redirectURL;
			if(StringUtils.isNotEmpty(redirectWebRoot))
			{
				displayRedirectURL = urlMapforDisplay.get(redirectWebRoot+redirectURL);
			}
			
	%>	
			<tr id="WebRefTableRow1_<%=index%>" class="tableRow<%=i%2%>">
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"id"%>' value='<%=ics.GetVar(webreferencePrefixComputed+"id")%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"webroot"%>' value='<%=webroot%>'/>
			<input type="hidden" class="webreferencehiddenurl" name='<%=inputWebreferencePrefixComputed+"webreferenceurl"%>' value='<%=webreferenceURL%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"template"%>' value='<%=template%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"wrapper"%>' value='<%=wrapper%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"httpstatus"%>' value='<%=httpStatus%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"patternid"%>' value='<%=patternid%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"createddate"%>' value='<%=ics.GetVar(webreferencePrefixComputed+"createddate")%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"params"%>' value='<%=params%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"redirecturl"%>' value='<%=redirectURL%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"redirectwebroot"%>' value='<%=redirectWebRoot%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"dgroup"%>' value='<%=deviceGroup%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"field"%>' value='<%=field%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"fieldindex"%>' value='<%=fieldIndex%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"fieldvalue"%>' value='<%=fieldValue%>'/>
			<%	if(StringUtils.isNotEmpty(field)) continue; // Blob urls are not editable. So do not display the form%>
			<td class="nowrap"><%if(patternid >0)  {%>
				<xlat:stream key='UI/Forms/NotAvailable'/>
				<% }else {	%>
				<a href='#' onclick="changeStatus(<%=index%>)"><xlat:stream key='UI/Forms/ChangeStatus'/></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href='#' onclick="deleteWebreference(<%=index%>)"><xlat:stream key='dvin/Common/Delete'/></a>
			<%} %></td>
			<td class="center"><%if(patternid >0)  {%><xlat:stream key='dvin/Common/Yes'/> <% }else { %><xlat:stream key='dvin/Common/No'/> <%} %></td>			
			<td id="WebreferencesTableHttpStatusCell_<%=index%>" class="center" title='<%="200".equals(httpStatus) ? "" : displayRedirectURL%>'><img src="js/fw/images/ui/wem/<%=httpStatus%>.png" alt="" title="" width="28" height="45" /></td>
			<td>
				<strong><xlat:stream key='dvin/UI/CSAdminForms/URL'/>:</strong> <span id="WebreferencesTableWebreferenceUrl_<%=index%>"><%=displayWebreferenceURL%></span>
				<%if(isRedirect) { %>
						<br><strong><xlat:stream key='UI/Forms/RedirectTo'/>:</strong> <%=displayRedirectURL %>
				<% } %>
				<div id="webRefTableDetail_<%=index%>" class="webRefTableDetail">
				<strong><xlat:stream key='dvin/UI/Template'/>:</strong> <%=ics.GetVar(webreferencePrefixComputed+"template")%>
				<%if(StringUtils.isNotEmpty(wrapper))  {%>
					<br /><strong><xlat:stream key='dvin/UI/Wrapper'/>:</strong> <%=wrapper%>
				<% } %>
				<%if(deviceGroupNameList!=null && deviceGroupNameList.size() > 0) { %>
					<br /><strong><xlat:stream key='dvin/UI/Admin/DeviceGroup'/>:</strong> <%=StringUtils.join(deviceGroupNameList, ",")%>
				<% } %>
				<%	if(StringUtils.isNotEmpty(params))  {
				%>
				<br /><strong><xlat:stream key='dvin/AT/Template/Parameters'/>:</strong> <br>
				<%
					String assetType = tam.getAssetTypeFromPageName(template);
					String tname = tam.getTemplateNameFromPageName(template);								
					List<ArgumentBean> templateArgs = templateDataService.getTemplateArguments( tname, assetType );
					String[] paramArr = params.split("&");
					for (String str : paramArr) {
						String paramValue = "&nbsp;&nbsp;&nbsp;&nbsp;";
						String[] strArr = str.split("=");
						for(ArgumentBean arguments:templateArgs) {
							if(strArr.length == 2) {
								if(strArr[0].equals(arguments.getName())) {
									paramValue +=arguments.getDescription() + "=";			
										if(arguments.getValues().size() > 0)
										{
											 for(Map.Entry<String,String> entry:arguments.getValues().entrySet()) {
												 String value =  entry.getKey();
												 if(value.equals(strArr[1])) {
													out.println(paramValue + entry.getValue() +"<br>");																						 
												 }
											 }
										} else {
												 out.println(paramValue + strArr[1]+"<br>");														 
										}
									}
								}
							}
						}
			 		}
				%>
				</div>
				<div class="viewLink"><a href="#" onclick="updateTableDetailView(<%=index%>, this, true,'webref')"><xlat:stream key='UI/Forms/ViewMore'/></a></div>
			</td>
		</tr>
		
		<tr id="WebRefTableRow2_<%=index%>" class="tableRow<%=index%2%>">
			<td colspan="4" class="webRefFormRedirectCell">
				<div id="WebreferencesTableRedirectRow_<%=index%>" class="webRefFormRedirect">				
					<div class="webRefFormField">
						<label class="webRefFormLabel"><xlat:stream key='UI/Forms/HttpStatus'/>:</label>
						<span>
							<select dojotype="dijit.form.Select" id="httpStatusSelect_<%=index%>" placeHolder="<xlat:stream key='dvin/Common/Select'/>">
								<option value='200'>200</option>
								<option value='301'>301</option>
								<option value='302'>302</option>
							</select>
						</span>
					</div>
					<div class="webRefFormField">
						<label class="webRefFormLabel"><xlat:stream key='UI/Forms/RedirectTo'/>:</label>
						<span class="inlineBlock">
							<span id="redirecturlcontainerdiv_<%=index%>"></span>
							<input type="radio" name="redirecturl_<%=index%>" value="custom"> <input type=text name="customRedirectURl_<%=index%>" length="70" class="redirectTextBox"/>
						</span>
					</div>
					<div class="webRefFormButton">
						<div dojotype='fw.ui.dijit.Button' title="<xlat:stream key='dvin/AdminForms/Apply'/>" label="<xlat:stream key='dvin/AdminForms/Apply'/>" onClick="applyStatusChange(<%=index%>)"></div>
						<div dojotype='fw.ui.dijit.Button' title="<xlat:stream key='UI/Forms/Cancel'/>" label="<xlat:stream key='UI/Forms/Cancel'/>" onClick="cancelStatusChange(<%=index%>)"></div>
					</div>
				</div>
			</td>
		</tr>
<%	}
	
	}
%>	</tbdody>
</table>

<%if(blobURLindexes.size()  > 0) { %>

<h3><xlat:stream key='UI/Forms/BlobURL'/></h3>
<table class="webRefTable">
	<tr>
		<th width="160"><xlat:stream key='dvin/UI/Admin/Action'/></th>
		<th width="140" class="center"><xlat:stream key='UI/Forms/AutoGenerated'/></th>
		<th width="80" class="center"><xlat:stream key='UI/Forms/Status'/></th>
		<th><xlat:stream key='UI/Forms/Info'/></th>
	</tr>
<%
	for (int i = 0; i < blobURLindexes.size() ; i++) {
		int index = blobURLindexes.get(i);
		String webreferencePrefixComputed = webreferencePrefix + index +webreference;
		String inputWebreferencePrefixComputed = inputWebreferencePrefix+index+webreference;
		String httpStatus = ics.GetVar(webreferencePrefixComputed+"httpstatus");
		String template = ics.GetVar(webreferencePrefixComputed+"template");
		String wrapper = ics.GetVar(webreferencePrefixComputed+"wrapper");
		String webreferenceURL = ics.GetVar(webreferencePrefixComputed+"webreferenceurl");
		String webroot = ics.GetVar(webreferencePrefixComputed+"webroot");
		String field = ics.GetVar(webreferencePrefixComputed+"field");
		String fieldIndex = ics.GetVar(webreferencePrefixComputed+"fieldindex");
		String fieldValue = ics.GetVar(webreferencePrefixComputed+"fieldvalue");
		String redirectURL = ics.GetVar(webreferencePrefixComputed+"redirecturl");
		String redirectWebRoot = ics.GetVar(webreferencePrefixComputed+"redirectwebroot");
		String params = ics.GetVar(webreferencePrefixComputed+"params");
		// Remove the filename from the display since we add it.
		String[] parameterString = StringUtils.split(params, ",");
		Map<String, String> parameterMap = new HashMap<String, String>();
		StringBuilder filteredParams = new StringBuilder();
		//for (String parameters : parameterString)
		for (int j = 0; j < parameterString.length; j++)
		{
			String[] parameter = StringUtils.split(parameterString[j], "=");
			if (parameter.length == 2 && !"filename".equals( parameter[0]))
			{
				if(StringUtils.isNotBlank(filteredParams.toString())) {
					filteredParams.append(",");
				}
				filteredParams.append(parameter[0]).append("=").append(parameter[1]);
			}			
		}		
		long patternid = Long.parseLong(ics.GetVar(webreferencePrefixComputed+"patternid"));
		// Decode the URL for the display	
		String displayWebreferenceURL =  WebReferencesManager.decodeURL(urlMapforDisplay.get(webroot+webreferenceURL));
		String displayRedirectURL = redirectURL;
		if(StringUtils.isNotEmpty(redirectWebRoot))
		{
			displayRedirectURL = urlMapforDisplay.get(redirectWebRoot+redirectURL);
		}
		%>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"id"%>' value='<%=ics.GetVar(webreferencePrefixComputed+"id")%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"webroot"%>' value='<%=webroot%>'/>
			<input type="hidden" class="webreferencehiddenurl" name='<%=inputWebreferencePrefixComputed+"webreferenceurl"%>' value='<%=webreferenceURL%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"template"%>' value='<%=template%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"wrapper"%>' value='<%=wrapper%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"httpstatus"%>' value='<%=httpStatus%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"patternid"%>' value='<%=patternid%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"createddate"%>' value='<%=ics.GetVar(webreferencePrefixComputed+"createddate")%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"params"%>' value='<%=params%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"redirecturl"%>' value='<%=redirectURL%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"redirectwebroot"%>' value='<%=redirectWebRoot%>'/>			
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"field"%>' value='<%=field%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"fieldindex"%>' value='<%=fieldIndex%>'/>
			<input type="hidden" name='<%=inputWebreferencePrefixComputed+"fieldvalue"%>' value='<%=fieldValue%>'/>
		<tr class="tableRow<%=i%2%>">
		<td class="nowrap"><xlat:stream key='UI/Forms/NotAvailable'/></td>
		<td class="center"><%if(patternid >0)  {%><xlat:stream key='dvin/Common/Yes'/> <% }else { %><xlat:stream key='dvin/Common/No'/> <%} %></td>
		<td class="center"><img src="js/fw/images/ui/wem/<%=httpStatus%>.png" alt="" title="" /></td>
		<td><strong><xlat:stream key='dvin/UI/CSAdminForms/URL'/>:</strong> <%=displayWebreferenceURL%>		
		<div id="blobRefTableDetail_<%=index%>" class="webRefTableDetail">
		<strong><xlat:stream key='dvin/AdminForms/FieldName'/>:</strong> <%=ics.GetVar(webreferencePrefixComputed+"field")%>		
		<%if(StringUtils.isNotEmpty(filteredParams.toString()))  {%>
					<br /><strong><xlat:stream key='dvin/AT/Template/Parameters'/>:</strong> <%=filteredParams%>
				<% } %>
		</div>
		<div class='viewLink'><a href='#' onclick='updateTableDetailView(<%=index%>, this, true,"blobref")'><xlat:stream key='UI/Forms/ViewMore'/></a></div>
		</td>
	</tr>
	<% }
	%>
	</table>
	<% 
	}
	%>
</div>
</cs:ftcs>