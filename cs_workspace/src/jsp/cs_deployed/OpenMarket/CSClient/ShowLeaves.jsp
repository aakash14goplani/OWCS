<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<%//
// OpenMarket/CSClient/ShowLeaves
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.mda.*,com.openmarket.xcelerate.common.*,com.openmarket.xcelerate.asset.AssetIdImpl,com.fatwire.mda.DimensionableAssetInstance.DimensionParentRelationship,java.util.*,com.fatwire.assetapi.data.AssetId"%>
<cs:ftcs>
<%! 
private Map<String,String> getRelatives(String assetType,String assetId,ICS ics)
{
	Map<String,String> rt=new HashMap<String,String>();
	// get the dimension support factory
	DimensionSupportManagerFactory dsmf = DimensionSupportManagerFactory.getInstance(ics);
			
	// get the asset dimensionable manager 
	DimensionableAssetManager dam = dsmf.getDimensionableAssetManager();
			
	// create an the 
	AssetId aid = new AssetIdImpl(assetType, new Long(assetId));
			
	Collection<AssetId> relatives = dam.getRelatives(aid, null);

	// build up the result list
	for (AssetId relative : relatives)
	{
		Collection<Dimension> dims = dam.getDimensionsForAsset(relative);
		long dimid=0;
		for (Dimension dim : dims)
		{
			if (dim.getGroup()!=null && "Locale".equalsIgnoreCase(dim.getGroup()))
			{
				dimid=dim.getId().getId();
				rt.put(Long.toString(dimid),Long.toString(relative.getId()));
				break;
			}
		}
	}

	return rt;
}

private Map<String,String> getParents(String assetType,String assetId,ICS ics)
{
	Map<String,String> rt=new HashMap<String,String>();
	// get the dimension support factory
	DimensionSupportManagerFactory dsmf = DimensionSupportManagerFactory.getInstance(ics);
			
	// get the asset dimensionable manager 
	DimensionableAssetManager dam = dsmf.getDimensionableAssetManager();
			
	// create an the 
	AssetId aid = new AssetIdImpl(assetType, new Long(assetId));

	Collection<DimensionParentRelationship> dims1 = dam.getParents(aid);
	for (DimensionParentRelationship dimP : dims1)
	{
		long dimid=0;
		if (dimP.getGroup()!=null && "Locale".equalsIgnoreCase(dimP.getGroup()))
		{
			Collection<Dimension> dims = dam.getDimensionsForAsset(dimP.getParent());
			for (Dimension dim : dims)
			{
				if (dim.getGroup()!=null && "Locale".equalsIgnoreCase(dim.getGroup()))
				{
					dimid=dim.getId().getId();
					rt.put(Long.toString(dimid),Long.toString(dimP.getParent().getId()));
					break;
				}
			}
		}
	}
	return rt;
}

// Load the available dimension of subtype Locale
%>
<asset:list type="Dimension" list="listLocales" order="description" pubid='<%=ics.GetSSVar("pubid")%>' excludevoided="true">
	<asset:argument name="subtype" value="Locale"/>
