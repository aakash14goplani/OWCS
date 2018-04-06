<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ page import="oracle.stellent.ucm.poller.Constants"%>
<cs:ftcs>
    <script type="text/javascript">

        function MemoryData() {
            this.isNewRule = true;
            this.existRules = new Array(); // string
            this.inputedRuleEnabled = false;
            this.inputedRuleName = "";
            this.inputedRuleDesc = "";
            this.inputedTypeC = "";
            this.inputedSubtype = "";

            this.ucmMetakeys = new Array(); // UcmMetakey
            this.ucmRenditionNames = new Array(); // string
            this.ucmConversionNames = new Array(); // string
            this.ucmConversionDescs = new Array(); // string
            this.ucmOperators = new Array(); // UserOp

            this.fwKeyField = "";

            this.fwAssets = new Array(); // FwAsset
            
            this.indexOfAsset = function (typeC) {
                for (var i = 0; i < this.fwAssets.length; i++) {
                    if (this.fwAssets[i].typeC == typeC) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getAsset = function (typeC) {
                var index = this.indexOfAsset(typeC);
                if (index == -1){
                    return null;
                }
                return this.fwAssets[index];
            };
            
            this.getSubtype = function (typeC, subtype) {
                var fwAsset = this.getAsset(typeC);
                if (fwAsset == null) {
                    return null;
                }
                return fwAsset.getSubtype(subtype);
            };
            
            this.getParentGroup = function (typeC, subtype, parentGroupName) {
                var fwSubtype = this.getSubtype(typeC, subtype);
                if (fwSubtype == null) {
                    return null;
                }
                return fwSubtype.getParentGroup(parentGroupName);
            };
            
            this.getParent = function (typeC, subtype, parentGroupName, parentName) {
                var fwParentGroup = this.getParentGroup(typeC, subtype, parentGroupName);
                if (fwParentGroup == null) {
                    return null;
                }
                return fwParentGroup.getParent(parentName);
            };
            
            this.getField = function (typeC, subtype, fieldName) {
                var fwSubtype = this.getSubtype(typeC, subtype);
                if (fwSubtype == null) {
                    return null;
                }
                return fwSubtype.getField(fieldName);
            };
        }

        function FwAsset(typeC, typeCD, typeP, typePD, typeA) {
            this.typeC = typeC;
            this.typeCD = typeCD;
            this.typeP = typeP;
            this.typePD = typePD;
            this.typeA = typeA;

            this.fwSubtypes = new Array(); // FwSubtype
            
            this.indexOfSubtype = function (subtype) {
                for (var i = 0; i < this.fwSubtypes.length; i++) {
                    if (this.fwSubtypes[i].subtype == subtype) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getSubtype = function (subtype) {
                var index = this.indexOfSubtype(subtype);
                if(index == -1) {
                    return null;
                }
                return this.fwSubtypes[index];
            };
            
            this.getField = function (subtype, fieldName) {
                var fwSubtype = this.getSubtype(subtype);
                if(fwSubtype == null) {
                    return null;
                }
                return fwSubtype.getField(fieldName);
            };
        }

        function FwSubtype(subtype) {
            this.subtype = subtype;
            
            this.fwSites = new Array(); // FwSite

            this.fwParentGroups = new Array(); // FwParentGroup

            this.fwFields = new Array(); // FwField
            
            this.indexOfSite = function (siteName) {
                for (var i = 0; i < this.fwSites.length; i++) {
                    if (this.fwSites[i].name == siteName) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getSite = function (siteName) {
                var index = this.indexOfSite(siteName);
                if (index == -1) {
                    return null;
                }
                return this.fwSites[index];
            };
            
            this.getSelectedSites = function () {
                var sites = new Array();
                for (var i = 0; i < this.fwSites.length; i++) {
                    var fwSite = this.fwSites[i];
                    if (fwSite.inputedCheck) {
                        sites.push(fwSite);
                    }
                }
                return sites;
            };

            this.indexOfParentGroup = function (parentGroupName) {
                for (var i = 0; i < this.fwParentGroups.length; i++) {
                    if (this.fwParentGroups[i].name == parentGroupName) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getParentGroup = function (parentGroupName) {
                var index = this.indexOfParentGroup(parentGroupName);
                if (index == -1) {
                    return null;
                }
                return this.fwParentGroups[index];
            };
            
            this.indexOfField = function (fieldName) {
                for (var i = 0; i < this.fwFields.length; i++) {
                    if (this.fwFields[i].name == fieldName) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getField = function (fieldName) {
                var index = this.indexOfField(fieldName);
                if (index == -1) {
                    return null;
                }
                return this.fwFields[index];
            };
        }

        function FwSite(name, check) {
            this.name = name;
            
            this.inputedCheck = check; // true/false
        }

        function FwField(name, type, isRequired, isList, fieldType, fieldValue) {
            this.name = name;
            this.type = type;
            this.isRequired = isRequired;
            this.isList = isList;

            this.inputedType = fieldType;
            this.inputedValue = fieldValue;

            if (this.type == 'date' && this.inputedType == "<%=Constants.TypeLiteral%>" && this.inputedValue) {
                var userTzDate = dojo.date.locale.parse(this.inputedValue, {selector: "date", datePattern: "<%=Constants.NoTimeZoneDatePattern%>"});
                this.inputedValue = dojo.date.locale.format(userTzDate, {formatLength:'medium'});
            }
        }

        function FwParentGroup(name, isRequired, isSingleSelection) {
            this.name = name;
            this.isRequired = isRequired;
            this.isSingleSelection = isSingleSelection;
            
            this.fwParents = new Array(); // FwParent
            
            this.selectSingleParent = function (parentName) {
                for (var i = 0; i < this.fwParents.length; i++) {
                    var fwParent = this.fwParents[i];
                    fwParent.inputedCheck = (fwParent.name == parentName);
                }
            };
            
            this.getSelectedParents = function () {
                var parents = new Array();
                for (var i = 0; i < this.fwParents.length; i++) {
                    var fwParent = this.fwParents[i];
                    if (fwParent.inputedCheck) {
                        parents.push(fwParent);
                    }
                }
                return parents;
            };
            
            this.indexOfParent = function (parentName) {
                for (var i = 0; i < this.fwParents.length; i++) {
                    if (this.fwParents[i].name == parentName) {
                        return i;
                    }
                }
                return -1;
            };
            
            this.getParent = function (parentName) {
                var index = this.indexOfParent(parentName);
                if (index == -1) {
                    return null;
                }
                return this.fwParents[index];
            };
        }
        
        function FwParent (name, check) {
            this.name = name;
            
            this.inputedCheck = check; // true/false
        }
        
        function UserOp(name, type, desc) {
            this.name = name;
            this.type = type;
            this.desc = desc;
        }
        
        function UcmMetakey(name, type) {
        	this.name = name;
        	this.type = type;
        }
    </script>
</cs:ftcs>
