<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.util.AssetUtil"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="com.fatwire.services.*"
%><%@page import="com.fatwire.services.beans.*"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="java.util.*"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@page import="com.fatwire.services.beans.asset.basic.template.TemplateBean"
%><%@page import="com.fatwire.services.beans.asset.TypeBean"
%><%@page import="com.fatwire.services.beans.asset.basic.template.ArgumentBean"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<ics:callelement element="UI/Utils/encodeParameters">
	<ics:argument name="excludeParametersLst" value="persistedPositions"/>
</ics:callelement>
<%
try{
	String tname = ics.GetVar("tname");
	
	String assetType = ics.GetVar("assetType");
	String assetId = ics.GetVar("assetId");
	// get template data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	TemplateService templateDataService = servicesManager.getTemplateService();
	
	// get all set of legal arguments/legal values for the given template
	List<Map<String,Object>> arguments = new ArrayList<Map<String,Object>>();
	List<ArgumentBean> templateArgs = null;
	
	if ( StringUtils.isNotBlank(tname) || (assetType!= null && assetId != null)) {	
		
		if(StringUtils.isBlank(tname)&& assetType!= null && assetId != null)
		{
			AssetId asset = AssetUtil.toAssetId(assetType +":" +assetId);
			templateArgs = templateDataService.getArguments( asset );
		} else
		{	
			if (tname.startsWith("/")) {
				// if this is a typeless template, then remove the leading / and set assetType to null 
				// as this is the contract expected by TemplateService
				tname = tname.substring(1);
				assetType = null;
			}
			templateArgs = templateDataService.getTemplateArguments( tname, assetType );
		}	
		if ( templateArgs == null || templateArgs.isEmpty() ) {
			// TODO better presentation for typeless vs typed templates (need to indicate asset type too)
		%>
			<xlat:lookup key="UI/UC1/Layout/NoArgsForTemplate" varname="cs_message" escape="true" encode="false" evalall="false">
				<xlat:argument name="tname" value="<%=tname %>" />
			</xlat:lookup>
		<%
			request.setAttribute( "cs_message", ics.GetVar("cs_message") );
		}
	} else {
		request.setAttribute( "cs_message", "<xlat:stream key='UI/UC1/Layout/NoTemplateSelected'/>" );
	}
	
	if ( templateArgs != null ) {
		Map<String,Object> argumentMap = null;
		for ( ArgumentBean templateArg : templateArgs ) {
			argumentMap = new HashMap<String,Object>();
			
			String argName = templateArg.getName();
			String argDesc = templateArg.getDescription();
			if ( !Utilities.goodString( argDesc ) ) {
				argDesc = argName; // default to arg name if no description provided
			}
			argumentMap.put("name", argName);
			argumentMap.put("description", argDesc);
			
			// legalValues is a map of legal arg name => legal arg description
			// (description is optional)
			Map<String,String> legalValues = templateArg.getValues();
			
			// we need to determine whether the current arg is optional or not
			boolean isRequired = true;
			if ( legalValues != null ) {
				Set<String> keys = legalValues.keySet();
				for ( String key : keys ) {
					// the template framework has the following contract to indicates whether
					// a legal arg is required or not: it passes a legal arg with an empty name and desc
					if ( !Utilities.goodString( key ) && !Utilities.goodString( legalValues.get( key ) ) ) {
						// the current legal arg is optional
						isRequired = false;
						// stop here
						break;
					}
				}
			}
			
			// the arg has legal values if legalValues is not empty
			boolean hasLegalValues = legalValues != null && legalValues.size() > 0;
			
			// ...unless, it is optional, and there's only 1 legal value
			if (!isRequired && legalValues.size() == 1) {
				// which, according to our previous contract is the empty string
				// in this case, our arg doesn't have legal values
				hasLegalValues = false;
			}
			
			argumentMap.put( "isRequired", Boolean.valueOf( isRequired ) );
			argumentMap.put( "hasLegalValues", Boolean.valueOf( hasLegalValues ) );
			argumentMap.put( "legalValues", legalValues );
			arguments.add( argumentMap );
		}
	}
	
	request.setAttribute( "templateArguments", arguments );
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>