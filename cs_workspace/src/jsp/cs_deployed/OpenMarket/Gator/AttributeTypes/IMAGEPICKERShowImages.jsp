<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.fatwire.search.source.SearchIndexFields"
%><%@ page import="java.text.NumberFormat"
%><%@ page import="java.text.DecimalFormat"
%><%@ page import="javax.imageio.ImageIO"
%><%@ page import="java.awt.Image"
%><%@ page import="java.io.File"
%><%@ page import="com.fatwire.realtime.util.Util"
%><%@ page import="java.util.*"%><%!
String formatBytes(long size) {
    NumberFormat formatter = new DecimalFormat("#0.00 KB");
    return formatter.format( size / 1024d );
}
boolean getDimensions(ICS ics, String widthVar, String heightVar, String sizeVar, String pathVar) {
    Image image = null;
    int width = 0;
    int height = 0;
    try {
    	if (ics.GetVar(pathVar) != null) {
	        File blobFile = new File(ics.GetVar(pathVar));
	        ics.SetVar(sizeVar, formatBytes(blobFile.length()));
    	    image = ImageIO.read(blobFile);
        	width = image.getWidth(null);
	        height = image.getHeight(null);
    	    ics.SetVar(widthVar, String.valueOf(width));
	        ics.SetVar(heightVar, String.valueOf(height));
	   	}
    } catch(Exception e) {
        ics.LogMsg(e.toString());
    }
    return (width <= height); // returns true/false for portrait/landscape
}
%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<ics:setvar name="imagepath" value='<%=ics.GetProperty("ft.cgipath") + "Xcelerate/graphics"%>' />
<string:encode variable="ASSETTYPENAMEOUT" varname="ASSETTYPENAMEOUT"/>
<string:encode variable="ATTRIBUTEID" varname="ATTRIBUTEID"/>
<string:encode variable="ATTRIBUTENAMEOUT" varname="ATTRIBUTENAMEOUT"/>
<string:encode variable="ATTRIBUTETYPENAMEOUT" varname="ATTRIBUTETYPENAMEOUT"/>
<string:encode variable="CATEGORYATTRIBUTENAMEOUT" varname="CATEGORYATTRIBUTENAMEOUT"/>
<string:encode variable="RESTRICTEDCATEGORYLISTOUT" varname="RESTRICTEDCATEGORYLISTOUT"/>
<string:encode variable="imagesizeselect" varname="imagesizeselect"/>
<string:encode variable="searchterm" varname="searchterm"/>
<string:encode variable="sortBy" varname="sortBy"/>
<string:encode variable="AttrName" varname="AttrName"/>
<string:encode variable="ascending" varname="ascending"/>
<string:encode variable="cs_callback" varname="cs_callback"/>
<html>
<%
	String sImageSize ="";
	if(ics.GetVar("imagesizeselect")!=null)
	{
		sImageSize = ics.GetVar("imagesizeselect");
	}
	else
	{
		sImageSize = "100";
	}
	String resultsPerPage=ics.GetVar("resultsPerPage");
	if(resultsPerPage == null){
		resultsPerPage = "10";
	}

	String sortBy=ics.GetVar("sortBy");
	if(sortBy == null){
		sortBy = SearchIndexFields.Global.NAME;
	}

	String ascending=ics.GetVar("ascending");
	if(ascending == null){
		ascending = "true";
	}

	String sCategory = "";
	if(ics.GetVar("category")!=null)
		sCategory = ics.GetVar("category");
