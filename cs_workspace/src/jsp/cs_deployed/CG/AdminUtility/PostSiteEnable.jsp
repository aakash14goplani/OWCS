<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
com.fatwire.csdt.service.valueobject.ServiceQueryValueObject,com.fatwire.csdt.service.CSDTService,com.fatwire.csdt.service.factory.CSDTServicefactory,com.fatwire.csdt.service.impl.ExportService,com.fatwire.csdt.service.util.CSDTServiceUtil, com.sun.jersey.api.client.*,com.sun.jersey.api.client.WebResource.*, com.sun.jersey.api.client.ClientResponse.Status, com.fatwire.wem.sso.*, javax.ws.rs.core.MediaType, org.codehaus.jettison.json.JSONObject, java.util.*, java.io.File, java.io.StringWriter, java.io.PrintWriter, org.apache.commons.io.FileUtils"%>

<cs:ftcs>
<ics:getproperty name="xcelerate.batchuser" output="user"
                 file="futuretense_xcel.ini"/>
<ics:getproperty name="xcelerate.batchpass" output="pass"
                 file="futuretense_xcel.ini"/>				
<ics:getproperty name="cs.csdtfolder" output="csdt_exportFolder"
                 file="futuretense.ini"/>				
<ics:getproperty name="cg.management.url" output="cg_mgmt"
                 file="futuretense_xcel.ini"/>

 				 
<%
	String userName = ics.GetVar("user");
	String cgManagementURL = ics.GetVar("cg_mgmt");
	String password = Utilities.decryptString(ics.GetVar("pass"));
	String csdtExportFolder = ics.GetVar("csdt_exportFolder");
	String dsNameForCore = "cg-integration-core";
	String dsNameForAvisports = "cg-integration-avisports";
	String development = ics.GetVar("development");
	Boolean avisportsInstalled = false;
%>
	<ics:catalogmanager>
		<ics:argument name="ftcmd" value="login"/>
		<ics:argument name="username" value='<%=userName %>'/>
		<ics:argument name="password" value='<%=password %>'/>
		<ics:argument name="cs.timeout" value="-1"/>
	</ics:catalogmanager>
