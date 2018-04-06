<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyView
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.realtime.util.Util"%>
<%!
	public static final String TREENAME = "LocaleTree";

    String getRootNode(ICS ics)	throws Exception
	{	FTValList params = new FTValList();
		params.put("ftcmd", "findnode");
		params.put("treename", TREENAME);
		params.put("where", "otype,oid");
		params.put("otype", "DimensionSet");
		params.put("oid", ics.GetVar("DimensionSet:id"));
		ics.TreeManager(params);

		IList ilist = ics.GetList(TREENAME);
		if (null != ilist && ilist.hasData())
		{	return (ilist.getValue("nid"));
		}

		return (null);
	}

	void printTree(JspWriter out, ICS ics, String sNodeID, String sOID, int iDepth) throws Exception
	{
		if (null != sOID)
		{	String sql = "select name from Dimension where id = "+sOID;
			IList iList = ics.SQL("Dimension", sql, null, -1, false, true, null);
			String sName = iList.getValue("name");

			out.println("<li style='padding-left: "+(iDepth*20)+"px; padding-bottom: 5px;'>"+sName+"</li>");
		}

		FTValList params = new FTValList();
		params.put("ftcmd", "getchildren");
		params.put("treename", TREENAME);
		params.put("orderby", "nrank");
		params.put("nparentid", sNodeID);
		ics.TreeManager(params);

		IList ilistChildren = ics.GetList(TREENAME);

		if (null != ilistChildren)
		{	if (null != sOID)
				iDepth += 1;

			for (int i = 1; ilistChildren.moveTo(i); i++)
			{	printTree(out, ics, ilistChildren.getValue("nid"), ilistChildren.getValue("oid"), iDepth);
			}
		}
	}
%>
<cs:ftcs>
<script>
	var getHiddenElement = function(name,value){
		var elm = document.createElement("input");
					elm.type = "hidden";
		elm.name = name;
		elm.value = value;
		return elm;
	};
	
	var deleteHierarchy = function(pagename){
		if(!document.AppForm.elements['DimensionSet:id'])
			document.AppForm.appendChild(getHiddenElement('DimensionSet:id','<%=ics.GetVar("DimensionSet:id")%>'));
		if(!document.AppForm.elements['pagename'])
			document.AppForm.appendChild(getHiddenElement('pagename',pagename));
		if(!document.AppForm.elements['form_action'])
			document.AppForm.appendChild(getHiddenElement('form_action',"delete"));
		
		document.AppForm.submit();
	};
</script>
<string:encode variable="cs_environment" varname="cs_environment"/>
<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
<!-- DimensionSet page title with asset name -->
<tr>
    <td>
        <span class="title-text">
            <xlat:stream key="dvin/AT/DimensionSet/ConfigureLocaleHierarchy"/>
        </span>
    </td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
    <ics:argument name="SpaceBelow" value="No" />
</ics:callelement>
<!-- Action bar -->
<satellite:link pagename="OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyView" outstring="inspectURL">
    <satellite:parameter name="DimensionSet:id" value='<%=ics.GetVar("DimensionSet:id")%>' />
</satellite:link>
<% if ("ucform".equals(ics.GetVar("cs_environment"))){%>
	<satellite:link pagename="OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyEdit" outstring="editURL">
		<satellite:parameter name="DimensionSet:id" value='<%=ics.GetVar("DimensionSet:id")%>' />
		<satellite:parameter name="cs_environment" value='ucform' />
	</satellite:link>
<% } else {%>
	<satellite:link pagename="OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyEdit" outstring="editURL">
		<satellite:parameter name="DimensionSet:id" value='<%=ics.GetVar("DimensionSet:id")%>' />
	</satellite:link>
<% } %>
<tr>
    <td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <%--<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar">
            <ics:argument name="SpaceAbove" value="No" />
        </ics:callelement>--%>
        <tr>
            <td style="padding-left: 15px;">
            <%
                try
                {	String sRoot = getRootNode(ics);
                    if (null != sRoot)
                        printTree(out, ics, sRoot, null, 0);
					else
						out.println("<br>" + Util.xlatLookup(ics, "dvin/AT/DimensionSet/LocaleHierarchyNotConfigured", false, false) + "<br>");
                }
                catch (Exception e)
                {	e.printStackTrace(new java.io.PrintWriter(out));
                }
            %>
            </td>
        </tr>
        </table>
       </td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
<tr>
    <td>
        <table  border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <xlat:lookup key="dvin/Common/Edit" escape="true" varname="_XLAT_EDIT"/>
                <xlat:lookup key="dvin/UI/Admin/EditThisDescription" varname="_ALT_EDIT"/>
                <a href='<%=ics.GetVar("editURL")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_EDIT")%>';return true;" onmouseout="window.status='';return true">
                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="dvin/Common/Edit"/></ics:callelement>
                </a>
            
                <xlat:lookup key="dvin/Common/Delete" escape="true" varname="_XLAT_DELETE"/>
                <xlat:lookup key="dvin/UI/Admin/DeleteThisDescription" varname="_ALT_DELETE"/>
                <a href='#' onclick="javascript:deleteHierarchy('OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyPost');" onmouseover="window.status='<%=ics.GetVar("_XLAT_DELETE")%>';return true;" onmouseout="window.status='';return true">
                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="dvin/Common/Delete"/></ics:callelement>
                </a>
            </td>
        </tr>
        </table>
    </td>
</tr>
</table>
</cs:ftcs>