<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.wcs.mapping.*,
                   oracle.wcs.matching.*,
                   oracle.wcs.util.*,
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
ics.CallElement("WCC/Rule/ParseRuleFiles", null);
Map<String, GroupMatcher> groupMatcherMap = (Map<String, GroupMatcher>) ics.GetObj ("wcc.groupMatcherMap");
List<String> ruleOrderList = (List<String>) ics.GetObj ("wcc.ruleOrderList");

if (ics.GetVar("sortRules") != null) {
	
	ArrayList<String> newRuleOrderList = new ArrayList<String>();
	
	int count = Integer.parseInt(ics.GetVar("sortRules"));
	for (int i = 0; i < count; i++) {
		String ruleName = ics.GetVar("rule-" + i);
		boolean ruleEnabled = Boolean.valueOf(ics.GetVar("enabled-" + i));
		if (ruleOrderList.remove(ruleName)) {
			newRuleOrderList.add(ruleName);
			groupMatcherMap.get(ruleName).setEnabled(ruleEnabled);
		}
	}
	
	newRuleOrderList.addAll(ruleOrderList);
	ruleOrderList = newRuleOrderList;
	
	ics.SetObj ("wcc.ruleOrderList", ruleOrderList);
    
    ics.CallElement("WCC/Rule/StoreRuleFiles", null);
	
} else if (ics.GetVar("deleteRule") != null) {

    ruleOrderList.remove(ics.GetVar("deleteRule"));

    ics.CallElement("WCC/Rule/StoreRuleFiles", null);
    
} else if (ics.GetVar("rule.isNewRule") != null) {
	
    ics.CallElement("WCC/Rule/ProcessRuleForm", null);
    GroupMatcher groupMatcher = (GroupMatcher) ics.GetObj ("wcc.groupMatcher");
    
    if (groupMatcher != null) {
        groupMatcherMap.put(groupMatcher.getRuleName(), groupMatcher);
        
        if (!ruleOrderList.contains(groupMatcher.getRuleName())) {
            ruleOrderList.add(groupMatcher.getRuleName());
        }
        
        ics.CallElement("WCC/Rule/StoreRuleFiles", null);
    }
}
%>

<script type="text/javascript">
rules = new Array();

dojo.addOnLoad(function () {
    var parentTag;
    var inputTag;
    var alt;
    
    parentTag = dojo.byId("add-link");
    alt = '<xlat:stream key="wcc/rule/button/newrule" escape="true" encode="false"/>';
    inputTag = new fw.ui.dijit.Button (
            {   label: alt, title: alt
            }).placeAt(parentTag);
});

function submitEditForm(ruleIndex) {
    var reqForm = dojo.create("form", {
        action : "ContentServer",
        method : "post"
    }, document.AppForm, "after");
    
    dojo.create("input", {
        type : "hidden",
        name : "_authkey_",
        value : "<%=session.getAttribute("_authkey_")%>"
    }, reqForm);
    
    dojo.create("input", {
        type : "hidden",
        name : "pagename",
        value : "WCC/RuleDetail"
    }, reqForm);
    
    if (ruleIndex > -1) {
        dojo.create("input", {
            type : "hidden",
            name : "editRule",
            value : rules[ruleIndex].name
        }, reqForm);
    } else if (rules.length > 0) {
        dojo.create("input", {
            type : "hidden",
            name : "rule.count",
            value : rules.length
        }, reqForm);
        
        for (var i = 0; i < rules.length; i++) {
            dojo.create("input", {
                type : "hidden",
                name : "rule." + i,
                value : rules[i].name
            }, reqForm);
        }
    }
    
    reqForm.submit();
}
</script>

