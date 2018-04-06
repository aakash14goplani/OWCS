<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.fatwire.services.*"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.services.util.*"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="java.util.*"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.services.ui.beans.UIAssetCopyBean"
%><%@page import="com.fatwire.services.ui.beans.UIAssetBean"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="com.fatwire.services.beans.response.MessageCollectors.SaveAssetsMessageCollector"%>
<%@page import="com.fatwire.services.beans.response.MessageCollector"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<cs:ftcs>

<%
	//Call to filter/encode all request Input Parameter Strings
%>
<ics:callelement element="UI/Utils/encodeParameters">
	<ics:argument name="excludeParametersLst" value="assetData"/>
</ics:callelement>
<%
try 
{
	Session ses = SessionFactory.getSession(ics);
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	final AssetService assetService = servicesManager.getAssetService();
	final ICS _ics = ics;	
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetData")))));
	List<UIAssetCopyBean> result = GenericUtil.transformList(assetIds, new GenericUtil.Transformer<AssetId, UIAssetCopyBean>() {
		public UIAssetCopyBean transform(AssetId assetId){
			UIAssetCopyBean assetCopyBean = new UIAssetCopyBean();
			try {
				AssetData assetData = assetService.read(assetId, Arrays.asList("name"));
				
				SaveAssetsMessageCollector collector = new SaveAssetsMessageCollector();
				if(assetData!=null)
				{
					AttributeData attributeData = assetData.getAttributeData("name");
					String name = attributeData != null ? String.valueOf(attributeData.getData()) : "";
					String copyStr = StringUtils.defaultIfEmpty(_ics.GetVar("name"),"Copy Of "+name);
					String copyName = null;
					if(copyStr.length() > 50)
						copyName = copyStr.substring(0,50) + "_" + (int)Math.ceil(100000*(Math.random()))+ "...";
					else
						copyName = copyStr + "_" + (int)Math.ceil(100000*(Math.random()))+ "...";
					AssetSaveStatusBean copyStatus = assetService.copy(assetId, copyName, collector);
					UIAssetBean orgAssetBn = new UIAssetBean();
					orgAssetBn.setName(name);
					orgAssetBn.setId(Long.toString(assetId.getId()));
					orgAssetBn.setType(assetId.getType());
					assetCopyBean.setOriginalAsset(orgAssetBn);
					if(copyStatus != null && copyStatus.isSuccess())
					{
						if(copyStatus.getAssetData() != null && copyStatus.getAssetData().getAssetId() != null){
							UIAssetBean copiedAssetBn = new UIAssetBean();
							copiedAssetBn.setName(copyName);
							copiedAssetBn.setId(Long.toString(copyStatus.getAssetData().getAssetId().getId()));
							copiedAssetBn.setType(copyStatus.getAssetData().getAssetId().getType());
							assetCopyBean.setasset(copiedAssetBn);							
							String refreshKeys = StringUtils.join(copyStatus.getRefreshKeys(),";");
							assetCopyBean.setRefreshKeys(refreshKeys);
						}
						else {
							if(collector.getErrorMessages() != null && collector.getErrorMessages().size() > 0)
								assetCopyBean.setMessage(collector.getErrorMessages().get(0));
						}	
					}
					else {
						if(collector.getErrorMessages() != null && collector.getErrorMessages().size() > 0) {
							assetCopyBean.setMessage(collector.getErrorMessages().get(0));
							_log.error("Asset Copy operation failed for the asset: " + name + ". Error Message: " + collector.getErrorMessages().get(0));
						}	
					}
				}
			} catch (ServiceException e) {
				throw new UIException(e);
			}
			return assetCopyBean;
		}
	});
	request.setAttribute("result", result);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>