<%@page import="java.util.Enumeration"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
		<ics:argument name="c" value='<%=ics.GetVar("c") %>' />
		<ics:argument name="cid" value='<%=ics.GetVar("cid") %>' />
		<ics:argument name="assetPrefix" value='<%=ics.GetVar("cid") %>' />
	</ics:callelement><%
	String webReference = ics.GetVar(ics.GetVar("cid") + ":Webreference");
	if(Utilities.goodString(webReference)){
		out.println(webReference+ "<br/><br/>");
		for(String web_reference : webReference.split(",")){
			String assetURL = web_reference.substring(1, web_reference.indexOf("WebRoot")).split("=")[1].trim();
			String webRoot = web_reference.substring(web_reference.indexOf("WebRoot")).replaceAll("]", "").split("=")[1].trim();
			out.println("assetURL: " + assetURL + "<br/>webRoot: " + webRoot + "<br/>");
			String sql = "SELECT assetid, assettype FROM WebReferences WHERE webroot ='" + webRoot + "' AND webreferenceurl ='" + assetURL + "'";
			out.println("Query: " + sql + "<br/>");
			%><ics:sql table="WebReferences" listname="assetDetailsList" sql='<%=sql %>' />
			<ics:if condition='<%=null != ics.GetList("assetDetailsList") && ics.GetList("assetDetailsList").hasData() %>'>
				<ics:then>
					<ics:listloop listname="assetDetailsList">
						<ics:listget fieldname="assetid" listname="assetDetailsList" output="asset_id"/>
						<ics:listget fieldname="assettype" listname="assetDetailsList" output="asset_type"/>
						<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
							<ics:argument name="c" value='<%=ics.GetVar("asset_type") %>' />
							<ics:argument name="cid" value='<%=ics.GetVar("asset_id") %>' />
							<ics:argument name="assetPrefix" value='<%=ics.GetVar("asset_id") %>' />
						</ics:callelement>
						Body Text: <ics:getvar name='<%=ics.GetVar("asset_id") + ":body_text" %>'/> <br/><br/>
					</ics:listloop>
				</ics:then>
			</ics:if><%
			
			String reqURI = request.getRequestURI();
			StringBuffer reqURL = request.getRequestURL();
			out.println("reqURI: " + reqURI + ", reqURL: " + reqURL + "<br/>"); 
			
			out.println("<br/><br/>Attributes: <br/>");
			for(Enumeration<String> e = request.getAttributeNames(); e.hasMoreElements(); ){
				String attName = (String)e.nextElement();
				out.println("attName: " + attName + ", value: " + request.getAttribute(attName) + "<br/>");
			}
			
			out.println("<br/><br/>Parameters: <br/>");
			for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ){
				String paramName = (String)e.nextElement();
				out.println("paramName: " + paramName + ", value: " + request.getParameter(paramName) + "<br/>");
			}
			
			out.println("<br/><br/>Header Names: <br/>");
			for(Enumeration<String> e = request.getHeaderNames(); e.hasMoreElements(); ){
				String headerName = (String)e.nextElement();
				out.println("headerName: " + headerName + ", value: " + request.getHeader(headerName) + "<br/>");
				
			}
		}
	}
%></cs:ftcs>