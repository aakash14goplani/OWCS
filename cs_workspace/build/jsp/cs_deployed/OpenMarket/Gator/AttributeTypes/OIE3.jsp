<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%>

<%-- OpenMarket/Gator/AttributeTypes/OIE3--%>

<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.openmarket.xcelerate.controlpanel.InSite"
%><%@ page import="com.openmarket.basic.util.Base64"
%><%@ page import="com.fatwire.cs.mayura.ui.util.ImageUtil"
%><%@ page import="com.openmarket.gator.interfaces.IPresentationObject" %>
<%@ page import="com.openmarket.gator.interfaces.IPresentationElement"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>

<%!String getAttribute(ICS ics, String attributeName, String defaultValue)
{    
    IPresentationObject presObj = (IPresentationObject)ics.GetObj(ics.GetVar("PresInst"));
    String attributeValue = presObj.getPrimaryAttributeValue(attributeName);
    if (!Utilities.goodString(attributeValue))
        return defaultValue;
    else
        return attributeValue;
}
%>

<cs:ftcs>

<%
if ("no".equals(ics.GetVar("MultiValueEntry")))
{
%>
    <ics:getproperty name="ft.cgipath" file="futuretense.ini" output="cgipath"/>
    <ics:getproperty name="xcelerate.imageeditor.basepath" file="futuretense_xcel.ini" output="basepath"/>
    <%=ics.GetVar("AttrName")%>
<%
    String attributeName = ics.GetVar("AttrName");
    boolean isSingleValued = "single".equals(ics.GetVar("EditingStyle"));
    boolean isRequired = "true".equals(ics.GetVar("RequiredAttr"));
    IList attributeValueList = ics.GetList("AttrValueList", false);
    boolean hasValues = "true".equals( ics.GetVar("IsAttrValueListCurrent"));
    // attributeValueList != null && attributeValueList.hasData();
    String fileName = "";
    String urlValue = "";
    String folder = "";
    byte[] fileData = null;    
    String encodedFileData = null;
    String uriPrefix = ics.GetVar("cgipath");
    String currentInput = ics.GetVar("cs_CurrentInputName");
    String currentValue = null;
    String codebase = ics.GetVar("basepath");
    if (!Utilities.goodString(codebase))
        codebase = uriPrefix + "ImageEditor/OIE.cab#version=3,0,1,12";        
    
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
    String defaultTextSize = getAttribute(ics, "DEFAULTTEXTSIZE", "12");
    String defaultTextColor = getAttribute(ics, "DEFAULTTEXTCOLOR", "#000000");  
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
    String imageUrl = null;
    String pagename = ics.GetVar("pagename");
    boolean isPosted = "true".equals(ics.GetVar("__POSTED__"));
    String attributeId = null;
    IList tmplattrlist = ics.GetList("tmplattrlist");
    if (tmplattrlist != null){
	    int moveToRow = Integer.parseInt(ics.GetVar("tmplattrlistIndex"));
	    tmplattrlist.moveTo(moveToRow);
        attributeId = tmplattrlist.getValue("assetid");
    } 
%>
    <ics:setvar name="doDefaultDisplay" value="no" />
    <tr>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>    
	<td></td>
	<td valign="top">
<%
    if (hasValues)
    {
	urlValue = attributeValueList.getValue("urlvalue");
        if (urlValue != null)
	{
                int last = urlValue.lastIndexOf(java.io.File.separator);
                fileName = urlValue.substring(last+1);
                fileData = attributeValueList.getFileData("urlvalue");                
                folder   = attributeValueList.getValue("folder");
                if (isPosted && !pagename.endsWith("Post"))
		{
                    Vector temporaryIds = (Vector)ics.GetObj("v" + attributeId);                    
                    if (temporaryIds != null)
		    {
                        for (int i = 0; i < temporaryIds.size(); i++)
			{
                            String currentId = (String)temporaryIds.get(i);
%>
				<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
					<ics:argument name = "val_variable" value ="currentId"/>
					<ics:argument name = "dataType" value ="long"/>
				</ics:callelement>
				<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	            <ics:then>
					<ics:sql sql='<%="select urldata from TempObjects where id=" + currentId%>' listname="tmpUrlValueList" table="TempObjects" />
				</ics:then>
				</ics:if>
				
<%
                            IList tmpUrlValueList = ics.GetList("tmpUrlValueList");
                            String tmpUrlValue = null;
                            if (tmpUrlValueList != null)
                                tmpUrlValue = tmpUrlValueList.getValue("urldata");
                            if (tmpUrlValue != null && tmpUrlValue.equals(urlValue))
			    {
                                ics.SetVar("blobwhere", currentId);
                                ics.SetVar("blobtable", "TempObjects");
                                ics.SetVar("blobcol", "urldata");
                                ics.SetVar("blobkey", "id");
                                break; 
                            }
                        }                        
                    }
                }
		else
		{
%>
	<blobservice:getidcolumn varname="blobkey" />
	<blobservice:geturlcolumn varname="blobcol" />
	<blobservice:gettablename varname="blobtable" />
<%
			if ("OpenMarket/Xcelerate/Actions/CopyFront".equals(pagename) || "OpenMarket/Xcelerate/Actions/TranslateFront".equals(pagename))
			{
%>
	<assetset:setasset name="as" type='<%=ics.GetVar("AssetType")%>' id='<%=ics.GetVar("Copyid")%>'/>
<%
			}
			else
			{
%>
	<assetset:setasset name="as" type='<%=ics.GetVar("AssetType")%>' id='<%=ics.GetVar("id")%>'/>
<%
			}
%>
	<assetset:getattributevalues name="as" typename='<%=ics.GetVar("attributetype")%>' attribute='<%=ics.GetVar("AttrName")%>' listvarname="blobidlist" />
	<ics:listloop listname="blobidlist">
		<ics:listget listname="blobidlist" fieldname="value" output="blobid" />
		<blobservice:readdata id='<%=ics.GetVar("blobid")%>' listvarname="bloburldatalist" />
		<ics:listget listname="bloburldatalist" fieldname="urldata" output="bloburldata"/>
<%
			if (urlValue != null && urlValue.equals(ics.GetVar("bloburldata")))
			{
				ics.SetVar("blobwhere",ics.GetVar("blobid"));
			}
%>
	</ics:listloop>                    
<%
		}
%> 
	<satellite:blob assembler="query"
		blobtable='<%=ics.GetVar("blobtable")%>'
		blobkey='<%=ics.GetVar("blobkey")%>'
		blobwhere='<%=ics.GetVar("blobwhere")%>'
		blobcol='<%=ics.GetVar("blobcol")%>'
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		outstring="imageurl"/>                             
<%                
                imageUrl = ics.GetVar("imageurl");
	}                
    }        
    if (!isSingleValued)
    {
            String requireInfo = null;
            if (isRequired)
	    {
                requireInfo = ics.ResolveVariables("Variables.RequireInfo*Variables.cs_MultipleInputName*Variables.currentAttrName*ReqTrue*Variables.AttrType!", false);
            }
	    else
	    {
                requireInfo = ics.ResolveVariables("Variables.RequireInfo*Variables.cs_MultipleInputName*Variables.currentAttrName*ReqFalse*Variables.AttrType!", false);
            }                       
            ics.SetVar("RequireInfo", requireInfo);            

            int currentRowNb = (attributeValueList == null?0:attributeValueList.currentRow()); // [1..nb of values currently stored]
            int valueCounter = ics.GetCounter("TCounter"); // [1..nb of values currently on form]
            if (valueCounter > currentRowNb)
	    {
                fileName = "";
                imageUrl = null;
	    }            
    }
%> 
<div id="div_jscontainer_<%=currentInput%>" style="position:relative;top:0px;left:0px;">
	<object type="application/x-oleobject" name="oie_<%=currentInput%>" id="oie_<%=currentInput%>" 
		classid="clsid:EC59EE59-B27D-4581-9E93-6AB6CB88E970" 
		codebase="<%=codebase%>" 
		width="<%=width%>" 
		height="<%=height%>">
		<param name="langid" value="<%=locale%>">        
		<param name="DefaultTextFontFamily" value="<%=defaultTextFont%>">
		<param name="DefaultTextSize" value="<%=defaultTextSize%>">
		<param name="DefaultTextColor" value="<%=defaultTextColor%>">
		<param name="SnapshotPaneVisible" value="<%=snapshotPanelVisible%>">
		<param name="FitImage" value="<%=fitImage%>">
		<param name="LimitCropping" value="<%=limitCropping%>">
		<param name="CropWidth" value="<%=cropWidth%>">
		<param name="CropHeight" value="<%=cropHeight%>">
		<param name="EnableOIEFormat" value="<%=enableOIEFormat%>">
		<param name="LimitSize" value="<%=limitSize%>">
		<param name="MaxWidth" value="<%=maxWidth%>">
		<param name="MaxHeight" value="<%=maxHeight%>">
		<param name="MinWidth" value="<%=minWidth%>">
		<param name="MinHeight" value="<%=minHeight%>">
		<param name="AutoResample" value="<%=autoResample%>">
		<param name="AutoResampleProportional" value="<%=autoResampleProportional%>">
		<param name="TagEdit" value="<%=tagEdit%>">            
		<param name="Base64JpegQuality" value="<%=base64JpegQuality%>">
		<param name="AskToSaveLocally" value="<%=askToSaveLocally%>">
		<param name="DefaultSavingType" value="<%=defaultSavingType%>">
		<param name="EnableGIFSaving" value="<%=enableGifSaving%>">
		<param name="EnableJPEGSaving" value="<%=enableJpegSaving%>">
		<param name="EnablePNGSaving" value="<%=enablePngSaving%>">
		<param name="EnableTIFFSaving" value="<%=enableTiffSaving%>">
		<param name="EnableBMPSaving" value="<%=enableBmpSaving%>">                                                                                    
		<param name="GridVisible" value="<%=gridVisible%>">
		<param name="GridSnap" value="<%=gridSnap%>">                        
		<param name="GridSpacingX" value="<%=gridSpacingX%>">
		<param name="GridSpacingY" value="<%=gridSpacingY%>">
		<param name="MaxThumbnailHeight" value="<%=maxThumbnailHeight%>">
		<param name="MaxThumbnailWidth" value="<%=maxThumbnailWidth%>">
		<param name="ThumbnailFormat" value="<%=thumbnailFormat%>">                      
	</object>
</div>
	<input type="hidden" name="<%=currentInput%>_file" value="<%=fileName%>"/>
	<input type="hidden" name="<%=currentInput%>" value="<%=encodedFileData%>" />
	<input type="hidden" name="_DEL_<%=currentInput%>" value=""/>
<%
    if (imageUrl != null)
    {
%>
	<input type="hidden" name="_DATA_<%=currentInput%>" value="yes"/>
<%
    }
%>
	<script>
    var objEditor = document.getElementById("oie_<%=currentInput%>");                
<%
    if (imageUrl != null)
    {
%>
        if(typeof(objEditor.LoadFromURL) != 'undefined')
		objEditor.LoadFromURL("<%=imageUrl%>&oieloadpicture=<string:stream value="<%=fileName%>"/>");
<%
    }
    IPresentationObject presentationObject = (IPresentationObject)ics.GetObj(ics.GetVar("PresInst"));
    Map<String,String> buttonMap = ImageUtil.getButtonConfig(presentationObject);
    Set keySet = buttonMap.keySet();
    Iterator<String> keys = keySet.iterator();
    while (keys.hasNext())
    {
	String feature = keys.next();
%>
	if(typeof(objEditor.SetFeature) != 'undefined')
	objEditor.SetFeature("<%=feature%>", <%=buttonMap.get(feature)%>);
<%
    }
    if (ics.GetVar("cs_isOIELoaded") == null)
    {
    	ics.SetCounter("oieCounter",1);
    	
%>

		function oie_remove(fieldname)
		{
               var objEditor = document.getElementById("oie_" + fieldname);
			   if(typeof(objEditor.LoadFromBase64) != 'undefined')
               objEditor.LoadFromBase64("deleted", "deleted");
			   if(typeof(objEditor.GetAsBase64) != 'undefined')
               objEditor.GetAsBase64("");
               document.forms[0].elements[fieldname].value='';
               document.forms[0].elements[fieldname+'_file'].value='';
               document.forms[0].elements['_DEL_' + fieldname].value='on';
        }
	
        function openImagePicker(url)
		{
                var left = window.screenLeft;
                var top = window.screenTop;
                var windowProperties = 'scrollbars=yes,resizable=yes,width=620,height=600,top=' + top + ',left=' + left;                        
                var imagePickerWin = window.open(url,'templateSelect', windowProperties);
        }
	
        function loadImage(fieldname, imageUrl)
		{
                var objEditor = document.getElementById(fieldname);
				if(typeof(objEditor.LoadFromURL) != 'undefined')
                objEditor.LoadFromURL(imageUrl);
        }
	
        function insertImage(fieldname, imageUrl)
		{
                var objEditor = document.getElementById(fieldname);
				if(typeof(objEditor.InsertImageFromURL) != 'undefined')
                objEditor.InsertImageFromURL(imageUrl);
        }	
	</script>

		<input type="hidden" id="oieCount" value="<%=ics.GetCounter("oieCounter") %>" />
	
<%
	ics.SetVar("cs_isOIELoaded","true");
    }else{
    	ics.SetCounter("oieCounter",ics.GetCounter("oieCounter")+1);
%>
			c = document.getElementById("oieCount");
			c.value=<%=ics.GetCounter("oieCounter") %>;
	</script>
<%
    }
%>
	<br />

<%
    if ("multiple-ordered".equals(ics.GetVar("EditingStyle")))
    {
	if (ics.GetVar("isMoveMulFieldsLoaded") == null)
	{
%>
		<ics:callelement element="OpenMarket/Xcelerate/Scripts/MoveMulFields"/>
<%
		ics.SetVar("isMoveMulFieldsLoaded","true");
	}
%>
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding-left:2px">
                    <xlat:lookup key="dvin/UI/Moveup" varname="mouseover" escape="true"/>
                    <xlat:lookup key="dvin/UI/Moveup" varname="_XLAT_"/>
					<a href="javascript:void(0)" onmouseover="window.status='<ics:getvar name="mouseover"/>';return true;" onmouseout="window.status='';return true;" onclick="move_oiefield('<ics:getvar name="cs_MultipleInputName"/>', 1, 'oie_');">
					<img src="<ics:getvar name="cs_imagedir"/>/graphics/common/controlpanel/up.gif" border="0" vspace="0"  hspace="2" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"/></a>
				</td>																														   
				<td>
                    <xlat:lookup key="dvin/UI/Movedown" varname="mouseover" escape="true"/>
                    <xlat:lookup key="dvin/UI/Movedown" varname="_XLAT_"/>
					<a href="javascript:void(0)" onmouseover="window.status='<ics:getvar name="mouseover"/>';return true;" onmouseout="window.status='';return true;" onclick="move_oiefield('<ics:getvar name="cs_MultipleInputName"/>', -1, 'oie_');">
					<img src="<ics:getvar name="cs_imagedir"/>/graphics/common/controlpanel/dn.gif" border="0" vspace="0"  hspace="2" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"/></a>
				</td>																														   
			</tr>
		</table>
<%
    }
%>
		<xlat:lookup key="dvin/Common/Delete" varname='_Delete_'/>
		<img src="<ics:getvar name="cs_imagedir"/>/graphics/common/icon/iconDeleteContent.gif" onclick="oie_remove('<ics:getvar name="cs_CurrentInputName"/>');" alt="<%=ics.GetVar("_Delete_")%>" title="<%=ics.GetVar("_Delete_")%>" />

		<table border="0" cellpadding="0" cellspacing="0">
<%
    if (enableImagePicker)
    {
%>
			<satellite:link
			    assembler="query"
			    outstring="imagepickerurl"
			    pagename="OpenMarket/Gator/AttributeTypes/IMAGEPICKERShowImages">
			    <satellite:argument name="fieldname" value='<%="oie_" + currentInput %>' />
			    <satellite:argument name="ATTRIBUTETYPENAMEOUT" value="<%=imgPickerAttributeType %>" />
			    <satellite:argument name="ATTRIBUTENAMEOUT" value="<%=imgPickerAttributeName %>" />
			    <satellite:argument name="ASSETTYPENAMEOUT" value="<%=imgPickerAssetType%>" />
			    <satellite:argument name="CATEGORYATTRIBUTENAMEOUT" value="<%=imgPickerCategoryAttribute %>" />
			    <satellite:argument name="RESTRICTEDCATEGORYLISTOUT" value="<%=imgPickerRestrictedCategoryList %>" />
			    <satellite:argument name="cs_callback" value="loadImage"/>
			</satellite:link>
			<tr>
				<td style="padding-top:5px; padding-left:2px">
					<xlat:lookup key="dvin/Common/Selectbackgroundimage" varname='_SBI_'/>
					<a href="#" onclick="openImagePicker('<ics:getvar name="imagepickerurl"/>');return false;"><img src="<ics:getvar name="cs_imagedir"/>/graphics/<ics:getssvar name="locale"/>/button/content/images/BrowseImage_adv.gif" alt="<%=ics.GetVar("_SBI_")%>" title="<%=ics.GetVar("_SBI_")%>" border="0"/></a>
				</td>
			</tr>
<%
    }
    if (oieEnableImagePicker)
    {
%>
			<satellite:link
			    assembler="query"
			    outstring="insertimagepickerurl"
			    pagename="OpenMarket/Gator/AttributeTypes/IMAGEPICKERShowImages">
			    <satellite:argument name="fieldname" value='<%="oie_" + currentInput %>' />
			    <satellite:argument name="ATTRIBUTETYPENAMEOUT" value="<%=oieImgPickerAttributeType %>" />
			    <satellite:argument name="ATTRIBUTENAMEOUT" value="<%=oieImgPickerAttributeName %>" />
			    <satellite:argument name="ASSETTYPENAMEOUT" value="<%=oieImgPickerAssetType%>" />
			    <satellite:argument name="CATEGORYATTRIBUTENAMEOUT" value="<%=oieImgPickerCategoryAttribute %>" />
			    <satellite:argument name="RESTRICTEDCATEGORYLISTOUT" value="<%=oieImgPickerRestrictedCategoryList %>" />
			    <satellite:argument name="cs_callback" value="insertImage"/>
			</satellite:link>
			<tr>
				<td style="padding-left:2px">
					<xlat:lookup key="dvin/Common/Insertimageasalayer" varname='_IIL_'/>
					<a href="#" onclick="openImagePicker('<ics:getvar name="insertimagepickerurl"/>');return false;"><img src="<ics:getvar name="cs_imagedir"/>/graphics/<ics:getssvar name="locale"/>/button/content/images/InsertImage_adv.gif" alt="<%=ics.GetVar("_IIL_")%>" title="<%=ics.GetVar("_IIL_")%>" border="0"/></a>
				</td>
			</tr>
<%
    }
%>
		</table>
	</td>
    </tr>
<%
}
%>
</cs:ftcs>
