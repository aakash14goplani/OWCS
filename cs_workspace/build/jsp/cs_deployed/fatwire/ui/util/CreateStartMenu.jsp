<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="com.openmarket.xcelerate.interfaces.IStartMenuItem"%> 
<%@ page import="com.openmarket.xcelerate.interfaces.ISiteList"%> 
<%@ page import="com.openmarket.xcelerate.interfaces.IRoleList"%> 
<%@ page import="com.openmarket.xcelerate.interfaces.IStartMenu"%> 
<%@ page import="com.openmarket.xcelerate.common.SiteList"%> 
<%@ page import="com.openmarket.xcelerate.common.RoleList"%> 
<%@ page import="com.openmarket.xcelerate.startmenu.StartMenuItem" %>
<%@ page import="com.openmarket.xcelerate.startmenu.StartMenu" %>
<%@ page import="com.openmarket.xcelerate.asset.AssetType" %>
<cs:ftcs>
<%-- 
	This element can be invoked with the following tag
		<ics:callelement element=PATH_OF_THIS_ELEMENT>
			<ics:argument name="name" 	value=NAME_VALUE{Type: String} />
			<ics:argument name="description" 	value=DESCRIPTION_VALUE{Type: String} />
			<ics:argument name="assetType" 		value=ASSETTYPE_VALUE{Ex: "Content_C" or "Product_C" etc} />
			<ics:argument name="menuType"		value=MENUTYPE_VALUE{Ex: "ContentForm" or "Search" or "InsiteForm" or "Word" or "CSDocLink"} />			
			<ics:argument name="legalsites"		value=LEGALSITES_VALUE{Ex: "FirstSiteII,AdminSite,avisports" etc} />			
			<ics:argument name="legalroles"		value=LEGALROLES_VALUE{Ex: "AdvancedUser,Analytics,Approver,ArtworkAuthor" etc} />			
		</ics:callelement> 
	legalsites and legalroles have to be comma separated in case it has multiple values.
	If they are defined(not passed), then the startmenu created will be enabled for all the sites.
	Passing invalid assetType or incorrect menu name(existing) will be handled.
--%>
<%	
	String name = (Utilities.goodString(ics.GetVar("name"))) ? ics.GetVar("name"):null;
	String description = (Utilities.goodString(ics.GetVar("description"))) ? ics.GetVar("description"):null;
	String assetType = (Utilities.goodString(ics.GetVar("assetType"))) ? ics.GetVar("assetType"):null;
	String menuType = (Utilities.goodString(ics.GetVar("menuType"))) ? ics.GetVar("menuType"):null;			
	StartMenuItem rval = new StartMenuItem();	
	AssetType	result = new AssetType();
    ISiteList legalSites = new SiteList();
    IRoleList legalRoles = new RoleList();    
    String[] ls = null;
    if(Utilities.goodString(ics.GetVar("legalsites"))) {
    	ls = ics.GetVar("legalsites").split(",");
    	for(String site:ls){
%>
  			<publication:load name='sitename' field='name' value='<%=site%>' />
			<publication:get name='sitename' field='id' output='PubID' />		
<%	    	
    		legalSites.addSite(Long.parseLong(ics.GetVar("PubID")));
		}
	} 
    if((Utilities.goodString(ics.GetVar("legalroles")))) legalRoles.addRoles(ics.GetVar("legalroles").split(","));    
    if(result.Load(ics,assetType)!=null) { 
    	rval.setName(name);
		rval.setDescription(description);
		rval.setAssetType(assetType);
		rval.setItemType(menuType);
		if(legalSites.getNumSites()!=0) rval.setLegalSites(legalSites);
		if(legalRoles.getRoles().length!=0) rval.setLegalRoles(legalRoles);
		try{
			StartMenu startMenu = new StartMenu(ics);	
			startMenu.setMenuItem(rval);	
		}catch (Exception e){			// An exception will be thrown on trying to recreate an existing start menu.
			e.printStackTrace();		
		}    	
	}else{
		ics.SetErrno(-12006);	// Invalid assettype
	}
	
%>
</cs:ftcs>