
<%@ page contentType="text/html; charset=UTF-8"
		import="COM.FutureTense.Interfaces.IList,
		        com.openmarket.gator.interfaces.*,
				com.openmarket.assetframework.interfaces.*,
				com.openmarket.xcelerate.interfaces.*,
                COM.FutureTense.Interfaces.FTValList,
                com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="com.openmarket.gator.interfaces.ITemplateAssetInstance" %>
<%@ page import="java.util.*,java.util.Iterator,
				 java.util.Hashtable" %>

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>

<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%
//         OpenMarket/Xcelerate/Util/SetAssocParentGroups
//
//
// INPUT
//
// OUTPUT
//
// Created ;  March 01, 2011
// By:       JAG
// REASON :  Processes ALL StartMenu Default MultiValue Attributes values
//           Including Parents/Groups and Flex Definition Extended Attributes
//           For each multi-valued attribute, a count of the fields displayed
//           on the form, which includes the possible
//           "add another" field, will be posted.
//           The name of this variable will be the attribute name plus "VC".
//
//          1) For ALL  Attribute_% AssetGather must therefore look for the
//             appropriate count variable before attempting to gather anything.
//             The name of the Total  variable will be formatted as follows ${attribute name}
//             concatenated with "VC" ( Total Value Count )MV .
//
%>
<cs:ftcs>
<%
    // MV Attribute Map Table to count each attributes Total number
    // of array element values processed and set in ICS Scope variables.
    HashMap<String, Integer> enabledMVGroups =  new HashMap<String, Integer>();
%>

<ics:if condition='<%= ics.GetList("startMenuMVList") != null %>'>
    <ics:then>
        <ics:listloop listname='startMenuMVList'>
             <ics:listget listname="startMenuMVList" fieldname="name" output="groupname"/>
             <ics:listget listname="startMenuMVList" fieldname="value" output="value"/>
             <%
                      String name = ics.GetVar("groupname") ;
                      String value = ics.GetVar("value") ;
                      String  fname  ;

                      int total = 0 ;
                      if ( enabledMVGroups.containsKey(name) )
                      {
                          Integer iTotal = (Integer)enabledMVGroups.get(name) ;
                          ++iTotal ;
                          enabledMVGroups.put(name, iTotal) ;

                          total = iTotal.intValue()-1 ;
                          // Is it a Parent or Def Associated Attribute ?
                          if ( name.startsWith("Attribute_") )
                          {
                               // Parese and use pure attr name only
                               String vcname = name.substring(name.indexOf("_")+1) ;
                               // Append VC to the name and set its running total
                               ics.SetVar(vcname+"VC", iTotal);
                          }
                          else
                          {
                              // Set the Total  for this Parent Group ...
                              ics.SetVar("ContentDetails:"+name+":Total", iTotal);
                          }
                      }
                      else
                      {
                          // Flex Def with its Associated Extended Attributes
                          // Must Start at Array List Index equal to one !
                          if ( name.startsWith("Attribute_") )
                          {
                            total = 1 ;
                            enabledMVGroups.put(name, new Integer(2))  ;
                          }
                          else{
                            enabledMVGroups.put(name, new Integer(1))  ;
							// Set the Total  for this Parent Group ...
                            ics.SetVar("ContentDetails:"+name+":Total", 1);
						  }
                      }
                      if ( name.startsWith("Attribute_") )
                          fname=name+"_"+total ;
                      else
                          fname="ContentDetails:"+name+":"+total ;
                      ics.SetVar(fname, value);
                 %>
     </ics:listloop>
   </ics:then>
</ics:if>


</cs:ftcs>