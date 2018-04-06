<%@ page import="COM.FutureTense.Interfaces.IList,
                 COM.FutureTense.Interfaces.ICS,
                 COM.FutureTense.Util.ftMessage,
                 com.fatwire.flame.portlets.DocumentManagement,
                 com.fatwire.flame.dm.*,
                 com.openmarket.xcelerate.asset.AssetType,
                 com.openmarket.xcelerate.site.Publication,
                 org.apache.commons.logging.LogFactory,
                 java.util.*"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="publication" uri="futuretense_cs/publication.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Flame/DocumentManagement/SelectFolderPopup
//
// INPUT
//
// OUTPUT
//%>
<%!
	private static final String PAGE_NAME = "OpenMarket/Flame/DocumentManagement/SelectFolderPopup";
	public static class BreadCrumbWithLink extends BreadCrumb {
		private final Syntax syntax;
		public BreadCrumbWithLink(Syntax syntax, String sFolderId) {
			super(syntax.getFolderType(), sFolderId);
			this.syntax = syntax;
		}

		protected Map getDocTypeParam(ICS ics) {
			return syntax.getParameters();
		}

		protected Map getFolderParam(ICS ics, String sFolderId) {
			Map param = syntax.getParameters();
			param.put(DocumentManagement.PARAM_FOLDERID, sFolderId);
			return param;
		}

		public List getNodes(ICS ics, int levels) {
			List nodes = super.getNodes(ics, levels);

			String docType = syntax.getDocType();
			if (docType != null) {
				String sDocTypeDesc = AssetType.Load(ics, docType).Get("description");
				Map param = syntax.getParameters();
				param.put(DocumentManagement.PARAM_DOC_TYPE, docType);
				nodes.add(new ImmutableNode(sDocTypeDesc, param));
			}

			return nodes;
		}
	}

	public static class Syntax {
		private final String sDocType;
		private final String sFolderType;
		private final String sFolderId;
		private final String sThisPage;
		private final String sTemplate;
		private final String sToDelete;
		private final String sValidDef;
		private final HashMap param;

		public Syntax(String sDocType, String sFolderType, String sFolderId, String sThisPage, String sTemplate, String sToDelete, String sValidDef) {
			this.sDocType = sDocType;
			this.sFolderType = sFolderType;
			this.sFolderId = sFolderId;
			this.sThisPage = sThisPage;
			this.sTemplate = sTemplate;
			this.sToDelete = sToDelete;
			this.sValidDef = sValidDef;

			param = new HashMap();
			param.put(DocumentManagement.PARAM_RENDERPAGENAME,		PAGE_NAME);
			param.put(DocumentManagement.PARAM_DOC_TYPE,	sDocType);
			param.put(DocumentManagement.PARAM_FOLDER_TYPE,	sFolderType);
			param.put("ThisPage", sThisPage);
			param.put("Template", sTemplate);
			param.put("ToDelete", sToDelete);
			param.put("ValidDef", sValidDef);
		}

		public String getDocType() {
			return sDocType;
		}

		public String getFolderType() {
			return sFolderType;
		}

		public String getFolderId() {
			return sFolderId;
		}

		public String getThisPage() {
			return sThisPage;
		}

		public String getTemplate() {
			return sTemplate;
		}

		public String getToDelete() {
			return sToDelete;
		}

		public String getValidDef() {
			return sValidDef;
		}

		public Map getParameters() {
			return (Map) param.clone();
		}
	}
