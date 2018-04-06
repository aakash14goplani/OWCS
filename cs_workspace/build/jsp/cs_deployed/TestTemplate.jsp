<%@page import="com.fatwire.assetapi.query.SimpleQuery"%>
<%@page import="java.util.Collection"%>
<%@page import="com.fatwire.system.SessionFactory"%>
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
                    com.fatwire.assetapi.query.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors,
                   com.fatwire.system.*,
                   java.util.*"%><cs:ftcs>
	<%--

INPUT

OUTPUT

--%>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>

	<%
		String assetType = ics.GetVar("c");
		String assetId = ics.GetVar("cid");	
		/*
			SESSION : 
			A session is a token that encapsulates connectivity to a single Content Server instance.
			Session is created with user's credentials, therefore, business objects obtained with a given have access 
			privileges and restrictions for that user.
			
			SessionFactory:
			This is a factory to create new Session instances or obtain ones already created.
		*/
		Session ses = SessionFactory.getSession();
		out.println("Session : "+ses);
		/*
			This interface is the primary access point for getting to Asset's data.
			An asset data can be looked up either by its AssetId using AssetDataManager.read or by using Query
		*/
		AssetDataManager assetDataManager = (AssetDataManager) ses.getManager(AssetDataManager.class.getName());
		out.println("<br /><br />Asset Data Manager : "+assetDataManager+"<br /><br />");
		
		List<String> attributeNames = new ArrayList<String>();
		attributeNames.add("image");
		attributeNames.add("insert_body_text");
		attributeNames.add("lbl_button");
		attributeNames.add("asset_link");
		attributeNames.add("link_url");
		
		int i = 0;
		Query query = new SimpleQuery(assetType,"HOME PAGE FEATURE BANNER BOX",null,attributeNames);
		for(AssetData assetData : assetDataManager.read( query ))
		{		
			for( i=0; i<attributeNames.size(); i++ )
			{
				out.println( "Asset Data for Attribute : "+attributeNames.get(i)+" : "
				+assetData.getAttributeData(attributeNames.get(i)).getData());
				ics.LogMsg(""+assetData.getAttributeData(attributeNames.get(i)).getData());
				out.println( "<br/>" );
			}
		}
	 %>
	 
<%-- 	 <assetset:setasset name="trial" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid") %>'/> --%>
<%-- 	 <%if(ics.GetVar("trial")!=null && ics.GetErrno()==0){ %> --%>
<%-- 	 <assetset:getattributevalues name="trial" listvarname="result" attribute="image"/> --%>
<%-- 	 <ics:listloop listname="result"> --%>
<%-- 	 	<ics:listget fieldname="id" listname="result" output="id"/> --%>
<%-- 	 	Aakash : <ics:getvar name="id"/> --%>
<%-- 	 </ics:listloop> --%>
<%
 	/* 
 	}
 	 	else
 	 	{
 	 		ics.LogMsg("Akshay");
 	 		//ics.LogMsg("Trial : "+ics.GetVar("trial"));
 	 		out.println("<br/><br/><br/><br/>Trial : "+ics.GetVar("trial")+"<br/><br/><br/><br/>Error : "+ics.GetErrno());
 	 	}
 	 */
%>
	 

</cs:ftcs>