%>
<string:encode variable="fieldname" varname="fieldname"/>
<head>
    <link href='<%=ics.GetProperty("ft.cgipath") + "Xcelerate/data/css/" + ics.GetSSVar("locale") + "/wemAdvancedUI.css"%>' rel="stylesheet" type="text/css"/>
	<link href='<%=ics.GetProperty("ft.cgipath") + "Xcelerate/data/css/" + ics.GetSSVar("locale") + "/common.css"%>' rel="stylesheet" type="text/css"/>
	<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
		<ics:argument name="cssFilesToLoad" value="common.css,wemAdvancedUI.css"/>
	</ics:callelement>
	<style type="text/css" media="all">
        body {
            font-family : verdana,arial,helvetica,sans-serif;
            background: #eaeaea;
			margin:0;
        }

        .imagename {
            font-size: xx-small;
            font-weight: bold;
            display: block;
		}
        .warning {
            color: #FF0000;
            font-size: xx-small;
        }
		.individualImage2{
			float: left;
            margin: 0px;
            border-style: solid;
            border-width: 1px;
            border-color: #006699;
            text-align: center;
            background: #fff;
            text-align: center;
		}
        .dimension {font-size: xx-small;color:#919191;white-space: nowrap;}
        .mimetype {font-size: xx-small;display:block;color:#919191;}
        h3 {
            color: #333333;
            font-size: medium;
            font-weight: bold;
        }
        /* Added by Greg */
        label {
        	color: #fff;
        	font-size: small;
        	font-weight: bold;
        }

        #ImageSizeFormContainer {
        	float: right;
        }

        #searchtable {
        	<%
         	  out.println("visibility: visible");
        	%>
        }
		a:link {text-decoration: none;color: #fff}
		a:visited {text-decoration: none;color: #fff}
		a:active {text-decoration: none;color: #fff}
		a:hover {text-decoration: underline;color: #fff}
		
		.navtab a:link {text-decoration: none;color: #4A91B8}
		.navtab a:visited {text-decoration: none;color: #4A91B8}
		.navtab a:active {text-decoration: none;color: #4A91B8}
		.navtab a:hover {text-decoration: underline;color: #4A91B8}
		
		.searchTab{
			position:relative;
			top:10px;
		}
		
		.searchTab a:hover {text-decoration: none;color: #fff}
		.navtab{
			font-weight:bold;
			text-align:right;
		}
		#shadow-container {
			margin:0 auto;
			position: relative;
			display:table;/*firefox fix*/
			width:<%=sImageSize%>px;
		}
        #shadow-container .shadow2,
		#shadow-container .shadow3,
		#shadow-container .shadow4,
		#shadow-container .container {
			position: relative;
			left: -1px;
			top: -1px;
		}
		#shadow-container .shadow1 {
			background: #e9e9e9;
		}
		#shadow-container .shadow2 {
			background: #e0e0e0;
		}
		#shadow-container .shadow3 {
			background: #d1d1d1;
		}
		#shadow-container .shadow4 {
			background: #c6c6c6;
		}
		#shadow-container .container {
        background: #fff;
        border: 1px solid #555;
        padding:5px;
		}

		.input{
		border-width:2px;
		color:#333333;
		font-family:verdana,arial,helvetica,sans-serif;
		font-size:11px;
		padding:1px 3px 1px 4px;
		}
	</style>
    <script>
	var advancedUI = true;
	var csForm = window.opener.document.forms["AppForm"];
	if( csForm == null){
		//this must be the dashboard UI
		advancedUI = false;
		csForm = window.opener.document.forms["mainForm"];
	}

	function submitForm(){
		clearDefaultText();
		document.searchForm.submit();
	}

	function clearDefaultText(){
		if(document.searchForm.searchterm.value == '<%=Util.xlatLookup(ics,"fatwire/Alloy/UI/EnterSearchTextHere")%>'){
			document.searchForm.searchterm.value="";
		}
	}

	function selectImage(image,actualimage,filename, subtype, name)
	{
        <%String fieldName = ics.GetVar("fieldname"),
        		 attrName = ics.GetVar("AttrName");
        	
        %>
        if( advancedUI ){ <%
				// if opened from image editor
				if (fieldName != null && fieldName.startsWith("oie_")) {%>
					var imageUrl = 'BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage + '&oieloadpicture=' + filename;
					var callback = window.opener.<%=ics.GetVar("cs_callback")%>;
					callback('<%=fieldName%>', imageUrl, '<%= attrName %>');
				<%}else if (fieldName != null && fieldName.startsWith("clarkii_")) {%>
	    	    			var imageUrl = 'BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage + '&oieloadpicture=' + filename;
					var callback = window.opener.<%=ics.GetVar("cs_callback")%>;
					callback('<%=fieldName%>', imageUrl, '<%= attrName %>');	
				<%} else { %>
    			//csForm.elements['<%= ics.GetVar("fieldname")%>'].value=image;				
				window.opener.pickImageInToDnDSrc(image, name, subtype, '<%=ics.GetVar("ATTRIBUTEID")%>', '<%=ics.GetVar("ASSETTYPENAMEOUT")%>', '<%=ics.GetVar("ATTRIBUTENAMEOUT")%>');					
    			//window.opener.document.images['<%= ics.GetVar("fieldname")%>'].src= 'BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage;
				<%}%>
		}
		else{
	        //dash UI
            <%if (fieldName != null && fieldName.startsWith("oie_")) {%>
                    //image editor
                    var imageUrl = '../../BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage + '&oieloadpicture=' + filename;
					var callback = window.opener.<%=ics.GetVar("cs_callback")%>;
					callback('<%=fieldName%>', imageUrl, '<%= attrName %>');
	        <%}
	    else if (fieldName != null && fieldName.startsWith("clarkii_")) {%>
	    	    var imageUrl = 'BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage + '&oieloadpicture=' + filename;
					var callback = window.opener.<%=ics.GetVar("cs_callback")%>;
					callback('<%=fieldName%>', imageUrl, '<%= attrName %>');	
	    <%}
            else{%>
                //normal imagePicker
			    csForm.elements['<%= ics.GetVar("fieldname")%>'].value='<%=ics.GetVar("ASSETTYPENAMEOUT")%>:' + image;
    			window.opener.document.images['<%= ics.GetVar("fieldname")%>_IMG'].src= '../../BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&csblobid=' + <%=ics.GetSSVar("csblobid")%> + '&blobwhere=' + actualimage;

               // PR#20048 Added Source Hidden Filed to hold the new updated Asset
               csForm.elements['<%= ics.GetVar("fieldname")%>_SRC'].value= '../../BlobServer?blobcol=urldata&blobtable=MungoBlobs&blobkey=id&blobwhere=' + actualimage;

                <%
            }%>
        }
	}

	function selectImageForFCK(imageId){
		var imageAssetType = '<%=ics.GetVar("ASSETTYPENAMEOUT")%>';
		document.forms['searchForm'].elements['pagename'].value="OpenMarket/Xcelerate/Actions/AddInclusion";
		if("true"=="<%=ics.GetVar("IFCKEditor")%>"){
			document.forms['searchForm'].elements['tn_id'].value = imageId;
			document.forms['searchForm'].elements['tn_AssetType'].value = imageAssetType;
			document.forms['searchForm'].elements['name'].value = document.forms[0].elements['FCKName'].value;
			document.forms['searchForm'].elements['AssetType'].value =document.forms[0].elements['FCKAssetType'].value;
			//Check if the asset is linking to itself.
				if( imageAssetType == '<%=ics.GetVar("FCKAssetType")%>' && imageId =='<%=ics.GetVar("FCKAssetId")%>'){
					alert("<xlat:stream key='dvin/UI/CannotAddSelfInclude' encode='false' escape='true'/>");
					return false;
				}
		}
		document.forms['searchForm'].submit();
	}
		
    </script>
    <!-- ADDED BY GREG HINTS.JS -->
	<script language="JavaScript">
		// Title: Tigra Hints
		// URL: http://www.softcomplex.com/products/tigra_hints/
		// Version: 1.4
		// Date: 04/16/2006
		// Note: Permission given to use this script in ANY kind of applications if
		//    header lines are left unchanged.

		var THintsS = [];
		function THints (o_cfg, items) {
			this.n_id = THintsS.length;
			THintsS[this.n_id] = this;
			this.top = o_cfg.top ? o_cfg.top : 0;
			this.left = o_cfg.left ? o_cfg.left : 0;
			this.n_dl_show = o_cfg.show_delay;
			this.n_dl_hide = o_cfg.hide_delay;
			this.b_wise = o_cfg.wise;
			this.b_follow = o_cfg.follow;
			this.x = 0;
			this.y = 0;
			this.divs = [];
			this.iframes = [];
			this.show  = TTipShow;
			this.showD = TTipShowD;
			this.hide = TTipHide;
			this.move = TTipMove;
			// register the object in global collection
			this.n_id = THintsS.length;
			THintsS[this.n_id] = this;
			// filter Netscape 4.x out
			if (document.layers) return;
			var b_IE = navigator.userAgent.indexOf('MSIE') > -1,
			s_tag = ['<iframe frameborder="0" scrolling="No" id="TTifip%name%" style="visibility:hidden;position:absolute;top:0px;left:0px;',   b_IE ? 'width:1px;height:1px;' : '', o_cfg['z-index'] != null ? 'z-index:' + o_cfg['z-index'] : '', '" width=1 height=1></iframe><div id="TTip%name%" style="visibility:hidden;position:absolute;top:0px;left:0px;',   b_IE ? 'width:1px;height:1px;' : '', o_cfg['z-index'] != null ? 'z-index:' + o_cfg['z-index'] : '', '"><table cellpadding="0" cellspacing="0" border="0"><tr><td class="', o_cfg.css, '" nowrap>%text%</td></tr></table></div>'].join('');


			this.getElem =
				function (id) { return document.all ? document.all[id] : document.getElementById(id); };
			this.showElem =
				function (id, hide) {
				this.divs[id].o_css.visibility = hide ? 'hidden' : 'visible';
				this.iframes[id].o_css.visibility = hide ? 'hidden' : 'visible';
				};

			document.onmousemove = f_onMouseMove;
			if (window.opera)
				this.getSize = function (id, b_hight) {
					return this.divs[id].o_css[b_hight ? 'pixelHeight' : 'pixelWidth']
				};
			else
				this.getSize = function (id, b_hight) {
					return this.divs[id].o_obj[b_hight ? 'offsetHeight' : 'offsetWidth']
				};
			for (i in items) {
				document.write (s_tag.replace(/%text%/g, items[i]).replace(/%name%/g, i));
				this.divs[i] = { 'o_obj' : this.getElem('TTip' + i) };
				this.divs[i].o_css = this.divs[i].o_obj.style;
				this.iframes[i] = { 'o_obj' : this.getElem('TTifip' + i) };
				this.iframes[i].o_css = this.iframes[i].o_obj.style;

			}
		}
		function TTipShow (id) {
			if (document.layers) return;
			this.hide();
			if (this.divs[id]) {
				if (this.n_dl_show) this.divs[id].timer = setTimeout('THintsS[' + this.n_id + '].showD("' + id + '")', this.n_dl_show);
				else this.showD(id);
				this.visible = id;
			}
		}

		function TTipShowD (id) {
			this.move(id);
			this.showElem(id);
			if (this.n_dl_hide) this.timer = setTimeout("THintsS[" + this.n_id + "].hide()", this.n_dl_hide);
		}

		function TTipMove (id) {
			var	n_win_l = f_scrollLeft(),
				n_win_t = f_scrollTop();

			var n_x = window.n_mouseX + n_win_l + this.left,
				n_y = window.n_mouseY + n_win_t + this.top;

			window.status = n_x;
			if (this.b_wise) {
				var n_w = this.getSize(id), n_h = this.getSize(id, true),
				n_win_w = f_clientWidth(), n_win_h = f_clientHeight();

				if (n_x + n_w > n_win_w + n_win_l) n_x = n_win_w + n_win_l - n_w;
				if (n_x < n_win_l) n_x = n_win_l;
				if (n_y + n_h > n_win_h + n_win_t) n_y = n_win_h + n_win_t - n_h;
				if (n_y < n_win_t) n_y = n_win_t;
			}
			this.divs[id].o_css.left = n_x + 'px';
			this.divs[id].o_css.top = n_y + 'px';
			this.iframes[id].o_css.left = n_x + 'px';
			this.iframes[id].o_css.top = n_y + 'px';
			this.iframes[id].o_css.height = (n_h-this.top) + 'px';
			this.iframes[id].o_css.width = (this.getSize(id, false)-this.left) + 'px';
		}

		function TTipHide () {
			if (this.timer) clearTimeout(this.timer);
			if (this.visible != null) {
				if (this.divs[this.visible].timer) clearTimeout(this.divs[this.visible].timer);
				setTimeout('THintsS[' + this.n_id + '].showElem("' + this.visible + '", true)', 10);
				this.visible = null;
			}
		}

		function f_onMouseMove(e_event) {
			if (!e_event && window.event) e_event = window.event;
			if (e_event) {
				window.n_mouseX = e_event.clientX;
				window.n_mouseY = e_event.clientY;
			}
			return true;
		}
		function f_clientWidth() {
			if (typeof(window.innerWidth) == 'number')
				return window.innerWidth;
			if (document.documentElement && document.documentElement.clientWidth)
				return document.documentElement.clientWidth;
			if (document.body && document.body.clientWidth)
				return document.body.clientWidth;
			return null;
		}
		function f_clientHeight() {
			if (typeof(window.innerHeight) == 'number')
				return window.innerHeight;
			if (document.documentElement && document.documentElement.clientHeight)
				return document.documentElement.clientHeight;
			if (document.body && document.body.clientHeight)
				return document.body.clientHeight;
			return null;
		}
		function f_scrollLeft() {
			if (typeof(window.pageXOffset) == 'number')
				return window.pageXOffset;
			if (document.body && document.body.scrollLeft)
				return document.body.scrollLeft;
			if (document.documentElement && document.documentElement.scrollLeft)
				return document.documentElement.scrollLeft;
			return 0;
		}
		function f_scrollTop() {
			if (typeof(window.pageYOffset) == 'number')
				return window.pageYOffset;
			if (document.body && document.body.scrollTop)
				return document.body.scrollTop;
			if (document.documentElement && document.documentElement.scrollTop)
				return document.documentElement.scrollTop;
			return 0;
		}
</script>
</head>
<body>
<satellite:form assembler="query" name="searchForm" method="POST">
	<input type="hidden" name="cs_callback" value="<ics:getvar name="cs_callback"/>"/>
	<input type="hidden" name="displayPage" value=""/>
	<input type="hidden" name="resultsPerPage" value="<%=resultsPerPage%>"/>
	<input type="hidden" name="sortBy" value="<%=sortBy%>"/>
	<input type="hidden" name="ascending" value="<%=ascending%>"/>
	<input type="hidden" name="ATTRIBUTEID" value="<%=ics.GetVar("ATTRIBUTEID")%>"/>
	<ics:if condition='<%= "true".equals(ics.GetVar("IFCKEditor"))%>'>
    <ics:then>
		<INPUT TYPE="HIDDEN" NAME="formFieldName" VALUE='<%=ics.GetVar("formFieldName")%>'/>
		<INPUT TYPE="HIDDEN" NAME="fieldname" VALUE='<%=ics.GetVar("fieldname")%>'/>
		<INPUT TYPE="HIDDEN" NAME="FCKName" VALUE='<%=ics.GetVar("FCKName")%>'/>
		<INPUT TYPE="HIDDEN" NAME="fielddesc" VALUE='<%=ics.GetVar("fielddesc")%>'/>
		<INPUT TYPE="HIDDEN" NAME="FCKAssetId" VALUE='<%=ics.GetVar("FCKAssetId")%>'/>
		<INPUT TYPE="HIDDEN" NAME="FCKAssetType" VALUE='<%=ics.GetVar("FCKAssetType")%>'/>
		<INPUT TYPE="HIDDEN" NAME="IFCKEditor" VALUE='<%=ics.GetVar("IFCKEditor")%>'/>
		<INPUT TYPE="HIDDEN" NAME="tn_id" VALUE=""/>
		<!-- name and AssetType are dummy fields and their values will be replaced by the values of FCKname and FCKAssetType
		fields before submitting to AddInclusion page -->
		<INPUT TYPE="HIDDEN" NAME="name" VALUE=""/>
		<INPUT TYPE="HIDDEN" NAME="AssetType" VALUE=""/>
		<INPUT TYPE="HIDDEN" NAME="tn_AssetType" VALUE=""/>
	</ics:then>
	</ics:if>
	<div class="topMenuBar">
		<div style="width:100%;text-align:center;color: #FFFFFF;font-size: 18px;padding-top: 10px;">Image Picker</div>
	</div>
	<div style="height:42px;background:#555;margin-top:-3px;z-index:2">
	<span style="position:relative;top:9px">
	  <label style="margin-left:20px;font-size:x-small;"><xlat:stream key="dvin/UI/ThumbnailSize"/>: </label></span><span style="position:relative;top:11px"><select class="input" name="imagesizeselect" onchange="submitForm();">
		<option <%if(sImageSize.equals("100")){%>selected <%}%>value="100">100 pixels&nbsp;</option>
		<option <%if(sImageSize.equals("125")){%>selected <%}%>value="125">125 pixels&nbsp;</option>
		<option <%if(sImageSize.equals("150")){%>selected <%}%>value="150">150 pixels&nbsp;</option>
		<option <%if(sImageSize.equals("175")){%>selected <%}%>value="175">175 pixels&nbsp;</option>
		<option <%if(sImageSize.equals("200")){%>selected <%}%>value="200">200 pixels&nbsp;</option>
	</select></span><span style="position:relative;top:9px;font-size:xx-small;">
	<label style="margin-left:20px;font-size:x-small;"><xlat:stream key="dvin/UI/ImagesPerPage"/>:</label>
	<a href="#" onClick="document.searchForm.resultsPerPage.value='10';submitForm();">10</a>
	<a href="#" onClick="document.searchForm.resultsPerPage.value='25';submitForm();">25</a>
	<a href="#" onClick="document.searchForm.resultsPerPage.value='50';submitForm();">50</a>
	<a href="#" onClick="document.searchForm.resultsPerPage.value='100';submitForm();">100</a>
	</span>
	<div style="float:right">
		<table id="searchtable" cellpadding="0" cellspacing="0" border="0" class="searchTab">
		<tr>
			  <td></td>
			  <td></td>
			  <td style="padding-bottom:5px;" nowrap>
			  	<%
			  		String sSearchTerm=Util.xlatLookup(ics,"fatwire/Alloy/UI/EnterSearchTextHere");
			  		if(ics.GetVar("searchterm")!=null)
			  		{
			  			sSearchTerm=ics.GetVar("searchterm");
			  		}
			  	%>
				<input class="input" size="32" name="searchterm" type="text" value='<%=sSearchTerm%>' onClick="clearDefaultText();"/>&nbsp;&nbsp;
			  </td>
			<td style="vertical-align:bottom;text-align:left;">
			<a onclick="submitForm();" href="#">
				<xlat:lookup key="UI/Forms/Search" varname="_XLAT_" escape="true"/>
				<xlat:lookup key="UI/Forms/Search" varname="_ALT_"/>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Search"/></ics:callelement>
			</a>
			</td>
		</tr>
		</table>
	</div>
	</div>
	<table cellpadding="0" cellspacing="0" border="0">
  	<tr>
  	  <td>&nbsp;</td>
	</tr>
	</table>
	<%-- added by Greg --%>
	<ics:if condition='<%=Utilities.goodString(ics.GetVar("RESTRICTEDCATEGORYLISTOUT"))%>'>
	<ics:then>
		<input type="hidden" name="RESTRICTEDCATEGORYLISTOUT" value='<%=ics.GetVar("RESTRICTEDCATEGORYLISTOUT")%>'/>
		<%
		String catList = ics.GetVar("RESTRICTEDCATEGORYLISTOUT");
		StringTokenizer Tok = new StringTokenizer(catList,",");
		%>
		<listobject:create name="categoryListObj" columns="value"/>
		<%
		while(Tok.hasMoreElements())
		{
		%>
		<listobject:addrow name="categoryListObj">
			<listobject:argument name="value" value='<%=Tok.nextToken()%>'/>
		</listobject:addrow>
		<%
		}
		%>
		<listobject:tolist name="categoryListObj" listvarname="categoryList" />
	</ics:then>
	</ics:if>
	<ics:if condition='<%=Utilities.goodString(ics.GetVar("CATEGORYATTRIBUTENAMEOUT"))%>'>
	<ics:then>
		<select name="category" onchange="submitForm();">

		<ics:if condition='<%=!Utilities.goodString(ics.GetVar("RESTRICTEDCATEGORYLISTOUT"))%>'>
		<ics:then>
			<searchstate:create name="ss" />
			<assetset:setsearchedassets name="allCategories" assettypes='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' constraint="ss" site='<%=ics.GetSSVar("pubid")%>' />
			<assetset:getattributevalues name="allCategories" attribute='<%=ics.GetVar("CATEGORYATTRIBUTENAMEOUT")%>' ordering="ascending" listvarname="categoryList" typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>'/>
		        <option value="" <%if(sCategory.equals("all")){out.print("selected");}%>>* ALL</option>
		</ics:then>
		<ics:else>
			<ics:if condition='<%=ics.GetVar("category")==null%>'>
			<ics:then>
				<ics:listget listname="categoryList" fieldname="value" output="category"/>
			</ics:then>
			</ics:if>
		</ics:else>
		</ics:if>
		<ics:listget listname="categoryList" fieldname="#numRows" output="numOfRows" />
		<ics:if condition='<%=Integer.parseInt(ics.GetVar("numOfRows") != null ? ics.GetVar("numOfRows") : "0")!=0%>'>
		<ics:then>
			<ics:listloop listname="categoryList">
				<ics:listget listname="categoryList" fieldname="value" output="current"/>
				<%String selected = (ics.GetVar("current") != null && ics.GetVar("current").equals(ics.GetVar("category"))?"selected":"");%>
				<option value="<ics:getvar name="current"/>" <%=selected%>><ics:getvar name="current"/></option>
			</ics:listloop>
		</ics:then>
		</ics:if>
		</select>
		<input type="hidden" name="CATEGORYATTRIBUTENAMEOUT" value='<%=ics.GetVar("CATEGORYATTRIBUTENAMEOUT")%>'/>
	</ics:then>
	</ics:if>
	<input type="hidden" name="fieldname" value='<%=ics.GetVar("fieldname")%>'/>
	<input type="hidden" name="ATTRIBUTETYPENAMEOUT" value='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>'/>
	<input type="hidden" name="ATTRIBUTENAMEOUT" value='<%=ics.GetVar("ATTRIBUTENAMEOUT")%>'/>
	<input type="hidden" name="ASSETTYPENAMEOUT" value='<%=ics.GetVar("ASSETTYPENAMEOUT")%>'/>
	<input type="hidden" name="pagename" value="OpenMarket/Gator/AttributeTypes/IMAGEPICKERShowImages"/>
	<input type="hidden" name="_charset_" value="<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini"/>"/>
	<input type="hidden" name="AttrName" value='<%=ics.GetVar("AttrName")%>'/>
</satellite:form>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/IMAGEPICKERSearchImages">
<ics:argument name="resultsPerPage" value="<%=resultsPerPage%>" />
<ics:argument name="sortBy" value="<%=sortBy%>" />
<ics:argument name="ascending" value="<%=ascending%>" />
</ics:callelement>
<ics:if condition='<%=ics.GetList("Images",false)!=null && ics.GetList("Images",false).hasData()%>'>
<ics:then>

<!-- ADDED BY GREG HINTS_CFG.JS -->
<script language="JavaScript">
	var HINTS_CFG = {
		'top'        : 5, // a vertical offset of a hint from mouse pointer
		'left'       : 5, // a horizontal offset of a hint from mouse pointer
		'css'        : 'hintsClass', // a style class name for all hints, TD object
		'show_delay' : 500, // a delay between object mouseover and hint appearing
		'hide_delay' : 2000, // a delay between hint appearing and hint hiding
		'wise'       : true,
		'follow'     : true,
		'z-index'    : 1 // a z-index for all hint layers
	},

	HINTS_ITEMS = {

	<ics:listloop listname="Images">
			<ics:listget listname="Images" fieldname="id" output="theId"/>
            <ics:listget listname="Images" fieldname="name" output="theName"/>
			<ics:listget listname="Images" fieldname="startdate" output="startDate" />
			<ics:listget listname="Images" fieldname="enddate" output="endDate" />
            <assetset:setasset name="theImage" type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' id='<%=ics.GetVar("theId")%>' />
            <assetset:getattributevalues name="theImage" attribute='<%=ics.GetVar("ATTRIBUTENAMEOUT")%>' listvarname="imageList" typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>' />
            
            <ics:if condition='<%=ics.GetList("imageList") != null && ics.GetList("imageList").hasData()%>'>
            <ics:then>
                <ics:listget listname="imageList" fieldname="value" output="imageId" />
                <ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
         			<ics:argument name = "columnvalue" value ='<%=ics.GetVar("imageId")%>'/>
         			<ics:argument name = "type" value ="Long"/>
         		</ics:callelement>
         		<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	            <ics:then>
 	            	<ics:sql sql='<%="select urldata,filevalue from MungoBlobs where id=" + ics.GetVar("imageId")%>' listname="blobdata" table="MungoBlobs" />
	                <ics:listget listname="blobdata" fieldname="filevalue" output="filevalue" />
					<ics:listget listname="blobdata" fieldname="urldata" output="urldata" />
	                <ics:setvar name="blobpath" value='<%=ics.GetProperty("cc.urlattrpath", "gator.ini", true) + ics.GetVar("urldata")%>' />
					<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DetermineFileType">
						<ics:argument name="filename" value='<%=ics.GetVar("filevalue")%>' />
					</ics:callelement>
					<ics:if condition='<%="true".equals(ics.GetVar("displayable"))%>'>
					<ics:then>
		                <render:getbloburl csblobid='<%=ics.GetSSVar("csblobid")%>' blobtable="MungoBlobs" blobcol="urldata" blobkey="id" blobwhere='<%=ics.GetVar("imageId")%>' outstr="thebloburl"/>
		            </ics:then>
		            <ics:else>
		            	<ics:setvar name="thebloburl" value='<%=ics.GetVar("imagepath")+"/imagepicker/notDisplayable.gif"%>' />
		            </ics:else>
		            </ics:if>
	                <%boolean isPortrait = getDimensions(ics, "width", "height", "size", "blobpath");%>
	                '<%=ics.GetVar("theId")%>':wrap_img("<%=ics.GetVar("thebloburl")%>","<span class='imagename'><ics:getvar name='theName'/></span><span class='dimension'><ics:getvar name='width'/> x <ics:getvar name='height' /> | <ics:getvar name='size'/></span><span class='mimetype'><ics:getvar name='filetype' /></span><span class='dimension'><ics:getvar name='startDate' /> | <ics:getvar name='endDate' /></span>"),
	            </ics:then>
	            </ics:if>
               </ics:then>
            </ics:if>
	</ics:listloop>

		'00':wrap_img("00", "just_here_to_maintain_end_of_array")
	};

	var myHint = new THints (HINTS_CFG, HINTS_ITEMS);


	function wrap (s_, b_ques) {
		return "<table cellpadding='0' cellspacing='0' border='0' style='-moz-opacity:90%;filter:progid:DXImageTransform.Microsoft.dropShadow(Color=#777777,offX=4,offY=4)'><tr><td rowspan='2'><img src='img/1"+(b_ques?"q":"")+".gif'></td><td><img src='/img/pixel.gif' width='1' height='15'></td></tr><tr><td background='img/2.gif' height='28' nowrap>"+s_+"</td><td><img src='img/4.gif'></td></tr></table>"
	}

	function wrap_img (s_file, s_title) {
		return "<table class='individualImage2' cellpadding=0 bgcolor=white style='border:1px solid #777777'><tr><td><img src='"+s_file+"' class='picI'></td></tr><tr><td align=center>"+s_title+"</td></tr></table>"
	}



</script>


<table width="100%" border="0"><tr>
<td width="70%">
<table width="100%" border="0" cellpadding="10">
<%
int j=0;
for(int i=1;i<=20;i++){
if(j%5==0){
%>
<tr >
<%
}
int srow = j+1;
int erow = j+6;
%>
	<ics:listloop listname="Images" startrow="<%=srow%>" endrow="<%=erow%>">
	<td align="center" valign="top">
	    <ics:listget listname="Images" fieldname="id" output="theId"/>
            <ics:listget listname="Images" fieldname="name" output="theName"/>
			<ics:listget listname="Images" fieldname="startdate" output="startDate" />
			<ics:listget listname="Images" fieldname="enddate" output="endDate" />
			<asset:getsubtype type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' objectid='<%=ics.GetVar("theId")%>' output="SubTypeCheck" />
            <assetset:setasset name="theImage" type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' id='<%=ics.GetVar("theId")%>' />
            <assetset:getattributevalues name="theImage" attribute='<%=ics.GetVar("ATTRIBUTENAMEOUT")%>' listvarname="imageList" typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>' />
			
			<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
     			<ics:argument name = "val_variable" value ='<%=ics.GetVar("imageId")%>'/>
     			<ics:argument name = "dataType" value ="long"/>
     		</ics:callelement>
     	
            <ics:if condition='<%=ics.GetList("imageList") != null&& ics.GetList("imageList").hasData() && "true".equals(ics.GetVar("isDataValid"))%>'>
            <ics:then>
                <ics:listget listname="imageList" fieldname="value" output="imageId" />
                <ics:sql sql='<%="select urldata,filevalue from MungoBlobs where id=" + ics.GetVar("imageId")%>' listname="blobdata" table="MungoBlobs" />
                <ics:listget listname="blobdata" fieldname="filevalue" output="filevalue" />
				<ics:listget listname="blobdata" fieldname="urldata" output="urldata" />
                <ics:setvar name="blobpath" value='<%=ics.GetProperty("cc.urlattrpath", "gator.ini", true) + ics.GetVar("urldata")%>' />
                <ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DetermineFileType">
                	<ics:argument name="filename" value='<%=ics.GetVar("filevalue")%>' />
                </ics:callelement>
                <ics:if condition='<%="true".equals(ics.GetVar("displayable"))%>'>
                <ics:then>
				<%boolean isPortrait = getDimensions(ics, "width", "height", "size", "blobpath");%>
				<table cellpadding="0"><tr><td style="text-align:center;vertical-align:top;" nowrap>
	<div id="shadow-container">
        <div class="shadow1">
            <div class="shadow2">
                <div class="shadow3">
					<div class="shadow4">
	                <div class="container"><table><tr><td style="vertical-align:middle;text-align:center;font-size:0;line-height:0;padding:0;width:<%=sImageSize%>px;height:<%=sImageSize%>px;
			"><a onMouseOver="myHint.show('<%=ics.GetVar("theId")%>')" onMouseOut="myHint.hide()" onClick="if('true' == '<%=ics.GetVar("IFCKEditor")%>'){selectImageForFCK('<%= ics.GetVar("theId")%>');}else {selectImage('<%= ics.GetVar("theId")%>','<%= ics.GetVar("imageId")%>','<%=ics.GetVar("filevalue")%>', '<%=ics.GetVar("SubTypeCheck")%>', '<%=ics.GetVar("theName")%>' );window.close();} return false;" href="#">
    	            <satellite:blob csblobid='<%=ics.GetSSVar("csblobid")%>' blobtable="MungoBlobs" blobcol="urldata" blobkey="id" blobwhere='<%=ics.GetVar("imageId")%>' container="servlet">
        	            <satellite:parameter name="border" value="0"/>
            	        <satellite:parameter name='<%=(isPortrait?"height":"width")%>' value='<%=sImageSize%>'/>
                	</satellite:blob>
	                </a></td></tr></table></div></div>
                </div>
            </div>
        </div>
				</div></td></tr><tr><td style="text-align:center;vertical-align:top;">
				  <span class="imagename">
				  <%
				  String imageName ="";
				  /*Limit the characters in the name of the image to 15 to have good look and feel of the UI*/
				  if(ics.GetVar("theName")!=null && ics.GetVar("theName").trim().length() !=0){
					if(ics.GetVar("theName").trim().length() > 15){
						imageName = ics.GetVar("theName").substring(0,16) + "...";
					} else {
						imageName = ics.GetVar("theName");
					}
				  }
				  %><%=imageName%>
				  </span>
    	            <span class="dimension"><ics:getvar name="width"/> x <ics:getvar name="height" /> | <ics:getvar name="size" /></span>
        	        <span class="mimetype"><ics:getvar name="filetype" /></span>
					<span class="dimension"><ics:getvar name="startDate" /> | <ics:getvar name="endDate" /></span></td></tr></table>
				</ics:then>
                <ics:else>
	                <a onMouseOver="myHint.show('<%=ics.GetVar("theId")%>')" onMouseOut="myHint.hide()" onClick="selectImage('<%= ics.GetVar("theId")%>','<%= ics.GetVar("imageId")%>','<%=ics.GetVar("filevalue")%>'); window.close(); return false;" href="#">
						<img src="<ics:getvar name="imagepath"/>/imagepicker/notDisplayable.gif"/>
	                </a></ics:else>
                </ics:if>
            </ics:then>
            <ics:else>
				<table cellpadding="0"><tr><td style="text-align:center;vertical-align:top;font-size:8" nowrap>
					<div id="shadow-container">
						<div style="width:<%=sImageSize%>px;height:<%=sImageSize%>px " class="container"><xlat:stream key="dvin/AT/Common/ImageNotAvailable" />									</div>
					</div></td></tr><tr><td style="text-align:center;vertical-align:top;">
				  <span class="imagename">
				  <%
				  String imageName ="";
				  /*Limit the characters in the name of the image to 15 to have good look and feel of the UI*/
				  if(ics.GetVar("theName")!=null && ics.GetVar("theName").trim().length() !=0){
					if(ics.GetVar("theName").trim().length() > 15){
						imageName = ics.GetVar("theName").substring(0,16) + "...";
					} else {
						imageName = ics.GetVar("theName");
					}
				  }
				  %><%=imageName%>
				  </span>
					<span class="dimension">Image Not Available</span>
				</td></tr></table>
 			</ics:else>
			</ics:if>
		</td>
		</ics:listloop>
<% if(j%5==0){
%>
</tr>
<%
}
j=j+5;
%>
<%
}
%>
</table>
</td>
<td VALIGN="top" ALIGN="RIGHT" WIDTH="20%" NOWRAP="NOWRAP"><table border="0" cellpadding="3px"  class="navtab"><tr><td style="font-size:12px;"><%=ics.GetVar("totalImages")%>&nbsp;<xlat:stream key="dvin/UI/Images"/></td></tr><tr><td style="font-size:xx-small;" nowrap><% String displayPage = ics.GetVar("displayPage");
String totalPages = ics.GetVar("totalPages");
if (Integer.parseInt(displayPage) > 1){%><a onclick="document.searchForm.displayPage.value='<%= Integer.toString(Integer.parseInt(displayPage) - 1)%>'; submitForm();" href="#"><img border="0" src="<ics:getvar name="imagepath"/>/common/imagepicker/leftArrow.gif"/><xlat:stream key="dvin/UI/Previous"/></a>&nbsp;|&nbsp;<%}%><xlat:stream key="dvin/UI/PageOf"/>
<%if (Integer.parseInt(displayPage) < Integer.parseInt(totalPages)){%>
|<a onclick="document.searchForm.displayPage.value='<%= Integer.toString(Integer.parseInt(displayPage) + 1) %>'; submitForm();" href="#"><xlat:stream key="dvin/UI/Next"/><img border="0" src="<ics:getvar name="imagepath"/>/common/imagepicker/rightArrow2.gif"/></a><%}%></td></tr><tr><td style="font-size:xx-small;"><xlat:stream key="dvin/AT/Common/SortBy"/></td></tr><tr><td style="font-size:xx-small;"><%if(!ics.GetVar("sortBy").equals(SearchIndexFields.Global.NAME)){%><a href="#" onClick='document.searchForm.sortBy.value="<%=SearchIndexFields.Global.NAME%>";submitForm();'><xlat:stream key="dvin/AT/Common/Name"/></a><%}else{%><xlat:stream key="dvin/AT/Common/Name"/><%}%></td></tr><tr><td style="font-size:xx-small;"><%if(!ics.GetVar("sortBy").equals(SearchIndexFields.Global.UPDATED_DATE)){%><a href="#" onClick='document.searchForm.sortBy.value="<%=SearchIndexFields.Global.UPDATED_DATE%>";submitForm();'><xlat:stream key="dvin/UI/Search/ModifiedDate"/></a><%}else{%><xlat:stream key="dvin/UI/Search/ModifiedDate"/><%}%></td></tr></table></td><td WIDTH="10%" NOWRAP="NOWRAP"/></tr></table>
</ics:then>
<ics:else>
    <p class="warning"><xlat:stream key="dvin/UI/SorryNoImages"/></p>
</ics:else>
</ics:if>
</BODY>
</HTML>
</cs:ftcs>
