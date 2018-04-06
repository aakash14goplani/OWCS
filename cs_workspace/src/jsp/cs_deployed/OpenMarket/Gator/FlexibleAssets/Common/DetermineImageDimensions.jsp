<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/DetermineImageDimensions
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
<%@ page import="com.fatwire.util.ImageUtil"%>
<cs:ftcs>
<%
try{
	IList attrValueList = ics.GetList(ics.GetVar("listname"));
	attrValueList.moveToRow(IList.gotorow,Integer.parseInt(ics.GetVar("currrow")));
	byte [] data = attrValueList.getFileData(ics.GetVar("columnname"));
	String dimensions = ImageUtil.getImageDimensions(data);
	ics.SetVar("ImageDimensions",dimensions);
	
	// Parse dimension value and get width and height.
	// Example of dimensions = 1234x12
	String[] dimensionsParams = dimensions.split("x");
	if (dimensionsParams.length > 1) {
		ics.SetVar("ImageDimensions_width", dimensionsParams[0].trim());
		ics.SetVar("ImageDimensions_height", dimensionsParams[1].trim());
	}
} catch(Exception e){
	ics.SetVar("filesize","");
}
%>
</cs:ftcs>