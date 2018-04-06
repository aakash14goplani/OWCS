<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>

<%@ page import="com.openmarket.gator.nvobject.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/Segments/ContentFormLoadData
--
-- INPUT

--	nvobject named nvRuleSet
--
-- OUTPUT
--
-->

<%	// VISITOR DATA (Scalar Attributes)
{
	ics.CallElement("OpenMarket/Xcelerate/AssetType/Segments/GetCatLists", null);
	
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("visitorData = {\r\n");
	ics.StreamText("categories: [\r\n");

	IList catList = ics.GetList("catList"); 
	int nCats = catList.numRows();
	
	for (int cat=0; cat < nCats; cat++)
	{
		catList.moveTo(cat+1);
		
		String catName = catList.getValue("name");

		if (cat != 0)
			ics.StreamText(",");
			
		ics.StreamText("{ name: '" + StringEscapeUtils.escapeJavaScript(catName) + "',\r\n");
		ics.StreamText("attributes: [ \r\n");
		
		FTValList args = new FTValList();
		args.setValString("TYPE", "ScalarVals");
		args.setValString("VARNAME", "ScalarMgr");
		ics.runTag("atm.locate", args);				

		args.removeAll();
		args.setValString("NAME", "ScalarMgr");
		args.setValString("CATEGORY", catName);
		args.setValString("LISTVARNAME", "ScalarList");
		args.setValString("SITE", ics.GetSSVar("pubid"));
		ics.runTag("scalardatums.getall", args);				

		IList attList = ics.GetList("ScalarList"); 
		int nAtts = attList.numRows();
		
		for (int att=0; att < nAtts; att++)
		{
			attList.moveTo(att+1);
			
			String attID = attList.getValue("attrid");

			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("ATTRIBUTE", attID);
			ics.runTag("visitordata.getscalarattributedef", args);				
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theDescription");
			ics.runTag("visitorscalar.getDescription", args);				
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theType");
			ics.runTag("visitorscalar.getType", args);		
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theLength");
			ics.runTag("visitorscalar.getlength", args);		

			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theDefault");
			ics.runTag("visitorscalar.getdefaultvalue", args);		
			
			if (att != 0)
				ics.StreamText(",");

			ics.StreamText("{ id: '" + attID + "'");
			ics.StreamText(" , type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theType")) + "'");
			ics.StreamText(" , desc: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theDescription")) + "'");
			ics.StreamText(" , length: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theLength")) + "'");
			ics.StreamText(" , defaultvalue: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theDefault")) + "'");

			args.removeAll();
			args.setValString("NAME", "ScalarMgr");
			args.setValString("ID", attID);
			args.setValString("VARNAME", "theAssetID");
			args.setValString("SITE", ics.GetSSVar("pubid"));
			ics.runTag("scalardatums.getassetid", args);				
			
			String theAssetID = ics.GetVar("theAssetID");
			
			if (theAssetID != null && !theAssetID.isEmpty())
				ics.StreamText(" , assetid: '" + StringEscapeUtils.escapeJavaScript(theAssetID) + "'");
			
			// also need to get the value "constraints" (if any?)

			ics.StreamText(" , constraint: { ");
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theConstraint");
			ics.runTag("visitorscalar.getvalueconstraint", args);		
			
			args.removeAll();
			args.setValString("NAME", "theConstraint");
			args.setValString("VARNAME", "theConstraintType");
			ics.runTag("visitorconstraint.gettype", args);		
			ics.StreamText(" type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintType")) + "'");
			
			if ("enum".equals(ics.GetVar("theConstraintType")))
			{
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("LISTVARNAME", "theConstraintList");
				ics.runTag("visitorconstraint.getlegalvalues", args);		

				ics.StreamText(", list: [");
				
				IList list = ics.GetList("theConstraintList");
				
				int nVals = list.numRows();
				
				for (int val=0; val < nVals; val++)
				{
					if (val != 0)
						ics.StreamText(", ");
					
					list.moveTo(val+1);
					ics.StreamText("'" + StringEscapeUtils.escapeJavaScript(list.getValue("value")) + "'");
				}
				
				ics.StreamText("]\r\n");
			}
			else
			if ("range".equals(ics.GetVar("theConstraintType")))
			{
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("VARNAME", "theConstraintStart");
				ics.runTag("visitorconstraint.getstart", args);		

				ics.StreamText(", start: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintStart")) + "'");
				
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("VARNAME", "theConstraintEnd");
				ics.runTag("visitorconstraint.getend", args);
				
				ics.StreamText(", end: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintEnd")) + "'");
			}
			
			ics.StreamText(" }\r\n");	// close off the "constraint" object
			
			ics.StreamText(" }\r\n");	// close off the "att" object
		}
		
		ics.StreamText("] }\r\n");		// close attributes array and category object
	}
	
	ics.StreamText("] } \r\n");			// close categories array and outer level "visitorData" object
	ics.StreamText("</script>\r\n");
}
%>

