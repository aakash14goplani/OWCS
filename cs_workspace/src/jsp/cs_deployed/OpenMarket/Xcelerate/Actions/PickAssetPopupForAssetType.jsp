<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/PickAssetPopupForAssetType
//
// INPUT
//  cs_SelectionStyle - required [single|multiple]
//  cs_CallbackSuffix - required suffix to the callback function name
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
<div class="width-outer-70">
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<%
FTValList args = new FTValList();
String cs_imageDir = ics.GetVar("cs_imagedir");
//Set the asset type name into field name to display at the top of the page
ics.SetVar("cs_FieldName",ics.GetVar("searchAType"));
%>
<%

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
{ %><div id="papheader">
<div class="title-text"><xlat:stream key='dvin/UI/AssetMgt/Selectassetsforfield'/></div>
</div>
<div id="pappanel">
    <xlat:lookup key='dvin/UI/AssetMgt/Fieldtosubmitnotavailable' varname='errorStr'/>
    <ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/ShowMessage'>
        <ics:argument name='severity' value='error'/>
        <ics:argument name='msgtext' value='<%=ics.GetVar("errorStr")%>'/>
    </ics:callelement>
    <xlat:lookup key='dvin/Common/Closethiswindow' varname='_XLAT_'/>
    <a href="javascript:void(0);" onclick="javascript:window.close(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/CloseWindow"/></ics:callelement></a>
</div>
    <%
}%>
<div id="papheader">
<div class="title-text">
<%if ("multiple".equals(ics.GetVar("cs_SelectionStyle"))) { %>
<xlat:stream key='dvin/UI/AssetMgt/Selectassetsforfield'/>
<%} else { %>
<xlat:stream key='dvin/UI/AssetMgt/Selectassetforfield'/>
<% } %>
</div>
</div>
</div>
            <input type="hidden" name="action" value=""/>
    <div id="pappanel">
	<string:encode variable="cs_SelectionStyle" varname="cs_SelectionStyle"/>
	<input type="hidden" name="cs_SelectionStyle" value="<%=ics.GetVar("cs_SelectionStyle")%>"/>
	<string:encode variable="cs_CallbackSuffix" varname="cs_CallbackSuffix"/>
	<input type="hidden" name="cs_CallbackSuffix" value="<%=ics.GetVar("cs_CallbackSuffix")%>"/>
	                    <listobject:create name='loAssets' columns='assetid,assettype'/>
                        <%
						String qrydata = ics.getSQL("OpenMarket/Xcelerate/AssetType/" + ics.GetVar("searchAType") + "/SelectSummary");
						//Replace SessionVariables.pubid with Variables.pubid in the query data.
						qrydata =  qrydata.replaceAll("SessionVariables.pubid", "Variables.pubid");
						ics.SetVar("AssetType",ics.GetVar("searchAType"));
						ics.SetVar("queryend","ORDER BY " + ics.GetVar("searchAType") + ".name");
						ics.SetVar("queryfields","");
						qrydata = ics.ResolveVariables(qrydata);
						%>
						<%-- above code already assumes selectsummary.sql contains SessionVariables.pubid, 
