<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/GetBLOBFolder
//
// INPUT
//  cs_GBF_filename
//  varname
// OUTPUT
//  Variables.varname
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<%
    // this element constructs a folder name in the form [0-1023]/[0-1023] based on the bottom 10/10 bits
    // of the hashcode of the filename.  the point is to make sure there are not too many files in a single
    // directory 
    ics.SetVar(ics.GetVar("varname"), Utilities.getBLOBDir(ics.GetVar("cs_GBF_filename")));
%>
</cs:ftcs>