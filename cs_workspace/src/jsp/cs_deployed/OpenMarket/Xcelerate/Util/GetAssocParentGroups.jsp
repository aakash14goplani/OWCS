
<%@ page contentType="text/html; charset=UTF-8"
		import="COM.FutureTense.Interfaces.IList,
		        com.openmarket.gator.interfaces.*,
				com.openmarket.assetframework.interfaces.*,
				com.openmarket.xcelerate.interfaces.*,
                COM.FutureTense.Interfaces.FTValList,
                com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="com.openmarket.gator.interfaces.ITemplateAssetInstance" %>
<%@ page import="java.util.*" %>

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
// OpenMarket/Xcelerate/Util/GetAssocParentGroups 
//
// REASON :  This element is called from StartMenu Element
//           Creates a Map Object of ParentDef and Set of
//           Parents associated with the Parent Definition
//
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
<%
   // Get the passed Asset Start Menu Asset Paremers and Flex Family Template
   String  AssetType = ics.GetVar("AssetType") ;
   String  templatetype = ics.GetVar("TemplateType") ;
   String  templateobjectid = ics.GetVar("Templateid") ;

   System.out.println("\nEntered@GetAssocParentGroups@ "+AssetType+" @issue <asset:load  templatetype="+templatetype+", template_objectid="+templateobjectid);
%>
<asset:load type='<%=templatetype%>' name='ProdTmplinst' objectid='<%=templateobjectid%>'/>
<%
    // Construct a Templat Instance Object
    ITemplateAssetInstance ita = (ITemplateAssetInstance)ics.GetObj("ProdTmplinst");

    IList tmplparents = ita.getParentGroupTemplates();

    ics.RegisterList("TmplParents", tmplparents);
    IList tmpllist = null;

    // Get the Parent Definition Template Type  Manager
    IFlexTemplateTypeManager fttm = FlexTypeManagerFactory.getFlexTemplateTypeManager(ics);
    ics.SetVar("GroupTemplateType", fttm.getTemplateType(ics.GetVar("TemplateType")));

    // Get Associated Group Parent Type
    IFlexAssetTypeManager fatm = FlexTypeManagerFactory.getFlexAssetTypeManager(ics);
    // Set the Group Type
    ics.SetVar("grouptype", fatm.getGroupType(AssetType));

    String groupType = ics.GetVar("grouptype");
    Map<String, List<String>> masterPDList = new HashMap<String, List<String>>();
%>

<asset:get name='ProdTmplinst' field='name' output='TypeName'/>

<assettype:load name='type' type='<%=ics.GetVar("grouptype")%>'/>
<assettype:scatter name='type' prefix='AssetTypeObj'/>

<hash:create name='SelectedGroups'/>

