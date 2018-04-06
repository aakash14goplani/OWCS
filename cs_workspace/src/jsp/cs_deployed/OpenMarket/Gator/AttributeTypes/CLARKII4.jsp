
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%>

<%-- OpenMarket/Gator/AttributeTypes/CLARKII4--%>
<%@page import="com.fatwire.ui.util.InsiteUtil"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.openmarket.basic.util.Base64"
%><%@ page import="com.openmarket.gator.interfaces.IPresentationObject" %>
<%@ page import="com.openmarket.gator.interfaces.IPresentationElement"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects"%>
<%@ page import="com.openmarket.xcelerate.interfaces.TempObjectsFactory"%>
<%@ page import="com.openmarket.gator.blobservice.BlobService"%>
<%@ page import="COM.FutureTense.Interfaces.FTVAL"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="com.fatwire.util.BlobUtil"%>
<%@ page import="com.openmarket.xcelerate.common.TempObjects"%>


<%!
private static final String EQUALDELIMITER = "=";
private static final String DELIMITER = "_:_";

String getAttribute(ICS ics, String attributeName, String defaultValue)
{    
    IPresentationObject presObj = (IPresentationObject)ics.GetObj(ics.GetVar("PresInst"));
	String attributeValue = presObj.getPrimaryAttributeValue(attributeName);
	if (!Utilities.goodString(attributeValue))
		return defaultValue;
	else
		return attributeValue;
}

private final String getUploadToken(ICS ics) throws Exception
{
	return InsiteUtil.getUploadToken(ics);
}

private final Map<String, String> getQryMap(String url) 
{
	// /cs/BlobServer?blobcol=urldata&blobtable=MungoBlobs&csblobid=1316668710205&blobkey=id&blobwhere=1316668710129
	Map<String, String> qryMap = new HashMap<String, String>();
	if (null == url) return qryMap;
	String[] params = url.substring(url.indexOf('?') + 1).split("&");

	for (String param : params) 
	{
		int indexOfEqual = param.indexOf('=');
		if (indexOfEqual == -1) continue;
		qryMap.put(param.substring(0, indexOfEqual), param.substring(indexOfEqual + 1));
	}
	return qryMap;
}

// Imported from com.fatwire.services.util.ImageUtil
private Map<String, String> getButtonConfig(IPresentationObject presentationObject)
{
	Map<String, String> buttonMap = new HashMap();

    if (presentationObject != null)
    {
		IPresentationElement root = presentationObject.getPrimaryElement();
        if (root != null && root.getChildrenCount() == 1)
        {
			IPresentationElement buttons = root.getChild(0);
            if (buttons != null)
            {
				int buttonCount = buttons.getChildrenCount();
                for (int i = 0; i < buttonCount; i++)
                {
					IPresentationElement current = buttons.getChild(i);
                    if (current != null)
                    {
						String name = current.getAttributeValue("NAME");
                        String visible = current.getAttributeValue("VISIBLE");
                        buttonMap.put(name, ("true".equals(visible) ? "1" : "0"));
					}
				}
			}
		}
	}
	return buttonMap;
}

private static boolean isID(String id) 
{
	if (null == id) return false;
	// The id length should not be more than 19 chars
	if (id.length() > 19) return false;
	// All the characters should be numbers.
	for (int i = 0; i < id.length(); i++) 
	{
		if (!Character.isDigit(id.charAt(i))) return false;
	}
	return true;
}
%>

<cs:ftcs>
<script type="text/javascript" src="ImageEditor/clarkii/clarkii_config.js"></script>

<ics:setvar name="doDefaultDisplay" value="no" />

<ics:getproperty name="ft.cgipath" file="futuretense.ini" output="cgipath"/>
<ics:getproperty name="xcelerate.imageeditor.clarkii.basepath" file="futuretense_xcel.ini" output="basepath"/>

