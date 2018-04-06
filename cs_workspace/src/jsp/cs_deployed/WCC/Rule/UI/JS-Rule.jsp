<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="oracle.stellent.ucm.poller.Constants"%>
<cs:ftcs>
<script type="text/javascript">
function Rule(ruleDivId) {
    this.divId = ruleDivId;
    this.div = null;

    this.addAndDivId = this.divId + "-addAND";
    this.addAndDiv = null;

    this.paintDisabled = true;
    this.divIdManager = new DivIdManager();

    this.rows = new Array();

    this.getIniText = function() {
        var iniText = "";
        for ( var i = 0; i < this.rows.length; i++) {
            var rowIniText = this.rows[i].getIniText();
            if (rowIniText != "") {
                iniText += rowIniText + "\n";
            }
        }
        iniText = "(AND" + "\n" + iniText + ")";
        return iniText;
    };

    this.indexOfRow = function(rowDivId) {
        for ( var i = 0; i < this.rows.length; i++) {
            if (this.rows[i].divId == rowDivId) {
                return i;
            }
        }
        return -1;
    };

    this.addRow = function(afterThisRowDivId) { // afterThisRowDivId is optional
        var rowDivId = this.divIdManager.nextRowDivId(this.divId);
        var row = new Row(this, rowDivId);
        var afterThisIndex = this.indexOfRow(afterThisRowDivId);
        if (afterThisIndex == -1) {
            this.rows.push(row);
        } else {
            this.rows.splice(afterThisIndex + 1, 0, row);
        }
        row.paint();
        return row;
    };

    this.removeRow = function(rowDivId) {
        var i = this.indexOfRow(rowDivId);
        if (i > -1) {
            var row = this.rows[i];
            this.rows.splice(i, 1);
            row.destroy();

            if (i == 0 && this.rows.length > 0) {
                this.rows[0].destroyTopSeparator();
            }

            return row;
        } else {
            return null;
        }
    };

    this.addCell = function(rowDivId, userSingleRule) {
        var i = this.indexOfRow(rowDivId);
        if (i > -1) {
            return this.rows[i].addCell(userSingleRule);
        } else {
            return null;
        }
    };

    this.removeCell = function(rowDivId, cellDivId) {
        var i = this.indexOfRow(rowDivId);
        if (i > -1) {
            return this.rows[i].removeCell(cellDivId);
        } else {
            return null;
        }
    };

    this.getCell = function(rowDivId, cellDivId) {
        var i = this.indexOfRow(rowDivId);
        if (i > -1) {
            return this.rows[i].getCell(cellDivId);
        } else {
            return null;
        }
    };

    this.paint = function() {
        if (this.paintDisabled) {
            return;
        }

        this.destroy();
        this.div = dojo.byId(this.divId);

        for ( var i = 0; i < this.rows.length; i++) {
            this.rows[i].paint();
        }
    };

    this.destroy = function() {
        if (this.div) {
            dojo.forEach(dijit.findWidgets(this.div), function(w) {
                w.destroyRecursive(true);
            });
            dojo.destroy(this.divId);
            this.div = null;
        }
    };
}

