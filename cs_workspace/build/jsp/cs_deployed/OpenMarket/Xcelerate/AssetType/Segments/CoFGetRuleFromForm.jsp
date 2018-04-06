<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<%@ page import="com.openmarket.gator.nvobject.*"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>

<cs:ftcs>
<%
	// this is NOT pure code... originally coded as an xml template...
	
	
	String strCriteriaOperation = ics.GetVar("CriteriaOperation");
	
	if ("SegmentSave".equals(ics.GetVar("SegmentsRuleScreen")) || "SegmentSave".equals(ics.GetVar("RebuildScreen"))) 
	{
		NVObject nv = (NVObject) ics.GetObj("nvRuleSet");
		String	thisRuleString = null;
		
		NVObject nvCell = new NVObject();
		ics.SetObj("nvSegRule", nvCell);	// retrieved by name in called elements... very important!!
		
		if ("CoFDemographics".equals(ics.GetVar("FromPage")) )
		{
			nvCell.setValue("RULETYPE", ics.GetVar("sRuleType"));
			nvCell.setValue("RULEOP", ics.GetVar("sRuleOp"));
			nvCell.setValue("VARNAME", ics.GetVar("sVarAttid"));
			
			if (ics.GetVar("sVarAssetid") != null)
				nvCell.setValue("VARASSETID", ics.GetVar("sVarAssetid"));
				
			nvCell.setValue("VARDESC", ics.GetVar("sVarName"));
			nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp"));
			nvCell.setValue("VALUE", ics.GetVar("sValue1"));
			nvCell.setValue("RULECATEGORY", ics.GetVar("SegmentsFromRuleScreen"));
						
			if (ics.GetVar("sValue2") != null)
				nvCell.setValue("HIGHVALUE", ics.GetVar("sValue2"));
			
			if ("timestamptype".equals(ics.GetVar("sValue1")))
			{
				int nMonth = Integer.parseInt(ics.GetVar("00StartMonth")) - 1;
				int nHour = Integer.parseInt(ics.GetVar("00StartHour"));
				
				if (nHour == 12)
					nHour = 0;
				
				FTValList args = new FTValList();
				args.setValString("VARNAME", "theStart");
				args.setValString("YEAR", ics.GetVar("00StartYear"));
				args.setValString("MONTH", Integer.toString(nMonth));
				args.setValString("DAY", ics.GetVar("00StartDay"));
				args.setValString("HOUR", Integer.toString(nHour));
				args.setValString("MINUTE", ics.GetVar("00StartMin"));
				args.setValString("AMPM", ics.GetVar("0-0StartamOrpm"));
				args.setValString("TIMEZONE", ics.GetVar("0-0StartTimeZone"));
				ics.runTag("DATE.CONVERT", args);				

				nvCell.setValue("VALUE", ics.GetVar("theStart"));
				nvCell.setValue("VALTZ", ics.GetVar("0-0StartTimeZone"));

				if ("bt".equals(ics.GetVar("sCompareOp")))
				{
					int nEndMonth = Integer.parseInt(ics.GetVar("00doEndMonth")) - 1;
					int nEndHour = Integer.parseInt(ics.GetVar("00doEndHour"));
					
					if (nEndHour == 12)
						nEndHour = 0;
					
					FTValList endargs = new FTValList();
					endargs.setValString("VARNAME", "theEnd");
					endargs.setValString("YEAR", ics.GetVar("00doEndYear"));
					endargs.setValString("MONTH", Integer.toString(nEndMonth));
					endargs.setValString("DAY", ics.GetVar("00doEndDay"));
					endargs.setValString("HOUR", Integer.toString(nEndHour));
					endargs.setValString("MINUTE", ics.GetVar("00doEndMin"));
					endargs.setValString("AMPM", ics.GetVar("0-0doEndamOrpm"));
					endargs.setValString("TIMEZONE", ics.GetVar("0-0doEndTimeZone"));
					ics.runTag("DATE.CONVERT", endargs);				

					nvCell.setValue("HIGHVALUE", ics.GetVar("theEnd"));
					nvCell.setValue("HIGHVALTZ", ics.GetVar("0-0doEndTimeZone"));
				}
				else
				{
					nvCell.setValue("HIGHVALUE", "0");
					nvCell.setValue("HIGHVALTZ", "0");
				}
			}
		}
		else
		if ("CoFHistory".equals(ics.GetVar("FromPage")))
		{
			nvCell.setValue("RULETYPE", ics.GetVar("sRuleType"));
			nvCell.setValue("VARNAME", ics.GetVar("sVarAttid"));

			if (ics.GetVar("sVarAssetid") != null)
				nvCell.setValue("VARASSETID", ics.GetVar("sVarAssetid"));

			nvCell.setValue("VARDESC", ics.GetVar("sVarName"));
			nvCell.setValue("RULECATEGORY", ics.GetVar("SegmentsFromRuleScreen"));

			// Handle time
			nvCell.setValue("HDATEOP", ics.GetVar("durationType"));

			if ("relative".equals(ics.GetVar("durationType")))
			{
				nvCell.setValue("HRELTYPE", ics.GetVar("sRelativeOp"));
				nvCell.setValue("HINTERVAL", ics.GetVar("sHinterval"));
			}
			else
			if ("fixed".equals(ics.GetVar("durationType")))
			{
				int nMonth = Integer.parseInt(ics.GetVar("StartMonth")) - 1;
				int nHour = Integer.parseInt(ics.GetVar("StartHour"));
				
				if (nHour == 12)
					nHour = 0;
				
				FTValList args = new FTValList();
				args.setValString("VARNAME", "StartDate");
				args.setValString("YEAR", ics.GetVar("StartYear"));
				args.setValString("MONTH", Integer.toString(nMonth));
				args.setValString("DAY", ics.GetVar("StartDay"));
				args.setValString("HOUR", Integer.toString(nHour));
				args.setValString("MINUTE", ics.GetVar("StartMin"));
				args.setValString("AMPM", ics.GetVar("StartamOrpm"));
				args.setValString("TIMEZONE", ics.GetVar("StartTimeZone"));
				ics.runTag("DATE.CONVERT", args);				

				nvCell.setValue("HSTARTDATE", ics.GetVar("StartDate"));
				nvCell.setValue("HSTARTTZ", ics.GetVar("StartTimeZone"));

				int nEndMonth = Integer.parseInt(ics.GetVar("EndMonth")) - 1;
				int nEndHour = Integer.parseInt(ics.GetVar("EndHour"));
				
				if (nEndHour == 12)
					nEndHour = 0;
				
				FTValList endargs = new FTValList();
				endargs.setValString("VARNAME", "EndDate");
				endargs.setValString("YEAR", ics.GetVar("EndYear"));
				endargs.setValString("MONTH", Integer.toString(nEndMonth));
				endargs.setValString("DAY", ics.GetVar("EndDay"));
				endargs.setValString("HOUR", Integer.toString(nEndHour));
				endargs.setValString("MINUTE", ics.GetVar("EndMin"));
				endargs.setValString("AMPM", ics.GetVar("EndamOrpm"));
				endargs.setValString("TIMEZONE", ics.GetVar("EndTimeZone"));
				ics.runTag("DATE.CONVERT", endargs);				

				nvCell.setValue("HENDDATE", ics.GetVar("EndDate"));
				nvCell.setValue("HENDTZ", ics.GetVar("EndTimeZone"));
			}
			else
			{
				nvCell.setValue("HSTARTDATE", "0");
			}
			
			// Basic options
			
			if ("UseTotal".equals(ics.GetVar("SummableType")))
			{
				nvCell.setValue("HOP", "sum");
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp1"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp1"));
				
				if (ics.GetVar("sValue") != null)
					nvCell.setValue("VALUE", ics.GetVar("sValue"));

				if (ics.GetVar("sHField") != null)
					nvCell.setValue("HFIELD", ics.GetVar("sHField"));
			}
			else
			if ("UseCount".equals(ics.GetVar("SummableType")))
			{
				nvCell.setValue("HOP", "count");
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp2"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp2"));
				
				if (ics.GetVar("sValue1") != null)
					nvCell.setValue("VALUE", ics.GetVar("sValue1"));
			}
			else
			if ("UseEarliest".equals(ics.GetVar("SummableType")))
			{
				nvCell.setValue("HOP", "first");
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp3"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp3"));
				
				int nMonth = Integer.parseInt(ics.GetVar("sEarliestMonth")) - 1;
				int nHour = Integer.parseInt(ics.GetVar("EarliestHour"));
				
				if (nHour == 12)
					nHour = 0;
				
				FTValList args = new FTValList();
				args.setValString("VARNAME", "EarliestDate");
				args.setValString("YEAR", ics.GetVar("EarliestYear"));
				args.setValString("MONTH", Integer.toString(nMonth));
				args.setValString("DAY", ics.GetVar("EarliestDay"));
				args.setValString("HOUR", Integer.toString(nHour));
				args.setValString("MINUTE", ics.GetVar("EarliestMin"));
				args.setValString("AMPM", ics.GetVar("EarliestamOrpm"));
				args.setValString("TIMEZONE", ics.GetVar("EarliestTimeZone"));
				ics.runTag("DATE.CONVERT", args);				

				nvCell.setValue("VALUE", ics.GetVar("EarliestDate"));
				nvCell.setValue("VALUETZ", ics.GetVar("EarliestTimeZone"));
			}
			else
			if ("UseLatest".equals(ics.GetVar("SummableType")))
			{
				nvCell.setValue("HOP", "last");
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp4"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp4"));
				
				int nMonth = Integer.parseInt(ics.GetVar("sLatestMonth")) - 1;
				int nHour = Integer.parseInt(ics.GetVar("LatestHour"));
				
				if (nHour == 12)
					nHour = 0;
				
				FTValList args = new FTValList();
				args.setValString("VARNAME", "LatestDate");
				args.setValString("YEAR", ics.GetVar("LatestYear"));
				args.setValString("MONTH", Integer.toString(nMonth));
				args.setValString("DAY", ics.GetVar("LatestDay"));
				args.setValString("HOUR", Integer.toString(nHour));
				args.setValString("MINUTE", ics.GetVar("LatestMin"));
				args.setValString("AMPM", ics.GetVar("LatestOrpm"));
				args.setValString("TIMEZONE", ics.GetVar("LatestTimeZone"));
				ics.runTag("DATE.CONVERT", args);				

				nvCell.setValue("VALUE", ics.GetVar("LatestDate"));
				nvCell.setValue("VALUETZ", ics.GetVar("LatestTimeZone"));
			}

			// Constraint Management  (depends on availabilty - by name - of "nvSegRule" object)
			ics.CallElement("OpenMarket/Xcelerate/AssetType/Segments/GetHistoryConstraints", null);
		}
		else
		if ("CoFCart".equals(ics.GetVar("FromPage")))
		{
			nvCell.setValue("RULECATEGORY", ics.GetVar("SegmentsFromRuleScreen"));

			nvCell.setValue("RULETYPE", ics.GetVar("sRuleType"));
			nvCell.setValue("ASSETOP", ics.GetVar("scAssetOp"));
			nvCell.setValue("CARTMODE", ics.GetVar("CartMode"));

			if ("value".equals(ics.GetVar("scAssetOp")))
			{
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp1"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp1"));
				nvCell.setValue("VALUE", ics.GetVar("sValue1"));
				nvCell.setValue("VALTZ", "0");
				
				if (ics.GetVar("sValue2") != null)
				{
					nvCell.setValue("HIGHVALUE", ics.GetVar("sValue2"));
					nvCell.setValue("HIGHVALTZ", "0");
				}
			}
			else
			if ("count".equals(ics.GetVar("scAssetOp")))
			{
				nvCell.setValue("RULEOP", ics.GetVar("sRuleOp2"));
				nvCell.setValue("COMPAREOP", ics.GetVar("sCompareOp2"));
				nvCell.setValue("VALUE", ics.GetVar("sValue3"));
				nvCell.setValue("VALTZ", "0");
				
				if (ics.GetVar("sValue4") != null)
				{
					nvCell.setValue("HIGHVALUE", ics.GetVar("sValue4"));
					nvCell.setValue("HIGHVALTZ", "0");
				}
			}
			
			if ("all".equals(ics.GetVar("CartMode")))
			{
				nvCell.setValue("NUMASSETS", "0");
			}
			else
			{
				String thisRC = ics.GetVar("CriteriaRow") + "_" + ics.GetVar("CriteriaColumn");

				if (ics.GetVar("CartlistClauses") != null)
				{
					String CartlistClauses = ics.GetVar("CartlistClauses");
					
					if (CartlistClauses.indexOf(thisRC) == -1)
					{
						CartlistClauses = CartlistClauses + "," + thisRC;
						ics.SetVar("CartlistClauses", CartlistClauses);
					}
					
					ics.StreamText("<input type='hidden' name='CartlistClauses' value='" + CartlistClauses + "' />");
				}
				else
				{
					ics.SetVar("CartlistClauses", thisRC);
					ics.StreamText("<input type='hidden' name='CartlistClauses' value='" + thisRC + "' />");
				}
				
				if ("true".equals(ics.GetVar("haveCartlist")))
				{
					IList theList = ics.GetList("Segments:Cartlists"); 
					int nItems = theList.numRows();
					nvCell.setValue("NUMASSETS", Integer.toString(nItems));
					
					ics.SetVar("segment:ruleset_map:Total", "2");
					ics.StreamText("<input type='hidden' name='" + thisRC + "_NumCart' value='" + Integer.toString(nItems) + "' />");

					for (int i=0; i < nItems; i++)
					{
						theList.moveTo(i+1);
						
						// check and remove old rulemap stuff
						
						String ourAssetId = nvCell.getValue("ASSETID"+i);
						String ourAssetType = nvCell.getValue("ASSETTYPE"+i);

						if (ourAssetId != null)
						{							
							nvCell.setValue("ASSETID"+i, null);
							nvCell.setValue("ASSETTYPE"+i, null);
						}
						else
						{
							ourAssetId = theList.getValue("assetid");
							ourAssetType = theList.getValue("assettype");
						}

						String ourKey = thisRC + "_ASSETKEY" + i;
						String ourValue = ourAssetType + ":" + ourAssetId;
						
						// <RULESETMAP.SET NAME="theMap" KEY="Variables.ourKey" TYPE="asset" VALUE="Variables.ourValue"/>

						FTValList args = new FTValList();
						args.setValString("NAME", "theMap");
						args.setValString("KEY", ourKey);
						args.setValString("TYPE", "asset");
						args.setValString("VALUE", ourValue);
						ics.runTag("RULESETMAP.SET", args);				
						
						nvCell.setValue("ASSETKEY"+i, ourKey);						
						
						ics.StreamText("<input type='hidden' name='" + thisRC + "_" + i + "CartListAssetid' value='" + ourAssetId + "' />");
						ics.StreamText("<input type='hidden' name='" + thisRC + "_" + i + "CartListAssettype' value='" + ourAssetType + "' />");
					}
				}
				else
				{
					String strItems = ics.GetVar("NumCartlistItems");
					int nItems = Integer.parseInt(strItems);
					
					nvCell.setValue("NUMASSETS", strItems);
					
					if (nItems != 0)
					{
						ics.StreamText("<input type='hidden' name='" + thisRC + "_NumCart' value='" + strItems + "' />");
						
						for (int i=0;  i < nItems; i++)
						{
							String idName = thisRC + "_" + i + "CartListAssetid";
							String idValue = ics.GetVar(idName);
							ics.StreamText("<input type='hidden' name='" + idName + "' value='" + idValue + "' />");

							String typeName = thisRC + "_" + i + "CartListAssettype";
							String typeValue = ics.GetVar(typeName);
							ics.StreamText("<input type='hidden' name='" + typeName + "' value='" + typeValue + "' />");
							
							String mapKey = thisRC + "_ASSETKEY" + i;
							String mapValue = typeValue + ":" + idValue;
							
							// <RULESETMAP.SET NAME="theMap" KEY="Variables.ourKey" TYPE="asset" VALUE="Variables.ourValue"/>

							FTValList args = new FTValList();
							args.setValString("NAME", "theMap");
							args.setValString("KEY", mapKey);
							args.setValString("TYPE", "asset");
							args.setValString("VALUE", mapValue);
							ics.runTag("RULESETMAP.SET", args);				
							
							nvCell.setValue("ASSETKEY"+i, mapKey);
						}
					}				
				}
			}
		}
		
		thisRuleString = nvCell.getAsString();		
		
		// we have gathered data for the "cell" we are working on
		
		if ("AddRow".equals(ics.GetVar("CriteriaOperation")) || "AddColumn".equals(ics.GetVar("CriteriaOperation")))
		{
			int nRows = Integer.parseInt(nv.getValue("NUMAND"));
			int row = Integer.parseInt(ics.GetVar("CriteriaRow"));

			// find out if we are referencing an existing cell - and if so, convert to an "EditItem"
			if (row < nRows)
			{
				NVObject nvRow = new NVObject();
				
				String thisRowString = nv.getValue("ANDCLAUSE" + row);
				nvRow.setFromString(thisRowString);
				
				int nCols = Integer.parseInt(nvRow.getValue("NUMCOL"));
				int col= Integer.parseInt(ics.GetVar("CriteriaColumn"));
				 
				if (col < nCols)
					ics.SetVar("CriteriaOperation", "EditItem");
			}
		}
	
		if ("AddRow".equals(ics.GetVar("CriteriaOperation")))
		{
			int nRows = Integer.parseInt(nv.getValue("NUMAND"));
			int row = Integer.parseInt(ics.GetVar("CriteriaRow"));
			
			NVObject nvRow = new NVObject();
			nvRow.setValue("ORCLAUSE0", thisRuleString);
			nvRow.setValue("NUMCOL", "1");

			String thisRowString = nvRow.getAsString();
			nv.setValue("ANDCLAUSE" + Integer.toString(row), thisRowString);
			nv.setValue("NUMAND", Integer.toString(nRows+1));
			
			ics.SetVar("SegRuleSetHint", nv.getAsString());
		}
		else
		if ("AddColumn".equals(ics.GetVar("CriteriaOperation")))
		{
			String thisRowString = nv.getValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"));
			NVObject nvRow = new NVObject();
			nvRow.setFromString(thisRowString);
	
			int nCols = Integer.parseInt(nvRow.getValue("NUMCOL"));
			nvRow.setValue("ORCLAUSE" + nCols, thisRuleString);
			
			nvRow.setValue("NUMCOL", Integer.toString(nCols+1));
			
			thisRowString = nvRow.getAsString();
			
			nv.setValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"), thisRowString);
			
			ics.SetVar("SegRuleSetHint", nv.getAsString());
		}
		else
		if ("EditItem".equals(ics.GetVar("CriteriaOperation")))
		{
			String thisRowString = nv.getValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"));
			NVObject nvRow = new NVObject();
			nvRow.setFromString(thisRowString);

			nvRow.setValue("ORCLAUSE" + ics.GetVar("CriteriaColumn"), thisRuleString);
			thisRowString = nvRow.getAsString();
			
			nv.setValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"), thisRowString);
			
			ics.SetVar("SegRuleSetHint", nv.getAsString());
		}
		else
		if ("DeleteItem".equals(ics.GetVar("CriteriaOperation")))
		{
			String thisRowString = nv.getValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"));
			NVObject nvRow = new NVObject();
			nvRow.setFromString(thisRowString);

			int nCols = Integer.parseInt(nvRow.getValue("NUMCOL"));
			
			if (nCols > 1)	// if cols is greater than one, we need to renumber the columns
			{
				int col= Integer.parseInt(ics.GetVar("CriteriaColumn"));

				while (col < nCols-1)
				{
					String strItem = nvRow.getValue("ORCLAUSE" + Integer.toString(col+1));
					nvRow.setValue("ORCLAUSE" + col, strItem);
					
					col++;
				}
				
				nvRow.setValue("ORCLAUSE" + col, null);
				nvRow.setValue("NUMCOL", Integer.toString(nCols-1));
				nv.setValue("ANDCLAUSE" + ics.GetVar("CriteriaRow"), nvRow.getAsString());
				ics.SetVar("SegRuleSetHint", nv.getAsString());
			}
			else			// otherwise. we are deleting a row and need to renumber the rows.
			{
				int nRows = Integer.parseInt(nv.getValue("NUMAND"));
				int row = Integer.parseInt(ics.GetVar("CriteriaRow"));

				while (row < nRows-1)
				{
					String strItem = nv.getValue("ANDCLAUSE" + Integer.toString(row+1));
					nv.setValue("ANDCLAUSE" + row, strItem);
					
					row++;
				}
				
				nv.setValue("ANDCLAUSE" + row, null);
				nv.setValue("NUMAND", Integer.toString(nRows-1));
				ics.SetVar("SegRuleSetHint", nv.getAsString());
			}
		}
	}
%>

</cs:ftcs>