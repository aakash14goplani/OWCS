<%@ page import="COM.FutureTense.Interfaces.IList,
				 com.openmarket.basic.interfaces.AssetException,
				 com.openmarket.xcelerate.interfaces.*,
				 java.util.Hashtable,
                 java.util.Map,
                 java.util.Iterator"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="hash" uri="futuretense_cs/hash.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%!
	private static String[] FIELDS = {"name", "description"};
	private static Hashtable getDefaultDMFields() {
		Hashtable enabledFields = new Hashtable();
		for (int i = 0; i < FIELDS.length; i++) {
			String field = FIELDS[i];
			enabledFields.put(field, field);
		}
		return enabledFields;
	}
	private static boolean isEnabled(IExternalClientsConfigManager man,
			String clientID, String subType, String property) throws AssetException {
		IExternalClientsConfigItem item = man.loadFromFields(clientID, subType, property, "enable");
		return item != null && Boolean.valueOf(item.getValue()).booleanValue();
	}
%><%//
// OpenMarket/Gator/FlexibleAssets/FormMode/DMEnabled
//
// INPUT
//
// OUTPUT
//%><cs:ftcs><%
	/*
	Load the externalclients entry corresponding to clientid.
	Get the list of assettype columns & attributes values from
	externalclients config table
	*/
    String formMode = ics.GetVar("cs_formmode");
    if ("DM".equals(formMode)) {
        String pubId = ics.GetSSVar("pubid");
        String assetType = ics.GetVar("AssetType");

        IExternalClientsManager iExternalClientsManager = ExternalClientsManagerFactory.make(ics);
        IExternalClientsItem iExternalClientsItem = iExternalClientsManager.loadFromFields(pubId, "CSDocLink", assetType);
        if (iExternalClientsItem != null) {
            String clientID = iExternalClientsItem.getId();

            String subType = ics.GetVar("TypeName");
            if (subType == null) {
                subType = ics.GetVar("empty");
            }
            %>
            <assettype:load name="at" field="assettype" value="<%=assetType%>" />
            <%
            if (ics.GetErrno() != 0) {
                ics.SetVar("assettype", ics.GetVar("aType"));
                %><xlat:stream key="dvin/UI/Admin/NoDataavailableforassettype"/><%
                throw new Exception();
            }
            %>
            <assettype:get name="at" field="description" output="at:description"/>
            <!-- get a list of attributes for this asset subtype  -->
            <asset:def list="aTypeDef" type="<%=assetType%>" subtype="<%=subType%>" pubid="<%=pubId%>" />
            <%
            IList aTypeDef = ics.GetList("aTypeDef");

            if (aTypeDef == null) {
                %><xlat:stream key="dvin/UI/Admin/NoDataavailable"/><%
                throw new Exception();
            }
            IExternalClientsConfigManager iExternalClientsConfigManager = ExternalClientsConfigManagerFactory.make(ics);
            IList verifyList = iExternalClientsConfigManager.getItemList(clientID, subType, null, null);
            if (verifyList.numRows() == 0) {
                // if no existing config data, add default data
                for (int i = 1; i <= aTypeDef.numRows(); i++) {
                    aTypeDef.moveTo(i);
                    if ("true".equalsIgnoreCase(aTypeDef.getValue("editable"))) {
                        String name = aTypeDef.getValue("name");
                        String value = "Name".equalsIgnoreCase(name) ? "true" : "";
                        ics.SetVar("attribVal", value);
                        IExternalClientsConfigItem iExternalClientsConfigItem;
                        iExternalClientsConfigItem = iExternalClientsConfigManager.create();
                        iExternalClientsConfigItem.setProperty(name);
                        iExternalClientsConfigItem.setClientId(clientID);
                        iExternalClientsConfigItem.setSubType(subType);
                        iExternalClientsConfigItem.setAction("enable");
                        iExternalClientsConfigItem.setValue(value);
                        iExternalClientsConfigManager.save(iExternalClientsConfigItem);

                        iExternalClientsConfigItem = iExternalClientsConfigManager.create();
                        iExternalClientsConfigItem.setProperty(name);
                        iExternalClientsConfigItem.setClientId(clientID);
                        iExternalClientsConfigItem.setSubType(subType);
                        iExternalClientsConfigItem.setAction("acceptdocs");
                        iExternalClientsConfigItem.setValue("No");
                        iExternalClientsConfigManager.save(iExternalClientsConfigItem);

                        iExternalClientsConfigItem = iExternalClientsConfigManager.create();
                        iExternalClientsConfigItem.setProperty(name);
                        iExternalClientsConfigItem.setClientId(clientID);
                        iExternalClientsConfigItem.setSubType(subType);
                        iExternalClientsConfigItem.setAction("maxfilesize");
                        iExternalClientsConfigItem.setValue("No");
                        iExternalClientsConfigManager.save(iExternalClientsConfigItem);
                    }
                }
                //reload the new status
                verifyList = iExternalClientsConfigManager.getItemList(clientID, subType, null, null);
            } else {
                /*
                check if the existing config data is still valid.
                ways it might have broken include
                    * deletion of the subtype,
                    * removal or fields in the subtype, and
                    * renamed fields in the subtype
                */
                Hashtable hSubtypeFields = new Hashtable();
                for (int i = 1; i <= aTypeDef.numRows(); i++) {
                    aTypeDef.moveTo(i);
                    String name = aTypeDef.getValue("name");
                    hSubtypeFields.put(name, name);
                }

                IExternalClientsConfigItem item;
                for (int i = 1; i <= verifyList.numRows(); i++) {
                    verifyList.moveTo(i);
                    String property = verifyList.getValue("property");
                    if (!hSubtypeFields.containsKey(property)) {
                        item = iExternalClientsConfigManager.loadFromFields(clientID, subType, property, "enable");
                        if (item != null)
                            iExternalClientsConfigManager.delete(item.getId());
                        item = iExternalClientsConfigManager.loadFromFields(clientID, subType, property, "acceptdocs");
                        if (item != null)
                            iExternalClientsConfigManager.delete(item.getId());
                        item = iExternalClientsConfigManager.loadFromFields(clientID, subType, property, "maxfilesize");
                        if (item != null)
                            iExternalClientsConfigManager.delete(item.getId());
                    }
                }
            }

            %><hash:create name="enabledFields"/><%
            %><hash:create name="enabledParents"/><%
            %><hash:create name="enabledAttributes"/><%
            //Loop over all search results
            aTypeDef.moveTo(1);
            for (int i = 1; i <= aTypeDef.numRows(); i++) {
                aTypeDef.moveTo(i);
                if ("true".equalsIgnoreCase(aTypeDef.getValue("editable"))) {
                    String property = aTypeDef.getValue("name");
                    if ("Name".equalsIgnoreCase(property) ||
                        isEnabled(iExternalClientsConfigManager, clientID, subType, property)) {
                        if (property.startsWith("Group_")) {
                            final int l = "Group_".length();
                            %><hash:add name="enabledParents" value='<%=property.substring(l)%>'/><%
                        } else if (property.startsWith("Attribute_")) {
                            final int l = "Attribute_".length();
                            %><hash:add name="enabledAttributes" value='<%=property.substring(l)%>'/><%
                        } else {
                            %><hash:add name="enabledFields" value='<%=property%>'/><%
                        }
                    }
                }
            }
        } else {
			//DM is not enabled for this asset type.
			ics.SetObj("enabledFields", getDefaultDMFields());
		}
    }
%></cs:ftcs>