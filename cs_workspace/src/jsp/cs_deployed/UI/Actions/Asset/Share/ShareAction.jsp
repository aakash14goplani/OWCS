<%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.AssetService"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@page import="com.fatwire.services.beans.entity.SiteBean"
%><%@ page import="com.fatwire.assetapi.def.AssetTypeDef"
%><%@ page import="com.fatwire.services.beans.entity.SiteBean"
%><%@ page import="com.fatwire.services.exception.ServiceException"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIShareBean"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@ page import="com.fatwire.assetapi.def.AssetTypeDefImpl"
%><cs:ftcs><%
try{
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	AssetService assetService = servicesManager.getAssetService();	
	
	String strPubId = request.getParameter("pubId");
	String[] pubIds = strPubId.split(","); 
	
	List<Long> pubIdList = new ArrayList<Long>();
	if(pubIds != null && pubIds.length>0) {
		for(String pubId : pubIds) {
			if(NumberUtils.isNumber(pubId))
				pubIdList.add(NumberUtils.toLong(pubId));
		}
	}
	
	List<SiteBean> sharedSites =  null;
	boolean result = false;
	AssetTypeDef assetDefinition = new AssetTypeDefImpl();
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetData")))));
	for(AssetId assetId : assetIds){
		result = assetService.share(assetId, pubIdList);
		if(result) {
			sharedSites = assetService.getSitesInWhichShared(assetId);
		}
		// we also need the assettype description for the display
		assetDefinition = assetService.getDefinition(assetId.getType(), AssetUtil.getSubtype(ics, assetId));
	}
	
	//create the presentation bean and set the values.	
	UIShareBean shareBean = new UIShareBean();	
	StringBuffer buf = new StringBuffer();
	if(sharedSites != null && sharedSites.size() > 0)
	{
%>
	<xlat:lookup key='UI/UC1/Layout/ShareMessage1' varname='output' evalall='false'><xlat:argument name='name' value='<%=assetDefinition.getDescription()%>'/></xlat:lookup>
<%
		buf.append(ics.GetVar("output"));
		buf.append("<br>");
		for(int i=0; i<sharedSites.size(); i++)
		{
			buf.append(sharedSites.get(i).getName());
			buf.append("<br>");
		}
	}
	shareBean.setSharedSites(buf.toString());
	shareBean.setStatus(result);
	shareBean.setAssetTypeDescription(assetDefinition.getDescription());
	request.setAttribute("shareBean", shareBean);

} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
}catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>