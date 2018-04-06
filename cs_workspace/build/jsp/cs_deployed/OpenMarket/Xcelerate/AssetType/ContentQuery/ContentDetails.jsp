<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ page import="com.fatwire.services.beans.search.SearchCriteria"%>
<%@ page import="com.thoughtworks.xstream.XStream"%>

<cs:ftcs>
    <% if ("ucform".equals(ics.GetVar("cs_environment"))) { %>
    <style type="text/css">
        .rows {
            margin: 1em 3em;

            clear: both;
            float: left;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="js/fw/css/ui/fw.css"/>
    <%
        String queryString = "";
        if (ics.GetBin("ContentDetails:urlquery") != null) {
            queryString = new String(ics.GetBin("ContentDetails:urlquery"));
        }        
    %>
    <script type="text/javascript">
        dojo.require('fw.ui.view.ContentQueryView');
        var cqView = new fw.ui.view.ContentQueryView({initContext: parent, appContext: parent.SitesApp});
        dojo.addOnLoad(function() {                                
              cqView.init();
              cqView.displaySearchQuery(<%=queryString%>); 
        });
    </script>
    <xlat:lookup key="UI/Forms/Content" varname="tabContent"/>

    <div dojoType="dijit.layout.BorderContainer" class="bordercontainer">
        <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ActionsBar">
            <ics:argument name="Screen" value="Inspect"/>
            <ics:argument name="NoPreview" value="true"/>
        </ics:callelement>
        <div dojoType="dijit.layout.ContentPane" region="center">
            <div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">
                <div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabContent")%>"  selected="true">
                    <!-- hidden fields to get the search to work in inspect mode -->
                    <input dojoType="dijit.form.TextBox" id="sortorder" type="hidden" 
                           value='<string:stream variable="ContentDetails:sortorder"/>'/>
                    <input dojoType="dijit.form.TextBox" id="listsize" type="hidden" 
                           value='<string:stream variable="ContentDetails:listsize"/>'/>
                    <input dojoType="dijit.form.TextBox" id="sortfield" type="hidden" 
                           value='<string:stream variable="ContentDetails:sortfield"/>'/>
                    <table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
                        <tr>
                            <td>
                                <span class="title-text"><string:stream variable="AssetTypeObj:description"/>: </span>
                                <span class="title-value-text type-header"><string:stream variable="ContentDetails:name"/></span>
                            </td>
                        </tr>
                        <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
                            <ics:argument name="SpaceBelow" value="No"/>
                        </ics:callelement>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset"><string:stream variable="ContentDetails:name"/></td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/AT/Common/Description"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset"><string:stream variable="ContentDetails:description"/></td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset"><string:stream variable="ContentDetails:id"/></td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/UI/ContentQuery/ListSize"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset"><string:stream variable="ContentDetails:listsize"/></td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/UI/ContentQuery/SortField"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset">
                                            <ics:if condition='<%="name".equals(ics.GetVar("ContentDetails:sortfield"))%>'>
                                                <ics:then><xlat:stream key="dvin/AT/Common/Name"/></ics:then>
                                            </ics:if>
                                            <ics:if condition='<%="AssetType_Description".equals(ics.GetVar("ContentDetails:sortfield"))%>'>
                                                <ics:then><xlat:stream key="dvin/Common/AssetType"/></ics:then>
                                            </ics:if>
                                            <ics:if condition='<%="locale".equals(ics.GetVar("ContentDetails:sortfield"))%>'>
                                                <ics:then><xlat:stream key="dvin/AT/Dimension/Locale"/></ics:then>
                                            </ics:if>
                                            <ics:if condition='<%="updateddate".equals(ics.GetVar("ContentDetails:sortfield"))%>'>
                                                <ics:then><xlat:stream key="dvin/AT/Common/Modified"/></ics:then>
                                            </ics:if>
                                        </td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                    <tr>
                                        <td class="form-label-text"><xlat:stream key="dvin/UI/ContentQuery/SortOrder"/>:</td>
                                        <td><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
                                        <td class="form-inset">
                                            <ics:if condition='<%="asc".equals(ics.GetVar("ContentDetails:sortorder"))%>'>
                                                <ics:then><xlat:stream key="dvin/AT/Common/ascending"/></ics:then>
                                            </ics:if>
                                            <ics:if condition='<%="desc".equals(ics.GetVar("ContentDetails:sortorder"))%>'>
                                                <ics:then><xlat:stream key="dvin/AT/Common/descending"/></ics:then>
                                            </ics:if>                          
                                        </td>
                                    </tr>
                                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                </table>
                            </td>
                        </tr>                
                    </table>                          
                </div>
                <div dojoType="dijit.layout.ContentPane" title="<xlat:stream key='dvin/UI/ContentQuery/QueryTabTitle'/>" selected="true">
                    <input dojoType="dijit.form.TextBox" id="cqmode" required="true" type="hidden" value="inspect"/>
                    <input dojoType="dijit.form.TextBox" id="queryString" type="hidden" value='<%=queryString%>'/>
                    <div id="searchQueryDetails"><xlat:stream key="dvin/UI/ContentQuery/NoQuery"/></div>
                    <div class='searchButtons' style="margin: 3em 0 0 20em">
                        <div id="advancedSearchBtn" class="searchButtonNode" dojoType="fw.ui.dijit.Button" 
                            label="<xlat:stream key='UI/UC1/Layout/RunSearch'/>"></div>                                       
                    </div>     
                </div>
            </div>
        </div>
    </div>
    <%} else {%>
				<div class="width-outer-70">
				<xlat:lookup key="UI/UC1/JS/ContentServerErrorMessage" varname="notSupportedInAdminUI"/>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
					<ics:argument name="msgtext" value="Variables.notSupportedInAdminUI"/>
					<ics:argument name="severity" value="error"/>
				</ics:callelement>
			</div><P/>
	<%}%>
</cs:ftcs>    