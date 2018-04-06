<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>

<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>

<cs:ftcs>

	<!-- ASSUME that this is the EDIT view... deal with layering the "Inspect" view later -->

	<!--New Segment Selection-->
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/SegmentKeyLookup"/>
	
	<ics:sql sql="select distinct assetattr from FlexAssetTypes ORDER BY assetattr" listname= "SortAssetTypeList" table="FlexAssetTypes"/>

	<xlat:lookup key="dvin/AT/Common/Special" varname="SpStrH"/>

	<!-- Prepare for the Dynamic element selection  typeAhead -->
	<satellite:link pagename="fatwire/ui/util/TypeAheadSearchResults" assembler="query" outstring="typeAheadUrl">
		<satellite:argument name="searchField" value='name'/>
		<satellite:argument name="searchOperation" value='STARTS_WITH'/>
		<satellite:argument name="assetType" value='CSElement'/>
		<satellite:argument name="assetSubType" value=''/>
		<satellite:argument name="sort" value='name'/>
		<satellite:argument name="rows" value='1000'/>	
	</satellite:link>

<% 
{
	// =============================================================================
	// JS/JSON data representing a set of asset types and attributes - used for Sort
	// =============================================================================

	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("sortAssetData = [\r\n");

	IList assetTypeList = ics.GetList("SortAssetTypeList"); 
	int nTypes = assetTypeList.numRows();

	FTValList args = new FTValList();

	for (int type=0; type < nTypes; type++)
	{
		assetTypeList.moveTo(type+1);

		String assetType = assetTypeList.getValue("assetattr");

		// <ATM.LOCATE TYPE=typeName varname="AMGR"/>
		args.removeAll();
		args.setValString("TYPE", assetType);
		args.setValString("VARNAME", "AMGR");
		ics.runTag("atm.locate", args);				
	
		// <COMPLEXASSETS.GETALLASSETS NAME="AMGR" LISTVARNAME="AllAttr" SITE="SessionVariables.pubid"/>
		args.removeAll();
		args.setValString("NAME", "AMGR");
		args.setValString("LISTVARNAME", "AllAttr");
		args.setValString("SITE", ics.GetSSVar("pubid"));
		ics.runTag("complexassets.getallassets", args);
	
		IList attrList = ics.GetList("AllAttr"); 
		int nAttrs = attrList.numRows();

		if (type != 0)
			ics.StreamText(",");
		
		ics.StreamText("{name:'" + StringEscapeUtils.escapeJavaScript(assetType) + "',\r\n");
		
		args.removeAll();
		args.setValString("LIST", "thisAssetType");
		args.setValString("FIELD1", "assettype");
		args.setValString("VALUE1", assetType);
		ics.runTag("ASSETTYPE.LIST", args);

		IList thisAssetType = ics.GetList("thisAssetType");
		ics.StreamText(" desc:'" + StringEscapeUtils.escapeJavaScript(thisAssetType.getValue("description")) + "',\r\n");
		
		ics.StreamText(" attributes: [ ");
		
		for (int attr = 0; attr < nAttrs; attr++)
		{
			attrList.moveTo(attr+1);
			
			String attrId = attrList.getValue("assetid");			

			args.removeAll();
			args.setValString("TYPE", assetType);
			args.setValString("LIST", "AttrInst");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", attrId);
			ics.runTag("ASSET.LIST", args);
			
			IList attrInst = ics.GetList("AttrInst");

			if (attr != 0)
				ics.StreamText(",");
			
			ics.StreamText("'" + StringEscapeUtils.escapeJavaScript(attrInst.getValue("name")) + "'");
		}
		
		ics.StreamText(" ]\r\n");
		ics.StreamText("}\r\n");
	}
		
	// add the "special" asset and attributes
	if (nTypes > 0)
		ics.StreamText(", ");
	
	ics.StreamText("{name:'SpStrH', desc:'" + ics.GetVar("SpStrH") + "',attributes: ['_ASSETTYPE_', '_CONFIDENCE_', '_RATING_' ]}");
	
	ics.StreamText("] \r\n");	// close "assetData" array
	ics.StreamText("</script>\r\n");
}
%>

