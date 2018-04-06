<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<%
//
// OpenMarket/Gator/FlexibleAssets/Common/ValueStyle
//
// INPUT
//
// EditingStyle		- an ICS variable with values "single" or "multiple" or ???
// AttrValueList	- ICS list of current values for the attribute.  For url or blob attributes, also includes the file binary component.
// tmplattrlist		- ICS list containing information for the current attribute, from the flex template, set to the row
//			  corresponding to this attribute.
// MyAttrVal		- ICS variable containing the current value of a single-valued, non url/blob attribute
// RequiredAttr		- ICS variable set to "true" if the attribute is required
// AttrName		- ICS variable containing the name of the attribute
// AttrDesc		- ICS variable containing the description of the attribute
// AttrTypeID		- ICS variable containing the attribute type ID for the attribute, if any
// PresObj		- ICS object - the current presentation object for the attribute type, if any
// type			- an ICS variable with the type of the attribute, e.g. "date"
// attrassettype	- an ICS variable with the referenced asset type, if type is "asset"
//
// OUTPUT
//
// The purpose of this element is to display an attribute, as either single- or multi-valued.
// The element which actually does the attribute display is PresentationStyles.  It will be called
// for every value of the attribute, and if the attribute is multivalued, it will be called an additional
// time, so that an "add another" empty field may be displayed.  A flag will be sent to PresentationStyles
// to signal that an addition field is being requested in this case.
//
// For each multi-valued attribute, a count of the fields displayed on the form, which includes the possible
// "add another" field, will be posted.  The name of this variable will be the attribute name plus "VC".
// AssetGather must therefore look for the appropriate count variable before attempting to gather anything.
//
// For URL or blob attributes, each multi-valued field can have a "_file" variant that contains binary data.
//
//
%>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.basic.common.DoubleStringList"%>

<cs:ftcs>

<!-- First, set up all the environment we need -->

<!--To show name or description in the Add another button -->
<ics:getproperty 
      name="cc.attrDisplayStyle"
      file="gator.ini"
      output="pval"/>

<%

String nameOrDesc;

if (ics.GetVar("pval").equals("name"))
	nameOrDesc = ics.GetVar("AttrName");
else
{
	nameOrDesc = ics.GetVar("AttrDesc");
	if (nameOrDesc == null || nameOrDesc.length() == 0)
		nameOrDesc = ics.GetVar("AttrName");
}

ics.SetVar("NameorDesc",nameOrDesc);

// Check for single attribute display
boolean isSingle = ics.GetVar("EditingStyle").equals("single");

// Check for whether this is a copy operation or not
boolean isCopy = (ics.GetVar("updatetype").equals("setformdefaults") && ics.GetVar("ContentDetails:name").length() == 0);

// NOTE: The original code made a distinction between original post and a repost.  The distinction seemed to be that only
// on the first post did it calculate the attribute count based on AttrValueList; afterwards, the count existed outside
// the value of the list.

// The logic I have here attempts to do the same thing simply by looking for the existence of the posted form variable that
// would contain the count.  If it doesn't exist, the value is obtained directly from the list itself.
// The hidden itself is NOT posted here, because how we do it depends on whether it's a single or multi-valued case.

String countVariableName = ics.GetVar("AttrName")+"VC";
String countVariableValue = ics.GetVar(countVariableName);
int numberOfPostedValues;
boolean isRepost;
if (countVariableValue == null || countVariableValue.length() == 0)
{
	numberOfPostedValues = ics.GetList("AttrValueList").numRows();
	isRepost = false;
}
else
{
	numberOfPostedValues = Integer.parseInt(countVariableValue);
	isRepost = true;
}

// Make sure there is at least one posted value in all cases.  This is necessary because of the way required fields are
// checked for existence.
if (numberOfPostedValues == 0)
	numberOfPostedValues = 1;

%>
<input TYPE="hidden" NAME='<%=countVariableName%>' VALUE='<%=Integer.toString(numberOfPostedValues)%>'/>
<%
	String status = "multiple";
	if(isSingle)
		status = "single";
%>
<input TYPE="hidden" NAME='<%=ics.GetVar("AttrName")+"_type"%>' VALUE='<%=status%>'/>
<%

// Set the TCounter counter to 1.  For single values, this is all that will be used.
// For multi-values, this is the starting point.
ics.SetCounter("TCounter",1);

// There are three basic situations: create, edit, and copy.
// After a repost, the "create" and "copy" situations effectively become "edit".

boolean isAttrValueListCurrent = ics.GetList("AttrValueList") != null && ics.GetList("AttrValueList").hasData();

