<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Tabs/Preview
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

<asset:load name="currentAsset" type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("id")%>' />
<asset:get name="currentAsset" field="name" output="name"/>
<asset:get name="currentAsset" field="description" output="description"/>
<assettype:load name="currentType" type='<%=ics.GetVar("AssetType") %>'/>
<assettype:get name="currentType" field="description" output="typeDesc"/>
<div class="panelSection">
    <h3><span id="assetTypeDescription"><ics:getvar name="typeDesc" /></span></h3>    
    <table>
        <tr><th><xlat:stream key="dvin/Common/Name" />:</th></tr><tr><td style="padding-left:19px;"><span id="previewedAssetName"><string:stream variable="name" /></span></td></tr>
        <tr><th><xlat:stream key="dvin/Common/Description" />:</th></tr><tr><td style="padding-left:19px;"><span id="previewedAssetDescription"><string:stream variable="description"/></span></td></tr>
    </table>
</div>

<div class="panelSection">
    <h3><xlat:stream key="dvin/Common/Template" /></h3>
    <table>
        <tr><th><xlat:stream key="dvin/Common/Name" />:</th></tr><tr><td style="padding-left:19px;"><span id="templateName"></span></td></tr>
        <tr><th><xlat:stream key="dvin/Common/Description" />:</th></tr><tr><td style="padding-left:19px;"><span id="templateDescription"></span></td></tr>
    </table>    
</div>    

</cs:ftcs>