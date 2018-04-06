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
                   oracle.stellent.ucm.poller.*,
                   oracle.wcs.mapping.*,
                   oracle.wcs.matching.*,
                   java.io.*,
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
List<String> ruleOrderList = (List<String>) ics.GetObj ("wcc.ruleOrderList");

ics.CallElement("WCC/Util/LoadMatcherIni", null);
IniFile matcherIniFile = (IniFile) ics.GetObj("wcc.matcher.ini");

matcherIniFile.getLines().clear();

for (String ruleName : ruleOrderList) {
	GroupMatcher groupMatcher = groupMatcherMap.get(ruleName);
    for (String line : groupMatcher.format()) {
    	matcherIniFile.getLines().add(line);
    }
    matcherIniFile.getLines().add("");
}

matcherIniFile.save();


ics.CallElement("WCC/Util/LoadMapperIni", null);
IniFile mapperIniFile = (IniFile) ics.GetObj("wcc.mapper.ini");

mapperIniFile.getLines().clear();

for (GroupMatcher groupMatcher : groupMatcherMap.values()) {
    String ruleName = groupMatcher.getRuleName();
    GroupMapper groupMapper = groupMatcher.getGroupMapper();
    for (String line : groupMapper.format()) {
    	mapperIniFile.getLines().add(ruleName + "." + line);
    }
    mapperIniFile.getLines().add("");
}

mapperIniFile.save();
%>
</cs:ftcs>