<%
	String encodeImageUrl = "";
	String attributeName = ics.GetVar("AttrName");
    boolean isSingleValued = "single".equals(ics.GetVar("EditingStyle"));
    String maximumValues = "";
    boolean isRequired = "true".equals(ics.GetVar("RequiredAttr"));
    IList attributeValueList = ics.GetList("AttrValueList", false);
    boolean hasValues = "true".equals(ics.GetVar("IsAttrValueListCurrent"));
    //hasValues = true;
	// attributeValueList != null && attributeValueList.hasData();
	String fileName = "";
	String urlValue = "";
	String folder = "";
	byte[] fileData = null;
	String encodedFileData = null;
    String uriPrefix = "/"+ics.GetVar("cgipath").replace("/","")+"/";
	String currentInput = ics.GetVar("cs_CurrentInputName");
	String currentValue = null;

	String codebase = ics.GetVar("basepath");
	if (!Utilities.goodString(codebase))
		codebase = uriPrefix + "ImageEditor/clarkii/";
	else if (codebase.indexOf(uriPrefix.replace("/", "")) == -1) {
		codebase = uriPrefix + codebase;
	}

	//TODO: determine relative path using # of slashes in codebase - 1
	StringBuilder str = new StringBuilder();
	for (int i = 0; i < codebase.length() - 1; i++) 
	{
		if (codebase.charAt(i) == '/')
			str.append("../");
	}

	String baseUri = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
	codebase = codebase.replaceAll("/+", "/");
	if (!codebase.endsWith("/"))
		codebase = codebase + "/";
	codebase = baseUri + codebase;

	// Fix for PR# 27771
    String emptyImageUrl=ics.GetVar("cs_imagedir")+"/graphics/common/logo/spacer.gif";

	// Image Editor options
	String locale = "EN";
	String width = getAttribute(ics, "WIDTH", "500");
	String height = getAttribute(ics, "HEIGHT", "400");

	String fitImage = getAttribute(ics, "FITIMAGE", "true");
    String snapshotPanelVisible = getAttribute(ics, "SNAPSHOTPANEL", "false");
    String limitCropping = getAttribute(ics, "LIMITCROPPING", "false");
	String cropWidth = getAttribute(ics, "CROPWIDTH", "100");
	String cropHeight = getAttribute(ics, "CROPHEIGHT", "100");
    String enableOIEFormat = getAttribute(ics, "ENABLEOIEFORMAT", "true");
	String limitSize = getAttribute(ics, "LIMITSIZE", "false");

	String maxWidth = getAttribute(ics, "MAXWIDTH", "800");
	String maxHeight = getAttribute(ics, "MAXHEIGHT", "600");
	String minWidth = getAttribute(ics, "MINWIDTH", "1");
	String minHeight = getAttribute(ics, "MINHEIGHT", "1");

    String autoResample = getAttribute(ics, "AUTORESAMPLE", "false");
    String autoResampleProportional = getAttribute(ics, "AUTORESAMPLEPROPORTIONAL", "false");

    String defaultTextFont = getAttribute(ics, "DEFAULTTEXTFONT", "Arial");
	if (!defaultTextFont.startsWith("_"))
		defaultTextFont = "_" + defaultTextFont;
    String defaultTextSize = getAttribute(ics, "DEFAULTTEXTSIZE", "12");
    String defaultTextColor = getAttribute(ics, "DEFAULTTEXTCOLOR", "#000000");  
	if (defaultTextColor.startsWith("#"))
		defaultTextColor=defaultTextColor.replaceAll("#+","");
    
    boolean enableImagePicker = "true".equals(getAttribute(ics, "ENABLEIMAGEPICKER", "false"));
    String imgPickerAttributeType = getAttribute(ics, "ATTRIBUTETYPE", null);
    String imgPickerAssetType = getAttribute(ics, "ASSETTYPE", null);
    String imgPickerAttributeName = getAttribute(ics, "ATTRIBUTE", null);
    String imgPickerCategoryAttribute = getAttribute(ics, "CATEGORYATTRIBUTE", ""); 
    String imgPickerRestrictedCategoryList = getAttribute(ics, "RESTRICTEDCATEGORYLIST", "");
    
    boolean oieEnableImagePicker = "true".equals(getAttribute(ics, "OIEENABLEIMAGEPICKER", "false"));
    String oieImgPickerAttributeType = getAttribute(ics, "OIEATTRIBUTETYPE", null);
    String oieImgPickerAssetType = getAttribute(ics, "OIEASSETTYPE", null);
    String oieImgPickerAttributeName = getAttribute(ics, "OIEATTRIBUTE", null);
    String oieImgPickerCategoryAttribute = getAttribute(ics, "OIECATEGORYATTRIBUTE", ""); 
    String oieImgPickerRestrictedCategoryList = getAttribute(ics, "OIERESTRICTEDCATEGORYLIST", "");    

    if (imgPickerAttributeType == null || imgPickerAssetType == null || imgPickerAttributeName == null)
		enableImagePicker = false;
    if (oieImgPickerAttributeType == null || oieImgPickerAssetType == null || oieImgPickerAttributeName == null)
		oieEnableImagePicker = false;

	String tagEdit = getAttribute(ics, "TAGEDIT", "false");

    String base64JpegQuality = getAttribute(ics, "BASE64JPEGQUALITY", "95");
    String askToSaveLocally = getAttribute(ics, "ASKTOSAVELOCALLY", "false");
    String defaultSavingType = getAttribute(ics, "DEFAULTSAVINGTYPE", "gif");
    
    String enableGifSaving = getAttribute(ics, "ENABLEGIFSAVING", "true");
    String enableJpegSaving = getAttribute(ics, "ENABLEJPEGSAVING", "true");
    String enablePngSaving = getAttribute(ics, "ENABLEPNGSAVING", "true");
    String enableTiffSaving = getAttribute(ics, "ENABLETIFFSAVING", "true");
    String enableBmpSaving = getAttribute(ics, "ENABLEBMPSAVING", "true");

    String gridVisible = getAttribute(ics, "GRIDVISIBLE", "false");
	String gridSnap = getAttribute(ics, "GRIDSNAP", "false");
    String gridSpacingX = getAttribute(ics, "GRIDSPACINGX", "10");
    String gridSpacingY = getAttribute(ics, "GRIDSPACINGY", "10");
    
    String maxThumbnailHeight = getAttribute(ics, "MAXTHUMBNAILHEIGHT", "100");
    String maxThumbnailWidth = getAttribute(ics, "MAXTHUMBNAILWIDTH", "100");
    String thumbnailFormat = getAttribute(ics, "THUMBNAILFORMAT", "gif");   

	String flashVersion = "10.0.0";

	String imageUrl = null;
	String pagename = ics.GetVar("pagename");
	boolean isPosted = "true".equals(ics.GetVar("__POSTED__"));
	String attributeId = null;
	IList tmplattrlist = ics.GetList("tmplattrlist");

	if (tmplattrlist != null) 
	{
	    int moveToRow = Integer.parseInt(ics.GetVar("tmplattrlistIndex"));
		tmplattrlist.moveTo(moveToRow);
		attributeId = tmplattrlist.getValue("assetid");
	}

	//bounding width height
	int iWidth = 500;//dafault
	try 
	{
		iWidth = Integer.parseInt(width);
	} catch(Exception ex){}

	int iHeight = 400;//dafault
	try 
	{
		iHeight = Integer.parseInt(height);
	} catch(Exception ex){}

	if (iWidth > Integer.parseInt(maxWidth))
		width = maxWidth;
	else if (iWidth < Integer.parseInt(minWidth))
		width = minWidth;

	if (iHeight > Integer.parseInt(maxHeight))
		height = maxHeight;
	else if (iHeight < Integer.parseInt(minHeight))
		height = minHeight;

	String path = request.getContextPath();

	FTValList args = new FTValList();
	args.setValString("NAME", ics.GetVar("PresInst"));
	args.setValString("VARNAME", "MAXVALUES");
	ics.runTag("presentation.getmaxvalues", args);		 
	maximumValues = ics.GetVar("MAXVALUES");
	maximumValues = Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : "-1";
	if (isSingleValued) maximumValues = "1";
	
	// Get the customization information of Clarkii
    IPresentationObject presentationObject = (IPresentationObject)ics.GetObj(ics.GetVar("PresInst"));
	Map<String, String> buttonMap = getButtonConfig(presentationObject);
	Set keySet = buttonMap.keySet();
	Iterator<String> keys = keySet.iterator();
	String keysStr = "[", valuesStr = "[";
    while (keys.hasNext())
    {
		String feature = keys.next();
		if (feature != null && buttonMap.get(feature) != null) {
			keysStr += "'" + feature + "',";
			valuesStr += buttonMap.get(feature) + ",";
		}
	}
	keysStr = keysStr.substring(0, keysStr.length() - 1);
	valuesStr = valuesStr.substring(0, valuesStr.length() - 1);
	keysStr += "]";
	valuesStr += "]";
	
	StringBuilder customInfo = new StringBuilder("{");
	
	customInfo.append("'fitImage': '" + fitImage.equalsIgnoreCase("true") + "', ");		
	customInfo.append("'gridSnap': '" + gridSnap + "', ");
	customInfo.append("'maxThumbnailWidth': '" + maxThumbnailWidth + "', ");
	customInfo.append("'maxThumbnailHeight': '" + maxThumbnailHeight + "', ");
	customInfo.append("'defaultSavingType': '" + defaultSavingType + "'");

	customInfo.append("}");
		
