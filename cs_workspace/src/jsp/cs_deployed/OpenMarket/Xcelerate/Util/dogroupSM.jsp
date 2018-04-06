
<%@ page contentType="text/html; charset=UTF-8"
		import="COM.FutureTense.Interfaces.IList,
		        com.openmarket.gator.interfaces.*,
				com.openmarket.assetframework.interfaces.*,
				com.openmarket.xcelerate.interfaces.*,
                COM.FutureTense.Interfaces.FTValList,
                com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="com.openmarket.gator.interfaces.ITemplateAssetInstance" %>
<%@ page import="java.util.*" %>
<%@ page import="com.fatwire.assetapi.def.*" %>

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
//  OpenMarket/Xcelerate/Util/doinspect
//
// INPUT
//                         Operation : ASSET.INSPECT
//     Inputs : required - TYPE
//     OUTPUT : Inspects All Fields Generates  Four Sets / Group asset's fields
//     ERRORS : possible errnos and err mesgs
//
//
// Reason :  Handle the flex family definition  name passed in
//           as "Any"  then query All Defined named Associations
//           for the AssetType and with no subtype.
//
// Modified:  May 10, 2011
// By:        JAG
// Reason:    Enhancement Added the Grouping and Section Attribute Type Heading(s) into both
//              Default Value ALL Attributes ( Attributes Flex Defined, Parents, Associations and Meta Attributes )
//              Pulldown and its associated assigned Values Pulldown. All attributes are displayed with the
//              special prefix removed and just the "Name" post fixed with (S) or (M) for MultiValue / SingleValue.
//              Improved the in ADD / REMOVE attribute functinality with respect to Grouped sections.

// OUTPUT
//   1) Create the following SM Fields / Attribute Type Section Tables
//      a)  System
//      b)  Parent Definitions ( GROUP_ )
//      c)  User defined Extended Fields  ( Attribute_${name} )
//      d)  Named Associations  ( Association-named ${} )
//
//
//
%>
<cs:ftcs>

    <xlat:lookup key="dvin/UI/Admin/Attributes" escape="true" varname="H_Attributes"/>
    <xlat:lookup key="dvin/UI/Admin/Parents" escape="true" varname="H_Parents"/>
    <xlat:lookup key="dvin/UI/Admin/Associations" escape="true" varname="H_Associations"/>
    <xlat:lookup key="dvin/UI/Admin/MetaAttributes" escape="true" varname="H_MetaAttributes"/>

<%
      // passed Asset Start Menu Asset Type and Flex Family Template Name subtype
      // Gets only child relations of this  Startmenu  asset type,
      String assettype = ics.GetVar("AssetType");
      String subtype = ics.GetVar("SubType");
      String fields = ics.GetVar("fields");

      int   nc = 0 ;
      FTValList vN = new FTValList();

      // Get the AssetType Manager
      IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);

      // The name of the target List
      String  target = null;
      String  fieldname = null ;
      String  fieldid = null ;

      String  readonly = null ;
      String required =  null;
      String refsubtype = null;

      String name = null;
      String type = null ;
      String reftype = null ;
      String clienttype  =  null;
      String multiple   =  null;

      String enumvals = null ;
      String enumdisplay =  null;

      String prefix = null ;

      String postfix = " (S)" ;
      // The Array List of Targets Sections
      // ( Flex User Defined Attributes, Parents, Associations, META System )
      String[] targets = {"A*", "B*", "C*", "D*"};

      // Collect all the Group Headings
      List<String> targetDesc = new ArrayList<String>();

      targetDesc.add( "*- - - - - - - - - - "+ics.GetVar("H_Attributes")+"  - - - - - - - - - - *" ) ;
      targetDesc.add( "*- - - - - - - - - - "+ics.GetVar("H_Parents")+"  - - - - - - - - - - *" ) ;
      targetDesc.add( "*- - - - - - - - - - "+ics.GetVar("H_Associations")+"  - - - - - - - - - - *" ) ;
      targetDesc.add( "*- - - - - - - - - - "+ics.GetVar("H_MetaAttributes")+"  - - - - - - - - - - *" ) ;

