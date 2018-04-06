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
                   com.fatwire.assetapi.def.*,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   com.fatwire.system.SessionFactory,
                   com.fatwire.assetapi.query.*,
                   oracle.wcs.assetdef.*,
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
AssetType assetType = (AssetType) ics.GetObj ("wcc.populateAssetType");

HashMap<AssetId, AssetData> aTypeMap = new HashMap<AssetId, AssetData>();
HashMap<AssetId, AssetData> pdTypeMap = new HashMap<AssetId, AssetData>();
LinkedList<AssetData> pTypeList = new LinkedList<AssetData>();

AssetDataManager assetDataManager = (AssetDataManager) SessionFactory.getSession().getManager(AssetDataManager.class.getName());
AssetTypeDefManager assetTypeManager = (AssetTypeDefManager) SessionFactory.getSession().getManager(AssetTypeDefManager.class.getName());

// retrieve all type_A records
SimpleQuery query = new SimpleQuery(assetType.getTypeA(), null, null, Arrays.asList("name", "description", "valuestyle", "type"));
query.getProperties().setIsBasicSearch(true);

for (AssetData item : assetDataManager.read(query)) {
    aTypeMap.put(item.getAssetId(), item);
}

// retrieve all type_P records
query = new SimpleQuery(assetType.getTypeP(), null, null, Arrays.asList("name", "flexgrouptemplateid"));
query.getProperties().setIsBasicSearch(true);

for (AssetData item : assetDataManager.read(query)) {
    pTypeList.add(item);
}

// retrieve all type_PD records
query = new SimpleQuery(assetType.getTypePD(), null, null, Arrays.asList("name", "description"));
query.getProperties().setIsBasicSearch(true);

for (AssetData item : assetDataManager.read(query)) {
    pdTypeMap.put(item.getAssetId(), item);
}

// retrieve all attributes and parents
query = new SimpleQuery(assetType.getTypeCD(), null, null, Arrays.asList("name", "Publist", "Groups", "Attributes"));
query.getProperties().setIsBasicSearch(true);

