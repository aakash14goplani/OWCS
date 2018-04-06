<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,java.io.File,COM.FutureTense.Util.ftUtil"
%><cs:ftcs><%-- AssetTypePostDeleteCleanup

INPUT : - assettype - Name of the assettype that has been successfully deleted

OUTPUT : - errno - Error-code resulting of the delete operation.
//This element is called from AssetType.xml after deleting an asset type.This element deletes the orphan element xmls that are of no use after asset type got deleted.

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<ics:getproperty name="xcelerate.base" file="futuretense_xcel.ini" output="basepath"/>
<%
if((ics.GetVar("assettype") != null && !ics.GetVar("assettype").isEmpty()) && (ics.GetVar("basepath") != null && !ics.GetVar("basepath").isEmpty()))
{
String rootPath = ics.GetVar("basepath")+File.separator+"AssetType"+File.separator+ics.GetVar("assettype");
int errNo = ftUtil.emptyfolder(rootPath,true);
String errnostr = new Integer(errNo).toString();
//If some file/folder inside the rootfolder could not be deleted due to file access permissions, set a negative error number
%>
<ics:setvar name="errno" value="<%=errnostr%>" />
<%		
}
%>

</cs:ftcs>