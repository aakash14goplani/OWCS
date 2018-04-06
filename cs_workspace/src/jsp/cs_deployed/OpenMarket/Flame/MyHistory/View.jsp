<%@ page import="java.util.ArrayList,
                 java.util.Hashtable,
                 java.util.StringTokenizer,
                 javax.portlet.WindowState,
                 COM.FutureTense.Interfaces.FTValList,
                 COM.FutureTense.Interfaces.IList,
                 com.openmarket.xcelerate.asset.AssetType,
                 com.openmarket.logging.Logging,
                 com.fatwire.flame.portlets.FlamePortlet,
                 com.fatwire.flame.portlets.MyHistory,
                 com.fatwire.flame.variation.Normalizer,
                 com.fatwire.flame.variation.NormalizerFactory"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/MyHistory/View
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
	<portlet:defineObjects/>
    <%
    Normalizer normFormField = NormalizerFactory.getNormalizer(NormalizerFactory.FORM_FIELD,
        renderRequest, renderResponse, portletConfig);
    ics.CallElement("OpenMarket/Flame/Common/UIFramework/PortletCSFormMode", null);

    ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
    String cs_imageDir = ics.GetVar("cs_imagedir");
    %>
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>
    <script>
        function <portlet:namespace/>_removeCheck()
        {
            var form = document.forms["<portlet:namespace/>_myhistory"];
            for (var i=0; i<form.elements.length; i++) {
                if (form.elements[i].name=='<%=normFormField.normalize("historyitems")%>') {
                    if (form.elements[i].checked==true) {
                        form.submit();
                        return false;
                    }
                }
            }
            alert('<xlat:stream key="dvin/UI/PleaseselectitemstoremovefromAL" escape="true" encode="false"/>');
            return false;
        }

        function <portlet:namespace/>_selectAll()
        {
            var form = document.forms["<portlet:namespace/>_myhistory"];
            var checked = form.<%=normFormField.normalize("selectall")%>.checked;
            for (var i=0; i<form.elements.length; i++) {
                if (form.elements[i].name=='<%=normFormField.normalize("historyitems")%>')
                    form.elements[i].checked = checked;
            }
        }
    </script>

    <% ics.CallElement("OpenMarket/Flame/Common/Script/Popup", null); %>

    <%
    boolean isMaximized = renderRequest.getWindowState().equals(WindowState.MAXIMIZED);
    String colspan = isMaximized?"11":"9";

	// for DocumentManagemnet, display only asset type enabled for CSDocLink
	Hashtable enabledAssetTypes = new Hashtable();
	if ( ics.GetVar("cs_formmode").equals("DM") )
	{
		FTValList args = new FTValList();
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
			Logging.error(MyHistory.class.getName(), ics, "OpenMarket/Flame/MyHistory/View", "[jsp]", e);
			e.printStackTrace();
		}
	}

    String history = ics.GetSSVar("portalhistory");
    if (history != null && history.length() > 0) {
        %>
        <satellite:link assembler="query" outstring="removeURL" portleturltype="action">
            <satellite:argument name="<%=FlamePortlet.ACTION%>" value="removeitems"/>
            <satellite:argument name="pagename" value="OpenMarket/Flame/MyHistory/View"/>
        </satellite:link>

        <satellite:form name='<portlet:namespace/>_myhistory' method="post" action="<%=ics.GetVar("removeURL")%>">
          <property:get param="xcelerate.charset" inifile="futuretense_xcel.ini" varname="propcharset"/>
          <INPUT TYPE="HIDDEN" NAME="_charset_" VALUE="<%=ics.GetVar("propcharset")%>"/>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
        </tr>
        <tr>
            <td>
                <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 0px 1px;">
                    <tr><td colspan="<%=colspan%>" class="tile-highlight">
                        <img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
                    </td></tr>
                    <tr class="section-header">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><div><xlat:stream key="dvin/Common/Type"/></div></td>
                    <td>&nbsp;</td>
                    <td><div><xlat:stream key="dvin/Common/Name"/></div></td>
                    <td>&nbsp;</td>
                    <% if (isMaximized) { %>
                        <td><div><xlat:stream key="dvin/Common/Description"/></div></td>
                        <td>&nbsp;</td>
                    <% } %>
                    <td>
                        <input type="checkbox" onclick='return <portlet:namespace/>_selectAll();' name='<%=normFormField.normalize("selectall")%>' />
                    </td>
                    <td class="tile-c">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="<%= colspan %>" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
                </tr>    

                <%
                ArrayList assets = new ArrayList();
                StringTokenizer st = new StringTokenizer(history, ";");
                while (st.hasMoreTokens())
                     assets.add((String)st.nextToken());

                int maxListSize = 5;
                int listSize = assets.size();
                int moreListItems = 0;

                if (!isMaximized && (listSize > maxListSize + 1)) {
                    moreListItems = listSize - maxListSize;
                    listSize = maxListSize;
                }

                boolean bRowHighlight = false;
                for (int i=0; i<listSize; i++) {
                    String assetStr = (String)assets.get(i);
                    int index = assetStr.indexOf(",");
                    String assetid = assetStr.substring(0, index);
                    String assettype = assetStr.substring(index+1);

	                if ( !ics.GetVar("cs_formmode").equals("DM") || enabledAssetTypes.containsKey(assettype) )
	                {
	                    String assettypeDesc;
	                    AssetType at = AssetType.Load(ics,assettype );
	                    if ( at!=null )
	                        assettypeDesc = at.Get(AssetType.DESCRIPTION);
	                    else
	                        assettypeDesc = assettype;
	                    %>
	                    <asset:list list='assetlist' type='<%= assettype %>' field1='id' value1='<%= assetid %>'/>
	                    <ics:listget listname="assetlist" fieldname="name" output="assetname"/>
	                    <ics:listget listname="assetlist" fieldname="description" output="assetdesc"/>
	                    <%
	                    String assetname = ics.GetVar("assetname");
	                    String assetdesc = ics.GetVar("assetdesc");
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
	                                <%= assettypeDesc %>
	                            </div>
	                        </td>
	                        <td><br /></td>
	                        <td valign="top" align="left">
	                            <div class="portlet-section-text">
	                                <xlat:lookup key="dvin/UI/ShowContent" varname="_XLAT_" escape="true"/>
	                                <% if (isMaximized) { %>
	                                    <a href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= assetname %></a>
	                                <% } else { %>
	                                    <a title="<%= assetdesc %>" href='javascript:void(0);' onclick="<portlet:namespace/>_<%= showPopup %>" onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true"><%= assetname %></a>
	                                <% } %>
	                            </div>
	                        </td>
	                        <td><br /></td>
	
	                        <% if (isMaximized) { %>
	                            <td valign="top" align="left"><div class="portlet-section-text"><%= assetdesc %></div></td>
	                            <td><br /></td>
	                        <% } %>
	
	                        <td valign="top" nowrap="nowrap">
                            <input type="checkbox" name="<%=normFormField.normalize("historyitems")%>" value="<%= assetid %>" />
	                            <br />
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
            </tr>
        <tr>
            <td background="<%= cs_imageDir %>/graphics/common/screen/blackdot.gif" valign="top" height="1"><img width="1" height="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
        <tr>
        <td background="<%= cs_imageDir %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td><td></td>
        </tr>

        <tr>
            <td colspan="3">
            <table width="100%">
            <tr>
                <% if (moreListItems>0) { %>
                    <!-- workaround for Weblogic8.1sp2 URL generation bug -->
                    <satellite:link assembler="query" outstring="moreURL"  windowstate="maximized">
                        <satellite:argument name="pagename" value="OpenMarket/Flame/MyHistory/View"/>
                    </satellite:link>
                    <ics:setvar name="moreURL" value='<%= ics.GetVar("moreURL") + "&#38;_state=maximized&#38;window.newWindowState=MAXIMIZED" %>' />

                    <td align="left">
                        <a href='<%= ics.GetVar("moreURL") %>' >
                            <ics:setvar name="num" value="<%= String.valueOf(moreListItems) %>" />
                        <div class="portlet-font"><xlat:stream key="dvin/UI/NumMoreDot"/></div>
                        </a>
                    </td>

	                <xlat:lookup key="dvin/Common/RemoveSelectedItemsActiveList" varname="_XLAT_" escape="true"/>
	                <td align="right">
	                    <a class="inline-right" href="javascript:void(0);" onclick='<portlet:namespace/>_removeCheck(); return false;' onmouseover='window.status="<%=ics.GetVar("_XLAT_")%>";return true;' onmouseout="window.status='';return true;">
	                       <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement>
	                    </a>
	                </td>
                <% } %>
            </tr>
            </table>
            </td>
        </tr>

        </table>
        </satellite:form>

        <%
    } else {
        %>
        <img width="250" height="15" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/><br/>
        <div class="portlet-font"><xlat:stream key="dvin/UI/NoAssetsInHistoryList"/></div><br/>
        <%
    }
    %>
</cs:ftcs>