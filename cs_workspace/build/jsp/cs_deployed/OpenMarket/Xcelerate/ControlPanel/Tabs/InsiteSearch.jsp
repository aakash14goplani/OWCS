<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Tabs/InsiteSearch
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="java.util.*"
%><cs:ftcs>
<div class="panelSection">
<table valign="top" cellpadding="0" cellspacing="0" border="0">
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
        <select id="insiteSearchAssetType" style="font-size:xx-small; width: 148px;">
          <ics:listloop listname="items">
          	<ics:listget listname="items" fieldname="assettype" output="assettype" />
          	<ics:listget listname="items" fieldname="name" output="name" />
          	<ics:listget listname="items" fieldname="description" output="description" />
          	<assettype:load name="type" type='<%=ics.GetVar("assettype")%>' />
          	<assettype:scatter name="type" prefix="AssetTypeObj" />
          	<ics:if condition='<%="CSElement".equals(ics.GetVar("assettype")) || "SiteEntry".equals(ics.GetVar("assettype")) || legalTypes.contains(ics.GetVar("assettype")) %>'>
          	<ics:then>
			<ics:setvar name="flextemplateid" value="" />
            	<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/StartMenuAssetSubtype">
                    <ics:argument name="simplesearch" value="true"/>
                    <ics:argument name="assettypename" value='<%=ics.GetVar("assettype")%>'/>
                    <ics:argument name="startmenupename" value='<%=ics.GetVar("name")%>'/>
            	</ics:callelement>

	          	<ics:if condition='<%=!("".equals(ics.GetVar("flextemplateid")))%>' >
	          	<ics:then>
	          	<option value='<ics:getvar name="assettype"/>&flextemplateid=<ics:getvar name="flextemplateid"/>'>
	          	</ics:then>
	          	<ics:else>
	          	<option value='<ics:getvar name="assettype"/>'>
	          	</ics:else>
	          	</ics:if>
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
   <td><%
   String searchText = ics.GetVar("searchText");
   if (searchText == null)  searchText = "";
   %><input id="insiteSearchText" name="insiteSearchText" type="text" style="font-size: xx-small; width: 148px;" value="<%=searchText%>" />
    </td>
</tr>
<tr>
    <td colspan="2"><img src="<ics:getvar name="panelImagePath"/>/spacer.gif" width="1" height="5" /></td>
</tr>
<tr>
    <td align="right" style="padding-left:19px;" colspan="2">
        <ics:setvar name="imageFolder" value='<%=ics.GetProperty("ft.cgipath") + "images/" + ics.GetSSVar("locale")%>' />
        <xlat:lookup key="dvin/Common/Search" varname="XLAT_Search"/>
        <img id="insiteSearchBtn" src="<ics:getvar name="panelImagePath"/>/insite_SearchButton.gif" title="<ics:getvar name="XLAT_Search"/>" alt="<ics:getvar name="XLAT_Search"/>" onmouseover="swap(this,'<ics:getvar name="panelImagePath"/>/insite_SearchButtonBlue.gif')" onmouseout="swap(this,'<ics:getvar name="panelImagePath"/>/insite_SearchButton.gif')" />
    </td>
</tr>
</table>
</div>
<div id="searchContentResults" class="panelSection"></div>
</cs:ftcs>
