
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
//  OpenMarket/Xcelerate/Util/GetAssetAssociations
//
// INPUT
//   Gets ALL Named Asset child Associations of this Startmenu  asset type,
//	 or otherwise Gets all possible child relations
//   organized by child asset type
//
//  Modified  April 01, 2011 
//
// Handle Named (only) asset associations
// Unammmed will be deprecated anf no longer used
// All Associations will be named..
//
// Modified  April 13, 2010
// Reason :  Handle the flex family definition  name passed in
//           as "Any"  then query All Defined named Associations
//           for the AssetType and with no subtype.
//
// OUTPUT
%>
<cs:ftcs>
<%
    // Use Asset API And get Asset Type Definition Manager
    //
    AssetTypeDefManager atdm = new AssetTypeDefManagerImpl(ics);

    // passed Asset Start Menu Asset Paremers and Flex Family Template Name subtype
    // Gets only child relations of this  Startmenu  asset type,
    String type = ics.GetVar("AssetType");
    String subtype = ics.GetVar("SubType");

    // Handle Named (only) Asset associations
    // Unammmed will be deprecated anf no longer used
    // All Associations will be named.. 
    IAssocNamedManager we = AssocNamedManagerFactory.make(ics);
    IList tmplassoc ;
    if ( !subtype.equals("Any") )
    {
      tmplassoc = we.getItemsList(type, subtype);
    }
    else
    {
      tmplassoc = we.getItemsList(type, null);
    }
 
    ics.RegisterList("associations", tmplassoc);
%>

<ics:if condition='<%=ics.GetVar("errno").equals("0")%>'>
<ics:then>
    <ics:if condition='<%=tmplassoc!=null%>'>
    <ics:then>
         <ics:if condition='<%=tmplassoc.hasData()%>'>
          <ics:then>
                       <!--
                             Create the Master Parent Association Def Table
                             The Primary Attributes ( Columns ) are as follows...
                        -->
                       <listobject:create name='masterAssocList'
                                          columns='name,childassettype,multiple,deptype'/>
                       <ics:listloop listname='associations'>
                             <%
                                    String childassettype = tmplassoc.getValue("childassettype");
                                    String descr = tmplassoc.getValue("description");
                                    String deptype = tmplassoc.getValue("deptype");
                                    String name = tmplassoc.getValue("name");
                                    String multiple = tmplassoc.getValue("multivalued");

                                    if ( multiple.length() == 0 )
                                    {
                                        multiple="F" ; 
                                    }
                            %>

                            <listobject:addrow name="masterAssocList">
                              <listobject:argument  name="name"           value='<%=name%>'/>
                              <listobject:argument  name="childassettype" value='<%=childassettype%>'/>
                              <listobject:argument  name="multiple"       value='<%=multiple%>'/>
                              <listobject:argument  name="deptype"        value='<%=deptype%>'/>
                           </listobject:addrow>
                       </ics:listloop>

                    <%
                        //  Finally we set the Master Named Association Parent List
                        //  object in ICS scope so that the
                        //  utility  helper element(GetAssetFields) can use it
                        //  to process and set PickFromTree Control Dialogs.
                        //  ics.SetObj("masterPDListMap",masterPDList);
                    %>
                    <listobject:tolist name='masterAssocList' listvarname='masterNamedAssocList'/>
                </ics:then>
        </ics:if>
     </ics:then>
    </ics:if>
</ics:then>
</ics:if>
</cs:ftcs>