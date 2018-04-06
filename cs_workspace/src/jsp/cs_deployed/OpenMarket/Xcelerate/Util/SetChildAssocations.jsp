
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
//          OpenMarket/Xcelerate/Util/SetChildAssocations
//
//
// INPUT
//
// OUTPUT
//
// Created ;  March 25, 2011
// By:        JAG
// REASON :  Processes ALL StartMenu Default Named and Unamed Child Asset Assocations
//           For each multi-valued attribute, a count of the fields displayed
//           The Variable Name Formating is as  follows:

//           1)  single-valued, there will be a variable called
//			    "xxx:Association-named:<name_of_association>", which contains the value (if any). (describing the asset id)
//              "xxx:Association-named:<name_of_association>:_type" (describing the asset type of the asset id).
//
//           2)  multivalued, then
//			    "xxx:Association-named:<name_of_association>:Total" will contain the number of values,
//				and the first child consists
//				of the variables "xxx:Association-named:<name_of_association>:0:ref" (describing the asset id) and
//				"xxx:Association-named:<name_of_association>:0:ref_type" (describing the asset type of the asset id).
//			    Also, "xxx:Association-named:<name_of_association>:0:rank" describes the rank value of the association.
//
//          3) For ALL Association-named_% AssetGather must therefore look for the
//             appropriate count variable before attempting to gather anything.
//             The name of the Total  variable will be formatted as follows ${attribute name}
//             concatenated with "VC" ( Total Value Count )MV .
//
%>
<cs:ftcs>
<%
    // MV Attribute Map Table to count each attributes Total number
    // of array element values processed and set in ICS Scope variables.
    HashMap<String, Integer> MVNamedAssoc =  new HashMap<String, Integer>();
    String MvNamedAssocList  =  ics.GetVar("MvNamedAssocList") ;
   
    int i = 0 ; 
%>
<ics:if condition='<%= ics.GetList("SMNamedAssocationListMV") != null && ics.GetList("SMNamedAssocationListMV").hasData() %>'>
        <ics:then>
            <ics:listloop listname='SMNamedAssocationListMV'>
                <ics:listget listname="SMNamedAssocationListMV" fieldname="name"  output="name"/>
                 <%
                         String sname = ics.GetVar("name") ;
                         MVNamedAssoc.put(sname, new Integer(0))   ;
                 %>
           </ics:listloop>
      </ics:then>
</ics:if>


<ics:if condition='<%= ics.GetList("SMNamedAssocationList") != null && ics.GetList("SMNamedAssocationList").hasData() %>'>
    <ics:then>
            <%
                i= 0 ;
            %>
            <ics:listloop listname='SMNamedAssocationList'>
                 <ics:listget listname="SMNamedAssocationList" fieldname="name"  output="name"/>
                 <ics:listget listname="SMNamedAssocationList" fieldname="value" output="value"/>
                 <%
                          String name = ics.GetVar("name") ;
                          String value = ics.GetVar("value") ;
                          int total ;

                          // Parse and Extract the Asset Type and Asset Id
                          // Get the Asset ID and Asset Type
                          String[] temp= value.split(":");
                          String  type = temp[0]  ;
                          String  id = temp[1] ;

                          // Is this a MV ?
                          if ( MVNamedAssoc.containsKey(name) )
                          {
                              Integer iTotal = (Integer)MVNamedAssoc.get(name) ;
                              int rank = iTotal.intValue() ;
                              ++iTotal ;
                              MVNamedAssoc.put(name, iTotal) ;
                              total = iTotal.intValue() ;

                              String  mvchildid = "ContentDetails:"+name+":"+rank+":ref" ; //Association-named:GabbySV" ;
                              String  mvchildassettype = "ContentDetails:"+name+":"+rank+":ref_type" ;
                              String  mvchildrank = "ContentDetails:"+name+":"+rank+":rank" ;
                              ics.SetVar(mvchildid, id);
                              ics.SetVar(mvchildassettype, type ) ;    
                              ics.SetVar(mvchildrank,  Integer.toString(rank)) ;

                              String  mvtotal = "ContentDetails:"+name+":Total"   ;
                              ics.SetVar(mvtotal,  Integer.toString(total)) ;

                          }
                          else
                          {
                              // single-valued, there will be a variable called
                              // "xxx:Association-named:<name_of_association>", which contains the value (if any). (describing the asset id)
                              // "xxx:Association-named:<name_of_association>:_type" (describing the asset type of the asset id).
                              // SV  Association SET type and ID
                              total = 0 ;
                              // Place in Map We may see this assocation again as MV
                              // This is a Single Value Named Asset Association !
                              // Parse the value and create the ICS Named Association
                              // Variables and Asset ID and Values
                              String childid = "ContentDetails:"+name ; //Association-named:GabbySV" ;
                              String childassettype = childid+"_type" ;

                              ics.SetVar(childid, id);
                              ics.SetVar(childassettype, type ) ;
                          }
                  %>
         </ics:listloop>
      </ics:then>
</ics:if>

</cs:ftcs>