function Row(rule, rowDivId) {
    this.rule = rule;

    this.divId = rowDivId;
    this.div = null;

    this.topDivId = rowDivId + "-top-separator";
    this.topDiv = null;

    this.addOrDivId = this.divId + "-addOR";
    this.addOrDiv = null;

    this.addAndDivId = this.divId + "-addAND";
    this.addAndDiv = null;

    this.cells = new Array();

    this.getIniText = function() {
        var iniText = "";
        for ( var i = 0; i < this.cells.length; i++) {
            var cellIniText = this.cells[i].getIniText();
            if (cellIniText != "") {
                iniText += cellIniText + "\n";
            }
        }
        if (iniText != "") {
            iniText = "(OR" + "\n" + iniText + ")";
        }
        return iniText;
    };

    this.indexOfCell = function(cellDivId) {
        for ( var i = 0; i < this.cells.length; i++) {
            if (this.cells[i].divId == cellDivId) {
                return i;
            }
        }
        return -1;
    };

    this.addCell = function(userSingleRule) {
        var cellDivId = this.rule.divIdManager.nextCellDivId(this.divId);
        var cell = new Cell(this, cellDivId, userSingleRule);
        this.cells.push(cell);
        cell.paint();
        return cell;
    };

    this.removeCell = function(cellDivId) {
        var i = this.indexOfCell(cellDivId);
        if (i > -1) {
            var cell = this.cells[i];
            this.cells.splice(i, 1);
            cell.destroy();

            if (i == 0 && this.cells.length > 0) {
                this.cells[0].destroyTopSeparator();
            }

            return cell;
        } else {
            return null;
        }
    };

    this.getCell = function(cellDivId) {
        var i = this.indexOfCell(cellDivId);
        if (i > -1) {
            return this.cells[i];
        } else {
            return null;
        }
    };

    this.paint = function() {
        if (this.rule.paintDisabled) {
            return;
        }
        
        var myIndex = this.rule.indexOfRow(this.divId);
        
        if (myIndex == 0) {
            this.div = dojo.create("div", {
                id : this.divId,
                'class' : "segRow"
            }, this.rule.div);
        } else {

            this.topDiv = dojo.create("div", {
                id : this.topDivId,
                'class' : "segRowHeader"
            }, this.rule.rows[myIndex - 1].div, "after");

            var html = ""
                + "<div class='segConnectorLine'>"
                + "</div>"
                + "<div class='segConnector segAndConnector segRound'>"
                + "  <div class='segConnectorLabel'>"
                + '<xlat:stream key="dvin/AT/Segments/CellANDConnector" escape="true" encode="false"/>'
                + "  </div>"
                + "</div>"
                + "<div class='segConnectorLine'>"
                + "</div>";
            
            this.topDiv.innerHTML = html;

            this.div = dojo.create("div", {
                id : this.divId,
                'class' : "segRow"
            }, this.topDiv, "after");
        }

        this.addOrDiv = dojo.create("div", {
            id : this.addOrDivId,
            'class' : "segAdder segCellAdder segRound"
        }, this.div);

        this.addOrDiv.innerHTML = "<a href='javascript:doAddCell(\"" + this.divId + "\")'>"
                + "<img src='js/fw/images/ui/ui/engage/AddOff.png' class='segAdderIcon' border='0'>"
                + "<div class='segAdderLabel'>"
                + '<xlat:stream key="dvin/AT/Segments/CellORAdder" escape="true" encode="false"/>'
                + "</div>"
                + "</a>";

        this.addAndDiv = dojo.create("div", {
            id : this.addAndDivId,
            'class' : "segAdder segRowAdder segRound"
        }, this.div);

        this.addAndDiv.innerHTML = "<a href='javascript:doAddRow(\"" + this.divId + "\")'>"
		        + "<img src='js/fw/images/ui/ui/engage/AddOff.png' class='segAdderIcon' border='0'>"
		        + "<div class='segAdderLabel'>"
		        + '<xlat:stream key="dvin/AT/Segments/CellANDAdder" escape="true" encode="false"/>'
		        + "</div>"
		        + "</a>";

        for ( var i = 0; i < this.cells.length; i++) {
            this.cells[i].paint();
        }
    };

    this.destroy = function() {
    	if (this.div) {
            dojo.forEach(dijit.findWidgets(this.div), function(w) {
                w.destroyRecursive(true);
            });
            dojo.destroy(this.divId);
            this.div = null;
            
            this.destroyTopSeparator();
    	}
    };
    
    this.destroyTopSeparator = function() {
    	if (this.topDiv) {
            dojo.destroy(this.topDivId);
            this.topDiv = null;
    	}
    };
}

