<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.fatwire.assetapi.*"
%><%@ page import="com.fatwire.cs.core.uri.Definition"
%><%@ page import="com.openmarket.xcelerate.controlpanel.*"
%><%@ page import="com.openmarket.xcelerate.asset.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIDisassembleBean"
%><%@page import="com.fatwire.services.ui.beans.UIAssetBean"
%><cs:ftcs>
<%
try{
	Definition definition = null;
	String c   = null;
	String cid = null;
	String url = ics.GetVar("cs_url");
	
	// create the presentaion bean 
	UIDisassembleBean disassembleBean = new UIDisassembleBean();
	
	if (url != null) {
		// disassemble the incoming URL
		// TODO move this out of ControlPanel class
		definition = ControlPanel.disassemble(url);
		if (definition != null) {
			// we expect a c and cid
			c   = definition.getParameter("c");
			cid = definition.getParameter("cid");
	
			if ( c != null && cid != null ) {
				StringBuffer err = new StringBuffer();
			
				// get the asset name
				Session ses = SessionFactory.getSession();
				AssetDataManager mgr = (AssetDataManager)ses.getManager(AssetDataManager.class.getName());
				AssetId id = new AssetIdImpl(c, Long.valueOf(cid));
				AssetData assetData = mgr.readAttributes( id, Collections.singletonList( "name" ) );
				String assetName = assetData.getAttributeData("name").getData().toString();			
				
				//create asset bn and set asset values
				UIAssetBean assetBean = new UIAssetBean();
				assetBean.setId(cid);
				assetBean.setType(c);
				assetBean.setName(assetName);
				disassembleBean.setAsset(assetBean);
				
				// get the template name
				String tname = "";
				String subtype = "";
				
				// TODO move this to service layer
				String pagename = definition.getParameter("pagename");
				String childpagename = definition.getParameter("childpagename");
				String pagelet = (childpagename != null ? childpagename : pagename);
				
				String sql = "select t.name as name, t.description as description, t.subtype as subtype from Template t, SiteCatalog s where t.status!='VO' and s.rootelement=t.rootelement and s.pagename='" + pagelet + "'";
				
				IList templateData = ics.SQL("SiteCatalog,Template", sql, null, -1, true, err);
				if (templateData != null && templateData.hasData()) {
					tname = templateData.getValue("name");
					subtype = templateData.getValue("subtype");
					if (subtype == null || subtype.length() == 0)
						tname = "/" + tname;
				}
				//set the template name and icspage flag
				disassembleBean.setTname(tname);
				disassembleBean.setIscspage(true);
				
			}
			else {
				// no c and cid in the URL
				disassembleBean.setIscspage(false);
			}
		}
		else {
			disassembleBean.setIscspage(false);
		}
		request.setAttribute("disassembleBean", disassembleBean);
	}
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>