%>

<ics:if condition='<%= ics.GetList("SMVGroupByName") != null && ics.GetList("SMVGroupByName").hasData() %>'>
<ics:then>
    <%
         // A) Create the following SM Fields / Attribute Tables
         //      a)  System
         //      b)  Parent Definitions ( GROUP_ )
         //      c)  User defined Extended Fields  ( Attribute_${name} )
         //      d)  Named Associations  ( Association-named ${} )
         //

        // Create the Required Attribute Section Base Attribute Tables
        for ( int tg=0 ; tg < targets.length ; ++tg )
        {
           target = targets[tg] ;  %>
           <listobject:create  name='<%=target%>'
                       columns='readonly,required,multiple,clienttype,type,reftype,refsubtype,fieldname,enumvals,enumdisplay,id'/> <%
        }
   %>



   <ics:listloop listname='SMVGroupByName'>

       <ics:listget listname="SMVGroupByName" fieldname="readonly" output="readonly"/>
       <ics:listget listname="SMVGroupByName" fieldname="required" output="required"/>
       <ics:listget listname="SMVGroupByName" fieldname="refsubtype" output="refsubtype"/>

       <ics:listget listname="SMVGroupByName" fieldname="fieldname" output="name"/>
       <ics:listget listname="SMVGroupByName" fieldname="type" output="type"/>
       <ics:listget listname="SMVGroupByName" fieldname="reftype" output="reftype"/>
       <ics:listget listname="SMVGroupByName" fieldname="clienttype" output="clienttype"/>
       <ics:listget listname="SMVGroupByName" fieldname="multiple" output="multiple"/>

       <ics:listget listname="SMVGroupByName" fieldname="enumvals" output="enumvals"/>
       <ics:listget listname="SMVGroupByName" fieldname="enumdisplay" output="enumdisplay"/>

       <%
       //readonly,required,multiple,clienttype,type,reftype,refsubtype,fieldname,enumvals,enumdisplay
                 readonly = ics.GetVar("readonly") ;
                 required =  ics.GetVar("required");
                 refsubtype = ics.GetVar("refsubtype");

                 name = ics.GetVar("name");
                 type = ics.GetVar("type") ;
                 reftype = ics.GetVar("reftype") ;
                 clienttype  = ics.GetVar("clienttype");
                 multiple   = ics.GetVar("multiple");

                 enumvals =ics.GetVar("enumvals");
                 enumdisplay =  ics.GetVar("enumdisplay");

                 target = "D*"  ;
                 prefix = "System_"  ;
                 fieldname = name ;

                  // What type of attribute field
                  // Is it a Association
                  if ( name.startsWith("Association-named:"))
                  {
                       // Push the field onto the Named Asset Association Table
                       fieldname = name.substring(name.indexOf(':')+1)  ;
                       // Set the target  to Asset Named Assocation
                       target = "C*" ;
                       prefix = "Association-named:" ;
                  }else
                       if ( name.startsWith("Attribute_"))
                       {
                          fieldname = name.substring(name.indexOf('_')+1)  ;
                          // Set the target  to User Defined Custom
                          target = "A*" ;
                          prefix = "Attribute_" ;
                       }
                   else
                       if ( name.startsWith("Group_"))
                       {
                          fieldname = name.substring(name.indexOf('_')+1)  ;
                          // Set the target  to User Defined Custom
                          target = "B*" ;
                          prefix =  "Group_" ;
                       }

                  // Need to Post Fix Multi-Value Attributes with MV
                  // and SV
                  if ( multiple.equals("true") )
                    fieldname=fieldname+ "(M)" ;
                  else
                    fieldname=fieldname+ "(S)" ;

                  // Fieldname has just the Attribute Name in this case
                  //
                  // fieldid = target+fieldname ;
                  fieldid = prefix+"*"+type+"*"+multiple+"*"+fieldname ;
                  ++nc ;
        %>

        <listobject:addrow name='<%=target%>' >
				<listobject:argument name='readonly' value='<%=readonly%>'/>
                <listobject:argument name='required' value='<%=required%>'/>
                <listobject:argument name='multiple' value='<%=multiple%>'/>
                <listobject:argument name='clienttype' value='<%=clienttype%>'/>
                <listobject:argument name='type' value='<%=type%>'/>
             	<listobject:argument name='reftype' value='<%=reftype%>'/>
                <listobject:argument name='refsubtype' value='<%=refsubtype%>'/>
                <listobject:argument name='fieldname' value='<%=fieldname%>'/>
                <listobject:argument name='enumvals' value='<%=enumvals%>'/>
                <listobject:argument name='enumdisplay' value='<%=enumdisplay%>'/>
                <listobject:argument name='id' value='<%=fieldid%>'/>

         </listobject:addrow>

   </ics:listloop>