</asset:list>
<xlat:lookup key='dvin/CSDocLink/View' varname='view_key'/>
<xlat:lookup key='fatwire/Alloy/UI/masterAsset' varname='masterasset'/>
<xlat:lookup key='fatwire/Alloy/UI/MakeMaster' varname='makemaster'/>
<%
// Load all the assets and create the xml for doclink
int numAssets = Integer.parseInt(ics.GetVar("assets:Total"));
FTValList vN = new FTValList();
String assetPrefix = null;
String currentDef = null;
String clientInfoListName = null;
String dropFieldListName = null;
for (int assetIndex = 0; assetIndex < numAssets; assetIndex++)
{ 
	assetPrefix = "asset"+String.valueOf(assetIndex)+":";
	ics.SetCounter("currentInst",assetIndex);
	// KDW: The equivalent of the following line was lost sometime between 5.5 and 6.3, not sure when, but it really has to be there for existing values to be properly detected.
%>
	<asset:scatter name='<%="assets:"+ics.GetCounter("currentInst")%>' prefix='<%="asset"+ics.GetCounter("currentInst")%>' exclude="true"/>
<%
	currentDef = ics.GetVar(assetPrefix+"flextemplateid");
	if (ics.GetList(currentDef) == null)
	{ 
		// This loads the definition's primary asset row into a list called "asset<n>:flextemplateid"
%>
		<asset:list list='<%=currentDef%>' type='<%=ics.GetVar("defType")%>' field1='id' value1='<%=currentDef%>'/>
<%
	}
  
	clientInfoListName = ics.GetVar("AssetType") + ics.GetList(currentDef).getValue("name") + "Config";
	if (ics.GetList(clientInfoListName) == null)
	{
		vN.setValString("CLIENTID", ics.GetVar("clientid"));
		vN.setValString("LISTVARNAME", clientInfoListName);
		vN.setValString("SUBTYPE", ics.GetList(currentDef).getValue("name"));
		vN.setValString("ACTION", "enable");
		vN.setValString("VALUE", "true");
		ics.runTag("externalclientsconfigmanager.getitemlist", vN);
	}
  
	dropFieldListName = ics.GetVar("AssetType") + ics.GetList(currentDef).getValue("name") + "Drop";
	if (ics.GetList(dropFieldListName) == null)
	{
		vN.removeAll();
		vN.setValString("CLIENTID", ics.GetVar("clientid"));
		vN.setValString("LISTVARNAME", dropFieldListName);
		vN.setValString("SUBTYPE", ics.GetList(currentDef).getValue("name"));
		vN.setValString("ACTION", "acceptdocs");
		vN.setValString("NOTVALUE", "No");
		ics.runTag("externalclientsconfigmanager.getitemlist", vN);                                                                                                                                               
	}
  
	ics.SetVar("asset:id",ics.GetVar(assetPrefix+"id"));
	ics.SetVar("asset:name",ics.GetVar(assetPrefix+"name"));
	ics.SetVar("asset:description",ics.GetVar(assetPrefix+"description"));
  
	vN.removeAll();
	vN.setValString("MUSTBEASSIGNED", "false");
	vN.setValString("OBJECT", "workflowasset:"+String.valueOf(assetIndex));
	vN.setValString("FUNCTIONNAME", "preview");
	vN.setValString("SITE", ics.GetSSVar("pubid"));
	vN.setValString("VARNAME", "previewLegal");
	ics.runTag("workflowengine.isfunctionlegal", vN);
	
	vN.removeAll();
	vN.setValString("MUSTBEASSIGNED", "false");
	vN.setValString("OBJECT", "workflowasset:"+String.valueOf(assetIndex));
	vN.setValString("FUNCTIONNAME", "inspect");
	vN.setValString("SITE", ics.GetSSVar("pubid"));
	vN.setValString("VARNAME", "inspectLegal");
	ics.runTag("workflowengine.isfunctionlegal", vN);

	vN.removeAll();
	vN.setValString("OBJECT", "workflowasset:"+String.valueOf(assetIndex));
	vN.setValString("FUNCTIONNAME", "edit");
	vN.setValString("SITE", ics.GetSSVar("pubid"));
	vN.setValString("VARNAME", "editLegal");
	ics.runTag("workflowengine.isfunctionlegal", vN);                                                                                                                                               

	vN.removeAll();
	vN.setValString("OBJECT", "workflowasset:"+String.valueOf(assetIndex));
	vN.setValString("FUNCTIONNAME", "delete");
	vN.setValString("SITE", ics.GetSSVar("pubid"));
	vN.setValString("VARNAME", "deleteLegal");
	ics.runTag("workflowengine.isfunctionlegal", vN);                                                                                                                                               
  
	IList dropfield = ics.GetList(dropFieldListName);
	boolean hasFile = false;
	if (dropfield != null && dropfield.hasData())
	{
		if (ics.GetVar(assetPrefix+dropfield.getValue("property")+"_file") != null ||
			ics.GetVar(assetPrefix+dropfield.getValue("property")+":0_file") != null)
		{
			hasFile = true;
		}
	}

	ics.SetVar("nameVal", ics.GetVar("asset:name")); 
%>
  
<string:encode variable='asset:name' varname='encoded'/>
<CHILD Folder="false" ID="<%=ics.GetVar("asset:id")%>" NAME="<%=ics.GetVar("encoded")%>">
<ATTRIBUTES> 

<%
	// define a variables which talks about the Dimensions
	boolean isDimensionEnabled=true;
	String dimid=null;

	IList clientFields = ics.GetList(clientInfoListName);
	if (clientFields != null && clientFields.hasData())
	{
		do
		{
			ics.RemoveVar("typeString");
			vN.removeAll();
			vN.setValString("SITE", ics.GetSSVar("pubid"));
			vN.setValString("ASSETTYPE", ics.GetVar("AssetType"));
			vN.setValString("SUBTYPE", ics.GetList(currentDef).getValue("name"));
			vN.setValString("ATTRIBUTE", clientFields.getValue("property"));
			vN.setValString("VARNAME", "typeString");
			ics.runTag("inspectdata.gettypestring", vN);                                                                                                                                               
			if (ics.GetVar("typeString")!=null)
			{
				vN.removeAll();
				vN.setValString("VALUE", ics.GetVar("typeString"));
				vN.setValString("ATTRIBUTE", clientFields.getValue("property"));
				vN.setValString("LISTVARNAME", "lTypeInfo");
				ics.runTag("inspector.parsetypestring", vN);
%>
				<ics:callelement element='OpenMarket/CSClient/ShowAttributes' >
					<ics:argument name='clientInfoListName' value='<%=clientInfoListName%>'/>
					<ics:argument name='cs_dropField' value='<%=hasFile?dropfield.getValue("property"):"false"%>'/>
				</ics:callelement> 
<%
			}
			if ("Dimension".equals(clientFields.getValue("property")))
				isDimensionEnabled=true;
		} while (clientFields.moveToRow(IList.next,0));
	}
%>
	<string:encode variable='AssetType' varname='packedAT'/>
	<ATTRIBUTE NAME="<%=ics.GetVar("_XLAT_AT")%>" VALUE="<%=ics.GetVar("packedAT")%>" DESCRIPTION="<%=ics.GetVar("_XLAT_AT")%>" DataType="String" READONLY="true"/>
<%
	IList history = null;
	if ("true".equals(ics.GetVar("inspectLegal")))
	{
		if ("true".equals(ics.GetVar("trackingenabled")))
		{
			// <!-- find out if checked out by anyone -->
			history = ics.RTHistory(ics.GetVar("AssetType"),ics.GetVar("asset:id"),null,null,null,null,"ItsHistory");
			if (!(history == null || !history.hasData() || history.getValue("lockedby").length()==0))
			{
				// Display RT lock status as a read-only attribute
%>
	<xlat:lookup key='dvin/CSDocLink/Lockedbywho' varname='_XLAT_'/>
	<ATTRIBUTE NAME="<%=ics.GetVar("_XLAT_COStatus")%>" VALUE="<%=ics.GetVar("_XLAT_")%>" DataType="String" DESCRIPTION="<%=ics.GetVar("_XLAT_COStatus")%>" READONLY="true"/>
<%
			}
		}
		java.util.Hashtable assigned = (java.util.Hashtable) ics.GetObj("hAssignedAssets");
		if (assigned.containsKey(ics.GetVar("asset:id")))
		{
			// Display asset assignment as a read-only attribute.
%>
	<xlat:lookup key='dvin/UI/Assignments' varname='_XLAT_'/>
	<ATTRIBUTE NAME="<%=ics.GetVar("_XLAT_")%>" VALUE="<%=ics.GetSSVar("username")%>" DataType="String" DESCRIPTION="<%=ics.GetVar("_XLAT_")%>" READONLY="true"/>
<%
		}
	}
	
	// Now, deal with dimension attributes.  I'm really not sure this code should be here; it may properly belong in ShowAttributes.
	if (isDimensionEnabled)
	{
%>
		<xlat:lookup key='dvin/AT/Dimension/Locale' varname='_XLAT_Dimension'/>
		<asset:load name='assetInstance' type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("asset:id")%>' />
		<asset:scatter name='assetInstance' fieldlist='Dimension,Dimension-parent' prefix='dimasset'/>
<%
		int iTotal = Integer.parseInt(ics.GetVar("dimasset:Dimension:Total"));
		if (iTotal > 0)
		{
			for (int i = 0; i < iTotal; i++)
			{ 
				dimid = ics.GetVar("dimasset:Dimension:"+i); 
			}
		}
		int iDPTotal = Integer.parseInt(ics.GetVar("dimasset:Dimension-parent:Total"));
		for (int i = 0; i < iDPTotal; i++)
		{
			String id = ics.GetVar("dimasset:Dimension-parent:"+i+":asset");
			String group = ics.GetVar("dimasset:Dimension-parent:"+i+":group");
			//System.out.println(" p id "+id +" group "+group);
		}
		if (ics.GetList("listLocales") != null && ics.GetList("listLocales").hasData())
		{
			// Do this only if Dimension is enabled for this site
%>
	<ATTRIBUTE NAME="Dimension" DISPLAYNAME="<%=ics.GetVar("_XLAT_Dimension")%>" VALUE="" DataType="list" REQUIRED="false" READONLY="<%=ics.GetVar("cs_readOnly")%>" DESCRIPTION="Locale" > 
		<OPTIONS>
<%
			// Loop over locales
%>
			<ics:listloop listname='listLocales' >
				<ics:listget listname='listLocales' fieldname='id' output='did'/>
				<ics:listget listname='listLocales' fieldname='description' output='ddescription'/>
<%
				// Emit option for each locale
%>
			<OPTION VALUE="<%=ics.GetVar("did")%>" SELECTED="<%=(( dimid!=null) && (dimid.equalsIgnoreCase(ics.GetVar("did"))))?"true":"false"%>"  DISPLAYVALUE="<%=ics.GetVar("ddescription")%>"/>
<%
				// Done option
%>
			</ics:listloop>
<%
			// End of list
%>
		</OPTIONS>
	</ATTRIBUTE>
<%
		}
	}
%>
</ATTRIBUTES>

<!-- commands are changed to take care of mutliple check out MULTIPLE=true -->
<COMMANDS>
	 
<% 
	if ((isDimensionEnabled) && (dimid!=null))
	{ 
		Map<String,String> relat=getRelatives(ics.GetVar("AssetType"),ics.GetVar("asset:id"),ics);
		Map<String,String> parents=getParents(ics.GetVar("AssetType"),ics.GetVar("asset:id"),ics);
%>
	 <xlat:lookup key='dvin/CSDocLink/Translate' varname='translate_key'/>
	 <COMMAND NAME="<%=ics.GetVar("translate_key")%>" URI="ContentServer?pagename=OpenMarket" TYPE="normal" MULTIPLE="false">
<%
		if (ics.GetList("listLocales") != null && ics.GetList("listLocales").hasData())
		{
			// Do this only if Dimension is enabled for this site
%>
			<ics:listloop listname='listLocales' >
				<ics:listget listname='listLocales' fieldname='id' output='did'/>
				<ics:listget listname='listLocales' fieldname='description' output='ddescription'/>
<% 
				if (dimid!=null && dimid.equals(ics.GetVar("did")))
				{ 
				}
				else if (relat.get(ics.GetVar("did"))!=null )
				{ 
					String viewStr=ics.GetVar("view_key")+" "+ics.GetVar("ddescription");
					if (parents!=null && parents.get(ics.GetVar("did"))!=null )
						viewStr=ics.GetVar("view_key")+ics.GetVar("masterasset");
%>
					<ics:callelement element='OpenMarket/CSClient/BuildBlobURL'>
						<ics:argument name='cs_dropField' value='<%=dropfield.getValue("property")%>'/>
						<ics:argument name='relativeassetid' value='<%=relat.get(ics.GetVar("did"))%>'/>
					</ics:callelement>
<%
					// Emit a view subcommand
%>
		
		<SUBCOMMAND NAME="<%=viewStr %>" URI="<%=ics.GetVar("referURL")%>" TYPE="shell" DEFAULT="true" />
<%
				}
				else
				{
					// Emit a create subcommand
%>
		<xlat:lookup key='dvin/Common/Create' varname='create_key'/>
	     <SUBCOMMAND NAME="<%=ics.GetVar("create_key")%> <%=ics.GetVar("ddescription") %>" UPLOADURI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=TranslateUsingUpload(?)(RequestType=Post)SourceID=<%=ics.GetVar("asset:id")%>(?)dimid=<%=ics.GetVar("did")%>(?)(TargetPath;Node)(DroppedFile;TheFile)(?)DroppedOn=(TargetID)(?)(Attributes;new:;FromSource=true)(?)parentid=<%=ics.GetVar("op")%>"  COPYURI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=TranslateUsingCopy(?)Node2=<%=ics.GetVar("AssetType")%>(?)SourcePath2=<%=ics.GetVar("AssetType")%>(?)SourceID=<%=ics.GetVar("asset:id")%>(?)dimid=<%=ics.GetVar("did") %>(?)pubid=<%=ics.GetSSVar("pubid")%>(?)DroppedOn=(TargetID)(?)(Attributes;new:;FromSource=true)(?)parentid=<%=ics.GetVar("op")%>" />
<%
				}
%>
			</ics:listloop>
<%
		}
		
		if (parents!=null && parents.size()>0)
		{
			if (dimid!=null && parents.get(dimid)!=null )
			{
				// Emit master asset subcommand
%>
		 <xlat:lookup key='dvin/CSDocLink/MasterAsset' varname='masterasset_key'/>
    	<SUBCOMMAND NAME="<%=ics.GetVar("masterasset_key")%>" URI="" TYPE="normal" MULTIPLE="false" />
<%
			}
			else
			{
				// Emit makemaster subcommand
%>
		<SUBCOMMAND NAME="<%=ics.GetVar("makemaster")%>" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=MakeMaster(?)Node2=<%=ics.GetVar("AssetType")%>(?)SourceID=<%=ics.GetVar("asset:id")%>(?)parentid=<%=ics.GetVar("op")%>(?)dimid=<%=dimid%>(?)DroppedOn=(TargetID)(?)(Attributes;new:;FromSource=true)" TYPE="normal" MULTIPLE="false"/>
<%
			}
		}
%>
	</COMMAND>
<%
	}

	if ("true".equals(ics.GetVar("editLegal")) && "true".equals(ics.GetVar("trackingenabled")))
	{
		if (history == null || !history.hasData() || !history.getValue("lockedby").equals(ics.GetSSVar("username")))
		{
%>
	<xlat:lookup key='dvin/CSDocLink/CheckOut' varname='_XLAT_'/>
	<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" TBBITMAP="2010" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=RevTrackControl(?)id=<%=ics.GetVar("asset:id")%>(?)command=checkout(?)Edited=(TargetID)(?)(TargetPath;Node)" TYPE="normal" MULTIPLE="true"/>
<%
		}
		else
		{
%>
	<xlat:lookup key='dvin/CSDocLink/UndoCheckout' varname='_XLAT_'/>
	<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" TBBITMAP="2009" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=RevTrackControl(?)id=<%=ics.GetVar("asset:id")%>(?)command=undo(?)Edited=(TargetID)(?)(TargetPath;Node)" TYPE="normal" MULTIPLE="true"/>
	<xlat:lookup key='dvin/CSDocLink/CheckIn' varname='_XLAT_'/>
	<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" TBBITMAP="2012" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=RevTrackControl(?)id=<%=ics.GetVar("asset:id")%>(?)command=checkin(?)Edited=(TargetID)(?)(Attributes;checkin:;FromSource=true)(?)(TargetPath;Node)" TYPE="normal" MULTIPLE="true"/>
<%
		}
	}
	if ("true".equals(ics.GetVar("deleteLegal")))
	{
%>
		<xlat:lookup key='dvin/Common/Delete' varname='_XLAT_'/>
		<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=Delete(?)id=<%=ics.GetVar("asset:id")%>(?)(TargetPath;Node)" TYPE="normal"  MULTIPLE="true"/>
<%
	}
		 if ("true".equals(ics.GetVar("previewLegal"))) { %>
			<xlat:lookup key='dvin/Common/Preview' varname='_XLAT_'/> <%
			if (ics.GetVar("clearPassword")==null && ics.GetSSVar("usessoVal") == null) {
				vN.removeAll();
				vN.setValString("PASSWORD", ics.GetVar("password"));
				vN.setValString("VARNAME", "clearPassword");
				ics.runTag("misc.doclinkdecrypt", vN);
				}
		
				vN.removeAll();
				vN.setValString("PACKEDARGS", "cs.session=true");
				if (ics.GetSSVar("usessoVal") == null)
				{
					vN.setValString("PASSWORD", ics.GetVar("clearPassword"));
					vN.setValString("USERNAME", ics.GetVar("username"));
				}
				vN.setValString("PUBID", ics.GetSSVar("pubid"));
				vN.setValString("ASSETID", ics.GetVar("asset:id"));
				vN.setValString("ASSETTYPE", ics.GetVar("AssetType"));
				vN.setValString("VARNAME", "PreviewURL");
				ics.runTag("previewurl.makeurl", vN);
            
			String currentURL = Utilities.replaceAll(ics.GetVar("PreviewURL"), "?", "(?)");
			currentURL = Utilities.replaceAll(ics.GetVar("PreviewURL"), "&", "(?)"); 
			if (ics.GetSSVar("usessoVal") == null)
			{
				currentURL=currentURL+"(?)authusername="+ics.GetVar("username") +"(?)authpassword="+ics.GetVar("clearPassword");
			}
			%>

		<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" URI="<%=currentURL%>" TYPE="shell"/>
<%
		 }
	if ("true".equals(ics.GetVar("inspectLegal")) && hasFile)
	{
%>
		<ics:callelement element='OpenMarket/CSClient/BuildBlobURL'>
			<ics:argument name='cs_dropField' value='<%=dropfield.getValue("property")%>'/>
			<ics:argument name='relativeassetid' value='<%=ics.GetVar("asset:id")%>'/>
		</ics:callelement>
           
		<COMMAND NAME="<%=ics.GetVar("view_key")%>" URI="<%=ics.GetVar("referURL")%>" TYPE="shell" DEFAULT="true"/>
<%
	} 
	java.util.Hashtable assigned = (java.util.Hashtable) ics.GetObj("hAssignedAssets");
	if (assigned.containsKey(ics.GetVar("asset:id")))
	{
%>
		<xlat:lookup key='dvin/UI/AssetMgt/FinishMyAssignment' varname='_XLAT_'/>
		<COMMAND NAME="<%=ics.GetVar("_XLAT_")%>" URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=FinishAssignment(?)AssetType=<%=ics.GetVar("AssetType")%>(?)primarypubid=<%=ics.GetSSVar("pubid")%>(?)id=<%=ics.GetVar("asset:id")%>(?)(Attributes;finish:;FromSource=true)(?)(TargetPath;Node)" TYPE="normal"/>
<%
	}
%>
	</COMMANDS>
<%
	if ("true".equals(ics.GetVar("editLegal")))
	{
%>
	<UPDATEURI URI="<%=ics.GetVar("cgipathapproot")%>ContentServer?pagename=OpenMarket/CSClient/CSClientPage(?)CSCPage=Update(?)Edited=(TargetID)(?)(TargetPath;Node)(?)(Attributes;changes:)"/>
<%
	}
%>
</CHILD>
<% 
}
%> 

</cs:ftcs>