function Cell(row, cellDivId, userSingleRule) {
    this.row = row;

    this.divId = cellDivId;
    this.div = null;

    this.topDivId = cellDivId + "-top-separator";
    this.topDiv = null;
    
    this.metakeyWidget;
    this.operatorWidget;
    this.valueWidget;
    this.datePickerWidget;
    this.lastMetaType;
    
    this.userSingleRule = userSingleRule;

    this.getIniText = function() {
        return this.userSingleRule.getIniText();
    };

    this.newOperatorDS = function(type) {
        var operatorDS = {identifier: "name", label: "desc", items: [{name: "", desc: ""}]};
        for (var i = 0; i < mData.ucmOperators.length; i++) {
            var item = { name: mData.ucmOperators[i].name, desc: mData.ucmOperators[i].desc };
            if (type == 'date' || type == 'int') {
            	if (mData.ucmOperators[i].type == type) {
                    operatorDS.items.push(item);
            	}
            } else if (mData.ucmOperators[i].type != 'date' && mData.ucmOperators[i].type != 'int') {
                operatorDS.items.push(item);
            }
        }
        return operatorDS;
    }

    this.createMetakeyCombo = function(bodyDiv) {
        var fieldDiv = dojo.create("div", {
        	id: this.divId + '-w-metakey', 'class' : "segFieldDiv"
        }, bodyDiv);
        
        this.lastMetaType = this.userSingleRule.metatype;
        
        var metakeyStore = {identifier: "name", label: "name", items: [{name: "", type: ""}]};
        for (var i = 0; i < mData.ucmMetakeys.length; i++) {
            metakeyStore.items.push({ name: mData.ucmMetakeys[i].name, type: mData.ucmMetakeys[i].type });
        }
        var dstore = new dojo.data.ItemFileReadStore({data: metakeyStore});

        var cell = this;
        this.metakeyWidget = new fw.dijit.UIFilteringSelect (
                   {   store: dstore, searchAttr: "name", value: this.userSingleRule.metakey,
                	   placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                       onChange: function(newValue) {
                    	    cell.userSingleRule.metakey = this.item.name;
                    	    cell.userSingleRule.metatype = this.item.type;
                    	    
                    	    if (this.item.type == "date") {
                    	    	if (cell.lastMetaType != "date") {
                                    cell.syncWithMetakeyType();
                    	    	}
                    	    } else if (this.item.type == "int") {
                                if (cell.lastMetaType != "int") {
                                    cell.syncWithMetakeyType();
                                }
                    	    } else {
                                if (cell.lastMetaType == "date" || cell.lastMetaType == "int") {
                                    cell.syncWithMetakeyType();
                                }
                    	    }
                       }
                   }).placeAt(fieldDiv);
    };

    this.createOperatorCombo = function(bodyDiv) {
        var fieldDiv = dojo.create("div", {
        	id: this.divId + '-w-operator', 'class' : "segFieldDiv"
        }, bodyDiv);
        
         var datastore = this.newOperatorDS(this.userSingleRule.metatype);
         var dstore = new dojo.data.ItemFileReadStore({data: datastore});
        
        var cell = this;
        this.operatorWidget = new fw.dijit.UIFilteringSelect (
                   {   store: dstore, searchAttr: "desc", value: this.userSingleRule.operator,
                	   placeHolder: '<xlat:stream key="wcc/rule/build/tip/select" escape="true" encode="false"/>',
                       onChange: function(newValue) {
                           cell.userSingleRule.operator = newValue;
                       }
                   }).placeAt(fieldDiv);
    };

    this.createValueText = function(bodyDiv) {
        var fieldDiv = dojo.create("div", {
        	id: this.divId + '-w-value', 'class' : "segFieldDiv"
        }, bodyDiv);
        
        var readonly = this.userSingleRule.metatype == "date";
        
        var cell = this;
        this.valueWidget = new fw.dijit.UIInput (
                {   type: "text", value: cell.userSingleRule.value, readOnly: readonly,
                    placeHolder: '<xlat:stream key="wcc/rule/build/tip/input" escape="true" encode="false"/>',
                    onChange: function(newValue) {
                        cell.userSingleRule.value = dojo.trim(newValue);
                    }
                }).placeAt(fieldDiv);
    };
    
    this.createDatePicker = function(bodyDiv) {
        var fieldDiv = dojo.create("div", {
        	id: this.divId + '-w-datepicker', 'class' : "segFieldDiv calButton"
        }, bodyDiv);
        
        var cell = this;
        this.datePickerWidget = new dijit.form.DropDownButton({
            label: '<img title="<xlat:stream key="fatwire/Alloy/UI/PickADate" escape="true" encode="false"/>" src="js/fw/images/ui/ui/engage/calendarButton.png" border="0"/>',
            dropDown: null,
            onClick: function() {
                if(!this.dropDown) {
                    var _tstampwgt = new fw.ui.dijit.TimestampPicker({
                        onTimeStampSelect: function(timeStamp) {
                            cell.valueWidget.set('value', dojo.date.locale.format(this.timeStamp, {formatLength:'medium'}));
                        },  
                        timeStamp: dojo.date.locale.parse(cell.userSingleRule.value, {formatLength:'medium'}),
                        timePicker: true                        
                    });
                    this.dropDown = _tstampwgt;
                }
                this.openDropDown();
            }
        }, fieldDiv);
        
        if (this.userSingleRule.metatype == "date") {
            this.datePickerWidget.domNode.style.visibility = "visible";
        } else {
            this.datePickerWidget.domNode.style.visibility = "hidden";
        }
    };
    
    this.syncWithMetakeyType = function() {
    	
    	var datastore = this.newOperatorDS(this.userSingleRule.metatype);
        this.operatorWidget.store.clearOnClose = true;
        this.operatorWidget.store.data = datastore;
        this.operatorWidget.store.close();
        this.operatorWidget.set("value", "");

        if (this.userSingleRule.metatype == 'date') {
            this.valueWidget.set("value", dojo.date.locale.format(new Date(new Date().getTime() + tzDiffMillis), {formatLength:'medium'}));
            this.valueWidget.set("readOnly", true);
            
            this.datePickerWidget.domNode.style.visibility = "visible";
        } else {
            this.valueWidget.set("value", "");
            this.valueWidget.set("readOnly", false);
            
            this.datePickerWidget.domNode.style.visibility = "hidden";
        }
        
        this.lastMetaType = this.userSingleRule.metatype;
    };

    this.paint = function() {
        if (this.row.rule.paintDisabled) {
            return;
        }
        
        if (this.row.indexOfCell(this.divId) > 0) {
            this.topDiv = dojo.create("div", {
                id : this.topDivId,
                'class' : "segCellHeader"
            }, this.row.addOrDiv, "before");
            
            var html = ""
                + "<div class='segConnectorLine'>"
                + "</div>"
                + "<div class='segConnector segOrConnector segRound'>"
                + "  <div class='segConnectorLabel'>"
                + '<xlat:stream key="dvin/AT/Segments/CellORConnector" escape="true" encode="false"/>'
                + "  </div>"
                + "</div>"
                + "<div class='segConnectorLine'>"
                + "</div>";
            
            this.topDiv.innerHTML = html;
        }

        this.div = dojo.create("div", {
            id : this.divId,
            'class' : "segCell"
        }, this.row.addOrDiv, "before");
        
        var bodyDiv = dojo.create("div", {
            'class' : "segCellBody clearfix segRound"
        }, this.div);

        this.createMetakeyCombo(bodyDiv);
        this.createOperatorCombo(bodyDiv);
        this.createValueText(bodyDiv);
        this.createDatePicker(bodyDiv);

        var removeDiv = dojo.create("div", {
            'class' : "segRemove clearfix"
        }, bodyDiv);

        var aTag = dojo.create("a", {
            href : "javascript:doRemoveCell('" + this.row.divId + "','" + this.divId + "')"
        }, removeDiv);

        var imgTag = dojo.create("img", {
        	'class' : "segRemoveImage",
            src : "js/fw/images/ui/ui/engage/DeleteOff.png",
            title : '<xlat:stream key="dvin/Common/Delete" escape="true" encode="false"/>',
            border : "0",
            hspace : "2"
        }, aTag);
    };

    this.destroy = function() {
    	if (this.div) {
            dojo.forEach(dijit.findWidgets(this.div), function(w) {
                w.destroyRecursive(true);
            });
            dojo.destroy(this.divId);
            this.div = null;
            
            this.destroyTopSeparator();
    	}
    };
    
    this.destroyTopSeparator = function() {
    	if (this.topDiv) {
            dojo.destroy(this.topDivId);
            this.topDiv = null;
    	}
    };
}

