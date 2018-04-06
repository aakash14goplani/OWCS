<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Search/IndexSourceMetaDataConfigHelper
//%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   com.fatwire.cs.core.search.source.IndexSourceConfig,
                   java.util.*,
                   com.fatwire.cs.core.search.source.IndexSourceMetadata,
                   com.fatwire.cs.core.search.data.FieldDescriptor,
                   com.fatwire.assetapi.def.*,
                   com.fatwire.search.source.*,
                   com.fatwire.assetapi.util.AssetUtil,
                   com.openmarket.gator.page.Page,
                   com.openmarket.assetframework.interfaces.*"
%>
<cs:ftcs>
<%
	String temp = ics.GetVar("tempAssetType");
	Map sortedMap = (Map)ics.GetObj("tempSortedMap");
	String checked = ("true".equals(ics.GetVar("checked")))?"true":"false";
	AssetIndexSourceConfigImpl indexConfig = new AssetIndexSourceConfigImpl( ics );
	AssetIndexSourceMetadata metadata = (AssetIndexSourceMetadata) indexConfig.getConfiguration( temp );
	StringBuilder stringBuilder = new StringBuilder();
	Set<String> fieldnames = null;
	if(metadata != null)
		fieldnames = metadata.getFieldNames();
	if ( AssetUtil.isFlexAsset( ics, temp ) || Page.STANDARD_TYPE_NAME.equals(temp ))
	{
		String attributeType = AssetUtil.getAttributeType( ics, temp );
		IList assets = ics.SQL( attributeType, "select name from " + attributeType + " where status <> 'VO'",
								"test", -1, true, true, new StringBuffer() );
		if ( null != assets && assets.hasData() )
		{
			for ( int i = 1; i <= assets.numRows(); i++ )
			{
				assets.moveTo( i );
				String fieldname = assets.getValue( "name" );
				if("true".equals(ics.GetVar("containsChk")) && fieldnames.contains(fieldname)){
					continue;
				}
				AttributeDef def = AssetUtil.getFlexAttributeDef( ics, temp, fieldname  );
				FieldDescriptor desc = ((AssetIndexSourceMetadata) metadata).getFieldDescriptor( def );
				String fieldInfo = fieldname + ";" + checked;
				sortedMap.put(fieldInfo,desc);
			}
		}
	}
	AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);
	AssetTypeDef assetDef = atdm.findByName( temp, null );
	Map<String, FieldDescriptor> defs = ((AssetIndexSourceMetadata) metadata).getAllFieldDescriptors( assetDef );
	for ( String fieldname : defs.keySet() )
	{
		if("true".equals(ics.GetVar("containsChk")) && fieldnames.contains(fieldname)){
			continue;
		}
		FieldDescriptor desc = defs.get( fieldname );
		String fieldInfo = fieldname + ";" + checked;
		sortedMap.put(fieldInfo,desc);
	}
	//Set the StringBuilderObject into ics
	ics.SetObj("tempStringbdr",stringBuilder);
%>
</cs:ftcs>