for (AssetData subtypeAsset : assetDataManager.read(query)) {

	String subtype = subtypeAsset.getAttributeData("name").getData().toString();
	AssetSubtype assetSubtype = assetType.getSubtypeMap().get(subtype);
	
    if (assetSubtype == null) {
        continue;
    }

    assetSubtype.setFieldDefMap(new HashMap<String, FieldDef>());
    assetSubtype.setParentDefList(new ArrayList<ParentFieldDef>());
    
    assetSubtype.setSiteList((List<String>)subtypeAsset.getAttributeData("Publist").getData());

    // parent fields
    for (Map<String, AttributeData> member : (List<Map<String, AttributeData>>)subtypeAsset.getAttributeData("Groups").getData()) {
        
        AssetData groupDefAsset = pdTypeMap.get((AssetId)member.get("assetid").getData());

        ParentFieldDef parentFieldDef = new ParentFieldDef();

        String name = groupDefAsset.getAttributeData("name").getData().toString();
        parentFieldDef.setName(name);
        parentFieldDef.setLabel(name);
        parentFieldDef.setRequired(member.get("required").getData().equals("true"));
        parentFieldDef.setList(member.get("multiple").getData().equals("true"));
        parentFieldDef.setType(AttributeTypeEnum.ASSET);
        parentFieldDef.setParentDef(groupDefAsset);
        
        for (AssetData parentAsset : pTypeList) {
            if (groupDefAsset.getAssetId().equals((AssetId)parentAsset.getAttributeData("flexgrouptemplateid").getData())) {
                parentFieldDef.getParentMap().put(parentAsset.getAttributeData("name").getData().toString(), parentAsset);
            }
        }

        assetSubtype.getParentDefList().add(parentFieldDef);
    }

    // user defined regular fields excluding default fields like name, description, etc.
    for (Map<String, AttributeData> member : (List<Map<String, AttributeData>>)subtypeAsset.getAttributeData("Attributes").getData()) {
        
        AssetData attrAsset = aTypeMap.get((AssetId)member.get("assetid").getData());
        
        FieldDef fieldDef = new FieldDef();
        
        fieldDef.setRequired(member.get("required").getData().equals("true"));
        fieldDef.setOrdinal((Integer)member.get("ordinal").getData());
        fieldDef.setName(attrAsset.getAttributeData("name").getData().toString());
        fieldDef.setLabel(attrAsset.getAttributeData("description").getData().toString());
        String valuestyle = attrAsset.getAttributeData("valuestyle").getData().toString();
        fieldDef.setList(valuestyle.equals("M") || valuestyle.equals("O"));
        fieldDef.setType(AttributeTypeEnum.fromValue(attrAsset.getAttributeData("type").getData().toString().toLowerCase()));
        
        assetSubtype.getFieldDefMap().put(fieldDef.getName(), fieldDef);
    }

    // add the "name" field
    FieldDef hardcode = new FieldDef();

    hardcode.setRequired(true);
    hardcode.setOrdinal(-9999);
    hardcode.setName("name");
    hardcode.setLabel("name");
    hardcode.setList(false);
    hardcode.setType(AttributeTypeEnum.STRING);

    assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);

    //add the "description" field
    hardcode = new FieldDef();

    hardcode.setRequired(false);
    hardcode.setOrdinal(-9998);
    hardcode.setName("description");
    hardcode.setLabel("description");
    hardcode.setList(false);
    hardcode.setType(AttributeTypeEnum.STRING);

    assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);

    //add the "fwtags" field
    hardcode = new FieldDef();

    hardcode.setRequired(false);
    hardcode.setOrdinal(-9997);
    hardcode.setName("fwtags");
    hardcode.setLabel("fwtags");
    hardcode.setList(true);
    hardcode.setType(AttributeTypeEnum.STRING);

    assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);

    //add the "template" field
    hardcode = new FieldDef();

    hardcode.setRequired(false);
    hardcode.setOrdinal(-9996);
    hardcode.setName("template");
    hardcode.setLabel("template");
    hardcode.setList(false);
    hardcode.setType(AttributeTypeEnum.STRING);

    assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);

    if (!"disabled".equalsIgnoreCase(ics.GetProperty("cs.sitepreview"))) {
        //add the "startdate" field
        hardcode = new FieldDef();

        hardcode.setRequired(false);
        hardcode.setOrdinal(9998);
        hardcode.setName("startdate");
        hardcode.setLabel("startdate");
        hardcode.setList(false);
        hardcode.setType(AttributeTypeEnum.DATE);

        assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);

        //add the "enddate" field
        hardcode = new FieldDef();

        hardcode.setRequired(false);
        hardcode.setOrdinal(9999);
        hardcode.setName("enddate");
        hardcode.setLabel("enddate");
        hardcode.setList(false);
        hardcode.setType(AttributeTypeEnum.DATE);

        assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);
    }
    
    // find out asset associations
    AssetTypeDef assetTypeDef = assetTypeManager.findByName(assetType.getTypeC(), subtype);
    if (assetTypeDef != null) {
        List<AssetAssociationDef> assetAssoDefList =  assetTypeDef.getAssociations();
        if (assetAssoDefList != null) {
            int ordinal = 9000;
            for (AssetAssociationDef assoDef : assetAssoDefList) {
                hardcode = new FieldDef();

                hardcode.setRequired(false);
                hardcode.setOrdinal(ordinal++);
                hardcode.setName(assoDef.getName());
                hardcode.setLabel(assoDef.getName());
                hardcode.setList(assoDef.isMultiple());
                hardcode.setType(AttributeTypeEnum.ASSETREFERENCE);

                assetSubtype.getFieldDefMap().put(hardcode.getName(), hardcode);
            }
        }
    }
}
%>
</cs:ftcs>