<%
if (ruleOrderList.size() > 0) {
%>
<script type="text/javascript">
<%
	for (int i = 0; i < ruleOrderList.size(); i++) {
	    GroupMatcher groupMatcher = groupMatcherMap.get(ruleOrderList.get(i));
	    
	    out.println("rules.push(new Rule('" + groupMatcher.getRuleName() + "', '" + groupMatcher.getRuleDesc() + "', " + groupMatcher.isEnabled() +  "));");
	}
%>


function Rule (name, desc, enabled) {
	var enableTip = '<xlat:stream key="wcc/rule/build/tip/checktoenable" escape="true" encode="false"/>';
	var disableTip = '<xlat:stream key="wcc/rule/build/tip/checktodisable" escape="true" encode="false"/>';
	
	this.name = name;
	this.desc = desc;
	this.enabled = enabled;
	this.tip = enabled ? disableTip : enableTip;
	
	this.setEnabled = function (b) {
	    this.enabled = b;
	    this.tip = b ? disableTip : enableTip;
	}
}

function moveUp(row) {
	if (row < 1) {
		return;
	}
	exchangeRows(row - 1, row);
}

function moveDown(row) {
	if (row > rules.length - 2) {
		return;
	}
    exchangeRows(row, row + 1);
}

function exchangeRows(thisRow, thatRow) {
	var temp = rules[thisRow];
	rules[thisRow] = rules[thatRow];
	rules[thatRow] = temp;
	
	dojo.byId("ruleNameTag-" + thisRow).innerHTML = rules[thisRow].name;
    dojo.byId("ruleNameTag-" + thatRow).innerHTML = rules[thatRow].name;
    
    dojo.byId("ruleDescTag-" + thisRow).innerHTML = rules[thisRow].desc;
    dojo.byId("ruleDescTag-" + thatRow).innerHTML = rules[thatRow].desc;
    
    dojo.byId("ruleEnabledTag-" + thisRow).checked = rules[thisRow].enabled;
    dojo.byId("ruleEnabledTag-" + thatRow).checked = rules[thatRow].enabled;
    
    dojo.byId("ruleEnabledTag-" + thisRow).title = rules[thisRow].tip;
    dojo.byId("ruleEnabledTag-" + thatRow).title = rules[thatRow].tip;
}

function enabledChanged(row) {
    var enableCheck = dojo.byId("ruleEnabledTag-" + row);
	rules[row].setEnabled(enableCheck.checked);
	enableCheck.title = rules[row].tip;
}

dojo.addOnLoad(function () {
    var parentTag;
    var inputTag;
    var alt;

    parentTag = dojo.byId("save-link");
    alt = '<xlat:stream key="dvin/UI/Save" escape="true" encode="false"/>';
    inputTag = new fw.ui.dijit.Button (
            {   label: alt, title: alt
            }).placeAt(parentTag);
    
    for (var i = 0; i < rules.length; i++) {
    	var enableCheck = dojo.byId("ruleEnabledTag-" + i);
    	enableCheck.checked = rules[i].enabled;
    	enableCheck.title = rules[i].tip;
    }
});

function submitDeleteForm(ruleIndex) {
	if (!confirm('<xlat:stream key="fatwire/Alloy/UI/AreYouSureYouWantToDeleteByName" escape="true" encode="false"/>'.replace('Variables.assetName', rules[ruleIndex].name))) {
		return;
	}
	
    var reqForm = dojo.create("form", {
        action : "ContentServer",
        method : "post"
    }, document.AppForm, "after");
    
    dojo.create("input", {
        type : "hidden",
        name : "_authkey_",
        value : "<%=session.getAttribute("_authkey_")%>"
    }, reqForm);
    
    dojo.create("input", {
        type : "hidden",
        name : "pagename",
        value : "WCC/RuleList"
    }, reqForm);
        
    dojo.create("input", {
        type : "hidden",
        name : "deleteRule",
        value : rules[ruleIndex].name
    }, reqForm);
    
    reqForm.submit();
}

function submitSortForm() {
    var reqForm = dojo.create("form", {
        action : "ContentServer",
        method : "post"
    }, document.AppForm, "after");
    
    dojo.create("input", {
        type : "hidden",
        name : "_authkey_",
        value : "<%=session.getAttribute("_authkey_")%>"
    }, reqForm);
    
    dojo.create("input", {
        type : "hidden",
        name : "pagename",
        value : "WCC/RuleList"
    }, reqForm);
    
    dojo.create("input", {
        type : "hidden",
        name : "sortRules",
        value : rules.length
    }, reqForm);
    
    for (var i = 0; i < rules.length; i++) {
        dojo.create("input", {
            type : "hidden",
            name : "rule-" + i,
            value : rules[i].name
        }, reqForm);
        
        dojo.create("input", {
            type : "hidden",
            name : "enabled-" + i,
            value : rules[i].enabled
        }, reqForm);
    }
    
    reqForm.submit();
}
</script>
<%
}
%>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
    <tr><td>
        <span class="title-text"><xlat:stream key="wcc/rule/title/long"/></span></td></tr>
    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<%