// There was a fair bit of original logic to prevent the use of the original data values (AttrValueList) except when they are updated
// (for example, when the data type was a url attribute).  This could not be changed without breaking attribute editors that might
// rely on these behaviors, so I've preserved the following:
//
// <attrname>VC		- the CURRENT reposted count, possibly having nothing to do what the values in AttrValueList are, but
//			  which control what AssetGather looks at;
//
// AttrValueList	- the current value list actually saved in the database, UNLESS it is a url attribute or blob attribute,
//			  in which case it is considered current on every repost, EXCEPT when the attribute hasn't yet been created.
//
// There also was special logic in here to make repost of default (non-attribute-editor) date values in broken-down form be easier.
// There was no need whatsoever to preserve that logic.  Indeed, I've reorganized this to not attempt to perform anything special
// here other than to signal PresentationStyles about the context in a useful way.

ics.SetVar("IsRepost",isRepost?"true":"false");
ics.SetVar("IsCopy",isCopy?"true":"false");
ics.SetVar("IsAttrValueListCurrent",isAttrValueListCurrent?"true":"false");

if (isSingle)
{
	// Single value.  Call the presentation style element once.
%>
	<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/PresentationStyles'/>
<%
}
else
{
	// Multiple value attribute!
	// Cycle through all attribute values, plus one extra one for "add another".
	IList attrvaluelist = ics.GetList("AttrValueList");
if (!(ics.GetVar("type").equals("url")) )
{
	// for non-tree applet by FatWireJP
	if (attrvaluelist.hasData()) {
		boolean hasOrdinal = Utilities.goodString(attrvaluelist.getValue("ordinal"));
		DoubleStringList newList = new DoubleStringList(numberOfPostedValues, "value", "ordinal");

		for (int i = 0; i < numberOfPostedValues; i++) {
			if (attrvaluelist.moveTo(i + 1)) {
				String ordinal = "";
				if (hasOrdinal) {
					ordinal = String.valueOf(i + 1);
				}
				newList.setRow(i, attrvaluelist.getValue("value"), ordinal);
			} else {
				newList.setRow(i, "", "");
			}
		}
	    ics.RegisterList("AttrValueList", newList);
	    attrvaluelist = newList;
	}
}
	// FatWireJP
	int numRows = 0;
	if (isAttrValueListCurrent)
	{
		attrvaluelist.moveToRow(IList.first,0);
		numRows = attrvaluelist.numRows();
	}
	int i = 0;
	while (i < numberOfPostedValues)
	{
		// Set up the context variables.
%>
		<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/PresentationStyles'/>
<%
		if (isAttrValueListCurrent)
		{
			// Only advance if we can; if not, the list is no longer valid.
			if (numRows > i+1) 
				attrvaluelist.moveToRow(IList.gotorow, i + 2);
			else
			{
				isAttrValueListCurrent = false;
				ics.SetVar("IsAttrValueListCurrent","false");
			}
		}
		ics.SetCounter("TCounter", ics.GetCounter("TCounter")+1);
		i++;
	}
%>

	<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/DetermineSelfManagedAddButton'>
		<ics:argument name='AttributeType' value='<%=ics.GetVar("MyAttributeType")%>'/>
	</ics:callelement>
<%	if (!"true".equalsIgnoreCase(ics.GetVar("isSelfManagedAddButton"))) { %>	
	<tr>
		<td></td>
		<td></td>
		<td>
			<xlat:lookup key='dvin/AT/Common/AddAnother' varname='AddAnother'/>
			<xlat:lookup key='dvin/AT/Common/AddAnother' escape='true' varname='mouseover'/>
			<div data-dojo-type='fw.ui.dijit.Button' data-dojo-props='
				title: "<%= ics.GetVar("AddAnother") %>", 
				label: "<%= ics.GetVar("AddAnother") %>",
				onClick: dojo.hitch(null, "GotoNextStep", this.form, "<%= countVariableName %>", "<%= Integer.toString(i) %>", "add"),
				onMouseOver: function() { window.status="<%=ics.GetVar("mouseover")%>"; return true; },
				onMouseOut: function() { window.status=""; return true; }
			'></div>
            <%
            if (ics.GetVar("type") != "url" && i > 1) {
            %>
	            <xlat:lookup key='dvin/AT/Common/DeleteLast' varname='DeleteLast'/>
	            <xlat:lookup key='dvin/AT/Common/DeleteLast' escape='true' varname='mouseover'/>
	            <div data-dojo-type='fw.ui.dijit.Button' data-dojo-props='
					title: "<%= ics.GetVar("DeleteLast") %>", 
					label: "<%= ics.GetVar("DeleteLast") %>",
					onClick: dojo.hitch(null, "GotoNextStep", this.form, "<%= countVariableName %>", "<%= Integer.toString(i) %>", "delete"),
					onMouseOver: function() { window.status = "<%=ics.GetVar("mouseover")%>"; return true; },
					onMouseOut: function() { window.status = ""; return true; }
				'></div>
            <%
            }
            %>           
        </td>
	</tr>
<%	}  
}
%>

</cs:ftcs>
