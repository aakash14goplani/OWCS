<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/ProcessValues
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
<%@ page import="javax.servlet.jsp.JspWriter"%>
<%@ page import="com.openmarket.basic.interfaces.ListObjectFactory"%>
<%@ page import="com.openmarket.basic.interfaces.IListObject"%>
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects"%>
<%@ page import="com.openmarket.xcelerate.common.TempObjects"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>

<%!

private static final Log PROCESSVALUESLOG = LogFactory.getLog(ftMessage.GENERIC_DEBUG);

private void processValue(ICS ics, JspWriter out, IList attrValueList, String attrSingleInputName, String attrType, int index) {
	String processedValue = "";
	ics.SetVar("isEncodeValue", "false");
	
	preProcessingValue(ics, out, attrValueList, attrSingleInputName, attrType, index);
	
	processedValue = executeProcessElement(ics, attrValueList, attrType);
	
	try {
		setMyAttrValue(ics, 
					   null != processedValue ? processedValue : attrValueList.getValue("value"), 
					   "true".equalsIgnoreCase(ics.GetVar("isEncodeValue")));
	} catch (Exception e) {
		ics.SetVar("MyAttrVal", "");
		PROCESSVALUESLOG.error(ics.GetVar("AttrName") + " || " + "processValue error");
	}
	
	clearTemporaryVars(ics);
}


private void preProcessingValue(ICS ics, JspWriter out, IList attrValueList, String attrSingleInputName, String attrType, int index) {
	String fileName = "";
	if ("url".equalsIgnoreCase(attrType)) {
		fileName = processUrlValue(ics, attrValueList);
		
		// TODO: Can do a better fix in UPLOADER
		if (!"UPLOADER".equalsIgnoreCase(ics.GetVar("MyAttributeType"))) {
			createInputNode(out, attrSingleInputName + "_" + index + "_file", fileName);	
		}
		if ("TEXTAREA".equalsIgnoreCase(ics.GetVar("MyAttributeType"))) {
			ics.SetVar("isEncodeValue", "true");	
		}
	} else if ("date".equalsIgnoreCase(attrType)) {
		processDateValue(ics, attrValueList);
	} else {
		ics.SetVar("isEncodeValue", "true");
	}
}


private String executeProcessElement(ICS ics, IList attrValueList, String attrType) {
	String processCallElementName = "OpenMarket/Gator/AttributeTypes/Process" + ics.GetVar("MyAttributeType") + "Value";
	FTValList arguments = new FTValList();
	
	if (ics.IsElement(processCallElementName)) {
		try {
			if ("url".equalsIgnoreCase(attrType)) {
				arguments.setValString("currentUrlValue", attrValueList.getValue("urlvalue"));
				arguments.setValString("currentFolder", attrValueList.getValue("folder"));
				arguments.setValBLOB("currentUrlFileValue", attrValueList.getFileData("urlvalue"));
			} else {
				arguments.setValString("currentValue", attrValueList.getValue("value"));
			}
		} catch (Exception e) {
			PROCESSVALUESLOG.error("processValue error 1");
		}
		
		ics.CallElement(processCallElementName, arguments);
	}
	
	return ics.GetVar("processedValue");
}


private void clearTemporaryVars(ICS ics) {
	ics.RemoveVar("currentValue");
	ics.RemoveVar("currentUrlValue");
	ics.RemoveVar("currentFolder");
	ics.RemoveVar("currentUrlFileValue");
	ics.RemoveVar("processedValue");
	ics.RemoveVar("isEncodeValue");
}