%>
<cs:ftcs>
<%
//Call the element to write out the popup Javascript
ics.CallElement( "OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null );

String  sImageBaseURL   = ics.GetVar( "cs_imagedir" );

//Get the site id from the session
String  sPubId          = ics.GetSSVar( "pubid" );
String  sDocType        = ics.GetVar( DocumentManagement.PARAM_DOC_TYPE );
String  sFolderType		= ics.GetVar( DocumentManagement.PARAM_FOLDER_TYPE );

if (sDocType == null || sFolderType == null) {
	//todo: error message
}

//Get the current folder id from the request - null means root
String  sFolderId  		= ics.GetVar( DocumentManagement.PARAM_FOLDERID );

if( sDocType == null )  //There's no AssetType for Documents selected for the portlet
{
	//Get a list of asset types configured for DocLink
	IList   listDocLink = DocumentManagement.getDocLinkTypes( ics, sPubId );
	int     iNumDLTypes = listDocLink.numRows();

	if( iNumDLTypes == 0 ) //no asset types configured for DocLink, show a message
	{
		throw new UnsupportedOperationException( "No asset types are configured for DocLink.  This is not implemented for Spark." );
		//todo: implement message page so it can be returned here
	}
	else if( iNumDLTypes == 1 ) //only one asset type configured for DocLink, automatically pick it
	{
		try
		{
			sDocType    = listDocLink.getValue( "assettype" );
		}
		catch( NoSuchFieldException e )
		{
			LogFactory.getLog(ftMessage.GENERIC_DEBUG).error("Exception getting asset type name for single DocLink asset type:", e);
		}
	}
	else    //show a list of types
	{
		throw new UnsupportedOperationException( "More than one asset type is configured for DocLink.  This is not implemented for Spark." );
		//todo: implement page to list doc link asset types so it can be returned here
	}
}

String ThisPage = ics.GetVar("ThisPage");
String Template = ics.GetVar("Template");
String ToDelete = ics.GetVar("ToDelete");
String ValidDef = ics.GetVar("ValidDef");
if(ToDelete == null)
ToDelete = "";
//Syntax syntax = new Syntax(sDocType, sFolderType, sFolderId, ThisPage, Template, ToDelete, ValidDef);
%>
<html>
<head>
	<!-- Get the description of the current site -->
	<publication:load name="thePub" objectid="<%=sPubId%>"/>
	<publication:get name="thePub" field="description" output="pubDescription" />
	<title><%=ics.GetVar("pubDescription")%></title>
	<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet'/>

	<script>
		function UpdateSelection() {
			opener.UpdateSelection('<%=ThisPage%>', <%=Template%>, '<%=ToDelete%>', '<%=( sFolderId == null ) ? "" : "id="+sFolderId+",assettype="+sFolderType%>');
			window.close();
			return false;
		}
	</script>
<head>
<body>
	<%=ics.GetVar( "pubDescription" ) %>
    <hr color="black" noshade/>
	<!-- display the breadcrumb trail -->
	<%
	//List    listCrumbs  = result.getBreadCrumb();
	HashMap param = new HashMap();
	param.put(DocumentManagement.PARAM_RENDERPAGENAME,		PAGE_NAME);
	param.put(DocumentManagement.PARAM_DOC_TYPE,	sDocType);
	param.put(DocumentManagement.PARAM_FOLDER_TYPE,	sFolderType);
	param.put("ThisPage", ThisPage);
	param.put("Template", Template);
	param.put("ToDelete", ToDelete);
	param.put("ValidDef", ValidDef);
	BreadCrumb breadcrumb = new DocumentManagement.BreadCrumb(null, sDocType, sFolderType, sFolderId, param);
	List listCrumbs = breadcrumb.getNodes(ics, 3);
	if( listCrumbs.isEmpty() )
	{
		//todo: log error
	}
	//todo: error handling
	for (int i = listCrumbs.size() - 1; i > 0; i--)
	{
		HierarchyNode node = (HierarchyNode)listCrumbs.get(i);

		Map params = node.getParameters();
		if (params != null) {
			%>
			<satellite:link assembler="query" outstring="crumbURL">
			<%
			for (Iterator it = params.entrySet().iterator(); it.hasNext();) {
				Map.Entry entry = (Map.Entry) it.next();
				%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
			}
			%>
			</satellite:link>
			<%
		}
		%><nobr><%
		if (params != null) {
			%><a href='<%=ics.GetVar( "crumbURL" )%>'><%
		}
		%><%=node.getName()%><%
		if (params != null) {
			%></a><%
		}
		%></nobr> &gt; <%
	}

	if (listCrumbs.size() > 0) {
		%><nobr><%=((HierarchyNode)listCrumbs.get(0)).getName()%></nobr><%
	}

	//Only allow the select the folders with valid defintion.
	boolean valid = true;
	if (sFolderId != null && ValidDef != null) {
		%><asset:list list="folder" type="<%=sFolderType%>" field1="id" value1="<%=sFolderId%>"/><%
		String sFolderDefId = ics.GetList("folder").getValue("flexgrouptemplateid");
		StringTokenizer st = new StringTokenizer(ValidDef, ",");
		valid = false;
        while(st.hasMoreTokens()) {
			if (sFolderDefId.equals(st.nextToken())) {
				valid = true;
				break;
			}
		}
	}
	if (valid) {
	%>
		<A HREF="javascript:void(0);" onclick="return UpdateSelection()"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Select"/></ics:callelement></A>
	<%
	}
	%>

    <hr size="1" noshade/>
	<!-- Folder List -->
	<%
	Pagination pagination = new Pagination(DocumentManagement.PAGE_SIZE,
		sFolderId == null ?
			FolderHierarchy.countRootFolders(ics, sPubId, sFolderType) :
			FolderHierarchy.countSubFolders(ics, sPubId, sFolderType, sFolderId)
	);
	//Get the current page number (assume we'll never get a page number out of range)
	String sPage = ics.GetVar(DocumentManagement.PARAM_PAGE_NUMBER);
	Pagination.Page activePage = pagination.getPage(sPage == null ? 0 : Integer.parseInt(sPage));
	//Calculate the starting index from the (zero-based) page number and the page size

	List listFolders = sFolderId == null ?
		FolderHierarchy.getRootFolders(ics, sPubId, sFolderType, activePage.getItemIndex(), DocumentManagement.PAGE_SIZE) :
		FolderHierarchy.getSubFolders(ics, sPubId, sFolderType, sFolderId, activePage.getItemIndex(), DocumentManagement.PAGE_SIZE);

	//Display all the folders on this page
	Map subfolder = (Map) param.clone();//syntax.getParameters();
	Iterator itFolders = listFolders.iterator();
	while (itFolders.hasNext()) {
		String sItemId = (String)itFolders.next();
		%>
		<!-- Create link to navigate to this folder using its name -->
		<asset:list type="<%=sFolderType%>" list="itemNameList">
			<asset:argument name="id" value='<%=sItemId%>'/>
		</asset:list>
		<satellite:link assembler="query" outstring="itemURL" portleturltype="render">
		<%
		subfolder.put(DocumentManagement.PARAM_FOLDERID, sItemId);
		for (Iterator it = subfolder.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
		}
		%>
		</satellite:link>
		<nobr>
		<img src='<%=sImageBaseURL + "/OMTree/TreeImages/folder.png"%>' border="0">
		<a href='<%=ics.GetVar( "itemURL" )%>'><ics:listget listname="itemNameList" fieldname="name"/></a></nobr>
		<br/>
		<%
	}
	%>

	<!-- Pagination controls -->
    <hr size="1" noshade/>
	<div align="right">
	<nobr>
	<%
	Map pagelink = (Map) param.clone();//syntax.getParameters();
	pagelink.put(DocumentManagement.PARAM_FOLDERID, sFolderId);
	//Show links to previous and first page if we're not at the first page
	if (activePage.hasPrevious()) {
		%>
		<satellite:link assembler="query" outstring="firstPageURL" portleturltype="render">
		<%
		pagelink.put(DocumentManagement.PARAM_PAGE_NUMBER, "0");
		for (Iterator it = pagelink.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
		}
		%>
		</satellite:link>
		<xlat:lookup key="dvin/Common/First" varname="_XLAT_" />
		<a href='<%=ics.GetVar( "firstPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/doubleArrowLeft.gif"%>' width="15" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
		<satellite:link assembler="query" outstring="backPageURL" portleturltype="render">
		<%
		pagelink.put(DocumentManagement.PARAM_PAGE_NUMBER, String.valueOf(activePage.getIndex() - 1));
		for (Iterator it = pagelink.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
		}
		%>
		</satellite:link>
		<xlat:lookup key="dvin/Common/Previous" varname="_XLAT_" />
		<a href='<%=ics.GetVar( "backPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/leftArrow.gif"%>' width="11" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
		<%
	}

	//Set vars for localization
	//  Variables.startIndex - Variables.endIndex of Variables.totalItems
	//  e.g. 1 - 10 of 50
	ics.SetVar("startIndex",pagination.getNumberOfItems() == 0 ? 0 : activePage.getItemIndex() + 1);
	ics.SetVar("endIndex",	pagination.getNumberOfItems() == 0 ? 0 : activePage.getItemIndex() + listFolders.size());
	ics.SetVar("totalItems",pagination.getNumberOfItems() );
	%>
	<xlat:stream key="fatwire/Flame/Common/PaginationDisplay" />

	<%
	//Show links to next and last page if we're not at the last page
	if (activePage.hasNext()) {
		%>
		<satellite:link assembler="query" outstring="nextPageURL" portleturltype="render">
		<%
		pagelink.put(DocumentManagement.PARAM_PAGE_NUMBER, String.valueOf(activePage.getIndex() + 1));
		for (Iterator it = pagelink.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
		}
		%>
		</satellite:link>
		<xlat:lookup key="dvin/Common/Next" varname="_XLAT_" />
		<a href='<%=ics.GetVar( "nextPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/rightArrow.gif"%>' width="11" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
		<satellite:link assembler="query" outstring="lastPageURL" portleturltype="render">
		<%
		pagelink.put(DocumentManagement.PARAM_PAGE_NUMBER, String.valueOf(pagination.getNumberOfPages()));
		for (Iterator it = pagelink.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
		}
		%>
		</satellite:link>
		<xlat:lookup key="dvin/Common/Last" varname="_XLAT_" />
		<a href='<%=ics.GetVar( "lastPageURL" )%>'><img src='<%=sImageBaseURL + "/graphics/common/icon/doubleArrow.gif"%>' width="15" height="12" alt='<%=ics.GetVar( "_XLAT_" )%>' border="0"></a>
		<%
	}
	%>
	</nobr>
	</div>
</body>
</html>
</cs:ftcs>