<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%><%//
// OpenMarket/Gator/AttributeTypes/RENDERFLASH
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
<cs:ftcs>
<!-- user code here -->


<SCRIPT LANGUAGE="JavaScript">
function SetFlashFlag () {
	var obj = document.forms[0].elements[0];
    obj.form.elements['upcommand'].value="previewflash";
    obj.form.submit();
    return false;
}
</SCRIPT>
<ics:if condition='<%=ics.GetVar("MultiValueEntry").equals("no")%>'>
<ics:then>
<ics:setvar name="doDefaultDisplay" value="no"/>
<blobservice:getidcolumn varname="idcol"/>
<blobservice:gettablename varname="tablename"/>
<blobservice:geturlcolumn varname="urlcol"/>
<%--Get args from the attribute editor --%>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FFATTRTYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FFATTRNAME"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FFTYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="IFATTRTYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="IFATTRNAME"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="IFTYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FAATTRTYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FATYPE"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FAFLASHATTRNAME"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FAIMAGEATTRNAME"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="FATEXTATTRNAME"/>
</ics:callelement>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
<td></td>
<td>
<%--Get the attributes from the flash asset --%>
<assetset:setasset name="flashasset" type='<%=ics.GetVar("FATYPEOUT")%>' id='<%=ics.GetVar("id")%>' />

<assetset:getattributevalues name="flashasset" typename='<%=ics.GetVar("FAATTRTYPEOUT")%>' attribute='<%=ics.GetVar("FAFLASHATTRNAMEOUT")%>' listvarname="flashlist"/>
<assetset:getattributevalues name="flashasset" typename='<%=ics.GetVar("FAATTRTYPEOUT")%>' attribute='<%=ics.GetVar("FAIMAGEATTRNAMEOUT")%>' listvarname="imagelist"/>
<assetset:getattributevalues name="flashasset" typename='<%=ics.GetVar("FAATTRTYPEOUT")%>' attribute='<%=ics.GetVar("FATEXTATTRNAMEOUT")%>' listvarname="txtlist"/>

<ics:listloop listname="flashlist"><ics:listget listname="flashlist" fieldname="value" output="flashid"/></ics:listloop>
<%String sImgVal =""; %>
<ics:listloop listname="imagelist">
	<ics:listget listname="imagelist" fieldname="value" output="imgid"/>
	<assetset:setasset name="imagefile" type='<%=ics.GetVar("IFTYPEOUT")%>' id='<%=ics.GetVar("imgid")%>' />
	<assetset:getattributevalues name="imagefile" typename='<%=ics.GetVar("IFATTRTYPEOUT")%>' attribute='<%=ics.GetVar("IFATTRNAMEOUT")%>' listvarname="imagefilelist"/>
	<ics:listloop listname="imagefilelist">
		<ics:listget listname="imagefilelist" fieldname="value" output="imgfileid"/>
		<%
		   String sImgURL="";
		   
		   sImgURL=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/BlobServer?";
		   System.out.println(sImgURL);
		   sImgURL=addParam(sImgURL,"blobtable",ics.GetVar("tablename"));
		   sImgURL=addParam(sImgURL,"blobkey",ics.GetVar("idcol"));
		   sImgURL=addParam(sImgURL,"blobwhere",ics.GetVar("imgfileid"));
		   sImgURL=addParam(sImgURL,"blobcol",ics.GetVar("urlcol"));
		   sImgVal = sImgVal+sImgURL+"|";
		%>
	</ics:listloop>
</ics:listloop>
<%
String sTempTxt="";
String sTxtVal =""; 
%>
<%--assemble text param to submit to flash --%>
<ics:listloop listname="txtlist">
	<ics:listget listname="txtlist" fieldname="value" output="txtval"/>
	<%
		 sTempTxt=ics.GetVar("txtval");
		 sTempTxt=sTempTxt.replaceAll("&","%26");
		 sTxtVal = sTxtVal+sTempTxt+"|";
	%>
</ics:listloop>

<assetset:setasset name="flashfile" type='<%=ics.GetVar("FFTYPEOUT")%>' id='<%=ics.GetVar("flashid")%>' />
<assetset:getattributevalues name="flashfile" typename='<%=ics.GetVar("FFATTRTYPEOUT")%>' attribute='<%=ics.GetVar("FFATTRNAMEOUT")%>' listvarname="flashfilelist"/>
<ics:listloop listname="flashfilelist"><ics:listget listname="flashfilelist" fieldname="value" output="flashfileid"/></ics:listloop>
<% String sFlashURL=request.getServerName()+":"+request.getServerPort();%>
<render:getbloburl
      outstr="flashurl"
      blobtable='<%=ics.GetVar("tablename")%>'
      blobkey='<%=ics.GetVar("idcol")%>'
      blobwhere='<%=ics.GetVar("flashfileid")%>'
      blobcol='<%=ics.GetVar("urlcol")%>'
      satellite="false"
	  scheme='<%=request.getScheme() %>'
	  authority="<%=sFlashURL%>"
      >
</render:getbloburl>
<% String sElemName="Attribute_"+ics.GetVar("AttrName");%>
<input type="hidden" name='<%=sElemName%>' value="test"/>
<% String sObjectName="flash_"+ics.GetVar("id")+"_"+ics.GetVar("AttrName");%>
<%--Object/Embed tags to render the flash --%>
<OBJECT classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' 
		codebase='<%=request.getScheme() %>://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0' 
		WIDTH='525' 
		HEIGHT='154' 
		id='<%=sObjectName%>' 
		align='middle'>
   

<PARAM NAME='FlashVars' VALUE='imagefiles=<%=sImgVal%>&imagelabels=<%=sTxtVal%>'>
<PARAM NAME='allowScriptAccess' VALUE='sameDomain'>
<PARAM NAME='movie' VALUE='<%=ics.GetVar("flashurl")%>'>
<PARAM NAME='quality' VALUE='high'>
<PARAM NAME='bgcolor' VALUE='#FFFFFF'>
<PARAM NAME='scale' VALUE='noborder'>

<EMBED 	src='<%=ics.GetVar("flashurl")%>' 
		quality='high' 
		bgcolor='#FFFFFF' 
		FlashVars='imagefiles=<%=sImgVal%>&imagelabels=<%=sTxtVal%>'
		WIDTH='525' 
		HEIGHT='154' 
		NAME='<%=sObjectName%>' 
		scale='noborder' 
		align='middle' 
		allowScriptAccess='sameDomain'  
		TYPE='application/x-shockwave-flash' 
		PLUGINSPAGE='<%=request.getScheme() %>://www.macromedia.com/go/getflashplayer'>

</EMBED>

</OBJECT>

<%
	String sImageDIR = ics.GetVar("cs_imagedir");
	String sLocale = ics.GetSSVar("locale");
%>
<%--Save and preview link/button --%>
<a href="javascript:void(0)"
	onclick="return SetFlashFlag(); return checkfields('<%=ics.GetVar("ThisPage")%>');"
	onmouseover="window.status='Preview Flash';return true;"
	onmouseout="window.status='';return true;"
	><img src="<%=sImageDIR%>/graphics/<%=sLocale%>/button/content/images/SaveandPreview.gif"
		alt="Preview Flash" align="absmiddle"
		border="0" vspace="10"/></a>



<%! private String addParam(String sURL, String key, String value) throws Exception
{
String sReturn = sURL;
sReturn = sReturn + key + "=" + value + "%26";
return sReturn;
}
%>
</ics:then>
</ics:if>


</cs:ftcs>