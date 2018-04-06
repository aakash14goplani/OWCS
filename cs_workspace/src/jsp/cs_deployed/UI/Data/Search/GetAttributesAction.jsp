<%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ui.beans.UIAssetBean"
%><%@page import="com.fatwire.assetapi.def.AttributeDef"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.beans.asset.TypeBean"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.Session"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%>
<%@page import="com.fatwire.system.SessionFactory"%><cs:ftcs><%
try {
	String assetType = StringUtils.defaultString(request.getParameter("assetType"));
	String assetSubType = StringUtils.defaultString(request.getParameter("subType"));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	SearchService searchService =  servicesManager.getSearchService();

	if(StringUtils.isNotBlank(assetType)) {
		if(StringUtils.isBlank(assetSubType)) {
			assetSubType = null;
		}
		List<AttributeDef> attributeDefList = searchService.getSearchEnabledAttributes(assetType, assetSubType);
		List<UIAssetBean> attributeDefDisplayList = GenericUtil.transformSourceList(attributeDefList, new GenericUtil.Transformer<AttributeDef, UIAssetBean>() {
			public UIAssetBean transform(AttributeDef def) {
				UIAssetBean uiBean = new UIAssetBean();
				uiBean.setName(def.getName());
				uiBean.setType(def.getType().getName());
				return uiBean;
			}
		}, new GenericUtil.Predicate<AttributeDef> () {
			public boolean evaluate(AttributeDef def) {
				return !(SearchUtil.RESTRICTED_ATTRIBUTES_FOR_SEARCH.contains(def.getName()));
			}
		});
		request.setAttribute("assetAttributes", attributeDefDisplayList);
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>