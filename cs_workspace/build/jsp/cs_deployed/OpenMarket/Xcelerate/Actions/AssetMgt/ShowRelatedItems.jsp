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
%><cs:ftcs><%-- OpenMarket/Xcelerate/Actions/AssetMgt/ShowRelatedItems

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<satellite:link assembler="query" pagename="OpenMarket/Gator/FlexibleAssets/Common/CDRecommendations" outstring="DisplayRelatedItemsURL">
    <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
	<satellite:argument name="id" value='<%=ics.GetVar("id")%>'/>
	<satellite:argument name="templatetype" value='<%=ics.GetVar("templatetype")%>'/>
	<satellite:argument name="templateid" value='<%=ics.GetVar("templateid")%>'/>
</satellite:link>


<script type="text/javascript">
function updateRelItems(response){
    if (response) {
        dojo.place(response, 'trNodeToReplaceRelItem', 'before');
    }
    var trnode = dojo.byId('trNodeToReplaceRelItem');
    trnode.parentNode.removeChild(trnode);
}

dojo.xhrGet({
    url: '<%=ics.GetVar("DisplayRelatedItemsURL")%>',
    handle: updateRelItems
});	
</script>

<div id="trNodeToReplaceRelItem">
    <div valign="middle" align="center" colspan="3" style="border: 1px solid #CCC;padding:4px;">
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif'/>
    <br/>
    <br/>
    <b>
    <span><xlat:stream key="dvin/UI/Loading"/></span>
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif'/>
    </b>
    </div>
</div>

</cs:ftcs>