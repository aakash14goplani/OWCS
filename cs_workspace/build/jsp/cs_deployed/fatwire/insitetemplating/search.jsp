<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" 
%><%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld" 
%><%
//
// fatwire/insitetemplating/search
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS,COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="com.openmarket.xcelerate.interfaces.*" 
%><%@ page import="com.fatwire.assetapi.def.AssetTypeDef,
                   com.fatwire.assetapi.def.AssetTypeDefManager,
                   com.fatwire.assetapi.def.AssetTypeDefManagerImpl,
                   com.fatwire.assetapi.common.AssetAccessException"%>
<cs:ftcs><%
String limit = "100";
String startMenuId = ics.GetVar("startmenuid");
IStartMenu sm = StartMenuFactory.make(ics);
IStartMenuItem smi = sm.getMenuItem(startMenuId);
String assettype = smi.getAssetType();
//[KGF 2008-12-09] get description for tooltip/alt
String assettypedesc = "";
AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);
try { assettypedesc = atdm.findByName(assettype, null).getDescription(); }
catch (AssetAccessException e) {}
if (!Utilities.goodString(assettypedesc))
    assettypedesc = assettype; //default to name if no description was obtained

String cs_imagedir = "";
cs_imagedir += ics.GetProperty( "ft.cgipath" );
cs_imagedir += ics.GetProperty( "xcelerate.imageurl", "futuretense_xcel.ini", true);
%>
<ics:setvar name="AssetType" value="<%=assettype %>"/>
<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/SearchString">
	<ics:argument name="searchAssetType" value="<%=assettype %>"/>
	<ics:argument name="searchText" value='<%=ics.GetVar("aname") %>'/>
