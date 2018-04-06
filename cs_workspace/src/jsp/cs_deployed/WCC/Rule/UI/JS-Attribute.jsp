<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="oracle.stellent.ucm.poller.*"
%><cs:ftcs>
    <script type="text/javascript">
        function populateFieldMappingUI() {
            var html = '';
            html += '<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">';
            html += '<tr>';
            html += '    <td colspan="9" class="tile-highlight">';
            html += '        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
            html += '        <DIV class="new-table-title"><xlat:stream key="wcc/rule/col/attribute"/></DIV></td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
            html += '        <DIV class="new-table-title"><xlat:stream key="dvin/Common/Type"/></DIV></td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
            html += '        <DIV class="new-table-title"><xlat:stream key="wcc/rule/col/takefrom"/></DIV></td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
            html += '    <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
            html += '        <DIV class="new-table-title"><xlat:stream key="dvin/Common/Value"/></DIV></td>';
            html += '    <td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>';
            html += '</tr>';
            html += '<tr>';
            html += '    <td colspan="9" class="tile-dark">';
            html += '        <IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>';
            html += '</tr>';
            
            var fwSubtype = mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype);
            var fwFields = fwSubtype.fwFields;
            
            for ( var i = 0; i < fwFields.length; i++) {
                var fwField = fwFields[i];
                if (fwField.name == mData.fwKeyField) {
                    continue;
                }
                
                html += (i % 2 == 0) ? '<tr class="tile-row-normal">' : '<tr class="tile-row-highlight">';
                
                html += '  <td style="min-width:16px;"></td>';
                
                html += '  <td class="form-label-inset">';
                html += '    <DIV class="small-text-inset">';
                html += (fwField.isRequired ? '<span class="alert-color">*</span>' : '') + fwField.name;
                html += '    </DIV></td>';
                
                html += '  <td></td>';
                
                html += '  <td>';
                html += '    <DIV class="small-text-inset">';
                html += fwField.type + (fwField.isList ? " (M)" : "");
                html += '    </DIV></td>';
                
                html += '  <td></td>';
                html += '  <td><DIV id="' + fwField.name + '-type-div"></DIV></td>';
                html += '  <td></td>';
                html += '  <td style="white-space:nowrap;"><DIV id="' + fwField.name + '-value-div"></DIV></td>';
                html += '  <td style="min-width:16px;"></td>';
                html += '</tr>';
            }

            html += '</table>';
            
            var tableDiv = dojo.byId("attrMappingTable");
            
            dojo.forEach(dijit.findWidgets(tableDiv), function(w) {
                w.destroyRecursive(true);
            });
            
            tableDiv.innerHTML = html;
            
            for ( var i = 0; i < fwFields.length; i++) {
                var fwField = fwFields[i];
                if (fwField.name == mData.fwKeyField) {
                    continue;
                }
                renderFieldType(fwField);
                renderFieldValue(fwField);
            }
        }
        
        function renderFieldType(fwField) {
            var typeDivId = fwField.name + "-type-div";
            var div = dojo.byId(typeDivId);
            
            dojo.forEach(dijit.findWidgets(div), function(w) {
                w.destroyRecursive(true);
            });
            
            div.innerHTML = "";
            
            var datastore = {identifier: "name", label: "name", items: [{name: "", code: ""}]};
            
            if (fwField.type == "blob") {
            	datastore.items.push({name: "<xlat:stream key='<%="wcc/rule/attrvalue/" + Constants.TypeRendtion%>' escape='true' encode='false'/>", code: "<%=Constants.TypeRendtion%>"});
                datastore.items.push({name: "<xlat:stream key='<%="wcc/rule/attrvalue/" + Constants.TypeConversion%>' escape='true' encode='false'/>", code: "<%=Constants.TypeConversion%>"});
            } else if (fwField.type == "asset" || fwField.type == "assetreference") {
                datastore.items.push({name: "<xlat:stream key='<%="wcc/rule/attrvalue/" + Constants.TypeLiteral%>' escape='true' encode='false'/>", code: "<%=Constants.TypeLiteral%>"});
            } else {
                datastore.items.push({name: "<xlat:stream key='<%="wcc/rule/attrvalue/" + Constants.TypeLiteral%>' escape='true' encode='false'/>", code: "<%=Constants.TypeLiteral%>"});
                datastore.items.push({name: "<xlat:stream key='<%="wcc/rule/attrvalue/" + Constants.TypeMetadata%>' escape='true' encode='false'/>", code: "<%=Constants.TypeMetadata%>"});
            }
            
            var name = "";
            for (var i = 0; i < datastore.items.length; i++) {
                if (datastore.items[i].code == fwField.inputedType) {
                	name = datastore.items[i].name;
                }
            }
            
            var store = new dojo.data.ItemFileReadStore({data: datastore});
            var combo = new fw.dijit.UIFilteringSelect (
                       {   store: store, value: name,
                    	   placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                           onChange: function(newValue) {
                               onFieldTypeChange(fwField.name, this.item.code);
                           }
                       }).placeAt(div);
        }
        
        function renderFieldValue(fwField) {
            var valueDivId = fwField.name + "-value-div";
            var div = dojo.byId(valueDivId);
            
            dojo.forEach(dijit.findWidgets(div), function(w) {
                w.destroyRecursive(true);
            });
            
            div.innerHTML = "";
            
            if (fwField.inputedType == "") {
            	
            	return;
            	
            } else if (fwField.inputedType == "<%=Constants.TypeLiteral%>") {
            	
                if (fwField.type == 'date') {
                	
                	if (!fwField.inputedValue) {
                        fwField.inputedValue = dojo.date.locale.format(new Date(new Date().getTime() + tzDiffMillis), {formatLength:'medium'});
                	}
                	
                    var textbox = new fw.dijit.UIInput (
                            {   type: "text", value: fwField.inputedValue, readOnly: true,
                                onChange: function(newValue) {
                                	fwField.inputedValue = dojo.trim(newValue);
                                }
                            }).placeAt(div);
                    
                    var calIconDiv = dojo.create("div", {className: "calButton"}, div);
                    var picker = new dijit.form.DropDownButton({
                        label: '<img title="<xlat:stream key="fatwire/Alloy/UI/PickADate" escape="true" encode="false"/>" src="js/fw/images/ui/ui/engage/calendarButton.png" border="0"/>',
                        dropDown: null,
                        onClick: function() {
                            if(!this.dropDown) {
                                var _tstampwgt = new fw.ui.dijit.TimestampPicker({
                                    onTimeStampSelect: function(timeStamp) {
                                        textbox.set('value', dojo.date.locale.format(this.timeStamp, {formatLength:'medium'}));
                                    },  
                                    timeStamp: dojo.date.locale.parse(fwField.inputedValue, {formatLength:'medium'}),
                                    timePicker: true                        
                                });
                                this.dropDown = _tstampwgt;
                            }
                            this.openDropDown();
                        }
                    }, calIconDiv);

                } else {
                    var textbox = new fw.dijit.UIInput (
                            {   type: "text", value: fwField.inputedValue,
                                placeHolder: '<xlat:stream key="wcc/rule/build/tip/input" escape="true" encode="false"/>',
                                onChange: function(newValue) {
                                    onFieldValueChange(fwField.name, dojo.trim(newValue));
                                }
                            }).placeAt(div);
                }
            } else {
            	
                var datastore = {identifier: "name", label: "name", items: [{ name: "", code: "" }]};
                var name = fwField.inputedValue;
                
                if (fwField.inputedType == "<%=Constants.TypeMetadata%>") {
                    for (var i = 0; i < mData.ucmMetakeys.length; i++) {
                    	if (fwField.type == 'date') {
                    		if (mData.ucmMetakeys[i].type == 'date') {
                                datastore.items.push({ name: mData.ucmMetakeys[i].name, code: mData.ucmMetakeys[i].name });
                    		}
                    	} else if (fwField.type == 'int' || fwField.type == 'money' || fwField.type == 'float') {
                            if (mData.ucmMetakeys[i].type == 'int') {
                                datastore.items.push({ name: mData.ucmMetakeys[i].name, code: mData.ucmMetakeys[i].name });
                            }
                    	} else {
                            datastore.items.push({ name: mData.ucmMetakeys[i].name, code: mData.ucmMetakeys[i].name });
                    	}
                    }
                } else if (fwField.inputedType == "<%=Constants.TypeRendtion%>") {
                    for (var i = 0; i < mData.ucmRenditionNames.length; i++) {
                        datastore.items.push({ name: mData.ucmRenditionNames[i], code: mData.ucmRenditionNames[i] });
                    }
                } else if (fwField.inputedType == "<%=Constants.TypeConversion%>") {
                    for (var i = 0; i < mData.ucmConversionNames.length; i++) {
                        datastore.items.push({ name: mData.ucmConversionDescs[i], code: mData.ucmConversionNames[i] });
                        
                        if (mData.ucmConversionNames[i] == fwField.inputedValue) {
                        	name = mData.ucmConversionDescs[i];
                        }
                    }
                }
                
                var store = new dojo.data.ItemFileReadStore({data: datastore});
                var combo = new fw.dijit.UIFilteringSelect (
                           {   store: store, searchAttr: "name", value: name,
                        	   placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                               onChange: function(newValue) {
                                   onFieldValueChange(fwField.name, this.item.code);
                               }
                           }).placeAt(div);
            }
        }
        
        function onFieldTypeChange(fieldName, newValue) {
            var fwField = mData.getField(mData.inputedTypeC, mData.inputedSubtype, fieldName);
            fwField.inputedType = newValue;
            fwField.inputedValue = "";
            
            renderFieldValue(fwField);
        }
        
        function onFieldValueChange(fieldName, newValue) {
            var fwField = mData.getField(mData.inputedTypeC, mData.inputedSubtype, fieldName);
            fwField.inputedValue = newValue;
        }
    </script>
</cs:ftcs>
