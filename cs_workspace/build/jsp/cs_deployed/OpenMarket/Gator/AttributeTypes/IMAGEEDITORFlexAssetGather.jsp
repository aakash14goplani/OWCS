<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList,
				 COM.FutureTense.Interfaces.IList,
				 java.util.HashSet,
				 java.util.StringTokenizer,
				 java.util.Collection,
                 com.openmarket.basic.interfaces.IListBasic,
				 java.util.Iterator,
				 com.openmarket.xcelerate.util.ConverterUtils" %>
<%
//
// OpenMarket/Gator/AttributeTypes/IMAGEEDITORFlexAssetGather
//
// INPUT
//
// OUTPUT
//
%>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="flexasset" uri="futuretense_cs/flexasset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ page import="com.openmarket.basic.util.Base64"
%><%!

private static boolean isID(String id) {
	if (null == id) return false;
	// The id length should not be more than 19 chars
	if (id.length() > 19) return false;
	// All the characters should be numbers.
	for (int i = 0; i < id.length(); i++) {
		if (!Character.isDigit(id.charAt(i))) return false;
	}
	return true;
}

%><cs:ftcs><%
// retrieve current input name
String inputName = ics.GetVar("cs_CurrentInputName");

if (null != ics.GetVar(inputName))
	ics.SetVar(inputName+"_hasData","true");//this variable will be checked in assetgather

String vName = ics.GetVar("vectorName");
FTValList vN = new FTValList();
ics.SetVar(ics.GetVar("currAttrID") + "_isValueId", "true");
int numValues = 0;
if (ics.GetVar("_DEL_" + inputName) == null) {
	
	if (ics.GetObj(vName) != null)
	{
		if (null != ics.GetVar("loopNumber") && "0".equals(ics.GetVar("loopNumber").trim())) {
			vN = new FTValList();
			vN.setValString("NAME", vName);
			ics.runTag("vector.create", vN);
			numValues = 0;
		}
	}
	else
	{
		vN = new FTValList();
		vN.setValString("NAME", vName);
		ics.runTag("vector.create", vN);
		numValues = 0;
	}
	if (ics.GetVar(inputName)!=null) {
	
		ics.SetVar("tempid", ics.GetVar(inputName));
		vN = new FTValList();
		vN.setValString("NAME", vName);
		vN.setValString("VARNAME", "currentLength");
		ics.runTag("vector.length", vN);
		
		int curr = Integer.valueOf(ics.GetVar("currentLength"));
		String filename = ics.GetVar(inputName + "_file");
		
		vN = new FTValList();
		vN.setValString("NAME", vName);
		vN.setValString("INDEX", String.valueOf(curr));
		vN.setValString("VALUE", ics.GetVar("tempid"));
		ics.runTag("vector.add", vN); 	
	}
	
} else {

	if (ics.GetObj(vName) != null)
	{
		if (null != ics.GetVar("loopNumber") && "0".equals(ics.GetVar("loopNumber").trim())) {
			vN = new FTValList();
			vN.setValString("NAME", vName);
			ics.runTag("vector.create", vN);
			numValues = 0;
		}
	}

	if (ics.GetVar(inputName)!=null) {
		vN = new FTValList();
		vN.setValString("ID", ics.GetVar(inputName));
		ics.runTag("tempobjects.delete", vN);
	}
}	

if ("S".equals(ics.GetVar("EditingStyle"))) {
	vN = new FTValList();
	vN.setValString("NAME", vName);
	vN.setValString("VARNAME", "currentLength");
	ics.runTag("vector.length", vN);
			
	int singleLength = Integer.valueOf(ics.GetVar("currentLength"));
	if (singleLength > 0)
	{
		vN = new FTValList();
		vN.setValString("NAME", vName);
		vN.setValString("VARNAME", "currtempids");
		vN.setValString("DELIM", ",");
		ics.runTag("vector.tostring", vN);

		java.util.StringTokenizer tempidTokens = new java.util.StringTokenizer(ics.GetVar("currtempids"), ",");
%>
		<listobject:create name='temp' columns='id'/>
<%
		while (tempidTokens.hasMoreTokens())
		{
%>
			<listobject:addrow name='temp'>
				<listobject:argument name='id' value='<%=tempidTokens.nextToken()%>'/>
			</listobject:addrow>
<%
		}
%>
		<listobject:tolist name='temp' listvarname='tempids'/>
<%
		vN = new FTValList();
		vN.setValString("LISTVARNAME", "valList");
		vN.setValString("COLUMN", "urlvalue");
		vN.setValString("LIST", "tempids");
		ics.runTag("tempobjects.getlist", vN);
%>
		<ics:callelement element='OpenMarket/Gator/Util/FixBLOBList'>
			<ics:argument name='cs_ListToReplace' value='valList'/>
		</ics:callelement>

		<flexasset:setattribute name='<%= ics.GetVar("loadedAsset") %>' id='<%= ics.GetVar("currAttrID") %>' list='valList'/> 
<%
		
%>
		<hash:create name='hRaj1MyAttrVal' list='valList' column='urlvalue' />
		<hash:tostring name='hRaj1MyAttrVal' varname='Raj1AttrVal' delim=',' />
<%
			
	}
	else
	{
		
%>
		<flexasset:setattribute name='<%= ics.GetVar("loadedAsset") %>' id='<%= ics.GetVar("currAttrID") %>'/>
<%
	}
}

%></cs:ftcs>
