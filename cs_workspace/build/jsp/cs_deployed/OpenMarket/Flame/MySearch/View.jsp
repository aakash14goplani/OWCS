<%@ page import="COM.FutureTense.Interfaces.FTValList,
                 COM.FutureTense.Interfaces.IList,
                 COM.FutureTense.Util.ftMessage,
                 com.fatwire.flame.search.Search,
                 com.fatwire.flame.search.SimpleSearch,
                 com.fatwire.flame.search.SimpleOrder,
                 com.fatwire.flame.portlets.FlamePortlet,
                 com.fatwire.flame.portlets.MySearch,
                 com.fatwire.flame.variation.Normalizer,
                 com.fatwire.flame.variation.NormalizerFactory,
                 com.openmarket.xcelerate.site.Publication,
                 java.util.Hashtable,
                 java.util.ArrayList,
                 org.apache.commons.logging.LogFactory"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/MySearch/View
//
// INPUT
//
// OUTPUT
//%>
<%!
private static final String[][] SEARCH_FIELDS = {
    {"Name", "dvin/AT/Common/Name"},
    {"Description", "dvin/AT/Common/Description"},
    {"UpdatedBy", "dvin/Common/ModifiedBy"},
    {"CreatedBy", "dvin/Common/CreatedBy"}
};

