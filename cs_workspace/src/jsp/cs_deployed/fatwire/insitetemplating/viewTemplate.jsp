<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" 
%><%//
// fatwire/insitetemplating/viewTemplate
// DEPRECATED - now replaced by UI/Action/GetPagelet
// 
//	renders a c/cid/tname
//
// INPUT
//		tname: template name
//		c: content type
//		cid: content id
//		site: current site name
//		pageletArgs: encoded name/value pairs
// OUTPUT
//		a rendered pagelet
// TODO error handling
//
%><%@ page import="COM.FutureTense.Interfaces.*" 
%><%@ page import="com.openmarket.xcelerate.asset.TemplateManager" 
%><%@ page import="java.net.URLDecoder" 
%><cs:ftcs>
<usermanager:getloginusername varname="thisusername"/><%
	String tname  = ics.GetVar("tname");
	String c      = ics.GetVar("c");
	String cid    = ics.GetVar("cid");
	String rm     = "insite_templating-"+ics.GetVar("thisusername")+"-"+ics.GetSSVar("pubid");
	boolean hasTemplate = ( Utilities.goodString( tname ) );
	boolean hasContent = ( Utilities.goodString( c ) && Utilities.goodString( cid ) );
%>
<ics:if condition='<%="SiteEntry".equals(c) || "CSElement".equals(c) %>'>
<ics:then>
	<ics:callelement element='<%= "fatwire/insitetemplating/view" + c %>'>
	  <ics:argument name="rendermode" value="<%=rm %>"/>
	</ics:callelement>
</ics:then>
<ics:else><% 
	if ( hasContent && hasTemplate ) 
	{
		String pagename = null;
		if (tname.startsWith("/"))
			pagename = TemplateManager.getSiteCatalogName(ics.GetVar("site"), null, tname.substring(1));			
		else
			pagename = TemplateManager.getSiteCatalogName(ics.GetVar("site"), c, tname);	

		String args = ics.GetVar( "pageletArgs" );
		String decodedArgs = null;
		if ( args != null ) {
			decodedArgs = URLDecoder.decode( args, "UTF-8" ); // TODO file encoding
		}
		%>
		<render:satellitepage pagename='<%= pagename %>' >
			<render:argument name='c' value='<%=ics.GetVar("c")%>' />
			<render:argument name='cid' value='<%=ics.GetVar("cid")%>' />
			<render:argument name='rendermode' value="<%=rm%>" /><%
			if ( Utilities.goodString( decodedArgs ) ) 
			{
				FTValList params = Utilities.getParams( decodedArgs );
				java.util.Enumeration keys = params.keys();
				while ( keys.hasMoreElements() )
				{
					String argName = (String)keys.nextElement();
					%><render:argument name="<%=argName%>" value="<%=params.getValString(argName)%>"/><%
				}
			}%>
		</render:satellitepage>
	<%}
	else if ( hasTemplate ) 
	{%>
		<div class="emptyIndicator" style="height: 100px;">
			<div class="emptyIndicatorInner">
				<div class="emptyIndicatorText" style=""><span class="avatar"><span class="left"></span>
				<span class="content">Template selected. Drop content to render slot</span><span class="right"></span></span>
				</div>
			</div>
		</div><%
		// TODO temporary message
	}
	else if ( hasContent ) 
	{%>
		<div class="emptyIndicator" style="height: 100px;">
		<div class="emptyIndicatorInner">
			<div class="emptyIndicatorText" style=""><span class="avatar"><span class="left"></span>
			<span class="content">Content selected - select template to render slot</span><span class="right"></span></span>
			</div>
		</div>
		</div><%
	}
	else
	{
		// TODO - this doesn't work
		%>
		<div class="emptyIndicator" style="height: 100px;">
		<div class="emptyIndicatorInner">
			<div class="emptyIndicatorText" style=""><span class="avatar"><span class="left"></span>
			<span class="content">&nbsp;</span><span class="right"></span></span>
			</div>
		</div>
		</div><%
	}%>
</ics:else>
</ics:if>
</cs:ftcs>