</ics:then>
</ics:if>

<listobject:create  name='SMaseterLst'
                    columns='readonly,required,multiple,clienttype,type,reftype,refsubtype,fieldname,enumvals,enumdisplay,id'/>

<!--
 Pass Number TWO  Merge the List of Tables and Group by Attribute type(s)
 into one table each with a heading row for the name of the group
 -->
<%
         // A) Create the following SM Fields / Attribute Tables
         //      a)  System
         //      b)  Parent Definitions ( GROUP_ )
         //      c)  User defined Extended Fields  ( Attribute_${name} )
         //      d)  Named Associations  ( Association-named ${} )
         //

         // Create the Required Base Attribute Tables
         for ( int tg=0 ; tg < targets.length ; ++tg )
         {
            target = targets[tg] ;
            String desc = targetDesc.get(tg) ;
            nc = 0 ;

            %>

            <listobject:addrow name='SMaseterLst' >
                                 <listobject:argument name='type' value='string'/>
                                  <listobject:argument name='clienttype' value='String'/>
                                 <listobject:argument name='fieldname' value='<%=desc%>'/>
								 <listobject:argument name='readonly' value=''/>
								 <listobject:argument name='required' value=''/>
								 <listobject:argument name='multiple' value=''/>
								 <listobject:argument name='reftype' value=''/>
								 <listobject:argument name='refsubtype' value=''/>
								 <listobject:argument name='enumvals' value=''/>
								 <listobject:argument name='enumdisplay' value=''/>
								 <listobject:argument name='id' value=''/>
            </listobject:addrow>

            <listobject:tolist name='<%=target%>' listvarname='<%=target%>'/>

            <ics:listloop listname='<%=target%>' >

                      <ics:listget listname='<%=target%>' fieldname="readonly" output="readonly"/>
                      <ics:listget listname='<%=target%>' fieldname="required" output="required"/>
                      <ics:listget listname='<%=target%>' fieldname="refsubtype" output="refsubtype"/>

                      <ics:listget listname='<%=target%>' fieldname="fieldname" output="fieldname"/>
                      <ics:listget listname='<%=target%>' fieldname="type" output="type"/>
                      <ics:listget listname='<%=target%>' fieldname="reftype" output="reftype"/>
                      <ics:listget listname='<%=target%>' fieldname="clienttype" output="clienttype"/>
                      <ics:listget listname='<%=target%>' fieldname="multiple" output="multiple"/>

                      <ics:listget listname='<%=target%>' fieldname="enumvals" output="enumvals"/>
                      <ics:listget listname='<%=target%>' fieldname="enumdisplay" output="enumdisplay"/>
                      <ics:listget listname='<%=target%>' fieldname="id" output="fieldid"/>

                <%
                    //readonly,required,multiple,clienttype,type,reftype,refsubtype,fieldname,enumvals,enumdisplay
                    fieldname = ics.GetVar("fieldname") ;
                    readonly = ics.GetVar("readonly") ;
                    required =  ics.GetVar("required");
                    refsubtype = ics.GetVar("refsubtype");
                    type = ics.GetVar("type") ;
                    reftype = ics.GetVar("reftype") ;
                    clienttype  = ics.GetVar("clienttype");
                    multiple   = ics.GetVar("multiple");

                    enumvals =ics.GetVar("enumvals");
                    enumdisplay =  ics.GetVar("enumdisplay");
                    fieldid   = ics.GetVar("fieldid");

                    ++nc ;
               %>

                <listobject:addrow name='SMaseterLst' >
                              <listobject:argument name='readonly' value='<%=readonly%>'/>
                              <listobject:argument name='required' value='<%=required%>'/>
                              <listobject:argument name='multiple' value='<%=multiple%>'/>
                              <listobject:argument name='clienttype' value='<%=clienttype%>'/>
                              <listobject:argument name='type' value='<%=type%>'/>
                               <listobject:argument name='reftype' value='<%=reftype%>'/>
                              <listobject:argument name='refsubtype' value='<%=refsubtype%>'/>
                              <listobject:argument name='fieldname' value='<%=fieldname%>'/>
                              <listobject:argument name='enumvals' value='<%=enumvals%>'/>
                              <listobject:argument name='enumdisplay' value='<%=enumdisplay%>'/>
                              <listobject:argument name='id' value='<%=fieldid%>'/>

                       </listobject:addrow>

           </ics:listloop>

        <%
         }
        %>
