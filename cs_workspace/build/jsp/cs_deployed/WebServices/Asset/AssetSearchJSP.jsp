<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld"
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld"
%><%//
// WebServices/Asset/AssetSearchJSP
// Note that the xml header must be streamed before any other
// character, including whitespace. Do not insert any text
// that will be streamed to the response before the xml header.
//
// INPUT
//
// OUTPUT
//%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="com.openmarket.basic.objects.StringVarsType"
%><%@ page import="com.openmarket.basic.objects.StringRowsType"
%><cs:ftcs><ics:if condition="<%=!(Boolean.valueOf(ics.GetProperty(ftMessage.csXmlHeaderAutoStreamProp)).booleanValue())%>"><ics:then><ics:getproperty name="cs.xmlHeader"/></ics:then></ics:if><soap:message uri="http://divine.com/someuri/" ns="s">

<%--
	Operation: ASSET.SEARCH

	Inputs:
		  TYPE="asset type"
		  [SUBTYPE="asset subtype"]
		  PREFIX="prefix"
		  [FIELDLIST="field name(s)"]
		  LOCALFIELDS="fields"
		  PUBLIST="publication ID"
		  [EXCLUDE="true|false"]
		  [LIMIT="maximum assets"]
		  [ORDER="order-by string"]

		  StringVarsType searchCriteria - search criteria variables

	Output: List containing found assets
	Errors: errnos and messages
--%>



<%

	// Populate tag attributes
	String assettype = ics.GetVar("TYPE");
	String subtype = ics.GetVar("SUBTYPE");
	String prefix = ics.GetVar("PREFIX");
	String fieldlist = ics.GetVar("FIELDLIST");
	boolean exclude = ftMessage.truestr.equals(ics.GetVar("EXCLUDE"));
	int limit;
	try {
		limit = Integer.parseInt(ics.GetVar("LIMIT"));
	} catch (Exception e) {
		limit = -1;
	}
	String order = ics.GetVar("ORDER");
	String what = ics.GetVar("WHAT");

	if (ics.systemDebug())
	{
		ics.LogMsg("WebServices/Asset/AssetSearch Key asset:search attributes:");
		ics.LogMsg("WebServices/Asset/AssetSearch \tassettype="+assettype);
		ics.LogMsg("WebServices/Asset/AssetSearch \tsubtype="+subtype);
		ics.LogMsg("WebServices/Asset/AssetSearch \tprefix="+prefix);
		ics.LogMsg("WebServices/Asset/AssetSearch \tfieldlist="+fieldlist);
		ics.LogMsg("WebServices/Asset/AssetSearch \texclude="+exclude);
		ics.LogMsg("WebServices/Asset/AssetSearch \tlimit="+limit);
		ics.LogMsg("WebServices/Asset/AssetSearch \torder="+order);
		ics.LogMsg("WebServices/Asset/AssetSearch \twhat="+what);



		// convert input params to variables
		ics.LogMsg("WebServices/Asset/AssetSearch Loading search parameters from request");
	}

	StringVarsType scVars = (StringVarsType)ics.GetObj("SEARCHCRITERIA");
	if (scVars == null)
	{
		if (ics.systemDebug())
			ics.LogMsg("WebServices/Asset/AssetSearch \tNo Keys Passed In");
	}
	else
	{

		if (scVars.getKeys() == null || scVars.getValues() == null)
		{
			if (ics.systemDebug())
				ics.LogMsg("WebServices/Asset/AssetSearch \tNo Keys Passed In");
		}
		else
		{
			String[] scKeys = scVars.getKeys().getItem();
			String[] scVals = scVars.getValues().getItem();
			if (scKeys == null || scVals == null)
			{
				if (ics.systemDebug())
					ics.LogMsg("WebServices/Asset/AssetSearch \tNo Keys Passed In");
			}
			else
			{
				for (int i =0; i < scKeys.length; i++)
				{
					ics.SetVar(scKeys[i],scVals[i]);
					if (ics.systemDebug())
						ics.LogMsg("WebServices/Asset/AssetSearch \tkey:"+scKeys[i]+" value:"+scVals[i]);
				}
			}
		}
	}

	// make sure we have required params
	if ( assettype == null || prefix == null)
	{
		if (ics.systemDebug())
			ics.LogMsg("WebServices/Asset/AssetSearch Invalid params - skipping search");
		ics.SetErrno(ftErrors.badparams);
	}
	else
	{

		if (ics.systemDebug())
			ics.LogMsg("WebServices/Asset/AssetSearch Running tag asset:search");

		// we are clear to run the tag
		%>

		<asset:search
			type='<%=assettype%>'
			subtype='<%=subtype%>'
			list='outlist'
			prefix='<%=prefix%>'
			fieldlist='<%=fieldlist%>'
			exclude='<%=exclude%>'
			limit='<%=limit%>'
			order='<%=order%>'
			what='<%=what%>'
		/>

		<%
		if (ics.systemDebug())
			ics.LogMsg("WebServices/Asset/AssetSearch Done running asset:search.  Errno="+ics.GetErrno());

		IList outlist = ics.GetList("outlist");
		if (outlist ==  null)
			ics.SetErrno(ftErrors.norows);
	}
	%>


	<ics:if condition='<%=ics.GetErrno()==0%>'>
	<ics:then>
		<soap:body tagname="getListOut">
			<%
				if (ics.systemDebug())
					ics.LogMsg("WebServices/Asset/AssetSearch number of rows = "+ics.GetList("outlist").numRows());
			%>
			<misc:listtoxml list='outlist' namespace='s' varname='listXML'/>
			<listOUT xsi:type="s:iList">
				<ics:getvar name='listXML'/>
			</listOUT>
			<%
				if (ics.systemDebug())
					ics.LogMsg("WebServices/Asset/AssetSearch Streamed IList, done!");
			%>
		</soap:body>
	</ics:then>
	<ics:else>
		<soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
		<%
		if (ics.systemDebug())
			ics.LogMsg("WebServices/Asset/AssetSearch Streamed soap fault ("+ics.GetErrno()+":"+ics.GetVar("errdetail1")+")");
		%>
	</ics:else>
	</ics:if>


</soap:message>


</cs:ftcs>