private static final String[][] SORT_FIELDS = {
    {"name", "dvin/AT/Common/Name"},
    {"description", "dvin/AT/Common/Description"},
    //{"createdby", "dvin/Common/CreatedBy"},
    //{"createddate", "dvin/UI/Search/CreatedDate"},
    {"updatedby", "dvin/Common/ModifiedBy"},
    {"updateddate", "dvin/UI/Search/ModifiedDate"}
};
%>
<cs:ftcs>
	<portlet:defineObjects/>
    <%
	ics.SetVar("queryfields","");
	Normalizer normFormField = NormalizerFactory.getNormalizer(NormalizerFactory.FORM_FIELD,
			renderRequest, renderResponse, portletConfig);
	ics.CallElement("OpenMarket/Flame/Common/UIFramework/PortletCSFormMode", null);

	ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
	String cs_imageDir = ics.GetVar("cs_imagedir");
    %>
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>
    <script>

    function <portlet:namespace/>_doSearch()
    {
        var form = document.forms["<portlet:namespace/>_mysearch"];
        form.elements["<%=normFormField.normalize(FlamePortlet.ACTION)%>"].value = "<%=MySearch.ACTION_DOSEARCH%>";
        form.submit();
        return false;
    }
    
    function <portlet:namespace/>_advancedSearch()
    {
        var form = document.forms["<portlet:namespace/>_mysearch"];
        var searchTypeElement = form.<%=normFormField.normalize("searchtype")%>;
        var formmode = form.<%=normFormField.normalize("formmode")%>.value;
        var url;
        if( formmode == "DM" )
        { url = JSSearchDMURLs[searchTypeElement.selectedIndex];  }
        else
        { url = JSSearchContentURLs[searchTypeElement.selectedIndex];  }

        var win = window.open(url, "AdvancedSearch", "directories=no,scrollbars=yes,resizable=yes,location=no,menubar=no,toolbar=no,top=20,width=650,height=680,left=300");
        win.focus();

        return false;
    }
    </script>

    <%
    FTValList args = new FTValList();
    args.setValString("ITEMTYPE", "Search");
    args.setValString("PUBID", ics.GetSSVar("pubid"));
    args.setValString("LISTVARNAME", "atList");
    ics.runTag("STARTMENU.GETMATCHINGSTARTITEMS", args);
    args.removeAll();
    
    // for DocumentManagemnet, display only asset type enabled for CSDocLink
    Hashtable enabledAssetTypes = new Hashtable();
    if ( ics.GetVar("cs_formmode").equals("DM") ) {
		args.setValString( "CLIENTAPP", "CSDocLink");
		args.setValString( "SITE", ics.GetSSVar("pubid"));
		args.setValString("LISTVARNAME", "enabledAssetTypes");
		ics.runTag("EXTERNALCLIENTSMANAGER.GetEnabledAssetTypesForAClient", args);
		args.removeAll();
    } else {
    	 Publication site = Publication.Load( ics, new Long(ics.GetSSVar("pubid")), null, false );
    	 IList enabledlist = site.GetEnabledAssetTypes( ics );
 		 ics.RegisterList("enabledAssetTypes",enabledlist);
    }
    IList enabledList = ics.GetList("enabledAssetTypes");
    if (enabledList!=null && enabledList.hasData()) {
		for(int i = 1; i <= enabledList.numRows(); i++) {
			try {
				enabledList.moveTo(i);
				enabledAssetTypes.put( enabledList.getValue("assettype"), enabledList.getValue("assettype") );
			} catch(NoSuchFieldException e) {
				LogFactory.getLog(ftMessage.GENERIC_DEBUG).error("OpenMarket/Flame/MySearch/View", e);
				continue;
			}
		}
    }
    
    IList atList = ics.GetList("atList");
    if (atList!=null && atList.hasData() && !enabledAssetTypes.isEmpty()) {
        SimpleOrder order;
        SimpleSearch search;
        try {
            Object tmp = renderRequest.getPortletSession().getAttribute(Search.class.getName());
            search = tmp instanceof SimpleSearch ? (SimpleSearch)tmp : null;
            tmp = search != null ? search.getOrder() : null;
            order = tmp instanceof SimpleOrder ? (SimpleOrder)tmp : null;
        } catch (Exception e) {
            search = null;
            order = null;
        }
        %>
       
        <satellite:link assembler="query" outstring="searchURL" portleturltype="action" >
            <satellite:argument name="pagename" value="OpenMarket/Flame/MySearch/View"/>
			<satellite:argument name="_state" value="maximized"/>
			<satellite:argument name="windowstate" value="maximized"/>
			<satellite:argument name="window.newWindowState" value="MAXIMIZED"/>
        </satellite:link>
     
        <%
        String urlSearch = ics.GetVar("searchURL");
        %>

        <satellite:form name="<portlet:namespace/>_mysearch" method="post" action="<%=urlSearch%>">
		<property:get param="xcelerate.charset" inifile="futuretense_xcel.ini" varname="propcharset"/>
		<INPUT TYPE="HIDDEN" NAME="_charset_" VALUE="<%=ics.GetVar("propcharset")%>"/>
		<input type="hidden" name="<%=normFormField.normalize(FlamePortlet.ACTION)%>" value="<%=MySearch.ACTION_DOSEARCH%>" />
		<input type="hidden" name="<%=normFormField.normalize("formmode")%>" value="<%=ics.GetVar("cs_formmode")%>" />


		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
		</tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 1px 1px;">
					<tr>
						<td colspan="3" class="tile-highlight">
							<img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
						</td>
					</tr>
					<tr class="section-header">
						<td colspan="3" class="tile-c">&nbsp;</td>
					</tr>
                    <tr>
                        <td colspan="3" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
                    </tr>

                       <tr>
    					<td colspan="3" NOWRAP="NOWRAP"><DIV class="form-inset">
                        <select name="<%=normFormField.normalize(MySearch.SEARCH_TYPE)%>" size="1">
                        <%
                        ArrayList alSearchURLs = new ArrayList();
                        for(int i = 1; i <= atList.numRows(); i++) {
                            atList.moveTo(i);
                            String assetType;
                            String startID;
                            try {
                                assetType = atList.getValue("assettype");
                                startID = atList.getValue("id");
                            } catch(NoSuchFieldException e) {
								LogFactory.getLog(ftMessage.GENERIC_DEBUG).error("OpenMarket/Flame/MySearch/View", e);
                                continue;
                            }
                            if ( enabledAssetTypes.containsKey(assetType) ) {
                          	 	String startItemName = atList.getValue("name");
                            	String selected = search != null && assetType.equals(search.getType()) ? " SELECTED" : "";
                            	%>
                            	<option value="<%= assetType %>"<%=selected%>/><%= startItemName %>
                            	<satellite:link assembler="query" outstring='advancedSearchURL' container='servlet'>
									<satellite:argument name='cs_environment' value='portal' />
									<satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
									<satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/SearchFront'/>
									<satellite:argument name='AssetType' value='<%=assetType%>'/>
									<satellite:argument name='cs_StartID' value='<%=startID%>'/>
                            	</satellite:link>
                            	<%
                                alSearchURLs.add(ics.GetVar("advancedSearchURL"));
                            }
                        }
                        %>
                       </select>
    				        </DIV>
    				 	</td>
    				</tr>
                <script type="text/javascript">
					<%
					if( ics.GetVar("cs_formmode").equalsIgnoreCase("DM") ) {
						%>
						var JSSearchDMURLs = new Array(<%=alSearchURLs.size()%>);
						<%
						for (int URLIndex = 0; URLIndex < alSearchURLs.size(); URLIndex++) {
							%>
							JSSearchDMURLs[<%=String.valueOf(URLIndex)%>] = '<%=alSearchURLs.get(URLIndex)%>';
							<%
                        }
					} else {
						%>
						var JSSearchContentURLs = new Array(<%=alSearchURLs.size()%>);
						<%
						for (int URLIndex = 0; URLIndex < alSearchURLs.size(); URLIndex++) {
							%>
							JSSearchContentURLs[<%=String.valueOf(URLIndex)%>] = '<%=alSearchURLs.get(URLIndex)%>';
                            <%
                        }
					}
					%>
                </script>
    				<tr>
   						<%--<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif" /></td>--%>
   					</tr>		
   					<tr>
    					<td class="form-shade" NOWRAP="NOWRAP" width="1%"><DIV class="form-label-inset"><xlat:stream key="dvin/Common/Search"/></DIV></td>
    					<td class="form-shade" colspan="2" NOWRAP="NOWRAP"><DIV class="form-inset">
    				        <!-- Note this list must match exactly the values in the select named fields -->
                        <select name="<%=normFormField.normalize(MySearch.SEARCH_FIELD)%>" size="1">
                        <%
                        for (int i = 0; i < SEARCH_FIELDS.length; i++) {
                            String field = SEARCH_FIELDS[i][0];
                            String xlat = SEARCH_FIELDS[i][1];
                            String selected = search != null && field.equals(search.getField()) ? " SELECTED" : "";
                            %>
                            <option value="<%=field%>"<%=selected%>/><xlat:stream key="<%=xlat%>"/>
                            <%
                        }
                        %>
                        </select>

    				        <span class="form-label-text">&nbsp;
								<xlat:stream key="dvin/UI/Search/for"/> &nbsp;</span><% String searchtext = search != null ? search.getText() : ""; %><input name="<%=normFormField.normalize(MySearch.SEARCH_TEXT)%>" value='<%=searchtext != null ? searchtext : ""%>' type="text" size="10" /><BR />
    				        </DIV>
    				 	</td>
    				</tr>
    				<tr>
   						<!--<td colspan="3" class="light-line-color"><img height="1" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif" /></td>-->
   					</tr>		
   					<tr>
   						<td colspan="3"><DIV class="form-label-inset"><xlat:stream key="dvin/UI/Search/SearchOptions"/>:</DIV>
   						<DIV class="form-inset">
   							<xlat:stream key="dvin/Common/SortResultsBy"/> &nbsp;
                   				 <select name="<%=normFormField.normalize(MySearch.SORT_BY)%>">
                   				     <%
                   				     for (int i = 0; i < SORT_FIELDS.length; i++) {
                   				         String field = SORT_FIELDS[i][0];
                   				         String xlat = SORT_FIELDS[i][1];
                   				         String selected = order != null && field.equals(order.getField()) ? " SELECTED" : "";
                   				         %>
                   				         <option value="<%=field%>"<%=selected%>/><xlat:stream key="<%=xlat%>"/>
                   				         <%
                   				     }
                   				     %>
                   				 </select>
   						</DIV>
   						</td>
   					</tr>



				</table>
			</td>
		</tr>
		<tr>
			<td background="<%=cs_imageDir%>/graphics/common/screen/shadow.gif">
				<img align="left" width="1" height="5" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
			</td>
		</tr>
		</table>

                <table width="100%">
                <tr>
                    
                    <td align="left">
                        <a href="javascript:void(0);" onclick="<portlet:namespace/>_advancedSearch();">
                        <span class="portlet-font">
                            <img src="<%= cs_imageDir %>/graphics/common/icon/doubleArrow.gif" width="15" height="12" border="0"/><xlat:stream key="dvin/UI/advancedsearch"/>
                        </span>
                        </a>
                    </td>

                    <xlat:lookup key="dvin/UI/NewSearch" varname="_XLAT_" escape="true"/>
                    <td colspan="3" align="right">
                        <a href="javascript:void(0);" onclick="<portlet:namespace/>_doSearch(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Search"/></ics:callelement></a>
                    </td>
                </tr>
                </table>


        <%
        if (search != null) {
            MySearch.setArgsSimpleSearch(args, search);
            ics.CallElement("OpenMarket/Flame/MySearch/SearchResults", args);
            args.removeAll();
        }
        %>
        </satellite:form>
        <%
    } else {
        %>
        <img width="250" height="15" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/><br/>
        <div class="portlet-font"><xlat:stream key="dvin/UI/NoStartMenuItemsForAssetSearch"/></div><br/>
        <%
    }
    %>
</cs:ftcs>
