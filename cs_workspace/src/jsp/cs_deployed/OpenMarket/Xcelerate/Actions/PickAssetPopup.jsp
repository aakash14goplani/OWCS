<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/PickAssetPopup
//
// INPUT
//  cs_PickAssetType - optional AssetType to restrict selection to
//  cs_SelectionStyle - required [single|multiple]
//  cs_CallbackSuffix - required suffix to the callback function name
//  cs_History - optional comma delimited list of asset ids
//  cs_FieldName - required pretty name of field selection is for
//
// OUTPUT
//  calls a JavaScript function in the parent window
//  PickAssetPopupCallback(list of selected assets)
//  The list of assets is in the form AssetType1:AssetId1:AssetName1;AssetType2:AssetId2:AssetName2;etc
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*,com.fatwire.assetapi.site.*"%>
<cs:ftcs>
<%!
// Display section:  Need to display tabs showing the different selection methods.
// ActiveList, History, My Assignments, Search

private static final int ACTIVELIST_METHOD = 0;
private static final int HISTORY_METHOD = 1;
private static final int MYASSIGNMENT_METHOD = 2;
private static final int SEARCH_METHOD = 3;
%>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<%
FTValList args = new FTValList();
String cs_imageDir = ics.GetVar("cs_imagedir");
%>
<%
if(ics.GetVar("FCKName") == null){
	ics.SetVar("FCKName","");
}
if(ics.GetVar("FCKAssetId") == null){
	ics.SetVar("FCKAssetId","");
}

//Check if pubname or pubid is getting passed

if(ics.GetVar("pubname") != null){
	SiteManager sm = new SiteManagerImpl(ics);
	List<String> siteNames = new ArrayList<String>();
	siteNames.add(ics.GetVar("pubname"));
	List<Site> sites = sm .read(siteNames);
	Long pubid = ((Site)(sites.get(0))).getId();
	ics.SetVar("pubid",pubid.toString());
} else if(ics.GetVar("pubid") == null){
	ics.SetVar("pubid",ics.GetSSVar("pubid"));
}


