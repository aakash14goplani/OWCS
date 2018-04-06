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
<%@page import="java.util.ArrayList, com.openmarket.xcelerate.common.ElementCatalogTable, com.openmarket.xcelerate.interfaces.IElementCatalogEntry, com.openmarket.xcelerate.common.ElementCatalogEntry"%><cs:ftcs>

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
<% if (ics.GetErrno() == 0)
{
    boolean isMember = ics.UserIsMember("xceladmin");
    if (isMember)
    {
        String name = request.getParameter("name");
        String descr = request.getParameter("description");
        String urlspec = request.getParameter("urlspec");
        String url = request.getParameter("url");
        String r1 = request.getParameter("resdetails1");
        String r2 = request.getParameter("resdetails2");

        ElementCatalogTable table = new ElementCatalogTable(ics);
        IElementCatalogEntry entry = new ElementCatalogEntry();
        entry.setElementname(name);
        entry.setDescription(descr);
        entry.setResDetails1(r1);
        entry.setResDetails2(r2);
        entry.setUrlFileData(url);
        entry.setUrlSpec(urlspec);
        if (table.getEntry(entry.getElementname()) != null)
        {
            table.deleteEntry(entry);
        }
        table.setEntry(entry);
        if ( ics.GetErrno() != 0 ){
%>
				Save Error:<%=ics.GetErrno() %>
<% }
else { %>

<assetid>@ElementCatalog:<%=name%></assetid>
Success

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