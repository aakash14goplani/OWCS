
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"%>
<%@ taglib prefix="decimal" uri="futuretense_cs/decimal.tld"%>
<%
	//
	// OpenMarket/Gator/FlexibleAssets/Common/PresentationStylesJSP
	//
	// INPUT
	//
	// TCounter		- ICS counter containing the number of the value in question, starting at 1
	// AttrValueList	- ICS list containing the current attribute values, as a list, set to the row corresponding to this value.
	// tmplattrlist		- ICS list containing information for the current attribute, from the flex template, set to the row
	//			  corresponding to this attribute.
	// AttrName		- ICS variable containing the name of current Attribute
	// AttrDesc		- ICS variable containing the description of the current attribute
	// NameOrDesc		- ICS variable containing either the name or the description of the current attribute, depending on what was
	//			  selected by the appropriate gator.ini property
	// type,AttrType	- ICS variable containing the type of current Attribute, e.g. "date"
	// RequiredAttr		- ICS variable set to "true" if the attribute is required
	// AttrTypeID		- ICS variable containing the identifier of the attribute type asset corresponding to this attribute, if any.
	// IsRepost		- ICS variable set to "true" if this is a form repost (as opposed to the original setup)
	// IsCopy		- ICS variable set to "true" if this is a copy operation
	// IsAttrValueListCurrent- ICS variable set to "true" if the contents of AttrValueList are in fact germane at the moment
	// PresObj		- ICS object containing the presentation object for this attribute type, if any.
	// EditingStyle		- ICS variable containing "single", "multiple", or ???
	// ErrorforEditor	- ICS variable containing an error string, apparently posted in case of an attribute editor error.
	//
	// OUTPUT
	//
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<%
	// Set the revision value to empty, since we are talking about the current revision only
	ics.SetVar("Revision", "");

	// First, calculate the current input name
%>

<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
	<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
	<ics:argument name='cs_IsMultiple' 	value='<%=(ics.GetVar("EditingStyle").equals("single")?"false":"true")%>' />
	<ics:argument name='cs_ValueNum' 	value='<%=String.valueOf(ics.GetCounter("TCounter"))%>' />
	<ics:argument name='cs_IsMultiSelect' value='false' />
	<ics:argument name='cs_Varname' 	value='cs_CurrentInputName' />
</ics:callelement>