%>
	<satellite:link
	    assembler="query"
	    outstring="imagepickerurl"
		pagename="OpenMarket/Gator/AttributeTypes/IMAGEPICKERShowImages">
	    <satellite:argument name="fieldname" value='<%="clarkii_" + currentInput.substring(0, currentInput.lastIndexOf("_")) %>' />
	    <satellite:argument name="ATTRIBUTETYPENAMEOUT" value="<%=imgPickerAttributeType %>" />
	    <satellite:argument name="ATTRIBUTENAMEOUT" value="<%=imgPickerAttributeName %>" />
	    <satellite:argument name="ASSETTYPENAMEOUT" value="<%=imgPickerAssetType%>" />
	    <satellite:argument name="CATEGORYATTRIBUTENAMEOUT" value="<%=imgPickerCategoryAttribute %>" />
	    <satellite:argument name="RESTRICTEDCATEGORYLISTOUT" value="<%=imgPickerRestrictedCategoryList %>" />
		<satellite:argument name="cs_callback" value="loadClarkiiImage" />
		<satellite:argument name="AttrName" value='<%= ics.GetVar("AttrName") %>' />
	</satellite:link>

	<satellite:link
	    assembler="query"
	    outstring="insertimagepickerurl"
		pagename="OpenMarket/Gator/AttributeTypes/IMAGEPICKERShowImages">
	    <satellite:argument name="fieldname" value='<%="clarkii_" + currentInput %>' />
	    <satellite:argument name="ATTRIBUTETYPENAMEOUT" value="<%=oieImgPickerAttributeType %>" />
	    <satellite:argument name="ATTRIBUTENAMEOUT" value="<%=oieImgPickerAttributeName %>" />
	    <satellite:argument name="ASSETTYPENAMEOUT" value="<%=oieImgPickerAssetType%>" />
	    <satellite:argument name="CATEGORYATTRIBUTENAMEOUT" value="<%=oieImgPickerCategoryAttribute %>" />
	    <satellite:argument name="RESTRICTEDCATEGORYLISTOUT" value="<%=oieImgPickerRestrictedCategoryList %>" />
		<satellite:argument name="cs_callback" value="insertClarkiiImage" />
		<satellite:argument name="AttrName" value='<%= ics.GetVar("AttrName") %>' />
	</satellite:link>

<ics:if condition='<%= "no".equalsIgnoreCase(ics.GetVar("MultiValueEntry")) %>'>
<ics:then>
	<ics:callelement element='OpenMarket/Gator/AttributeTypes/ProcessValues'>
		<ics:argument name='AttrType' value='<%= ics.GetVar("type") %>' />
	</ics:callelement>
</ics:then>
</ics:if>