<% 
{
	// =========================================================
	// JS/JSON data representing the full list of known segments
	// =========================================================

	// <ATM.LOCATE TYPE="Segments" varname="segmgr"/>
	FTValList args = new FTValList();
	
	args.removeAll();
	args.setValString("TYPE", "Segments");
	args.setValString("VARNAME", "segmgr");
	ics.runTag("atm.locate", args);				

	// <COMPLEXASSETS.GETALLASSETS NAME="segmgr" LISTVARNAME="SegList" SITE="SessionVariables.pubid"/>
	args.removeAll();
	args.setValString("NAME", "segmgr");
	args.setValString("LISTVARNAME", "SegList");
	args.setValString("SITE", ics.GetSSVar("pubid"));
	ics.runTag("complexassets.getallassets", args);

	IList segList = ics.GetList("SegList"); 
	int nSegs = segList.numRows();
	int seg = 0;
	
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("segmentData = [\r\n");
	
	for (seg=0; seg < nSegs; seg++)
	{
		segList.moveTo(seg+1);

		if (seg != 0)
			ics.StreamText(",");
		
		String assetid = segList.getValue("assetid");

		args.removeAll();
		args.setValString("TYPE", "Segments");
		args.setValString("LIST", "SegInst");
		args.setValString("FIELD1", "id");
		args.setValString("VALUE1", assetid);
		ics.runTag("ASSET.LIST", args);
		
		IList segInst = ics.GetList("SegInst");
		
		ics.StreamText("{name:'" + StringEscapeUtils.escapeJavaScript(segInst.getValue("name")) + "'");
		ics.StreamText(",key:'" + StringEscapeUtils.escapeJavaScript(Utilities.genID()) + "'");
		ics.StreamText(",id:'" + StringEscapeUtils.escapeJavaScript(assetid) + "'}");
	}
		
	ics.StreamText("] \r\n");	// close "segmentData" array
	ics.StreamText("</script>\r\n");
}
%>


<% 
{
	// ============================================================
	// JS/JSON data representing the full list of known asset types
	// ============================================================
	
	FTValList args = new FTValList();
		
	// <PUBLICATION.LOAD NAME="thissite" OBJECTID="SessionVariables.pubid"/>
	args.removeAll();
	args.setValString("NAME", "thisSite");
	args.setValString("OBJECTID", ics.GetSSVar("pubid"));
	ics.runTag("publication.load", args);				

   // <PUBLICATION.CHILDREN NAME="thissite" LIST="typeList" OBJECTTYPE="AssetType" ORDER="description"/>
	args.removeAll();
	args.setValString("NAME", "thisSite");
	args.setValString("LIST", "TypeList");
	args.setValString("OBJECTTYPE", "AssetType");
	args.setValString("ORDER", "description");
	ics.runTag("PUBLICATION.CHILDREN", args);

	IList typeList = ics.GetList("TypeList"); 
	int nTypes = typeList.numRows();
	int type = 0;
	
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("assetTypeData = [\r\n");
	
	for (type=0;  type < nTypes; type++)
	{
		typeList.moveTo(type+1);

		if (type != 0)
			ics.StreamText(",");
		
		String assetid = typeList.getValue("oid");
		
		args.removeAll();
		args.setValString("LIST", "thisAssetType");
		args.setValString("FIELD1", "id");
		args.setValString("VALUE1", assetid);
		ics.runTag("ASSETTYPE.LIST", args);

		IList thisAssetType = ics.GetList("thisAssetType");
	
		String saveAssetType = ics.GetVar("AssetType");
		args.removeAll();
		args.setValString("AssetType", thisAssetType.getValue("assettype"));
		args.setValString("AssetDef", "");			
		ics.CallElement("OpenMarket/Gator/UIFramework/FindAssetImage", args);
		ics.SetVar("AssetType", saveAssetType);

		String iconPath = ics.GetVar("imageUsed");
		
		if (iconPath == null)
			iconPath = "";
		
		ics.StreamText("{type:'" + StringEscapeUtils.escapeJavaScript(thisAssetType.getValue("assettype")) + "'");
		ics.StreamText(", desc:'" + StringEscapeUtils.escapeJavaScript(thisAssetType.getValue("description")) + "'");
		ics.StreamText(", icon:'" + StringEscapeUtils.escapeJavaScript(iconPath) + "'}");
	}
		
	ics.StreamText("] \r\n");	// close "assetTypeData" array
	ics.StreamText("</script>\r\n");
}
%>

