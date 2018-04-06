<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   com.openmarket.assetframework.interfaces.AssetTypeManagerFactory,
		 		   com.openmarket.assetframework.interfaces.IAssetTypeManager,
		 		   com.openmarket.gator.interfaces.IAttributeTypeManager,
		 		   com.openmarket.gator.interfaces.IPresentationObject"
%><cs:ftcs><%-- OpenMarket/Gator/FlexibleAssets/Common/GetTagNameByAttributeEditorId

INPUT
	AttrEditorId : we need to pass the Attribute Editor Id to this element

OUTPUT
	AttrEditorName: given attribute editor id it will set tag name of the attribute editor to AttrEditorName variable.
--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<%
String XMLParseError = null;
IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
ics.SetObj("atmgr", atm.locateAssetManager("AttrTypes"));
IAttributeTypeManager iam = (IAttributeTypeManager) ics.GetObj("atmgr");
try
{		
	ics.SetObj("PresObj", iam.getPresentationObject(ics.GetVar("AttrEditorId")));
}
catch (Exception e)
{
	XMLParseError = ics.GetVar("errno");
}

if (XMLParseError == null)
{
	IPresentationObject ipo = (IPresentationObject) ics.GetObj("PresObj");
	ics.SetVar("AttrEditorName", ipo.getTypeName());
}
%>

</cs:ftcs>