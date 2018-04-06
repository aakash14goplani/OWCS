
<%@ page contentType="text/html; charset=UTF-8"
		import="COM.FutureTense.Interfaces.IList,
		        com.openmarket.gator.interfaces.*,
				com.openmarket.assetframework.interfaces.*,
				com.openmarket.xcelerate.interfaces.*,
                COM.FutureTense.Interfaces.FTValList,
                com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="com.openmarket.gator.interfaces.ITemplateAssetInstance" %>
<%@ page import="java.util.*" %>
<%@ page import="com.openmarket.gator.interfaces.ITemplateAssetManager" %>

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
//
// OpenMarket/Xcelerate/Util/SetAssocParentGroups
//
// Created ;  April 26 01, 2011
// By:       JAG
// REASON :  Processes ALL StartMenu Default MultiValue Attributes values
//           Flex Like ExtensiblePage Extended Attributes
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
// REASON :   This element is called from StartMenu Element
//            Creates a Map Object of ParentDef and Set of
//            Parents associated with the Parent Definition
//
// Modified:  April 25, 2011
// By:        JAG
// Reason:    PR#25709 Fixed the creating start menu for an extensible page asset type
//            to select a Flex Page Definition ( Template ) and to collect, process, display
//            and set default values for all Extended and associated custom attributes
//            for that start menu selected page  definition.
// INPUT
//
// OUTPUT
//
//		This element constructs a Map containing the set of SV Parent Definiton Type Templates
//		and the list of Associated Parent asset  for which the attributes will be made
//		available in the list of default values for Start Menu items screen.
//
%>
<cs:ftcs>

<!-- are we working with a Flex Group Or Flex Asset? -->
<!-- performance improvement by use of new tag getattributeinfo -->
<%
    // Get The Flex Family Template Type and the flexdefinition id
    String templateType = ics.GetVar("TemplateType");
    String flextemplatid = ics.GetVar("flextemplatid");
    String prefix = ics.GetVar("prefix");

    IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
    // Get the Template Manager ...
    ITemplateAssetManager itam = (ITemplateAssetManager)atm.locateAssetManager(templateType);

    // Get the list of attributes for Flextemplate  ( PageDefinition )
    IList tmplattrlist = itam.getAttributeInfo(flextemplatid);

    // Save the desired subtypes/asset reference too - but this only needs to be a local variable.
    java.util.Map<String, IList> subtypeMap = itam.getAttributeSubtypeInfo(flextemplatid);

    // MV Attribute Map Table to count each attributes Total number
    // of array element values processed and set in ICS Scope variables.
    HashMap<String, Integer> enabledMVAttrs =  new HashMap<String, Integer>();
%>


<%
	int numAttrs = 0;

	// Collect ALL MultiValue Attributes. Used to Set the Startmenu Default Values
	// Thus, no point in checking for errno here...
	if (tmplattrlist != null && tmplattrlist.hasData())
	{
           for(int i = 1; tmplattrlist.moveTo(i); i++)
           {
               String name = "Attribute_"+tmplattrlist.getValue("name") ;
               String assetid = tmplattrlist.getValue("assetid");

               String clienttype = tmplattrlist.getValue("type");

               String assettype = tmplattrlist.getValue("assettypename");
               String multiple =  tmplattrlist.getValue("valuestyle") ;
               if ( multiple.equals("M") )
               {
                   enabledMVAttrs.put(name,new Integer(0))  ;
               }
           }
    }
%>


<ics:if condition='<%= ics.GetList("SMCustomAttr") != null %>'>
        <ics:then>
            <ics:listloop listname='SMCustomAttr'>
                 <ics:listget listname="SMCustomAttr" fieldname="name" output="name"/>
                 <ics:listget listname="SMCustomAttr" fieldname="value" output="value"/>
                 <%
                     String name = ics.GetVar("name") ;
                     String value = ics.GetVar("value") ;
                     String fname ;                   

                     int total = 0 ;
                     if ( enabledMVAttrs.containsKey(name) )
                     {
                         Integer iTotal = (Integer)enabledMVAttrs.get(name) ;
                         ++iTotal ;
                         enabledMVAttrs.put(name, iTotal) ;
                         total = iTotal.intValue()-1 ;                        

                         // Parese and use pure attr name only
                         String vcname = name.substring(name.indexOf("_")+1) ;

                         // Parese and use pure attr name only
                         String totalname =    prefix+":"+name+":Total";

                         // Append VC to the name and set its running total
                         ics.SetVar(vcname+"VC", iTotal);

                         fname=prefix+":"+name+":"+total ;

                         // Ste Element Indexed Menber and value 
                         ics.SetVar(fname, value);
                         ics.SetVar(totalname, iTotal);
                     }
                     
                 %>
            </ics:listloop>
         </ics:then>
</ics:if>



</cs:ftcs>