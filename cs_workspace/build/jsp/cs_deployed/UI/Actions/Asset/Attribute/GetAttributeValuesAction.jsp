<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ page import="com.fatwire.system.*"%>
<%@ page import="com.fatwire.util.BlobUtil"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="com.fatwire.assetapi.query.*"%>
<%@ page import="com.fatwire.assetapi.def.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="com.openmarket.xcelerate.asset.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="com.fatwire.services.ui.beans.UIAssetBean"%>
<%@ page import="com.fatwire.services.ui.beans.UIBlobBean"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>

<cs:ftcs>
<%
String attributeName = ics.GetVar("attributeName");
String incomingAssetId = ics.GetVar("assetId");
String incomingIsBinary = ics.GetVar("isBinary");
// TODO validate incoming arguments
long assetId = Long.valueOf(incomingAssetId).longValue();
boolean isBinary = Boolean.valueOf(incomingIsBinary).booleanValue();
String assetType = ics.GetVar("assetType");
try {
	// get AssetData object
	Session ses = SessionFactory.getSession();
	AssetDataManager mgr = (AssetDataManager)ses.getManager(AssetDataManager.class.getName());
	AssetId id = new AssetIdImpl( assetType, assetId );
	List<String> attributeNames = new ArrayList<String>();
	AssetData assetData = null;
	AttributeDef def = null;
	AttributeTypeEnum type = null;
	List result = null;
	// TODO hardcoded strings
	if ( attributeName.startsWith( "Association-named:" ) || attributeName.equals( "Association-unnamed" ) ) 
	{
		assetData = mgr.readAttributes(id, attributeNames);
		String assocName = ( attributeName.equals( "Association-unnamed" ) ? AssetAssociationDef.UnnamedAssociationName : attributeName.substring( "Association-named:".length() ) );
		result = assetData.getAssociatedAssets( assocName );
		type = AttributeTypeEnum.ASSET;
	}
	else
	{
		attributeNames.add(attributeName);
		assetData = mgr.readAttributes(id, attributeNames);
		// get AttributeData and AttributeDef
		AttributeData data = assetData.getAttributeData(attributeName);
		def = data.getAttributeDef();
		// get attribute data type
		type = data.getType();
		// get data
		result = data.getDataAsList();
	}
	// values will be sent to the Json element
	List values = new ArrayList();
	switch( type ) {
		case LIST: // TODO check this
			if ( "AdvCols".equals( assetType ) )
			{
				List<AssetId> ids = new ArrayList<AssetId>();
				for ( Object o : result )
				{
					Map<String,AttributeData> m = (Map<String,AttributeData>)o;
					AttributeData data = m.get("assetid");
					ids.add( (AssetId)data.getData() );
				}
				Iterable<AssetData> assetDataList = mgr.read(ids);
				for ( AssetData d: assetDataList ) {
					UIAssetBean assetBean = new UIAssetBean();
					assetBean.setId(Long.toString(d.getAssetId().getId()));
					assetBean.setName(d.getAttributeData("name").getData().toString());
					assetBean.setType(d.getAssetId().getType());
					values.add(assetBean);
				}
			}
			break;
		case ASSET:
			// get names of all related asset ids
			// TODO should displayed field be customizable?
			List<AssetId> ids = (List<AssetId>)result;
			Iterable<AssetData> assetDataList = mgr.read(ids);
			for ( AssetData d: assetDataList ) {
				UIAssetBean assetBean = new UIAssetBean();
				assetBean.setId(Long.toString(d.getAssetId().getId()));
				assetBean.setName(d.getAttributeData("name").getData().toString());
				assetBean.setType(d.getAssetId().getType());
				values.add(assetBean);
			}
		break;
		case BLOB:
		case URL:
			if (isBinary) {
				// upload field - build a list of objects representing files
				// (file names + BlobServer URLs)
				for ( Object value : result ) {
					BlobObject current = (BlobObject)value;
					String fileName = StringEscapeUtils.escapeJavaScript(current.getFilename());
					BlobObject.BlobAddress address = current.getBlobAddress();					
					Object blobId = address.getIdentifier();
					String idColumnName = address.getIdentifierColumnName(); // TODO remove if unused
					String blobURL = StringEscapeUtils.escapeJavaScript(BlobUtil.getBlobUrl(ics, current, def, id));
					
					UIBlobBean blobBean = new UIBlobBean();
					blobBean.setBlobId(blobId.toString());
					blobBean.setFilename(fileName);
					blobBean.setBlobURL(blobURL);
					values.add(blobBean);
				}
			}
			else {
				// blob fields containing text
				// build a list of strings containing text values
				for ( Object value: result ) {
					BlobObject current = (BlobObject)value;
					InputStream is = current.getBinaryStream();
					byte[] blob = new byte[ is.available() ];
					is.read( blob );
					values.add(new String( blob ));	
				}
			}

		break;
		case FLOAT:
		case INT:
		case LONG:
		case MONEY:
			// numeric data - no quotes
			for ( Object value : result ) {
				values.add(value.toString());
			}
		break;
		case LARGE_TEXT:
		case STRING:
		case DATE:
			for ( Object value : result ) {
				values.add(value.toString());
			}
		break;
	}	
	request.setAttribute( "values", values );
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>