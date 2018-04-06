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
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.wcs.assetdef.*,
                   oracle.wcs.mapping.*,
                   oracle.wcs.matching.*,
                   java.util.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%
Map<String, GroupMatcher> groupMatcherMap = (Map<String, GroupMatcher>) ics.GetObj ("wcc.groupMatcherMap");

for (GroupMatcher groupMatcher : groupMatcherMap.values()) {
    
    GroupMapper groupMapper = groupMatcher.getGroupMapper();
    
    if (groupMapper == null || groupMapper.getTypeCD() == null || groupMapper.getTypeCDinstance() == null) {
        continue;
    }
    
    AssetSubtype assetSubtype = new AssetSubtype(groupMapper.getTypeCDinstance());

    AssetType assetType = new AssetType(groupMapper.getTypeC(), groupMapper.getTypeCD(), groupMapper.getTypeA(), groupMapper.getTypeP(), groupMapper.getTypePD());
    assetType.getSubtypeMap().put(assetSubtype.getSubtype(), assetSubtype);
    
    groupMapper.setAssetSubtype(assetSubtype);

    ics.SetObj ("wcc.populateAssetType", assetType);
    ics.CallElement("WCC/Rule/RetrieveFieldDefPerCDinstance", null);
}
%>
</cs:ftcs>