<%
{
	// =============================================================
	// JS/JSON data representing the RECOMMENDATION 
	// (mode + type + options + sort + select + segments +  assets) 
	// =============================================================

	FTValList args = new FTValList();
		
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("listData = {\r\n");
	
	ics.StreamText("mode:'" + StringEscapeUtils.escapeJavaScript(ics.GetVar("AdvColMode")) + "',\r\n");
	
	String advcoltype = ics.GetVar("advcoltype");
	
	if (advcoltype == null)
		advcoltype = "";
	
	ics.StreamText("type:'" + StringEscapeUtils.escapeJavaScript(advcoltype) + "',\r\n");

	// ===========================

	String elementid = ics.GetVar("ContentDetails:elementid");
	String elementname = "";
	
	if (elementid == null)
		elementid = "";
	
	ics.StreamText("elementid:'" + StringEscapeUtils.escapeJavaScript(elementid) + "',\r\n");
	
	if (!elementid.isEmpty())
	{	
		args.removeAll();
		args.setValString("TYPE",  "CSElement");
		args.setValString("LIST", "thisElement");
		args.setValString("FIELD1", "id");
		args.setValString("VALUE1", elementid);
		ics.runTag("ASSET.LIST", args);
		
		IList thisElement = ics.GetList("thisElement");
		elementname = thisElement.getValue("name");
	}

	ics.StreamText("elementid:'" + StringEscapeUtils.escapeJavaScript(elementid) + "',\r\n");
	ics.StreamText("elementname:'" + StringEscapeUtils.escapeJavaScript(elementname) + "',\r\n");
			
	// ===========================
	
	String selection = ics.GetVar("ContentDetails:style");
	
//	if (selection == null || selection.isEmpty())
//		selection = "F";

	if (selection == null)
		selection = "H";
	
	ics.StreamText("selection:'" + StringEscapeUtils.escapeJavaScript(selection) + "',\r\n");

	// ===========================
		
	ics.StreamText("options: {\r\n");
	
	ics.StreamText("ovrdable:'" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ContentDetails:ovrdable")) + "',\r\n");
	ics.StreamText("mapstyle:'" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ContentDetails:mapstyle")) + "',\r\n");

	int nTypes = Integer.parseInt(ics.GetVar("ContentDetails:types:Total"));		
	
	ics.StreamText("types: [\r\n");
	
	if (nTypes == 1 && "_ALL_".equals(ics.GetVar("ContentDetails:types:0")))
	{
		ics.StreamText("{type:'_ALL_'");
		ics.StreamText(",desc:''}");
	}
	else	
	{
		for (int t = 0; t < nTypes; t++)
		{
			if (t != 0)
				ics.StreamText(",");

			String ourType = ics.GetVar("ContentDetails:types:" + Integer.toString(t));
			
			args.removeAll();
			args.setValString("LIST", "assetTypeList");
			args.setValString("FIELD1", "assettype");
			args.setValString("VALUE1", ourType);
			ics.runTag("ASSETTYPE.LIST", args);
			
			IList assetTypeList = ics.GetList("assetTypeList");		
		
			ics.StreamText("{type:'" +  StringEscapeUtils.escapeJavaScript(ourType) + "'");
			ics.StreamText(",desc:'" +  StringEscapeUtils.escapeJavaScript(assetTypeList.getValue("description")) + "'}");
		}
	}
	
	ics.StreamText("]\r\n");		// close "types" array
	ics.StreamText("},\r\n"); 		// close "options" object
	
	// ===========================
		
	ics.StreamText("sortorder: [\r\n");
	
	IList sortOrderList = ics.GetList("ContentDetails:Sortorder");		
	
	if (sortOrderList == null)
	{	// generate default entry
		
		ics.StreamText("{ attributetypename:'SpStrH'");
		ics.StreamText(", attributename:'_CONFIDENCE_'");
		ics.StreamText(", direction:'descending' }\r\n");
	}
	else
	{
		int nSorts = sortOrderList.numRows();
		
		for (int rec=0; rec < nSorts; rec++)
		{
			sortOrderList.moveTo(rec+1);
	
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{ attributetypename:'" +  StringEscapeUtils.escapeJavaScript(sortOrderList.getValue("attributetypename")) + "'");
			ics.StreamText(", attributename:'" +  StringEscapeUtils.escapeJavaScript(sortOrderList.getValue("attributename")) + "'");
			ics.StreamText(", direction:'" +  StringEscapeUtils.escapeJavaScript(sortOrderList.getValue("direction")) + "' }\r\n");
		}		
	}
	
	ics.StreamText("],\r\n"); 		// close "sortorder" array
		
	// ===========================
		
	ics.StreamText("segments: [\r\n");

	IList segList = ics.GetList("SegFromKeysList"); 
	int nSegs = segList.numRows();
	
	for (int seg=0; seg < nSegs; seg++)
	{
		segList.moveTo(seg+1);

		if (seg != 0)
			ics.StreamText(",");
		
		ics.StreamText("{name:'" + StringEscapeUtils.escapeJavaScript(segList.getValue("segName")) + "'");
		ics.StreamText(",key:'" + StringEscapeUtils.escapeJavaScript(segList.getValue("segKey")) + "'");
		ics.StreamText(",id:'" + StringEscapeUtils.escapeJavaScript(segList.getValue("segId")) + "'");

		ics.StreamText(", assets: [\r\n");

		// asset list detail goes here

		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("LISTVARNAME", "recList");
		args.setValString("BUCKET", segList.getValue("segKey") + "_IN");
		ics.runTag("ACOLLECTION.SORTMANUALRECOMMENDATIONS", args);

		IList recList = ics.GetList("recList");		

		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("LISTVARNAME", "outList");
		args.setValString("BUCKET", segList.getValue("segKey") + "_OUT");
		ics.runTag("ACOLLECTION.SORTMANUALRECOMMENDATIONS", args);

		IList outList = ics.GetList("outList");		
		
		int nRecs = recList.numRows();
		
		for (int rec=0; rec < nRecs; rec++)
		{
			recList.moveTo(rec+1);
			
			String assetid = recList.getValue("assetid");
			String assettype = recList.getValue("assettype");
			String confidence = recList.getValue("confidence");
			String outconfidence = null;
			
			Float f = new Float(confidence);
			f = f*100;
			confidence = Integer.toString(Math.round(f));

			// slight ugliness... we need to scan the "outList" loolking for "out of segment confidence" values for this assetid
			// hopefully the list will not be very long... and I know that the original code was even more horrible...
			
			if (outList != null)
			{
				int nOuts = outList.numRows();
				for (int nOut=0; nOut < nOuts; nOut++)
				{
					outList.moveTo(nOut+1);
					
					if (assetid.equals(outList.getValue("assetid")))
					{
						outconfidence = outList.getValue("confidence");						
						
						Float fo = new Float(outconfidence);
						fo = fo*100;
						outconfidence = Integer.toString(Math.round(fo));
						break;
					}
				}
			}
			
			args.removeAll();
			args.setValString("TYPE",  assettype);
			args.setValString("LIST", "assetList");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", assetid);
			ics.runTag("ASSET.LIST", args);
			
			IList assetList = ics.GetList("assetList");
			
			args.removeAll();
			args.setValString("LIST", "assetTypeList");
			args.setValString("FIELD1", "assettype");
			args.setValString("VALUE1", assettype);
			ics.runTag("ASSETTYPE.LIST", args);
			
			IList assetTypeList = ics.GetList("assetTypeList"); 
			
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{id:'" +  StringEscapeUtils.escapeJavaScript(assetid) + "'");
			ics.StreamText(",type:'" +  StringEscapeUtils.escapeJavaScript(assettype) + "'");
			ics.StreamText(",typedesc:'" +  StringEscapeUtils.escapeJavaScript(assetTypeList.getValue("description")) + "'");
			ics.StreamText(",name:'" +  StringEscapeUtils.escapeJavaScript(assetList.getValue("name")) + "'");
			ics.StreamText(",confidence:'" + StringEscapeUtils.escapeJavaScript(confidence) + "'");
			
			if (outconfidence != null)
				ics.StreamText(",outconfidence:'" + StringEscapeUtils.escapeJavaScript(outconfidence) + "'");
			
			String saveAssetType = ics.GetVar("AssetType");
			args.removeAll();
			args.setValString("AssetType", assettype);
			args.setValString("AssetDef", "");			
			ics.CallElement("OpenMarket/Gator/UIFramework/FindAssetImage", args);
			ics.SetVar("AssetType", saveAssetType);
			
			String iconPath = ics.GetVar("imageUsed");
			
			if (iconPath == null)
				iconPath = "";
			
			ics.StreamText(",icon:'" + StringEscapeUtils.escapeJavaScript(iconPath) + "'");
		
			ics.StreamText("}\r\n");	// close the asset object
		}
		
		ics.StreamText("]\r\n");	// close the  "assets" array
		
		ics.StreamText(", listasset: {id: 'LIST_ID', name: 'LIST_NAME', type: 'LIST_TYPE', typedesc: 'LIST_TYPEDESC'} \r\n");
		
		ics.StreamText(" }\r\n");	// close one "segment" object
	}

	ics.StreamText("] \r\n");	// close "segments" array

	// now - deal with the "no segments apply" case

	{
		ics.StreamText(", assets: [\r\n");

		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("LISTVARNAME", "recList");
		args.setValString("BUCKET", "");
		ics.runTag("ACOLLECTION.SORTMANUALRECOMMENDATIONS", args);
	
		IList recList = ics.GetList("recList");		
	
		//@BJN DUPLICATE
		
		int nRecs = recList.numRows();
		
		for (int rec=0; rec < nRecs; rec++)
		{
			recList.moveTo(rec+1);
			
			String assetid = recList.getValue("assetid");
			String assettype = recList.getValue("assettype");
			String confidence = recList.getValue("confidence");
	
			Float f = new Float(confidence);
			f = f*100;
			confidence = Integer.toString(f.intValue());

			args.removeAll();
			args.setValString("TYPE",  assettype);
			args.setValString("LIST", "assetList");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", assetid);
			ics.runTag("ASSET.LIST", args);
			
			IList assetList = ics.GetList("assetList");
			
			args.removeAll();
			args.setValString("LIST", "assetTypeList");
			args.setValString("FIELD1", "assettype");
			args.setValString("VALUE1", assettype);
			ics.runTag("ASSETTYPE.LIST", args);
			
			IList assetTypeList = ics.GetList("assetTypeList"); 
			
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{id:'" +  StringEscapeUtils.escapeJavaScript(assetid) + "'");
			ics.StreamText(",type:'" +  StringEscapeUtils.escapeJavaScript(assettype) + "'");
			ics.StreamText(",typedesc:'" +  StringEscapeUtils.escapeJavaScript(assetTypeList.getValue("description")) + "'");
			ics.StreamText(",name:'" +  StringEscapeUtils.escapeJavaScript(assetList.getValue("name")) + "'");
			ics.StreamText(",confidence:'" + StringEscapeUtils.escapeJavaScript(confidence) + "'");
			
			ics.StreamText("}\r\n");	// close the asset object
		}
		
		ics.StreamText("]\r\n");	// close "assets" array

		ics.StreamText(", listasset: {id: 'LIST_ID', name: 'LIST_NAME', type: 'LIST_TYPE', typedesc: 'LIST_TYPEDESC'} \r\n");
	}
	
	ics.StreamText("} \r\n");	// close outer level "listData" object
	ics.StreamText("</script>\r\n");
} %>

</cs:ftcs>