<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="url" uri="futuretense_cs/url.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/RenderSWFUpload
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects"%>
<%@ page import="com.openmarket.xcelerate.common.TempObjects"%>
<%@page import="com.fatwire.ui.util.InsiteUtil"%>

<%@ page import="com.fatwire.util.BlobUtil"%>
<cs:ftcs>
<ics:getproperty name="form.defaultMaxValues" file="futuretense_xcel.ini" output="MAXVALUES" />
<ics:getproperty name="cs.disableSWFFlashUploader" file="futuretense_xcel.ini" output="forceHTMLUploader" />
<%
	String forceHTMLUploader = ics.GetVar("forceHTMLUploader");
	if (!Utilities.goodString(forceHTMLUploader))
		forceHTMLUploader = "false";	
	boolean isSingleValued = "single".equals(ics.GetVar("EditingStyle"));
	String strIsReq = "true".equals(ics.GetVar("RequiredAttr")) ? "True" : "False";
	
	StringBuilder tmpVal = new StringBuilder("");
	String urlValue = "";
	String fileName = "";
	byte[] fileData = null;
	String folder = "";
	String fileType = "";
	String fileTypes = ics.GetVar("FILETYPES") != null && ics.GetVar("FILETYPES").trim().length() > 0 ? ics.GetVar("FILETYPES").trim() : "*.*";
	String maxFileSize = ics.GetVar("MAXFILESIZE") != null && ics.GetVar("MAXFILESIZE").trim().length() > 0  ? ics.GetVar("MAXFILESIZE").trim() : "1024 MB";
	String minWidth = ics.GetVar("MINWIDTH") != null && ics.GetVar("MINWIDTH").trim().length() > 0  ? ics.GetVar("MINWIDTH").replaceAll("(?i)px", "").trim() : "0";
	String maxWidth = ics.GetVar("MAXWIDTH") != null && ics.GetVar("MAXWIDTH").trim().length() > 0  ? ics.GetVar("MAXWIDTH").replaceAll("(?i)px", "").trim() : "-1";
	String minHeight = ics.GetVar("MINHEIGTH") != null && ics.GetVar("MINHEIGTH").trim().length() > 0 ? ics.GetVar("MINHEIGTH").replaceAll("(?i)px", "").trim() : "0";
	String maxHeight = ics.GetVar("MAXHEIGHT") != null && ics.GetVar("MAXHEIGHT").trim().length() > 0  ? ics.GetVar("MAXHEIGHT").replaceAll("(?i)px", "").trim() : "-1";
	String tempObjId = "";
	String form_defaultMaxValues = ics.GetVar("MAXVALUES");
	String attr_MaxValues = ics.GetVar("OVERRIDEMAXVALUES");
	if (null == attr_MaxValues || "-1".equals(attr_MaxValues)) {
		if (null == form_defaultMaxValues) 
			form_defaultMaxValues = "-1";
	} else {
		form_defaultMaxValues = attr_MaxValues;
	}
%>

<tr>
	<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName'/>
	<td><br/></td>

<script type='text/javascript'>

