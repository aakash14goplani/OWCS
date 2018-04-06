<%@page import="com.fatwire.assetapi.def.AttributeTypeEnum"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.stellent.ucm.poller.*,
                   oracle.wcs.assetdef.*,
                   oracle.wcs.mapping.*,
                   oracle.wcs.matching.*,
                   oracle.wcs.util.WcsLocale,
                   java.text.*,
                   java.util.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>

<%
ics.CallElement("WCC/Util/LoadIntegrationIni", null);
FileBasedProps wccProps = (FileBasedProps) ics.GetObj("wcc.integration.ini");

String dDocNameField = wccProps.getProperty(Constants.KeyField);

ics.CallElement("WCC/Util/LoadSiteNameList", null);
List<String> siteList = (List<String>) ics.GetObj ("wcc.ui.site.name.list");

ics.CallElement("WCC/Util/LoadMetaKeyList", null);
Map<String,String> metaKeyTypeMap = (Map<String,String>) ics.GetObj ("wcc.ui.meta.name.type.map");

ics.CallElement("WCC/Util/LoadConvNameList", null);
List<String> conversionNameList = (List<String>) ics.GetObj ("wcc.ui.conversion.name.list");

ics.CallElement("WCC/Util/LoadRendNameList", null);
List<String> renditionNameList = (List<String>) ics.GetObj ("wcc.ui.rendition.name.list");

ics.CallElement("WCC/Rule/RetrieveAssetFamily", null);
List<AssetType> assetTypeList = (List<AssetType>) ics.GetObj ("wcc.assetTypeList");

ics.CallElement("WCC/Rule/ParseRuleFiles", null);
Map<String, GroupMatcher> iniGroupMatcherMap = (Map<String, GroupMatcher>) ics.GetObj ("wcc.groupMatcherMap");

GroupMatcher iniGroupMatcher = iniGroupMatcherMap.get(ics.GetVar("editRule"));

boolean createNew = (iniGroupMatcher == null);
ArrayList<String> existRuleList = new ArrayList<String>();

if (createNew) {
    iniGroupMatcher = new GroupMatcher();
    
    if (ics.GetVar("rule.count") != null) {
        int count = Integer.parseInt(ics.GetVar("rule.count"));
        for (int i = 0; i < count; i++) {
            existRuleList.add(ics.GetVar("rule." + i));
        }
    }
}

GroupMapper iniGroupMapper = iniGroupMatcher.getGroupMapper();

if (iniGroupMapper == null) {
    iniGroupMapper = new GroupMapper();
}

WcsLocale wcsLocale = new WcsLocale(ics);

SimpleDateFormat serverTzDateFormat = new SimpleDateFormat (Constants.TimeZoneDatePattern);
serverTzDateFormat.setTimeZone(TimeZone.getDefault());

SimpleDateFormat userTzDateFormat = new SimpleDateFormat (Constants.NoTimeZoneDatePattern);
userTzDateFormat.setTimeZone(wcsLocale.getSessionTimeZone());

Date userTzDate = new Date();
String userTzDateStr = userTzDateFormat.format(userTzDate);
%>

<script type="text/javascript">
dojo.require("fw.ui.dijit.StepWizard");

nextID = 0;
getNextID = function () {
    return nextID++;
};

tzDiffMillis = dojo.date.locale.parse("<%=userTzDateStr%>", {selector: "date", datePattern: "<%=Constants.NoTimeZoneDatePattern%>"}).getTime() - <%=userTzDate.getTime()%>;

inputedRule = new Rule("ruleDiv");

mData = new MemoryData();

mData.isNewRule = <%=createNew%>;
mData.inputedRuleEnabled = <%=iniGroupMatcher.isEnabled()%>;
mData.inputedRuleName = "<%=iniGroupMatcher.getRuleName()%>";
mData.inputedRuleDesc = "<%=iniGroupMatcher.getRuleDesc()%>";
mData.inputedTypeC = "<%=iniGroupMapper.getTypeC()%>";
mData.inputedSubtype = "<%=iniGroupMapper.getTypeCDinstance()%>";
mData.fwKeyField = "<%=dDocNameField%>";

