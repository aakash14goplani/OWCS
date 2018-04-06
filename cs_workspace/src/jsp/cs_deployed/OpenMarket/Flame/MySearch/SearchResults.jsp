<%@ page import="COM.FutureTense.Interfaces.FTValList,
                 com.openmarket.basic.interfaces.AssetException,
                 com.openmarket.xcelerate.sortlist.SearchItem,
                 com.openmarket.xcelerate.sortlist.SearchList,
                 com.fatwire.flame.portlets.FlamePortlet,
                 com.fatwire.flame.portlets.MySearch,
                 com.fatwire.flame.variation.Normalizer,
                 com.fatwire.flame.variation.NormalizerFactory,
                 COM.FutureTense.Interfaces.IList"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib uri="futuretense_cs/assettype.tld" prefix="assettype" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/MySearch/SearchResults
//
// input
//
// OUTPUT
//%>
<cs:ftcs>
	<portlet:defineObjects/>
    <%
    Normalizer normFormField = NormalizerFactory.getNormalizer(NormalizerFactory.FORM_FIELD, renderRequest, renderResponse, portletConfig);
    ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
    String cs_imageDir = ics.GetVar("cs_imagedir");
    %>
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>    
    <script>
        function <portlet:namespace/>_addCheck()
        {
            var form = document.forms["<portlet:namespace/>_mysearch"];
            for (var i=0; i<form.elements.length; i++) {
                if (form.elements[i].name=='<%=normFormField.normalize("activeitems")%>') {
                    if (form.elements[i].checked==true) {
                        form.elements['<%=normFormField.normalize(FlamePortlet.ACTION)%>'].value = "addtoactivelist";
                        form.submit();
                        return false;
                    }
                }
            }
            alert('<xlat:stream key="dvin/UI/PleaseselectitemstoaddtoAL" escape="true" encode="false"/>');
            return false;
        }

        function <portlet:namespace/>_selectAll()
        {
            var form = document.forms["<portlet:namespace/>_mysearch"];
            var checked = form.<%=normFormField.normalize("selectall")%>.checked;
            for (var i=0; i<form.elements.length; i++) {
                if (form.elements[i].name=='<%=normFormField.normalize("activeitems")%>')
                    form.elements[i].checked = checked;
            }
        }
    </script>

    <%
    int listSize = 10;
    int beginIndex = 1;
    String assettype = ics.GetVar("searchtype");

    String searchField = ics.GetVar("searchfield");
    String searchText = ics.GetVar("searchtext");
    String sortBy = ics.GetVar("sortby");
    String sortOrder = ics.GetVar("sortorder");
    boolean asc = sortOrder==null?true:sortOrder.equals("asc");
    %>
    <assettype:load name="type" type="<%= assettype %>" />
    <assettype:scatter name="type" prefix="AssetTypeObj" />
    <%
    ics.CallElement("OpenMarket/Flame/Common/Script/Popup", null);
    //load search engine specific string
    ics.CallElement("OpenMarket/Xcelerate/Actions/Search/seDescription", null);

    String useSearchIndex = ics.GetVar( "AssetTypeObj:usesearchindex" );
