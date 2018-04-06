<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>

<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="com.openmarket.directory.*"%>

<cs:ftcs>

<asset:list list="siteplanlist" type="SitePlan" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>'>
	<asset:argument name="name" value='<%=ics.GetVar("name")%>'/>
</asset:list>
<ics:setvar name="isDuplicate" value="false" />
<ics:if condition='<%=null != ics.GetList("siteplanlist") && ics.GetList("siteplanlist").hasData()%>'>
<ics:then>
	<ics:if condition='<%="edit".equals(ics.GetVar("updatetype"))%>'>
	<ics:then>
		<asset:get name="newSiteplanAsset" field="id" output="_newassetid"/>
		<ics:if condition='<%=!ics.GetVar("_newassetid").equals(ics.GetList("siteplanlist").getValue("id"))%>'>
		<ics:then>
			<ics:setvar name="isDuplicate" value="true" />
		</ics:then>
		</ics:if>
	</ics:then>
	<ics:else>
		<ics:if condition='<%="new".equals(ics.GetVar("updatetype"))%>'>
		<ics:then>
			<ics:setvar name="isDuplicate" value="true" />
		</ics:then>
		</ics:if>
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>

<ics:removevar name="_newassetid" />
<ics:removevar name="_assetid" />

</cs:ftcs>

