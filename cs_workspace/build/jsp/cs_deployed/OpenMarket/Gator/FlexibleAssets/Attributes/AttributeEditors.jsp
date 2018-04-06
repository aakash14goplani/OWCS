<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%//
// OpenMarket/Gator/FlexibleAssets/Attributes/AttributeEditors
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
<cs:ftcs><%
if ("true".equals(System.getProperty("enable.ucform","false")))
{
  ics.ClearErrno();
  StringBuffer errStr = new StringBuffer();
  IList results = ics.CallSQL("OpenMarket/Xcelerate/AssetType/FW_AttributeEditor/SelectSummary", null, -1,true, errStr); 
  if (results!=null && results.numRows()>0)
  {
       for (int i=1; i <= results.numRows(); i++)
       {
          results.moveTo(i);
		  String status=results.getValue("status");
		  if (status!=null && !"VO".equals(status))
		  {
		   String id=results.getValue("id");
		   String name=results.getValue("name");
		   if (ics.GetVar("ContentDetails:editorid").equalsIgnoreCase(id))
		   {
		   out.print("<option VALUE=\""+id+"\" SELECTED=\"\">" +name+" (E)");
		   }
		   else
		   {
		   out.print("<option VALUE=\""+id+"\">" +name+" (E)");
		   }
		  }
        }
  }
}
%></cs:ftcs>