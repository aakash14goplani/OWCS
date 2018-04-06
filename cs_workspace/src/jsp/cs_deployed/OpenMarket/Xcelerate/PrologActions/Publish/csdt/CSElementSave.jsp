<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%>
<%//
// csdt/CSElementSave
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@page import="java.util.StringTokenizer"%>

<%@page import="com.fatwire.csdt.service.valueobject.ServiceQueryValueObject"%>
<%@page import="com.fatwire.csdt.service.CSDTService"%>
<%@page import="com.fatwire.csdt.service.factory.CSDTServicefactory"%>
<%@page import="java.util.ArrayList"%><cs:ftcs>

<%!
	public String[] getTokens(String strToTokenize, String delimiter){
		StringTokenizer tokenizer = null;
		String[] values = null;
		int count = 0;
		if(strToTokenize.indexOf(delimiter) >= 0){
			tokenizer = new StringTokenizer(strToTokenize, delimiter);
			values = new String[tokenizer.countTokens()];
			while(tokenizer.hasMoreTokens()){
				values[count] = tokenizer.nextToken();
				count++;
			}
		}
		return values;
	}
%>

<user:login username='<%=request.getParameter("username") %>' password='<%=request.getParameter("password") %>'/>
<%
	if ( ics.GetErrno() == 0 ){
		boolean isMember = ics.UserIsMember("xceladmin");
		if ( isMember ) {
%>
			<asset:create name="currentAsset" type="CSElement"/>
			<asset:addsite name="currentAsset" pubid='<%=ics.GetVar("pubid")%>' />
			<asset:set name="currentAsset" field="name" value='<%=request.getParameter("name")%>'/>
			<asset:set name="currentAsset" field="description" value='<%=request.getParameter("description")%>'/>
			<asset:set name="currentAsset" field="rootelement" value='<%=request.getParameter("rootelement")%>'/>
			<asset:set name="currentAsset" field="elementdescription" value='<%=request.getParameter("elementdescription")%>'/>
            <ics:setvar name="useExistingElementCatalog" value='<%=request.getParameter("useExistingElementCatalog")%>'/>
			<ics:setvar name="element:0:urlspec" value='<%=request.getParameter("urlspec")%>'/>
			<ics:setvar name="element:0:url" value='<%=request.getParameter("url")%>'/>
			<ics:setvar name="element:0:url_file" value='<%=request.getParameter("url_file")%>'/>
			<ics:setvar name="element:0:url_folder" value='<%=request.getParameter("url_folder")%>'/>
			<ics:setvar name="element:0:resdetails1" value='<%=request.getParameter("resdetails1")%>'/>
			<ics:setvar name="element:0:resdetails2" value='<%=request.getParameter("resdetails2")%>'/>
<%
			// Generating the MAP related parameters
			String strMappings = request.getParameter("mapping");
			String[] mapValues = null;
			if( ( strMappings != null )
					&& ( strMappings.trim().length() >  0 ) ){
				if( strMappings.indexOf(",") > 0 ){
					mapValues = getTokens(strMappings, ",");
				}else{
					mapValues = new String[1];
					mapValues[0] = strMappings;
				}
				if(mapValues.length > 0){
					String mapTotal = (new Integer(mapValues.length)).toString();
%>
					<ics:setvar name="Mapping:Total" value='<%=mapTotal %>'/>
<%
					strMappings = "Mapping";
					int count = 0;
					while(count < mapValues.length){
						String[] mapEntries = getTokens(mapValues[count], "#");
						String keyStr = strMappings + ":" + count + ":key";
						String typeStr = strMappings + ":" + count + ":type";
						String valueStr = strMappings + ":" + count + ":value";
						String siteStr = strMappings + ":" + count + ":siteid";
%>
						<ics:setvar name='<%=keyStr %>' value='<%=mapEntries[0] %>'/>
						<ics:setvar name='<%=valueStr %>' value='<%=mapEntries[1] %>'/>
						<ics:setvar name='<%=typeStr %>' value='<%=mapEntries[2] %>'/>
						<ics:setvar name='<%=siteStr %>' value='<%=mapEntries[3] %>'/>
<%
						count++;
					}
				}
			}
%>
			<asset:gather name="currentAsset"/>
			<asset:save name="currentAsset"/>
<%
			if ( ics.GetErrno() != 0 ){
%>
				Save Error:<%=ics.GetErrno() %>
<%
			} else {
				ServiceQueryValueObject valueObject = new ServiceQueryValueObject();
%>
<asset:get name="currentAsset" field="id" output="assetid"/>
<assetid>CSElement:<ics:getvar name="assetid"/></assetid>
Success
<%
			}
		} else {
%>
		Insufficient Privileges
<%
		}
	} else {
%>
		Login Error:<%=ics.GetErrno() %>
<%
	}
%>
</cs:ftcs>