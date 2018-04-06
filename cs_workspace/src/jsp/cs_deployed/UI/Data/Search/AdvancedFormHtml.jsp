<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.beans.entity.StartMenuBean"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.ui.util.SearchUtil"%>
<%@page import="org.apache.commons.collections.CollectionUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
           %>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.services.beans.entity.UserBean"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<cs:ftcs>
    <%
    List<StartMenuBean> assetTypeList = GenericUtil.emptyIfNull((List<StartMenuBean>) request.getAttribute("assetType"));
	List<UserBean> userList = GenericUtil.emptyIfNull((List<UserBean>)request.getAttribute("author"));
	List<String> localeList = GenericUtil.emptyIfNull((List<String>)request.getAttribute("locale"));
	String mode = StringUtils.defaultString(request.getParameter("mode"));
	String searchType = StringUtils.defaultString(request.getParameter("searchType"));
	String assetType = StringUtils.defaultString(request.getParameter("assetType"));
	boolean isEdit = StringUtils.equalsIgnoreCase(mode, "edit");
	boolean isAdvanced = !StringUtils.equalsIgnoreCase(searchType, "simple");
    %>
    <%if(!isAdvanced && isEdit){%>
    <div class="searchField">
        <div class="label"><xlat:stream key="dvin/Common/Keyword"/></div>
        <div class="content">
            <input  type="text" dojoType="fw.dijit.UIInput" id="keywordBox" clearButton="true" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" />
        </div>
    </div>		
    <div class="searchField">
        <div class="label"><xlat:stream key="dvin/Common/AssetType"/></div>
        <div class="content">
            <select dojotype="fw.dijit.UIFilteringSelect" 
                    id="assetTypeSelect" 
                    name="assetTypeSelect" 
                    placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                    value="<%=SearchUtil.ANY%>">
                <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option><%
                        for(StartMenuBean  startMenu: assetTypeList){
                                out.println("<option value='"+startMenu.getAssetType().getType()+"'>");
                                out.println(startMenu.getAssetType().getAssetTypeDescription());
                                out.println("</option>");
                        }
                %></select>
        </div>
    </div>		
    <div id="subType" style="display: none">
        <div class="searchField">
            <div class="label"><xlat:stream key="UI/UC1/Layout/AssetSubType"/></div>
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="subTypeSelect" 
                        name="subTypeSelect"
                        searchAttr="label"
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                        value="<%=SearchUtil.ANY%>"
                        >
                    <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option>
                </select>
            </div>
        </div>
    </div><%
	}else{%><br>
    <div class="mainSearchFields">
        <h3><xlat:stream key='UI/UC1/Layout/AdvancedSearchMessage1'/></h3>
        <div class="searchField">
            <div class="label">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="keywordSelect" 
                        name="keywordSelect" 
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>">
                    <option value= "<%=SearchUtil.ANY_OF_THESE_WORDS %>"><xlat:stream key='UI/UC1/Layout/AdvancedSearchMessage2'/></option>
                    <option value= "<%=SearchUtil.ALL_OF_THESE_WORDS %>"><xlat:stream key='UI/UC1/Layout/AdvancedSearchMessage3'/></option>
                </select>
            </div>
            <div class="content">
                <input  type="text" dojoType="fw.dijit.UIInput" id="keywordBox" clearButton="true" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" />
            </div>
        </div>
    </div>
    <div class="subSearchFields">
        <h4><xlat:stream key='UI/UC1/Layout/AdvancedSearchMessage4'/></h4>
        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/UI/AssetMgt/AssetName'/></div>
            <div class="content">
                <input type="text" dojoType="fw.dijit.UIInput" id="field_name" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" clearButton="true" />
            </div>
        </div>

        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/Common/Description'/></div>
            <div class="content">
                <input type="text" dojoType="fw.dijit.UIInput" id="field_description" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" clearButton="true" />
            </div>
        </div>
        <div class="searchField">
            <div class="label alignTop"><xlat:stream key='UI/UC1/Layout/Tags'/></div>
            <div class="content">
                <div id='field_tags' name='field_tags' value="" delimiter=',' dojoType='fw.ui.dojox.form.TagListInput' readOnlyItem='true' readOnlyInput='false' showCloseButtonWhenValid='true' showCloseButtonWhenInvalid='true' class='searchTagListInput' ></div>
            </div>
        </div>
        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/UI/Common/Id'/></div>
            <div class="content">
                <input type="text" dojoType="fw.dijit.UIInput" id="field_id" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" clearButton="true" />
            </div>
        </div>
        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/UI/Admin/Locale'/></div>
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="localeSelect"
                        name="localeSelect"	
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                        value="<%=SearchUtil.ANY%>">
                    <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option><%
                    for(String locale : localeList) {
                            out.println("<option value='"+locale+"'>");
                            out.println(locale);
                            out.println("</option>");
                    }%></select>
            </div>
        </div>
        <div class="searchField">
            <div class="label"><xlat:stream key='fatwire/Alloy/UI/Author'/></div>
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="authorSelect" 
                        name="authorSelect"
                        value="<%=SearchUtil.ANY%>"
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                        >
                    <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option><%
                    for(UserBean user: userList){
                            out.println("<option value='"+user.getName()+"'>");
                            out.println(user.getName());
                            out.println("</option>");
                    }
                    %><option value= "<%=SearchUtil.OTHER%>"><xlat:stream key='UI/UC1/Layout/Other'/></option>
                </select>
            </div>
            <div id="otherBox" class="subContent" style="display:none">
                <div class="searchField">
                    <div class="label"><xlat:stream key='dvin/Common/Name'/></div> <input type="text" dojoType="fw.dijit.UIInput" id="otherText" placeHolder="<xlat:stream key='UI/UC1/Layout/EnterText'/>" clearButton="true" />
                </div>
            </div>
        </div>
        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/Common/Modified'/></div>
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect"
                        id="modifiedSelect" 
                        name="modifiedSelect"	
                        value="<%=SearchUtil.ANY%>"
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                        >
                    <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option>
                    <option value= "<%=SearchUtil.PAST_24_HOURS %>"><xlat:stream key='UI/UC1/Layout/Past_24_Hours'/></option>
                    <option value= "<%=SearchUtil.PAST_MONTH %>"><xlat:stream key='UI/UC1/Layout/PastMonth'/></option>
                    <option value= "<%=SearchUtil.PAST_WEEK %>"><xlat:stream key='UI/UC1/Layout/PastWeek'/></option>
                    <option value= "<%=SearchUtil.PAST_YEAR %>"><xlat:stream key='UI/UC1/Layout/PastYear'/></option>
                    <option value= "<%=SearchUtil.CUSTOM_RANGE %>"><xlat:stream key='UI/UC1/Layout/CustomRange'/></option>
                </select>
            </div>
            <div id="dateBox" class='subContent' style="display:none">
                <div class="searchField">
                    <div class="label"><xlat:stream key='UI/UC1/Layout/From'/></div> <input dojotype="fw.ui.dijit.DateTextBox" readonly="true" popupClass="fw.ui.dijit.Calendar" placeHolder="<xlat:stream key='fatwire/Alloy/UI/PickADate'/>" id="from_modified" />
                </div>
                <div class="searchField">
                    <div class="label"><xlat:stream key='UI/UC1/Layout/To'/></div> <input dojotype="fw.ui.dijit.DateTextBox" readonly="true" popupClass="fw.ui.dijit.Calendar" placeHolder="<xlat:stream key='fatwire/Alloy/UI/PickADate'/>" id="to_modified" />
                </div>
            </div>
        </div>

        <div class="searchField">
            <div class="label"><xlat:stream key='dvin/Common/AssetType'/></div>
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="assetTypeSelect" 
                        name="assetTypeSelect" 
                        placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                        value="<%=SearchUtil.ANY%>">
                    <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option><%
                            for(StartMenuBean  startMenuItem: assetTypeList){
                                    out.println("<option value='"+startMenuItem.getAssetType().getType()+"'>");
                                    out.println(startMenuItem.getAssetType().getAssetTypeDescription());
                                    out.println("</option>");
                            }
                    %></select>
            </div>
        </div>
    </div>
    <div id="defaultSubTypeDiv" class="defaultAttrSearchFields">
        <div id="subType" style="display: none">
            <div class="searchField">
                <div class="label"><xlat:stream key='UI/UC1/Layout/AssetSubType'/></div>
                <div class="content">
                    <select dojotype="fw.dijit.UIFilteringSelect" 
                            id="subTypeSelect" 
                            name="subTypeSelect"
                            searchAttr="label"
                            placeHolder="<xlat:stream key='dvin/Common/Select'/>"
                            value="<%=SearchUtil.ANY%>">
                        <option value= "<%=SearchUtil.ANY%>"><xlat:stream key='dvin/Common/Any'/></option>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div id="defaultAttributesDiv" class="defaultAttrSearchFields">
        <h4><xlat:stream key='UI/UC1/Layout/AdvancedSearchMessage5'/></h4>
        <div id="attributesDiv" style="display:none">
        </div>
        <div class="searchField addField">
            <div class="content">
                <select dojotype="fw.dijit.UIFilteringSelect" 
                        id="attributeSelect"
                        name="attributeSelect"
                        searchAttr="name"
                        placeHolder="<xlat:stream key='UI/UC1/Layout/AddAField'/>"
                        >
                </select>
            </div>
            <div class="content">
                <div id="addAttributesBtn" class="searchButtonNode" dojoType="fw.ui.dijit.Button" label="<xlat:stream key='dvin/Common/Add'/>"></div>
            </div>
        </div>
    </div>
<%}%>
</cs:ftcs>