mData.ucmOperators.push(new UserOp("StringEquals",      "string",   '<xlat:stream key="wcc/rule/operator/Equals" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("StringContains",    "string",   '<xlat:stream key="wcc/rule/operator/Contains" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("StringStartsWith",  "string",   '<xlat:stream key="wcc/rule/operator/StartsWith" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("StringEndsWith",    "string",   '<xlat:stream key="wcc/rule/operator/EndsWith" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("StringGreaterThan", "string",   '<xlat:stream key="wcc/rule/operator/GreaterThan" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("StringLessThan",    "string",   '<xlat:stream key="wcc/rule/operator/LessThan" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("DateBefore",        "date",     '<xlat:stream key="wcc/rule/operator/Before" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("DateAfter",         "date",     '<xlat:stream key="wcc/rule/operator/After" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntEquals",         "int",      '<xlat:stream key="wcc/rule/operator/IntEquals" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntNotEquals",      "int",      '<xlat:stream key="wcc/rule/operator/IntNotEquals" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntGreaterThan",    "int",      '<xlat:stream key="wcc/rule/operator/IntGreaterThan" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntGreaterEquals",  "int",      '<xlat:stream key="wcc/rule/operator/IntGreaterEquals" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntLessThan",       "int",      '<xlat:stream key="wcc/rule/operator/IntLessThan" escape="true" encode="false"/>'));
mData.ucmOperators.push(new UserOp("IntLessEquals",     "int",      '<xlat:stream key="wcc/rule/operator/IntLessEquals" escape="true" encode="false"/>'));

<%
for (String name : existRuleList) {
    out.println("mData.existRules.push('" + name + "');");
}

for (String name : conversionNameList) {
    out.println("mData.ucmConversionNames.push('" + name + "');");
    out.println("mData.ucmConversionDescs.push('" + wcsLocale.translates("wcc/rule/attrvalue/" + name, "js") + "');");
}

for (String name : renditionNameList) {
    out.println("mData.ucmRenditionNames.push('" + name + "');");
}

for (String name : metaKeyTypeMap.keySet()) {
    out.println("mData.ucmMetakeys.push(new UcmMetakey('" + name + "','" + metaKeyTypeMap.get(name) + "'));");
}
%>

new function () {

var row;
var singleRule;

<%
for (GroupMatcher andMatcher : iniGroupMatcher.getGroupRuleList()) {
    out.println("row = inputedRule.addRow();");
    for (SingleMatcher orMatcher : andMatcher.getSingleRuleList()) {
        String metaKeyType = metaKeyTypeMap.get(orMatcher.getMetaName());
        String oprand = orMatcher.getOprand();
        if ("date".equals(metaKeyType)) {
            oprand = userTzDateFormat.format(serverTzDateFormat.parse(oprand));
        }
        out.println("singleRule = new UserSingleRule('"
                + orMatcher.getMetaName() + "', '"
                + metaKeyType + "', '"
                + orMatcher.getOperator() + "', '"
                + oprand + "');");
        out.println("row.addCell(singleRule);");
    }
}
%>

if (inputedRule.rows.length == 0) {
    inputedRule.addRow().addCell(new UserSingleRule("","","",""));
}

var fwAsset;
var fwSubtype;
var fwParentGroup;

<%
for (AssetType assetType : assetTypeList) {
    
    out.println("fwAsset = new FwAsset('" + assetType.getTypeC() + "', '" + assetType.getTypeCD() + "', '"
            + assetType.getTypeP() + "', '" + assetType.getTypePD() + "', '" + assetType.getTypeA() + "');");
    out.println("mData.fwAssets.push(fwAsset);");
    
    for (AssetSubtype assetSubtype : assetType.getSubtypeMap().values()) {
        
        out.println("fwSubtype = new FwSubtype('" + assetSubtype.getSubtype() + "');");
        out.println("fwAsset.fwSubtypes.push(fwSubtype);");

        boolean iniMatched = assetType.getTypeC().equals(iniGroupMapper.getTypeC()) 
                          && assetSubtype.getSubtype().equals(iniGroupMapper.getTypeCDinstance());
        
        List<String> iniSiteList = Collections.<String>emptyList();
        if (iniMatched) {
            SingleMapper sitesMapper = iniGroupMapper.getSingleMapperMap().get("sites");
            if (sitesMapper != null && sitesMapper.getWccAssetGetter().getFieldType() == Constants.TypeLiteral) {
                iniSiteList = sitesMapper.getWccAssetGetter().getStringList();
            }
        }

        if (assetSubtype.getSiteList().contains("0")) {
            out.println("fwSubtype.fwSites.push(new FwSite('0', " + iniSiteList.contains("0") + "));");
        }
        for (String site : assetSubtype.getSiteList()) {
            if ("0".equals(site) || "AdminSite".equals(site)) {
                continue;
            }
            out.println("fwSubtype.fwSites.push(new FwSite('" + site + "', " + iniSiteList.contains(site) + "));");
        }

        for (FieldDef fieldDef : assetSubtype.getSortedFieldDefs()) {
            String fieldType = "", fieldValue = "";
            if (iniMatched) {
                SingleMapper singleMapper = iniGroupMapper.getSingleMapperMap().get(fieldDef.getName());
                if (singleMapper != null) {
                    fieldType = singleMapper.getWccAssetGetter().getFieldType();
                    fieldValue = singleMapper.getWccAssetGetter().getFieldValue();
                }
            }
            if (fieldDef.getType() == AttributeTypeEnum.DATE && Constants.TypeLiteral.equals(fieldType) && !fieldValue.isEmpty()) {
                fieldValue = userTzDateFormat.format(serverTzDateFormat.parse(fieldValue));
            }
            out.println("fwSubtype.fwFields.push(new FwField('" + fieldDef.getName() + "', '" + fieldDef.getType() + "', "
                    + fieldDef.isRequired() + ", " + fieldDef.isList()
                    + ", '" + fieldType + "', '" + fieldValue + "'));");
        }

        List<String> selectedParentNameList = null;
        if (iniMatched) {
            SingleMapper parentsMapper = iniGroupMapper.getSingleMapperMap().get("parents");
            if (parentsMapper != null && parentsMapper.getWccAssetGetter().getFieldType() == Constants.TypeLiteral) {
                selectedParentNameList = parentsMapper.getWccAssetGetter().getStringList();
            }
        }
        
        for (ParentFieldDef parentDef : assetSubtype.getParentDefList()) {
            out.println("fwParentGroup = new FwParentGroup('" + parentDef.getName() + "', "
                    + parentDef.isRequired() + ", " + !parentDef.isList() + ");");
            out.println("fwSubtype.fwParentGroups.push(fwParentGroup);");
            
            for (String name : parentDef.getParentMap().keySet()) {
                boolean userCheck = false;
                if (selectedParentNameList != null) {
                    userCheck = selectedParentNameList.contains(name);
                }
                out.println("fwParentGroup.fwParents.push(new FwParent('" + name + "', " + userCheck + "));");
            }
        }
    }
}
%>

}();

function submitRuleForm() {
    if (!basicValidation()) {
        return;
    }
    
    var ruleIniText = inputedRule.getIniText();
    var fwAsset = mData.getAsset(mData.inputedTypeC);
    var fwSubtype = fwAsset.getSubtype(mData.inputedSubtype);
    var fwFields = fwSubtype.fwFields;
    
    var newForm = dojo.create("form", {
        action : "ContentServer",
        method : "post"
    }, document.AppForm, "after");

    dojo.create("input", {
        type : "hidden",
        name : "_authkey_",
        value : "<%=session.getAttribute("_authkey_")%>"
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "pagename",
        value : "WCC/RuleList"
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.isNewRule",
        value : mData.isNewRule
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.isRuleEnabled",
        value : mData.inputedRuleEnabled
    }, newForm);
    
    dojo.create("input", {
        type : "hidden",
        name : "rule.ruleName",
        value : mData.inputedRuleName
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.ruleDesc",
        value : mData.inputedRuleDesc
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.matchingRuleText",
        value : ruleIniText
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetTypeC",
        value : fwAsset.typeC
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetTypeCD",
        value : fwAsset.typeCD
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetTypeP",
        value : fwAsset.typeP
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetTypePD",
        value : fwAsset.typePD
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetTypeA",
        value : fwAsset.typeA
    }, newForm);

    dojo.create("input", {
        type : "hidden",
        name : "rule.assetSubtype",
        value : fwSubtype.subtype
    }, newForm);

    for (var i = 0; i < fwFields.length; i++) {
        var fwField = fwFields[i];
        if (fwField.name != mData.fwKeyField && fwField.inputedType && fwField.inputedValue) {
        	var value2submit;
        	if (fwField.inputedType == "<%=Constants.TypeLiteral%>") {
        		if (fwField.type == "date") {
                    var userTzDate = dojo.date.locale.parse(fwField.inputedValue, {formatLength:'medium'});
                    var userTzDateStr = dojo.date.locale.format(userTzDate, {selector: "date", datePattern: "<%=Constants.NoTimeZoneDatePattern%>"});
                    value2submit = "@UserProfileTimeZone@" + userTzDateStr;
        		} else {
                    value2submit = fwField.inputedValue;
        		}
        	} else {
        		value2submit = fwField.inputedType + "." + fwField.inputedValue
        	}
            dojo.create("input", {
                type : "hidden",
                name : "rule.field." + fwField.name,
                value : value2submit
            }, newForm);
        }
    }
    
    var selectedSites = "";
    for (var i = 0; i < fwSubtype.fwSites.length; i++) {
        var fwSite = fwSubtype.fwSites[i];
        if (fwSite.inputedCheck) {
            if (selectedSites) {
                selectedSites += "; "
            }
            selectedSites += fwSite.name;
        }
    }
    
    dojo.create("input", {
        type : "hidden",
        name : "rule.field.sites",
        value : selectedSites
    }, newForm);

    var selectedParents = new Array(); // string
    for (var i = 0; i < fwSubtype.fwParentGroups.length; i++) {
        var fwParentGroup = fwSubtype.fwParentGroups[i];
        for (var j = 0; j < fwParentGroup.fwParents.length; j++) {
            var fwParent = fwParentGroup.fwParents[j];
            if (fwParent.inputedCheck) {
                selectedParents.push(fwParent.name);
            }
        }
    }
    if (selectedParents.length > 0) {
        var inputedParents = selectedParents[0];
        for (var i = 1; i < selectedParents.length; i++) {
            inputedParents += '; ' + selectedParents[i];
        }
        dojo.create("input", {
            type : "hidden",
            name : "rule.field.parents",
            value : inputedParents
        }, newForm);
    }
    
    newForm.submit();
}

function cancelRuleForm() {
    if (confirm('<xlat:stream key="dvin/Common/CancelClicked" escape="true" encode="false"/>')) {
        window.location="ContentServer?pagename=WCC/RuleList";
    }
}

dojo.addOnLoad(function () {
    inputedRule.paintDisabled = false;
    inputedRule.paint();

    var textUI = dojo.byId("currentDocNameFieldText");
    textUI.innerHTML = mData.fwKeyField;
    
    populateNameTabUI();

    populateTypeUI();
    populateSubtypeUI();
    populateParentGroupUI();
    populateSiteCheckUI();

    updateDependencyOnAssetType();
    updateDependencyOnRuleName();
});
</script>

</cs:ftcs>
