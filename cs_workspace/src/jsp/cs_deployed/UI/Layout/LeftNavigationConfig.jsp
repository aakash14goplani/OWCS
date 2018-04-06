<%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session,org.apache.commons.lang.StringUtils"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><cs:ftcs>
<!--   
	LeftNav Custom Integration:  Pane Content Plug-in 
	The tree tag is now optional for the parent top level Element Tag 
	Added the source property which now is the plug-in for the 
	source element rendering any "content" display 
-->	    
<leftnavconfig>
 <panes>
 
	<pane id="sitePane" label="<xlat:stream key='UI/UC1/Layout/SiteTree' escape='true'/>" iconClass="siteTreeIcon">		
		<content>
			<source> UI/Layout/LeftNavigation/Tree </source>  
				
			<tree id="siteTree" label="<xlat:stream key='dvin/UI/SitePlan' escape='true'/>" showParentsOnly="true">				
					<roots> UI/Data/Tree/SitePlanStoreRoots </roots> 						
					<datastore> UI/Data/Tree/Store </datastore> 												  											
					<include>
						<uid>CSSystem:TreeTabs:Site Plan</uid>
					</include>					
					<arguments>
					  <%
						Session ses = SessionFactory.getSession();
						ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
						SiteService siteService = servicesManager.getSiteService();
						boolean canPlacePage = siteService.canPlacePage(GenericUtil.getLoggedInSite(ics));
						if(canPlacePage) 
						{%>
						<argument name="dndController" value="fw.ui.dnd.SiteTreeSource" /><%
						}%>
						<argument name="typeAttr" value="type" />
						<argument name="persist" value="false" />
						<argument name="autoExpand" value="false" />
						<argument name="dragThreshold" value="8" />
						<argument name="betweenThreshold" value="5" />
						<argument name="showRoot" value="false" />
						</arguments>
			</tree>
		</content>
	</pane>
	
	<pane id="contentPane" label="<xlat:stream key='UI/UC1/Layout/ContentTree' escape='true'/>" >
		<content>  
			<source> UI/Layout/LeftNavigation/Tree </source>  
			 	 
			<tree id="contentTree" label="<xlat:stream key='UI/UC1/Layout/AssetTree' escape='true'/>" showParentsOnly="true">		       	   
		       	
		       	    <datastore> UI/Data/Tree/Store </datastore> 			  		
					<exclude>
						<uid>CSSystem:TreeTabs:Admin</uid>
						<uid>CSSystem:TreeTabs:Site Plan</uid>
						<uid>CSSystem:TreeTabs:Site Admin</uid>
						<uid>CSSystem:TreeTabs:Workflow</uid>
						<uid>CSSystem:TreeTabs:Bookmarks</uid>
						<uid>CSSystem:TreeTabs:Design</uid>
						<uid>CSSystem:TreeTabs:History</uid>
						<uid>CSSystem:TreeTabs:Mobility</uid>
						<uid>CSSystem:TreeTabs:Connector Admin</uid>
					</exclude>					
					<arguments>
					    <argument name="showRoot" value="false" />
						<argument name="typeAttr" value="type" />
						<argument name="persist" value="false" />
						<argument name="dndController" value="fw.ui.dnd.TreeSource" />					
					</arguments>										
			</tree> 
		</content>
	</pane>

	<pane id="myWorkPane" label="<xlat:stream key='dvin/UI/MyWork' escape='true'/>" iconClass="systemTreeIcon">
		<canAccess> true </canAccess>		
		<content>
			<source> UI/Layout/LeftNavigation/Tree </source>  
					
			<tree id="systemTree" label="<xlat:stream key='UI/UC1/Layout/SystemTree' escape='true'/>" >
			    	<datastore> UI/Data/Tree/Store </datastore> 			  		
					<include>
						<uid>CSSystem:TreeTabs:Bookmarks</uid>
						<uid>CSSystem:TreeTabs:History</uid>	
					</include>
					<arguments>
						<argument name="typeAttr" value="type" />
						<argument name="persist" value="false" />
						<argument name="dndController" value="fw.ui.dnd.TreeSource" />
						<argument name="showRoot" value="false" />
					</arguments>
			</tree>
		</content>
	</pane>
	 	
	<pane id="marketingTreePane" label="<xlat:stream key='UI/UC1/Layout/MarketingTree' escape='true'/>" iconClass="contentTreeIcon" canAccess="true">
		<canAccess> true </canAccess>
	
		<content>  
			<source> UI/Layout/LeftNavigation/Tree </source>
			        
			<tree id="marketingTree" label="<xlat:stream key='dvin/UI/Treetab/Marketing' escape='true'/>" showParentsOnly="true">
			  	<datastore> UI/Data/Tree/Store </datastore> 
				<include>
					<uid>CSSystem:TreeTabs:Marketing</uid>  				
				</include>
				<arguments>
					<argument name="typeAttr" value="type" />
					<argument name="persist" value="false" />
					<argument name="dndController" value="fw.ui.dnd.TreeSource" />
					<argument name="showRoot" value="false" />
				</arguments>						
			</tree> 
		</content>
	</pane>
	
	<asset:list type="FW_Application" list="deletelist" field1="name" value1="Community" />
	<ics:ifnotempty list="deletelist">
		<ics:then>
			<ics:setvar  name="community" value="true"/>
		</ics:then>
		<ics:else>
			<ics:setvar  name="community" value="false"/>
		</ics:else>
	</ics:ifnotempty>

     	<%
			String cG = ics.GetVar("community");
     		if(cG != null && StringUtils.isNotEmpty(cG) && cG.equalsIgnoreCase("true"))
			{
     	%>
        	 <pane id="communityGadgetsPane" label="<xlat:stream key='CG/CommunityGadgets' escape='true'/>"
        	 	iconClass="contentTreeIcon" canAccess="true">
             <ics:callelement element="CG/GetPermission"/>
             <canAccess>
                <%if(ics.GetVar("user-access-is-granted")==null)
                {%>false<%}else{%>true<%}%>
             </canAccess>
             	<content>
              		 <source>UI/Layout/LeftNavigation/Tree</source>
                	 <tree  id="communityGadgets" label="<xlat:stream
							key='CG/CustomTree' escape='true'/>" showParentsOnly="true">
                     <datastore>CG/LoadTree</datastore>
                     <include>
                        <uid>CSSystem:TreeTabs:Bookmarks</uid>
                        <uid>CSSystem:TreeTabs:History</uid>
                     </include>
                     <arguments>
                          <argument name="typeAttr" value="type" />
                          <argument name="persist" value="false" />
                          <argument name="dndController" value="fw.ui.dnd.TreeSource" />
                          <argument name="showRoot" value="false" />
                     </arguments>
                </tree>
             </content>
         </pane>

<%
}
%>

 </panes>
</leftnavconfig>
</cs:ftcs>