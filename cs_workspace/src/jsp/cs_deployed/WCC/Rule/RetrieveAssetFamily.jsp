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
                   com.fatwire.assetapi.data.*,
                   com.fatwire.system.SessionFactory,
                   com.fatwire.assetapi.query.*,
                   oracle.wcs.assetdef.*,
                   java.util.*"
%>
<%@ page import="com.fatwire.cs.core.db.PreparedStmt" %>
<cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%
AssetDataManager assetDataManager = (AssetDataManager) SessionFactory.getSession().getManager(AssetDataManager.class.getName());

// All asset families
String sqlQuery = 
	       "select"
         + "    main.AssetAttr     as typea,"
         + "    main.AssetType     as typec,"
         + "    main.AssetTemplate as typecd,"
         + "    main.AssetFilter   as typef,"
         + "    gdef.AssetType     as typep,"
         + "    gdef.AssetTemplate as typepd"
         + "  from"
         + "    FlexAssetTypes main,"
         + "    FlexGroupTypes gdef"
         + "  where"
         + "    main.AssetGroup = gdef.AssetType" ;

PreparedStmt stmt = new PreparedStmt (sqlQuery, Arrays.asList("FlexAssetTypes", "FlexGroupTypes"));
IList sqlResult = ics.SQL (stmt, null, false);

int totalRow = sqlResult.numRows();

List<AssetType> assetTypeList = new ArrayList<AssetType>();

for (int row = 1; row <= totalRow; row++) {
    sqlResult.moveTo(row);
    
    String typeA  = sqlResult.getValue("typea");
    String typeC  = sqlResult.getValue("typec");
    String typeCD = sqlResult.getValue("typecd");
    String typeP  = sqlResult.getValue("typep");
    String typePD = sqlResult.getValue("typepd");

    AssetType assetType = new AssetType(typeC, typeCD, typeA, typeP, typePD);
    
    // all typeCD instances
    SimpleQuery queryCD = new SimpleQuery(typeCD, null, null, Arrays.asList("name"));
    queryCD.getProperties().setIsBasicSearch(true);

    for (AssetData item : assetDataManager.read(queryCD)) {
        String subtype = item.getAttributeData("name").getData().toString();
        
        assetType.getSubtypeMap().put(subtype, new AssetSubtype(subtype));
    }

    ics.SetObj ("wcc.populateAssetType", assetType);
    ics.CallElement("WCC/Rule/RetrieveFieldDefPerCDinstance", null);
    
    assetTypeList.add(assetType);
}

ics.SetObj ("wcc.assetTypeList", assetTypeList);
%>
</cs:ftcs>
