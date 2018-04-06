<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/IReferenceAndSharing
//      Derived from IContentSiteEntries.jsp to display loading box for References and Sharing section of page.
//
// INPUT
//    AssetType - asset type of current asset
//    id - id of current asset
//    revisionInspect - (optional) if true, this is Inspect of a previous revision and we do not display asset relations
//    AssetTypeObj:description - description of current asset type to be displayed as part of a locale string
//    ContentDetails:name - name of current asset to be displayed as part of locale string
//
// OUTPUT
//%>
<cs:ftcs>

<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/AssetMgt/ReferencesAndSharing" outstring="ReferencesAndSharingURL">
    <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
	<satellite:argument name="id" value='<%=ics.GetVar("id")%>'/>
	<satellite:argument name="revisionInspect" value='<%=ics.GetVar("revisionInspect")%>'/>
    <satellite:argument name="AssetTypeObj:description" value='<%=ics.GetVar("AssetTypeObj:description")%>'/>
    <satellite:argument name="ContentDetails:name" value='<%=ics.GetVar("ContentDetails:name")%>'/>
</satellite:link>

<script type="text/javascript">
function updateReferenceSharing(response){
    if (response) {
        dojo.place(response, 'trNodeToReplace', 'before');
    }
    var trnode = dojo.byId('trNodeToReplace'), refLinkNode = dojo.byId('referencedByLinkNode');
    trnode.parentNode.removeChild(trnode);
    refLinkNode.parentNode.removeChild(refLinkNode);
}

function getReferencedAssets() {
	var waitNode = dojo.byId('trNodeToReplace');
	waitNode.style.display = '';
    dojo.xhrGet({
        url: '<%=ics.GetVar("ReferencesAndSharingURL")%>',
        handle: updateReferenceSharing
    });	
}
</script>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
<tr id="referencedByLinkNode">
	<td class="form-label-text"><xlat:stream key="dvin/UI/AssetMgt/ReferencedBy"/>:</td>
	<td></td>
	<td class="form-inset"><a href="#" onclick="getReferencedAssets();"><img style="position:relative;top:3px;border:none;" src='<%=ics.GetVar("cs_imagedir")%>/../wemresources/images/ui/tree/treeExpand.png' width="18px" height="18px"/><span style="padding: 5px;"><xlat:stream key="dvin/UI/Show"/></span></a></td>
</tr>

<tr id="trNodeToReplace" style='display:none;'>
	<td class="form-label-text"></td>
	<td></td>
    <td class="form-inset" valign="middle" align="center" colspan="3" style="border: 1px solid #CCC;padding:4px;">
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