<ics:if condition='<%=ics.GetVar("errno").equals("0")%>'>
<ics:then>
	<ics:if condition='<%=tmplparents!=null%>'>
    <ics:then>
		
        <!--
            tmplparents List Object  Variable is used to pass the list of originial 
            parents of an asset to AssetGather.jsp
            on Startmenu save, we need to refresh Selected Parents
           from the original selected parents definitions
         -->

        <ics:if condition='<%=tmplparents.hasData()%>'>
                <ics:then>

                    <!--
                          Create the Master Parent Def Table
                          The Primary Attributes ( Columns ) are as follows... 
                     -->                     
                    <listobject:create name='masterPDList'
                                       columns='parentDefName,displayName,groupType,lEnumDisplay,lEnumVals'/>

                    <ics:listloop listname='TmplParents'>

                       <!-- Entered AssocParents.jsp@ JAG  GroupTemplateType:Media_PD , GroupType:null, TemplateInstance:ProdTmplinst  -->
                       <%
                             // Use The Parent Def  Template Instance  to get the Single or Multiple
                             // Parent Group attributes
                             // Set the required/optional and is it Multiple(M) / Single(S)
                             ics.SetVar("required", (ita.getParentGroupRequired(tmplparents.getValue("assetid"))?"true":"false"));
                             ics.SetVar("multiple", (ita.getParentGroupMultiple(tmplparents.getValue("assetid"))?"true":"false"));

                             String  fvOptional = ics.GetVar("required")  ;
                             String  fvSMV = ics.GetVar("multiple")  ;

                             //System.out.print("\nIssue Get asset:list { type="+ics.GetVar("GroupTemplateType")+"}@"+tmplparents.getValue("assetid")+", optional:"+fvOptional+", Multiple:"+fvSMV ) ;
                         %>

                         <asset:list type='<%=ics.GetVar("GroupTemplateType")%>' list='tmplList' field1='id' value1='<%=tmplparents.getValue("assetid")%>'/>

                         <%
                            // We now have the name and Meta data Single, MV required ?
                            tmpllist = ics.GetList("tmplList");
                            String PDname = "Group_"+tmpllist.getValue("name") ;

                            String PDnameDisplay ;

                            if (ics.GetVar("multiple").equals("false")) {
                               PDnameDisplay = "Group_"+tmpllist.getValue("name") ;
                            }
                            else
                            {
                               // Set the Prefix to MV indicatore
                               PDnameDisplay = "Group_MV_"+tmpllist.getValue("name");
                            }
                       %>
                        <hash:add name="SelectedGroups" value='<%=tmpllist.getValue("name")%>'/>

                        <ics:setvar name='<%="req"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("required")%>'/>
						<ics:setvar name='<%="mult"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("multiple")%>'/>
                        <ics:setvar name='<%="_id_"+tmpllist.getValue("name")%>' value='<%=tmpllist.getValue("id")%>'/>

					    <listobject:create name='singleTmpl' columns='assetid'/>
						<listobject:addrow name='singleTmpl'>
							<listobject:argument name='assetid' value='<%=tmplparents.getValue("assetid")%>'/>
						</listobject:addrow>
						<listobject:tolist name='singleTmpl' listvarname='currentList'/>

                        <%
                              // Get Associated Parents 
                              IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);

                              String groupParentType =  ics.GetVar("grouptype") ;

                              ics.SetObj("GroupManager", atm.locateAssetManager(ics.GetVar("grouptype")));

                              ITemplateableAssetManager itam = (ITemplateableAssetManager)ics.GetObj("GroupManager");
                              IList myparentgroups = itam.getSortedTypedAssets(ics.GetSSVar("pubid"),ics.GetList("currentList"));
                              ics.RegisterList("MyParentGroups",myparentgroups);
                              ics.ClearErrno();

                              myparentgroups = ics.GetList("MyParentGroups");

                              //Create list to hold Parent names associated with the ParentDef
                              List<String> parentList = new ArrayList<String>();

                              StringBuffer lEnumDisplay = new StringBuffer();
                              StringBuffer lEnumVals = new StringBuffer();

                              if (myparentgroups != null && myparentgroups.hasData()) {
                              %>

                                  <ics:listloop listname='MyParentGroups'>
                                       <%
                                           String id =  myparentgroups.getValue("assetid")   ;
                                           String parentName =  myparentgroups.getValue("name") ;

                                           // Add to the Master Parent Definition Group  List
                                           parentList.add(parentName) ;
                                           // Build Comma Dilimited list of Parent Display Names and Asset Id
                                           lEnumDisplay.append(parentName+",")   ;

                                           //  Set the Asset identifier equal to ${AssetType}:{id}
                                           //  String assetid = ics.GetVar("grouptype")+":"+id;
                                           lEnumVals.append(id+",")   ;
                                       %>
                                  </ics:listloop>
                             <% }

                                 //Associate the Parent list with the Parent-Definition
                                 masterPDList.put(PDname,parentList);
                             %>
                           <listobject:addrow name="masterPDList">   <%
                           %>
                              <listobject:argument  name="parentDefName"  value='<%=PDname%>'/>
                              <listobject:argument  name="displayName"    value='<%=PDnameDisplay%>'/>
                              <listobject:argument  name="groupType"      value='<%=groupParentType%>'/>
                              <listobject:argument  name="lEnumDisplay"   value='<%=lEnumDisplay.toString()%>'/>
                              <listobject:argument  name="lEnumVals"      value='<%=lEnumVals.toString()%>'/>
                           </listobject:addrow>

                    </ics:listloop>
                    <%
                        //  Finally we set the Master Definition Parent List object in ICS scope so that the
                        //  utility  helper element(GetAssetFields) can use it
                        //  and not will not be required have to recreate it.
                        ics.SetObj("masterPDListMap",masterPDList);	                        
                    %>
                    <listobject:tolist name='masterPDList' listvarname='masterPDParents'/>
                </ics:then>
        </ics:if>
        
     </ics:then>
    </ics:if>
</ics:then>
    </ics:if>
</cs:ftcs>