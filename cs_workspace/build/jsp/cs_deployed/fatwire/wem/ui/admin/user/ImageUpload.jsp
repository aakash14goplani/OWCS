<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/wem/ui/admin/user/ImageUpload
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
<%@page import="com.fatwire.ui.util.InsiteUtil"%>
<cs:ftcs>
<satellite:link pagename="fatwire/wem/ui/admin/user/ImageUploadHandler" assembler="query" outstring="uploadhandler">
	<satellite:argument name="fieldName" value="Filedata"/>
</satellite:link>
<ics:getproperty name="cs.disableSWFFlashUploader" file="futuretense_xcel.ini" output="forceHTMLUploader" />
<%
	String forceHTMLUploader = ics.GetVar("forceHTMLUploader");
	if (!Utilities.goodString(forceHTMLUploader))
		forceHTMLUploader = "false";
%>
<style type="text/css">
	.uploadButton {
		vertical-align: top;
		display: inline-block;
		width: 110px;
		height: 34px;
		position: absolute !important;
	}
	.SWFUploadProfileDiv {
		clear: both;
		float: left;
	}
</style>
<script type="text/javascript">
	dojo.require('fw.ui.dijit.SWFUpload');
	
	initializeUploader = function(){
		dojo.addOnLoad(function(){
			dojo.connect(dijit.byId("hRemove"), "onClick", function(){
				var remBtn = dijit.byId("hRemove");
				if ((dojo.isIE < 9) && (dojo.byId('profileImg') == null || typeof(dojo.byId('profileImg')) === 'undefined')) {
					//Check if there is an empty photo before trying to remove it
					var imgDiv = dojo.byId('profileImgDiv');
					imgDiv.removeChild(dojo.byId('profileImgDiv-temp'));
					var imgElm = document.createElement("img");
					imgElm.id = 'profileImg';
					imgElm.src = '<%=ics.GetVar("cspath")%>/wemresources/images/emptyPhoto.png';
					imgDiv.appendChild(imgElm);
				} else if (dojo.isIE) {
					var imgDiv = dojo.byId('profileImgDiv');
					var imgElm = dojo.query('[id=profileImg]', imgDiv)[0];
					dojo.attr(imgElm, "src", '<%=ics.GetVar("cspath")%>/wemresources/images/emptyPhoto.png');
					dojo.style(imgElm, "width", '90px');
					dojo.style(imgElm, "height", '90px');					
				} else if(typeof(dojo.isIE) ==='undefined' && dojo.byId('profileImg').src != '<%=ics.GetVar("cspath")%>/wemresources/images/emptyPhoto.png'){
					dojo.byId('profileImg').src = '<%=ics.GetVar("cspath")%>/wemresources/images/emptyPhoto.png';
				}
				dijit.byId('hRemove').set('disabled',true);
				//Clear the imagesrc element
				dojo.byId("wem:AdminUI:imagesrc").value = '';
			});		
		});		
	};

	dojo.addOnLoad(function() {
		var buildUploaderUrl = function() {
			return '<%=ics.GetVar("uploadhandler")%>';
		};
		
		var attrs = {
			uploadUrl: buildUploaderUrl(),
			uploadOnChange: true,
			buttonWidth: 110,
			buttonHeight: 34,
			progressTarget: dojo.byId("progressBarProfileNode"),
			buttonAction: -100,
			forceHTMLUploader: <%=forceHTMLUploader.toLowerCase()%>,
			token: '<%= InsiteUtil.getUploadToken(ics) %>',
			identifier: '<%= session.getId() %>',
			_authkey_: '<%= (String)session.getAttribute("csrfuuid") %>'
		};
		
		var browseButton = new fw.ui.dijit.Button({
			title : fw.util.getString("UI/Forms/Browse"), 
			label : fw.util.getString("UI/Forms/Browse"),
			buttonStyle: "grey",
			buttonType: "Continue wemButtonStyle"
		});
		dojo.place(browseButton.domNode, dojo.byId("buttonProfileNode"));
		if(dojo.isIE){
			SWFUpload.prototype.getFlashHTML = function () {
				return ['<object id="', this.movieName, '" type="application/x-shockwave-flash" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" data="', this.settings.flash_url, '" width="', this.settings.button_width, '" height="', this.settings.button_height, '" class="swfupload">',
						'<param name="wmode" value="', this.settings.button_window_mode, '" />',
						'<param name="movie" value="', this.settings.flash_url, '" />',
						'<param name="quality" value="high" />',
						'<param name="menu" value="false" />',
						'<param name="allowScriptAccess" value="always" />',
						'<param name="flashvars" value="' + this.getFlashVars() + '" />',
						'</object>'].join("");						
			};
		}
		var fileUploader = new fw.ui.dijit.SWFUpload(attrs, dojo.byId("swfUploadProfileNode"));
		dojo.connect(fileUploader, 'uploadStart', fileUploader._uploader, function(file) {
			this.addPostParam("token",'<%= InsiteUtil.getUploadToken(ics) %>');
			this.addPostParam("identifier",'<%= session.getId() %>');
			this.addPostParam("_authkey_",'<%= session.getAttribute("_authkey_") %>');
			this.addPostParam("_authtoken_",'<%= (String)session.getAttribute("csrfuuid") %>');
		});
		dojo.connect(fileUploader, 'onFileQueued', function(file) {
			if(this._nonflashuploader) {
				this._nonflashuploader.postData = dojo.mixin(this._nonflashuploader.postData, {
					"_authkey_": '<%= session.getAttribute("_authkey_") %>'
				});
			}
		});
		dojo.connect(fileUploader, 'uploadComplete', function(file) {});
		dojo.connect(fileUploader, 'uploadError', function(file, errorCode, message) {});
		dojo.connect(fileUploader, 'onFileComplete', function(dataArray) {
			if(this._nonflashuploader) {
				dojo.forEach(dataArray, function(d){
					//in Dojo 1.6, params are buried one level down
					d = d.additionalParams;
					if(d.thumbimagesrc){
						var thumbImage = 'data:' + d.mimetype + ';base64,' + d.thumbimagesrc;
						if(dojo.isIE < 9) {
							elementsImageReplacement.hasRequiredFlashVersion();
							elementsImageReplacement.display(d.thumbimagesrc.substring(d.thumbimagesrc.indexOf(',')+1),"profileImgDiv",90,90);				
						} 
						else if (dojo.isIE) {
							var imgDiv = dojo.byId('profileImgDiv');
							var imgElm = dojo.query('[id=profileImg]', imgDiv)[0];
							dojo.attr(imgElm, "src", thumbImage);
							dojo.style(imgElm, "width", '90px');
							dojo.style(imgElm, "height", '90px');
						} 
						else {
							changeDivImage(thumbImage);
						}
						if(d.imagesrc){
							var imageOrig = 'data:' + d.mimetype + ';base64,' + d.imagesrc;
							dojo.byId("wem:AdminUI:imagesrc").value = imageOrig;
						}
						dijit.byId('hRemove').set('disabled',false);
					}					
				});
			}		
		});
		dojo.connect(fileUploader, 'onFileQueued', function(file) {
			var xhrProps = {
				url: dojo.config.fw_csPath + 'wem/fatwire/wem/ui/Ping',
				handleAs: 'json',
				error: function(err) {
					wemcontext.directToLoginPage();
				}
			};
			return dojo.xhrGet(xhrProps);});
		dojo.connect(fileUploader, "uploadSuccess", function(file, serverData){
			var responseText = serverData, d;
			if (responseText) {
				try {
					d = dojo.fromJson(responseText);
				} catch (e) {
					console.debug("[SWFUpload uploadSuccess] Server data is not json: ", responseText.length);
				}
			}
			if(d && dojo.isObject(d) && d.thumbimagesrc){
				var thumbImage = 'data:' + d.mimetype + ';base64,' + d.thumbimagesrc;
				if(dojo.isIE < 9) {
					elementsImageReplacement.hasRequiredFlashVersion();
					elementsImageReplacement.display(d.thumbimagesrc.substring(d.thumbimagesrc.indexOf(',')+1),"profileImgDiv",90,90);				
				} else if (dojo.isIE) {
					var imgDiv = dojo.byId('profileImgDiv');
					var imgElm = dojo.query('[id=profileImg]', imgDiv)[0];
					dojo.attr(imgElm, "src", thumbImage);
					dojo.style(imgElm, "width", '90px');
					dojo.style(imgElm, "height", '90px');
				} else {
					changeDivImage(thumbImage);
				}
				if(d.imagesrc){
					var imageOrig = 'data:' + d.mimetype + ';base64,' + d.imagesrc;
					dojo.byId("wem:AdminUI:imagesrc").value = imageOrig;
				}
				dijit.byId('hRemove').set('disabled',false);
			}
		});
		if(dojo.isIE < 9) fileUploader.startup();
	});
	changeDivImage = function(url)
	{
		document.getElementById("profileImg").src = url;
	};
</script>

<div class="row">
	<label><xlat:stream key="fatwire/wem/admin/user/edit/ImagePreview"/></label>
	<div id="profileImgDiv" display="inline" class='profile'><img id="profileImg" src="<%=ics.GetVar("cspath")%>/wemresources/images/emptyPhoto.png"/></div>
</div>
<div style="float: left; margin-top:35px; width: 300px; padding-left: 20px;">
	<div class='SWFUploadProfileDiv'>	
		<span id='swfUploadProfileNode'></span>
		<span id='buttonProfileNode'></span>
	</div>
	
	<div style="vertical-align: top;display: inline-block;" >	
		<button dojoType="fw.ui.dijit.Button" style="padding-left: 20px" id="hRemove" buttonStyle="grey" buttonType="Delete wemButtonStyle" disabled="true">
		<xlat:stream  key='fatwire/wem/admin/common/actions/Remove'/>
		</button>
	</div>
	<div  id="progressBarProfileNode"></div>
</div>		
<div class="clear"></div>

</cs:ftcs>