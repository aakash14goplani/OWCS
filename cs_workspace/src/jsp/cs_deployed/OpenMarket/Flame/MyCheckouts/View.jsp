<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>

<%//
// OpenMarket/Flame/MyCheckouts/View
//
// input
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.*" %>
<%@ page import="javax.portlet.*"%>
<%@ page import="com.openmarket.xcelerate.sortlist.*"%>
<%@ page import="com.openmarket.basic.interfaces.AssetException"%>
<%@ page import="com.openmarket.basic.common.SortList"%>
<%@ page import="com.openmarket.basic.common.SortItem"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="com.openmarket.logging.Logging"%>
<%@ page import="com.fatwire.flame.portlets.MyCheckouts"%>

<cs:ftcs>
    <%
    ics.CallElement("OpenMarket/Flame/Common/UIFramework/PortletCSFormMode", null);

    ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
    String cs_imageDir = ics.GetVar("cs_imagedir");

    ics.CallElement("OpenMarket/Flame/Common/Script/Popup", null);
    %>

    <portlet:defineObjects />
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>
    <%
    String ASC = "asc";
    String DESC = "desc";

    // sort by  which column, e.g. addded date, name, ...
    String sortBy = ics.GetVar("sortby");
    if (sortBy == null)
        sortBy = "checkoutdate";

    // sort order, desc or asc
    String sortOrder = ics.GetVar("sortorder");
    if (sortOrder == null)
        sortOrder = DESC;

    boolean bSortAsc = sortOrder.equals(ASC);

    boolean isMaximized = renderRequest.getWindowState().equals(WindowState.MAXIMIZED);
    String colspan = isMaximized?"13":"11";

    FTValList args = new FTValList();
    args.setValString("VARNAME", "userName");
    ics.runTag("USERMANAGER.GetLoginUserName", args);
    args.removeAll();

	// for DocumentManagemnet, display only asset type enabled for CSDocLink
	Hashtable enabledAssetTypes = new Hashtable();
	if ( ics.GetVar("cs_formmode").equals("DM") )
	{
		args.setValString( "CLIENTAPP", "CSDocLink");
		args.setValString( "SITE", ics.GetSSVar("pubid"));
		args.setValString("LISTVARNAME", "enabledAssetTypes");
		ics.runTag("EXTERNALCLIENTSMANAGER.GetEnabledAssetTypesForAClient", args);
		args.removeAll();
	}
	IList enabledList = ics.GetList("enabledAssetTypes");
	if (enabledList!=null && enabledList.hasData()) {
		try {
			for(int i = 1; i <= enabledList.numRows(); i++) {
				enabledList.moveTo(i);
				enabledAssetTypes.put( enabledList.getValue("assettype"), enabledList.getValue("assettype") );
			}
		} catch(NoSuchFieldException e) {
			Logging.error(MyCheckouts.class.getName(), ics, "OpenMarket/Flame/MyCheckouts/View", "[jsp]", e);
			e.printStackTrace();
		}
	}

    SortItem[] items;
    try {
        SortList checkoutList = new CheckoutList(ics, ics.GetSSVar("locale"), ics.GetVar("userName"),ics.GetSSVar("pubid"));
        items = checkoutList.getSortedList(sortBy, bSortAsc);
    } catch (AssetException e) {
        items = null;
    }

    if (items != null && items.length > 0) {
        %>

        <satellite:link assembler="query" outstring="sortByTypeURL">
            <satellite:argument name="sortby" value="assettypedescription" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("assettypedescription")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyCheckouts/View"/>
        </satellite:link>

        <satellite:link assembler="query" outstring="sortByNameURL">
            <satellite:argument name="sortby" value="assetname" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("assetname")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyCheckouts/View"/>
        </satellite:link>

        <satellite:link assembler="query" outstring="sortByDateURL">
            <satellite:argument name="sortby" value="checkoutdate" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("checkoutdate")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyCheckouts/View"/>
        </satellite:link>

        <satellite:form id="<portlet:namespace/>_mycheckoutslist" method="post">
          <property:get param="xcelerate.charset" inifile="futuretense_xcel.ini" varname="propcharset"/>
          <INPUT TYPE="HIDDEN" NAME="_charset_" VALUE="<%=ics.GetVar("propcharset")%>"/>

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
        </tr>
        <tr>
            <td>
                <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 1px 1px;">
                <tr><td colspan="<%=colspan%>" class="tile-highlight">
                    <img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
                    </td>
                </tr>
                <tr class="section-header">
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><a href="<%=ics.GetVar("sortByTypeURL")%>" class="link-header"><xlat:stream key="dvin/Common/Type"/></a></td>
                <td>&nbsp;</td>
                <td><a href="<%=ics.GetVar("sortByNameURL")%>" class="link-header"><xlat:stream key="dvin/Common/Name"/></a></td>
                <td>&nbsp;</td>
                <% if (isMaximized) { %>
                    <satellite:link assembler="query" outstring="sortByDescriptionURL">
                        <satellite:argument name="sortby" value="assetdescription" />
                        <satellite:argument name="sortorder" value='<%= sortBy.equals("assetdescription")&&bSortAsc?DESC:ASC %>' />
                        <satellite:argument name="pagename" value="OpenMarket/Flame/MyCheckouts/View"/>
                    </satellite:link>
                    <td><a href="<%=ics.GetVar("sortByDescriptionURL")%>" class="link-header"><xlat:stream key="dvin/Common/Description"/></a></td>
                    <td>&nbsp;</td>
                <% } %>
                <td nowrap><a href="<%=ics.GetVar("sortByDateURL")%>" class="link-header"><xlat:stream key="dvin/Common/CheckoutDate"/></a></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td class="tile-c">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="<%= colspan %>" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
            </tr>
        <%
            int maxListSize = 5;
            int listSize = items.length;
            int moreListItems = 0;

            if (!isMaximized && (listSize > maxListSize + 1)) {
                moreListItems = listSize - maxListSize;
                listSize = maxListSize;
            }

            boolean bRowHighlight = false;
            for (int i=0; i<listSize; i++) {
                SortItem item = items[i];
                String assetid = item.getColumnValue("assetid");
                String assettype = item.getColumnValue("assettype");
                if ( !ics.GetVar("cs_formmode").equals("DM") || enabledAssetTypes.containsKey(assettype) )
                {
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
                               <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= previewPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconPreviewContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"/></a>
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
	                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconInspectContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>
	
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
	                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= editPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconEditContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></a>

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

	                <td><br /></td>
	                <td valign="top" align="left" nowrap="nowrap">
	                    <div class="portlet-section-text">
	                        <%= item.getColumnValue("assettypedescription") %>
	                    </div>
	                </td>
	                <td><br /></td>
	                <td valign="top" align="left">
	                    <div class="portlet-section-text">
	                        <xlat:lookup key="dvin/UI/ShowContent" varname="_XLAT_" escape="true"/>
	                        <% if (isMaximized) { %>
	                            <a href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= item.getColumnValue("assetname") %></a>
	                        <% } else { %>
	                            <a title="<%=item.getColumnValue("assetdescription")%>" href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= item.getColumnValue("assetname") %></a>
	                        <% } %>
	                    </div>
	                </td>
	                <td><br /></td>
	
	                <% if (isMaximized) { %>
	                    <td valign="top" align="left">
	                        <div class="portlet-section-text">
	                            <%= item.getColumnValue("assetdescription") %>
	                        </div>
	                    </td>
	                    <td><br /></td>
	                <% } %>
	
	                <td valign="top" nowrap="nowrap" align="left">
	                    <div class="portlet-section-text">
	                        <%= item.getColumnValue("checkoutdate").substring(0,10) %><br />
	                    </div>
	                </td>
	
	                <td><br /></td>
	                <td valign="top" nowrap="nowrap" align="left">
	                    <div class="portlet-section-text">
	                        <xlat:lookup key="dvin/UI/Checkinthisitem" varname="_XLAT_" escape="true"/>
	                        <xlat:lookup key="dvin/UI/Checkinthisitem" varname="_xlat_checkin"/>
	                        <satellite:link assembler="query" outstring="checkinURL" container="servlet">
	                            <satellite:argument name="AssetType" value='<%= item.getColumnValue("assettype") %>' />
	                            <satellite:argument name="id" value='<%= item.getColumnValue("assetid") %>' />
	                            <satellite:argument name="cs_environment" value="portal" />
	                            <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
	                            <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/CommitFront"/>
	                        </satellite:link>
	                        <% String onclick = "csPopup('" +  ics.GetVar("checkinURL") + "', 'CheckinAsset')"; %>
	                        <a href='javascript:void(0);'  onclick="<portlet:namespace/>_<%= onclick %>" onmouseover='window.status="<%= ics.GetVar("_XLAT_")%>"; return true;' onmouseout="window.status='';return true"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/CheckIn"/></ics:callelement></a>
	                    </div>
	            </td>
	
	                <td><br /></td>
	                </tr>
	            <%
	                bRowHighlight = !bRowHighlight;
	             }
	             }
          %>

            </table>
            </td>
        <tr>
            <td background="<%= cs_imageDir %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
        </tr>

         <% if (moreListItems>0) { %>
            <!-- workaround for Weblogic8.1sp2 URL generation bug -->
            <satellite:link assembler="query" outstring="moreURL" windowstate="maximized" >
                <satellite:argument name="sortby" value="<%= sortBy %>" />
                <satellite:argument name="sortorder" value="<%= sortOrder %>" />
                <satellite:argument name="pagename" value="OpenMarket/Flame/MyCheckouts/View"/>
            </satellite:link>
            <ics:setvar name="moreURL" value='<%= ics.GetVar("moreURL") + "&#38;_state=maximized&#38;window.newWindowState=MAXIMIZED" %>' />

            <tr>
                <td colspan="3" align="left">
                    <a href='<%= ics.GetVar("moreURL") %>' >
                        <ics:setvar name="num" value="<%= String.valueOf(moreListItems) %>" />
                        <div class="portlet-font">&nbsp;<xlat:stream key="dvin/UI/NumMoreDot"/></div>
                    </a>

                </td>
            </tr>
        <% } %>

        </table>
        </satellite:form>

        <%
    } else {
        %>
        <img width="250" height="15" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/><br/>
        <div class="portlet-font"><xlat:stream key="dvin/UI/NoAssetsInCheckoutList"/></div><br/>
        <%
    }
    %>

</cs:ftcs>

