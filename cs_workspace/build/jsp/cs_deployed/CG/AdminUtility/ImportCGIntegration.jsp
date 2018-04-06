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
com.fatwire.csdt.service.valueobject.ServiceQueryValueObject,com.fatwire.csdt.service.CSDTService,com.fatwire.csdt.service.factory.CSDTServicefactory,com.fatwire.csdt.service.impl.ExportService,com.fatwire.csdt.service.util.CSDTServiceUtil, java.util.*, java.io.File, java.io.StringWriter, java.io.PrintWriter, org.apache.commons.io.FileUtils"%>

<cs:ftcs>
<ics:getproperty name="xcelerate.batchuser" output="user"
                 file="futuretense_xcel.ini"/>
<ics:getproperty name="xcelerate.batchpass" output="pass"
                 file="futuretense_xcel.ini"/>				
<ics:getproperty name="cs.csdtfolder" output="csdt_exportFolder"
                 file="futuretense.ini"/>				

 				 
<%
	String userName = ics.GetVar("user");
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
    if (ics.GetErrno() == 0)
    {
        boolean isMember = ics.UserIsMember("xceladmin");

        if (isMember)
        {
		
		%>
			<br/> <u>Community-Gadgets Integration</u> <br/><br/>
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
            ServiceQueryValueObject valueObject = new ServiceQueryValueObject();
            try
            {

				CSDTService service = CSDTServicefactory.getService("import");
				
				// ELEMENTS
				String [] extension = {"jsp"};
				String pathToElements = csdtExportFolder + File.separator + "envision" + File.separator + dsNameForCore + File.separator + "src" +File.separator+ "jsp" + File.separator +"cs_deployed";
				File datastoreFile = new File(pathToElements);
				Collection<File> jspElements = FileUtils.listFiles(datastoreFile, extension, true);
				
				ics.LogMsg("Community-Gadgets Integration: About to import elements located under " + pathToElements);
				
				%><br/>  About to import elements  <br/><br/>  <%
				
				String element;
				for(File file: jspElements)
				{
					element = file.toString();
					element = element.replace(pathToElements + File.separator,"");
					element = element.replace(".jsp","");
					element = element.replace("\\","/");
					
					valueObject = new ServiceQueryValueObject();
					valueObject.setIds("@ELEMENTCATALOG:" + element);
					valueObject.setDataStoreName(dsNameForCore);
					valueObject.setIsIdMapping(false);
					service.execute(ics, valueObject);
					
				}
				%><br/>  Elements imported successfully  <br/><br/>  <%
				
				if("true".equalsIgnoreCase(development))
				{
					
					%><br/> Development Install Detected. <br/><br/>  <%
					
					// ASSET TYPES
					valueObject = new ServiceQueryValueObject();
					valueObject.setIds("@ASSET_TYPE:*");
					valueObject.setDataStoreName(dsNameForCore);
					valueObject.setIsIdMapping(false);
					service.execute(ics, valueObject);
					
					ics.LogMsg("Community-Gadgets Integration: Created Asset Types successfully." + avisportsInstalled);
					
					%><br/> Created Asset Types <br/><br/>  <%

					
					
					// ALL ASSETS
					%><br/>  About to import assets  <br/><br/>  <%
					valueObject = new ServiceQueryValueObject();
					valueObject.setIds("@ALL_ASSETS");
					valueObject.setDataStoreName(dsNameForCore);
					valueObject.setIsIdMapping(false);
					valueObject.setTargetSiteNames("avisports");
					service.execute(ics, valueObject);
					%><br/>  Assets created successfully <br/><br/>  <%
					
					if(avisportsInstalled)
					{
					
					    pathToElements = csdtExportFolder + File.separator + "envision" + File.separator + dsNameForAvisports + File.separator + "src" +File.separator+ "jsp" + File.separator +"cs_deployed";
						datastoreFile = new File(pathToElements);
						jspElements = FileUtils.listFiles(datastoreFile, extension, true);
						
						ics.LogMsg("Community-Gadgets Integration: About to import elements located under " + pathToElements);
						
						%><br/>  About to import elements <br/><br/>  <%
						
						for(File file: jspElements)
						{
							element = file.toString();
							element = element.replace(pathToElements + File.separator,"");
							element = element.replace(".jsp","");
							element = element.replace("\\","/");
							
							valueObject = new ServiceQueryValueObject();
							valueObject.setIds("@ELEMENTCATALOG:" + element);
							valueObject.setDataStoreName(dsNameForAvisports);
							valueObject.setIsIdMapping(false);
							service.execute(ics, valueObject);
							
						}
						ics.LogMsg("Community-Gadgets Integration: avisports Element Catalog imported successfully ");
						
						valueObject = new ServiceQueryValueObject();
						valueObject.setIds("@SITECATALOG:*");
						valueObject.setDataStoreName(dsNameForAvisports);
						valueObject.setIsIdMapping(false);
						valueObject.setTargetSiteNames("avisports");
						service.execute(ics, valueObject);
						
						ics.LogMsg("Community-Gadgets Integration: avisports Sites Catalog imported successfully ");
						%><br/> avisports Elements imported successfully  <br/><br/>  <%
					    
					%><br/>Avisports detected: About to create StartMenu and Assets <br/><br/>  <%
						// START MENUS
						valueObject = new ServiceQueryValueObject();
						valueObject.setIds("@STARTMENU:*");
						valueObject.setDataStoreName(dsNameForAvisports);
						valueObject.setIsIdMapping(false);
						valueObject.setTargetSiteNames("avisports");
						service.execute(ics, valueObject);
						
						ics.LogMsg("Community-Gadgets Integration: Avisports Sample Site: Created StartMenus successfully.");
						%><br/>StartMenu created successfully <br/> <br/> <%			
						valueObject = new ServiceQueryValueObject();
						valueObject.setIds("@ALL_ASSETS");
						valueObject.setDataStoreName(dsNameForAvisports);
						valueObject.setIsIdMapping(false);
						valueObject.setTargetSiteNames("avisports");
						service.execute(ics, valueObject);
						
						ics.LogMsg("Community-Gadgets Integration: Avisports Sample Site: Created Assets successfully.");
						%><br/>Assets created successfully <br/><br/> <%	
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

%><%=valueObject.getResponse()%><br/><%
    
            if (errorList.isEmpty())
            {%>
Success
<%		} else { %> ##ERROR##  
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
</cs:ftcs>