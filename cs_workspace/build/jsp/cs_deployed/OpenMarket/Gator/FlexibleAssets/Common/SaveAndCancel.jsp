<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="workflowasset" uri="futuretense_cs/workflowasset.tld"
%><%@ taglib prefix="workflowengine" uri="futuretense_cs/workflowengine.tld"
%><%@ page import="com.openmarket.xcelerate.commands.PreviewURLGeneratorDispatcher"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%//
// OpenMarket/Gator/FlexibleAssets/Common/SaveAndCancel
//
// INPUT
//	ssvar:
//		locale		different images are used for different locale
//	var:
//		cs_imagedir the Xcelerate base url, e.g. "/Xcelerate"
//		updatetype	"setformdefaults" means creation, save.gif is used as save button
//                  otherwise use save_changes.gif for editting.
//		ThisPage
//                  This variable is used in the checkfields() javascript.
//      DMSupported whether this asset support switching between DM and WCM views
//      cs_formmode the current view is DM or WCM
// OUTPUT
//		a Cancel button and a Save button in a row.
//      plus a optional DM or WCM link, only if the asset type support both formmode.
%><cs:ftcs>
<ics:if condition='<%="EditFront".equals(ics.GetVar("ThisPage"))%>'>
<ics:then>
	<ics:if condition='<%="false".equals(ics.GetVar("CanPreview"))%>'>
	<ics:then>
		<ics:setvar name="NoPreview" value="true"/>
	</ics:then>
	</ics:if>
	<ics:if condition='<%=!"true".equals(ics.GetVar("NoPreview"))%>'>
	<ics:then>
		<workflowasset:load assettype='<%=ics.GetVar("AssetType")%>' id='<%=ics.GetVar("id")%>' objvarname="workflowasset"/>
		<workflowengine.isfunctionlegal object="workflowasset" functionname="preview" site='<%=ics.GetSSVar("pubid")%>' varname="isLegal" mustbeassigned="false"/>
	<ics:if condition='<%="false".equals(ics.GetVar("isLegal"))%>'>
	<ics:then>
		<ics:setvar name="NoPreview" value="true"/>
	</ics:then>
	</ics:if>
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>
<div dojoType="dijit.layout.ContentPane" region="top">
<div class='toolbarContent'>
<table>
    <%
    String sImageDIR = ics.GetVar("cs_imagedir");
    String sLocale = ics.GetSSVar("locale");
    boolean create = "setformdefaults".equals(ics.GetVar("updatetype"));
    %>
    <xlat:lookup key="dvin/UI/Save" varname="SaveAlt"/>
    <xlat:lookup key="dvin/UI/Admin/InspectThisDescription" varname="InspectAlt"/>
	<xlat:lookup key="dvin/UI/GoBack" varname="GoBackAlt"/>
	<xlat:lookup key="UI/Forms/RefreshThisDescription" varname="RefreshDesc" escape="true"/>
    <%
    String sSaveAlt = ics.GetVar("SaveAlt");
    String sInspectAlt = ics.GetVar("InspectAlt");
	String sGoBackAlt = ics.GetVar("GoBackAlt");
    String sRefreshDesc = ics.GetVar("RefreshDesc");
    //Cleanup temp variables
    ics.RemoveVar("SaveAlt");
    ics.RemoveVar("InspectAlt");
	ics.RemoveVar("GoBackAlt");
    ics.RemoveVar("RefreshDesc");
    %>
	<tr>
		<td align="left">
		<ics:if condition='<%=!"EditFront".equals(ics.GetVar("ThisPage"))%>'>
		<ics:then>
			<a href="javascript:void(0)" onclick="return cancelFlexContentForm();">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
					<ics:argument name="buttonImage" value="goback.png"/>
					<ics:argument name="toolbartitle" value="<%=sGoBackAlt%>"/>
				</ics:callelement>
			</a>
		</ics:then>
		</ics:if>
		<ics:if condition='<%="EditFront".equals(ics.GetVar("ThisPage"))%>'>
		<ics:then>
			<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
				<ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
				<ics:argument name="assetid" value='<%=ics.GetVar("id")%>'/>
				<ics:argument name="varname" value="urlInspectItem"/>
				<ics:argument name="function" value="inspect"/>
			</ics:callelement>
			<a href="<%=ics.GetVar("urlInspectItem")%>">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
					<ics:argument name="buttonImage" value="inspect.png"/>
					<ics:argument name="toolbartitle" value="<%=sInspectAlt%>"/>
				</ics:callelement>
			</a>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
				<ics:argument name="buttonImage" value="separator.png"/>
				<ics:argument name="toolbartitle" value=""/>
			</ics:callelement>
		</ics:then>
		</ics:if>		
			<a href="javascript:void(0)" onclick="return submitFlexContentForm();">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
					<ics:argument name="buttonImage" value="save.png"/>
					<ics:argument name="toolbartitle" value="<%=sSaveAlt%>"/>
				</ics:callelement>
			</a>
			<ics:if condition='<%="EditFront".equals(ics.GetVar("ThisPage"))%>'>
			<ics:then>
				
				<ics:if condition='<%=null == ics.GetVar("NoPreview")%>'>
				<ics:then>
<%
					FTValList vN = new FTValList();
					vN.setValString("VARNAME", "previewURL");
					vN.setValString("ASSETTYPE", ics.GetVar("AssetType"));
					vN.setValString("ASSETID", ics.GetVar("id"));
					vN.setValString("PUBID", ics.GetSSVar("pubid"));
					PreviewURLGeneratorDispatcher.MakeURL(ics, vN);