dojo.addOnLoad(function() {
	var currInputName = '<%=ics.GetVar("cs_CurrentInputName")%>';
	var _authkey_= document.getElementsByName("_authkey_")[0].value;
	var fileUploader = new fw.ui.dijit.form.FormUploader({
		token: '<%= InsiteUtil.getUploadToken(ics) %>', 
		_authtoken_: '<%= (String)session.getAttribute("csrfuuid") %>',
		sessionid: '<%= session.getId() %>',
		single: <%= isSingleValued %>,
		multiple: <%= !isSingleValued %>,
		value: [<%= ics.GetObj("strAttrValues") %>],
		maxVals: '<%= form_defaultMaxValues %>',
		maxFileSize: '<%= maxFileSize %>',
		fileTypes: '<%= fileTypes %>',
		minWidth: '<%= minWidth %>',
		maxWidth: '<%= maxWidth %>',
		minHeight: '<%= minHeight %>',
		maxHeight: '<%= maxHeight %>',
		_authkey_:_authkey_,
		forceHTMLUploader: <%=forceHTMLUploader.toLowerCase()%>,
		
		<% if("ucform".equals(ics.GetVar("cs_environment"))) { %>
			cs_environment: "ucform",
		<% } %>
		
		getMultipleInputNamePrefix: function() {
			return '<%= ics.GetVar("cs_SingleInputName") %>';
		},
		
		regenReqInfoVal: function(numOfValues) {
			console.group('[MultiValuedClarkiiEditor] - regenReqInfoVal:', arguments);
			
			var	self = this,
				jsMultipleInputNamePrefix = self.getMultipleInputNamePrefix(),
				jsRequiredInfoNode,
				jsReqInfoVal = '',
				isReq = '<%= ics.GetVar("RequiredAttr") %>'
				newNumOfValues = numOfValues || self._getValueAttr().length;
				
			isReq = 'true' == isReq ? 'True' : 'False';
			
			if (dojo.isIE)
				jsRequiredInfoNode = document.getElementsByName("<%=ics.GetVar("AttrNumber")%>RequireInfo")[0];
			else
				jsRequiredInfoNode = dojo.query('[name="<%=ics.GetVar("AttrNumber")%>RequireInfo"]')[0];
			console.debug('Before - jsRequiredInfoNode: ', jsRequiredInfoNode);

			if (this.multiple) {
				for (var i = 0; i < newNumOfValues; i++) {
					jsReqInfoVal = jsReqInfoVal + '*' + jsMultipleInputNamePrefix + '_' + (i + 1) + '*' + '<%=ics.GetVar("AttrName")%>' + '*' + 'Req' + isReq + '*' + '<%=ics.GetVar("AttrType")%>!';
				}				
			} else {
				jsReqInfoVal = '*' + jsMultipleInputNamePrefix + '*' + '<%=ics.GetVar("AttrName")%>' + '*' + 'Req' + isReq + '*' + '<%=ics.GetVar("AttrType")%>!';
			}
						
			dojo.attr(jsRequiredInfoNode, 'value', jsReqInfoVal);
			console.debug('After - jsRequiredInfoNode: ', jsRequiredInfoNode);
			console.groupEnd();
			return jsRequiredInfoNode;	
		},
		
		regenAttrVCNode: function() {
			console.group('[MultiValuedClarkiiEditor] - regenAttrVCNode:', arguments);
			
			var self = this,
				attrVCNode;
		
			if (dojo.isIE)
				attrVCNode = document.getElementsByName("<%=ics.GetVar("AttrName")%>VC")[0];
			else
				attrVCNode = dojo.query('[name="<%=ics.GetVar("AttrName")%>VC"]')[0];
		
			dojo.attr(attrVCNode, 'value', self._getValueAttr().length);
			
			console.debug('attrVCNode: ', attrVCNode);
			console.groupEnd();
			return attrVCNode;			
		},
		
		deleteTempObjectId: function(tempId){
			if(dojo.isString(tempId)) {
				dojo.xhrGet({
	        		url: 'ContentServer',
	        		sync: false,
	        		content: {
						pagename: 'OpenMarket/Gator/AttributeTypes/DeleteTempObjectIds',
						toDeleteTempObjId: tempId
	        		},
	        		
	        		load: function(response, ioargs) {
	    				console.log('response: ', response);
						console.log('ioargs: ', ioargs);
	        		},
	        		
	        		error: function(error, ioargs) {
	        			console.log('error: ', error);
						console.log('ioargs: ', ioargs);
	        		}
	        	});	
			}				
		},
		
		_setImgNodes: function(blobData){		
			// If dndContainer is hidden due to deletion of all values then enable it here.
			if ('none' === dojo.style(this._dndContainer.node, 'display'))
				dojo.style(this._dndContainer.node, 'display', '');
			if (!this.multiple) {
				var dndNodeList = this._dndContainer.getAllNodes(),
					dndNode;
				if (dojo.isArray(dndNodeList) && dndNodeList.length > 0)
					dndNode = dndNodeList[0];
				if (dndNode) {
					var tempIdNodeArray = dojo.query('input[name^='+  this.getMultipleInputNamePrefix() +  ']', dndNode);
					if (dojo.isArray(tempIdNodeArray) && tempIdNodeArray.length > 0) {
						tempIdNode = tempIdNodeArray[0];
						this.deleteTempObjectId(dojo.attr(tempIdNode, 'value'));
					}	
				}
				dojo.forEach(this._dndContainer.getAllNodes(), dojo.destroy);
			}

			this._setDnDItems(blobData);
		},
		
		_setDnDItems: function(blobData){
			// blobData should be an object
			// 		if its an Array, we use it's first element(which is an object)
			if(dojo.isArray(blobData)) {
				blobData = blobData[0];
			}
			var self = this, iconImg, crossDiv, fileNameDiv, dataDiv, dndNode, newNode, imgDiv, lb, imgDimensionParams, index;
			if (blobData.uploadvalid == 'failed') {
				if(parent.SitesApp)
					blobData.cause && blobData.cause != "" ?  parent.SitesApp.error(blobData.cause) : parent.SitesApp.error(fw.util.getString("UI/UC1/JS/UploadFailed"));
				else
					blobData.cause && blobData.cause != "" ? alert(blobData.cause) : alert(fw.util.getString("UI/UC1/JS/UploadFailed"));
				return;
			}
			if (blobData.uploadstatus == 'failed') {
				if(parent.SitesApp)
					blobData.cause && blobData.cause != "" ?  parent.SitesApp.error(blobData.cause) : parent.SitesApp.error(fw.util.getString("UI/UC1/JS/UploadFailed"));
				else
					blobData.cause && blobData.cause != "" ? alert(blobData.cause) : alert(fw.util.getString("UI/UC1/JS/UploadFailed"));
				return;
			}
			this.numberOfValues++;		
			dndNode = dojo.create('div',{fileName:blobData.filename, fileId:blobData.tempObjectId, fileType:blobData.filetype});
			newNode = dojo.create('div', {'class': 'UploaderMainDiv'}, dndNode, 'first');
			 
			//fileNameDiv = dojo.create('div', {'class': 'UploadFileNameDiv', innerHTML: blobData.filename}, newNode, 'last');
			dataDiv = dojo.create('div', {'class': 'UploadFileDiv'}, newNode, 'last');
			crossDiv = dojo.create('div', {'class': 'removeButton'}, newNode, 'last');				

			if(blobData.filetype.match(/image/) == 'image'){
				imgDimensionParams = this.parseImgDimensions(blobData.dimension);
				imgDiv = dojo.place('<img alt="' + blobData.filename + '" src="' + blobData.blobURL + '"/>',dataDiv,'last');				
				lb = new fw.dijit.UILightbox({title: blobData['filename'], href: blobData.blobURL, displayInfo: blobData}, imgDiv);
				lb.startup();
				if (imgDimensionParams && imgDimensionParams.height > imgDimensionParams.width) 
					dojo.style(imgDiv, 'height', '96px');
				else
					dojo.style(imgDiv, 'width', '96px');
			}
			else{				
				var otherDiv = dojo.create('a',{href:blobData.blobURL});
				iconImg = dojo.place('<img alt="' + blobData.filename + '" src="' + this.getIcon(blobData.filename) + '" width="96px"/>', otherDiv, 'last');
				dojo.place(otherDiv, dataDiv, 'last');
			}
			
			new dijit.Tooltip({connectId: [dataDiv], label: fw.util.createTooltip(blobData)});
			
			var index = self._getValueAttr().length + 1;
			var bNode = self.multiple ? self.getBlobNode(index) : dojo.query('input[name="' + this.getMultipleInputNamePrefix() + '"]')[0], 
				isNewlyAddedVal = self.isWidgetStarted ? 'true' : 'false',
				indexVal = '';

			if (this.multiple)
				indexVal = '_' + (this._getValueAttr().length + 1);
				
			if (!bNode) {
				bNode = dojo.create('input', {
					type: 'hidden',
					name: this.getMultipleInputNamePrefix() + indexVal,
					oraNodeName: this.getMultipleInputNamePrefix() + indexVal,
					id: this.getMultipleInputNamePrefix() + indexVal,
					isnewlyadded: isNewlyAddedVal,
					value: blobData.tempObjectId
				}, dndNode, 'last');				
			} else {
				if ('' == dojo.attr(bNode, 'value')) {
					dojo.attr(bNode, 'value', blobData.tempObjectId);
				}					
				dojo.place(bNode, dndNode, 'last');
			}
			
			var fileNode = dojo.create('input', {
				type: 'hidden',
				name: self.getMultipleInputNamePrefix() + indexVal + '_file',
				id: self.getMultipleInputNamePrefix() + indexVal + '_file',
				oraNodeType: 'filenode',
				oraNodeName: self.getMultipleInputNamePrefix() + indexVal + '_file',
				value: blobData.filename				
			}, dndNode, 'last');
			
			var delNode = dojo.create('input', {
				type: 'hidden',
				name: '_DEL_' + self.getMultipleInputNamePrefix() + indexVal,
				id: '_DEL_' + self.getMultipleInputNamePrefix() + indexVal,
				oraNodeType: 'delnode',
				oraNodeName: '_DEL_' + self.getMultipleInputNamePrefix() + '_' + (self._getValueAttr().length + 1),
				value: ''
			}, dndNode, 'last');
			
			
			var rmNode = dojo.create('a', {'class': 'FormUploaderCross', style: { display:'block'}});
			dojo.place(rmNode, crossDiv, 'last'); 
			var disConnectHan = dojo.connect(rmNode,'onclick',function(){
				if ('true' == dojo.attr(bNode, 'isnewlyadded') || self.single) {
					self.deleteTempObjectId(dojo.attr(bNode, 'value'));				
				}
				
				if ((dojo.isArray(self.get('value')) && self.get('value').length == 1) || 
						(!self.multiple && '' != self.blobURL)) {
 					dojo.place(bNode, self.domNode, 'last');
 					dojo.attr(bNode, 'value', '');
 				}
				
				if ('true' == dojo.attr(bNode, 'isnewlyadded'))
					dojo.NodeList(dndNode).forEach(dojo.destroy);
				else {
	 				dojo.style(dndNode, {'display': 'none'});
	 				dojo.attr(fileNode, 'value', '');
	 				dojo.attr(delNode, 'value', 'on');					
				}
				
				dojo.disconnect(disConnectHan);
				self.validate();
				self.numberOfValues--;
				self._onChange();
				
				// If there are no elements to display then hide the dndContainer itself.
				if (self.numberOfValues == 0) 
					dojo.style(self._dndContainer.node, 'display', 'none');
				
				self.orderModified(self._dndContainer);
				if (0 == self.numberOfValues)
					self.regenReqInfoVal(1);
				else
					self.regenReqInfoVal();
				self.regenAttrVCNode();
			});
				
			this._dndContainer && this._dndContainer.insertNodes(false, [dndNode]);	
			
			self._onChange();
			self.regenAttrVCNode();
			self.regenReqInfoVal();
		},
		
		getBlobNode: function(index, item) { 
			var bNode;	
			if (index) {
				if (item)
					bNode = dojo.query('[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + index + '"]', item)[0];
				else 
					bNode = dojo.query('[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + index + '"]')[0];				
			} else {
				if (item)
					bNode = dojo.query('[oraNodeName^="' + this.getMultipleInputNamePrefix() + '_"]', item)[0];
				else 
					bNode = dojo.query('[oraNodeName^="' + this.getMultipleInputNamePrefix() + '_"]')[0];
			}
				
			return bNode;
		},
		
		getFileNode: function(selectedImgIndex, item) {
			var fileNode;
			if (selectedImgIndex) {
				if (item)
					fileNode = dojo.query('[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + selectedImgIndex + '_file' + '"]', item)[0];
				else
					fileNode = dojo.query('[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + selectedImgIndex + '_file' + '"]')[0];					
			} else {
				if (item)
					fileNode = dojo.query('[oraNodeName^="' + this.getMultipleInputNamePrefix() + '"][oraNodeName$="_file"][type="hidden"]', item)[0];
				else
					fileNode = dojo.query('[oraNodeName^="' + this.getMultipleInputNamePrefix() + '"][oraNodeName$="_file"][type="hidden"]')[0];					
			}
			return fileNode;
		},
		
		getDelNode: function(index, item) {
			var delNode;
			if (index) {
				delNode = dojo.query('[oraNodeName="_DEL_' + this.getMultipleInputNamePrefix() + '_' + index + '"]', item)[0];				
			} else {
				delNode = dojo.query('[oraNodeName^="_DEL_' + this.getMultipleInputNamePrefix() + '_"]', item)[0];
			}
			return delNode;
		},
		
		orderModified: function(source, nodes, copy) {
			console.group('[MultiValuedTextEditor] - orderModified:', arguments);			
			if (!this.multiple) return;

			var self = this,
				jsMultipleInputNamePrefix = self.getMultipleInputNamePrefix(),
				srcNodeList = new dojo.NodeList(source.node);
		
			var attrIndex = 1;
			
			//dojo.forEach(srcNodeList.children(), function(item, i) {
			dojo.forEach(srcNodeList[0].children, function(item, i) {
			//dojo.forEach(srcNodeList, function(item, i) {
				var blobNode = self.getBlobNode(null, item);
				
				if (!blobNode) return;												
				
				dojo.attr(blobNode, 'name', jsMultipleInputNamePrefix + '_' + attrIndex);
				dojo.attr(blobNode, 'oraNodeName', jsMultipleInputNamePrefix + '_' + attrIndex);
				dojo.attr(blobNode, 'id', jsMultipleInputNamePrefix + '_' + attrIndex);
			
				var delNode = self.getDelNode(null, item); 
				if (delNode) {
					dojo.attr(delNode, 'name', '_DEL_' + jsMultipleInputNamePrefix + '_' + attrIndex);
					dojo.attr(delNode, 'oraNodeName', '_DEL_' + jsMultipleInputNamePrefix + '_' + attrIndex);
					dojo.attr(delNode, 'id', '_DEL_' + jsMultipleInputNamePrefix + '_' + attrIndex);
				}
				
				var fileNode = self.getFileNode(null, item);
				if (fileNode) {
					dojo.attr(fileNode, 'name', jsMultipleInputNamePrefix + '_' + attrIndex + '_file');
					dojo.attr(fileNode, 'oraNodeName', jsMultipleInputNamePrefix + '_' + attrIndex + '_file');
					dojo.attr(fileNode, 'id', jsMultipleInputNamePrefix + '_' + attrIndex + '_file');
				}
				
				attrIndex++;
				console.debug('After modification - blobNode: ', blobNode, ' - attrIndex: ', attrIndex);								
			});	
			this._onChange();
			console.groupEnd();
		}
		
	}, dojo.byId(currInputName));
	
 	//var fileUploaderValues = fileUploader.get('value');
 	var fileUploaderValues = fileUploader.value;
	if ('' === fileUploaderValues) fileUploaderValues = [];
	if (!dojo.isArray(fileUploaderValues)) 
		fileUploaderValues = [fileUploaderValues];
	
	for (var i = 0; i < fileUploaderValues.length; i++) {
		var indexVal = '';
		
		if (fileUploader.multiple)
			indexVal = fileUploader.getMultipleInputNamePrefix() + '_' + (i + 1);
		else 
			indexVal = fileUploader.getMultipleInputNamePrefix();

		dojo.create('input', {
			type: 'hidden',
			name: '_DATA_' + indexVal,
			id: '_DATA_' + indexVal,
			oraNodeType: 'datanode',
			oraNodeName: '_DATA_' + indexVal,
			value: 'yes'
		}, fileUploader.domNode, 'last');			
	}
	
	fileUploader.startup();
	dojo.connect(fileUploader.uploader, 'onFileQueued', function(file) {
		var xhrProps = {
			url: dojo.config.fw_csPath + 'wem/fatwire/wem/ui/Ping',
			handleAs: 'json',
			error: function(err) {
				wemcontext.directToLoginPage();
			}
		};
		return dojo.xhrGet(xhrProps);});
	if (fileUploaderValues.length == 0) {
		var indexVal = '';
		
		if (fileUploader.multiple)
			indexVal = '_' + (fileUploader._getValueAttr().length + 1);			
	
		dojo.create('input', {
			type: 'hidden',
			name: fileUploader.getMultipleInputNamePrefix() + indexVal,
			oraNodeName: fileUploader.getMultipleInputNamePrefix() + indexVal,
			id: fileUploader.getMultipleInputNamePrefix() + indexVal,
			isnewlyadded: 'true',
			value: ''
		}, fileUploader.domNode, 'last');
		
		// If there are no elements to display then hide the dndContainer itself.
		if (fileUploader.numberOfValues == 0) 
			dojo.style(fileUploader._dndContainer.node, 'display', 'none');
		
		fileUploader.regenReqInfoVal(1);
	}
	
});
</script>
 
	<td valign="top">
		<div NAME='<%=ics.GetVar("cs_CurrentInputName")%>' id='<%=ics.GetVar("cs_CurrentInputName")%>'></div>
	</td>
 </tr>

</cs:ftcs>