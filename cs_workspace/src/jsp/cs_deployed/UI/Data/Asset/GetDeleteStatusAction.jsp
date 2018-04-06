<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.AuthorizationService"
%><%@ page import="com.fatwire.services.AssetService"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@ page import="com.fatwire.insite.utils.*"
%><%@ page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
try {
	// get handle to authorization service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	AuthorizationService authService = servicesManager.getAuthorizationService();
	AssetService assetService = servicesManager.getAssetService();
	
	List<AssetId> assetIds = JsonUtil.jsonToIdList(ics.GetVar("assetIds"));
	List<PermissionBean> permissions = authService.canDelete(ids);
	//	TODO	authorization service refactoring =>
	//			when permission denied, AssetPermission should indicate the cause
	List<Map<String,Object>> data = new ArrayList<Map<String,Object>>();
	for (PermissionBean permission : permissions) {
		Map<String,Object> map = new HashMap<String,Object>();
		AttributeData attributeData = assetService.read(permission.getAsset()).getAttributeData( "name");
		if (attributeData != null && attributeData.getData() != null) {
			map.put("name", attributeData.getData());
		}
		else {
			map.put("name", "&lt;null&gt;");
		}
		
		map.put("permission", permission);
		
		data.add(map);
	}
	
	// put list of permissions
	request.setAttribute("statusList", data);
	// and the corresponding list of references
	//request.setAttribute("references", references);
 } catch( Exception e ) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
}%></cs:ftcs>
