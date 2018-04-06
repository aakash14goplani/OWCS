<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.assetapi.site.*"
%><%@ page import="com.fatwire.services.VersioningService"
%><%@ page import="com.fatwire.services.ServicesManager"
%><cs:ftcs><%
try {
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	VersioningService service = servicesManager.getVersioningService();
	SiteManager siteMgr = (SiteManager)ses.getManager( SiteManager.class.getName() );
	String siteName = ics.GetSSVar( "PublicationName" );
	if ( siteName != null ) {
		List<Site> sites = siteMgr.read( Collections.singletonList( siteName ) );
		Site site = null;
		if ( sites != null && sites.size() > 0 ) {
			site = sites.get( 0 );
			List<String> assetTypes = site.getAssetTypes();
			List<String> trackedAssetTypes = new ArrayList<String>();
			for ( String assetType : assetTypes ) {
				if ( service.isTracked( assetType ) ) {
					trackedAssetTypes.add( assetType );
				}
			}
			request.setAttribute( "trackedTypes", trackedAssetTypes );
		}
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>