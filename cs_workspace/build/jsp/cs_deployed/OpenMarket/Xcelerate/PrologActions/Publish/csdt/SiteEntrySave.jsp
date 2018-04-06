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
// csdt/SiteEntrySave
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
			<asset:create name="currentAsset" type="SiteEntry"/>
			<asset:addsite name="currentAsset" pubid='<%=ics.GetVar("pubid")%>' />
			<asset:set name="currentAsset" field="name" value='<%=request.getParameter("name")%>'/>
			<asset:set name="currentAsset" field="description" value='<%=request.getParameter("description")%>'/>
			<asset:set name="currentAsset" field="template" value='<%=request.getParameter("template")%>'/>
			<asset:set name="currentAsset" field="cselement_id" value='<%=request.getParameter("cselement_id")%>'/>
			<ics:setvar name="cs_wrapper" value='<%=request.getParameter("cs_wrapper")%>'/>
            <ics:setvar name="pageletonly" value='<%=request.getParameter("pageletonly")%>'/>
			<asset:set name="currentAsset" field="useExistingSiteCatalog" value='<%=request.getParameter("useExistingSiteCatalog")%>'/>

			<ics:setvar name="rootelement" value='<%=request.getParameter("rootelement")%>'/>
			<ics:setvar name="pagename" value='<%=request.getParameter("pagename1")%>'/>
			<ics:setvar name="acl" value='<%=request.getParameter("acl")%>'/>
			<ics:setvar name="cscacheinfo" value='<%=request.getParameter("cscacheinfo")%>'/>
			<ics:setvar name="sscacheinfo" value='<%=request.getParameter("sscacheinfo")%>'/>
			<ics:setvar name="csstatus" value="live"/>

			<%
                String strPgCriteria = request.getParameter("pagecriteria");
                String[] pgCriteria = null;
                if( ( strPgCriteria != null )
                        && ( strPgCriteria.trim().length() >  0 ) )
                {
                    if( strPgCriteria.indexOf(",") > 0 ){
                        pgCriteria = getTokens(strPgCriteria, ",");
                    }else{
                        pgCriteria = new String[1];
                        pgCriteria[0] = strPgCriteria;
                    }
                    if(pgCriteria.length > 0)
                    {
                        ics.SetVar("pagecriteria:Total", String.valueOf(pgCriteria.length));

                        int count = 0;
                        while(count < pgCriteria.length)
                        {
                            ics.SetVar("pagecriteria:" + count, pgCriteria[count]);
                            ++count;
                        }
                    }
                }


            String prefixStr = "defaultarguments:";
			String defaultParams = request.getParameter("arguments");
			if((defaultParams != null)
					&&(defaultParams.trim().length() > 0)){
				int count = 0;
				String[] params = null;
				if( defaultParams.indexOf(",") > 0 ){
					params = getTokens(defaultParams, ",");
				}else{
					params = new String[1];
					params[0] = defaultParams;
				}

				if(params.length > 0){
					String totalDefaultArgs = (new Integer(params.length)).toString();
			%>
				<ics:setvar name="defaultarguments:Total" value='<%=totalDefaultArgs%>'/>
			<%
					while(count < params.length){
						String[] paramValues = getTokens(params[count],":");
						String nameStr = prefixStr+count+":name";
						String name = paramValues[0];
						String value = paramValues[1];
						String valueStr = prefixStr+count+":value";
			%>
						<ics:setvar name='<%=nameStr %>' value='<%=name %>'/>
						<ics:setvar name='<%=valueStr %>' value='<%=value %>'/>
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
<assetid>SiteEntry:<ics:getvar name="assetid"/></assetid>
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