//out.println( "useSearchIndex=" +  useSearchIndex);
    SearchItem[] items = null;
    if( Integer.parseInt(useSearchIndex) == 1 )
    {
        ics.SetVar("AssetType",  assettype);
        ics.SetVar("seQuery", "");
        ics.SetVar("seType", "");
        ics.SetVar("seRelevance", "");
        ics.SetVar("sqlQueryend", "");
        ics.SetVar(searchField, searchText);
        //Restore the Search Variables for Executing , Editing and Saving Searches
        ics.CallElement("OpenMarket/Xcelerate/Actions/Search/ManageSaveSearch", null);
        //<!--Insert common fields' contribution to the query string-->
        ics.CallElement("OpenMarket/Xcelerate/Actions/Search/AppendSelectDetailsSE", null);
        //<!--Insert AssetType's contribution to the query string-->
        ics.CallElement("OpenMarket/Xcelerate/AssetType/" + assettype + "/AppendSelectDetailsSE", null);

       if( ics.GetVar("seQuery").equals("") )
       {
              try{
                    SearchList searchList = new SearchList(ics, ics.GetSSVar("locale"),
                            assettype, null, sortBy, asc);
                    items = searchList.getList();
              }
              catch (AssetException ex) {
                   items = null;
              }
       }
       else
       { //Start a valid Search Engine search
        //Trim off the leading " AND ", which was blindly added before each subterm
        ics.SetVar("seQuery", ics.GetVar("seQuery").substring(5) );
       String  propselimit = ics.GetProperty("xcelerate.seLimit", "futuretense_xcel.ini", true);
       String  searchengine= ics.GetProperty("cs.searchengine", "futuretense.ini", true);
       %>
       <ics:search index='<%=ics.GetVar("AssetTypeObj:indexfile")%>'
                   listname="seResults"
                   searchterm='<%=ics.GetVar("seQuery")%>'
                   relevanceterm='<%=ics.GetVar("seRelevance")%>'
                   maxresults='<%=propselimit%>'
                   searchengine="<%=searchengine%>" />

       <%
              // errno -824 is a warning that search is inaccurate due to backend
              //       indexing. Need save this err no because it may be overwritten
            if( ics.GetVar("asyncSearchWarnno") != null && ics.GetVar("asyncSearchWarnno").equals("-824") )
            {
                ics.SetVar("SearchNotUpToDateWarnNo", "-824");
            }

           IList lresults = ics.GetList("seResults");
           if( lresults != null && lresults.numRows() >= 1 )
           {
              try{
                    SearchList searchList = new SearchList(ics, ics.GetSSVar("locale"),
                            assettype, ics.GetList("seResults"), sortBy, asc);
                    items = searchList.getList();
              }
              catch (AssetException ex) {
                   items = null;
              }
           }
           else{
               items = null;
           }
       } // else if seQuery is not empty
    } //end use Search index
    else
    {
        try {
            SearchList searchList = new SearchList(ics, ics.GetSSVar("locale"),
                    assettype, searchField, searchText, sortBy, asc);
            items = searchList.getList();
        } catch (AssetException ex) {
            items = null;
        }
    }
 if( ics.GetVar("SearchNotUpToDateWarnNo") != null && ics.GetVar("SearchNotUpToDateWarnNo").equals("-824") )
 {  %>
      <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
            <ics:argument name="elem" value="SearchNotUpToDate"/>
    	    <ics:argument name="severity" value="warning"/>
            <ics:argument name="AssetType" value="<%= assettype %>"/>
      </ics:callelement>
    <%
 }
    String colspan = "13";
    if (items != null && items.length > 0) {
        FTValList args = new FTValList();
        args.setValString("VARNAME", "userid");
        ics.runTag("USERMANAGER.GETLOGINUSER", args);
        args.removeAll();

        String beginIndexStr = ics.GetVar("beginindex");
        if (beginIndexStr!=null) {
            try {
                beginIndex = Integer.parseInt(beginIndexStr);
            } catch (NumberFormatException e) {
                beginIndex = 1;
            }
        }
        int lastIndex = beginIndex + listSize - 1;
        if (lastIndex > items.length) lastIndex = items.length;

        // used by messages
        ics.SetVar("startingPoint", beginIndex);
        ics.SetVar("LastItem", lastIndex);
        ics.SetVar("TotalResults", items.length);
        ics.SetVar("ResultLimit", listSize);
        %>

        <table cellpadding="0" cellspacing="0" border="0" WIDTH="98%">
        <tr>
            <td nowrap="nowrap" align="left" class="portlet-font">
                <xlat:stream key="dvin/UI/ItemsstartingPointLastItemTotalResults"/>
                <%
                if (sortBy != null) {
                    %><xlat:stream key="dvin/UI/sortedby"/> &quot;<%= sortBy %>&quot;<%
                }
                %>
                <br/>
                <xlat:stream key="dvin/Common/Type"/>: <string:stream value='<%= ics.GetVar("AssetTypeObj:description") %>'/>
                <br/>
            </td>
            <td nowrap="nowrap" align="right" class="portlet-font">
                <%
                if (beginIndex > 1) {
                    %>
                    <satellite:link assembler="query" outstring="previousURL" >
                        <satellite:argument name="<%=FlamePortlet.ACTION%>" value="<%=MySearch.ACTION_DOSEARCH%>" />
                        <satellite:argument name="searchtype" value="<%= assettype %>" />
                        <satellite:argument name="searchfield" value="<%= searchField %>" />
                        <satellite:argument name="searchtext" value='<%= searchText==null?"":searchText %>' />
                        <satellite:argument name="sortby" value="<%= sortBy %>" />
                        <satellite:argument name="sortorder" value="<%= sortOrder %>" />
                        <satellite:argument name="beginindex" value="<%= String.valueOf(beginIndex - listSize) %>" />
                    </satellite:link>
                    <a href="<%=ics.GetVar("previousURL") %>">
                        <img src="<%= cs_imageDir %>/graphics/common/icon/leftArrow.gif" height="12" width="11" border="0"/>
                        <xlat:stream key="dvin/UI/PreviousResultLimit"/>
                    </a> |
                    <%
                }
                if (lastIndex < items.length) {
                    int nextNum = items.length - lastIndex;
                    if (nextNum > listSize)
                        nextNum = listSize;
                    %>
                    <satellite:link assembler="query" outstring="nextURL" >
                        <satellite:argument name="<%=FlamePortlet.ACTION%>" value="<%=MySearch.ACTION_DOSEARCH%>" />
                        <satellite:argument name="searchtype" value="<%= assettype %>" />
                        <satellite:argument name="searchfield" value="<%= searchField %>" />
                        <satellite:argument name="searchtext" value='<%= searchText==null?"":searchText %>' />
                        <satellite:argument name="sortby" value="<%= sortBy %>" />
                        <satellite:argument name="sortorder" value="<%= sortOrder %>" />
                        <satellite:argument name="beginindex" value="<%= String.valueOf(lastIndex + 1) %>" />
                    </satellite:link>
                    <a href="<%=ics.GetVar("nextURL") %>">
                        <xlat:stream key="dvin/Common/Next"/>&nbsp;<%= nextNum %>
                        <img src="<%= cs_imageDir %>/graphics/common/icon/rightArrow.gif" height="12" width="11" border="0"/>
                    </a>
                    <%
                }
                %>
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        </table>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
        </tr>
        <tr>
            <td>
        <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 1px 1px;">
            <tr><td colspan="<%=colspan%>" class="tile-highlight">
                    <img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
                </td></tr>
            <tr class="section-header">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <!--<td><div class="portlet-form-label"><xlat:stream key="dvin/Common/Type"/></div></td-->
            <td>&nbsp;</td>
            <td><div><xlat:stream key="dvin/Common/Name"/></div></td>
            <td>&nbsp;</td>
            <td><div><xlat:stream key="dvin/Common/Description"/></div></td>
            <td>&nbsp;</td>
            <td nowrap><div><xlat:stream key="dvin/AT/Common/Status"/></div></td>
            <td>&nbsp;</td>
            <td nowrap><div><xlat:stream key="dvin/Common/Modified"/></div></td>
            <td>&nbsp;</td>
            <td>
                <input type="checkbox" onclick="return <portlet:namespace/>_selectAll();" name="<portlet:namespace/>_selectall" />
            </td>
            <td class="tile-c">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="<%= colspan %>" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
        </tr>    

        <%
            boolean bRowHighlight = false;
            for (int i=beginIndex-1; i<lastIndex; i++) {
                SearchItem item = items[i];
                String assetid = item.getColumnValue("assetid");

            if (i != 0) {
                %>
                <tr>
                    <td colspan="<%= colspan %>" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
                </tr>
                <%
            }
            %>
            <tr class="<%= bRowHighlight?"portlet-section-alternate":"portlet-section-body" %>" >
                <td><br /></td>
                <td valign="top" nowrap="nowrap">

					<%
					FTValList vl = new FTValList();
					String previewURL = "previewURL";
					vl.setValString("VARNAME", previewURL );
					vl.setValString("ASSETTYPE", assettype);
					vl.setValString("ASSETID", assetid);
					vl.setValString("PUBID", ics.GetSSVar("pubid") );
					ics.runTag("PREVIEWURL.MAKEURL", vl );
					String sPreviewURL = ics.GetVar(previewURL);
					%>
                    <xlat:lookup key="dvin/Common/PreviewThisItem" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/Common/PreviewThisItem" varname="mouseover" escape="true"/>

                    <% //previewURL could be null because of no available temple. 
                       String previewPopup = null;
                       if( sPreviewURL != null && sPreviewURL.trim().length()>0)
                       {
                           previewPopup = "csPopup('" + ics.GetVar(previewURL) + "', 'PreviewContent')";
                           %>
                           <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= previewPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconPreviewContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>
                           <%
                       }
                    %>

                    <satellite:link assembler="query" outstring="showContentURL" container="servlet">
                        <satellite:argument name="AssetType" value="<%= assettype %>" />
                        <satellite:argument name="id" value="<%= assetid %>" />
                        <satellite:argument name="cs_environment" value="portal" />
                        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
                        <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/ContentDetailsFront"/>
                    </satellite:link>
                    <xlat:lookup key="dvin/Common/InspectThisItem" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/Common/InspectThisItem" varname="mouseover" escape="true"/>
                    <% String showPopup = "csPopup('" + ics.GetVar("showContentURL") + "', 'ShowContent')"; %>
                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconInspectContent.gif" border="0" ALT="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>

                    <satellite:link assembler="query" outstring="editContentURL" container="servlet">
                        <satellite:argument name="AssetType" value="<%= assettype %>" />
                        <satellite:argument name="id" value="<%= assetid %>" />
                        <satellite:argument name="cs_environment" value="portal" />
                        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
                        <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/EditFront"/>
                    </satellite:link>
                    <xlat:lookup key="dvin/Common/EditThisItem" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/Common/EditThisItem" varname="mouseover" escape="true"/>
                    <% String editPopup = "csPopup('" + ics.GetVar("editContentURL") + "', 'EditContent')"; %>
                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= editPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconEditContent.gif" border="0" ALT="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>

                    <satellite:link assembler="query" outstring="deleteContentURL" container="servlet">
                        <satellite:argument name="AssetType" value="<%= assettype %>" />
                        <satellite:argument name="id" value="<%= assetid %>" />
                        <satellite:argument name="cs_environment" value="portal" />
                        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
                        <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/DeleteFront"/>
                    </satellite:link>
                    <xlat:lookup key="dvin/Common/Delete" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/Common/Delete" varname="mouseover" escape="true"/>
                    <% String deletePopup = "csPopup('" + ics.GetVar("deleteContentURL") + "', 'ShowContent')"; %>
                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= deletePopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconDeleteContent.gif" border="0" ALT="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>


                    <br />
                </td>

                <!--td><br /></td>
                <td valign="top" align="left" nowrap="nowrap">
                    <div class="portlet-section-text">
                        <%= item.getColumnValue("assettypedescription") %>
                    </div>
                </td-->
                <td><br /></td>

                <td valign="top" align="left">
                    <div class="portlet-section-text">
                        <xlat:lookup key="dvin/UI/ShowContent" varname="_XLAT_" escape="true"/>
                        <a href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= item.getColumnValue("assetname") %></a>
                    </div>
                </td>
                <td><br /></td>

                <td valign="top" align="left">
                <div class="portlet-section-text">
                    <%= item.getColumnValue("assetdescription") %>
                </div>
                </td>
                <td><br /></td>

                <td valign="top" nowrap="nowrap" align="left">
                    <div class="portlet-section-text">
                         <satellite:link assembler="query" outstring="assetStatusURL" container="servlet">
                            <satellite:argument name="AssetType" value='<%= assettype %>' />
                            <satellite:argument name="id" value='<%= assetid %>' />
                            <satellite:argument name="cs_environment" value="portal" />
                            <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
                            <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/StatusDetailsFront"/>
                        </satellite:link>
                        <% String onclickState = "csPopup('" + ics.GetVar("assetStatusURL") + "', 'ContentStatus')"; %>
                        <xlat:lookup key="dvin/UI/Showlowerstatus" varname="_XLAT_"/>
                        <xlat:lookup key="dvin/UI/Showlowerstatus" varname="mouseover" escape="true"/>
                        <a title="<%= ics.GetVar("_XLAT_") %>" href="javascript:void(0)" onclick="<portlet:namespace/>_<%= onclickState %>"
                               onmouseover='window.status="<%= ics.GetVar("mouseover") %>";return true;'
                               onmouseout="window.status='';return true;"><%= item.getColumnValue("statusdescription") %></a>
                    </div>
                </td>
                <td><br /></td>
                <%--
                <td valign="top" align="left">
                <div class="portlet-section-text">
                    <%= item.getColumnValue("updatedby") %>
                </div>
                </td>
                <td><br /></td>
                --%>
                <td valign="top" align="left"><div class="portlet-section-text"><%= item.getColumnValue("updateddate") %></div></td>
                <td><br /></td>

                <td valign="top" nowrap="nowrap">
                    <%
                    StringBuffer err = new StringBuffer();
                    ics.ClearErrno();
                    ics.SetVar("assetid", assetid);
                    ics.SelectTo("ActiveList", "*", "userid,assetid", null, 1, null, true, err);
                    if (ics.GetErrno() == -101) {
                        %><input type="checkbox" name="<%=normFormField.normalize("activeitems")%>" value='<%= assetid + ";" + assettype %>' /><%
                    } else {
                        %>&nbsp;<%
                    }
                    %><br />
                </td>

                <td><br /></td>
                </tr>
                <%
                bRowHighlight = !bRowHighlight;
            }
            %>

            </table>
            </td>
        </tr>
        <tr>
            <td background="<%= cs_imageDir %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td><td></td>
        </tr>

        <xlat:lookup key="dvin/UI/AddselecteditemstoyourActiveList" varname="_XLAT_" escape="true"/>
        <tr><td colspan="3" align="right"><a class="inline-right" href="javascript:void(0);" onclick="<portlet:namespace/>_addCheck(); return false;" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddtoMyBookmarks"/></ics:callelement></a></td></tr>

        </table>

        <%
    } else {
        %><div class="portlet-font" style="color: #c00"><xlat:stream key="dvin/UI/NoAssetTypeObjpluralwerefound"/></div><%
    }
    %>
    <%--
    <satellite:link assembler="query" outstring="doneURL" portleturltype="action" windowstate="normal" >
        <satellite:argument name="pagename" value="OpenMarket/Flame/MySearch/View"/>
        <satellite:argument name="<%=FlamePortlet.ACTION%>" value="<%=MySearch.ACTION_DONE%>"/>
    </satellite:link>
    --%>
    <!-- workaround for Weblogic8.1sp2 URL generation bug -->
    <satellite:link assembler="query" outstring="doneURL" portleturltype="action">
        <satellite:argument name="pagename" value="OpenMarket/Flame/MySearch/View"/>
        <satellite:argument name="<%=FlamePortlet.ACTION%>" value="<%=MySearch.ACTION_DONE%>"/>
		<satellite:argument name="windowstate" value="normal"/>
		<satellite:argument name="_state" value="normal"/>
		<satellite:argument name="window.newWindowState" value="NORMAL"/>
    </satellite:link>
    <ics:setvar name="doneURL" value='<%= ics.GetVar("doneURL") + "&#38;_state=normal&#38;window.newWindowState=NORMAL" %>' />
    <table cellpadding="0" cellspacing="0" border="0" WIDTH="100%">
    <tr>
        <td nowrap="nowrap" align="center">
            <xlat:lookup key='dvin/Common/Done' varname='_XLAT_' escape='true'/>
            <a href='<%= ics.GetVar("doneURL") %>' onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Done"/></ics:callelement></a>
        </td>
    </tr>
    </table>
</cs:ftcs>