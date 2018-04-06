<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/PullDownCompareValues
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<cs:ftcs>
<ics:if condition='<%= "float".equalsIgnoreCase(ics.GetVar("AttrType")) || "money".equalsIgnoreCase(ics.GetVar("AttrType")) %>'>
<ics:then>
	<ics:if condition='<%= "no".equalsIgnoreCase(ics.GetVar("MultiValueEntry")) %>'>
	<ics:then>
<%
		IList pullDownValueList = ics.GetList("PulldownValues");
		int numOfAttrValues = pullDownValueList.numRows();
		String savedValue = ics.GetVar("MyAttrVal");
		boolean isEqual = false;
		String currValue = "";
		Float convFloat1 = new Float("0");
		for (int i = 0; i < numOfAttrValues; i++) {
%>
			<string:encode varname="encodedStr" value='<%=pullDownValueList.getValue("value")%>' /> 
<%
			currValue = ics.GetVar("encodedStr");		
			if (Utilities.goodString(currValue)) convFloat1 = Float.valueOf(currValue);
			if (Utilities.goodString(savedValue)) {			
				Float convFloat2 = Float.valueOf(savedValue);
				float flt1 = convFloat1.floatValue();
				float flt2 = convFloat2.floatValue();
				int ix = Float.compare(flt1, flt2);
				if (ix == 0) isEqual = true;
			}
%>		
			<ics:if condition='<%= isEqual %>'>
			<ics:then>
				<option value='<%= convFloat1 %>'  selected="yes">
					<font size='<%= ics.GetVar("size") %>'>
						<string:stream value='<%= pullDownValueList.getValue("value") %>' />
					</font>
				</option>
			</ics:then>
			<ics:else>
				<option value='<%= convFloat1 %>' >
					<font size='<%= ics.GetVar("size") %>'>
						<string:stream value='<%= pullDownValueList.getValue("value") %>'/>
					</font>
				</option>
			</ics:else>
			</ics:if>
<%		
			isEqual = false;
			pullDownValueList.moveToRow(IList.next, i);		
		}
%>
	</ics:then>
	<ics:else>
<%
		Float convFloat1 = new Float("0");
		String currFloatValue = ics.GetVar("currFloatval");
		if (Utilities.goodString(currFloatValue)) convFloat1 = Float.valueOf(currFloatValue);
		boolean isEqual = false;
		String currValue = "";
		IList attrValueList = ics.GetList("AttrValueList");
		int numOfAttrValues = attrValueList.numRows();
		for (int i = 0; i < numOfAttrValues; i++) {
			currValue = attrValueList.getValue("value");
			if (Utilities.goodString(currValue)) {			
				Float convFloat2 = Float.valueOf(currValue);
				float flt1 = convFloat1.floatValue();
				float flt2 = convFloat2.floatValue();
				int ix = Float.compare(flt1, flt2);
				if (ix == 0) {
					isEqual = true;
					ics.SetVar("currFloatval", currValue);
					break;
				}
			}
			attrValueList.moveToRow(IList.next, i);	
		}
		
		if (!isEqual) ics.SetVar("currFloatval", convFloat1.toString());
%>
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>
<ics:if condition='<%= "date".equalsIgnoreCase(ics.GetVar("AttrType")) %>'>
<ics:then>
	<ics:if condition='<%= "no".equalsIgnoreCase(ics.GetVar("MultiValueEntry")) %>'>
	<ics:then>
<%
		IList pullDownValueList = ics.GetList("PulldownValues");
		int numOfAttrValues = pullDownValueList.numRows();
		String savedValue = ics.GetVar("MyAttrVal");
		DateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date convDate1 = new Date();
		Date convDate2 = new Date();
		if (Utilities.goodString(savedValue)) convDate2 = (Date) simpleFormat.parse(savedValue);
		boolean isEqual = false;
		String currValue = "";		
		for (int i = 0; i < numOfAttrValues; i++) {
%>
			<string:encode varname="encodedStr" value='<%=pullDownValueList.getValue("value")%>' /> 
<%
			currValue = ics.GetVar("encodedStr");
			//currValue = pullDownValueList.getValue("value");
			if (Utilities.goodString(currValue)) convDate1 = (Date) simpleFormat.parse(currValue);
			if (convDate2 != null) {
				int ix = convDate1.compareTo(convDate2);
				if (ix == 0) isEqual = true;
			}
%>		
			<ics:if condition='<%= isEqual %>'>
			<ics:then>
				<option value='<%= simpleFormat.format(convDate1) %>'  selected="yes">
					<font size='<%= ics.GetVar("size") %>'>
						<string:stream value='<%= pullDownValueList.getValue("value") %>' />
					</font>
				</option>
			</ics:then>
			<ics:else>
				<option value='<%= simpleFormat.format(convDate1) %>' >
					<font size='<%= ics.GetVar("size") %>'>
						<string:stream value='<%= pullDownValueList.getValue("value") %>'/>
					</font>
				</option>
			</ics:else>
			</ics:if>
<%		
			isEqual = false;
			pullDownValueList.moveToRow(IList.next, i);		
		}
%>
	</ics:then>
	<ics:else>
<%
		Date convDate1 = new Date();
		Date convDate2 = new Date();
		String currDateValue = ics.GetVar("currDateval");
		DateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (Utilities.goodString(currDateValue)) convDate1 = (Date) simpleFormat.parse(currDateValue);
		boolean isEqual = false;
		String currValue = "";
		IList attrValueList = ics.GetList("AttrValueList");
		int numOfAttrValues = attrValueList.numRows();
		for (int i = 0; i < numOfAttrValues; i++) {
			currValue = attrValueList.getValue("value");
			if (Utilities.goodString(currValue)) {			
				convDate2 = (Date) simpleFormat.parse(currValue);
				int ix = convDate1.compareTo(convDate2);
				if (ix == 0) {
					isEqual = true;
					ics.SetVar("currDateval", currValue);
					break;
				}
			}
			attrValueList.moveToRow(IList.next, i);	
		}
		
		if (!isEqual) ics.SetVar("currDateval", currDateValue);
%>
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>
</cs:ftcs>