<listobject:tolist name='SMaseterLst' listvarname='SMasterMunuArgs'/>
<listobject:tolist name='SMaseterLst' listvarname='lStartMenuArgValInspect'/>


<!--
      The final Verfication
  -->
    <%
       nc = 0 ;
       StringBuffer fieldsDisplay = new StringBuffer();
       StringBuffer fieldsID = new StringBuffer();
       int pt = 0 ;
    %>
    <ics:listloop listname='SMasterMunuArgs' >

                          <ics:listget listname='SMasterMunuArgs' fieldname="readonly" output="readonly"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="required" output="required"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="refsubtype" output="refsubtype"/>

                          <ics:listget listname='SMasterMunuArgs' fieldname="fieldname" output="fieldname"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="type" output="type"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="reftype" output="reftype"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="clienttype" output="clienttype"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="multiple" output="multiple"/>

                          <ics:listget listname='SMasterMunuArgs' fieldname="enumvals" output="enumvals"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="enumdisplay" output="enumdisplay"/>
                          <ics:listget listname='SMasterMunuArgs' fieldname="id" output="fieldid"/>

                    <%
                        //readonly,required,multiple,clienttype,type,reftype,refsubtype,fieldname,enumvals,enumdisplay
                        fieldname = ics.GetVar("fieldname") ;
                        readonly = ics.GetVar("readonly") ;
                        required = ics.GetVar("required");
                        refsubtype = ics.GetVar("refsubtype");
                        type = ics.GetVar("type") ;
                        reftype = ics.GetVar("reftype") ;
                        clienttype  = ics.GetVar("clienttype");
                        multiple   = ics.GetVar("multiple");

                        enumvals =ics.GetVar("enumvals");
                        enumdisplay =  ics.GetVar("enumdisplay");
                        fieldid   = ics.GetVar("fieldid");

                        if ( nc == 0 )
                          fieldsDisplay.append(fieldname)   ;
                        else
                          fieldsDisplay.append(";"+fieldname)      ;

                        // The Format META is as follows
                        // Group Type*Attr type*Multiple*name 
                        if ( !fieldname.startsWith("*-") )
                        {

                          if ( pt != 0 )
                              fieldsID.append(";"+fieldid )  ;
                          else
                             fieldsID.append(fieldid )  ;
                         ++pt ;
                        }
                          ++nc ;
                   %>
       </ics:listloop>
      <%
          // Set the fields title heading and attribute names to be displayed 
          ics.SetVar("fields", fieldsDisplay.toString() );
          // Set the fields id for mapping into StartMenu Arguments Group Tables
          ics.SetVar("fieldsid", fieldsID.toString() );
          // Set the List of Attribute Section Title Headings 
          StringBuffer titles = new StringBuffer();
          for ( String title : targetDesc  )
            titles.append(title+";")  ;

          ics.SetVar("fieldslabel", titles.toString() );

     
      %>
    
</cs:ftcs>