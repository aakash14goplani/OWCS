<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteTemplating
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="java.util.*"
%><cs:ftcs>
<xlat:lookup key="dvin/Common/Search" varname="XLAT_Search"/>
<table width="100%" height="24" border="0" cellpadding="0" cellspacing="0">
<tr>
<td align="right" class="topButtons" style="padding:3px 13px 3px 0px;">
<xlat:lookup key="dvin/Common/SaveChanges" varname="XLAT_SaveChanges"/>
<xlat:lookup key="dvin/Common/CancelChanges" varname="XLAT_CancelChanges"/>
 <img id="saveSlotsBtn" src="<ics:getvar name="panelImagePath" />/insite_Save.gif" title="<ics:getvar name="XLAT_SaveChanges"/>" alt="<ics:getvar name="XLAT_SaveChanges"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath" />/insite_saveBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath" />/insite_Save.gif')"/><img id="cancelSlotsBtn" src="<ics:getvar name="panelImagePath"/>/insite_cancel.gif" title="<ics:getvar name="XLAT_CancelChanges"/>" alt="<ics:getvar name="XLAT_CancelChanges"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath" />/insite_CancelBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath" />/insite_cancel.gif')" />
</td>
</tr>
</table>
<div id="pageBuilderStatusLine" class="statusLine">&nbsp;</div>
<div class="panelSection">
    <h3><ics:getvar name="XLAT_Search"/></h3>
    <satellite:form id="search" onsubmit="javascript:return false;" class="searchForm">
        <table border="0">
		<tr>
		    <td colspan="2">
		        &nbsp;
		    </td>
		</tr>
        <tr>
            <th style="vertical-align: middle;"><xlat:stream key="dvin/Common/AT/Map/type"/>: </th>
            <td><%
				FTValList args = new FTValList();
				args.setValString("ITEMTYPE", "Search");
				args.setValString("PUBID", ics.GetSSVar("pubid"));
				args.setValString("LISTVARNAME", "items");
				ics.runTag("STARTMENU.GETMATCHINGSTARTITEMS", args);
				Collection<String> legalTypes = new ArrayList<String>();
				%><asset:getlegalsubtypes list='AssetTypes' type='Template' pubid='<%= ics.GetSSVar("pubid") %>' />
				<ics:listloop listname="AssetTypes">
					<ics:listget listname="AssetTypes" fieldname="subtype" output="type" /><%
					legalTypes.add(ics.GetVar("type"));
				%></ics:listloop>
		        <select id="searchAssetType" name="searchAssetType" class="searchForm" style="width:148px">
		        	<option value=""><xlat:stream key="dvin/Common/Select"/>...</option>
		          <ics:listloop listname="items">
		          	<ics:listget listname="items" fieldname="assettype" output="assettype" />
		          	<ics:listget listname="items" fieldname="id" output="startmenuid"/>
					<ics:listget listname="items" fieldname="name" output="name" />
					<ics:listget listname="items" fieldname="description" output="description" />
		          	<ics:if condition='<%="CSElement".equals(ics.GetVar("assettype")) || "SiteEntry".equals(ics.GetVar("assettype")) || legalTypes.contains(ics.GetVar("assettype")) %>'>
		          	<ics:then>
		            <option value="<ics:getvar name="startmenuid"/>">
					<%
					if (ics.GetVar("description") != null && ics.GetVar("description").length() > 0)
					{
						%><string:stream value='<%=ics.GetVar("description")%>'/><%
					}
					else
					{
						%><string:stream value='<%=ics.GetVar("name")%>'/><%
					}
					%>
		            </option>
		            </ics:then>
		            </ics:if>
		          </ics:listloop>
		        </select>
            </td>
        </tr>
		<tr>
		    <td colspan="2"><img src="<ics:getvar name="panelImagePath"/>/spacer.gif" width="1" height="5" /></td>
		</tr>
        <tr>
            <th style="vertical-align: middle;"><xlat:stream key="dvin/UI/Common/Containing"/>:</th>
            <td>
                <input id="searchforname" name="searchName" style="width:148px" type="text" />
            </td>
        </tr>
		<tr>
		    <td colspan="2"><img src="<ics:getvar name="panelImagePath"/>/spacer.gif" width="1" height="5" /></td>
		</tr>
        <tr>
            <th style="vertical-align: middle;"><xlat:stream key="dvin/Common/Template"/>:</th>
            <td>
                <select id="TemplatesForType" name="TemplatesForType" style="width:148px;" />
                    <option value=""><xlat:stream key="dvin/Common/Select"/>...</option>
                </select>
            </td>
        </tr>
		<tr>
		    <td colspan="2"><img src="<ics:getvar name="panelImagePath"/>/spacer.gif" width="1" height="5" /></td>
		</tr>
        <tr>
            <td colspan="2" align="right" style="padding-left:19px;">
                <img id="searchBtn" src="<ics:getvar name="panelImagePath"/>/insite_SearchButton.gif" title="<ics:getvar name="XLAT_Search"/>" alt="<ics:getvar name="XLAT_Search"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath"/>/insite_SearchButtonBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath"/>/insite_SearchButton.gif')"/>
            </td>
    </table>
</satellite:form>
</div>
<div class="panelSection">
    <h3><xlat:stream key="dvin/Common/Searchresults"/></h3>
    <div id="searchResults">
    </div>
</div>
</cs:ftcs>
