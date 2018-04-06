<%@page import="com.fatwire.cs.core.webreference.WebReferencesBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesManager"%>
<%@page import="com.fatwire.assetapi.data.WebReferenceImpl"%>
<%@page import="com.fatwire.assetapi.data.WebReference"%>
<%@page import="java.util.Enumeration"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
	
	<xlat:lookup varname="urlalreadyexists" key="UI/Forms/URLAlreadyExists"/>
	<xlat:lookup varname="urlalreadyexistsasredirect" key="UI/Forms/URLAlreadyExistsAsRirect"/><%
	
	String vanityURL = (Utilities.goodString(ics.GetVar("vanity_url"))) ? ics.GetVar("vanity_url") : "http://localhost:9080/cs/practice/price-date_asset";
	String assetURL = vanityURL.substring(vanityURL.lastIndexOf("/") + 1);
	String webroot = "Practice";
	String sql = "SELECT assetid, assettype FROM WebReferences WHERE webroot ='" + webroot + "' AND webreferenceurl ='" + assetURL + "'";
	
	String reqURI = request.getRequestURI();
	StringBuffer reqURL = request.getRequestURL();
	out.println("reqURI: " + reqURI + ", reqURL: " + reqURL + "<br/>"); 
	
	out.println("<br/><br/>Attributes: <br/>");
	for(Enumeration<String> e = request.getAttributeNames(); e.hasMoreElements(); ){
		String attName = (String)e.nextElement();
		out.println("attName: " + attName + ", value: " + request.getAttribute(attName) + "<br/>");
	}
	
	out.println("<br/><br/>Parameters: <br/>");
	for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ){
		String paramName = (String)e.nextElement();
		out.println("paramName: " + paramName + ", value: " + request.getParameter(paramName) + "<br/>");
	}
	
	out.println("<br/><br/>Header Names: <br/>");
	for(Enumeration<String> e = request.getHeaderNames(); e.hasMoreElements(); ){
		String headerName = (String)e.nextElement();
		out.println("headerName: " + headerName + ", value: " + request.getHeader(headerName) + "<br/>");		
	}
	
	try{
		WebReferencesManager wrmObject = new WebReferencesManager(ics);
		WebReference wr = new WebReferenceImpl("localhost:9080", vanityURL, 200, "");
		out.println("Web Root: " + wr.getWebRoot());
		WebReferencesBean bean =  wrmObject.getWebReferenceForUnresolvedHost("localhost:9080", vanityURL); 
	}
	catch(Exception e){
		out.println("WebReference Exception: " );
	}
	
%><%-- <ics:sql table="WebReferences" listname="assetDetailsList" sql='<%=sql %>' />
	<ics:if condition='<%=null != ics.GetList("assetDetailsList") && ics.GetList("assetDetailsList").hasData() %>'>
		<ics:then>
			<ics:listloop listname="assetDetailsList">
				<ics:listget fieldname="assetid" listname="assetDetailsList" output="asset_id"/>
				<ics:listget fieldname="assettype" listname="assetDetailsList" output="asset_type"/>
				<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
					<ics:argument name="c" value='<%=ics.GetVar("asset_type") %>' />
					<ics:argument name="cid" value='<%=ics.GetVar("asset_id") %>' />
					<ics:argument name="assetPrefix" value='<%=ics.GetVar("asset_id") %>' />
				</ics:callelement>
				Body Text: <ics:getvar name='<%=ics.GetVar("asset_id") + ":body_text" %>'/><br/><br/>
			</ics:listloop>
		</ics:then>
	</ics:if>	 --%>
</cs:ftcs>