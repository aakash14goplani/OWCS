<%@page import="com.fatwire.services.beans.response.MessageCollectors.SaveAssetsMessageCollector"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.fatwire.services.*"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.services.util.*"
%><%@ page import="java.util.*"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"
%><%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
%><%@page import="com.fatwire.services.ui.beans.UIAssetCreateBean"
%><%@page import="com.fatwire.services.ui.beans.UIAssetBean"
%><%@page import="org.apache.commons.lang.StringUtils"
%><cs:ftcs><%
try{
	AssetId assetId = JsonUtil.jsonToId( ics.GetVar( "assetId" ) );
	AssetId dimensionId = JsonUtil.jsonToId( ics.GetVar( "dimensionId" ) );
	Session ses = SessionFactory.getSession( ics );
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	AssetService assetService = servicesManager.getAssetService();
	AssetData assetNameData = assetService.read(assetId, Arrays.asList("name"));
	AttributeData attributeName = assetNameData.getAttributeData("name");
	String name = attributeName != null ? attributeName.getData().toString() : "";
	UIAssetCreateBean translateBean = new UIAssetCreateBean();
	
	String translationName;
	if ( Utilities.goodString( ics.GetVar( "name" ) ) ) {
		translationName = ics.GetVar( "name" );
	}
	else {
		String dimensionLabel;
		AssetData assetDescriptionData = assetService.read(dimensionId, Arrays.asList("description"));
		AttributeData attributeDescription = assetDescriptionData.getAttributeData("name");
		if (attributeDescription != null && attributeDescription.getData() != null) {
			dimensionLabel = attributeDescription.getData().toString();
		}
		else {
			AssetData assetData = assetService.read(dimensionId, Arrays.asList("name"));
			AttributeData Name = assetData.getAttributeData("name");
			dimensionLabel = Name != null ? Name.getData().toString() : "";
		}
		String translationStr = "Translation of " + "(" + dimensionLabel  + ") " + name ; //already 27 bytes
		translationName = "";
		int availSpace = 50; //50bytes because we need some space to add suffix (random numbers and "...")
		for (char ch : translationStr.toCharArray())
		{
			if (availSpace - String.valueOf(ch).getBytes().length >= 0) 
			{
				translationName += ch;
				availSpace -= String.valueOf(ch).getBytes().length;
			}
			else
				break;
		}
		translationName += "_" + (int)Math.ceil(100000*(Math.random()))+ "..."; //9 bytes
		
	}
	DimensionBean dimensionBean = new DimensionBean();
	dimensionBean.setId(dimensionId);
	SaveAssetsMessageCollector collector = new SaveAssetsMessageCollector();
	AssetSaveStatusBean translationStatus = assetService.translate(assetId, translationName, dimensionBean, collector);
	if(translationStatus != null && translationStatus.isSuccess())
	{
		if(translationStatus.getAssetData() != null && translationStatus.getAssetData().getAssetId() != null){
			UIAssetBean assetBn = new UIAssetBean();
			assetBn.setName(translationName);
			assetBn.setId(Long.toString(translationStatus.getAssetData().getAssetId().getId()));
			assetBn.setType(translationStatus.getAssetData().getAssetId().getType());
			translateBean.setAsset(assetBn);
			String refreshKeys = StringUtils.join(translationStatus.getRefreshKeys(),";");
			translateBean.setRefreshKeys(refreshKeys);
		}
		else {
			if(collector.getErrorMessages() != null && collector.getErrorMessages().size() > 0)
				translateBean.setMessage(collector.getErrorMessages().get(0));
		}
	}
	else {
		if(collector.getErrorMessages() != null && collector.getErrorMessages().size() > 0)
			translateBean.setMessage(collector.getErrorMessages().get(0));
	}
	request.setAttribute("translateBean", translateBean);

} catch(Exception e) {
	e.printStackTrace();
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>