<%	// HISTORY DATA (History Attributes)
{
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("historyData = {\r\n");
	ics.StreamText("categories: [\r\n");
	
	IList catList = ics.GetList("catHList"); 
	int nCats = catList.numRows();
	
	for (int cat=0; cat < nCats; cat++)
	{
		catList.moveTo(cat+1);
		
		String catName = catList.getValue("name");

		if (cat != 0)
			ics.StreamText(",");

		ics.StreamText("{ name: '" + StringEscapeUtils.escapeJavaScript(catName) + "',\r\n");
		ics.StreamText("attributes: [ \r\n");
	
		FTValList args = new FTValList();
		args.setValString("TYPE", "HistoryVals");
		args.setValString("VARNAME", "HistoryMgr");
		ics.runTag("atm.locate", args);				
	
		args.removeAll();
		args.setValString("NAME", "HistoryMgr");
		args.setValString("CATEGORY", catName);
		args.setValString("LISTVARNAME", "HistoryList");
		args.setValString("SITE", ics.GetSSVar("pubid"));
		ics.runTag("historydatums.getall", args);				
	
		IList attList = ics.GetList("HistoryList"); 
		int nAtts = attList.numRows();
		
		for (int att=0; att < nAtts; att++)
		{
			attList.moveTo(att+1);
	
			String attID = attList.getValue("attrid");
	
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("ATTRIBUTE", attID);
			ics.runTag("visitordata.gethistoryattributedef", args);				
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("VARNAME", "theDescription");
			ics.runTag("visitorhistory.getDescription", args);		
			
	//		args.removeAll();
	//		args.setValString("NAME", "theDefinition");
	//		args.setValString("VARNAME", "theType");
	//		ics.runTag("visitorhistory.getType", args);		
			
			if (att != 0)
				ics.StreamText(",");
	
			ics.StreamText("{ id: '" + StringEscapeUtils.escapeJavaScript(attID) + "'");
	//		ics.StreamText(" , type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theType")) + "'");
			ics.StreamText(" , desc: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theDescription")) + "'");
			
			args.removeAll();
			args.setValString("NAME", "HistoryMgr");
			args.setValString("ID", attID);
			args.setValString("VARNAME", "theAssetID");
			args.setValString("SITE", ics.GetSSVar("pubid"));
			ics.runTag("historydatums.getassetid", args);				
			
			String theAssetID = ics.GetVar("theAssetID");
			
			if (theAssetID != null && !theAssetID.isEmpty())
				ics.StreamText(" , assetid: '" + StringEscapeUtils.escapeJavaScript(theAssetID) + "'");
			
			args.removeAll();
			args.setValString("NAME", "theDefinition");
			args.setValString("LISTVARNAME", "theFieldDefs");
			ics.runTag("visitorhistory.getallfielddefs", args);				
			
			IList fieldList = ics.GetList("theFieldDefs"); 
			int nFields = fieldList.numRows();
					
			ics.StreamText(" , fields: [");
			
			for (int field=0; field < nFields; field++)
			{
				fieldList.moveTo(field+1);
	
				String fieldDefName = fieldList.getValue("name");
	
				args.removeAll();
				args.setValString("FIELD", fieldDefName);
				args.setValString("NAME", "theFieldDef");
				ics.runTag("visitordata.gethistoryattributefielddef", args);
				
				args.removeAll();
				args.setValString("NAME", "theFieldDef");
				args.setValString("VARNAME", "theFieldDescription");
				ics.runTag("visitorhistoryfield.getdescription", args);
				
				args.removeAll();
				args.setValString("NAME", "theFieldDef");
				args.setValString("VARNAME", "theFieldName");
				ics.runTag("visitorhistoryfield.getname", args);
	
				args.removeAll();
				args.setValString("NAME", "theFieldDef");
				args.setValString("VARNAME", "theFieldType");
				ics.runTag("visitorhistoryfield.gettype", args);
	
				args.removeAll();
				args.setValString("NAME", "theFieldDef");
				args.setValString("VARNAME", "theFieldDefaultValue");
				ics.runTag("visitorhistoryfield.getdefaultvalue", args);
				
				if (field != 0)
					ics.StreamText(", ");
				
				ics.StreamText("{ name: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theFieldName")) + "'");
				ics.StreamText(" , desc: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theFieldDescription")) + "'");
				ics.StreamText(" , type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theFieldType")) + "'");
				ics.StreamText(" , defaultvalue: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theFieldDefaultValue")) + "'");
				
				// also need to get the value "constraints" (if any?)
	
				ics.StreamText(" , constraint: { ");
				
				args.removeAll();
				args.setValString("NAME", "theFieldDef");
				args.setValString("VARNAME", "theConstraint");
				ics.runTag("visitorhistoryfield.getvalueconstraint", args);		
				
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("VARNAME", "theConstraintType");
				ics.runTag("visitorconstraint.gettype", args);		
	
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("VARNAME", "theConstraintAssetType");
				ics.runTag("visitorconstraint.getassettype", args);		
				
				args.removeAll();
				args.setValString("NAME", "theConstraint");
				args.setValString("VARNAME", "theConstraintAssetAttribute");
				ics.runTag("visitorconstraint.getassetattribute", args);		
				
				ics.StreamText(" type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintType")) + "'");
				ics.StreamText(" , assettype: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintAssetType")) + "'");
				ics.StreamText(" , assetattribute: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintAssetAttribute")) + "'");
				
				// slightly odd stuff... 
				// the HCONSTRTYPE value stored in the rule specifies "value" or "assetattr"...
				// I *think* this is to discriminate between a scalar data "value" vs. a formated "assetid" field.
				// the "type" of the constraint then controls how to edit the "value" as usual...
				
				String hType = "".equals(ics.GetVar("theConstraintAssetType")) ? "value" : "assetattr";
				ics.StreamText(" , htype: '" + StringEscapeUtils.escapeJavaScript(hType) + "'");
				
				if ("enum".equals(ics.GetVar("theConstraintType")))
				{
					args.removeAll();
					args.setValString("NAME", "theConstraint");
					args.setValString("LISTVARNAME", "theConstraintList");
					ics.runTag("visitorconstraint.getlegalvalues", args);		
	
					ics.StreamText(", list: [");
					
					IList list = ics.GetList("theConstraintList");
					
					int nVals = list.numRows();
					
					for (int val=0; val < nVals; val++)
					{
						if (val != 0)
							ics.StreamText(", ");
						
						list.moveTo(val+1);
						ics.StreamText("'" + StringEscapeUtils.escapeJavaScript(list.getValue("value")) + "'");
					}
					
					ics.StreamText("]\r\n");
				}
				else
				if ("range".equals(ics.GetVar("theConstraintType")))
				{
					args.removeAll();
					args.setValString("NAME", "theConstraint");
					args.setValString("VARNAME", "theConstraintStart");
					ics.runTag("visitorconstraint.getstart", args);		
	
					ics.StreamText(", start: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintStart")) + "'");
					
					args.removeAll();
					args.setValString("NAME", "theConstraint");
					args.setValString("VARNAME", "theConstraintEnd");
					ics.runTag("visitorconstraint.getend", args);
					
					ics.StreamText(", end: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("theConstraintEnd")) + "'");
				}
				
				ics.StreamText(" }\r\n");	// close off the "constraint" object
				
				ics.StreamText(" }\r\n");	// close off the "field" object
			}
			ics.StreamText(" ]\r\n");	// close off the "fields" array
			
			ics.StreamText(" }\r\n");	// close off the "att" object
		}		
		
		ics.StreamText("] }\r\n");		// close attributes array and category object
	}
	
	ics.StreamText("] } \r\n");			// close categories array and outer level "historyData" object
	ics.StreamText("</script>\r\n");
}
%>

