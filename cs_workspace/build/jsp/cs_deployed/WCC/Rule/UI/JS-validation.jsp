<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="oracle.stellent.ucm.poller.*,
                   oracle.wcs.util.WcsLocale"
%><cs:ftcs>
<script type="text/javascript">
function xssCharFound(value) {
	if (typeof value == "string") {
        for (var i = 0; i < value.length; i++) {
            var ch = value.charAt(i);
            if (ch == "'" || ch == '"' || ch == "<" || ch == ">") {
                return true;
            }
        }
    }
    return false;
}

function basicValidation () {
	if (mData.isNewRule) {
	    if (mData.inputedRuleName == "") {
	        alert('<xlat:stream key="wcc/rule/validation/missrulename" escape="true" encode="false"/>');
	        return false;
	    }
	    
	    for (var i = 0; i < mData.inputedRuleName.length; i++) {
	    	var code = mData.inputedRuleName.charCodeAt(i);
	    	if ( (code >= 192)                    // ISO 8859-1 Latin and unicodes
	    	     || (code == 45)                  // hyphen (-)
	    	     || (code >= 48 && code <= 57)    // 0-9
                 || (code >= 65 && code <= 90)    // A-Z
                 || (code >= 97 && code <= 122)   // a-z
	    	) {
	    		// continue;
	    	} else {
	    		alert('<xlat:stream key="wcc/rule/validation/invalidrulename" escape="true" encode="false"/>');
	    		return false;
	    	}
	    }
		
	    if (dojo.indexOf(mData.existRules, mData.inputedRuleName) > -1) {
            alert('<xlat:stream key="wcc/rule/validation/unqiuerulename" escape="true" encode="false"/>');
	        return false;
	    }
	}
    
    if (mData.inputedRuleDesc == "") {
        alert('<xlat:stream key="wcc/rule/validation/nonnulldesc" escape="true" encode="false"/>');
        return false;
    }
    
    if (xssCharFound(mData.inputedRuleDesc)) {
        var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
        var field = '<xlat:stream key="dvin/Common/Description" escape="true" encode="false"/>';
        alert(msg.replace("{0}", field));
        return false;
    }
    
    if (mData.inputedTypeC == "") {
        alert('<xlat:stream key="wcc/rule/validation/missassettype" escape="true" encode="false"/>');
        return false;
    }
    
    if (mData.inputedSubtype == "") {
        alert('<xlat:stream key="wcc/rule/validation/missassetsubtype" escape="true" encode="false"/>');
        return false;
    }
    
    for (var i = 0; i < inputedRule.rows.length; i++) {
    	var row = inputedRule.rows[i];
    	for (var j = 0; j < row.cells.length; j++) {
    		var cell = row.cells[j];
    	    if (xssCharFound(cell.userSingleRule.value)) {
    	        var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
    	        var field = '<xlat:stream key="wcc/menu/rules" escape="true" encode="false"/>';
    	        alert(msg.replace("{0}", field));
    	        return false;
    	    }
    	}
    }
    
    var fwSubtype = mData.getSubtype(mData.inputedTypeC, mData.inputedSubtype);
    
    if (!fwSubtype) {
        alert('<xlat:stream key="wcc/rule/validation/invalidassetsubtype"/>');
        return false;
    }
    
    if (fwSubtype.getSelectedSites().length == 0) {
        alert('<xlat:stream key="wcc/rule/validation/misssite" escape="true" encode="false"/>');
        return false;
    }
    
    for (var i = 0; i < fwSubtype.fwParentGroups.length; i++) {
        var fwParentGroup = fwSubtype.fwParentGroups[i];
        if (fwParentGroup.isRequired) {
            if (fwParentGroup.getSelectedParents().length == 0) {
                alert('<xlat:stream key="wcc/rule/validation/missparent" escape="true" encode="false"/>'.replace('{0}', fwParentGroup.name));
                return false;
            }
        }
    }
    
    for (var i = 0; i < fwSubtype.fwFields.length; i++) {
        var fwField = fwSubtype.fwFields[i];
        
        if (fwField.name == mData.fwKeyField) {
        	continue;
        }
        
        if (fwField.isRequired) {
        	if (fwField.inputedType == "" || fwField.inputedValue == "") {
                alert('<xlat:stream key="wcc/rule/validation/missfield" escape="true" encode="false"/>'.replace('{0}', fwField.name));
                return false;
        	}
        }
        
        if (fwField.inputedType == "<%=Constants.TypeLiteral%>" && fwField.inputedValue) {
            if (xssCharFound(fwField.inputedValue)) {
                var msg = '<xlat:stream key="wcc/config/validation/xsschars" escape="true" encode="false"/>';
                var field = '<xlat:stream key="wcc/rule/col/attribute" escape="true" encode="false"/>';
                alert(msg.replace("{0}", field));
                return false;
            }
        	
        	if (fwField.type == "int" || fwField.type == "float" || fwField.type == "long" || fwField.type == "money") {
        		if (isNaN(fwField.inputedValue)) {
                    alert('<xlat:stream key="wcc/rule/validation/missnumberfield" escape="true" encode="false"/>'.replace('{0}', fwField.name));
                    return false;
        		}
        	}
        }
    }
    
    return true;
}
</script>
</cs:ftcs>
