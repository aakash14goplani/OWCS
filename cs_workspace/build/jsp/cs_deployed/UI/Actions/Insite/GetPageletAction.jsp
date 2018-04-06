<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="COM.FutureTense.Util.*" 
%><%@ page import="com.openmarket.xcelerate.asset.TemplateManager" 
%><%@ page import="java.net.URLDecoder"
%><%@ page import="java.util.*"
%><%@ page import="com.openmarket.xcelerate.interfaces.*"
%><%@ page import="com.openmarket.assetframework.interfaces.*"
%><%@ page import="com.openmarket.basic.interfaces.*"
%><%@ page import="com.fatwire.cs.ui.framework.*"
%><cs:ftcs><%
try {
	String tname  = ics.GetVar("tname");
	String c      = ics.GetVar("c");
	String cid    = ics.GetVar("cid");
	String site   = ics.GetSSVar("PublicationName");
	String rendermode = "insite";
	String pageletArgs = ics.GetVar( "pageletArgs" );
	Map<String,String> args = new HashMap<String,String>();
	String decodedArgs = null;
	if ( pageletArgs != null ) {
		decodedArgs = URLDecoder.decode( pageletArgs, "UTF-8" ); // TODO file encoding
		if ( Utilities.goodString( decodedArgs ) ) {
			FTValList params = Utilities.getParams( decodedArgs );
			java.util.Enumeration keys = params.keys();
			while ( keys.hasMoreElements() ) {
				String argName = (String)keys.nextElement();
				args.put( argName, params.getValString( argName ) );
			}
		}
	}
	
	if ( "CSElement".equals(c) ) {%>
		<asset:load name="currentAsset" type="CSElement" objectid='<%=cid %>' />
		<asset:get name="currentAsset" field="rootelement" output="elementname"/><%
		Map<String,Object> map = new HashMap<String,Object>();
		map.put( "rendermode", rendermode );
		map.put( "c", c );
		map.put( "cid", cid );
		map.put( "elementname", ics.GetVar("elementname"));
		map.put( "pageletArgs", args );
		request.setAttribute( "cs", map );
	}
	else if ( "SiteEntry".equals( c ) ) {%>
		<asset:load name="currentAsset" type="SiteEntry" objectid='<%=cid %>' />
		<asset:get name="currentAsset" field="pagename" output="pagename" /><%
		Map<String,Object> map = new HashMap<String,Object>();
		map.put( "pagename", ics.GetVar("pagename") );
		map.put( "c", c );
		map.put( "cid", cid );
		map.put( "rendermode", rendermode );
		map.put( "pageletArgs", args );
		request.setAttribute( "cs", map );
	}
	else {
		boolean isMobilityEnabled = true;
		String device=ics.GetVar("d");

		if (!isMobilityEnabled || !Utilities.goodString( device ))
		{
		boolean hasTemplate = ( Utilities.goodString( tname ) );
		boolean hasContent = ( Utilities.goodString( c ) && Utilities.goodString( cid ) );
		if ( hasContent && hasTemplate ) {
			IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
			ITemplateAssetManager manager = (ITemplateAssetManager)atm.locateAssetManager( "Template" );
			
			// check that the requested tname/c/site exists
			if (manager.getTemplateID(tname, c, ics.GetSSVar("pubid")) == null) {
				// TODO localization
				UIException uie = new UIException("There is no template '" + tname + "' available for asset type '"
													+ c + "' in site: '" + site + "'");
				request.setAttribute(UIException._UI_EXCEPTION_, uie);
				throw uie;
			}
			
			String pagename = null;
			if (tname.startsWith("/")) {
				pagename = TemplateManager.getSiteCatalogName(site, null, tname.substring(1));
			}
			else {
				pagename = TemplateManager.getSiteCatalogName(site, c, tname);	
			}
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put( "pagename", pagename );
			map.put( "c", c );
			map.put( "cid", cid );
			map.put( "rendermode", rendermode );
			map.put( "pageletArgs", args );
			request.setAttribute( "cs", map );
		}
		}
		else
		{
			// now device suffix is passed here. Look for device specific template
			boolean hasTemplate = ( Utilities.goodString( tname ) );
			boolean hasContent = ( Utilities.goodString( c ) && Utilities.goodString( cid ) );
			if ( hasContent && hasTemplate ) {
			String deviceTname=tname+"_"+device;
			IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
			ITemplateAssetManager manager = (ITemplateAssetManager)atm.locateAssetManager( "Template" );
			boolean templateExist=false;
			// check the device specific template 
			if (manager.getTemplateID(deviceTname, c, ics.GetSSVar("pubid")) != null)
			{
				templateExist=true;
				// change the template name to call
				tname=deviceTname;
			}
			else if (manager.getTemplateID(tname, c, ics.GetSSVar("pubid")) != null)
			{
				templateExist=true;
			}
		
			// check that the requested tname/c/site exists
			if (!templateExist) {
				// TODO localization
				UIException uie = new UIException("There is no template '" + tname + "' available for asset type '"
													+ c + "' in site: '" + site + "'");
				request.setAttribute(UIException._UI_EXCEPTION_, uie);
				throw uie;
			}
			
			String pagename = null;
			if (tname.startsWith("/")) {
				pagename = TemplateManager.getSiteCatalogName(site, null, tname.substring(1));
			}
			else {
				pagename = TemplateManager.getSiteCatalogName(site, c, tname);	
			}
			
			
			args.put( "d", device );
			Map<String,Object> map = new HashMap<String,Object>();
			map.put( "pagename", pagename );
			map.put( "c", c );
			map.put( "cid", cid );
			map.put( "rendermode", rendermode );
			map.put( "pageletArgs", args );
			request.setAttribute( "cs", map );
		}
	}
	}
} catch(Exception e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
}
%>
</cs:ftcs>