%>
<%
if ("parentwindowgone".equals(ics.GetVar("action")))
{ %><div id="papheader" class="width-outer-50">
<table><tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/AssetMgt/Selectassetsforfield"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
</div>
<div id="pappanel" class="width-outer-50">
    <xlat:lookup key='dvin/UI/AssetMgt/Fieldtosubmitnotavailable' varname='errorStr'/>
    <ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/ShowMessage'>
        <ics:argument name='severity' value='error'/>
        <ics:argument name='msgtext' value='<%=ics.GetVar("errorStr")%>'/>
    </ics:callelement>
    <xlat:lookup key='dvin/Common/Closethiswindow' varname='_XLAT_'/>
    <a href="javascript:void(0);" onclick="javascript:window.close(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/CloseWindow"/></ics:callelement></a>
</div>
    <%
} else {
	int selectionMethod = SEARCH_METHOD;
    if (ics.GetVar("cs_SelectionMethod")!=null && ics.GetVar("cs_SelectionMethod").length()!=0) {
        selectionMethod = Integer.parseInt(ics.GetVar("cs_SelectionMethod"));
    } else {
        ics.SetVar("cs_SelectionMethod", String.valueOf(SEARCH_METHOD));
    }

    if (ics.GetVar("cs_History")==null || ics.GetVar("cs_History").length()==0) {
        ics.SetVar("cs_History", "none");
    }

    boolean haveAssetType = false;
    if (ics.GetVar("cs_PickAssetType")!=null && ics.GetVar("cs_PickAssetType").length()!=0
        && !"none".equals(ics.GetVar("cs_PickAssetType"))) {
    %>
    	<ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
     			<ics:argument name = "columnvalue" value ='<%=ics.GetVar("cs_PickAssetType") %>'/>
     			<ics:argument name = "type" value ="String"/>
     	</ics:callelement>
    <%
    	Boolean isAssetTypeValid = new Boolean(ics.GetVar("validatedstatus"));
    	if(isAssetTypeValid)
    	{
        	haveAssetType = true;
    	}
    } else {
        ics.SetVar("cs_PickAssetType", "none");
    }

    // regardless of the method, we need a list ("lAssets" with columns "assetid" and "assettype")
    // of assets
    switch (selectionMethod) {
    case ACTIVELIST_METHOD:
        args.setValString("VARNAME", "currentUser");
        ics.runTag("usermanager.getloginuser", args);
        args.removeAll();

        args.setValString("USER", ics.GetVar("currentUser"));
        if (haveAssetType) {
            args.setValString("ASSETTYPE", ics.GetVar("cs_PickAssetType"));
        }
        args.setValString("SITE", ics.GetVar("pubid"));
        args.setValString("PREFIX", "AL:");
        ics.runTag("activelist.getuserlist", args);
        args.removeAll(); %>

        <listobject:create name='loAssets' columns='assetid,assettype'/> <%
        int ActiveListSize = Integer.parseInt(ics.GetVar("AL:Total"));
        for (int i = 0; i < ActiveListSize; i++) {
            args.setValString("NAME", "AL:"+String.valueOf(i));
            args.setValString("VARNAME", "currentAT");
            ics.runTag("activeitem.getassettype", args);
            args.setValString("VARNAME", "currentID");
            ics.runTag("activeitem.getassetid", args);
            args.removeAll(); %>
            <listobject:addrow name='loAssets'>
                <listobject:argument name='assetid' value='<%=ics.GetVar("currentID")%>'/>
                <listobject:argument name='assettype' value='<%=ics.GetVar("currentAT")%>'/>
            </listobject:addrow> <%
        } %>
        <listobject:tolist name='loAssets' listvarname='lAssets'/> <%
        break;
    case HISTORY_METHOD:
        // there are at least 2 histories we need to worry about.  the javascript history stored
        // in the toolbar frame of the UI and the session variable used by the portal.
        // unfortunately the 2 have different formats.  the UI uses a comma delimited list of
        // assset ids while the portal uses a semi-colon delimited list of comma delimited asset id/
        // asset type pairs.  and theoretically both histories could exist at the same time.  we'll
        // only use the portal history if cs_environment is portal, otherwise we'll use the toolbar
        // history since we don't have enough info to correctly merge the lists

        if ("portal".equals(ics.GetVar("cs_environment")))
        { %>
          <listobject:create name='loAssets' columns='assetid,assettype'/> <%
          if (ics.GetSSVar("portalhistory")!=null && ics.GetSSVar("portalhistory").length()!=0) {
              StringTokenizer asset = new StringTokenizer(ics.GetSSVar("portalhistory"), ";");
              while (asset.hasMoreTokens())
              {
                  StringTokenizer typeAndId = new StringTokenizer(asset.nextToken(), ",");
                  while (typeAndId.hasMoreTokens()) {
                      String currentID = typeAndId.nextToken();
                      String currentAT = typeAndId.nextToken();
                      if (!haveAssetType || currentAT.equals(ics.GetVar("cs_PickAssetType"))) { %>
                        <listobject:addrow name='loAssets'>
                            <listobject:argument name='assetid' value='<%=ics.GetVar("currentID")%>'/>
                            <listobject:argument name='assettype' value='<%=ics.GetVar("currentAT")%>'/>
                        </listobject:addrow> <%
                      }
                  }
              }
          } %>
          <listobject:tolist name='loAssets' listvarname='lAssets'/> <%
        } else if (!"none".equals(ics.GetVar("cs_History"))) {
        %>
        	<ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
     			<ics:argument name = "columnvalue" value ='<%=ics.GetVar("pubid") %>'/>
     			<ics:argument name = "type" value ="Long"/>
     		</ics:callelement>
        <%
        	Boolean isPubidValid = new Boolean(ics.GetVar("validatedstatus"));
        	if(isPubidValid)
        	{
	            StringBuffer sqlBuf = new StringBuffer();
	            sqlBuf.append("SELECT * FROM AssetPublication WHERE ");
	            if (haveAssetType) {
	                sqlBuf.append(" assettype=");
	                sqlBuf.append(ics.literal("AssetPublication", "assettype", ics.GetVar("cs_PickAssetType")));
	                sqlBuf.append(" AND ");
	            }
	            sqlBuf.append("assetid IN (");
	            sqlBuf.append(ics.GetVar("cs_History"));
	            sqlBuf.append(") AND pubid=");
	            sqlBuf.append(ics.GetVar("pubid"));
	            IList historyAssets = ics.SQL("AssetPublication", sqlBuf.toString(), "lAssets", -1, true, sqlBuf);
        	}
      	}
       break;
    case MYASSIGNMENT_METHOD:
        args.setValString("VARNAME", "currentUser");
        ics.runTag("usermanager.getloginuser", args);
        args.removeAll(); %>
        <listobject:create name='loUser' columns='ITEM'/>
        <listobject:addrow name='loUser'>
            <listobject:argument name='ITEM' value='<%=ics.GetVar("currentUser")%>'/>
        </listobject:addrow>
        <listobject:tolist name='loUser' listvarname='lUser'/> <%
        args.setValString("PREFIX", "allAssignments:");
        args.setValString("SITE", ics.GetVar("pubid"));
        args.setValString("STATUS", "active");
        args.setValString("ASSIGNEDTO", "lUser");
        ics.runTag("workflowengine.getfilteredassignments", args);
        args.removeAll(); %>

        <listobject:create name='loAssets' columns='assetid,assettype'/> <%

        String sNumAssignments = ics.GetVar("allAssignments:Total");
        if (sNumAssignments != null && sNumAssignments.length() != 0 && !"0".equals(sNumAssignments)) {
            int numAssignments = Integer.parseInt(sNumAssignments);
            for (int i = 0; i < numAssignments; i++) {
                args.setValString("NAME", "allAssignments:"+String.valueOf(i));
                args.setValString("OBJVARNAME", "workflowObject");
                ics.runTag("workflowassignment.getassignedobject", args);
                args.removeAll();
                args.setValString("OBJECT", "workflowObject");
                args.setValString("VARNAME", "currentID");
                ics.runTag("workflowasset.getassetid", args);
                args.removeAll();
                args.setValString("OBJECT", "workflowObject");
                args.setValString("VARNAME", "currentAT");
                ics.runTag("workflowasset.getassettype", args);
                args.removeAll();

                if (!haveAssetType || ics.GetVar("cs_PickAssetType").equals(ics.GetVar("currentAT"))) { %>
                   <listobject:addrow name='loAssets'>
                    <listobject:argument name='assetid' value='<%=ics.GetVar("currentID")%>'/>
                    <listobject:argument name='assettype' value='<%=ics.GetVar("currentAT")%>'/>
                   </listobject:addrow> <%
                }
            }
        } %>
        <listobject:tolist name='loAssets' listvarname='lAssets'/> <%

        break;
    case SEARCH_METHOD:
        // for Search we'll display a mini search form.  A field for the search criteria,
        // an optional list of asset types, and a search button

        break;
    }

    %>
    <satellite:link assembler="query" outstring='ActiveListURL' container='servlet'>
      <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
      <satellite:argument name='cs_SelectionMethod' value='<%=String.valueOf(ACTIVELIST_METHOD)%>' />
      <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
      <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
      <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
      <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
      <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
      <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
	  <satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
	  <%if("true".equals(ics.GetVar("IFCKEditor"))){%>
	  <satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
	  <satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
	  <satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
	  <satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  <satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
	  <%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
		<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
      <%}
	  }%>
	  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
		<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
		<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <%} %>
      <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
    </satellite:link>
    <satellite:link assembler="query" outstring='HistoryURL' container='servlet'>
      <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
      <satellite:argument name='cs_SelectionMethod' value='<%=String.valueOf(HISTORY_METHOD)%>' />
      <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
      <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
      <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
      <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
      <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
      <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
	  <satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
	  <%if("true".equals(ics.GetVar("IFCKEditor"))){%>
	  <satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
	  <satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
	  <satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
	  <satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  <satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
	  <%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
		<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
      <%}
	  }%>
	  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
		<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
		<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <%} %>
      <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
    </satellite:link>
    <satellite:link assembler="query" outstring='AssignmentURL' container='servlet'>
      <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
      <satellite:argument name='cs_SelectionMethod' value='<%=String.valueOf(MYASSIGNMENT_METHOD)%>' />
      <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
      <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
      <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
      <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
      <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
      <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
	  <satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
	  <%if("true".equals(ics.GetVar("IFCKEditor"))){%>
	  <satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
	  <satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
	  <satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
	  <satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  <satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
	  <%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
		<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
      <%}
	  }%>
	  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
		<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
		<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <%} %>
      <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
    </satellite:link>
    <satellite:link assembler="query" outstring='SearchURL' container='servlet'>
      <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
      <satellite:argument name='cs_SelectionMethod' value='<%=String.valueOf(SEARCH_METHOD)%>' />
      <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
      <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
      <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
      <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
      <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
      <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
	  <satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
	  <%if("true".equals(ics.GetVar("IFCKEditor"))){%>
	  <satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
	  <satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
	  <satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
	  <satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  <satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
	  <%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
		<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
      <%}
	  }%>
	  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
		<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
		<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
	  <%} %>
      <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
    </satellite:link>
    <script type="text/javascript">
  		startList = function() {
			if (document.all && document.getElementById) {
				navRoot = document.getElementById("navlist");
				for (i=0; i<navRoot.childNodes.length; i++) {
					node = navRoot.childNodes[i];
					if (node.nodeName=="LI") {
						node.onmouseover=function() {
							this.className+=" sfhover";
						  }
						node.onmouseout=function() {
							this.className=this.className.replace(" sfhover", "");
						}
					}
				}
			}
		}
		window.onload=startList;
	</script>

    <div id="papheader" class="width-outer-50">
    <table cellspacing="0" border="0" cellpadding="0" width="100%"><tr><td>
		<span class="title-text"><%if ("multiple".equals(ics.GetVar("cs_SelectionStyle"))) { %>
<xlat:stream key='dvin/UI/AssetMgt/Selectassetsforfield'/>
<%} else { %>
<xlat:stream key='dvin/UI/AssetMgt/Selectassetforfield'/>
<% } %></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
<table cellspacing="0" border="0" cellpadding="0">
    <tr><td style="padding-right:15px;" <% if (selectionMethod==SEARCH_METHOD) { %>id="current"<%}%>><xlat:lookup key="dvin/Common/Search" varname="mouseover" escape="true"/>
		<a href="<%=ics.GetVar("SearchURL")%>" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;">
		<img src="<%= cs_imageDir %>/graphics/common/icon/mArrowOff.gif" hspace="1" HEIGHT="9" WIDTH="9" BORDER="0"/>
		<span <% if (selectionMethod==SEARCH_METHOD) { %>class="navigation-bar-on"<%} else {%>class="navigation-bar"<%}%>>
			<xlat:stream key='dvin/Common/Search'/>
		</span></a>
	</td>
	<td style="padding-right:15px;" <% if (selectionMethod==ACTIVELIST_METHOD) { %>id="current"<%}%>><xlat:lookup key="dvin/Common/ActiveList" varname="mouseover" escape="true"/>
		<a href="<%=ics.GetVar("ActiveListURL")%>" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;">
		<img src="<%= cs_imageDir %>/graphics/common/icon/mArrowOff.gif" hspace="1" HEIGHT="9" WIDTH="9" BORDER="0"/>
		<span <% if (selectionMethod==ACTIVELIST_METHOD) { %>class="navigation-bar-on"<%} else {%>class="navigation-bar"<%}%>>
			<xlat:stream key='dvin/Common/ActiveList'/>
		</span></a>
	</td>
	<% if (!"popup".equals(ics.GetVar("cs_environment"))) { %>
	<td style="padding-right:15px;" <% if (selectionMethod==HISTORY_METHOD){%>id="current"<%}%>><xlat:lookup key="dvin/Common/History" varname="mouseover" escape="true"/>
		<a href="<%=ics.GetVar("HistoryURL")%>" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;">
			<img src="<%= cs_imageDir %>/graphics/common/icon/mArrowOff.gif" hspace="1" HEIGHT="9" WIDTH="9" BORDER="0"/>
			<span <% if (selectionMethod==HISTORY_METHOD) { %>class="navigation-bar-on"<%} else {%>class="navigation-bar"<%}%>>
				<xlat:stream key='dvin/Common/History'/>
		</span></a>
	</td>
	<% } %>
	<td style="padding-right:15px;" <% if (selectionMethod==MYASSIGNMENT_METHOD) { %>id="current"<%}%>><xlat:lookup key="dvin/UI/MyAssignments" varname="mouseover" escape="true"/>
		<a href="<%=ics.GetVar("AssignmentURL")%>" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;">
		<img src="<%= cs_imageDir %>/graphics/common/icon/mArrowOff.gif" hspace="1" HEIGHT="9" WIDTH="9" BORDER="0"/>
		<span <% if (selectionMethod==MYASSIGNMENT_METHOD) { %>class="navigation-bar-on"<%} else {%>class="navigation-bar"<%}%>>
			<xlat:stream key='dvin/UI/MyAssignments'/>
		</span></a>
	</td></tr>