<% 
	if("avisports".equals(request.getParameter("siteid")))
	{
	    if (ics.GetErrno() == 0)
	    {
	        boolean isMember = ics.UserIsMember("xceladmin");
	
	        if (isMember)
	        {
			
			%>
				<br/> <u>Sample Polls creating</u> <br/><br/>
				<publication:list list="thepublist"/>
				<ics:listloop listname="thepublist">
					<ics:listget listname="thepublist" fieldname="name" output="pubName" /> 
					<%
					if("avisports".equalsIgnoreCase(ics.GetVar("pubName")))
					{
						avisportsInstalled = true;
					}
					
					%>
				</ics:listloop>
				
				<%
	            List<String> errorList = new ArrayList<String>();
	            try
	            {
	
					if("true".equalsIgnoreCase(development) && avisportsInstalled)
					{
	
						%><br/>Avisports detected: About to create Sample Polls <br/> <%
							// START MENUS
							Client client = Client.create();
						
	    					SSOSession ssosess = SSO.getSSOSession();
							
	    					
	    					
							String multiticket = ssosess.getMultiTicket(userName, password);
							ics.LogMsg("multiticket:" + multiticket);
							ics.LogMsg("cgManagementURL:" + cgManagementURL);
							
							
							WebResource webResource = null;
							Builder res = null;
							Throwable lastException = null;
							boolean pollsInstalled = true;
							 %><br/>Checking polls<br/><%
							for(int i = 0; i < 5; i++)
					        {
					            try
					            {
									webResource = client
					                    .resource(cgManagementURL + "/wsdk/polls/api/search")
		
										.queryParam("multiticket", multiticket)
										.queryParam("order_by", "title")
										.queryParam("order_by_type", "asc")
										.queryParam("cnt", "10")
										.queryParam("start", "0")
										.queryParam("site_id", "avisports");
		
						            res = webResource.type(MediaType.APPLICATION_JSON_TYPE)
					                        .accept(MediaType.APPLICATION_JSON_TYPE)
						                    .header("Pragma", "auth-redirect=false")
						                    .header("_AUTH_HEADER_", "_AUTH_HEADER_");
						                
						            JSONObject data = res.get(JSONObject.class);
						            ics.LogMsg(data.toString());
						            if(data.optString("totalCount").equals("0"))
						            {
						                pollsInstalled = false;
						            };
						            ics.LogMsg("pollsInstalled="+ pollsInstalled);
					            	break;
					            }
					            catch (UniformInterfaceException e)
					            {
					                lastException = e;
					                if (e.getResponse().getClientResponseStatus().equals(Status.FORBIDDEN))
					                {
					                    multiticket = ssosess.getMultiTicket(userName, password);
					                }
					                else
					                {
					                    break;
					                }
					            }
					        }
							
							if(!pollsInstalled)
							{
					        for(int i = 0; i < 5; i++)
					        {
					            try
					            {
									webResource = client
					                    .resource(cgManagementURL + "/wsdk/polls/api/save")
		
										.queryParam("multiticket", multiticket)
										.queryParam("site_id", "avisports")
										.queryParam("pollStatus", "false")
										.queryParam("charttype", "PIE")
										.queryParam("resultsView", "0")
										.queryParam("resultsWidth", "300")
										.queryParam("pollTheme", "basic")
										.queryParam("discl_enabled", "no")
										.queryParam("isshowres", "yes")
										.queryParam("reset_votes", "false")
										.queryParam("title", "Colorado Skiing")
										.queryParam("question", "Which is the best place to ski in Colorado?")
										.queryParam("options", "[{'id':'n0','count':0,'color':'#1751a7','value':'Aspen'},{'id':'n1','count':0,'color':'#8aa717','value':'Breckenridge'},{'id':'n2','count':0,'color':'#a74217','value':'Copper Mountain'},{'id':'n3','count':0,'color':'#a78a17','value':'Steamboat'},{'id':'n4','count':0,'color':'#5f17a7','value':'Beaver Creek'}]");
		
						            res = webResource
						                    .header("Pragma", "auth-redirect=false")
						                    .header("_AUTH_HEADER_", "_AUTH_HEADER_");
						                
						            String data = res.get(String.class);
						            ics.LogMsg(data);
					            	break;
					            }
					            catch (UniformInterfaceException e)
					            {
					                lastException = e;
					                if (e.getResponse().getClientResponseStatus().equals(Status.FORBIDDEN))
					                {
					                    multiticket = ssosess.getMultiTicket(userName, password);
					                }
					                else
					                {
					                    break;
					                }
					            }
					        }
					        %><br/>Colorado Skiing: <%if(null == lastException){%>success<%}else{%><br/><%= lastException%><%}%><%
					        for(int i = 0; i < 5; i++)
					        {
					            try
					            {
					                multiticket = ssosess.getMultiTicket(userName, password);
				            		webResource = client
					                    .resource(cgManagementURL + "/wsdk/polls/api/save")
		
										.queryParam("multiticket", multiticket)
										.queryParam("site_id", "avisports")
										.queryParam("pollStatus", "false")
										.queryParam("charttype", "PIE")
										.queryParam("resultsView", "0")
										.queryParam("resultsWidth", "300")
										.queryParam("pollTheme", "basic")
										.queryParam("discl_enabled", "no")
										.queryParam("isshowres", "yes")
										.queryParam("reset_votes", "false")
										.queryParam("title", "Surf Spot")
										.queryParam("question", "Which is the best surf spot?")
										.queryParam("options", "[{'id':'n0','count':0,'color':'#1751a7','value':'Gold Coast, Australia'},{'id':'n1','count':0,'color':'#8aa717','value':'Mentawai Islands, Indonesia'},{'id':'n2','count':0,'color':'#a74217','value':'Jeffreys Bay, South Africa'},{'id':'n3','count':0,'color':'#a78a17','value':'Fuerteventura, Spain'}]");
		
						            res = webResource
						                    .header("Pragma", "auth-redirect=false")
						                    .header("_AUTH_HEADER_", "_AUTH_HEADER_");
						                
						            String data = res.get(String.class);
						            ics.LogMsg(data);
						            break;
					            }
					            catch (UniformInterfaceException e)
					            {
					                lastException = e;
					                if (e.getResponse().getClientResponseStatus().equals(Status.FORBIDDEN))
					                {
					                    multiticket = ssosess.getMultiTicket(userName, password);
					                }
					                else
					                {
					                    break;
					                }
					            }
					        }
					        %><br/>Surf Spot: <%if(null == lastException){%>success<%}else{%><br/><%= lastException%><%}%><%
					        for(int i = 0; i < 5; i++)
					        {
					            try
					            {
						            multiticket = ssosess.getMultiTicket(userName, password);
					            	webResource = client
					                    .resource(cgManagementURL + "/wsdk/polls/api/save")
		
										.queryParam("multiticket", multiticket)
										.queryParam("site_id", "avisports")
										.queryParam("pollStatus", "false")
										.queryParam("charttype", "PIE")
										.queryParam("resultsView", "0")
										.queryParam("resultsWidth", "300")
										.queryParam("pollTheme", "basic")
										.queryParam("discl_enabled", "no")
										.queryParam("isshowres", "yes")
										.queryParam("reset_votes", "false")
										.queryParam("title", "Tennis Player")
										.queryParam("question", "Who is the best tennis player?")
										.queryParam("options", "[{'id':'n0','count':0,'color':'#1751a7','value':'Novak Djokovic'},{'id':'n1','count':0,'color':'#8aa717','value':'Roger Federer'},{'id':'n2','count':0,'color':'#a74217','value':'Rafael Nadal'},{'id':'n3','count':0,'color':'#a78a17','value':'Andy Murray'}]");
		
						            res = webResource
						                    .header("Pragma", "auth-redirect=false")
						                    .header("_AUTH_HEADER_", "_AUTH_HEADER_");
						                
						            String data = res.get(String.class);
						            ics.LogMsg(data);
						            break;
					            }
					            catch (UniformInterfaceException e)
					            {
					                lastException = e;
					                if (e.getResponse().getClientResponseStatus().equals(Status.FORBIDDEN))
					                {
					                    multiticket = ssosess.getMultiTicket(userName, password);
					                }
					                else
					                {
					                    break;
					                }
					            }
					        }
					        %><br/>Tennis Player: <%if(null == lastException){%>success<%}else{%><br/><%= lastException%><%}%><%
						   
						   
						    %><br/><br/>Saple Polls creating finish<br/><br/> <%	
							}
					}		
	
	            }
	            catch (Throwable t)
	            {
	                Throwable cause = t;
	                Throwable tempCause = t.getCause();
	                while (tempCause != null && cause != tempCause)
	                {
	                    cause = tempCause;
	                    tempCause = tempCause.getCause();
	                }
	
	                StringWriter pw = new StringWriter();
	                cause.printStackTrace(new PrintWriter(pw));
	                String errorMsg = "EXCEPTION THROWN: " + cause.getMessage() + "\n" + pw.getBuffer().toString();
	                errorList.add(errorMsg.replaceAll("\n", "<br/>"));
	                ics.LogMsg(errorMsg);
	            }
	
	            if (errorList.isEmpty())
	            {%>
				Success
				<%} else { %> ##ERROR##  
				<% 		for ( String errorMsg : errorList ){ %>
								<%=errorMsg %> 
				<%				
				}
			}
		} else { 
	%>
		##ERROR## Insufficient Privileges	
	<%
		}
	} else {
	%>
	##ERROR##  Login Error: <%=ics.GetErrno() %>
	<%
	}
%>
<%
} else {
%>
##INFO##  Script has not executed. Site ID: '<%=request.getParameter("siteid") %>' But should be 'avisports'
<%
}
%>
</cs:ftcs>