<%	// RULESET - set up to traverse rows
{
	NVObject nv = (NVObject) ics.GetObj("nvRuleSet");
	NVObject nvRow = new NVObject();
	NVObject nvCell = new NVObject();
	NVItem 	 nvItem = null;

	int nRows = Integer.parseInt(nv.getValue("NUMAND"));

	ics.StreamText("<script type='text/javascript'>\r\n");

	ics.StreamText("nvRuleSet = {");
	ics.StreamText("\r\n");
	
	// rows: [ { cols: [ cell: {foo: bar}] } ]	       
	          
	ics.StreamText("rows: [\r\n");
	
	for (int row = 0; row < nRows; row++)
	{
		nvRow.setFromString(nv.getValue("ANDCLAUSE" + row));
		int nCols = Integer.parseInt(nvRow.getValue("NUMCOL"));

		if (row != 0)
			ics.StreamText(", ");
		
		ics.StreamText("{ cols: [");		// array of cells for this row
		
		ics.StreamText("\r\n");
		
		for (int col = 0; col < nCols; col++)
		{
			nvCell.setFromString(nvRow.getValue("ORCLAUSE" + col));

			nvItem = nvCell.getFirst();

			if (col != 0)
				ics.StreamText(", ");
			
			ics.StreamText("{ ");		// open "cell"	
			
			boolean first = true;
			
			while (nvItem != null)
			{
				String name = nvItem.getValueName();

				if (name != null && !name.equals("NUMASSETS") && !name.startsWith("ASSETKEY")
						         && !name.equals("HNUMCONSTR") && !name.startsWith("HCONSTR") 
						         && !name.startsWith("HNUMCONSTRVALUE"))
				{	
					// extract leaf properties of the cell
					
					String value = StringEscapeUtils.escapeJavaScript(nvItem.getValue());
					
					if (first)
						first = false;
					else
						ics.StreamText("\r\n, ");	

					ics.StreamText(name + ": '" + value + "'");
				}
				
				nvItem = nvItem.getNext();
			}

			// Shopping Cart Assets
			
			String strNumAssets = nvCell.getValue("NUMASSETS");

			if (strNumAssets != null)
			{
				// create an array of associated assets
				
				ics.StreamText("\r\n, assets: [\r\n ");	
				
				int numAssets = Integer.parseInt(strNumAssets);
				
				for (int index = 0; index < numAssets; index++)
				{
					String name = "ASSETKEY" + Integer.toString(index);
					String value = nvCell.getValue(name); 
					
					if (value == null)
						value = "";

					if (index != 0)
						ics.StreamText(", ");
					
					ics.StreamText("{ ");	
					
					FTValList args = new FTValList();
				    args.removeAll();
				    args.setValString("ourKey", value);
			      	ics.CallElement("OpenMarket/Gator/Rules/RuleSetMapKeyLookup", args);					
					
					ics.StreamText("id: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ourAssetid")) + "'");
					ics.StreamText(", type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ourAssettype")) + "'");
					
					args.removeAll();
					
					args.setValString("LIST", "clAsset");
					args.setValString("TYPE", ics.GetVar("ourAssettype"));
					args.setValString("FIELD1", "id");
					args.setValString("VALUE1", ics.GetVar("ourAssetid"));
					
					ics.runTag("ASSET.LIST", args);				
					
					IList theList = ics.GetList("clAsset"); 
					if (theList != null && theList.numRows() > 0)
					{
						theList.moveTo(0);
						ics.StreamText(", name: '" + StringEscapeUtils.escapeJavaScript(theList.getValue("name")) + "'");
					}
					
					ics.StreamText(" }");	// close one "asset"
					ics.StreamText("\r\n");
				}
				
				ics.StreamText(" ]"); 	// close "assets" array"
				ics.StreamText("\r\n");
			}
			
			// History Attributes (Contraints)
			
			String strNumConstr = nvCell.getValue("HNUMCONSTR");

			// create an array of associated assets
			
			ics.StreamText("\r\n, constraints: [ ");	

			if (strNumConstr != null)
			{
				int numConstraints = Integer.parseInt(strNumConstr);
				
				for (int index = 0; index < numConstraints; index++)
				{
					if (index != 0)
						ics.StreamText(", ");
					
					ics.StreamText("{ ");	
					
					String name = "HCONSTRFIELD" + Integer.toString(index);
					ics.StreamText("name: '" + StringEscapeUtils.escapeJavaScript(nvCell.getValue(name)) + "'");

					name = "HCONSTRTYPE" + Integer.toString(index);
					String strType = nvCell.getValue(name);
					ics.StreamText(", type: '" + StringEscapeUtils.escapeJavaScript(strType) + "'");
					
					name = "HCONSTRASSETTYPE" + Integer.toString(index);
					String strAssetType = nvCell.getValue(name);
					
					if (strAssetType == null)
						strAssetType = "";
					
					ics.StreamText(", assettype: '" + StringEscapeUtils.escapeJavaScript(strAssetType) + "'");

					name = "HCONSTRATTRKEY" + Integer.toString(index);
					String strAttrKey = nvCell.getValue(name);
					String strAssetAttribute = "";
					if (strAttrKey != null && !strAttrKey.isEmpty())
					{
						String [] s = strAttrKey.split(":");
						
						if (s.length == 2)
							strAssetAttribute = s[1];
					}
					
					ics.StreamText(", assetattribute: '" + StringEscapeUtils.escapeJavaScript(strAssetAttribute) + "'");
					
					name = "HNUMCONSTRVALUE" + Integer.toString(index);
					String strNumValues = nvCell.getValue(name);
					int numValues = Integer.parseInt(strNumValues);
					
					ics.StreamText(", values: [");
					
					for (int val = 0; val < numValues; val++)
					{
						if (val != 0)
							ics.StreamText(", ");
						
						ics.StreamText("{");
						
						if ("value".equals(strType))
						{
							name = "HCONSTRVALUE"+ Integer.toString(index) + "-" + Integer.toString(val); 
							ics.StreamText("value: '" + StringEscapeUtils.escapeJavaScript(nvCell.getValue(name)) + "'");	
	
							name = "HCONSTRVALTZ"+ Integer.toString(index) + "-" + Integer.toString(val); 
							ics.StreamText(", valtz: '" + StringEscapeUtils.escapeJavaScript(nvCell.getValue(name)) + "'");	
						}
						else
						if ("assetattr".equals(strType))
						{
							name = "HCONSTRATYPE"+ Integer.toString(index) + "-" + Integer.toString(val); 
							String assetType = nvCell.getValue(name);
							
							if (assetType != null && !assetType.isEmpty())
							{
								name = "HCONSTRVALUE"+ Integer.toString(index) + "-" + Integer.toString(val); 
								ics.StreamText("id: '" + StringEscapeUtils.escapeJavaScript(nvCell.getValue(name)) + "'");
								ics.StreamText(", type: '" + StringEscapeUtils.escapeJavaScript(assetType) + "'");
							}
							else
							{
								name = "HCONSTRKEY"+ Integer.toString(index) + "-" + Integer.toString(val); 
								String key = nvCell.getValue(name);
									
								FTValList args = new FTValList();
							    args.removeAll();
							    args.setValString("ourKey", key);
						      	ics.CallElement("OpenMarket/Gator/Rules/RuleSetMapKeyLookup", args);					
								
								ics.StreamText("id: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ourAssetid")) + "'");
								ics.StreamText(", type: '" + StringEscapeUtils.escapeJavaScript(ics.GetVar("ourAssettype")) + "'");
								
								args.removeAll();
								
								args.setValString("LIST", "clAsset");
								args.setValString("TYPE", ics.GetVar("ourAssettype"));
								args.setValString("FIELD1", "id");
								args.setValString("VALUE1", ics.GetVar("ourAssetid"));
								
								ics.runTag("ASSET.LIST", args);				
								
								IList theList = ics.GetList("clAsset"); 
								if (theList != null && theList.numRows() > 0)
								{
									theList.moveTo(0);
									ics.StreamText(", name: '" + StringEscapeUtils.escapeJavaScript(theList.getValue("name")) + "'");
								}
							}
						}
						
						ics.StreamText("}");
					}

					ics.StreamText("]"); 	// close "values" array"
					
					ics.StreamText(" }");	// close one "constraint"
					ics.StreamText("\r\n");
				}
			}
			
			ics.StreamText(" ]"); 	// close "constraints" array"
			ics.StreamText("\r\n");
			
			ics.StreamText("}");	// close "cell"
			ics.StreamText("\r\n");
		}
		ics.StreamText("] }");		// close "cols" array
		ics.StreamText("\r\n");
	}

	ics.StreamText("]");			// close "rows" array
	
	// pick up leaf properties of the top level "nvRuleSet" object
	
	nvItem = nv.getFirst();

	while (nvItem != null)
	{
		String name = nvItem.getValueName();
		
		if (name != null && !name.equals("NUMAND")&& !name.startsWith("ANDCLAUSE"))
		{
			ics.StreamText(",\r\n");
			
			String value = nvItem.getValue();
			ics.StreamText(name + ": '" + value + "'");
		}
		
		nvItem = nvItem.getNext();
	}

	ics.StreamText("\r\n}");			// close outer level "nvRuleSet" object
	ics.StreamText("</script>\r\n");
}
%>

</cs:ftcs>