private String processUrlValue(ICS ics, IList attrValueList) {
	String fileName = "";
	try {
		fileName = attrValueList.getValue("urlvalue");
	} catch (Exception e) {
		fileName = ics.ResolveVariables("CS.UniqueID", false) + ".txt";
		PROCESSVALUESLOG.error(ics.GetVar("AttrName") + " || " + "processUrlValue error");
	}
		
	if (!Utilities.goodString(fileName))
		fileName = ics.ResolveVariables("CS.UniqueID", false) + ".txt";
	
	try {
		ics.SetVar("processedValue", attrValueList.getFileString("urlvalue"));
	} catch (Exception e) {
		ics.SetVar("MyAttrVal", "");
		PROCESSVALUESLOG.error(ics.GetVar("AttrName") + " || " + " processUrlValue error");
	}

	return fileName;
}


private void processDateValue(ICS ics, IList attrValueList) {
	boolean isAttrValueListCurrent = attrValueList != null && attrValueList.hasData();
	
	if (isAttrValueListCurrent) 
		ics.CallElement("OpenMarket/Gator/FlexibleAssets/Common/DeriveDayMonYeartime", null);
	else 
		ics.CallElement("OpenMarket/Gator/FlexibleAssets/Common/GetDateValue", null);
}


private void createInputNode(JspWriter out, String inputName, String inputValue) {
	String strInputNode = "<INPUT TYPE='HIDDEN' NAME='" + inputName + "' VALUE='" + inputValue + "'/>";
	
	try {
		out.println(strInputNode);	
	} catch (Exception e) {
		PROCESSVALUESLOG.error(inputName + " || createInputNode error");
	}
}


private String encodeValue(String value) {
	return value.replace(",", "&#Comma#&")
	   		  	.replace("'", "&#sQuote#&")
	   		  	.replace("\"", "&#dQuote#&");
}


private void setMyAttrValue(ICS ics, String value, boolean isEncode) {
	try {
		ics.SetVar("MyAttrVal", isEncode ? encodeValue(value) : value);	
	} catch (Exception e) {
		ics.SetVar("MyAttrVal", "");
		PROCESSVALUESLOG.error("setMyAttrValue error");
	}
}

%><cs:ftcs>

<%
	StringBuilder strAttrValues = new StringBuilder("");
	IList attrValueList = ics.GetList("AttrValueList");
	String attrSingleInputName = ics.GetVar("cs_SingleInputName");
	String attrType = ics.GetVar("AttrType");
	String currentAttrNameOrDesc = ics.GetVar("currentAttrNameorDesc");
	String requireValue = "true".equalsIgnoreCase(ics.GetVar("RequiredAttr")) ? "True" : "False";
	int numOfAttrValues = attrValueList.numRows();
	
	StringBuilder reqInfo = new StringBuilder("");
	
	if (0 == numOfAttrValues) {
		reqInfo.append("*").append(attrSingleInputName).append("_").append(1)
	  	   	   .append("*").append(currentAttrNameOrDesc)
	  	   	   .append("*Req").append(requireValue)
	  	   	   .append("*").append(attrType)
	  	   	   .append("!");
	}
	
	ics.SetCounter("MultiValCounter", 1);
 	for (int i = 0; i < numOfAttrValues; i++) {
		processValue(ics, out, attrValueList, attrSingleInputName, attrType, i + 1);
		
		strAttrValues.append(ics.GetVar("MyAttrVal")).append(",");
		
		reqInfo.append("*").append(attrSingleInputName).append("_").append(i + 1)
		  	   .append("*").append(currentAttrNameOrDesc)
		  	   .append("*Req").append(requireValue)
		  	   .append("*").append(attrType)
		  	   .append("!");
		
		attrValueList.moveToRow(IList.next, i);
		
		ics.SetCounter("MultiValCounter", ics.GetCounter("MultiValCounter") + 1);
	}
	
	if (strAttrValues.length() > 0) 
		strAttrValues.deleteCharAt(strAttrValues.length() - 1);
	
	ics.SetObj("strAttrValues", strAttrValues);
	ics.SetVar("MultiValReqInfo", reqInfo.toString());
	
	ics.RemoveVar("MyAttrVal");
	ics.RemoveVar("MultiValCounter");
%>

</cs:ftcs>