<tr>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>    
	
	<td></td>
	<td valign="top">
	<div id='<%=ics.GetVar("AttrName")%>_ToBeDeletedNodes_'></div>
	<div id='<%=ics.GetVar("AttrName")%>_MultiValuedClarkiiEditor'></div>

	<script>

	dojo.addOnLoad(function() {
		console.log('window.parent: ', window.parent);
		var imageURL = '<%=ics.GetVar("imageurl")%>';
		var queryObj = dojo.queryToObject(imageURL.substring(imageURL.indexOf('?') + 1));
		
		var flashVars = {
			FilePath: '<%=codebase%>',
			StartupProject: '<%=encodeImageUrl%>',
			
			DefaultTextFontFamily: '<%=defaultTextFont%>',
			DefaultTextSize: '<%=defaultTextSize%>',
			DefaultTextColor: '<%=defaultTextColor%>',
			DefaultTAPTextFontFamily: '<%=defaultTextFont%>',
			DefaultTAPTextSize: '<%=defaultTextSize%>',
			
			DefaultTAPTextColor: '<%=defaultTextColor%>'
		};
		var _authkey_= document.getElementsByName("_authkey_")[0].value;
		var clarkiiEditor = new fw.ui.dijit.form.MultiValuedClarkiiEditor({
			multiple: <%= !isSingleValued %>,
			imagePickerURL: '<%=ics.GetVar("imagepickerurl")%>',
			insertImagePickerURL: '<%=ics.GetVar("insertimagepickerurl")%>',
			acceptedTypes: ['<%=imgPickerAssetType%>'],
			clarkiiEditorParams: {flashVars: flashVars},
			maxVals: <%=maximumValues%>,
			isUCForm: <%= "ucform".equals(ics.GetVar("cs_environment")) %>,
			value: "[<%=ics.GetObj("strAttrValues")%>]",
			imgPickerAttributeName: '<%= imgPickerAttributeName %>',
			
			custom_keys: <%= keysStr %>,
			custom_values: <%= valuesStr %>,
			custom_info: "<%= customInfo %>",
			_authtoken_: '<%=(String)session.getAttribute("csrfuuid")%>',
			_authkey_:_authkey_,
			
			// 	In Contributor UI, token and session values were coming from fw.ui.app.
			//	We have overridden the function to just provide those values from server-side.
			initClarkii: function(){
				var self = this;
				
				var	flexDialog = this.flexDialog = new fw.ui.dijit.FlexibleDialog({						
					showCloseButton: false			
				});
				
				var clarkiiIns = this.clarkiiIns = new fw.ui.dijit.ClarkiiEditor({
					imageUrl:  '../../wemresources/images/icons/gears.gif',
					flashVars: self.clarkiiEditorParams.flashVars,
					onSave: dojo.hitch(self, '_onClarkiiSave'),
					onClarkiiImageComplete: dojo.hitch(self, '_onClarkiiImageComplete'),
					onClarkiiImageOpen: dojo.hitch(self, '_onClarkiiImageOpen'),
					
					toolbar: CS_FORM
				});
	
				var confirmPrompt = this.confirmPrompt = new fw.ui.dijit.ClarkiiConfirmationPrompt({				
					prompt: self.clarkiiIns,
					_slsYes : fw.util.getString('dvin/UI/Save'),
					_slsNo : fw.util.getString('dvin/UI/Cancel'),
					onConfirm: function() {
						self.clarkiiIns.save();
					},
					onDecline: function() { 
						flexDialog.hide(); 
						self.clarkiiIns._cleanGlobals();
					},
					onInsert: function() {
						dojo.hitch(null, 'openImagePicker', self.insertImagePickerURL, true)();
					}
				});
				
				this.flexDialog.startup();
				this.flexDialog.set('content', this.confirmPrompt);
				
				this.sessionObjInWidget = {
					token: '<%=getUploadToken(ics)%>', 
					sessionid: '<%=session.getId()%>' 
				};
				fw.ui.ObjectFactory.init(fw.ui.InnerConfig.aliases);
				this.assetDataService = fw.ui.ObjectFactory.createServiceObject("asset");		
			},
			
			// 	In Contributor UI, token and session values were coming from fw.ui.app.
			//	We have overridden the function to just provide those values from server-side.
			buildUploaderUrl: function() {
				var uploadUrl = fw.util.getCSpath() + 'ContentServer?pagename=fatwire/ui/util/fileUpload&fieldName=Filedata';
				var uploadArgs = {
					token: '<%=getUploadToken(ics)%>', 
					identifier: '<%=session.getId()%>',
					_authtoken_: this._authtoken_,
					_authkey_: this._authkey_
				};
				var query = dojo.objectToQuery(uploadArgs);
				uploadUrl += (uploadUrl.indexOf('?') > -1 ? '&' : '?') + query;
				return uploadUrl;
			},
			
			_setDnDItems: function(blobData, isExternalDrop) {
				//	summary:
				//		This function builds the look and feel of every dnd node before inserting it to dnd source.
				//		There are 4 input elements to every dnd item
				//		1) blobNode - The input element which will hold the temporary object id.
				//		2) fileNode - The input element with file name information.
				//		3) delete Node - The input element which informs if the node is marked for delete or not. The values are:
				//						 'on' - It represents that value is marked for delete.
				//						 ''	  - An empty values means there is no need to delete.
				//		4) image quality Node - It represents the quality information and its default value is set to 65.
				
				var self = this;
				
				// Non-flash uploader is giving data in array.
				blobData = dojo.isArray(blobData) ? blobData[0] : blobData;
				
				this.numberOfValues++;	
				
				// If dndContainer is hidden due to deletion of all values then enable it here.
				if ('none' === dojo.style(this._dndContainer.node, 'display'))
					dojo.style(this._dndContainer.node, 'display', '');
				
				var dndNode = dojo.create('div',{fileName:blobData.filename, fileId:blobData.tempObjectId});
				var clarkiiMainOuterDiv = dojo.create('div', {'class': 'ClarkiiMainOuterDiv'}, dndNode, 'last');
				var clarkiiMainDiv = dojo.create('div', {'class': 'ClarkiiMainDiv'}, clarkiiMainOuterDiv, 'last');
				var newNode = dojo.create('div',{'class': 'outerDivClass'}, clarkiiMainDiv, 'first');
				var dropZone = dojo.create('div', {'class': 'dropzone-inner'}, newNode, 'last');
				
				var imgDiv = dojo.place('<img alt="' + blobData.filename + '" src="' + blobData.blobURL + '"/>', dropZone, 'last'),
					imgDimensionParams = this.parseImgDimensions(blobData.dimension);
				if (imgDimensionParams && imgDimensionParams.height > imgDimensionParams.width) 
					dojo.style(imgDiv, 'height', '96px');
				else
					dojo.style(imgDiv, 'width', '96px');
				var lb = new fw.dijit.UILightbox({title: blobData['filename'], href: blobData.blobURL, displayInfo: blobData}, imgDiv);
					lb.startup();
				
				var imgClarkiiDiv = dojo.create('div', {'class': 'MultiValuedClarkiiEditorClarkiiIcon'}, clarkiiMainDiv, 'last');
				var rmNodeDiv = dojo.create('div', {'class': 'MultiValuedClarkiiEditorDelete'}, clarkiiMainDiv, 'last');
				var rmNode = dojo.create('a', {'class': 'DeleteCross', style: { display:'block'}},rmNodeDiv,'first');
	
				var index = self._getValueAttr().length + 1;
				var bNode, jsMultipleInputNamePrefix = this.getMultipleInputNamePrefix(), 
					prefixName = this.multiple ? this.getMultipleInputNamePrefix() + '_' + (this._getValueAttr().length + 1) : this.getMultipleInputNamePrefix();
				
				bNode = this.multiple ? self.getBlobNode(index) : dojo.query('input[name="' + prefixName + '"]')[0];
				if (!bNode) {
					bNode = dojo.create('input', {
						type: 'hidden',
						name: prefixName,
						id: prefixName,
						blobNode: "true",
						oraNodeType: 'blobnode',
						oraNodeName: prefixName,
						value: blobData.tempObjectId,
						isnewlyadded: 'true'
					}, clarkiiMainDiv, 'last');
				} else {
					if ('' == dojo.attr(bNode, 'value')) {
						dojo.attr(bNode, 'value', blobData.tempObjectId);
						dojo.attr(bNode, 'isnewlyadded', 'true');
					}					
					dojo.place(bNode, clarkiiMainDiv, 'last');
				}
				
				var fileNode = dojo.query('input[name="' + prefixName + '_file"]')[0];
				if (!fileNode) 
					fileNode = dojo.create('input', {
						type: 'hidden',
						name: prefixName + '_file',
						id: prefixName + '_file',
						oraNodeType: 'filenode',
						oraNodeName: prefixName + '_file',
						value: blobData.filename				
					}, clarkiiMainDiv, 'last');
				else {
					dojo.attr(fileNode, 'value', blobData.filename);
					dojo.place(fileNode, clarkiiMainDiv, 'last');
				}
	
				var delNode = dojo.query('input[name="_DEL_' + prefixName+ '"]')[0];
				if (!delNode)
					delNode = dojo.create('input', {
						type: 'hidden',
						name: '_DEL_' + prefixName,
						id: '_DEL_' + prefixName,
						oraNodeType: 'delnode',
						oraNodeName: '_DEL_' + prefixName,
						value: ''
					}, clarkiiMainDiv, 'last');
				else {
					dojo.attr(delNode, 'value', '');
					dojo.place(delNode, clarkiiMainDiv, 'last');
				}
				
				var imgQualityNode = dojo.query('input[name="' + prefixName + '_BASE64JPEGQUALITY"]')[0];
				if (!imgQualityNode)
					imgQualityNode = dojo.create('input', {
						type: 'hidden',
						name: prefixName + '_BASE64JPEGQUALITY',
						id: prefixName + '_BASE64JPEGQUALITY',
						// value="<%=base64JpegQuality%>"
						oraNodeType: 'imgqualitynode',
						oraNodeName: prefixName + '_BASE64JPEGQUALITY',
						value: 65
					}, clarkiiMainDiv, 'last');
				else {
					dojo.attr(imgQualityNode, 'value', 65);
					dojo.place(imgQualityNode, clarkiiMainDiv, 'last');
				}
						
				var imgClarkiiAnchor = dojo.create('a',{
						'class': 'ClarkiiOpen', 
						style: { display:'block'},
						onclick:dojo.hitch(this, '_onClarkiiClick', [dojo.attr(imgDiv,'src'), imgDiv, dndNode, blobData.filename, this._dndContainer])
				},imgClarkiiDiv,'first');
				
				
				new dijit.Tooltip({connectId: [dropZone], label: fw.util.createTooltip(blobData)});
				
				var disConnectHan = dojo.connect(rmNode,'onclick',function(event){	
					//	summary: 
					//		This function is executed on click of cross.
					//		This is meant for deleting the node.
					if ('true' == dojo.attr(bNode, 'isnewlyadded')) {
						self.deleteTempObjectId(dojo.attr(bNode, 'value'));				
					}
				
	 				if (self.get('value').length == 1) {
	 					//dojo.place(bNode, self.domNode, 'last');
	 					//dojo.attr(bNode, 'value', '');
	 				}
					if (!self.multiple) {
						self.deleteTempObjectId(dojo.attr(bNode, 'value'));	
	 					dojo.attr(bNode, 'value', '');
						dojo.place(bNode, self.domNode, 'last');
	 				}
	
					// if the blob input node is newly added then destroy 
					if ('true' == dojo.attr(bNode, 'isnewlyadded')) {	
						dojo.NodeList(dndNode).forEach(dojo.destroy);
					} else {
						// else hide the entire dnd node.
		 				dojo.style(dndNode, {'display': 'none'});
		 				//dojo.attr(fileNode, 'value', '');
		 				dojo.attr(delNode, 'value', 'on');			
					}
					
					self.validate();
					self.numberOfValues--;
					
					self._onChange();
					self.orderModified(self._dndContainer);
					
					if (0 == self.numberOfValues) {
						if (!self.isUCForm) 
							dojo.style(self._dndContainer.node, 'display', 'none');
						self.showDropZone();
						dojo.removeClass(self._dndContainer.node, 'ShowValues');
						
						// If there are no values then regenerate Require info node with at least one value.
						self.regenReqInfoVal(1);					
					} else
						self.regenReqInfoVal();
					
					dojo.disconnect(disConnectHan);
				});
				
				this._onChange();
					
				if (isExternalDrop)
					this._dndContainer && this._dndContainer.insertNodes(false, [dndNode], this._dndContainer.before, this._dndContainer.current);
				else 
					this._dndContainer && this._dndContainer.insertNodes(false, [dndNode], this._dndContainer.current, this._dndContainer.before);
				
				self.regenAttrVCNode();
				self.hideDropZone();
				dojo.addClass(this._dndContainer.node, 'ShowValues');
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
			
			getMultipleInputNamePrefix: function() {
				return '<%=ics.GetVar("cs_SingleInputName")%>';
			},
			
			regenReqInfoVal: function(numOfValues) {
				//	summary: 
				//		This function updates the Require info field.
				
				console.group('[MultiValuedClarkiiEditor] - regenReqInfoVal:', arguments);
				
				var	self = this,
					jsMultipleInputNamePrefix = self.getMultipleInputNamePrefix(),
					jsRequiredInfoNode,
					jsReqInfoVal = '',
					isReq = '<%=isRequired%>',
					newNumOfValues = numOfValues || self._getValueAttr().length;
					
				isReq = 'true' == isReq ? 'True' : 'False';
				
				jsRequiredInfoNode = dojo.query('input[name="<%=ics.GetVar("AttrNumber")%>RequireInfo"]')[0];
				
				console.debug('Before - jsRequiredInfoNode: ', jsRequiredInfoNode);
				
				if (this.multiple) {
					for (var i = 0; i < newNumOfValues; i++) {
						jsReqInfoVal = jsReqInfoVal + '*' + jsMultipleInputNamePrefix + '_' + (i + 1) + '*' + '<%=ics.GetVar("AttrName")%>' + '*' + 'Req' + isReq + '*' + '<%=ics.GetVar("AttrType")%>!';
					}	
				} else {
					jsReqInfoVal = jsReqInfoVal + '*' + jsMultipleInputNamePrefix + '*' + '<%=ics.GetVar("AttrName")%>' + '*' + 'Req' + isReq + '*' + '<%=ics.GetVar("AttrType")%>!';
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
			
				attrVCNode = dojo.query('input[name="<%=ics.GetVar("AttrName")%>VC"]')[0];
				dojo.attr(attrVCNode, 'value', self._getValueAttr().length);
				
				console.debug('attrVCNode: ', attrVCNode);
				console.groupEnd();
				return attrVCNode;			
			},
	
			orderModified: function(source, nodes, copy) {
				//	summary:
				//		This function is called once the elements are re-ordered via drag and drop.
				//		This will update the names of the input elements in every dnd item, as per the new order.
				
				console.group('[MultiValuedTextEditor] - orderModified:', arguments);			
				if (!this.multiple) return;
				var self = this,
					jsMultipleInputNamePrefix = self.getMultipleInputNamePrefix(),
					srcNodeList = new dojo.NodeList(source.node);
			
				console.debug('source: ', source);
				console.debug('srcNodeList: ', srcNodeList);
	
				var attrIndex = 1;
				
				dojo.forEach(srcNodeList.children(), function(item, i) {
					console.debug('i: ', i, ' - item: ', item, ' - attrIndex: ', attrIndex);
					
					var blobNode = self.getBlobNode(null, item);
					
					console.log('jsMultipleInputNamePrefix: ', jsMultipleInputNamePrefix, ' - blobNode: ', blobNode);
					
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
					
					var imgQualityNode = self.getImgQualityNode(null, item);
					if (imgQualityNode) {
						dojo.attr(imgQualityNode, 'name', jsMultipleInputNamePrefix + '_' + attrIndex + '_BASE64JPEGQUALITY');
						dojo.attr(imgQualityNode, 'oraNodeName', jsMultipleInputNamePrefix + '_' + attrIndex + '_BASE64JPEGQUALITY');
						dojo.attr(imgQualityNode, 'id', jsMultipleInputNamePrefix + '_' + attrIndex + '_BASE64JPEGQUALITY');
					} 
					
					attrIndex++;
					console.debug('After modification - blobNode: ', blobNode, ' - attrIndex: ', attrIndex);								
				});	
				this._onChange();
				console.groupEnd();
			},
			
			
			getSelectedImageIndex: function() {
				var selectedImgIndex;
				if (this.selectedImageIndex) 
					selectedImgIndex = this.selectedImageIndex;
				else 
					selectedImgIndex = this.selectedImageIndex = this.fw_getProperty('value').length;		
				console.log('Index of selected image: ', selectedImgIndex);
				return selectedImgIndex;
			},
			
			getFileNode: function(selectedImgIndex, item) {
				var fileNode;
				if (selectedImgIndex) {
					if (item)
						fileNode = dojo.query('input[name="' + this.getMultipleInputNamePrefix() + '_' + selectedImgIndex + '_file' + '"]', item)[0];
					else
						fileNode = dojo.query('input[name="' + this.getMultipleInputNamePrefix() + '_' + selectedImgIndex + '_file' + '"]')[0];					
				} else {
					if (item)
						fileNode = dojo.query('input[name^="' + this.getMultipleInputNamePrefix() + '"][name$="_file"]', item)[0];
					else
						fileNode = dojo.query('input[name^="' + this.getMultipleInputNamePrefix() + '"][name$="_file"]')[0];					
				}
				return fileNode;
			},
			
			getBlobNode: function(index, item) { 
				var bNode;	
				if (index) {
					if (item)
						bNode = dojo.query('input[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + index + '"]', item)[0];
					else 
						bNode = dojo.query('input[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + index + '"]')[0];				
				} else {
					if (item)
						bNode = dojo.query('input[oraNodeName^="' + this.getMultipleInputNamePrefix() + '_"]', item)[0];
					else 
						bNode = dojo.query('input[oraNodeName^="' + this.getMultipleInputNamePrefix() + '_"]')[0];
				}
					
				return bNode;
			},
			
			getDataNode: function(index, item) {
				var dataNode;
				if (index) {
					dataNode = dojo.query('input[oraNodeName="_DATA_' + this.getMultipleInputNamePrefix() + '_' + index + '"]', item)[0];
				} else {
					dataNode = dojo.query('input[oraNodeName^="_DATA_' + this.getMultipleInputNamePrefix() + '_"]', item)[0];		
				}
				return dataNode;
			},
			
			getDelNode: function(index, item) {
				var delNode;
				if (index) {
					delNode = dojo.query('input[oraNodeName="_DEL_' + this.getMultipleInputNamePrefix() + '_' + index + '"]', item)[0];				
				} else {
					delNode = dojo.query('input[oraNodeName^="_DEL_' + this.getMultipleInputNamePrefix() + '_"]', item)[0];
				}
				return delNode;
			},
			
			getImgQualityNode: function(index, item) {
				var imgQualityNode;
				if (index) {
					imgQualityNode = dojo.query('input[oraNodeName="' + this.getMultipleInputNamePrefix() + '_' + index + '_BASE64JPEGQUALITY"]', item)[0];	
				} else {
					imgQualityNode = dojo.query('input[oraNodeName^="' + this.getMultipleInputNamePrefix() + '"][oraNodeName$="_BASE64JPEGQUALITY"][type="hidden"]', item)[0];
				}
				return imgQualityNode;
			}
		});
		
		clarkiiEditor.placeAt('<%=ics.GetVar("AttrName")%>_MultiValuedClarkiiEditor', 'last');

 		var prefixName =  clarkiiEditor.getMultipleInputNamePrefix();
	 	if (clarkiiEditor._getValueAttr().length == 0) {
	 		if (clarkiiEditor.multiple) prefixName = prefixName + '_' + (clarkiiEditor._getValueAttr().length + 1);
			dojo.create('input', {
				type: 'hidden',
				name: prefixName,
				id: prefixName,
				blobNode: "true",
				oraNodeType: "blobnode",
				oraNodeName: prefixName,
				value: ''
			}, clarkiiEditor.domNode, 'last');
			
			// If there are no elements to display then hide the dndContainer itself.
			if (!clarkiiEditor.isUCForm) 
				dojo.style(clarkiiEditor._dndContainer.node, 'display', 'none');
		}
		
	 	// Create N data elements if there are N values while editing the asset. 
		for (var i = 0; i < clarkiiEditor._getValueAttr().length; i++) {
			prefixName =  clarkiiEditor.getMultipleInputNamePrefix();
			if (clarkiiEditor.multiple)
				prefixName = prefixName + '_' + (i + 1);
			dojo.create('input', {
				type: 'hidden',
				name: '_DATA_' + prefixName,
				id: '_DATA_' + prefixName,
				oraNodeType: 'datanode',
				oraNodeName: '_DATA_' + prefixName,
				value: 'yes'
			}, clarkiiEditor.domNode, 'last');			
		}	
		
	
		dojo.connect(clarkiiEditor, 'onUploadComplete', function(blobArgs) {		
			//	summary:
			//		Once upload completes then re-generate the Require info field and value count nodes.		
		
			this.regenReqInfoVal();
			this.regenAttrVCNode();
		});
	
		dojo.connect(clarkiiEditor, '_onClarkiiClick', function(args) {
			//	summary:
			//		On click of clarkii icon (at the top) identify the index of the value clicked.
			
			console.debug('_onClarkiiClick: ', args);
			if (!args[2]) return;
			
			var dndNode = args[2];
			var dndNodeId = dojo.attr(dndNode, 'id');
			var dndContainer = args[4];
			var allDndItems = dndContainer.getAllNodes();
			for (var i = 0; i < allDndItems.length; i++) {
				if (dndNodeId == dojo.attr(allDndItems[i], 'id')) break;
			}
			
			i++;
			console.debug('Index : ', i);
			this.selectedImageIndex = i;
		});
		
		dojo.connect(clarkiiEditor, 'onClarkiiUpload', clarkiiEditor, function(blobArgs) {
			console.group('onClarkiiUpload -- blobArgs', blobArgs);
			var prefixName = this.getMultipleInputNamePrefix();

			console.debug('onClarkiiUpload - this.selectedImageIndex: ', this.selectedImageIndex);
			var selectedImgIndex = null,
				fileNode ;
			
			if (this.selectedImageIndex) 
				selectedImgIndex = this.selectedImageIndex;
			else 
				selectedImgIndex = this.fw_getProperty('value').length;
			
			if (this.multiple) prefixName = prefixName + '_' + selectedImgIndex;
			console.debug('onClarkiiUpload - Index of selected image: ', selectedImgIndex);
			
			var blobNode = dojo.query('input[oraNodeName="' + prefixName + '"]')[0];
			this.deleteTempObjectId(dojo.attr(blobNode, 'value'));	
			dojo.attr(blobNode, 'value', blobArgs.tempObjectId);		
			
			// TODO: Need to get file name from Clarkii instance 
			fileNode = dojo.query('input[name="' + prefixName + '_file' + '"]')[0];			
			dojo.attr(fileNode, 'value', blobArgs.filename);
			
			this.regenAttrVCNode();
			this.regenReqInfoVal();
			console.groupEnd();
		});
	
		clarkiiEditor.startup();
	});
	
	</script>
	</td>
</tr>

<script>

   function openImagePicker(url, isOpenPopUp)
	{
		var isUCForm = '<%= "ucform".equals(ics.GetVar("cs_environment")) %>';
		isOpenPopUp = isOpenPopUp === true ? true : false;       		  
		if (!isOpenPopUp && 'true' == isUCForm) return openImagePickerUCForm(url);
		
		var left = window.screenLeft;
		var top = window.screenTop;
		var windowProperties = 'scrollbars=yes,resizable=yes,width=900,height=600,top=' + top + ',left=' + left;
		var imagePickerWin = window.open(url,'templateSelect', windowProperties);
	}
       
   function openImagePickerUCForm(url) {
		// TODO : UC1 might include attribute type also in search criteria (in this case 'Media_A')
		var assetType = '<%=imgPickerAssetType%>';
		parent.SitesApp.searchController.model.set('searchText', '');
		parent.SitesApp.searchController.model.set('assetType', assetType);
		parent.SitesApp.searchController.search();
	}

   function loadClarkiiImage(fieldname, imageUrl, attrName)
	{	
	return loadMultiValueClarkiiImage(fieldname, imageUrl, attrName);
   }
   
	function loadMultiValueClarkiiImage(fieldname, imageUrl, attrName) {        	
		var multiValuedClarkiiEditor = dijit.findWidgets(dojo.byId(attrName + '_MultiValuedClarkiiEditor'))[0],
			isUCForm = '<%= "ucform".equals(ics.GetVar("cs_environment")) %>',
			tempObjId = '', 
			csblobid = '',
			imageUrlQryMap = dojo.queryToObject(imageUrl),
			fileName = imageUrlQryMap.oieloadpicture || 'Temp.jpg';
		    	  	
		console.log('multiValuedClarkiiEditor: ', multiValuedClarkiiEditor);
		    	
		// An ajax call to copy the mungo blob object into tempObject and get temp object id.        	
		dojo.xhrGet({
			url: 'ContentServer',
		    sync: true,
		    content: {
				pagename: 'fatwire/ui/util/GetInfo',
				requestFor: 'GetTempObjectId',
				mungoBlobId: imageUrlQryMap.blobwhere
			},
		    		
		    load: function(response, ioargs) {
				tempObjId = response;
			   	if (typeof tempObjId.trim === "function")
			   		tempObjId = tempObjId.trim();
		   	},
		   		
		   	error: function(error, ioargs) {
		   		tempObjId = '';
		   	}
		});
		if(!multiValuedClarkiiEditor.multiple && multiValuedClarkiiEditor.numberOfValues >= 1)
		{
			console.debug('cancelled');
		}
		else 
		{
			multiValuedClarkiiEditor._setDnDItems({
				filename: fileName,
				tempObjectId: tempObjId,
				blobURL: '<%=ics.GetProperty("ft.cgipath")%>' + 'BlobServer?blobcol=urldata&blobtable=TempObjects&csblobid=' + imageUrlQryMap.csblobid + '&blobkey=id&blobwhere=' + tempObjId,
				filetype: 'jpeg'
			});	
		}		
	}

	function insertClarkiiImage(fieldname, imageUrl, attrName)
	{
		return multiValuedClarkiiInsertImage (fieldname, imageUrl, attrName);
	}
   
	function multiValuedClarkiiInsertImage (fieldname, imageUrl, attrName) {
		var multiValuedClarkiiEditor = dijit.findWidgets(dojo.byId(attrName + '_MultiValuedClarkiiEditor'))[0];
		multiValuedClarkiiEditor.clarkiiIns._embedNode.insertImageFromInternet('<%=baseUri%><%=uriPrefix%>'+imageUrl);
	}
</script>
</cs:ftcs>
