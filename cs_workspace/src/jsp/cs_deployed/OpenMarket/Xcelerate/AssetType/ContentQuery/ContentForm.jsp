<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@ page import="com.fatwire.services.beans.search.SearchCriteria"%>
<%@ page import="com.thoughtworks.xstream.XStream"%>
<%@ page import="com.fatwire.services.util.JsonUtil"%>

<cs:ftcs>
<% if ("ucform".equals(ics.GetVar("cs_environment"))) { %>
   <link rel="stylesheet" type="text/css" href="js/fw/css/ui/fw.css"/>
    <ics:callelement element="OpenMarket/Gator/Scripts/ValidateFieldsJSP"/>
    <%
        String queryString = "";
        if (ics.GetBin("ContentDetails:urlquery") != null) {
            queryString = new String(ics.GetBin("ContentDetails:urlquery"));
        }      
        Object assetId = ics.GetVar("id");
    %>
    <script type="text/javascript">             
        dojo.require('fw.ui.dijit.Calendar');
        dojo.require('fw.ui.dijit.DateTextBox');
        dojo.require('fw.ui.view.ContentQueryView');
        var cqView = new fw.ui.view.ContentQueryView({initContext: parent, appContext: parent.SitesApp});
        dojo.addOnLoad(function() {   
            cqView.init();
            cqView.populateSearchForm(<%=queryString%>);  
            // based on OpenMarket/Gator/Scripts/SetDirtyState
            var isEditOrNewPage = <%= "EditFront".equals(ics.GetVar("ThisPage")) || "NewContentFront".equals(ics.GetVar("ThisPage")) %>;
            var isUcForm = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
            var connectChangeEvents = function(){
                var widgets = dijit.findWidgets(dojo.byId("tabContent")).concat(dijit.findWidgets(dojo.byId("tabQuery")));
                dojo.forEach(widgets, function(eachWidget){
                    var handleChange = dojo.connect(eachWidget, "onChange", function(){	
                        if (!cqView.populatingAdvSearch) {
                            setTabDirty();
                            dojo.disconnect(handleChange);
                        }                        
                    });
                });		
            };
            if(isUcForm) {
                setTimeout(function(){connectChangeEvents();}, 0);
            }	
        });
        
        var obj = document.forms[0];

        function submitForm () {
            if (!dojo.string.trim(getAssetName())) {
                alert("<xlat:stream key='dvin/Assetmaker/SpecifyValidName'/>");
                obj.elements['ContentQuery:name'].focus();
                return false;
            }
            // list size is not empty, then check if it is an int.
            if (getListSize() && !IsPositiveInt(getListSize())) {
                alert("<xlat:stream key='dvin/UI/ContentQuery/Error/ListSize'/>");
                obj.elements['ContentQuery:listsize'].focus();
                return false;
            }
            var data = cqView._grabAdvancedSearchFormData();
            dojo.byId('queryString').value = dojo.toJson(data);
            obj.submit();
            return false;
        }
        
        function SetCancelFlag () {
            if(confirm("<xlat:stream key="dvin/Common/CancelClicked" escape="true" encode="false"/>")) {
                obj.elements['upcommand'].value="cancel";
                obj.submit();
                return false;
            }
        }
        
        function search() {
            cqView.search();            
        }
        function getAssetName() {
            return obj.elements['ContentQuery:name'].value;
        }
        function getListSize() {
            return obj.elements['ContentQuery:listsize'].value;
        }

    </script>


    <xlat:lookup key="UI/Forms/Content" varname="tabContent"/>

    <assettype:load name='type' type='<%=ics.GetVar("AssetType")%>'/>
    <assettype:scatter name='type' prefix='ContentQuery'/>
    <% if (ics.GetVar("isReposted") != null && ics.GetVar("isReposted").equals("true")) { %>
            <asset:scatter name="ContentDetails" prefix="ContentQuery"/>
    <% } %>
    <input type="hidden" name="FieldsOnForm" value="name,description,listsize,sortfield,urlquery,sortorder"/>
    <input type="hidden" name="editfileastext" value="urlquery"/>
    
    <div dojoType="dijit.layout.BorderContainer" class="bordercontainer">
        <!-- form buttons -->
        <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBar">
            <ics:argument name="doNotShowSaveButton" value="false"/>
            <ics:argument name="submitScript" value="submitForm"/>		
        </ics:callelement>
        <div dojoType="dijit.layout.ContentPane" region="center">
            <div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">
                <div dojoType="dijit.layout.ContentPane" id="tabContent" title="<%=ics.GetVar("tabContent")%>" selected="true" class="advancedSearchForm"> 
                    <div class="searchField">
                        <span class="text label"><span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Name"/>:</span>&nbsp;
                        <div class="content" id="saveSearchNameBox" dojoType="fw.dijit.UIInput" name="ContentQuery:name" value="<string:stream variable='ContentDetails:name'/>" maxLength="64">                    
                        </div>
                    </div>
                    <div class="searchField">
                        <span class="text label"><xlat:stream key="dvin/AT/Common/Description"/>:</span>&nbsp;
                        <div class="content" dojoType="fw.dijit.UIInput" name="ContentQuery:description" value="<string:stream variable='ContentDetails:description'/>">                    
                        </div>
                    </div>
                    <div class="searchField">
                        <span class="text label"><xlat:stream key="dvin/UI/ContentQuery/ListSize"/>:</span>&nbsp;
                        <div class="content" id="listsize" dojoType="fw.dijit.UIInput" name="ContentQuery:listsize" value="<string:stream variable='ContentDetails:listsize'/>" maxLength="8">                    
                        </div>
                    </div>
                    <div class="searchField">
                        <span class="text label"><xlat:stream key="dvin/UI/ContentQuery/SortField"/>:</span>&nbsp;
                        <select class="content" dojotype="fw.dijit.UIFilteringSelect" id="sortfield" name="ContentQuery:sortfield" 
                                value="<string:stream variable='ContentDetails:sortfield'/>" onchange="dojo.publish('fw/ui/contentquery/sortfield', [this]);">
                            <option value="name"><xlat:stream key="dvin/AT/Common/Name"/></option>
                            <option value="AssetType_Description"><xlat:stream key="dvin/Common/AssetType"/></option>
                            <option value="locale"><xlat:stream key="dvin/AT/Dimension/Locale"/></option>
                            <option value="updateddate"><xlat:stream key="dvin/AT/Common/Modified"/></option>
                        </select>
                    </div>
                    <div class="searchField">
                        <span class="text label"><xlat:stream key="dvin/UI/ContentQuery/SortOrder"/>:</span>&nbsp;
                        <select class="content" dojotype="fw.dijit.UIFilteringSelect" id="sortorder" name="ContentQuery:sortorder" value="<string:stream variable='ContentDetails:sortorder'/>"
                                onchange="dojo.publish('fw/ui/contentquery/sortorder', [this]);">
                            <option value="asc"><xlat:stream key="dvin/AT/Common/ascending"/></option>
                            <option value="desc"><xlat:stream key="dvin/AT/Common/descending"/></option>                            
                        </select>                    
                    </div>
                    <!-- hidden id field -->
                    <input type="hidden" id="assetId" value="<string:stream variable='ContentDetails:id'/>"/>
                </div>  

                <div dojoType="dijit.layout.ContentPane" region="center" title="<xlat:stream key='dvin/UI/ContentQuery/QueryTabTitle'/>" 
                     class="searchContainer fwGridContainer" id="tabQuery">
                    <input type="hidden" id="queryString" name="ContentQuery:urlquery" value='<%=queryString%>'/>                    
                    <input type="hidden" id="queryStringFile" name="ContentQuery:urlquery_file" value='cqueryfile'/> 
                    <input dojoType="dijit.form.TextBox" id="cqmode" required="true" type="hidden" value="edit"/>
                    <controller:callelement elementname="UI/Data/Search/AdvancedContentQuery">   
                        <controller:argument name="mode" value="edit" />                        
                    </controller:callelement>                     
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