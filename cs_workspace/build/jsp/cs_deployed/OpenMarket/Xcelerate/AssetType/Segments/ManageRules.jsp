<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<%@ page import="com.openmarket.gator.nvobject.*"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="com.openmarket.visitor.interfaces.RulesetMap" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/Segments/ManageRules
--
-- INPUT
--	SegRuleSetHint
--	SegRuleSetMapHint
--
-- OUTPUT
--     SegmentRuleText
-- 	   rebuilt RuleSetmap attached to the segment
--
-- Calls GenerateSegmentRuleset, based on a rule hint value in SegRuleSetHint.
--
-->

<%
	String ruleSetMapHint = ics.GetVar("SegRuleSetMapHint");

	if (ruleSetMapHint != null && !ruleSetMapHint.isEmpty())		
	{
		FTValList args = new FTValList();
		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("OBJVARNAME", "theMap");
		
		ics.runTag("SEGMENT.GETRATINGRULESETMAP", args);
	
		RulesetMap theMap = (RulesetMap) ics.GetObj("theMap");
		theMap.clearKeys();

		NVObject nvMap = new NVObject();
		nvMap.setFromString(ruleSetMapHint);

		NVItem nvItem = nvMap.getFirst();
		
		while (nvItem != null)
		{
			String key = nvItem.getValueName();
			String value = nvItem.getValue();
			
			theMap.addKey(key, "asset", value);
			
			nvItem = nvItem.getNext();
		}

		ics.SetObj("theMap", theMap);
		
		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("OBJECT", "theMap");
		ics.runTag("SEGMENT.SETRATINGRULESETMAP", args);
		
		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("PREFIX", "Segments");
		args.setValString("FIELDLIST", "ruleset");
		ics.runTag("ASSET.SCATTER", args);
		
	}

	String ruleSetHint = ics.GetVar("SegRuleSetHint");

	ics.SetVar("SegmentRuleText", "");
	
	if (ruleSetHint == null)
		ruleSetHint = "";

	if (!ruleSetHint.isEmpty())
	{
		NVObject test = new NVObject();
		test.setFromString(ruleSetHint);
		String strRows = test.getValue("NUMAND");
		
		if (strRows != null && !strRows.equals("0"))
		{
			// see parked chunk below...

			// String Ourlt="&#60;";
			// String Ourgt="&#62;";

			ruleSetHint = ruleSetHint.replaceAll("xxeqxx", "==");
			ruleSetHint = ruleSetHint.replaceAll("xxnexx", "==");
			ruleSetHint = ruleSetHint.replaceAll("xxgtxx", "&#62;");
			ruleSetHint = ruleSetHint.replaceAll("xxeqxx", "&#62;=");
			ruleSetHint = ruleSetHint.replaceAll("xxltxx", "&#60;");
			ruleSetHint = ruleSetHint.replaceAll("xxlexx", "&#60;=");
			
			// Unpacking quotes is no longer needed, since SegRuleSetHint is now properly escaped before posting

			// Convert to xml
				
			FTValList args = new FTValList();
			args.removeAll();
			args.setValString("hintstring", ruleSetHint);
			args.setValString("segid", ics.GetVar("id"));
			args.setValString("targetxml", "SegmentRuleText");
	
			ics.CallElement("OpenMarket/Gator/Rules/GenerateSegmentRuleset", args);
		}	
	}
	
	// parked chunk =====================================================================================
	/*
			<!-- This chunk of code has probably been unneeded for a long time, since all assets (even newly-created ones) now have an id -->
			<setvar NAME="GotId" VALUE="false"/>
			<if COND="Variables.updatetype=create">
			<then>
				<ASSET.GET NAME="theCurrentAsset" FIELD="id"/>
				<if COND="Variables.errno=0">
				<then>
					<setvar NAME="GotId" VALUE="true"/>
				</then>
				<else>
					<br/><XLAT.STREAM KEY="dvin/FlexibleAssets/FlexAssets/AssetGetFailed" errno="Variables.errno" EVALALL="false"/>
				</else>
				</if>
			</then>
			<else>
				<setvar NAME="GotId" VALUE="true"/>
			</else>
			</if>
						
			<if COND="Variables.GotId=true">
			<then>		
	*/			
%>
</cs:ftcs>