%>
					<ics:if condition='<%=null != ics.GetVar("previewURL")%>'>
					<ics:then>
						<ics:callelement element="OpenMarket/Xcelerate/Scripts/GotoPreview" />
						<xlat:lookup key="dvin/Common/Preview" escape="true" varname="_XLAT_"/>
						<a href="javascript:void(0)" onclick="openPreview('<%=ics.GetVar("previewURL")%>');">
							<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
								<ics:argument name="buttonImage" value="preview.png"/>
								<ics:argument name="toolbartitle" value='<%=ics.GetVar("_XLAT_")%>'/>
							</ics:callelement>
						</a>						
					</ics:then>
					</ics:if>
				</ics:then>
				</ics:if>				
				
				<xlat:lookup key="dvin/UI/ApproveforPublish" escape="true" varname="_XLAT_"/>
				<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
					<ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
					<ics:argument name="assetid" value='<%=ics.GetVar("id")%>'/>
					<ics:argument name="varname" value="urlapprfront"/>
					<ics:argument name="function" value="approve"/>
				</ics:callelement>
				
				<a href="<%=ics.GetVar("urlapprfront")%>">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
						<ics:argument name="buttonImage" value="approve.png"/>
						<ics:argument name="toolbartitle" value='<%=ics.GetVar("_XLAT_")%>'/>
					</ics:callelement>
				</a>
				
				<xlat:lookup key="dvin/UI/Admin/DeleteThisDescription" varname="_XLAT_"/>
				<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
					<ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
					<ics:argument name="assetid" value='<%=ics.GetVar("id")%>'/>
					<ics:argument name="varname" value="urldelfront"/>
					<ics:argument name="function" value="delete"/>
				</ics:callelement>
				<a href="<%=ics.GetVar("urldelfront")%>">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
						<ics:argument name="buttonImage" value="delete.png"/>
						<ics:argument name="toolbartitle" value='<%=ics.GetVar("_XLAT_")%>'/>
					</ics:callelement>
				</a>
			
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
					<ics:argument name="buttonImage" value="separator.png"/>
					<ics:argument name="toolbartitle" value=""/>
				</ics:callelement>				
				
				<xlat:lookup key="dvin/Common/Edit" escape="true" varname="_XLAT_"/>
				<xlat:lookup key="dvin/UI/Admin/EditThisDescription" escape="true" varname="_ALT_"/>
				<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
					<ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
					<ics:argument name="assetid" value='<%=ics.GetVar("id")%>'/>
					<ics:argument name="varname" value="urlInspectItem"/>
					<ics:argument name="function" value="edit"/>
				</ics:callelement>
				<ics:setvar name="editCheck" value="true"/>
				<ics:if condition='<%="Template".equals(ics.GetVar("AssetType"))%>'>
				<ics:then>
					<!-- check whther user is allowed to edit SiteCatalog or ElementCatalog -->
					<% boolean member = ics.UserIsMember("PageEditor");%>
					<ics:if condition='<%=member%>'>
					<ics:then>					
						<asset:getassettype  name='<%=ics.GetVar("assetname")%>' outname="at" />
						<assettype:get name="at" field="description" output="at:description"/>
						<ics:setvar name="editCheck" value="WrongACLToEditAsset"/>
					</ics:then>
					<ics:else>
						<% boolean isMember = ics.UserIsMember("ElementEditor");%>
						<ics:if condition='<%=isMember%>'>
						<ics:then>
							<asset:getassettype  name='<%=ics.GetVar("assetname")%>' outname="at" />
							<assettype:get name="at" field="description" output="at:description"/>
							<ics:setvar name="editCheck" value="WrongACLToEditAsset"/>
						</ics:then>
						</ics:if>
					</ics:else>
					</ics:if>
				</ics:then>
				</ics:if>
				<ics:if condition='<%="true".equals(ics.GetVar("editCheck"))%>'>
				<ics:then>
					<a style="position: absolute; right: 9px" href="<%=ics.GetVar("urlInspectItem")%>">
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
							<ics:argument name="buttonImage" value="refresh.png"/>
							<ics:argument name="toolbartitle" value="<%=sRefreshDesc%>"/>
						</ics:callelement>
					</a>
				</ics:then>
				</ics:if>
			</ics:then>
			</ics:if>	
            <%
            if ( "WCM".equals(ics.GetVar("cs_formmode")) ) {
            	if (String.valueOf(true).equals(ics.GetVar("DMSupported"))) {
                String formmode = "DM";
                %><xlat:lookup key='<%="dvin/FlexibleAssets/FormMode/"+formmode%>' varname="FormModeDesc" escape="true"/><%
                String sFormModeDesc = ics.GetVar("FormModeDesc");
                ics.RemoveVar("FormModeDesc");
                %>
                <img height="1" width="10" src="<%=sImageDIR%>/graphics/common/screen/dotclear.gif"/>
                <script>
                    function ChangeFormMode(formmode)
                    {
                        var form = document.forms[0];
                        if (form.elements['doSubmit'].value=="yes")
                        {
                            form.TemplateChosen.value = form.flextemplateid.value;
                            form.MultiAttrVals.value="addanother";
                            form.cs_formmode.value=formmode;

                            repostFlexContentForm();
                        }
                        return false;
                    }
                </script>
                <a href="javascript:void(0)"
                    onclick="return ChangeFormMode('<%=formmode%>');"
                    onmouseover="window.status='<%=sFormModeDesc%>';return true;"
                    onmouseout="window.status='';return true"><xlat:stream key='<%="dvin/FlexibleAssets/FormMode/"+formmode%>'/></a>
                <%
            	}
            }
            %>
		</td>
	</tr></table>
	</div>
	<div id="msgArea"></div>
	<div class="toolbarBorder"></div>
</div>
</cs:ftcs>