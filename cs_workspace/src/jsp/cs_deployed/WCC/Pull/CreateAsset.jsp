<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>

<%@ page import="oracle.stellent.ucm.poller.*" %>
<%@ page import="oracle.stellent.ucm.poller.record.*" %>
<%@ page import="oracle.wcs.assetdef.*" %>
<%@ page import="oracle.wcs.mapping.*" %>
<%@ page import="oracle.wcs.matching.GroupMatcher"%>
<%@ page import="oracle.wcs.util.WorkTimePerDoc" %>
<%@ page import="com.fatwire.assetapi.data.*" %>
<%@ page import="com.fatwire.assetapi.def.AttributeTypeEnum" %>
<%@ page import="com.fatwire.assetapi.query.*" %>
<%@ page import="com.fatwire.search.util.LogPropertyDescriptions" %>
<%@ page import="com.fatwire.system.SessionFactory" %>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl" %>
<%@ page import="org.apache.commons.logging.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<%!
private AssetId firstAssetByDocName (AssetDataManager assetManager, String dDocNameField, String dDocName,
                                            String typeC, String typeCDInstance) throws Exception { 

    Condition nameCondition = ConditionFactory.createCondition (dDocNameField, OpTypeEnum.EQUALS, dDocName);

    SimpleQuery nameQuery = new SimpleQuery (typeC, typeCDInstance, nameCondition, Arrays.asList (dDocNameField));
    nameQuery.getProperties ().setIsBasicSearch (true);

    for (AssetData asset : assetManager.read (nameQuery)) {
        return asset.getAssetId ();
    }

    return null;
}

private String formatStringList (List<String> list) {
    String result = "";
    if (list != null) {
        for (String item : list) {
            result += String.format ("%s,", item);
        }
        result = result.substring (0,result.length ()-1);
    }

    return result;
}

private AssetId parseAssetId (String assetIdStr) {
    int pos = assetIdStr.indexOf(':');
    if (pos == -1) {
        return null;
    }
    String type = assetIdStr.substring(0, pos);
    String id = assetIdStr.substring(pos + 1);
    return new AssetIdImpl(type, Long.parseLong(id));
}
%>


