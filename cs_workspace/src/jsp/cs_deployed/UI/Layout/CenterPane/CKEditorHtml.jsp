<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini" output="charset"/>
<div class="CKEditor">
	<div id="args" style="display:none;"></div>
	<div id="output" style="display:none;"></div>
	<h2 id="titleNode"></h2>
	<div class="innerBox">
		<jsp:include page="/js/fw/ui/dijit/templates/RoundedCorners.html" />
		<div dojoType="dojo.dnd.Source" accept="<%= ics.GetVar("assettypes")%>" id="previewNode" class="dropBox">&nbsp;
			<script type="dojo/connect" event="startup">
				var _MESSAGES = {
					_CHOOSE_ASSET: '<xlat:stream key="UI/UC1/CKEditor/DNDPreview" escape="true"/>',
					_CHOOSE_TEMPLATE: '<xlat:stream key="UI/UC1/CKEditor/ChooseTemplateForSelected" escape="true"/>',
					_SELF_INCLUDE_NOTALLOWED: '<xlat:stream key="dvin/UI/CannotAddSelfInclude" escape="true"/>',
					_INVALID_PAGE: '<xlat:stream key="UI/UC1/CKEditor/InvalidPage" escape="true"/>',
					_ASSET: 'Variables.asset',
					_PNAME: 'Variables.pname'
				},
				_ACTION = ['insert', 'edit'],
				_ITEM = ['asset', 'link'],
				args = dojo.byId('args').value = dojo.fromJson('<%= ics.GetVar("args")%>'),
				insiteDataService = fw.ui.ObjectFactory.createServiceObject("insite"),
				dlgMgr = fw.ui.ObjectFactory.createManagerObject('dialog'),
				previewNode = dojo.byId('previewNode'),
				dlg = dlgMgr.getEnclosingDialog(previewNode),
				advancedNode = dojo.byId('advancedNode'),
				ckEditorOkButton = dijit.byId('ckEditorOkButton'),
				ckEditorApplyButton = dijit.byId('ckEditorApplyButton'),
				errorNode = dojo.byId('errorNode'),
				linkParams = dojo.byId('linkParams'),
				wrapperSelect = dijit.byId('wrapperSelect'),
				linkAnchor = dijit.byId('linkAnchor'),
				linkText = dijit.byId('linkText'),
				paramsNode = dojo.byId('paramsNode'),
				paramsNodeButton = dojo.byId('paramsNodeButton'),
				asset,
				templatePicker,
				validate = function() {
					var actionMsg, itemMsg;
					if(!args || args === {}) {
						throw new Error('<xlat:stream key="UI/UC1/CKEditor/MissingArgs" escape="true"/>');
					}
					if(dojo.indexOf(_ACTION, args.action) < 0) {
						throw new Error('<xlat:stream key="UI/UC1/CKEditor/InvalidAction" escape="true"/>'.replace('Variables.actions',_ACTION));
					}
					if(dojo.indexOf(_ITEM, args.item) < 0) {
						throw new Error('<xlat:stream key="UI/UC1/CKEditor/InvalidItem" escape="true"/>'.replace('Variables.items',_ITEM));
					}
					if(args.item === 'asset') {
						itemMsg = '<xlat:stream key="UI/UC1/CKEditor/IncludedAsset" escape="true"/>';
						args.ttype = ['b'];	// Pagelets
						args.orientation = 'landscape';
						args.pageSize = 3;
					} else if(args.item === 'link') {
						itemMsg = '<xlat:stream key="UI/UC1/CKEditor/EmbeddedLink" escape="true"/>';
						args.ttype = ['l'];	// Layouts
						args.orientation = 'portrait';
						args.pageSize = 4;
						if(!args.linkText) {
							throw new Error('<xlat:stream key="UI/UC1/CKEditor/MissingLinkText" escape="true"/>');
						}
					}
					if(args.action === 'insert') {
						actionMsg = '<xlat:stream key="UI/UC1/CKEditor/InsertLinkTitle" escape="true"/>';
					} else if(args.action === 'edit') {
						actionMsg = '<xlat:stream key="UI/UC1/CKEditor/EditLinkTitle" escape="true"/>';
						if(!args.asset) {
							throw new Error('<xlat:stream key="UI/UC1/CKEditor/MissingAssetArg" escape="true"/>'.replace('Variables.assetarg',args.asset));
						}
					}
					dojo.byId('titleNode').innerHTML = actionMsg.replace('Variables.itemTitle',itemMsg);
				}, templateStore = new dojox.data.QueryReadStore({
					url: 'ContentServer?pagename=fatwire/ui/controller/controller&elementName=UI/Data/Template/TemplateStore&responseType=json'
				}), 
				verifyTemplate = function() {
					// Renders the asset using a template only if the template is valid
					templateStore.fetch({
						query: {
							assettype: args.asset.type,
							ttype: args.ttype
						},
						onComplete: function(items) {
							var found = dojo.some(items, function(item, i) {
								var template = fw.data.util.serializeStoreItem(templateStore, item, ['pageName', 'tname']);
								if(template.pageName === decodeURIComponent(args.pname)) {
									args.tname = template.tname;
									return true;
								}
							});
							showPreview(found);
						},
						onError: function(e) {
							throw new Error('<xlat:stream key="UI/UC1/CKEditor/ErrorTemplateName" escape="true"/>'.replace('Variables.detailedMessage',e.message));
						}
					});
				},

				showPreview = function(valid) {
					// Renders the asset using a template
					// Close the Advanced pane, so we can enable it later
					if(valid) {
						var options = [], selectedIndex = 0, tname = args.tname;
						dojo.addClass(previewNode,'dropBoxContent');
						if(!args.advanced) { args.advanced = {}; }
						// Escape the leading '/' for typeless templates and set asset type for typed templates
						dojo.xhrPost({
							url: 'ContentServer',
							content: {
								pagename: 'fatwire/ui/controller/controller',
								elementName: 'UI/Actions/Insite/SlotArgsPrompt',
								responseType: 'json',
								tname: tname.charAt(0) === '/' ? tname.slice(1) : tname,
								assetType: tname.charAt(0) === '/' ? '' : args.asset.type
							},
							handleAs: 'json',
							load: function(data) {
								if(data.cs_message) {
									delete args.templateArgs;
									ckEditorApplyButton.set('disabled', true);
									paramsNodeButton.style.display = 'none';
								} else {
									if(args.action === 'edit' && args.templateArgs) {
									// Browse through each of the supplied template args
										Object.keys(args.templateArgs).forEach(function(key){
											dojo.forEach(data.templateArguments, function(dataTarg) {
												if(dataTarg.name === args.templateArgs[key].name) {
													dataTarg.value = args.templateArgs[key].value;
												}
											});
										});
									}
									args.templateArgs = data.templateArguments;
									ckEditorApplyButton.set('disabled', false);
									paramsNodeButton.style.display = 'block';
								}
							},
							error: function(e) {
								onSessionTimeout();
								throw new Error('<xlat:stream key="UI/UC1/CKEditor/ErrorTemplateArgs" escape="true"/>'.replace('Variables.detailedMessage',e.message));
							}
						}).then(function() {
							// Enable extra parameters for link
							if(args.item === 'link') {
								ckEditorApplyButton.set('disabled', false);
								paramsNodeButton.style.display = 'block';
								dojo.xhrPost({
									url: 'ContentServer',
									content: {
										pagename: 'fatwire/ui/controller/controller',
										elementName: 'UI/Data/Template/WrapperStore',
										responseType: 'json'
									},
									handleAs: 'json',
									load: function(wrappers) {
										if(wrappers && wrappers.length > 0) {
											dojo.forEach(wrappers, function(wrapper, i) {
												selectedIndex = selectedIndex === 0 && args.advanced && args.advanced.wrapper && args.advanced.wrapper === wrapper.name ? i : selectedIndex;
												options[i] = {
													label: wrapper.name,
													value: wrapper.name,
													selected: selectedIndex > 0
												};
											});
											if(!wrapperSelect) {
												wrapperSelect = new dijit.form.Select({'class': 'wrapperSelect'}, dojo.byId('wrapperSelect'));
											}
											wrapperSelect.set('options', options);
											wrapperSelect.set('value', wrapperSelect.getOptions(selectedIndex));
											wrapperSelect.startup();
										}
									},
									error: function(e) {
										onSessionTimeout();
										throw new Error('<xlat:stream key="UI/UC1/CKEditor/ErrorWrappers" escape="true"/>'.replace('Variables.detailedMessage',e.message));
									}
								}).then(function() {
									// Render the asset in preview as if the apply button was clicked
									linkAnchor.set('value', args.advanced && args.advanced.linkAnchor ? args.advanced.linkAnchor : '');
									linkText.set('value', args.linkText ? decodeURIComponent(args.linkText) : '');
									if(args.linkText.indexOf("_%23CSEMBED_IMAGE%23_") != -1){
										dojo.byId("_linkText").style.display="none";
									}
									linkParams.style.display = 'block';
									initializeAdvancedParams();
									advancedNode.style.display = 'block';
									paramsNode.style.display = 'block';
									ckEditorOkButton.set('disabled', false);
									ckEditorApplyButton.onClick();
									dlg.layout();
								});
							} else {
								initializeAdvancedParams();
								advancedNode.style.display = 'block';
								paramsNode.style.display = 'block';
								ckEditorOkButton.set('disabled', false);
								ckEditorApplyButton.onClick();
								dlg.layout();
							}
						});
					} else {
						errorNode.innerHTML = _MESSAGES._INVALID_PAGE.replace(_MESSAGES._PNAME, args.pname);
						errorNode.style.display = 'block';
					}
				}, initializeAdvancedParams = function() {
					var queryParams = dijit.byId('queryParams'),
						args = dojo.byId('args').value,
						tname = args.tname;
					dojo.xhrPost({
						url: 'ContentServer',
						content: {
							pagename: 'fatwire/ui/controller/controller',
							elementName: 'UI/Actions/Insite/SlotArgsPrompt',
							responseType: 'html',
							tname: tname.charAt(0) === '/' ? tname.slice(1) : tname,
							assetType: tname.charAt(0) === '/' ? '' : args.asset.type
						},
						handleAs: 'text',
						load: function(data) {
							queryParams.set('content', data);
							if(args.templateArgs) {
								dojo.forEach(args.templateArgs, function(argument) {
									var argElement = dijit.byId(argument.name);	
									//  CKdialog displays a drop down if legal arguments are set else it is a text box
									if(argument.hasLegalValues){
										Object.keys(argument.legalValues).forEach(function(val){
											if(argElement && argument.value && val === decodeURIComponent(argument.value)) {
												argElement.set('value',val); // DisplayedValue
											}
										});
									} else {
										if(argElement && argument.value) {
											argElement.set('value',decodeURIComponent(argument.value)); //Displayed Value
										}
									}
								});
							}
						},
						error: function(e) {
							onSessionTimeout();
							throw new Error('<xlat:stream key="UI/UC1/CKEditor/ErrorRenderArgs" escape="true"/>'.replace('Variables.detailedMessage',e.message));
						}
					});
				}, createTemplatePicker = function() {
						var templatePickerNode = dojo.byId('templatePickerNode');
						templatePickerNode.style.display = 'block';
						templatePickerNode.style.height = '110px'; // TODO fix this
						templatePicker = new fw.ui.dijit.TemplatePicker({
								store: templateStore,
								thumbnailAttr: 'thumbnailUrl',
								queryMixin: {
									assettype: args.asset.type,
									ttype: args.ttype
								},
								orientation: args.orientation,
								pageSize: args.pageSize,
								onItemSelect: function(template) {
									// Define what happens when an item is selected on the Template Picker
									args.pname = template.pageName;
									args.tname = template.tname;
									showPreview(true);	// A template chosen from the Template picker will always be valid
								}
						},templatePickerNode);
					templatePicker.startup();
				}, onSessionTimeout =function(){
					if (window.parent) {
					var	WEM = window.parent.top.WemContext,wemCtx;
						if (WEM) {
							wemCtx = WEM.getInstance();
							if (!wemCtx.isSessionValid()) {
								wemCtx.directToTimeOutPage();
							}
						}
					}
				};
				
				validate();
				ckEditorOkButton.set('disabled', true);
				// For edit, render the asset first using incoming args
				if(args.action === 'edit') {
					ckEditorOkButton.set('disabled', false);
					verifyTemplate();
					createTemplatePicker();
					if(args.item === 'link') {
						// Set the initial values for link anchor and link text
						if(linkAnchor) {
							linkAnchor.set('value', args.advanced.linkAnchor);
						}
						if(linkText) {
							linkText.set('value', args.linkText);
						}
						if(args.linkText.indexOf("_%23CSEMBED_IMAGE%23_") != -1){
							dojo.byId("_linkText").style.display="none";
						}
					}
				} else if(args.action === 'insert') {
					previewNode.innerHTML = _MESSAGES._CHOOSE_ASSET;
				}
				// Hide the error node
				errorNode.innerHTML = '';
				errorNode.style.display = 'none';

				// Mix in asset drop zone behavior
				dojo.safeMixin(this, {
					checkAcceptance: function(source, nodes) {
						var accepts = this.accept,
							node, type,
							acceptedTypes,grid,item,data;
						//allow specification of '*' as "accept anything"
						node = nodes[0];
						if (fw.ui.dnd.util.isTreeSource(source)) {
							data=fw.ui.dnd.util.getNormalizedData(source, node);
							type=data.type;
							if(data.nodeType && data.nodeType== "adhoc")
							return false;
						} else if (fw.ui.dnd.util.isGridSource(source)) {
							item = source.getItem(node.id);
							grid = item.dndPlugin.grid;
							data = grid.store._items[item.data];
							type = grid.store.getValue(data, 'asset').type;							
						}
						if (this.accept && this.accept['*']) { return true; }
						// summary:
						//		checks if the target can accept nodes from this source
						// source: Object
						//		the source which provides items
						// nodes: Array
						//		the list of transferred items
						if(this == source){
							return !this.copyOnly || this.selfAccept;
						}
						if(!nodes || nodes.length < 1) {
							throw new Error("");
						}					
						
						acceptedTypes = Object.keys(accepts);
						if(dojo.some(acceptedTypes, function(acceptedType) {
							return acceptedType.toLowerCase() === type.toLowerCase();
						})) {
							return true;
						} else {
							dlgMgr.alert(acceptedTypes + ' are the only allowed asset types.');
							return false;
						}
					},
					onDropExternal: function(source, nodes, copy) {
						// Define what happens when an asset is dropped on the drop zone
						advancedNode.style.display = 'none';
						paramsNode.style.display = 'none';
						ckEditorApplyButton.set('disabled', true);
						ckEditorOkButton.set('disabled', true);
						// Populate asset
						var assetName = '';
						if(fw.ui.dnd.util.isTreeSource(source)) {
							args.asset = {
								id: source.tree.selectedNode.item.i.id,
								type: source.tree.selectedNode.item.i.type
							};
							assetName = source.tree.selectedNode.item.i.name;
						} else if(fw.ui.dnd.util.isGridSource(source)) {
							var ranges = dojo.map(nodes, function(node) {
									return source.getItem(node.id).data;
								}),
								items = source.getItem(nodes[0].id),
								range = ranges[0],
								store, item;
							for(var a = 1; a < ranges.length; ++a){
								range = range.concat(ranges[a]);
							}
							store = items.dndPlugin.grid.store;
							item = store._items[range];
							args.asset = fw.data.util.serializeStoreItem(store, item, ['asset']).asset;
							assetName = fw.data.util.serializeStoreItem(store, item, ['name']).name;
						}
						if ( args.asset.id == args.assetId && args.asset.type == args.assetType  )
	       				{
							previewNode.innerHTML = _MESSAGES._SELF_INCLUDE_NOTALLOWED;
							if(templatePicker)
								templatePicker.domNode.style.display='none';
							return false;
						} else {
							previewNode.innerHTML = _MESSAGES._CHOOSE_TEMPLATE.replace(_MESSAGES._ASSET, assetName);
							if(templatePicker){
								templatePicker.domNode.style.display='block';
								templatePicker.query.assettype = args.asset.type;
								templatePicker.reinitialize();
							}
							else {
								createTemplatePicker();
							}
						}
					}
				});
				dojo.connect(dlg, 'onHide', this, function() {
					this.destroy();
				});
			</script>
			<script type="dojo/method" event="onDndStart">
				// Copied this code from dojo.dnd.Source to have the css dojoDndTargetEnabled working
				//
				// summary:
				//		topic event processor for /dnd/start, called to initiate the DnD operation
				// source: Object
				//		the source which provides items
				// nodes: Array
				//		the list of transferred items
				// copy: Boolean
				//		copy items, if true, move items otherwise
				var source = arguments[0],
					nodes = arguments[1],
					copy = arguments[2];
				if(this.autoSync){ this.sync(); }
				if(this.isSource){
					this._changeState("Source", this == source ? (copy ? "Copied" : "Moved") : "");
				}
				var accepted = this.accept && this.checkAcceptance(source, nodes);
				this._changeState("Target", accepted ? "Enabled" : "Disabled");
				if(this == source){
					dojo.dnd.manager().overSource(this);
				}
				this.isDragging = true;
			</script>
		</div>
		<div id="errorNode" style="display:none;color:#f00;"></div>
	</div>
	<div id="templatePickerNode" class="templatePickerNode innerBox landscape" style="display:none;">
		<jsp:include page="/js/fw/ui/dijit/templates/RoundedCorners.html" />
	</div>
	<div id="paramsNode" class="innerBox paramsNode"  style="display:none;">
		<jsp:include page="/js/fw/ui/dijit/templates/RoundedCorners.html" />
		<div class="scrollerPaneContent">
			<div id="linkParams" class="linkParams" style="display:none;">
				<div><label><xlat:stream key="UI/UC1/CKEditor/Wrappers"/></label><div id="wrapperSelect"></div></div>
				<div><label><xlat:stream key="dvin/Common/LinkAnchor"/></label><div dojoType="fw.dijit.UIInput" id="linkAnchor" clearButton="true"></div></div>
				<div id="_linkText"><label><xlat:stream key="dvin/Common/AT/Linktext"/></label><div dojoType="fw.dijit.UIInput" id="linkText" clearButton="true"></div></div>
			</div>
			<div id="advancedNode" class="advancedNode" style="display:none;"><strong><xlat:stream key="UI/UC1/CKEditor/TemplateArguments"/></strong>
				<div id="queryParams" class="queryParams" data-dojo-type="dijit.layout.ContentPane"></div>
			</div>
		</div>
		<div id="paramsNodeButton" class="ckEditorApplyButton">
			<div id="ckEditorApplyButton" data-dojo-type="fw.ui.dijit.Button" disabled="true" data-dojo-props="buttonStyle:'greySmall'"><xlat:stream key="dvin/AdminForms/Apply"/>
				<script type="dojo/connect" event="onClick">
					var args = dojo.byId('args').value, returnArgs = dojo.clone(args),
						dlgMgr = fw.ui.ObjectFactory.createManagerObject('dialog'),
						output = dojo.byId('output'),
						query = {},
						errorNode = dojo.byId('errorNode'),
						previewNode = dojo.byId('previewNode'),
						linkText = dijit.byId('linkText'),
						linkAnchor = dijit.byId('linkAnchor'),
						wrapperSelect = dijit.byId('wrapperSelect'),
						gatherQueryParams = function(templateArgs) {
							var queryParams = '', key, value;
							if(templateArgs && templateArgs.length > 0) {
								dojo.forEach(templateArgs, function(argument, i) {
									if(i > 0) { queryParams += '&'; }
									key = argument.name,
									value = dijit.byId(key)? dijit.byId(key).value : '';
									queryParams += encodeURIComponent(key) + '=' + encodeURIComponent(value);
								});
							}
							return queryParams;
						}, gatherTemplateArgs = function(inputArgs) {
							var key, value, templateArgs = dojo.clone(inputArgs);
							dojo.forEach(templateArgs, function(argument) {
								if(dijit.byId(argument.name)) {
									argument.value = dijit.byId(argument.name).value;
								}
							});
							return templateArgs;
						}, getFieldData = function(query) {
							var link;
							if(query.item === "asset"){
								link = '<span id="_CSEMBEDTYPE_=inclusion&_PAGENAME_=';
								link += (args.action==="edit" ? query.pname: encodeURIComponent(query.pname));
								link += query.templateArgs ? ("&_ADDITIONALPARAMS_=" + encodeURIComponent(query.templateArgs) ) : "";
								link += "&_cid_=" + query.cid + "&_c_=" + query.c;
								link += (query.DEPTYPE ? ('&_deps_=exists"><i>[Asset Included (Id:' + query.cid + ";Type:" +query.c + ")]</i>"):('"><i>[Asset Included (Id:' + query.cid + ";Type:" +query.c + ")]</i>"));
								link += "</span>";
							} else if(query.item=="link") {
								if(query.linktext.indexOf("_#CSEMBED_IMAGE#_")===-1) query.linktext = query.linktext.replace(/\s/g,"&nbsp;");								
								link = '<a href="_CSEMBEDTYPE_=internal';
								link += "&_WRAPPER_=" + encodeURIComponent(query.wrapper) + "&_PAGENAME_=";
								link += (args.action==="edit" ? query.pname: encodeURIComponent(query.pname)) + "&_cid_=" + query.cid + "&_c_=" + query.c;
								link += (query.linkanchor !== '') ? ("&_frag_=" + encodeURIComponent(query.linkanchor)) : "";
								link += query.templateArgs ? ("&_ADDITIONALPARAMS_=" + encodeURIComponent(query.templateArgs)):"";
								link +='">'+ decodeURIComponent(query.linktext)+"</a>";
							}
							return link; 
						};
					returnArgs.advanced = {};
					query.item = returnArgs.item;
					query.c = returnArgs.asset.type;
					query.cid = returnArgs.asset.id;
					query.pname = returnArgs.pname;
					query.env = returnArgs.env;
					query.DEPTYPE = returnArgs.DEPTYPE;
					if(args.templateArgs) {
						returnArgs.advanced.templateArgs = gatherTemplateArgs(args.templateArgs),
						query.templateArgs = gatherQueryParams(args.templateArgs);
					}
					if(args.item === 'link') {
						returnArgs.linkText = linkText.get('value');
						returnArgs.advanced.linkAnchor = linkAnchor ? linkAnchor.get('value') : '';
						returnArgs.advanced.wrapper = wrapperSelect ? wrapperSelect.get('value') : '';
						query.linktext = returnArgs.linkText;
						query.linkanchor = returnArgs.advanced.linkAnchor;
						query.wrapper = returnArgs.advanced.wrapper;
						// Fix for PR# 28038.
						if(!dojo.string.trim(query.linktext)) {
							dlgMgr.alert('<xlat:stream key="UI/UC1/CKEditor/LinkTextCannotBeEmpty"/>');
						}
					}
					// Once we gathered all the parameters, 1) set the output object, 2) refresh the view
					returnArgs.fieldData = getFieldData(query);
					dojo.xhrPost({
						url: 'ContentServer',
						content: {
							pagename: 'fatwire/ui/controller/controller',
							elementName: 'UI/Data/CKEditor/Renderer',
							responseType: 'html',
							fieldData: returnArgs.fieldData,
							deviceid: args.deviceid
						},
						handleAs: 'text',
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded;charset=<%= ics.GetVar("charset")%>'
						},
						load: function(data) {
							errorNode.innerHTML = '';
							errorNode.style.display = 'none';
							//Data received from the server is going to be html encoded data so we need to decode it here
							var elm = document.createElement('div');
							elm.innerHTML = data;
							var unescapedData = (elm.childNodes.length === 0 ? "" : elm.childNodes[0].nodeValue);
							previewNode.innerHTML = unescapedData;
							var links = dojo.query('a', previewNode)
							if(links.length > 0) {
								dojo.forEach(links, function(link) {
									link.onclick = function() {
										return false;
									}
								});
							}
						},
						error: function(e) {
							onSessionTimeout();
							throw new Error('<xlat:stream key="UI/UC1/CKEditor/ErrorRenderArgs"/>'.replace('Variables.detailedMessage',e.message));
						}
					});
					output.value = returnArgs;
				</script>
			</div>
		</div>
	</div>
	<div class="buttonNode innerBox">
		<jsp:include page="/js/fw/ui/dijit/templates/RoundedCorners.html" />
		<div id="ckEditorOkButton" data-dojo-type="fw.ui.dijit.Button" data-dojo-props="buttonStyle:'grey',buttonType:'OK'"><xlat:stream key="UI/Forms/Ok"/>
			<script type="dojo/connect" event="onClick">
				var output = dojo.byId('output').value,
					dlgMgr = fw.ui.ObjectFactory.createManagerObject('dialog'),
					dlg = dlgMgr.getEnclosingDialog(this.domNode),
					w = SitesApp.getActiveView().contentPane.contentWindow,
					isCK = (output.isMultiVal && w.CKEDITOR) ? (w.parent.CKEDITOR.instances[output.fieldName]): w.CKEDITOR ? (w.CKEDITOR.instances[output.fieldName]) : false,
					html = output.fieldData;
				// Inspect the source of the call. It must be from ckeditor or a textfield. 
				if(!isCK) {
					var txtarea;
					var txtAreaWidget = w.dijit.byId(output.fieldName);
					if (txtAreaWidget && txtAreaWidget.editor && txtAreaWidget.editor.containerNode) {
						txtarea = txtAreaWidget.editor.containerNode;
					} else {
						txtarea = w.document.getElementsByName(output.fieldName).item(0);
					}
					if(output.env === "ie"){
						w.insertHTML_In_IE_Textarea(html,output.fieldName,output.isMultiVal);
					} else {
						var selStart = txtarea.selectionStart;
						var selEnd = txtarea.selectionEnd;
						var begin = txtarea.value.substr(0, selStart);
						var selection =(txtarea.value).substring(selStart, selEnd);
						var end = txtarea.value.substr(selEnd);
						txtarea.value =begin + html +end;
					}
				} else {
					// Get the ckeditor handle from the correct namespace depending on whether the call invocation comes web mode manage dialog or not.
					var CK = (output.isMultiVal) ? w.parent.CKEDITOR.instances[output.fieldName] : w.CKEDITOR.instances[output.fieldName];
					if(CK.getSelection()) {
						CK.getSelection().unlock(true);
					}
					w.CKUtilities.insertHTML(CK,output.fieldData);
				}
				dlg.hide();
			</script>
		</div>
		<div data-dojo-type="fw.ui.dijit.Button" data-dojo-props="buttonStyle:'grey'"><xlat:stream key="dvin/UI/Cancel"/>
			<script type="dojo/connect" event="onClick">
				var dlgMgr = fw.ui.ObjectFactory.createManagerObject('dialog'),
					dlg = dlgMgr.getEnclosingDialog(this.domNode);
				dlg.hide();
			</script>
		</div>
	</div>
</div>
</cs:ftcs>