function UserSingleRule(metakey, metatype, operator, value) {
    this.metakey = metakey;
    this.metatype = metatype;
    this.operator = operator;
    this.value = value;
    
    if (this.metatype == 'date') {
    	var userTzDate = dojo.date.locale.parse(this.value, {selector: "date", datePattern: "<%=Constants.NoTimeZoneDatePattern%>"});
    	this.value = dojo.date.locale.format(userTzDate, {formatLength:'medium'});
    }

    this.getIniText = function() {
        if (this.metakey == "" || this.operator == "" || this.value == "") {
            return "";
        } else {
        	var iniValue = this.value;
        	if (this.metatype == 'date') {
        		var userTzDate = dojo.date.locale.parse(this.value, {formatLength:'medium'});
        		var userTzDateStr = dojo.date.locale.format(userTzDate, {selector: "date", datePattern: "<%=Constants.NoTimeZoneDatePattern%>"});
        		iniValue = "@UserProfileTimeZone@" + userTzDateStr;
        	}
            return "(" + this.metakey + ";" + this.operator + ";" + iniValue + ")";
        }
    };
}

function DivIdManager() {
    this.rowNextIndex = 0;
    this.cellNextIndex = 0;

    this.nextRowDivId = function(ruleDivId) {
        return ruleDivId + "-" + this.rowNextIndex++;
    };

    this.nextCellDivId = function(rowDivId) {
        return rowDivId + "-" + this.cellNextIndex++;
    };
}

// global functions for UI changes
function doAddRow(afterThisRowDivId) {
    inputedRule.addRow(afterThisRowDivId).addCell(new UserSingleRule("","","",""));
}

function doAddCell(rowDivId) {
    inputedRule.addCell(rowDivId, new UserSingleRule("","","",""));
}

function doRemoveRow(rowDivId) {
    inputedRule.removeRow(rowDivId);
    if (inputedRule.rows.length == 0) {
        doAddRow();
    }
}

function doRemoveCell(rowDivId, cellDivId) {
    var rowIndex = inputedRule.indexOfRow(rowDivId);
    var row = inputedRule.rows[rowIndex];
    row.removeCell(cellDivId);
    if (row.cells.length == 0) {
        doRemoveRow(rowDivId);
    }
}
</script>
</cs:ftcs>