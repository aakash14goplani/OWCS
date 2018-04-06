<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ page import="oracle.wcs.util.WcsLocale"%>
<cs:ftcs>
<%
WcsLocale wcsLocale = new WcsLocale(ics);
%>
    <script type="text/javascript">
        function populateNameTabUI() {
            // ruleName
            var ruleNameTd = dojo.byId("ruleNameTdId");
            var ruleNameText = new fw.dijit.UIInput (
                    {   type: "text", style: "width: 30em;", value: mData.inputedRuleName, readOnly: !mData.isNewRule,
                        onChange: function(newValue) {
                        	onRuleNameChange(newValue);
                        },
                        validator: function (value) {
                        	if (value.length > 64) {
                        		this.set("value", value.substring(0, 64));
                        	}
                        	return true;
                        }
                    }).placeAt(ruleNameTd);

            // ruleDesc
            var ruleDescTd = dojo.byId("ruleDescTdId");
            var ruleDescText = new fw.dijit.UIInput (
                    {   type: "text", style: "width: 30em;", value: mData.inputedRuleDesc,
                        onChange: function(newValue) {
                            onRuleDescChange(newValue);
                        },
                        validator: function (value) {
                            if (value.length > 64) {
                                this.set("value", value.substring(0, 64));
                            }
                            return true;
                        }
                    }).placeAt(ruleDescTd);

            // ruleEnabled
            var ruleEnabledTd = dojo.byId("ruleEnabledTdId");
            ruleEnabledTd.innerHTML = "<input id='ruleEnabledId' type='checkbox' style='margin-left: 1px;' "
                    + (mData.inputedRuleEnabled ? "checked" : "") + " onclick='onRuleEnabledChange()'/>";
        }

        function onRuleNameChange(newValue) {
            mData.inputedRuleName = dojo.trim(newValue);

            updateDependencyOnRuleName();
        }

        function onRuleDescChange(newValue) {
            mData.inputedRuleDesc = dojo.trim(newValue);

            updateDependencyOnRuleName();
        }

        function onRuleEnabledChange() {
            mData.inputedRuleEnabled = dojo.byId("ruleEnabledId").checked;
        }

        function updateDependencyOnRuleName() {
            updateRuleNameTitle("ruleNameIdAtNameTab");
            updateRuleNameTitle("ruleNameIdAtRuleTab");
            updateRuleNameTitle("ruleNameIdAtTargetTab");
            updateRuleNameTitle("ruleNameIdAtAttrTab");
            
            var stepWizard = dijit.byId("ruleStepWizard");

            if (mData.inputedRuleName == "" || mData.inputedRuleDesc == "") {
                stepWizard._disableStep(1);
                stepWizard._disableStep(2);
                stepWizard._disableStep(3);
            } else {
                stepWizard._enableStep(1);
                stepWizard._enableStep(2);
                if (mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype)) {
                    stepWizard._enableStep(3);
                }
            }
        }

        function updateRuleNameTitle(titleId) {
            var titleTag = dojo.byId(titleId);
            if (titleTag) {
                titleTag.innerHTML = "<%=wcsLocale.translates("dvin/Common/Name")%> : " + mData.inputedRuleName;
            }
        }
    </script>
</cs:ftcs>


