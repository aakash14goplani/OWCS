<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="oracle.wcs.util.WcsLocale"%>
<cs:ftcs>
    <script type="text/javascript">
        function populateTypeUI() {
            var datastore = {identifier: "name", label: "name", items: [{name: ""}]};
            var options = mData.fwAssets; // FwAsset
            for (var i = 0; i < options.length; i++) {
                datastore.items.push({ name: options[i].typeC });
            }

            var store = new dojo.data.ItemFileReadStore({data: datastore});

            var div = dojo.byId("asset-type-td");
            var combo = new fw.dijit.UIFilteringSelect (
                       {    store: store, searchAttr: "name", value: mData.inputedTypeC,
                    	    placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                            onChange: function(newValue) {
                            	onAssetTypeChange(newValue);
                            }
                       }).placeAt(div);
        }

        function onAssetTypeChange(newValue) {
            mData.inputedTypeC = newValue;
            mData.inputedSubtype = "";

            populateSubtypeUI();
            populateParentGroupUI();
            populateSiteCheckUI();

            updateDependencyOnAssetType();
        }

        function populateSubtypeUI() {
            var datastore = {identifier: "name", label: "name", items: [{name: ""}]};
            
            var fwAsset = mData.getAsset(mData.inputedTypeC);
            if (fwAsset) {
                var options = fwAsset.fwSubtypes; // FwSubtype
                for (var i = 0; i < options.length; i++) {
                    datastore.items.push({ name: options[i].subtype });
                }
            }
            
            var store = new dojo.data.ItemFileReadStore({data: datastore});
            
            var valueUiId = "asset_subtype_ui";
            
            var w = dijit.byId(valueUiId);
            if (w) {
                w.destroyRecursive();
            }
            
            var div = dojo.byId("asset-subtype-td");
            var combo = new fw.dijit.UIFilteringSelect (
                    {    id: valueUiId, store: store, searchAttr: "name", value: mData.inputedSubtype,
                         placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                         onChange: function(newValue) {
                        	 onAssetSubtypeChange(newValue);
                         }
                    }).placeAt(div);
        }

        function onAssetSubtypeChange(newValue) {
            mData.inputedSubtype = newValue;

            populateParentGroupUI();
            populateSiteCheckUI();

            updateDependencyOnAssetType();
        }

        function updateDependencyOnAssetType() {
            var stepWizard = dijit.byId("ruleStepWizard");
            
            if (mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype) == null) {
                stepWizard._disableStep(3);
            } else {
                stepWizard._enableStep(3);

                var textUI;

                textUI = dojo.byId("currentTypeText");
                textUI.innerHTML = mData.inputedTypeC;

                textUI = dojo.byId("currentSubtypeText");
                textUI.innerHTML = mData.inputedSubtype;

                populateFieldMappingUI();
            }
        }

        function populateParentGroupUI() {
            var parentTd = dojo.byId("asset-parent-td");
            parentTd.innerHTML = "";

            var fwSubtype = mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype);
            if (fwSubtype) {
                for ( var i = 0; i < fwSubtype.fwParentGroups.length; i++) {
                    var fwParentGroup = fwSubtype.fwParentGroups[i];

                    if (i > 0) {
                    	parentTd.appendChild(document.createElement("br"));
                    }
                    
                    if (fwParentGroup.isRequired) {
                    	var span = document.createElement("span");
                        span.className = "alert-color";
                    	span.appendChild(document.createTextNode("*"));
                        
                    	parentTd.appendChild(span);
                    }
                    
                    parentTd.appendChild(document.createTextNode(fwParentGroup.name));
                    parentTd.appendChild(document.createElement("br"));
                    
                    if (fwParentGroup.isSingleSelection) {
                    	populateSingleParentUI(parentTd, fwParentGroup);
                    } else {
                    	populateMultipleParentUI(parentTd, fwParentGroup);
                    }
                }
            }
        }
        
        function populateSingleParentUI(div, fwParentGroup) {
            var datastore = {identifier: "name", label: "name", items: [{name: ""}]};
            
            var selectedOption = "";
            var options = fwParentGroup.fwParents; // FwParent
            for (var i = 0; i < options.length; i++) {
                datastore.items.push({ name: options[i].name });
                if (!selectedOption && options[i].inputedCheck) {
                	selectedOption = options[i].name;
                }
            }
            
            if (fwParentGroup.isRequired && options.length > 0 && !selectedOption) {
            	selectedOption = options[0].name;
                fwParentGroup.selectSingleParent(selectedOption);
            }

            var store = new dojo.data.ItemFileReadStore({data: datastore});

            var combo = new fw.dijit.UIFilteringSelect (
                       {    store: store, searchAttr: "name", value: selectedOption,
                            placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                            onChange: function(newValue) {
                            	onSingleParentChange(fwParentGroup, newValue);
                            }
                       }).placeAt(div);
        }
        
        function onSingleParentChange(fwParentGroup, newValue) {
            fwParentGroup.selectSingleParent(newValue);
        }
        
        function populateMultipleParentUI(div, fwParentGroup) {
            for (var i = 0; i < fwParentGroup.fwParents.length; i++) {
                var uiId = "parent-check-" + getNextID();
                var fwParent = fwParentGroup.fwParents[i];
                
                if (i > 0) {
                	div.appendChild(document.createElement("br"));
                }
                
                var htmlInput = document.createElement("input");
                htmlInput.id = uiId;
                htmlInput.type = "checkbox";
                htmlInput.checked = fwParent.inputedCheck;
                htmlInput.onclick = function() {
                	var inputId = uiId;
                	var group = fwParentGroup.name;
                	var parent = fwParent.name;
                	return function() {
                        onMultipleParentChange(inputId, group, parent);
                	};
                }();
                
                div.appendChild(htmlInput);
                div.appendChild(document.createTextNode(" " + fwParent.name));
            }
        }
        
        function onMultipleParentChange(uiId, parentGroupName, parentName) {
            var uiCheck = dojo.byId(uiId).checked;
            var fwParent = mData.getParent(mData.inputedTypeC, mData.inputedSubtype, parentGroupName, parentName);
            fwParent.inputedCheck = uiCheck;
        }
        
        function populateSiteCheckUI() {
            var siteTd = dojo.byId("asset-site-td");
            var html = "";

            var fwSubtype = mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype);
            if (fwSubtype) {
                html += '<table BORDER="0" CELLSPACING="0" CELLPADDING="0">';
                html += '    <tr>';
                html += '        <td></td>';
                html += '        <td class="tile-dark" HEIGHT="1">';
                html += '            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
                html += '        <td></td>';
                html += '    </tr>';
                html += '    <tr>';
                html += '        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>';
                html += '        <td >';
                html += '            <table id="siteTable" class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" style="min-width: 180px;">';
                html += '                <tr>';
                html += '                    <td colspan="3" class="tile-highlight">';
                html += '                        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
                html += '                </tr>';
                html += '                <tr>';
                html += '                    <td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;</td>';
                html += '                    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
                html += '                        <DIV class="new-table-title"><xlat:stream key="dvin/UI/SiteName" escape="true" encode="false"/></DIV></td>';
                html += '                    <td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;</td>';
                html += '                </tr>';
                html += '                <tr>';
                html += '                    <td colspan="3" class="tile-dark">';
                html += '                        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
                html += '                </tr>';
            	
                for (var i = 0; i < fwSubtype.fwSites.length; i++) {
                    var fwSite = fwSubtype.fwSites[i];
                    var siteName = fwSite.name;
                    if (i == 0 && siteName == "0") {
                    	siteName = '<xlat:stream key="dvin/UI/AssetMgt/AllSites"/>';
                    } 
                    if (i % 2 == 0) {
                    	html += '<tr class="tile-row-normal">';
                    } else {
                    	html += '<tr class="tile-row-highlight">';
                    }
                    html += '  <td></td>';
                    html += '  <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">';
                    html += '    <DIV class="small-text-inset">';
                    html += '      <input type="checkbox" ' + (fwSite.inputedCheck ? 'checked' : '') + ' id="siteCheck-' + i + '" onclick="onSiteSelectionChange(' + i + ')"/> ';
                    html += siteName;
                    html += '    </DIV></td>';
                    html += '  <td></td>';
                    html += '</tr>';
                }
            	
                html += '            </table></td>';
                html += '        <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>';
                html += '    </tr>';
                html += '    <tr>';
                html += '        <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">';
                html += '            <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
                html += '    </tr>';
                html += '    <tr>';
                html += '        <td></td>';
                html += '        <td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif">';
                html += '            <IMG WIDTH="1" HEIGHT="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
                html += '        <td></td>';
                html += '    </tr>';
                html += '</table>';
            }
            
            siteTd.innerHTML = html;
        }

        function onSiteSelectionChange(siteIndex) {
            var siteCheck = dojo.byId("siteCheck-" + siteIndex);
            var fwSubtype = mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype);
            fwSubtype.fwSites[siteIndex].inputedCheck = siteCheck.checked;
            
            if (fwSubtype.fwSites[0].name != "0" || siteCheck.checked == false) {
            	return;
            }
            
            if (siteIndex == 0) {
            	for (var i = 1; i < fwSubtype.fwSites.length; i++) {
                    dojo.byId("siteCheck-" + i).checked = false;
                    fwSubtype.fwSites[i].inputedCheck = false;
            	}
            } else {
                dojo.byId("siteCheck-0").checked = false;
                fwSubtype.fwSites[0].inputedCheck = false;
            }
        }
    </script>
</cs:ftcs>
