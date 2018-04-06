<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%-- OpenMarket/Xcelerate/Actions/AssetMgt/ShowAssociations

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/AssetMgt/ShowAssetChildren" outstring="DisplayAssociationsURL">
    <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
	<satellite:argument name="id" value='<%=ics.GetVar("id")%>'/>
	<satellite:argument name="assetname" value='<%=ics.GetVar("assetname")%>'/>
	<satellite:argument name="childassettype" value='<%=ics.GetVar("childassettype")%>'/>
    <satellite:argument name="revisionInspect" value='<%=ics.GetVar("revisionInspect")%>'/>
    <satellite:argument name="revision" value='<%=ics.GetVar("revision")%>'/>
</satellite:link>


<script type="text/javascript">
function updateAssociations(response){
    if (response) {
        dojo.place(response, 'trNodeToReplaceAssoc', 'before');
    }
    var trnode = dojo.byId('trNodeToReplaceAssoc');
    trnode.parentNode.removeChild(trnode);
}

dojo.xhrGet({
    url: '<%=ics.GetVar("DisplayAssociationsURL")%>',
    handle: updateAssociations
});	

</script>

<tr id="trNodeToReplaceAssoc" style='display:none;'>
    <td valign="middle" align="center" colspan="3" style="border: 1px solid #CCC;padding:4px;">
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif'/>
    <br/>
    <br/>
    <b>
    <span><xlat:stream key="dvin/UI/Loading"/></span>
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif'/>
    </b>
    </td>
</tr>

</cs:ftcs>