</table>
</div>
            <input type="hidden" name="action" value=""/>
    <div id="pappanel" class="width-outer-50">


                <%
                  if (selectionMethod == SEARCH_METHOD) { %>
                      <script type="text/javascript">
                         function doSearch()
                         {
							 document.forms[0].elements['action'].value = "runsearch";
                             document.forms[0].submit();
                         }
                      </script>
    
			<table class="width-outer-70" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tr>
				<td class="form-label-text">
					<% if (haveAssetType) { %>
                        <xlat:stream key='dvin/Common/AssetType'/>:
                    </td><td><BR/></td>
                 	<td class="form-inset">
						<assettype:load name='type' type='<%=ics.GetVar("cs_PickAssetType")%>'/>
                        <assettype:scatter name='type' prefix='AssetTypeObj'/>
                        <string:stream variable='AssetTypeObj:description'/><br/>
					</td>
                         <%
                      } else {
                        args.setValString("ITEMTYPE", "Search");
						if(ics.GetVar("cs_AllowedAssetType") != null){
						args.setValString("ASSETTYPE", ics.GetVar("cs_AllowedAssetType"));
                        }
						args.setValString("PUBID", ics.GetSSVar("pubid"));
                        args.setValString("LISTVARNAME", "lStartItems");
                        ics.runTag("startmenu.getmatchingstartitems", args);
                        args.removeAll();

                        IList startItems = ics.GetList("lStartItems");
                        if (startItems!= null && startItems.hasData()) { %>
                        	<xlat:stream key='dvin/Common/AssetType'/>:
                       </td><td><BR/></td>
                       <td class="form-inset">
                            <select name="StartItemAT"> <%
                                do { %>
                                    <option value="<%=startItems.getValue("assettype")%>" <%=startItems.getValue("assettype").equals(ics.GetVar("StartItemAT"))?"selected":""%>>
                                        <%if(startItems.getValue("description") !=null && startItems.getValue("description").trim().length() != 0) {%>
											<string:stream value='<%=startItems.getValue("description")%>'/>
										<%} else {%>
											<string:stream value='<%=startItems.getValue("name")%>'/>
										<%}%>
                                    </option> <%
                                } while (startItems.moveToRow(IList.next,0)); %>
                            </select>
					</td>
<%
                        }

                      } %>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
			<td class="form-label-text">
			<%
                 if (ics.GetVar("Name") != null && ics.GetVar("Name").length() != 0)
                 { %>
                   <string:encode variable='Name' varname='DisplayName'/> <%
                 } %>
                 <xlat:stream key='dvin/UI/Searchfor'/>:
			</td><td><BR/></td>
			<td class="form-inset">
				<input type="text" name="Name" value="<%=ics.GetVar("DisplayName")!=null?ics.GetVar("DisplayName"):""%>"/><br/>
			</td>
			</tr>
			
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>	
<tr><td><BR/></td><td><BR/></td><td>
   <%
                      if (haveAssetType && !"runsearch".equals(ics.GetVar("action"))) {
                        String currentType = haveAssetType?ics.GetVar("cs_PickAssetType"):ics.GetVar("StartItemAT"); %>
                        <assettype:load name='type' type='<%=currentType%>'/>
                        <assettype:scatter name='type' prefix='AssetTypeObj'/>
                        <ics:literal table='AssetPublication' column='assettype' string='<%=currentType%>' output='literal'/>
                        <ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
     						<ics:argument name = "columnvalue" value ='<%=ics.GetVar("pubid") %>'/>
     						<ics:argument name = "type" value ="Long"/>
     					</ics:callelement>
                        <%
                        Boolean isPubidValid = new Boolean(ics.GetVar("isDataValid"));
                        if(isPubidValid)
                        {
                        	String Sql = "SELECT count(*) as thecount FROM AssetPublication,"+currentType+" WHERE (AssetPublication.pubid="+ics.GetVar("pubid")+
                                     " or AssetPublication.pubid=0) AND AssetPublication.assettype="+ics.GetVar("literal")+" AND AssetPublication.assetid="+currentType+
                                     ".id AND "+currentType+".status!='VO'";
                        	IList contentCount = ics.SQL(currentType+",AssetPublication", Sql, null, -1, true, new StringBuffer()); %>

                        	<span class="form-inset"><xlat:stream key="dvin/UI/TotalAssetTypeObjplural"/>: <%=contentCount.getValue("thecount")%></span> <%
                        }
                      } %>
                      <xlat:lookup key="dvin/Common/Search" varname="XLAT_Search"/>
                      <xlat:lookup key="dvin/Common/Search" varname="_XLAT_" escape="true"/>
                      <a href="javascript:void(0);" onclick="javascript:doSearch(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Search"/></ics:callelement></a>
                      <xlat:lookup key='dvin/Common/Closethiswindow' varname='_XLAT_'/>
    <a href="javascript:void(0);" onclick="javascript:window.close(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;">
       <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/CloseWindow"/></ics:callelement>
    </a></td></tr>
                      </table>
	<string:encode variable="cs_SelectionStyle" varname="cs_SelectionStyle"/>
	<input type="hidden" name="cs_SelectionStyle" value="<%=ics.GetVar("cs_SelectionStyle")%>"/>
	<input type="hidden" name="cs_SelectionMethod" value="<%=String.valueOf(SEARCH_METHOD)%>"/>
	<string:encode variable="cs_PickAssetType" varname="cs_PickAssetType"/>
	<input type="hidden" name="cs_PickAssetType" value="<%=ics.GetVar("cs_PickAssetType")%>"/>
	<string:encode variable="cs_CallbackSuffix" varname="cs_CallbackSuffix"/>
	<input type="hidden" name="cs_CallbackSuffix" value="<%=ics.GetVar("cs_CallbackSuffix")%>"/>
	<string:encode variable="cs_History" varname="cs_History"/>
	<input type="hidden" name="cs_History" value="<%=ics.GetVar("cs_History")%>"/> <%
                      if ("runsearch".equals(ics.GetVar("action"))) {
                        // here we need to actually run the search and get the results into the lAssets list
                        if (haveAssetType)
                        {
                            ics.SetVar("StartItemAT", ics.GetVar("cs_PickAssetType"));
                        } %>
                        <listobject:create name='loAssets' columns='assetid,assettype'/>
                        <ics:callelement element='OpenMarket/Xcelerate/PrologActions/SearchPost'>
                            <ics:argument name='AssetType' value='<%=ics.GetVar("StartItemAT")%>'/>
                        </ics:callelement> <%
                        ics.RemoveVar("AssetType");
						IList searchResults = ics.GetList("Content");
                        if (searchResults != null && searchResults.hasData()) {
                            do { %>
                                <listobject:addrow name='loAssets'>
                                    <listobject:argument name='assetid' value='<%=searchResults.getValue("id")%>'/>
                                    <listobject:argument name='assettype' value='<%=ics.GetVar("StartItemAT")%>'/>
                                </listobject:addrow> <%
                            } while (searchResults.moveToRow(IList.next,0));
                        } %>
                        <listobject:tolist name='loAssets' listvarname='lAssets'/> <%
                      }
                  }
                  if (ics.GetList("lAssets")!=null && ics.GetList("lAssets").hasData()) {
                    // paginate
                    int listSize = 10;
                    int beginIndex = 1;
                    IList lAssets = ics.GetList("lAssets");
                    String beginIndexStr = ics.GetVar("beginindex");
                    if (beginIndexStr!=null) {
                        try {
                            beginIndex = Integer.parseInt(beginIndexStr);
                        } catch (NumberFormatException e) {
                            beginIndex = 1;
                        }
                    }
                    int lastIndex = beginIndex + listSize - 1;
                    if (lastIndex > lAssets.numRows()) lastIndex = lAssets.numRows();

                    // used by messages
                    ics.SetVar("startingPoint", beginIndex);
                    ics.SetVar("LastItem", lastIndex);
                    ics.SetVar("TotalResults", lAssets.numRows());
                    ics.SetVar("ResultLimit", listSize); %>
					<div style="float:right"><%
                    if (beginIndex > 1) {
                        %>
                        <satellite:link assembler="query" outstring="previousURL" >
                            <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
                            <satellite:argument name='cs_SelectionMethod' value='<%=ics.GetVar("cs_SelectionMethod")%>' />
                            <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
                            <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
                            <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
                            <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
                            <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
                            <satellite:argument name='StartItemAT' value='<%=ics.GetVar("StartItemAT")%>' />
                            <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
							<satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
                            <satellite:argument name='action' value='runsearch'/>
                            <satellite:argument name='Name' value='<%=ics.GetVar("Name")!=null?ics.GetVar("Name"):""%>'/>
                            <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
                            <satellite:argument name="beginindex" value="<%= String.valueOf(beginIndex - listSize) %>" />
                        <%if("true".equals(ics.GetVar("IFCKEditor"))){%>
							<satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
							<satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
							<satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  						<satellite:argument name='formFieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
							<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
							<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
							<satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
							<%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
								<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
							<%}
							}%>
						  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
							<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
							<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
						  <%} %>
						</satellite:link>
                        <a href="<%=ics.GetVar("previousURL") %>">
                            <img src="<%= cs_imageDir %>/graphics/common/icon/leftArrow.gif" height="12" width="11" border="0"/>
                            <xlat:stream key="dvin/UI/PreviousResultLimit"/>
                        </a> |
                        <%
                    }
                    if (lastIndex < lAssets.numRows()) {
                        int nextNum = lAssets.numRows() - lastIndex;
                        if (nextNum > listSize)
                            nextNum = listSize;
                        %>
                        <satellite:link assembler="query" outstring="nextURL" >
                            <satellite:argument name='cs_SelectionStyle' value='<%=ics.GetVar("cs_SelectionStyle")%>' />
                            <satellite:argument name='cs_SelectionMethod' value='<%=ics.GetVar("cs_SelectionMethod")%>' />
                            <satellite:argument name='cs_PickAssetType' value='<%=ics.GetVar("cs_PickAssetType")%>' />
                            <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
                            <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
                            <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
                            <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
                            <satellite:argument name='StartItemAT' value='<%=ics.GetVar("StartItemAT")%>' />
                            <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopup'/>
							<satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
                            <satellite:argument name='action' value='runsearch'/>
                            <satellite:argument name='Name' value='<%=ics.GetVar("Name")!=null?ics.GetVar("Name"):""%>'/>
                            <satellite:argument name='cs_History' value='<%=ics.GetVar("cs_History")%>' />
                            <satellite:argument name="beginindex" value="<%= String.valueOf(lastIndex + 1) %>" />
							<%if("true".equals(ics.GetVar("IFCKEditor"))){%>
							<satellite:argument name='FCKName' value='<%=ics.GetVar("FCKName")%>'/>
							<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
							<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor")%>'/>
							<satellite:argument name='fielddesc' value='<%=ics.GetVar("fielddesc")%>'/>
							<satellite:argument name='FCKAssetId' value='<%=ics.GetVar("FCKAssetId")%>'/>
							<satellite:argument name='FCKAssetType' value='<%=ics.GetVar("FCKAssetType")%>'/>
	  						<%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
								<satellite:argument name='cs_AllowedAssetType' value='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
							<%}
							}%>
						  <%if("false".equals(ics.GetVar("IFCKEditor"))){%>
							<satellite:argument name='IFCKEditor' value='<%=ics.GetVar("IFCKEditor") %>'/>
							<satellite:argument name='embedtype' value='<%=ics.GetVar("embedtype")%>'/>
						  <%} %>
						</satellite:link>
                        <a href="<%=ics.GetVar("nextURL") %>" title="<%=ics.GetVar("nextURL") %>">
                            <xlat:stream key="dvin/Common/Next"/>&nbsp;<%= nextNum %>
                            <img src="<%= cs_imageDir %>/graphics/common/icon/rightArrow.gif" height="12" width="11" border="0"/>
                        </a>
                        <%
                    }
                    if (lAssets.numRows() > listSize) { %>
                        <listobject:create name='loAssets' columns='assetid,assettype'/> <%
                        for (int i = beginIndex; (i < (beginIndex + 10)) && i <= lAssets.numRows(); i++) {
                            lAssets.moveTo(i); %>
                            <listobject:addrow name='loAssets'>
                                <listobject:argument name='assetid' value='<%=lAssets.getValue("assetid")%>'/>
                                <listobject:argument name='assettype' value='<%=lAssets.getValue("assettype")%>'/>
                            </listobject:addrow> <%
                        } %>
                        <listobject:tolist name='loAssets' listvarname='lAssets'/> <%
                    }
                    // done paginating %>
                    </div><div class="width-outer-50">                    <% if (lAssets.numRows()==1) { %><xlat:stream key="dvin/UI/Oneitemfound"/><br/><%} else { %>
                    <xlat:stream key="dvin/UI/ItemsstartingPointLastItemTotalResults"/><br/>
					<% } %></div>
					<table class="width-outer-50"><tr><td>
					<ics:callelement element='OpenMarket/Xcelerate/Actions/AssetMgt/TileMixedAssets'>
                        <ics:argument name='list' value='lAssets'/>
                        <ics:argument name='doStatus' value='false'/>
                        <ics:argument name='doModified' value='false'/>
						<ics:argument name='doIcons' value='false' />
						<ics:argument name='doDaysExpired' value='false' />
                    </ics:callelement>
                    </td></tr></table>
					<script type="text/javascript">
                      <%
                      if ("multiple".equals(ics.GetVar("cs_SelectionStyle"))) { %>
                          function SetSelection(SelectedAssets)
                          {
                              var obj = document.forms[0].elements[0];
                              var selections = obj.form.elements['cs_SelectedAssets'];
                              for (var i = 0; i < selections.length; i++) {
                                  if (SelectedAssets == selections[i].value)
                                      selections[i].checked = !selections[i].checked;
                              }
                          } <%
                      } else { %>
                          function SetSelection(SelectedAssets)
                          {
                            if (window.opener && window.opener.PickAssetCallback_<%=ics.GetVar("cs_CallbackSuffix")%>) {
                                  window.opener.PickAssetCallback_<%=ics.GetVar("cs_CallbackSuffix")%>(SelectedAssets);
                                  window.close();
                            } else {
								<%if("link".equals(ics.GetVar("embedtype"))){%>
									document.forms[0].elements['pagename'].value="OpenMarket/Xcelerate/Actions/EmbeddedLink";							
								<%} else {%>
									document.forms[0].elements['pagename'].value="OpenMarket/Xcelerate/Actions/AddInclusion";
								<%}%>                                
                              	if("true"=="<%=ics.GetVar("IFCKEditor")%>"){
									var AssetInfo = SelectedAssets.split(":");
									document.forms[0].elements['tn_id'].value = AssetInfo[1];
									document.forms[0].elements['tn_AssetType'].value = AssetInfo[0];
									document.forms[0].elements['name'].value = document.forms[0].elements['FCKName'].value;
									document.forms[0].elements['AssetType'].value =document.forms[0].elements['FCKAssetType'].value;
									//Check if the asset is linking to itself.
									if( AssetInfo[0]=='<%=ics.GetVar("FCKAssetType")%>' && AssetInfo[1]=='<%=ics.GetVar("FCKAssetId")%>' && 'link' != '<%=ics.GetVar("embedtype")%>'){
										alert("<xlat:stream key='dvin/UI/CannotAddSelfInclude' encode='false' escape='true'/>");
										return false;
									}
									<%
									if(ics.GetVar("cs_AllowedAssetType") == null){
										ics.SetVar("cs_AllowedAssetType","");
									}
									%>
									if('<%=ics.GetVar("cs_AllowedAssetType")%>' !='' && '<%=ics.GetVar("cs_AllowedAssetType")%>'.toUpperCase().indexOf(AssetInfo[0].toUpperCase()) == -1){
										alert("<xlat:stream key='dvin/UI/CannotLinkOrIncludeThisAsset' encode='false' escape='true'/>" + '\n<%=ics.GetVar("cs_AllowedAssetType")%>');
										return false;
									}
								} else if(<%=ics.GetVar("IFCKEditor")!=null && ics.GetVar("IFCKEditor").equals("false")%>) 
								{
									var AssetInfo = SelectedAssets.split(":");
									document.forms[0].elements['tn_id'].value = AssetInfo[1];
									document.forms[0].elements['tn_AssetType'].value = AssetInfo[0];
									document.forms[0].elements['name'].value = document.forms[0].elements['assetName'].value;
									document.forms[0].elements['AssetType'].value =document.forms[0].elements['AssetType'].value;
									document.forms[0].elements['fieldname'].value =document.forms[0].elements['cs_FieldName'].value;
									document.forms[0].elements['IFCKEditor'].value = "false";
								}
								else	
									document.forms[0].elements['action'].value = "parentwindowgone";								
								document.forms[0].submit();
								return false;
							}
                          }
                     <%}%>
					</script>
					<script type="text/javascript">
                      function SetSelections()
                      {
                          var obj = document.forms[0].elements[0];
                          var selections = obj.form.elements['cs_SelectedAssets'];
                          var SelectedAssets = '';
                          if (typeof(selections.length)!='undefined')
                          {
                              for (var i = 0; i < selections.length; i++) {
                                  if (selections[i].checked) {
                                      if (SelectedAssets == '')
                                          SelectedAssets = selections[i].value;
                                      else
                                          SelectedAssets += ";" + selections[i].value;
                                  }
                              }
                          }
                          else if (selections.checked) {
                              SelectedAssets = selections.value;
                          }
                          if (SelectedAssets == '') {
                              alert("<xlat:stream key='dvin/FlexibleAssets/Common/NoAssetSelected' encode='false' escape='true'/>");
                          } else if (window.opener && window.opener.PickAssetCallback_<%=ics.GetVar("cs_CallbackSuffix")%>) {
                              window.opener.PickAssetCallback_<%=ics.GetVar("cs_CallbackSuffix")%>(SelectedAssets);
                              window.close();
                          } else {
                              document.forms[0].elements['action'].value = "parentwindowgone";
                              document.forms[0].submit();
                          }
                      }
                    </script> <%
                    if ("multiple".equals(ics.GetVar("cs_SelectionStyle"))) { %>
                        <a href="javascript:void(0)" onclick="javascript:SetSelections();" style="margin : 5px 0 0 0;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Select"/></ics:callelement></a>

<%
                    }
                  } else {
                    if (selectionMethod != SEARCH_METHOD || "runsearch".equals(ics.GetVar("action")))
                    { %>
                        <xlat:stream key='dvin/UI/NoAssetsFound'/> <%
                    }
                  }
                %>



    </div><%
} // parent window still available %>
<%if("true".equals(ics.GetVar("IFCKEditor")))
{%>
	<string:encode variable="FCKName" varname="FCKName"/>
	<INPUT TYPE="HIDDEN" NAME="FCKName" VALUE='<%=ics.GetVar("FCKName")%>'/>
	<string:encode variable="fielddesc" varname="fielddesc"/>
	<INPUT TYPE="HIDDEN" NAME="fielddesc" VALUE='<%=ics.GetVar("fielddesc")%>'/>
	<string:encode variable="FCKAssetId" varname="FCKAssetId"/>
	<INPUT TYPE="HIDDEN" NAME="FCKAssetId" VALUE='<%=ics.GetVar("FCKAssetId")%>'/>
	<string:encode variable="FCKAssetType" varname="FCKAssetType"/>
	<INPUT TYPE="HIDDEN" NAME="FCKAssetType" VALUE='<%=ics.GetVar("FCKAssetType")%>'/>
	<string:encode variable="embedtype" varname="embedtype"/>
	<INPUT TYPE="HIDDEN" NAME="embedtype" VALUE='<%=ics.GetVar("embedtype")%>'/>
	<string:encode variable="IFCKEditor" varname="IFCKEditor"/>
	<INPUT TYPE="HIDDEN" NAME="IFCKEditor" VALUE='<%=ics.GetVar("IFCKEditor")%>'/>
	<string:encode variable="modeType" varname="modeType"/>
	<INPUT TYPE="HIDDEN" NAME="modeType" VALUE='<%=ics.GetVar("modeType")%>'/>
	<%if(ics.GetVar("cs_AllowedAssetType") !=null) {%>
		<string:encode variable="cs_AllowedAssetType" varname="cs_AllowedAssetType"/>
		<INPUT TYPE="HIDDEN" NAME="cs_AllowedAssetType" VALUE='<%=ics.GetVar("cs_AllowedAssetType")%>'/>
	<%}%>
	<INPUT TYPE="HIDDEN" NAME="tn_id" VALUE=""/>
	<!-- name and AssetType are dummy fields and their values will be replaced by the values of FCKname and FCKAssetType 
		fields before submitting to EmbeddedLink/AddInclusion page -->

	<INPUT TYPE="HIDDEN" NAME="name" VALUE=""/>
	<INPUT TYPE="HIDDEN" NAME="AssetType" VALUE=""/>
	<INPUT TYPE="HIDDEN" NAME="tn_AssetType" VALUE=""/>
<%
}
	else if("false".equals(ics.GetVar("IFCKEditor")))
	{
%>		
		<string:encode variable="name" varname="name"/>
		<INPUT TYPE="HIDDEN" NAME="name" VALUE='<%=ics.GetVar("name") %>'/>
		<string:encode variable="assetName" varname="assetName"/>
		<INPUT TYPE="HIDDEN" NAME="assetName" VALUE='<%=ics.GetVar("name")%>' />
		<string:encode variable="formFieldName" varname="formFieldName"/>
		<INPUT TYPE="HIDDEN" NAME="formFieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
		<string:encode variable="embedtype" varname="embedtype"/>
		<INPUT TYPE="HIDDEN" NAME="embedtype" VALUE='<%=ics.GetVar("embedtype")%>'/>
		<INPUT TYPE="HIDDEN" NAME="tn_id" VALUE=""/>
		<INPUT TYPE="HIDDEN" NAME="tn_AssetType" VALUE=""/>
		<string:encode variable="IFCKEditor" varname="IFCKEditor"/>
		<INPUT TYPE="HIDDEN" NAME="IFCKEditor" VALUE='<%=ics.GetVar("IFCKEditor")%>' />
		<string:encode variable="AssetType" varname="AssetType"/>
		<INPUT TYPE="HIDDEN" NAME="AssetType" VALUE='<%=ics.GetVar("AssetType")%>'/>
<%		
	}
%>
	<string:encode variable="cs_FieldName" varname="cs_FieldName"/>
    <INPUT TYPE="HIDDEN" NAME="cs_FieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>' />
	<string:encode variable="formFieldName" varname="formFieldName"/>
    <INPUT TYPE="HIDDEN" NAME="formFieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
	<string:encode variable="fieldname" varname="fieldname"/>
	<INPUT TYPE="HIDDEN" NAME="fieldname" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
	<string:encode variable="pubid" varname="pubid"/>
	<INPUT TYPE="HIDDEN" NAME="pubid" VALUE='<%=ics.GetVar("pubid")%>'/>
	<INPUT type="HIDDEN" name="pagename" value="OpenMarket/Xcelerate/Actions/PickAssetPopup"/>
	<string:encode variable="EditingStyle" varname="EditingStyle"/>
	<INPUT type="HIDDEN" name="EditingStyle" value="<%=ics.GetVar("EditingStyle")%>"/>	
</cs:ftcs>
