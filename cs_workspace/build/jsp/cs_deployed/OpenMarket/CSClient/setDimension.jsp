<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/CSClient/setDimension
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
<cs:ftcs>

<!-- get the dim parent -->
<%
String assetPrefix=ics.GetVar("assetprefix");

if (assetPrefix==null)
assetPrefix="new";


%>
<!-- get the dimension from the source asset if it is there assuming we have only locale type -->

<%
String totalAvailableDim=ics.GetVar(assetPrefix+":Dimension:Total");
int total = 0;
if (totalAvailableDim!=null)
total=Integer.parseInt(totalAvailableDim);
// asset does not have any locale set

String dimid = ics.GetVar("dimid");
if ((total <=0) &&  (dimid!=null)) 
{
int i=0;
ics.SetVar(assetPrefix+":Dimension:"+i,dimid);
ics.SetVar(assetPrefix+":Dimension:"+i+"_type","Dimension"); // hard coded
ics.SetVar(assetPrefix+":Dimension:Total", "1");
} 
else 
{
for (int i = 0; i < total; i++) 
{

if (dimid!=null)
ics.SetVar(assetPrefix+":Dimension:"+i,dimid);
//  String type = ics.GetVar("source:Dimension:"+i+"_type");
}

}
%>
</cs:ftcs>