<%@ page import="COM.FutureTense.Interfaces.IList,
                 com.fatwire.flame.dm.HierarchyNode,
                 com.fatwire.flame.portlets.PortletStyles,
                 com.fatwire.flame.portlets.DocumentManagement,
                 com.fatwire.satellite.Satellite,
                 java.util.Iterator,
                 java.util.Map"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="workflowengine" uri="futuretense_cs/workflowengine.tld"
%><%@ taglib prefix="workflowasset" uri="futuretense_cs/workflowasset.tld"
%><%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"
%><%//
// OpenMarket/Xcelerate/Flame/DocumentManagement/DocumentManagement_View
//
// INPUT
//
// OUTPUT
//%><cs:ftcs>
<string:encode varname="cs_imagedir" variable="cs_imagedir" />
<%
    ics.CallElement( "OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null );

    String  sImageBaseURL   = ics.GetVar( "cs_imagedir" );

    //Get the site id from the session
    String  sPubId          = ics.GetSSVar( "pubid" );
    String  sDocType        = request.getParameter( DocumentManagement.PARAM_DOC_TYPE );
        //(String)request.getAttribute( DocumentManagement.PARAM_DOC_TYPE );
    String  sFolderType     = sDocType == null ? null : DocumentManagement.getFolderType(ics, sDocType);
        //(String)request.getAttribute( DocumentManagement.PARAM_FOLDER_TYPE );

    //Get the current folder id from the request - null means root
    String  sFolderId  		= request.getParameter( DocumentManagement.PARAM_FOLDERID );

    //Get the current page number (assume we'll never get a page number out of range)
    String	sPage			= request.getParameter( DocumentManagement.PARAM_PAGE_NUMBER );

    if ( sFolderId != null )
    { //Need to find out whether the folder is still valid (not deleted). If not valid, set folder to the root.
  %>
      <asset:list type="SparkFolder" list="retlist" excludevoided="true" field1="id" value1="<%=sFolderId %>"/>
  <%
       IList mylist = ics.GetList( "retlist" );
       int rows = mylist.numRows();
       if( rows == 0 )
       {
          sFolderId = sPage = null;
       }
    }
    int     iPage           = ( sPage == null ) ? 0 : new Integer( sPage ).intValue();

    //Calculate the starting index from the (zero-based) page number and the page size
    int iStartIndex = iPage * DocumentManagement.PAGE_SIZE;

    DocumentManagement.View view = DocumentManagement.getView(ics, sPubId, sDocType, sFolderId, iStartIndex, DocumentManagement.PAGE_SIZE);
	HierarchyNode[] breadCrumbs = view.getBreadCrumbs();
	//Assume at least 1 node, which is the current folder/assettype/site
	Map refresh = breadCrumbs[0].getParameters();
	/*if (breadCrumbs != null && breadCrumbs.length > 0) {
		HierarchyNode node = breadCrumbs[0];
		if (node != null) {
			Map param = node.getParameters();
			if (param != null) {
				sDocType = (String) param.get(DocumentManagement.PARAM_DOC_TYPE);
				sFolderId = (String) param.get(DocumentManagement.PARAM_FOLDERID);
			}
		}
	}*/

    //First page that contains a document
    int iJumpDocsPage   = (view.getFolderCount() + 1) / DocumentManagement.PAGE_SIZE;
    //Total number of items
    int iNumItems       = view.getFolderCount() + view.getDocumentCount();

    if (breadCrumbs != null && breadCrumbs.length > 0) {
		%>
		<satellite:link assembler="query" outstring="fatwire_refresh" portleturltype="render">
		<%
		if (refresh != null) for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
		}
		%>
			<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="<%=String.valueOf(iPage)%>"/>
		</satellite:link>
		<script>
		if (!window.fatwire_refresh)
		{
			window.fatwire_refresh = new Function("window.location = \"<%=ics.GetVar("fatwire_refresh")%>\";window.focus();");
		}
		</script>
		<%
    }
    //Call the element to write out the popup Javascript
    ics.CallElement( "OpenMarket/Flame/Common/Script/Popup", null );
	%>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="dmportlet">
	<tr>
		<td></td>
		<td valign="top" height="1" background="<%=sImageBaseURL %>/graphics/common/screen/blackdot.gif"><img src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
		<td></td>
	</tr>
	<tr>
		<td valign="top" width="1" background="<%=sImageBaseURL %>/graphics/common/screen/blackdot.gif"><img width="1" height="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/blackdot.gif"><img width="1" height="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
			</tr>
			<tr>
				<!-- Get the description of the current site -->
				<publication:load name="thePub" objectid="<%=sPubId%>"/>
				<publication:get name="thePub" field="description" output="pubDescription" />
				<td colspan="2" class="portlet-section-header" style="padding:3px" ><div class="portlet-form-label"><%=ics.GetVar( "pubDescription" ) %></div></td>
			</tr>
			<tr>
				<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
			</tr>
			<tr>
				<td class="portlet-section-subheader" style="padding:3px">
					<%
					if( breadCrumbs != null && breadCrumbs.length > 0 ) {
						if( breadCrumbs.length > 1 ) {
							//The penultimate crumb links to the parent which is the same as up one level
							HierarchyNode up = breadCrumbs[1];

                            Map params = up.getParameters();
                            if (params != null) {
                                %>
                                <satellite:link assembler="query" outstring="upURL" portleturltype="render">
                                <%
                                for (Iterator it = up.getParameters().entrySet().iterator(); it.hasNext();) {
                                    Map.Entry entry = (Map.Entry) it.next();
                                    %><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
                                }
                                %>
                                </satellite:link>
                                <xlat:lookup key="fatwire/Flame/DocMgmt/UpLevel" varname="_XLAT_" />
                                <a href='<%=ics.GetVar("upURL")%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/up-folder.gif"%>' border="0" alt='<%=ics.GetVar( "_XLAT_" )%>' /></a>&nbsp;
                                <%
                            } else {
                                //todo: show a gray-outed picture
                            }
						}
						%>
						<!-- Generate a link for Jump to Folders (which is the same as the link to the first page -->
						<satellite:link assembler="query" outstring="jumpFoldersURL" portleturltype="render">
							<%
							for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
								Map.Entry entry = (Map.Entry) it.next();
								%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
							}
							%>
							<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="0"/>
						</satellite:link>
						<xlat:lookup key="fatwire/Flame/DocMgmt/JumpFolders" varname="_XLAT_" />
						<a href='<%=ics.GetVar( "jumpFoldersURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/jump-to-folders-icon.gif"%>' border="0" alt='<%=ics.GetVar( "_XLAT_" )%>' /></a>&nbsp;
						<!-- Generate a link for Jump to Documents -->
						<satellite:link assembler="query" outstring="jumpDocsURL" portleturltype="render">
							<%
							for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
								Map.Entry entry = (Map.Entry) it.next();
								%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
							}
							%>
							<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="<%=String.valueOf( iJumpDocsPage )%>"/>
						</satellite:link>
						<xlat:lookup key="fatwire/Flame/DocMgmt/JumpDocs" varname="_XLAT_" />
						<a href='<%=ics.GetVar( "jumpDocsURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/jump-to-docs-icon.gif"%>' border="0" alt='<%=ics.GetVar( "_XLAT_" )%>' /></a>
						<%
					}
					%>&nbsp;
				</td>

				<!-- Pagination controls -->
				<td class="portlet-section-subheader" align="right" width="*" style="padding:3px">
					<nobr>
					<%

						int iLastPage   = iNumItems / DocumentManagement.PAGE_SIZE + ( iNumItems % DocumentManagement.PAGE_SIZE > 0 ? 1 : 0 ) - 1;
						int	iLastItem	= iStartIndex + DocumentManagement.PAGE_SIZE;
						iLastItem		= iLastItem > iNumItems ? iNumItems : iLastItem;

						//Show links to previous and first page if we're not at the first page
						if( iPage > 0 )
						{  %>
							<xlat:lookup key="dvin/Common/First" varname="_XLAT_" />
							<a href='<%=ics.GetVar( "jumpFoldersURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/doubleArrowLeft.gif"%>' width="15" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
							<satellite:link assembler="query" outstring="backPageURL" portleturltype="render">
								<%
								for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
									Map.Entry entry = (Map.Entry) it.next();
									%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
								}
								%>
								<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="<%=String.valueOf( iPage - 1 )%>"/>
							</satellite:link>
							<xlat:lookup key="dvin/Common/Previous" varname="_XLAT_" />
							<a href='<%=ics.GetVar( "backPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/leftArrow.gif"%>' width="11" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
					<%  }

						//Set vars for localization
						//  Variables.startIndex - Variables.endIndex of Variables.totalItems
						//  e.g. 1 - 10 of 50
						int iFirstItem  = iStartIndex + 1;
						iFirstItem = iNumItems == 0 ? 0 : iFirstItem;
						ics.SetVar( "startIndex", iFirstItem );
						ics.SetVar( "endIndex", iLastItem );
						ics.SetVar( "totalItems", iNumItems );
					%>
					<xlat:stream key="fatwire/Flame/Common/PaginationDisplay" />
					<!-- Show links to next and last page if we're not at the last page -->
					<%  if( iPage < iLastPage )
						{   %>
							<satellite:link assembler="query" outstring="nextPageURL" portleturltype="render">
								<%
								for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
									Map.Entry entry = (Map.Entry) it.next();
									%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
								}
								%>
								<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="<%=String.valueOf( iPage + 1 )%>"/>
							</satellite:link>
							<xlat:lookup key="dvin/Common/Next" varname="_XLAT_" />
							<a href='<%=ics.GetVar( "nextPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/rightArrow.gif"%>' width="11" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
							<satellite:link assembler="query" outstring="lastPageURL" portleturltype="render">
								<%
								for (Iterator it = refresh.entrySet().iterator(); it.hasNext();) {
									Map.Entry entry = (Map.Entry) it.next();
									%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%
								}
								%>
								<satellite:argument name="<%=DocumentManagement.PARAM_PAGE_NUMBER%>" value="<%=String.valueOf( iLastPage )%>"/>
							</satellite:link>
							<xlat:lookup key="dvin/Common/Last" varname="_XLAT_" />
							<a href='<%=ics.GetVar( "lastPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/doubleArrow.gif"%>' width="15" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
							<%
						}   %>
					</nobr>
				</td>
			</tr>
			<tr>
				<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
			</tr>
			<%
			//Call the element to display the breadcrumb trail
			ics.SetObj(DocumentManagement.DM_VIEW_BREADCRUMB_PAGENAME, breadCrumbs);
			ics.CallElement( DocumentManagement.DM_VIEW_BREADCRUMB_PAGENAME, null);
			ics.SetObj(DocumentManagement.DM_VIEW_BREADCRUMB_PAGENAME, null);

			//Define style for alternating rows
			String	sStyle	= PortletStyles.PORTLET_SECTION_BODY;

			%>
			<tr>
				<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
			</tr>
			<tr>
				<td class="<%=sStyle%>" style="padding:3px">
					<% HierarchyNode node = (HierarchyNode)breadCrumbs[0]; %>
					<nobr><img src="<%=sImageBaseURL%>/graphics/common/icon/folder_open.gif" border="0"><%=node.getName()%></nobr>
				</td>
				<%
				//This user can inspect this folder, show the inspect icon
				if (sFolderType != null && sFolderId != null &&
					DocumentManagement.canExecute(ics, sPubId, sFolderType, sFolderId, DocumentManagement.FUNC_INSPECT) )
				{
					%>
					<satellite:link assembler="query" outstring="inspectURL" container="servlet">
						<satellite:argument name="AssetType" value="<%=sFolderType%>" />
						<satellite:argument name="id" value="<%=sFolderId%>" />
						<satellite:argument name="cs_environment" value="portal" />
						<satellite:argument name="cs_formmode" value="DM" />
						<satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/ContentDetailsFront"/>
					</satellite:link>
					<% String showPopup = "csPopup('" + ics.GetVar("inspectURL") + "', 'ShowContent')"; %>
					<xlat:lookup key="dvin/Common/InspectThisItem" varname="_XLAT_"/>
					<xlat:lookup key="dvin/Common/InspectThisItem" varname="mouseover" escape="true"/>
					<td class="<%=sStyle%>" style="padding:3px" align="right"><a href="javascript:void(0);" class="<%=sStyle%>" onclick="<portlet:namespace/>_<%=showPopup%>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" src='<%=sImageBaseURL + "/graphics/common/icon/iconInspectContent.gif"%>' name="<%=sFolderId%>" border="0" alt='<%=ics.GetVar("_XLAT_")%>' title='<%=ics.GetVar("_XLAT_")%>' /></a></td>
					<%
				}
				else //This user cannot inspect this folder, show nothing
				{
					%><td class="<%=sStyle%>">&nbsp;</td><%
				}
				%>
			</tr>
			<%

			//Display all the folders on this page
			HierarchyNode[] folders = view.getFolders();
			if (folders != null ) for (int i = 0; i < folders.length; i++) {
				HierarchyNode folder = folders[i];
				Map params = folder.getParameters();
				sStyle = ( sStyle == PortletStyles.PORTLET_SECTION_BODY ) ? PortletStyles.PORTLET_SECTION_ALTERNATE : PortletStyles.PORTLET_SECTION_BODY;
				%>
				<satellite:link assembler="query" outstring="itemURL" portleturltype="render">
					<%
					Map dm = (Map) params.get(DocumentManagement.FORMMODE_DM);
					for (Iterator it = dm.entrySet().iterator(); it.hasNext();) {
						Map.Entry entry = (Map.Entry) it.next();
						%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
					}
					%>
				</satellite:link>
				<tr>
					<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
				</tr>
				<tr>
					<td class="<%=sStyle%>" style="padding:3px" nowrap>
						<img src='<%=sImageBaseURL + "/graphics/common/controlpanel/spacer.gif"%>' width="20" height="1" alt="" border="0">
						<img src='<%=sImageBaseURL + "/graphics/common/icon/folder_closed.gif"%>' border="0">
						<a href='<%=ics.GetVar( "itemURL" )%>' class="<%=sStyle%>"><%=folder.getName()%></a>
					</td>
					<%
					Map inspect = (Map)params.get("inspect");
					if (inspect != null) {
						%>
						<satellite:link assembler="query" outstring="inspectURL" container="servlet">
							<%
							for (Iterator it = inspect.entrySet().iterator(); it.hasNext();) {
								Map.Entry entry = (Map.Entry) it.next();
								%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
							}
							%>
							<satellite:argument name="cs_environment" value="portal" />
							<satellite:argument name="cs_formmode" value="DM" />
							<satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/ContentDetailsFront"/>
						</satellite:link>
						<% String showPopup = "csPopup('" + ics.GetVar("inspectURL") + "', 'ShowContent')"; %>
						<xlat:lookup key="dvin/Common/InspectThisItem" varname="_XLAT_"/>
						<xlat:lookup key="dvin/Common/InspectThisItem" varname="mouseover" escape="true"/>
						<td class="<%=sStyle%>" style="padding:3px" align="right">
							<a href="javascript:void(0);" class="<%=sStyle%>"
								onclick="<portlet:namespace/>_<%=showPopup%>"
								onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;'
								onmouseout="window.status='';return true"
								><img height="14" width="14" hspace="2"
									src="<%=sImageBaseURL%>/graphics/common/icon/iconInspectContent.gif"
									name='<%=inspect.get("id")%>' border="0" alt='<%=ics.GetVar("_XLAT_")%>' title='<%=ics.GetVar("_XLAT_")%>' 
								/></a>
						</td>
						<%
					}
					else //This user cannot inspect this folder, show nothing
					{
						%><td class="<%=sStyle%>">&nbsp;</td><%
					}
				%>
				</tr>
				<%
			}


			//add csblobid to session for security check
			String sCSBlobId    = session.getId();
			ics.SetSSVar( "csblobid", sCSBlobId );
			%>
			<!-- Load the supported mime types by CS these are loaded once to avoid the database hit for each document-->
			<ics:selectto table="MimeType" what="mimetype,extension" listname="mType" />
			
			<%
			//Display all the documents on this page
			HierarchyNode[] documents = view.getDocuments();
			if (documents != null ) for (int i = 0; i < documents.length; i++) {
				HierarchyNode document = documents[i];
				Map param = document.getParameters();
				boolean mimeTypesupported=false;
				String mimeType="";
				String name=document.getName();
				String filename="";
				String dmblobid="";
				Map dmparam = (Map) param.get(DocumentManagement.FORMMODE_DM);
				if (dmparam != null)  //Link the name of the asset to the blob
				{
					for (Iterator it = dmparam.entrySet().iterator(); it.hasNext();) {
									Map.Entry entry = (Map.Entry) it.next();
									String keyName=(String)entry.getKey();
									if (keyName.equals("blobwhere"))
									{
										dmblobid=(String)entry.getValue();
									}
					}
				}
				ics.SetVar("errno","0");
             	ics.SetVar("id",dmblobid);
    			StringBuffer errstr = new StringBuffer();
    			IList blobsFile = ics.SelectTo("MungoBlobs",// tablename
    			"filevalue", // what
    			"id", // where
    			"id", // orderby
    			1, // limit
    			null, // ics list name
    			true, // cache?
    			errstr); // error StringBuffer
    			if ("0".equals(ics.GetVar("errno")) && blobsFile!=null && blobsFile.hasData())
    			{
    			filename = blobsFile.getValue("filevalue");
    			}
				String fileExtension="";
				if (filename.indexOf(".")>=0)
				fileExtension=filename.substring(filename.indexOf(".")+1);
				sStyle = ( sStyle == PortletStyles.PORTLET_SECTION_BODY ) ? PortletStyles.PORTLET_SECTION_ALTERNATE : PortletStyles.PORTLET_SECTION_BODY;
				%>

				<ics:listloop listname="mType">
          		<ics:listget listname="mType"           fieldname="extension" output="ext"/>
				<ics:listget listname="mType"           fieldname="mimetype" output="mName"/>
					<%
					if (fileExtension.equals(ics.GetVar("ext")))
				    {
					mimeTypesupported=true;
					mimeType=ics.GetVar("mName");
					} 
					%>
				</ics:listloop>
				<tr>
					<td colspan="2" background="<%=sImageBaseURL %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
				</tr>
				<tr>
					<td class="<%=sStyle%>" style="padding:3px" nowrap>
						<img src='<%=sImageBaseURL + "/graphics/common/controlpanel/spacer.gif"%>' width="20" height="1" alt="" border="0"/>
						<img src='<%=sImageBaseURL + "/OMTree/TreeImages/default.png"%>' border="0"/>
						<%
						Map dm = (Map) param.get(DocumentManagement.FORMMODE_DM);
						if (dm != null)  //Link the name of the asset to the blob
						{

							//Get the blob link params from the result
														%>
							<satellite:blob assembler="query" outstring="bloburl" container="<%=Satellite.CONTAINER_SERVLET%>" csblobid='<%=sCSBlobId%>'>
								<%
								for (Iterator it = dm.entrySet().iterator(); it.hasNext();) {
									Map.Entry entry = (Map.Entry) it.next();
									String keyName=(String)entry.getKey();
									if ((mimeTypesupported) && (keyName.equals("blobheader")))
															{
								%><satellite:parameter name="<%=(String)entry.getKey()%>" value="<%=mimeType%>" /><%
															}
															else {
									%><satellite:parameter name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>" /><%			
										}}

							       if (mimeTypesupported)
							          {	
						           String CD="attachment; filename="+filename;
									%>
									<satellite:parameter name="blobheadername1" value="Content-Disposition" />
									<satellite:parameter name="blobheadervalue1" value="<%=CD%>" />
									<satellite:parameter name="blobheadername2" value="MDT-Type" />
									<satellite:parameter name="blobheadervalue2" value="abinary; charset=UTF-8" />
								
									<%
							          }
								%>
							</satellite:blob>
							<% String showPopup = "csPopup('" + ics.GetVar("bloburl") + "', 'ShowBlob')"; %>
							<xlat:lookup key="dvin/Common/viewthisitem" varname="mouseover" escape="true"/>
							<a href="javascript:void(0);"
								onclick="<portlet:namespace/>_<%=showPopup%>"
								onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;'
								class="<%=sStyle%>"
								><%=document.getName()%></a>
							<%
						}
						else  //Just show the name of the asset
						{
							%><%=document.getName()%><%
						}
						%>
					</td>
					<%
					Map inspect = (Map) param.get(DocumentManagement.FUNC_INSPECT);
					if (inspect != null) //This user can inspect this document, show the inspect icon
					{
						%>
						<satellite:link assembler="query" outstring="inspectURL" container="servlet">
							<%
							for (Iterator it = inspect.entrySet().iterator(); it.hasNext();) {
								Map.Entry entry = (Map.Entry) it.next();
								%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
							}
							%>
							<satellite:argument name="cs_environment" value="portal" />
							<satellite:argument name="cs_formmode" value="DM" />
							<satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/ContentDetailsFront"/>
						</satellite:link>
						<% String showPopup = "csPopup('" + ics.GetVar("inspectURL") + "', 'ShowContent')"; %>
						<xlat:lookup key="dvin/Common/InspectThisItem" varname="_XLAT_"/>
						<xlat:lookup key="dvin/Common/InspectThisItem" varname="mouseover" escape="true"/>
						<td class="<%=sStyle%>" style="padding:3px" align="right">
							<a href="javascript:void(0);" class="<%=sStyle%>"
								onclick="<portlet:namespace/>_<%=showPopup%>"
								onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;'
								onmouseout="window.status='';return true"
								><img height="14" width="14" hspace="2"
									src="<%=sImageBaseURL%>/graphics/common/icon/iconInspectContent.gif"
									name='<%=inspect.get("id")%>' border="0" alt='<%=ics.GetVar("_XLAT_")%>' title='<%=ics.GetVar("_XLAT_")%>'
							/></a>
						</td>
						<%
					}
					else //This user cannot inspect this folder, show nothing
					{
						%><td class="<%=sStyle%>">&nbsp;</td><%
					}
					%>
				</tr>
				<%
			}
			%>
			</table>
		</td>
		<td valign="top" width="1" background="<%=sImageBaseURL %>/graphics/common/screen/blackdot.gif"><img width="1" height="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
	</tr>
	<tr>
		<td colspan="3" valign="top" height="1" background="<%=sImageBaseURL %>/graphics/common/screen/blackdot.gif"><img width="1" height="1" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
	</tr>
	<tr>
		<td></td>
		<td background="<%=sImageBaseURL %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%=sImageBaseURL %>/graphics/common/screen/dotclear.gif"/></td>
		<td></td>
	</tr>
	</table>
	<%
	//Show 'New' start menu links for folders and documents
	IList   listDocMenus    = DocumentManagement.getNewDocStartMenus(ics, sDocType, sPubId);
		//(IList)request.getAttribute( DocumentManagement.PARAM_DOC_MENUS );
	IList   listFolderMenus = DocumentManagement.getNewFolderStartMenus(ics, sFolderId, sFolderType, sPubId);
		//(IList)request.getAttribute( DocumentManagement.PARAM_FOLDER_MENUS );

	if (listFolderMenus != null) for( int i = 0; i < listFolderMenus.numRows(); i++ ) {
		listFolderMenus.moveTo( i + 1 );
		String  sAssetType      = listFolderMenus.getValue( "assettype" );
		String  sStartId        = listFolderMenus.getValue( "id" );
		String  sName           = listFolderMenus.getValue( "name" );

		%>
		<satellite:link assembler="query" outstring="createURL" container="servlet">
			<satellite:argument name="AssetType" value="<%=sAssetType %>" />
			<satellite:argument name="StartItem" value="<%=sStartId%>" />
			<satellite:argument name="cs_environment" value="portal" />
			<satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/NewContentFront"/>
			<satellite:argument name="cs_formmode" value="DM" />
			<satellite:argument name="Arg:Group_Folder" value="<%=sFolderId%>"/>   <!-- Sets the current folder as the parent -->
		</satellite:link>
		<% String onClick = "csPopup('" + ics.GetVar("createURL") + "', 'NewContent')"; %>
		<nobr class="portlet-font"><a href="javascript:void(0);" onclick="<portlet:namespace/>_<%=onClick%>" class="portlet-font"><img src='<%=sImageBaseURL + "/graphics/common/icon/new-folder-icon.gif"%>' alt="<%=sName%>" border="0"> <%=sName%></a></nobr><br />
		<%
	}

	if (listDocMenus != null) for( int i = 0; i < listDocMenus.numRows(); i++ ) {
		listDocMenus.moveTo( i + 1 );
		String  sAssetType      = listDocMenus.getValue( "assettype" );
		String  sStartId        = listDocMenus.getValue( "id" );
		String  sName           = listDocMenus.getValue( "name" );

		%>
		<satellite:link assembler="query" outstring="createURL" container="servlet">
			<satellite:argument name="AssetType" value="<%=sAssetType %>" />
			<satellite:argument name="StartItem" value="<%=sStartId%>" />
			<satellite:argument name="cs_environment" value="portal" />
			<satellite:argument name="cs_formmode" value="DM" />
			<satellite:argument name="pagename" value="OpenMarket/Xcelerate/Actions/NewContentFront"/>
			<satellite:argument name="Arg:Group_Folder" value="<%=sFolderId%>"/>    <!-- Sets the current folder as the parent -->
		</satellite:link>
		<% String onClick = "csPopup('" + ics.GetVar("createURL") + "', 'NewContent')"; %>
		<nobr class="portlet-font"><a href="javascript:void(0);" onclick="<portlet:namespace/>_<%=onClick%>" class="portlet-font"><img src='<%=sImageBaseURL + "/graphics/common/icon/new-document-icon.gif"%>' alt="<%=sName%>" border="0"> <%=sName%></a></nobr><br />
		<%
	}
%></cs:ftcs>