if (ruleOrderList.size() > 0) {
%>
<style>
	#wcc-connector-rules td {
		padding: 0 4px;
		min-width: 100px;
		width: 100%;
	}
</style>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
    <tr>
        <td></td>
        <td class="tile-dark" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
        <td></td>
    </tr>
    <tr>
        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
        <td >
            <table id="wcc-connector-rules" class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
                <tr>
                    <td colspan="4" class="tile-highlight">
                        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
                </tr>
                <tr>
                    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
                    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
                        <DIV class="new-table-title"><xlat:stream key="dvin/UI/Common/Enabled"/></DIV></td>
                    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
                        <DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV></td>
                    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
                        <DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV></td>
                </tr>
                <tr>
                    <td colspan="4" class="tile-dark">
                        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
                </tr>
<%
boolean rowNormal = false;
for (int i = 0; i < ruleOrderList.size(); i++) {
    GroupMatcher groupMatcher = groupMatcherMap.get(ruleOrderList.get(i));
    
    String rowStyle = (rowNormal = !rowNormal) ? "tile-row-normal" : "tile-row-highlight";
%>
                <tr class="<%=rowStyle%>">
                    <td VALIGN="bottom">
                        <A title="<xlat:stream key="dvin/Common/Edit"/>" href="javascript:void(0)" onclick="submitEditForm(<%=i%>);">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContent.gif"  border="0"/>
                        </A>
                        <A title="<xlat:stream key="dvin/Common/Delete"/>" href="javascript:void(0)" onclick="submitDeleteForm(<%=i%>);">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif"  border="0"/>
                        </A>
                        <A title="<xlat:stream key="dvin/UI/Moveup"/>" href="javascript:void(0)" onclick="moveUp(<%=i%>);">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/controlpanel/up.gif"  border="0"/>
                        </A>
                        <A title="<xlat:stream key="dvin/UI/Movedown"/>" href="javascript:void(0)" onclick="moveDown(<%=i%>);">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/controlpanel/dn.gif"  border="0"/>
                        </A></td>
                    <td>
                        <input id="ruleEnabledTag-<%=i%>" type="checkbox" onclick="enabledChanged(<%=i%>);"></td>
                    <td>
                        <a title="<xlat:stream key="dvin/Common/Edit"/>" href="javascript:void(0)" onclick="submitEditForm(<%=i%>);">
	                        <div id="ruleNameTag-<%=i%>" class="small-text-inset">
	                            <%=groupMatcher.getRuleName()%>
	                        </div>
                        </a></td>
                    <td>
                        <div id="ruleDescTag-<%=i%>" class="small-text-inset">
                            <%=groupMatcher.getRuleDesc()%>
                        </div></td>
                </tr>
<%
}
%>
            </table></td>
        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"></td>
    </tr>
    <tr>
        <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
    </tr>
</table> 
<%
}
%>

<div id="button-div" class="width-outer-70">
    <A id="add-link" href="javascript:void(0)" onclick="submitEditForm(-1);"></A>
<%
if (ruleOrderList.size() > 0) {
%>
    <A id="save-link" href="javascript:void(0)" onclick="submitSortForm();"></A>
<%
}
%>
</div>

</cs:ftcs>