<%
	// Grab the current value list and template atttribute list
	IList tmplattrlist = ics.GetList("tmplattrlist", false);
	IList attrvaluelist = ics.GetList("AttrValueList", false);

	String type = ics.GetVar("type");

	// Do specialized setup for attribute types that have special requirements.
	// NOTE: In my view all of this is being provided for backwards compatibility only.  Attribute
	// editors should be strictly discouraged from using any of the special guys here!

	if (type.equals("url")) {
		// == Specialized URL/blob setup ==

		// An ICS variable called "tempval" is set to contain the name of the file that was probably
		// used for the posting of binary data.  I really don't know why this is/was important.

		String tempval = ics.GetVar(ics.GetVar("cs_CurrentInputName") + "_file");
		if (tempval == null)
			ics.SetVar("tempval", "");
		else
			ics.SetVar("tempval", tempval);
	} else if (type.equals("date")) {
		// == Specialized date setup ==

		// It looks like, for date attributes, the date itself is converted into subfields and those fields are what got
		// posted around.  Convoluted logic in the old version of the ValueStyle element did all this stuff.  I've tried
		// to move it here without breaking anything.

		// The following code was being used on some repost conditions but not others.  The intent seems to have been to do
		// all this ONLY if there was not an attribute editor for the date attribute; however, it looked like there was
		// a bug or two in that logic.  As a result, in the case of there being an attribute editor,
		// GetDateValue was being called for create and before the first post,
		// but not during subsequent posts.
		//
		// This couldn't really have helped much, so I've changed the behavior to NEVER do any of the special logic
		// unless there's no attribute editor.  If this is OK, we can eventually move the logic out to DateTypeAttr and get rid
		// of it here.

		if (ics.GetVar("AttrTypeID").length() == 0) {
			if (ics.GetVar("IsAttrValueListCurrent").equals("true")) {
				// If there's an attribute value, AND this isn't an attribute editor, derive from it.
%>
				<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/DeriveDayMonYeartime' />
<%
			} else {
%>
				<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetDateValue' />
<%
			}
		} else {
			if (ics.GetVar("IsAttrValueListCurrent").equals("true"))
				ics.SetVar("tempval", attrvaluelist.getValue("value"));
			else {
				String tempval = ics.GetVar(ics.GetVar("cs_CurrentInputName"));
				if (tempval == null)
					ics.SetVar("tempval", "");
				else
					ics.SetVar("tempval", tempval);
			}
		}
	} else {
		// == All others ==

		// A value "tempval" is set up from the current input if it exists.
		if (ics.GetVar("IsAttrValueListCurrent").equals("true"))
			ics.SetVar("tempval", attrvaluelist.getValue("value"));
		else {
			String tempval = ics.GetVar(ics.GetVar("cs_CurrentInputName"));
			if (tempval == null)
				ics.SetVar("tempval", "");
			else
				ics.SetVar("tempval", tempval);
		}
	}

	if (ics.GetVar("AttrTypeID").length() > 0) {
		// There's an attribute editor for this attribute.

		// For each Presentation Object you may define an element of the same name in
		//	 OpenMarket/Gator/AttributeTypes.  That element needs to display an edit mechanism
		//	 for attribute data.  The name of the INPUT must be the name of the Attribute for single valued
		//	 Attributes.  For multi valued Attributes it is the name prepended by a counter.
		//	 Attribute values are contained in the 'value' column of the global AttrValueList.
		//	 TBD: describe javascript error checking
		//
		//	 INPUT:
		//		PresInst - instance of current Presentation Object
		//		AttrName - name of current Attribute
		//		AttrType - type of current Attribute
		//	   cs_SingleInputName - name of input for single valued and multiselect widgets
		//	   cs_MultipleInputName - name of input for multiple single value widgets
		//		MultiValueEntry - ("yes", "no") whether this call expects you to loop
		//					on values for multi valued attributes
		//	 OUTPUT:
		//		doDefaultDisplay - ("yes, "no") whether to display the default edit mechanism

		if (ics.GetVar("ErrorforEditor") != null) {
			// Error condition
			ics.SetVar("currentAttrName", ics.GetVar("NameorDesc"));
%>
			<tr>
				<td colspan="3">
				<ics:callelement element='OpenMarket/Xcelerate/Actions/Util/ShowError'>
					<ics:argument name='error' 		value='<%=ics.GetVar("ErrorforEditor")%>' />
					<ics:argument name='AssetType' 	value='<%=ics.GetVar("AssetType")%>' />
					<ics:argument name='currentAttrName' value='<%=ics.GetVar("currentAttrName")%>' />
				</ics:callelement>
				</td>
			</tr>
<%
			ics.RemoveVar("ErrorforEditor");
			ics.SetVar("doDefaultDisplay", "no");
		} else {
			// No error condition.
			// End specialized setup.

			// General setup for display.  (That is, calculate cs_SingleInputName and cs_MultipleInputName)
%>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='false' />
				<ics:argument name='cs_Varname' 	value='cs_SingleInputName' />
			</ics:callelement>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='true' />
				<ics:argument name='cs_ValueNum' 	value='<%=String.valueOf(ics.GetCounter("TCounter"))%>' />
				<ics:argument name='cs_IsMultiSelect' value='false' />
				<ics:argument name='cs_Varname' 	value='cs_MultipleInputName' />
			</ics:callelement>

			<ics:callelement element='<%="OpenMarket/Gator/AttributeTypes/"+ics.GetVar("MyAttributeType")%>'>
				<ics:argument name='PresInst' 	value='PresObj' />
				<ics:argument name='AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='AttrType' 	value='<%=ics.GetVar("type")%>' />
				<ics:argument name='AttrNumber' value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
				<ics:argument name='cs_SingleInputName' 	value='<%=ics.GetVar("cs_SingleInputName")%>' />
				<ics:argument name='cs_MultipleInputName' 	value='<%=ics.GetVar("cs_MultipleInputName")%>' />
				<ics:argument name='MultiValueEntry' value='no' />
				<ics:argument name='id' 		value='<%=ics.GetVar("id")%>' />
				<ics:argument name='AssetType' 	value='<%=ics.GetVar("AssetType")%>' />
			</ics:callelement>
<%
		}
	}

	// Next, if the signal indicates we should attempt to handle the attribute in the default way, do so.
	if (ics.GetVar("doDefaultDisplay").equals("yes")) {

		// Default attribute display code.  This is called only if there is no attribute editor that wishes to do the job.
		// Emit the scripts needed for ordered fields
%>
		<!--  OMIma25720  -->
		<ics:callelement element="OpenMarket/Xcelerate/Scripts/MoveMulFields" />
<%
		// For each type of attribute, the default display is a little different, so go through them
		// accordingly.

		if (type.equals("url")) {
			// == URL or blob-type attribute ==
%>
			<ics:if condition='<%=ics.GetVar("RequiredAttr").equals("true")%>'>
			<ics:then>
				<ics:setvar name='RequireInfo' value='<%=ics.GetVar("RequireInfo")+"*"+ics.GetVar("cs_CurrentInputName")+"*"+ics.GetVar("currentAttrName")+"*ReqTrue*"+ics.GetVar("type")+"!"%>' />
			</ics:then>
			<ics:else>
				<ics:setvar name='RequireInfo' value='<%=ics.GetVar("RequireInfo")+"*"+ics.GetVar("cs_CurrentInputName")+"*"+ics.GetVar("currentAttrName")+"*ReqFalse*"+ics.GetVar("type")+"!"%>' />
			</ics:else>
			</ics:if>
			<tr>
				<ics:callelement element='OpenMarket/Gator/AttributeTypes/RenderSWFUpload'>
					<ics:argument name='EditingStyle' 	value='<%= ics.GetVar("EditingStyle") %>' />
					<ics:argument name='cs_CurrentInputName' value='<%= ics.GetVar("cs_CurrentInputName") %>' />
					<ics:argument name='RequiredAttr' 	value='<%= ics.GetVar("RequiredAttr") %>' />
					<ics:argument name='RequireInfo' 	value='<%= ics.GetVar("RequireInfo") %>' />
					<ics:argument name='currentAttrName' value='<%= ics.GetVar("currentAttrName") %>' />
					<ics:argument name='AttrName' 		value='<%= ics.GetVar("AttrName") %>' />
					<ics:argument name='cs_imagedir' 	value='<%= ics.GetVar("cs_imagedir") %>' />
					<ics:argument name='TCounter' 		value='<%= ics.GetVar("TCounter") %>' />

					<ics:argument name='AttrNumber' 	value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
					<ics:argument name='AttrType' 		value='<%=ics.GetVar("type")%>' />

					<ics:argument name='PresInst' 		value='PresObj' />
					<ics:argument name='cs_SingleInputName' value='<%=ics.GetVar("cs_SingleInputName")%>' />
					<ics:argument name='cs_MultipleInputName' value='<%=ics.GetVar("cs_MultipleInputName")%>' />
					<ics:argument name='id' 			value='<%=ics.GetVar("id")%>' />
					<ics:argument name='AssetType' 		value='<%=ics.GetVar("AssetType")%>' />
				</ics:callelement>
			</tr>
<%
		} else if (ics.GetVar("attrassettype").length() > 0) {
%>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='false' />
				<ics:argument name='cs_Varname' 	value='cs_SingleInputName' />
			</ics:callelement>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='true' />
				<ics:argument name='cs_ValueNum' 	value='<%=String.valueOf(ics.GetCounter("TCounter"))%>' />
				<ics:argument name='cs_IsMultiSelect' value='false' />
				<ics:argument name='cs_Varname' 	value='cs_MultipleInputName' />
			</ics:callelement>
<%
			int attValueListRows = ics.GetList("AttrValueList").numRows();
			if (attValueListRows == 0)
				attValueListRows = 1;
			if (attValueListRows == ics.GetCounter("TCounter")) {
%>
				<ics:callelement element='OpenMarket/Gator/AttributeTypes/PICKASSET'>
					<ics:argument name='renderMultiValWidget' 	value='true' />
					<ics:argument name='MultiValueEntry' 		value='yes' />
					<ics:argument name='AttrNumber' 			value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
					<ics:argument name='overWriteDefaultDisplay' value='true' />
					<ics:argument name='PresInst' 				value='PresObj' />
				</ics:callelement>
<%
				ics.RemoveVar("renderMultiValWidget");
			}
		} else if (type.equals("date")) {
%>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='false' />
				<ics:argument name='cs_Varname' 	value='cs_SingleInputName' />
			</ics:callelement>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
				<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='cs_IsMultiple' 	value='true' />
				<ics:argument name='cs_ValueNum' 	value='<%=String.valueOf(ics.GetCounter("TCounter"))%>' />
				<ics:argument name='cs_IsMultiSelect' value='false' />
				<ics:argument name='cs_Varname' 	value='cs_MultipleInputName' />
			</ics:callelement>

			<ics:callelement element="OpenMarket/Gator/AttributeTypes/DATEPICKER">
				<ics:argument name='PresInst' 		value='PresObj' />
				<ics:argument name='AttrName' 		value='<%=ics.GetVar("AttrName")%>' />
				<ics:argument name='AttrType' 		value='<%=ics.GetVar("type")%>' />
				<ics:argument name='AttrNumber' 	value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
				<ics:argument name='cs_SingleInputName' value='<%=ics.GetVar("cs_SingleInputName")%>' />
				<ics:argument name='cs_MultipleInputName' value='<%=ics.GetVar("cs_MultipleInputName")%>' />
				<ics:argument name='MultiValueEntry' value='no' />
				<ics:argument name='id' 			value='<%=ics.GetVar("id")%>' />
				<ics:argument name='AssetType' 		value='<%=ics.GetVar("AssetType")%>' />
				<ics:argument name='overWriteDefaultDisplay' value='true' />
			</ics:callelement>
<%
			// == date type attribute ==
			if (!"single".equals(ics.GetVar("EditingStyle"))) {
				if (null == ics.GetObj("strAttrValues"))
					ics.SetObj("strAttrValues", new StringBuilder(""));

				if (ics.GetVar("tempval").length() > 0) {
					String tempVal = (String) ics.GetVar("tempval");
					ics.SetObj("strAttrValues", ((StringBuilder) ics.GetObj("strAttrValues"))
												.append(tempVal).append(","));
				}
				StringBuilder strAttrValues = (StringBuilder) ics.GetObj("strAttrValues");
				int attValueListRows = ics.GetList("AttrValueList").numRows();
				if (attValueListRows == 0)
					attValueListRows = 1;
				if (attValueListRows == ics.GetCounter("TCounter")) {
					if (strAttrValues.length() > 0) {
						ics.SetObj("strAttrValues", new StringBuilder(strAttrValues.substring(0, strAttrValues.length() - 1)));
					}
%>
					<ics:callelement element='OpenMarket/Gator/AttributeTypes/DATEPICKER'>
						<ics:argument name='renderMultiValWidget' value='true' />
						<ics:argument name='strAttrValues' 		value='<%=ics.GetObj("strAttrValues").toString()%>' />
						<ics:argument name='AttrNumber' 		value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
						<ics:argument name='MultiValueEntry' 	value='no' />
						<ics:argument name='overWriteDefaultDisplay' value='true' />
						<ics:argument name='PresInst' 			value='PresObj' />
					</ics:callelement>
<%
				}
			}
		} else {
					// == All others ==
%>
			<ics:if condition='<%=ics.GetVar("EditingStyle").equals("single")%>'>
			<ics:then>
				<tr>
					<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName' />
					<td></td>
					<td class="form-inset">
					<ics:if condition='<%=ics.GetVar("type").equals("money")%>'>
					<ics:then>
						<ics:setvar name='mycurrency' value='<%=ics.GetVar("empty")%>' />
						<ics:if condition='<%=!(ics.GetVar("MyAttrVal").equals(""))%>'>
						<ics:then>
							<currency:create name='currency' />
							<currency:getcurrency name='currency' value='<%=ics.GetVar("MyAttrVal")%>' varname='mycurrency' />
						</ics:then>
						</ics:if>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" 	value='<%=ics.GetVar("cs_CurrentInputName")%>' />
							<ics:argument name="inputValue" value='<%=ics.GetVar("mycurrency")%>' />
							<ics:argument name="inputSize" 	value='32' />
							<ics:argument name="inputMaxlength" value='48' />
							<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
						</ics:callelement>
					</ics:then>
					<ics:else>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" 	value='<%=ics.GetVar("cs_CurrentInputName")%>' />
							<ics:argument name="inputValue" value='<%=ics.GetVar("MyAttrVal")%>' />
							<ics:argument name="inputSize" 	value='32' />
							<ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
						</ics:callelement>
					</ics:else>
					</ics:if>
					</td>
				</tr>
			</ics:then>
			<ics:else>
				<ics:if condition='<%=ics.GetVar("RequiredAttr").equals("true")%>'>
				<ics:then>
					<ics:setvar name='RequireInfo' value='<%=ics.GetVar("RequireInfo")+"*"+ics.GetVar("cs_CurrentInputName")+"*"+ics.GetVar("currentAttrName")+"*ReqTrue*"+ics.GetVar("type")+"!"%>' />
				</ics:then>
				<ics:else>
					<ics:setvar name='RequireInfo' value='<%=ics.GetVar("RequireInfo")+"*"+ics.GetVar("cs_CurrentInputName")+"*"+ics.GetVar("currentAttrName")+"*ReqFalse*"+ics.GetVar("type")+"!"%>' />
				</ics:else>
				</ics:if>
				
				<ics:if condition='<%=ics.GetVar("type").equals("money")%>'>
				<ics:then>
					<ics:setvar name='mycurrency' value='<%=ics.GetVar("empty")%>' />
					<ics:if condition='<%=!(ics.GetVar("tempval").equals(""))%>'>
					<ics:then>
						<currency:create name='currency' />
						<currency:getcurrency name='currency' value='<%=ics.GetVar("tempval")%>' varname='mycurrency' />
						<ics:setvar name='tempval' value='<%=ics.GetVar("mycurrency")%>' />
					</ics:then>
					</ics:if>
				</ics:then>
				</ics:if>

				<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
					<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
					<ics:argument name='cs_IsMultiple' 	value='false' />
					<ics:argument name='cs_Varname' 	value='cs_SingleInputName' />
				</ics:callelement>
				<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/GetInputName'>
					<ics:argument name='cs_AttrName' 	value='<%=ics.GetVar("AttrName")%>' />
					<ics:argument name='cs_IsMultiple' 	value='true' />
					<ics:argument name='cs_ValueNum' 	value='<%=String.valueOf(ics.GetCounter("TCounter"))%>' />
					<ics:argument name='cs_IsMultiSelect' value='false' />
					<ics:argument name='cs_Varname' 	value='cs_MultipleInputName' />
				</ics:callelement>
<%
				if (null == ics.GetObj("strAttrValues"))
					ics.SetObj("strAttrValues", new StringBuilder(""));

				if (ics.GetVar("tempval").length() > 0) {

					String tempVal = (String) ics.GetVar("tempval");
					tempVal = tempVal.replaceAll(",", "&#Comma#&");
					tempVal = tempVal.replaceAll("'", "&#sQuote#&");
					tempVal = tempVal.replaceAll("\"", "&#dQuote#&");

					ics.SetObj("strAttrValues", ((StringBuilder) ics.GetObj("strAttrValues"))
												.append(tempVal)
												.append(","));
				}

				StringBuilder strAttrValues = (StringBuilder) ics.GetObj("strAttrValues");
				int attValueListRows = ics.GetList("AttrValueList").numRows();
				if (attValueListRows == 0)
					attValueListRows = 1;
				if (attValueListRows == ics.GetCounter("TCounter")) {
%>
				<tr>
					<ics:callelement
						element='OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName' />
					<td><BR />
					</td>
					<td>
						<ics:getproperty name="form.defaultMaxValues" file="futuretense_xcel.ini" output="MAXVALUES" />
<%
					if (strAttrValues.length() > 0) {
 						ics.SetObj("strAttrValues", new StringBuilder(strAttrValues.substring(0, strAttrValues.length() - 1)));
 					}
					String maximumValues = ics.GetVar("MAXVALUES");
					maximumValues = Utilities.goodString(maximumValues) && !"0".equals(maximumValues) ? maximumValues : "-1";
%> 
					<ics:setvar name="editorParams" value="{'width': '', 'height': '22px', 'isRetainEditorHeight': true, 'isSideButtonsInCenter': true}" />
					<ics:callelement element="OpenMarket/Gator/AttributeTypes/RenderMultiValuedTextEditor">
						<ics:argument name="editorName" 	value="fw.dijit.UIInput" />
						<ics:argument name='AttrNumber' 	value='<%="A"+String.valueOf(tmplattrlist.currentRow())+"_"%>' />
						<ics:argument name="AttrName" 		value='<%=ics.GetVar("AttrName")%>' />
						<!-- Default UIInput field doesn't support the embedded links -->
						<ics:argument name="AllowEmbeddedLinks" value='false' />
						<ics:argument name='AttrType' 		value='<%=ics.GetVar("type")%>' />
						<ics:argument name="EditingStyle" 	value='<%=ics.GetVar("EditingStyle")%>' />
						<ics:argument name='renderMultiValWidget' value='true' />
						<ics:argument name='strAttrValues' 	value='<%=ics.GetObj("strAttrValues").toString()%>' />
						<ics:argument name='PresInst' 		value='PresObj' />
						<ics:argument name='maximumValues' 	value='<%= maximumValues %>' />
						<ics:argument name='multiple' 		value='true' />
					</ics:callelement> 
					</td>
				</tr>
<%
				}
%>
			</ics:else>
			</ics:if>
<%
		}
	}
%>

</cs:ftcs>