+						so we'll also assume query contains AssetPublication --%>
+						<ics:sql sql="<%=qrydata%>" listname="Content" table='<%=ics.GetVar("searchAType")+",AssetPublication"%>' limit="1000"/>
						<%
						ics.RemoveVar("AssetType");
						IList searchResults = ics.GetList("Content");
                        if (searchResults != null && searchResults.hasData()) {
                            do { %>
                                <listobject:addrow name='loAssets'>
                                    <listobject:argument name='assetid' value='<%=searchResults.getValue("id")%>'/>
                                    <listobject:argument name='assettype' value='<%=ics.GetVar("searchAType")%>'/>
                                </listobject:addrow> <%
                            } while (searchResults.moveToRow(IList.next,0));
                        } %>
                        <listobject:tolist name='loAssets' listvarname='lAssets'/> <%
                    
                
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
                            <satellite:argument name='searchAType' value='<%=ics.GetVar("searchAType")%>' />
                            <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
                            <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
                            <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
                            <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
                            <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopupForAssetType'/>
							<satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
                            <satellite:argument name='Name' value='<%=ics.GetVar("Name")!=null?ics.GetVar("Name"):""%>'/>
                            <satellite:argument name="beginindex" value="<%= String.valueOf(beginIndex - listSize) %>" />
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
                            <satellite:argument name='searchAType' value='<%=ics.GetVar("searchAType")%>' />
                            <satellite:argument name='cs_CallbackSuffix' value='<%=ics.GetVar("cs_CallbackSuffix")%>' />
                            <satellite:argument name='cs_FieldName' value='<%=ics.GetVar("cs_FieldName")%>' />
                            <satellite:argument name='cs_environment' value='<%=ics.GetVar("cs_environment")%>' />
                            <satellite:argument name='cs_formmode' value='<%=ics.GetVar("cs_formmode")%>' />
                            <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PickAssetPopupForAssetType'/>
							<satellite:argument name='pubid' value='<%=ics.GetVar("pubid")%>'/>
                            <satellite:argument name='Name' value='<%=ics.GetVar("Name")!=null?ics.GetVar("Name"):""%>'/>
                            <satellite:argument name="beginindex" value="<%= String.valueOf(lastIndex + 1) %>" />
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
                    </div><div class="width-outer-70">                    <% if (lAssets.numRows()==1) { %><xlat:stream key="dvin/UI/Oneitemfound"/><br/><%} else { %>
                    <xlat:stream key="dvin/UI/ItemsstartingPointLastItemTotalResults"/><br/>
					<% } %></div>
					<ics:callelement element='OpenMarket/Xcelerate/Actions/AssetMgt/TileMixedAssets'>
                        <ics:argument name='list' value='lAssets'/>
                        <ics:argument name='doStatus' value='false'/>
                        <ics:argument name='doModified' value='false'/>
						<ics:argument name='doIcons' value='false' />
						<ics:argument name='doDaysExpired' value='false' />
                    </ics:callelement>
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
                    %>
                        <xlat:stream key='dvin/UI/NoAssetsFound'/> 
					<%
                  }
                %>



    </div>   <BR/> <div class="width-outer-70">    <xlat:lookup key='dvin/Common/Closethiswindow' varname='_XLAT_'/>
    <a href="javascript:void(0);" onclick="javascript:window.close(); return false;" onmouseover="window.status='<%= ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;">
        <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/CloseWindow"/></ics:callelement>
    </a></div> <%
 // parent window still available %>
	<string:encode variable="name" varname="name"/>
	<INPUT TYPE="HIDDEN" NAME="name" VALUE='<%=ics.GetVar("name") %>'/>
	<INPUT TYPE="HIDDEN" NAME="assetName" VALUE='<%=ics.GetVar("name")%>' />
	<string:encode variable="cs_FieldName" varname="cs_FieldName"/>
	<INPUT TYPE="HIDDEN" NAME="formFieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
	<string:encode variable="AssetType" varname="AssetType"/>
	<INPUT TYPE="HIDDEN" NAME="AssetType" VALUE='<%=ics.GetVar("AssetType")%>'/>
    <INPUT TYPE="HIDDEN" NAME="cs_FieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>' />
    <INPUT TYPE="HIDDEN" NAME="formFieldName" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
	<INPUT TYPE="HIDDEN" NAME="fieldname" VALUE='<%=ics.GetVar("cs_FieldName")%>'/>
	<string:encode variable="pubid" varname="pubid"/>
	<INPUT TYPE="HIDDEN" NAME="pubid" VALUE='<%=ics.GetVar("pubid")%>'/>
	<INPUT type="HIDDEN" name="pagename" value="OpenMarket/Xcelerate/Actions/PickAssetPopupForAssetType"/>
</cs:ftcs>
