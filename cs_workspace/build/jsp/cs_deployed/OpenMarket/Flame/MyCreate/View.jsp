<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/MyCreate/View
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="javax.portlet.*"%>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.*" %>
<%@ page import="com.openmarket.basic.interfaces.AssetException"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetType" %>
<cs:ftcs>
    <%
    ics.CallElement("OpenMarket/Flame/Common/UIFramework/PortletCSFormMode", null);

    ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
    String cs_imageDir = ics.GetVar("cs_imagedir");

    ics.CallElement("OpenMarket/Flame/Common/Script/Popup", null);

    %><portlet:defineObjects />
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>
    <%

    FTValList args = new FTValList();
    args.setValString("ITEMTYPE", "ContentForm");
    args.setValString("PUBID", ics.GetSSVar("pubid"));
    args.setValString("LISTVARNAME", "items");
    ics.runTag("STARTMENU.GETMATCHINGSTARTITEMS", args);
    args.removeAll();

    IList itemList = ics.GetList("items");
    if (itemList!=null && itemList.hasData()) {
        %>
      
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
		</tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 1px 1px;">
				<tr>
					<td colspan="7" class="tile-highlight">
						<img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
					</td>
				</tr>
				<tr class="section-header">
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>
						<div><xlat:stream key="dvin/Common/Type"/></div>
					</td>
					<td>&nbsp;</td>
					<td>
						<div><xlat:stream key="dvin/Common/Name"/></div>
					</td>
					<td class="tile-c">&nbsp;</td>
				</tr>

                      <ics:setvar name="rowStyle" value="tile-row-normal"/>
				<ics:setvar name="separatorLine" value="0"/>
				<!-- loop goes below -->
            <%
            boolean isMaximized = renderRequest.getWindowState().equals(WindowState.MAXIMIZED);

            int maxListSize = 10;
            int listSize = itemList.numRows();
            int moreListItems = 0;

            if (!isMaximized && (listSize > maxListSize + 1)) {
                moreListItems = listSize - maxListSize;
                listSize = maxListSize;
            }

            boolean bRowHighlight = false;
            %>
            <ics:listloop listname="items" maxrows="<%= listSize %>">
                <ics:listget listname="items" fieldname="assettype" output="assettype"/>
                <ics:listget listname="items" fieldname="id" output="id"/>
                <ics:listget listname="items" fieldname="name" output="name"/>

			 	

			 		<tr>
			 			<%--<td colspan="7" class="light-line-color">
			 				<img align="left" height="1" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
			 			</td>--%>
			 		</tr>

					<tr class='<%=ics.GetVar("rowStyle")%>'>
						<td>
							<br/>
						</td>
						<td valign="top" align="left" nowrap>
							<!-- content.gif images/links go here -->
						</td>
						<td><br/></td>
						<td valign="top" align="left" nowrap>
							<div class="small-text-inset">
                  			  <%
                  			  AssetType at = AssetType.Load(ics,ics.GetVar("asssettype"));
                  			  String assetTypeDesc = at!=null?at.Get(AssetType.DESCRIPTION):"";
                  			  %>
                  			  <%= assetTypeDesc %>
							</div>
						</td>
						<td>
							<br/>
						</td>
						<td valign="top" align="left">
							<div class="small-text-inset">
                  			  <satellite:link assembler="query" outstring="createAssetURL" container="servlet">
                  			      <satellite:argument name="AssetType" value='<%= ics.GetVar("assettype") %>' />
                  			      <satellite:argument name="StartItem" value='<%= ics.GetVar("id") %>' />
                  			      <satellite:argument name="cs_environment" value="portal" />
                  			      <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>' />
                  			      <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/NewContentFront"/>
                  			  </satellite:link>
                  			  <% String onClick = "csPopup('" + ics.GetVar("createAssetURL") + "', 'NewContent')"; %>
                  			  <a href='javascript:void(0);'  onclick="<portlet:namespace/>_<%= onClick %>"><%= ics.GetVar("name") %></a>
							</div>
						</td>
						<td>
							<br/>
						</td>
					</tr>
                    <ics:if condition='<%="tile-row-normal".equals(ics.GetVar("rowStyle"))%>'>
					<ics:then>
						<ics:setvar name="rowStyle" value="tile-row-highlight"/>
					</ics:then>
					<ics:else>
                        <ics:setvar name="rowStyle" value="tile-row-normal"/>
					</ics:else>
					</ics:if>

            	 </ics:listloop>
				</table>
			</td>
		</tr>
		<tr>
			<td background="<%=cs_imageDir%>/graphics/common/screen/shadow.gif">
				<img align="left" width="1" height="5" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
			</td>
		</tr>
		</table>


        
        
            <% if (moreListItems>0) { %>
                <!-- workaround for Weblogic8.1sp2 URL generation bug -->
                <satellite:link assembler="query" outstring="moreURL" >
                    <satellite:argument name="pagename" value="OpenMarket/Flame/MyCreate/View"/>
                </satellite:link>
                <ics:setvar name="moreURL" value='<%= ics.GetVar("moreURL") + "&#38;_state=maximized&#38;window.newWindowState=MAXIMIZED" %>' />

             
             
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="left">
                        <a href='<%= ics.GetVar("moreURL") %>' >
                            <ics:setvar name="num" value="<%= String.valueOf(moreListItems) %>" />
                            <div class="portlet-font">&nbsp;<xlat:stream key="dvin/UI/NumMoreDot"/></div>
                        </a>
                    </td>
                </tr>
        	</table>
            <% } %>
      
        <%
    } else {
        %>
        <img width="250" height="15" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/><br/>
        <div class="portlet-font"><xlat:stream key="dvin/UI/NoStartItemsForAssetCreation"/></div><br/>
        <%
    }
    %>
</cs:ftcs>