<cs:ftcs>
<%--
INPUT
OUTPUT
--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
    Log wccLog = (Log)ics.GetObj("wccLog");
    if (wccLog == null) {
        wccLog = LogFactory.getLog (LogPropertyDescriptions.LOG_NAME);
    }

    try {
SimpleDateFormat serverTzDateFormat = new SimpleDateFormat (Constants.TimeZoneDatePattern);

boolean errorFound = false;

ics.CallElement("WCC/Util/LoadIntegrationIni", null);
FileBasedProps wccProps = (FileBasedProps) ics.GetObj ("wcc.integration.ini");

String dDocNameField = wccProps.getProperty (Constants.KeyField);

WccBatchRecord batchRec = (WccBatchRecord)ics.GetObj ("wcc.batchRecord");
WccPollerRecord pollerRec = (WccPollerRecord) ics.GetObj ("wcc.pollerRecord");
String dDocName = batchRec.getDDocName ();

WccAsset wccAsset = (WccAsset)ics.GetObj ("wcc.wccAsset");
WorkTimePerDoc docTime = (WorkTimePerDoc)ics.GetObj ("wcc.docTime");

String ruleName = ics.GetVar ("wcc.currentRuleName");
Map<String, GroupMatcher> groupMatcherMap = (Map<String, GroupMatcher>)ics.GetObj ("wcc.groupMatcherMap");
GroupMapper groupMapper = groupMatcherMap.get (ruleName).getGroupMapper ();

ArrayList<String> siteList = new ArrayList<String> ();

AssetId previousAssetId = null;
AssetDataImpl asset = null;

docTime.assetTime.start();
AssetDataManager assetManager = (AssetDataManager)SessionFactory.getSession ().getManager (AssetDataManager.class.getName ());
previousAssetId = firstAssetByDocName (assetManager, dDocNameField, dDocName, groupMapper.getTypeC (), groupMapper.getTypeCDinstance ());

if (previousAssetId == null) {
    docTime.setAction("insert");
    asset = (AssetDataImpl)assetManager.newAssetData (groupMapper.getTypeC (), groupMapper.getTypeCDinstance ());
    asset.getAttributeData (dDocNameField).setData (dDocName);
} else {
    docTime.setAction("update");
    asset = (AssetDataImpl)assetManager.read (Arrays.<AssetId>asList (previousAssetId)).iterator ().next ();
}
docTime.assetTime.stop();

asset.getAttributeData ("Publist").setData (siteList);
asset.getAttributeData ("subtype").setData (groupMapper.getTypeCDinstance ());

for (SingleMapper singleMapper : groupMapper.getSingleMapperMap ().values ()) {
    String fieldName = "";
    FieldDef fieldDef = null;

    try {
        fieldName = singleMapper.getFieldName ();
        WccAssetGetter wccAssetGetter = singleMapper.getWccAssetGetter ();
        if (!wccAssetGetter.valueFound (wccAsset)) {
            continue;
        }

        if (fieldName.equals ("sites")) {
            if (wccAssetGetter.isString ()) {
                siteList.addAll (wccAssetGetter.getStringList ());
                asset.getAttributeData ("Publist").setData (siteList);
            }
            continue;
        }

        if (fieldName.equals ("parents")) {
            if (wccAssetGetter.isString ()) {
                ArrayList<AssetId> parentIdList = new ArrayList<AssetId> ();
                for (String parentName : wccAssetGetter.getStringList ()) {
                    for (ParentFieldDef parentDef : groupMapper.getAssetSubtype().getParentDefList ()) {
                        for (AssetData parentData : parentDef.getParentMap ().values ()) {
                            if (parentName.equals (parentData.getAttributeData ("name").getData ())) {
                                parentIdList.add (parentData.getAssetId ());
                            }
                        }
                    }
                }
                asset.setParents (parentIdList);
            }
            continue;
        }

        fieldDef = groupMapper.getAssetSubtype().getFieldDefMap ().get (fieldName);
        if (fieldDef == null) {
            continue;
        }
        
        AttributeData attrData = asset.getAttributeData (fieldName);

        if (fieldDef.getType () == AttributeTypeEnum.BLOB) {
            if (wccAssetGetter.isFile ()) {
                if (fieldDef.isList()) {
                    ArrayList<BlobObjectImpl> blobList = new ArrayList<BlobObjectImpl> ();
                    for (MemoryFile memFile : wccAssetGetter.getFileList ()) {
                        blobList.add (new BlobObjectImpl (memFile.getName (), memFile.getPath (), memFile.getBytes ()));
                    }
                    attrData.setDataAsList (blobList);
                } else {
                    MemoryFile memFile = wccAssetGetter.getFileList ().get(0);
                    BlobObjectImpl blob = new BlobObjectImpl (memFile.getName (), memFile.getPath (), memFile.getBytes ());
                    attrData.setData (blob);
                }
            }
            continue;
        }

        if (fieldDef.getType () == AttributeTypeEnum.DATE) {
        	if (wccAssetGetter.isDate ()) {
                if (fieldDef.isList()) {
                    attrData.setDataAsList (wccAssetGetter.getDateList ());
                } else {
                    attrData.setData (wccAssetGetter.getDateList ().get(0));
                }
        	} else if (wccAssetGetter.isString()) {
                if (fieldDef.isList()) {
                	ArrayList<Date> dateList = new ArrayList<Date>();
                	for (String timestamp : wccAssetGetter.getStringList ()) {
                		dateList.add (serverTzDateFormat.parse(timestamp));
                	}
                	attrData.setDataAsList (dateList);
                } else {
                	String timestamp = wccAssetGetter.getStringList ().get(0);
                    attrData.setData (serverTzDateFormat.parse(timestamp));
                }
        	}
            continue;
        }

        if (fieldDef.getType () == AttributeTypeEnum.ASSET) {
            if (wccAssetGetter.isString ()) {
                if (fieldDef.isList()) {
                    ArrayList<AssetId> assetIdList = new ArrayList<AssetId>();
                    for (String assetIdStr : wccAssetGetter.getStringList ()) {
                        assetIdList.add(parseAssetId(assetIdStr));
                    }
                    attrData.setDataAsList (assetIdList);
                } else {
                    AssetId assetId = parseAssetId(wccAssetGetter.getStringList ().get(0));
                    attrData.setData (assetId);
                }
            }
            continue;
        }

        if (fieldDef.getType () == AttributeTypeEnum.ASSETREFERENCE) {
            if (wccAssetGetter.isString ()) {
                ArrayList<AssetId> assetIdList = new ArrayList<AssetId>();
                for (String assetIdStr : wccAssetGetter.getStringList ()) {
                    assetIdList.add(parseAssetId(assetIdStr));
                }
                asset.setAssociation (fieldName, assetIdList);
            }
            continue;
        }

        // any other type
        if (fieldDef.isList()) {
        	attrData.setDataAsList (wccAssetGetter.getStringList ());
        } else {
        	attrData.setData (wccAssetGetter.getStringList ().get(0));
        }
    } catch (Exception e) {
        errorFound = true;
        batchRec.setStatus (WccEnum.Error);
        if (previousAssetId!= null) {
            batchRec.setAssetid (asset.getAssetId ().getId ());
        }
        batchRec.addRemarkProgress ("wcc/pdb/poller/error/fielddef", fieldName, fieldDef.getName (),  e.getMessage ());
        batchRec.addProgressStackTrace (e);
        docTime.dbTime.addMillis(batchRec.save ());
    }
} 

if (!errorFound) {
    try {

        docTime.assetTime.start();
        if (previousAssetId == null) {
            assetManager.insert (Arrays.<AssetData>asList (asset));
        } else {
            assetManager.update (Arrays.<AssetData>asList (asset));
        }
        docTime.assetTime.stop();

        batchRec.setAssetid (asset.getAssetId ().getId ());
        if (previousAssetId == null) {
            batchRec.setStatus (WccEnum.Added);
            batchRec.addRemarkProgress ("wcc/pdb/poller/assetcreated", asset.getAssetId ().toString (), formatStringList(siteList));
        } else {
            batchRec.setStatus (WccEnum.Updated);
            batchRec.addRemarkProgress ("wcc/pdb/poller/assetupdated", asset.getAssetId ().toString (), formatStringList(siteList));
        }
        docTime.dbTime.addMillis(batchRec.save ());

    } catch (Exception e) {
        batchRec.setStatus (WccEnum.Error);
        if (previousAssetId != null) {
            batchRec.setAssetid (asset.getAssetId ().getId ());
        }
        batchRec.addRemarkProgress ("wcc/pdb/common/exception/message", e.getMessage ());
        batchRec.addProgressStackTrace (e);
        batchRec.save ();
    }
}
    } catch (Exception t) {
        wccLog.info (Poller.getStackTrace(t));
        throw (t);
    }
%>
</cs:ftcs>
