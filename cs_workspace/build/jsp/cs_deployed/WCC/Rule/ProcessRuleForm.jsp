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
                   oracle.wcs.util.WcsLocale,
                   oracle.wcs.mapping.*,
                   oracle.wcs.matching.*,
                   java.text.*,
                   java.util.*,
                   COM.FutureTense.Util.ftErrors"
%><%!
private boolean xssCharFound (String value) {
    if (value != null) {
        for (int i = 0; i < value.length (); i++) {
            char ch = value.charAt (i);
            if (ch == '\'' || ch == '"' || ch == '<' || ch == '>') {
                return true;
            }
        }
    }
    return false;
}
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%
WcsLocale wcsLocale = new WcsLocale(ics);

SimpleDateFormat serverTzDateFormat = new SimpleDateFormat (Constants.TimeZoneDatePattern);
serverTzDateFormat.setTimeZone(TimeZone.getDefault());

SimpleDateFormat userTzDateFormat = new SimpleDateFormat (Constants.NoTimeZoneDatePattern);
userTzDateFormat.setTimeZone(wcsLocale.getSessionTimeZone());

String userTzToken = "@UserProfileTimeZone@";

try {
    boolean isNewRule = Boolean.valueOf(ics.GetVar("rule.isNewRule"));
    boolean isRuleEnabled = Boolean.valueOf(ics.GetVar("rule.isRuleEnabled"));

    String ruleName = ics.GetVar("rule.ruleName").trim();
    if (ruleName.length() == 0) {
        throw new IllegalArgumentException("forged name");
    }
    for (int i = 0; i < ruleName.length(); i++) {
        char code = ruleName.charAt(i);
        if ( (code >= 192)                    // ISO 8859-1 Latin and unicodes
             || (code == 45)                  // hyphen (-)
             || (code >= 48 && code <= 57)    // 0-9
             || (code >= 65 && code <= 90)    // A-Z
             || (code >= 97 && code <= 122)   // a-z
        ) {
            // continue;
        } else {
            throw new IllegalArgumentException("xss char found in name");
        }
    }

    String ruleDesc = ics.GetVar("rule.ruleDesc").trim();
    if (ruleDesc.length() == 0) {
        throw new IllegalArgumentException("forged description");
    }
    if (xssCharFound(ruleDesc)) {
        throw new IllegalArgumentException("xss char found in description");
    }

    // GroupMatcher
    LinkedList<String> lineList = new LinkedList<String>();

    lineList.add(ruleName + ":" + (isRuleEnabled ? "enabled" : "disabled") + ":" + ruleDesc);

    String ruleIniText = ics.GetVar("rule.matchingRuleText").trim();
    for (String iniLine : ruleIniText.split("\n")) {
        iniLine = iniLine.trim();
        if (xssCharFound(iniLine)) {
            throw new IllegalArgumentException("xss char found in rule value");
        }
        int pos = iniLine.indexOf(userTzToken);
        if (pos > -1) {
            String userTzDateStr = iniLine.substring(pos + userTzToken.length(), iniLine.length() - 1);
            Date userTzDate = userTzDateFormat.parse(userTzDateStr);
            String serverTzDateStr = serverTzDateFormat.format(userTzDate);
            iniLine = iniLine.substring(0, pos) + serverTzDateStr + ")";
        }
        lineList.add(iniLine);
    }

    GroupMatcher groupMatcher = GroupMatcher.parse(lineList);

    // GroupMapper
    lineList = new LinkedList<String>();

    lineList.add("assettype.A=" + ics.GetVar("rule.assetTypeA").trim());
    lineList.add("assettype.P=" + ics.GetVar("rule.assetTypeP").trim());
    lineList.add("assettype.PD=" + ics.GetVar("rule.assetTypePD").trim());
    lineList.add("assettype.C=" + ics.GetVar("rule.assetTypeC").trim());
    lineList.add("assettype.CD=" + ics.GetVar("rule.assetTypeCD").trim());
    lineList.add("assettype.CD.instance=" + ics.GetVar("rule.assetSubtype").trim());

    Enumeration varNames = ics.GetVars();
    while (varNames.hasMoreElements()) {
        String varName = ((String)varNames.nextElement()).trim();
        if (!varName.startsWith("rule.field.")) {
            continue;
        }

        String fieldName = varName.substring("rule.field.".length());
        String fieldValue = ics.GetVar(varName).trim();

        if (fieldName.isEmpty() || fieldValue.isEmpty()) {
            continue;
        }

        if (xssCharFound(fieldValue)) {
            throw new IllegalArgumentException("xss char found in attribute value");
        }

        int pos = fieldValue.indexOf(userTzToken);
        if (pos > -1) {
            String userTzDateStr = fieldValue.substring(pos + userTzToken.length(), fieldValue.length());
            Date userTzDate = userTzDateFormat.parse(userTzDateStr);
            String serverTzDateStr = serverTzDateFormat.format(userTzDate);
            fieldValue = fieldValue.substring(0, pos) + serverTzDateStr;
        }

        lineList.add(fieldName + "=" + fieldValue);
    }

    GroupMapper groupMapper = GroupMapper.parse(ruleName, lineList);

    groupMatcher.setGroupMapper(groupMapper);

    // Return to caller with updated or created GroupMapper
    ics.SetObj ("wcc.groupMatcher", groupMatcher);
} catch (Exception e) {
    // No updates because of an error (mainly a xss attack)
    ics.SetObj ("wcc.groupMatcher", null);
}
%>
</cs:ftcs>
