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
HashMap<String, GroupMatcher> groupMatcherMap = new HashMap<String, GroupMatcher>();
ics.SetObj ("wcc.groupMatcherMap", groupMatcherMap);
ArrayList<String> ruleOrderList = new ArrayList<String>();
ics.SetObj ("wcc.ruleOrderList", ruleOrderList);

LinkedList<String> lineList = new LinkedList<String>();
HashMap<String, LinkedList<String>> lineListPerRule = new HashMap<String, LinkedList<String>>();

ics.CallElement("WCC/Util/LoadMatcherIni", null);
IniFile matcherIniFile = (IniFile) ics.GetObj("wcc.matcher.ini");

for (String line : matcherIniFile.getLines()) {
    line = line.trim();
    if (!line.isEmpty() && !line.startsWith("#")) {
        lineList.addLast(line);
    }
}

for (GroupMatcher groupMatcher : GroupMatcher.parseAll(lineList)) {
    String ruleName = groupMatcher.getRuleName();
    ruleOrderList.add(ruleName);
    lineListPerRule.put(ruleName, new LinkedList<String>());
    groupMatcherMap.put(ruleName, groupMatcher);
}

ics.CallElement("WCC/Util/LoadMapperIni", null);
IniFile mapperIniFile = (IniFile) ics.GetObj("wcc.mapper.ini");

for (String line : mapperIniFile.getLines()) {
    line = line.trim();
    if (!line.isEmpty() && !line.startsWith("#")) {
        String ruleName = line.substring(0, line.indexOf('.'));
        lineList = lineListPerRule.get(ruleName);
        if (lineList != null) {
            lineList.addLast(line.substring(ruleName.length() + 1));
        }
    }
}

for (String ruleName : lineListPerRule.keySet()) {
    lineList = lineListPerRule.get(ruleName);
    if (!lineList.isEmpty()) {
        GroupMapper groupMapper = GroupMapper.parse(ruleName, lineList);
        if (groupMapper != null) {
            groupMatcherMap.get(ruleName).setGroupMapper(groupMapper);
        }
    }
}
%>
</cs:ftcs>
