<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/CSClient/MakeMaster
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
<%@ page import="com.fatwire.mda.*,com.openmarket.xcelerate.common.*,com.openmarket.xcelerate.asset.AssetIdImpl,com.fatwire.mda.DimensionableAssetInstance.DimensionParentRelationship,java.util.*,com.fatwire.assetapi.data.AssetId"%>
<cs:ftcs>
<!-- user code here -->
<%
try {
String assetType=ics.GetVar("Node2");
String assetId=ics.GetVar("SourceID");
final String LOCALE="Locale";
// get the dimension support factory
DimensionSupportManagerFactory dsmf = DimensionSupportManagerFactory.getInstance(ics);
// get the asset dimensionable manager 
DimensionableAssetManager dam = dsmf.getDimensionableAssetManager();
// create an the 
AssetId aid = new AssetIdImpl(assetType, new Long(assetId));
DimensionParentRelationship oldParent = dam.getParent(aid, LOCALE);
DimensionParentRelationship newParent = new DimParentRelationshipImpl(LOCALE, aid); // self
dam.resetParent(aid, oldParent, newParent);
%>
<AFFECTEDNODES><NODE PARENTID="<%=ics.GetVar("parentid")%>"></NODE></AFFECTEDNODES>
<% } catch (Exception ex) { %>
 <xlat:lookup key="dvin/CSDocLink/V1/ErrorMakingMaster" varname="_XLAT_"/>
<ERROR CODE="4" DESCRIPTION="<%=ics.GetVar("_XLAT_")%>" SEVERITY="2" />
<% } %>
</cs:ftcs>