</ics:callelement>
<ics:setvar name="queryfields" value="" />
<ics:callsql qryname='<%="OpenMarket/Xcelerate/AssetType/" + assettype  + "/SelectSummary"%>' listname="assetslist" limit="<%=limit %>"/><% 
IList assetList = ics.GetList("assetslist");
if (assetList != null && assetList.hasData()) {
    int maxResults = 5;
    int startRow = 1;
    try {
        startRow = Math.max(1, Integer.parseInt(ics.GetVar("start")));
    } catch(NumberFormatException e) {
    }
    int endRow   = Math.min(startRow + maxResults, assetList.numRows() + 1);    
    int prevResults = startRow - maxResults;
    int nextResults = startRow + maxResults;
    boolean style = true;
    
    
    /*
    	The following code snippet checks if startdate and enddate are available columns in the list 'assetList'
    	
    */
    
	boolean startDateAvailable = false;
	boolean endDateAvailable = false;
	int totalCols = assetList.numColumns();
	if(totalCols > 0)
	{
		String tempCol;
		for(int i=0;i<totalCols;i++)
		{
			tempCol = assetList.getColumnName(i);
			if(tempCol != null && tempCol.equals(IAsset.STARTDATE))
				startDateAvailable = true;
			if(tempCol != null && tempCol.equals(IAsset.ENDDATE))
				endDateAvailable = true;
		}
	}
    %>
    <table width="100%" cellpadding="0" cellspacing="0">    
	<tr>
	<td class="tableHeader" width="1%">&nbsp;</td>
	<td class="tableHeader" width="99%"><xlat:stream key="dvin/AT/Common/Name"/></td>
	</tr>

	<%
		if(ics.GetSSVar("locale")!=null)
		{
	%>
			<locale:create varname="localeObj" localename='<%=ics.GetSSVar("locale")%>'/>			
			<dateformat:create name="temp_date_object" datestyle="short" timestyle="short" locale="localeObj"/>
	<%
		}
		else
		{
	%>
			<dateformat:create name="temp_date_object" datestyle="short" timestyle="short"/>
	<%
		}
	%>
    <ics:listloop listname='assetslist' startrow='<%=String.valueOf(startRow)%>' endrow='<%=String.valueOf(endRow)%>'> 
    <tr class="<%=(style?"highlightOn":"highlightOff")%>">
		<td class="tableCell"><img src='<%=cs_imagedir%>/OMTree/TreeImages/AssetTypes/<%=assettype%>.png' title="<%=assettypedesc%>" alt="<%=assettypedesc%>" onerror="swap(this,'<%=cs_imagedir%>/OMTree/TreeImages/default.png');" /></td>
        <ics:listget listname='assetslist' fieldname='name' output='assetname'/>
        <ics:listget listname="assetslist" fieldname="description" output="assetdesc"/>
        <ics:listget listname="assetslist" fieldname="id" output="assetid" />
	    <%
        String cs_assetName = "";
	    cs_assetName += ics.GetVar( "assetname" );
          
        String cs_assetNameSubstring = cs_assetName;
		if(cs_assetNameSubstring.length() > 33)
		{
       	    cs_assetNameSubstring = cs_assetNameSubstring.substring(0, 33);
	   	    cs_assetNameSubstring += "...";
		}
        
        String cs_assetDesc = cs_assetName;
        if (ics.GetVar("assetdesc") != null && ics.GetVar("assetdesc").length() > 0)
        {
        %>
        <string:encode variable="assetdesc" varname="assetdesc"/>
        <%
            cs_assetDesc = ics.GetVar("assetdesc");
        }
		
	// Retrieve start/end dates to show in the tool tip
	%>
	<xlat:lookup key="dvin/UI/Common/NotApplicableAbbrev" varname="_NA_"/>
	<%
	ics.SetVar("dateInfo", ics.GetVar("_NA_"));
	if(startDateAvailable)
	{
%>
		<ics:listget listname="assetslist" fieldname="startdate" output="startDate" />
<%
		if(ics.GetVar("startDate")!=null && !(ics.GetVar("startDate").equals("")))
		{
%>
			<dateformat:getdatetime name="temp_date_object" value='<%=ics.GetVar("startDate")%>' valuetype="jdbcdate" varname="startDateShortVersion" />
<%
			ics.SetVar("dateInfo",ics.GetVar("startDateShortVersion"));
		}
	}

	if(endDateAvailable)
	{
%>
		<ics:listget listname="assetslist" fieldname="enddate" output="endDate" />
<%
		if(ics.GetVar("endDate")!=null && !(ics.GetVar("endDate").equals("")))
		{
%>
			<dateformat:getdatetime name="temp_date_object" value='<%=ics.GetVar("endDate")%>' valuetype="jdbcdate" varname="endDateShortVersion" />
<%
			ics.SetVar("dateInfo",ics.GetVar("dateInfo")+" - "+ics.GetVar("endDateShortVersion"));
		}
		else
		{
			//Invalid end date
			ics.SetVar("dateInfo", ics.GetVar("dateInfo") + " - " + ics.GetVar("_NA_"));
		}
	}
	else
		ics.SetVar("dateInfo", ics.GetVar("dateInfo") + " - " + ics.GetVar("_NA_")); //This is to handle the case when there is no end date column itself
%>				
        <td class="tableCell">
        <a href="#" class="resultItem" title='<%=ics.GetVar("dateInfo")+" | "+cs_assetDesc%>' onclick="javascript:previewTemplate('<%=ics.GetVar("assetid")%>', '<%=assettype%>');"><%=cs_assetNameSubstring%></a>
        </td>
        <%style = !style;%>
    </tr>
    </ics:listloop>
    
    <tr>
        <td colspan="2">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
       				 <td align="left" width="50%" class="bottomBorder" style="padding-left:10px;">
							<%if (prevResults > 0) {%>
								<xlat:lookup key="dvin/Common/Previous" varname="XLAT_Previous"/>
							    <a class="paginate" href="#" title="<ics:getvar name="XLAT_Previous"/>" onclick="fw.controlPanel.search(<%=prevResults%>); return false;">&lt; <xlat:stream key="dvin/Common/lowercaseprev"/></a> 
							<%}%>
						</td>
       				 <td align="right" class="bottomBorder" style="padding-right:10px;">                
							<%if (nextResults <= assetList.numRows()) {%>
								<xlat:lookup key="dvin/Common/Next" varname="XLAT_Next"/>
							    <a class="paginate" href="#" title="<ics:getvar name="XLAT_Next"/>" onclick="fw.controlPanel.search(<%=nextResults%>); return false;"><xlat:stream key="dvin/Common/lowercasenext"/> &gt;</a>
							<%}%>
       				 </td>
				</tr>
			</table>
		</td>
    </tr>
    
</table>      
<%} else {%>
    <span style="padding-left:35;"><xlat:stream key="dvin/UI/NoAssetsFound"/></span>
<%}%>
</cs:ftcs>
