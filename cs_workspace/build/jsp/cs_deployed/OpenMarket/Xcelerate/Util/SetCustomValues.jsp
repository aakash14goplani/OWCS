<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/SetCustomValues
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="java.io.*,java.util.*"%>
<cs:ftcs>
<%
    // MV Attribute Map Table to count each attributes Total number
    // of array element values processed and set in ICS Scope variables.
    HashMap<String, Integer> enabledMVGroups =  new HashMap<String, Integer>();
%>

<ics:if condition='<%= ics.GetList("SMVCustomList") != null %>'>
    <ics:then>
        <ics:listloop listname='SMVCustomList'>
			<ics:listget listname="SMVCustomList" fieldname="name" output="groupname"/>
			<ics:listget listname="SMVCustomList" fieldname="value" output="value"/>
			<%
				String name = ics.GetVar("groupname") ;
				String value = ics.GetVar("value") ;
				String  fname;
				int total = 0 ;
				if ( enabledMVGroups.containsKey(name) )
				{
					Integer iTotal = (Integer)enabledMVGroups.get(name) ;
					++iTotal ;
					enabledMVGroups.put(name, iTotal) ;
					total = iTotal.intValue()-1 ;
					ics.SetVar("startmenuarg:"+name+":Total", iTotal);
				}
				else
				{
					enabledMVGroups.put(name, new Integer(1))  ;
					ics.SetVar("startmenuarg:"+name+":Total", 1);
				}
				// ordinal is true
				fname=name+":"+total+":data" ;
				ics.SetVar("startmenuarg:"+fname, value);
			%>
     </ics:listloop>
   </ics:then>
</ics:if>
</cs:ftcs>