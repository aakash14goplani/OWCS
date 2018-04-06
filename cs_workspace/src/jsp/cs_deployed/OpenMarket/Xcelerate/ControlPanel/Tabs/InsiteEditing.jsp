<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteEditing
// - displays Editing tab
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="com.openmarket.xcelerate.controlpanel.InSiteEditingUtil"
%><%@page import="com.openmarket.xcelerate.controlpanel.InSiteEditingUtil.SupportedBrowser"%>
<cs:ftcs><% 
if ( !InSiteEditingUtil.isBrowserSupported( ics ) ) {
	StringBuffer list = new StringBuffer();
	for ( InSiteEditingUtil.SupportedBrowser browser : InSiteEditingUtil.SupportedBrowser.values() ) 
	{
		list.append( browser.getDescription() ).append( "<br/>" );
	}    
	ics.SetVar( "supportedBrowsers", list.toString() );
	%>    	    	
    <xlat:stream key="dvin/UI/TheInsiteEditingtabonlyworksIE" encode="false" escape="true" evalall="true" />	
<%} else {            
%><table width="100%" height="24" border="0" cellpadding="0" cellspacing="0">
<tr>
<td align="right" class="topButtons" style="padding:3px 13px 3px 0px;">
<xlat:lookup key="dvin/Common/SaveChanges" varname="XLAT_SaveChanges"/>
<xlat:lookup key="dvin/Common/CancelChanges" varname="XLAT_CancelChanges"/>
 <img id="ctrlSaveId" src="<ics:getvar name="panelImagePath" />/insite_Save.gif" title="<ics:getvar name="XLAT_SaveChanges"/>" alt="<ics:getvar name="XLAT_SaveChanges"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath" />/insite_saveBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath" />/insite_Save.gif')"/><img id="ctrlCancelId" src="<ics:getvar name="panelImagePath"/>/insite_cancel.gif" title="<ics:getvar name="XLAT_CancelChanges"/>" alt="<ics:getvar name="XLAT_CancelChanges"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath" />/insite_CancelBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath" />/insite_cancel.gif')" />
</td>
</tr>
</table>

<div class="panelSection">
    <h3><xlat:stream key="dvin/UI/AssetMgt/CurrentSelection"/></h3>    
    <table>
        <tr><th style="padding-left:39px;"><xlat:stream key="dvin/UI/AssetMgt/AssetName"/>:</th><td><span id="assetName"></span></tr>
        <tr><th style="padding-left:39px;"><xlat:stream key="dvin/UI/AssetMgt/FieldName"/>:</th><td><span id="assetField"></span></td></tr>
    </table>
</div>

<div class="panelSection">
    <h3><xlat:stream key="dvin/UI/AssetMgt/EditedAssets"/></h3>    
    <span id="editStatus" style="padding-left: 39px;"><xlat:stream key="dvin/UI/AssetMgt/Therearenoasset"/></span>
    <table id="editedAssets" cellspacing="0">
    </table>
</div>

<ics:getproperty name="xcelerate.charset" file="futuretense_xcel.ini" output="charset"/>

<satellite:form assembler="query" method="POST" id="form1" name="form1" target="insiteFrame" enctype="multipart/form-data">
</satellite:form>
<div id="insiteFrameLocation" style="display: none;"></div>
<%} // end else %>
</cs:ftcs>
