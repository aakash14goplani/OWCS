<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>

<%//
// OpenMarket/Flame/MyAssignments/View
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
<%@ page import="com.fatwire.flame.portlets.MyAssignments"%>

<cs:ftcs>

    <%
    ics.CallElement("OpenMarket/Flame/Common/UIFramework/PortletCSFormMode", null);

    ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
    String cs_imageDir = ics.GetVar("cs_imagedir");
    %>
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>

    <script>
    function <portlet:namespace/>_actionToTake(url)
    {
        var win = window.open(url, "ActionText", "width=300,height=200,scrollbars=yes,toolbar=no,location=no,status=no,menubar=no,resizable=yes,directories=no,left=300,top=20");
        win.focus();
    }
    </script>

    <% ics.CallElement("OpenMarket/Flame/Common/Script/Popup", null); %>

    <portlet:defineObjects />
    <%
    String ASC = "asc";
    String DESC = "desc";

    // sort by  which column, e.g. addded date, name, ...
    String sortBy = ics.GetVar("sortby");
    if (sortBy == null)
        sortBy = "deadline";

    // sort order, desc or asc
    String sortOrder = ics.GetVar("sortorder");
    if (sortOrder == null)
        sortOrder = ASC;

    boolean bSortAsc = sortOrder.equals(ASC);

    boolean isMaximized = renderRequest.getWindowState().equals(WindowState.MAXIMIZED);
    String colspan = isMaximized?"19":"9";

    FTValList args = new FTValList();
    args.setValString("VARNAME", "userID");
    ics.runTag("USERMANAGER.GETLOGINUSER", args);
    args.removeAll();

    SortItem[] items;
    try {
        SortList assignmentList = new AssignmentList(ics, ics.GetSSVar("locale"), ics.GetVar("userID"),ics.GetSSVar("pubid"));
        items = assignmentList.getSortedList(sortBy, bSortAsc);
    } catch (AssetException e) {
        items = null;
    }

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
			Logging.error(MyAssignments.class.getName(), ics, "OpenMarket/Flame/MyAssignments/View", "[jsp]", e);
			e.printStackTrace();
		}
	}

    if (items != null && items.length > 0) {
        %>
        <satellite:link assembler="query" outstring="sortByTypeURL">
            <satellite:argument name="sortby" value="assettypedescription" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("assettypedescription")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
        </satellite:link>

        <satellite:link assembler="query" outstring="sortByNameURL">
            <satellite:argument name="sortby" value="assetname" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("assetname")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
        </satellite:link>

        <satellite:link assembler="query" outstring="sortByDateURL">
            <satellite:argument name="sortby" value="deadline" />
            <satellite:argument name="sortorder" value='<%= sortBy.equals("deadline")&&bSortAsc?DESC:ASC %>' />
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
        </satellite:link>

        <satellite:form name="<portlet:namespace/>_myassignmentslist" method="post">
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
                </td></tr>
            <tr class="section-header">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td nowrap><a href="<%=ics.GetVar("sortByTypeURL")%>" class="link-header"><xlat:stream key="dvin/Common/Type"/></a></td>
            <td>&nbsp;</td>
            <td nowrap><a href="<%=ics.GetVar("sortByNameURL")%>" class="link-header"><xlat:stream key="dvin/Common/Name"/></a></td>
            <td>&nbsp;</td>
            <% if (isMaximized) { %>
                <%--
                <satellite:link assembler="query" outstring="sortByDescriptionURL">
                    <satellite:argument name="sortby" value="assetdescription" />
                    <satellite:argument name="sortorder" value='<%= sortBy.equals("assetdescription")&&bSortAsc?DESC:ASC %>' />
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
                </satellite:link>
                <td><a href="<%=ics.GetVar("sortByDescriptionURL")%>"><div class="portlet-section-texportlet-section-text"><u><xlat:stream key="dvin/Common/Description"/></u></div></a></td>
                <td>&nbsp;</td>
                --%>
                <satellite:link assembler="query" outstring="sortByStatedescriptionURL">
                    <satellite:argument name="sortby" value="statedescription" />
                    <satellite:argument name="sortorder" value='<%= sortBy.equals("statedescription")&&bSortAsc?DESC:ASC %>' />
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
                </satellite:link>
                <td nowrap><a href="<%=ics.GetVar("sortByStatedescriptionURL")%>" class="link-header"><xlat:stream key="dvin/UI/WorkflowState"/></a></td>
                <td>&nbsp;</td>

                <satellite:link assembler="query" outstring="sortByAssignedbyURL">
                    <satellite:argument name="sortby" value="assignedby" />
                    <satellite:argument name="sortorder" value='<%= sortBy.equals("assignedby")&&bSortAsc?DESC:ASC %>' />
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
                </satellite:link>
                <td nowrap><a href="<%=ics.GetVar("sortByAssignedbyURL")%>" class="link-header"><xlat:stream key="dvin/UI/Wf/AssignedBy"/></a></td>
                <td>&nbsp;</td>

                <satellite:link assembler="query" outstring="sortByAssigndateURL">
                    <satellite:argument name="sortby" value="assigndate" />
                    <satellite:argument name="sortorder" value='<%= sortBy.equals("assigndate")&&bSortAsc?DESC:ASC %>' />
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
                </satellite:link>
                <td nowrap><a href="<%=ics.GetVar("sortByAssigndateURL")%>" class="link-header"><xlat:stream key="dvin/UI/Wf/AssignedDate"/></a></td>
                <td>&nbsp;</td>

                <satellite:link assembler="query" outstring="sortByActiontottakeURL">
                    <satellite:argument name="sortby" value="actiontotake" />
                    <satellite:argument name="sortorder" value='<%= sortBy.equals("actiontotake")&&bSortAsc?DESC:ASC %>' />
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
                </satellite:link>
                <td nowrap><a href="<%=ics.GetVar("sortByActiontottakeURL")%>" class="link-header"><xlat:stream key="dvin/Common/ActionToTake"/></a></td>
                <td>&nbsp;</td>
            <% } %>
            <td nowrap><a href="<%=ics.GetVar("sortByDateURL")%>" class="link-header"><xlat:stream key="dvin/Common/Due"/></a></td>

            <% if (isMaximized) { %>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            <% } %>
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
                               <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= previewPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconPreviewContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" TITLE="<%=ics.GetVar("_XLAT_")%>" /></a>
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
	                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconInspectContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" TITLE="<%=ics.GetVar("_XLAT_")%>" /></a>
	
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
	                    <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= editPopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconEditContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" TITLE="<%=ics.GetVar("_XLAT_")%>" /></a>

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
                        <a href="javascript:void(0);" onclick="<portlet:namespace/>_<%= deletePopup %>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" HSPACE="2" vspace="4" src="<%= cs_imageDir %>/graphics/common/icon/iconDeleteContent.gif" border="0" ALT="<%=ics.GetVar("_XLAT_")%>" TITLE="<%=ics.GetVar("_XLAT_")%>" /></a>

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
	                        <a title="<%=item.getColumnValue("assetdescription")%>" href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= item.getColumnValue("assetname") %></a>
	                    </div>
	                </td>
	                <td><br /></td>
	
	                <% if (isMaximized) { %>
	                    <td valign="top" align="left">
	                        <div class="portlet-section-text">
	                            <satellite:link assembler="query" outstring="assetStatusURL" container="servlet">
	                                <satellite:argument name="AssetType" value='<%= assettype %>' />
	                                <satellite:argument name="id" value='<%= assetid %>' />
	                                <satellite:argument name="cs_environment" value="portal" />
	                                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
	                                <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/StatusDetailsFront"/>
	                            </satellite:link>
	                            <% String onClickState = "csPopup('" + ics.GetVar("assetStatusURL") + "', 'ContentStatus')"; %>
	                            <xlat:lookup key="dvin/UI/Showlowerstatus" varname="_XLAT_"/>
	                            <xlat:lookup key="dvin/UI/Showlowerstatus" varname="mouseover" escape="true"/>
	                            <a title="<%= ics.GetVar("_XLAT_") %>" href="javascript:void(0)" onclick="<portlet:namespace/>_<%= onClickState %>"
	                                   onmouseover='window.status="<%= ics.GetVar("mouseover") %>";return true;'
	                                   onmouseout="window.status='';return true;"><%= item.getColumnValue("statedescription") %></a>
	                        </div>
	                    </td>
	                    <td><br /></td>
	
	                    <td valign="top" align="left">
	                        <div class="portlet-section-text">
	                            <%= item.getColumnValue("assignedby") %>
	                        </div>
	                    </td>
	                    <td><br /></td>
	
	                    <td valign="top" align="left">
	                        <div class="portlet-section-text">
	                            <%= item.getColumnValue("assigndate") %>
	                        </div>
	                    </td>
	                    <td><br /></td>
	
	                    <td valign="top" align="left">
	                        <div class="portlet-section-text">
	                            <%
	                            String actionToTake = item.getColumnValue("actiontotake");
	                            if (actionToTake.length() > 20) {
	                                %>
	                                <satellite:link assembler="query" outstring="actionToTakeURL" container="servlet">
	                                    <satellite:argument name="assignmentid" value='<%= item.getColumnValue("id") %>' />
	                                    <satellite:argument name="cs_environment" value="portal" />
	                                    <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
	                                    <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/Workflow/ActionToTake"/>
	                                </satellite:link>
	                                <%
	                                actionToTake = actionToTake.substring(0, 17) + " ...";
	                                String onClickActionText = "actionToTake('" + ics.GetVar("actionToTakeURL") + "')";
	                                %>
	                                <xlat.lookup key="dvin/UI/ShowactionTotake" varname="_XLAT_" escape="true"/>
	
	                                <a href="javascript:void(0)" onclick="<portlet:namespace/>_<%= onClickActionText %>"
	                                   onmouseover='window.status="<%= ics.GetVar("_XLAT_") %>";return true;'
	                                   onmouseout="window.status='';return true;"><%= actionToTake %></a>
	                                <%
	                            } else {
	                                %>
	                                <%= actionToTake %>
	                                <%
	                            }
	                            %>
	                        </div>
	                    </td>
	                    <td><br /></td>
	                <% } %>
	
	                <td valign="top" nowrap="nowrap" align="left">
	                    <div class="portlet-section-text" style="color: #c00">
	                    <%
	                    args.setValString("deadline", item.getColumnValue("deadline"));
	                    ics.CallElement("OpenMarket/Xcelerate/Actions/Workflow/FormatDeadline", args);
	                    args.removeAll();
	                    %>
	                    <br />
	                    </div>
	                </td>
	
	                <td><br /></td>
	
	                <% if (isMaximized) { %>
	                    <td valign="top" nowrap="nowrap" align="left">
	                        <div class="portlet-section-text">
	                            <satellite:link assembler="query" outstring="finishAssignmentURL" container="servlet">
	                                <satellite:argument name="AssetType" value='<%= item.getColumnValue("assettype") %>' />
	                                <satellite:argument name="id" value='<%= item.getColumnValue("assetid") %>' />
	                                <satellite:argument name="cs_environment" value="portal" />
	                                <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
	                                <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/SetStatusFront"/>
	                            </satellite:link>
	                            <xlat:lookup key="dvin/UI/AssetMgt/FinishMyAssignment" varname="mouseover" escape="true"/>
	                            <xlat:lookup key="dvin/UI/AssetMgt/FinishMyAssignment" varname="_xlat_"/>
	                            <% String onClickFinish = "csPopup('" + ics.GetVar("finishAssignmentURL") + "', 'FinishMyAssignment')"; %>
	                            <a href='javascript:void(0);'  onclick="<portlet:namespace/>_<%= onClickFinish %>" onmouseover='window.status="<%= ics.GetVar("mouseover")%>"; return true;' onmouseout="window.status='';return true"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Finish"/></ics:callelement></a>
	                        </div>
	                    </td>
	                    <td><br /></td>
	                <% } %>
	
	                </tr>
	            <%
	                bRowHighlight = !bRowHighlight;
	            }
            }
            %>

            </table>
            </td>
        </tr>

        <tr>
        <td background="<%= cs_imageDir %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td><td></td>
        </tr>

        <% if (moreListItems>0) { %>
            <!-- workaround for Weblogic8.1sp2 URL generation bug -->
            <satellite:link assembler="query" outstring="moreURL" windowstate="maximized">
                <satellite:argument name="sortby" value="<%= sortBy %>" />
                <satellite:argument name="sortorder" value="<%= sortOrder %>" />
                <satellite:argument name="pagename" value="OpenMarket/Flame/MyAssignments/View"/>
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
        args.setValString("VARNAME", "theCurrentUserName");
        ics.runTag("USERMANAGER.GETLOGINUSERNAME", args);
        args.removeAll();
        %>
        <img width="250" height="15" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/><br/>
        <div class="portlet-font"><xlat:stream key="dvin/UI/NoAssetsInAssignmentList"/></div><br/>
        <%
    }

    if (isMaximized) {
        %>
        <satellite:link assembler="query" outstring="pendingAssignmentsURL" container="servlet">
            <satellite:argument name="report_assignto" value="user" />
            <satellite:argument name="report_assets" value="all" />
            <satellite:argument name="report_state" value="all" />
            <satellite:argument name="users" value='<%= ics.GetVar("userID") %>' />
            <satellite:argument name="cs_environment" value="portal" />
            <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
            <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/PendingAssignments"/>
        </satellite:link>
        <%
        String onClickPending = "csPopup('" + ics.GetVar("pendingAssignmentsURL") + "', 'PendingAssignments')";
        %>
        <br/><xlat:lookup key="dvin/UI/Showmycompletedassignmentsstillpending" varname="_XLAT_" escape="true"/>
        <a href='javascript:void(0);'  onclick="<portlet:namespace/>_<%= onClickPending %>" onmouseover='window.status="<%= ics.GetVar("_XLAT_")%>"; return true;' onmouseout="window.status='';return true"> <span class="portlet-font"><img src="<%= cs_imageDir %>/graphics/common/icon/doubleArrow.gif" width="15" height="12" border="0"/><xlat:stream key="dvin/UI/Showmycompletedassignmentsstillpending"/></span></a><br/>
        <%
    }
    %>

</cs:ftcs>

