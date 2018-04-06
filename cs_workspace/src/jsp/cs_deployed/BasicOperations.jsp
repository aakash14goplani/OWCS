<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%><%@ taglib
	prefix="asset" uri="futuretense_cs/asset.tld"%><%@ taglib
	prefix="assetset" uri="futuretense_cs/assetset.tld"%><%@ taglib
	prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%><%@ taglib
	prefix="ics" uri="futuretense_cs/ics.tld"%><%@ taglib
	prefix="listobject" uri="futuretense_cs/listobject.tld"%><%@ taglib
	prefix="render" uri="futuretense_cs/render.tld"%><%@ taglib
	prefix="siteplan" uri="futuretense_cs/siteplan.tld"%><%@ taglib
	prefix="searchstate" uri="futuretense_cs/searchstate.tld"%><%@ page
	import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"%>
<cs:ftcs>

	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	
	<%-- <ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ"> 
		<ics:argument name="assetId" value='<%=ics.GetVar("cid") %>'/>
		<ics:argument name="assetType" value='<%=ics.GetVar("c") %>'/>
	</ics:callelement> --%>

	<ics:setvar name="errno" value="0"/>
	<ics:sql table="Publication" listname="SiteList" sql="select id from publication where name='Risk_Engineering'" />
	<ics:if condition='<%="0".equals(ics.GetVar("errno")) %>'>
		<ics:then>
			value : <ics:resolvevariables name="SiteList.#numRows"/> <br/><br/>
			<%out.println("Resolve Variables : " + ics.ResolveVariables("SiteList.#numRows") + "<br/><br/>"); %>
			<%out.println("Get Variables : " + ics.GetVar("SiteList.#numRows") + "<br/><br/>"); %>
			<ics:if condition='<%=Integer.valueOf(ics.ResolveVariables("SiteList.#numRows")) > 0 %>'>
				<ics:then>
					List Not Empty
				</ics:then>
				<ics:else>
					List Empty
				</ics:else>
			</ics:if>
		</ics:then>
		<ics:else>
			Failed to execute SQL : <ics:geterrno/>
		</ics:else>
	</ics:if>

</cs:ftcs>
