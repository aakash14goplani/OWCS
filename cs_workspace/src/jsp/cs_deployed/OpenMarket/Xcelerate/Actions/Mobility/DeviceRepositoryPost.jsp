<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/AdminTreeNodes/DeviceGroupMgt/DevicesRepositoryPost
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Mobility.*"%>
<%@ page import="com.fatwire.mobility.device.*"%>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Mobility.DeviceService" %>
<%@ page import="com.fatwire.cs.core.mobility.ServiceLocator" %>
<%@ page import="javax.xml.parsers.*" %>
<%@ page import="java.io.*"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="org.apache.commons.logging.*"%>

<%@ page import="org.springframework.core.io.ClassPathResource"%>
<%@ page import="org.xml.sax.ErrorHandler"%>
<%@ page import="org.xml.sax.SAXException"%>
<%@ page import="org.xml.sax.SAXParseException"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="COM.FutureTense.Mobility.SitesDeviceManagerService"%>
<%@ page import="COM.FutureTense.Mobility.DeviceRepositoryObject"%>
<%! 
	private static final int MAX_ALLOWED_PATCHES = 100;
	private static Log log = LogFactory.getLog("com.fatwire.logging.cs.mobility");
	
	private static final boolean xmlValidator(byte[] stream)
	{
		DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		docFactory.setNamespaceAware(false);
		docFactory.setValidating(false);
		boolean validate = true;
	
		try
		{
			InputStream in = new ByteArrayInputStream(stream);
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			Document _devices = docBuilder.parse(in);
		}
		catch (Exception exception)
		{
			validate = false;
			String msg = exception.getMessage();
			if(msg.indexOf(":") != -1)
				msg = msg.substring(msg.indexOf(":")+1);
			log.error("Uploaded xml is not a valid format : " + msg);
		}
		return validate;
	}
	
	private static final boolean validateXSD(byte[] uploadedXML)
    {
		boolean validate = true;
    	String msg = null;
    	String schema = "schemas"+File.separator+"deviceRepositorySchema.xsd";
    	
    	ClassPathResource schemaPath = new ClassPathResource(schema);
    	
    	try
    	{
    		MobilityUtils.validateXMLStr(new String(uploadedXML), schemaPath);
    	}
    	catch (Exception e)
    	{
    		validate = false;
    		msg = e.getMessage();
			if(msg.indexOf(":") != -1)
				msg = msg.substring(msg.indexOf(":")+1);
			log.error("Uploaded xml is not a valid format as per the xsd : " + msg);
    	}
    	return validate;
    }
	
	
	private static final String delete(ICS ics, DeviceRepository deviceRepository, String deleteId, String filenames)
	{
		String idname = ics.GetVar("delete-" + deleteId);
		if(null != idname){
			deviceRepository.delete(idname.split(":")[0]);
			filenames = filenames != "" ? filenames + "," + idname.split(":")[1] : idname.split(":")[1];
			
		}
		return filenames;
	}
	
	private static final List<byte[]> getToBeValidatedFiles(ICS ics, String deviceRepositoryType, DeviceRepository deviceRepository) {
		List<byte[]> listOfFiles = new ArrayList<byte[]>();
		
		if (null != ics.GetVar("upload_" + deviceRepositoryType + "_file") || null != ics.GetVar("upload_" + deviceRepositoryType + "_1_file") ) {
			if (DeviceRepositoryType.getDeviceRepositoryType(deviceRepositoryType).isSingleValued()) {
				listOfFiles.add(ics.GetBin("upload_" + deviceRepositoryType));
			} else {
				for (int i = 0; i < MAX_ALLOWED_PATCHES; i++) {
					byte[] uploadFile = ics.GetBin("upload_" + deviceRepositoryType + "_" + String.valueOf(i+1)); 
					if (null == uploadFile) break;
					
					listOfFiles.add(uploadFile);
				}
			}	
		} else {
			List<DeviceRepositoryObject> dros = deviceRepository.getDeviceRepositoryObjects(deviceRepositoryType);
			for (DeviceRepositoryObject dro : dros) {
				listOfFiles.add(dro.getFileData());
			}
		}
		
		return listOfFiles;
	}
		
%>
<cs:ftcs>

	<%
	String deviceRepositoryType = ics.GetVar("device-repository-type");
	String olddeviceRepositoryType = ics.GetVar("old-device-repository-type");
	DeviceRepository deviceRepository = new DeviceRepository(ics);
	String uploadFilename = ics.GetVar("upload_" + deviceRepositoryType + "_file");
	byte[] uploadFiledata = ics.GetBin("upload_" + deviceRepositoryType);
	boolean isproper = true;
	boolean isXSDValidated = true;
	boolean isRepositoryAPIAvailable = true;
	boolean showwarnmessage = true;
	boolean isSwitchHappend = false;
	boolean isValid = true;
	String devicesXmlName = DeviceRepositoryType.DEVICESXML.getName();
	String validxmlfiles = "", 	nonvalidxmlfiles = "", deletedxmlfiles = "", deviceRepositoryName  = "";
	
	if(null != uploadFilename && !DeviceRepositoryType.WURFLZIP.getName().equals(deviceRepositoryType) ){
		isproper = xmlValidator(uploadFiledata);
	}
	
	if(DeviceRepositoryType.DEVICESXML.getName().equalsIgnoreCase(deviceRepositoryType)){
		if(null != uploadFiledata)
			isXSDValidated = validateXSD(uploadFiledata);
	} else {
		SitesDeviceManagerService srv = ServiceLocator.getService("SitesDeviceManagerService", SitesDeviceManagerService.class);
		isRepositoryAPIAvailable = srv.isRepositoryAPIAvailable(deviceRepositoryType);
	}
	
	if (null != ics.GetVar("upload_" + deviceRepositoryType + "_file") || null != ics.GetVar("upload_" + DeviceRepositoryType.WURFLPATCHXML.getName() + "_1_file") ) {
		if(isproper && isXSDValidated && isRepositoryAPIAvailable){
			
			SitesDeviceManagerService srv = ServiceLocator.getService("SitesDeviceManagerService", SitesDeviceManagerService.class);
			if(DeviceRepositoryType.WURFLROOTXML.getName().equalsIgnoreCase(deviceRepositoryType)){
				List<byte[]> wurflRootData = getToBeValidatedFiles(ics, DeviceRepositoryType.WURFLROOTXML.getName(), deviceRepository);
				List<byte[]> wurflPatchesData = getToBeValidatedFiles(ics, DeviceRepositoryType.WURFLPATCHXML.getName(), deviceRepository);
	            isValid = srv.verifyDeviceManager(deviceRepositoryType, wurflRootData.get(0), wurflPatchesData);
			} else {
				List<byte[]> rootData = getToBeValidatedFiles(ics, deviceRepositoryType, deviceRepository);
				isValid = srv.verifyDeviceManager(deviceRepositoryType, rootData.get(0));
			}
		}
	}

	if(isRepositoryAPIAvailable && isValid){
	
	if(isproper && isXSDValidated){
		deletedxmlfiles = delete(ics, deviceRepository, deviceRepositoryType, deletedxmlfiles);
		if("" != deletedxmlfiles && null == uploadFilename){
			deviceRepository.save(devicesXmlName, uploadFilename , uploadFiledata );
			isSwitchHappend = true;
		} else {
			deviceRepository.save(deviceRepositoryType, uploadFilename , uploadFiledata );
		}
		if(null != uploadFilename)
			validxmlfiles = validxmlfiles != "" ? validxmlfiles + "," + uploadFilename : uploadFilename;
	}else if(null != uploadFilename) {
		nonvalidxmlfiles = nonvalidxmlfiles != "" ? nonvalidxmlfiles + "," + uploadFilename : uploadFilename;
	}

	if (DeviceRepositoryType.WURFLROOTXML.getName().equals(deviceRepositoryType) && isproper) {
		for (int i = 1; i < MAX_ALLOWED_PATCHES; i++) {
			deviceRepositoryName = DeviceRepositoryType.WURFLPATCHXML.getName() + "_" + i ;
			uploadFilename = ics.GetVar("upload_" + deviceRepositoryName + "_file");
			deletedxmlfiles = delete(ics, deviceRepository, deviceRepositoryName, deletedxmlfiles);
			if (!Utilities.goodString(uploadFilename)) break;
			uploadFiledata = ics.GetBin("upload_" +deviceRepositoryName);
			if(xmlValidator(uploadFiledata)){
				deviceRepository.save(DeviceRepositoryType.WURFLPATCHXML.getName(), uploadFilename, uploadFiledata);
				validxmlfiles = validxmlfiles != "" ? validxmlfiles + "," + uploadFilename : uploadFilename;
			} else {
				nonvalidxmlfiles = nonvalidxmlfiles != "" ? nonvalidxmlfiles + "," + uploadFilename : uploadFilename;
			}
		}
	}
	
	if(isSwitchHappend) deviceRepositoryType = devicesXmlName;
	DeviceRepositoryType drt = DeviceRepositoryType.getDeviceRepositoryType(deviceRepositoryType);
	DeviceRepositoryType olddrt = DeviceRepositoryType.getDeviceRepositoryType(olddeviceRepositoryType);
	
	if(null == olddrt || drt.getRepositoryType().equals(olddrt.getRepositoryType())){
		showwarnmessage = false;
	}

%>
	<xlat:lookup key='<%= drt.getDescriptionKey() %>' varname="activeDeviceRepo" />
<%
	if(deletedxmlfiles!=""){
%>
	<xlat:lookup key="fatwire/admin/devicerepository/DeletedFiles" varname="deletemsg" evalall="false">
		<xlat:argument name="filename" value='<%=deletedxmlfiles %>'/>
	</xlat:lookup>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="severity" value='info'/>
		<ics:argument name="msgtext" value='<%= ics.GetVar("deletemsg")%>'/>
	</ics:callelement>  
<%
	}
	
	if(validxmlfiles!=""){
		if(!isXSDValidated) {
%>
			<xlat:lookup key="fatwire/admin/devicerepository/UploadedFileIsNotInValidFormat" varname="errormsg" evalall="false" encode="false">
				<xlat:argument name="filename" value='<%= nonvalidxmlfiles %>'/>
			</xlat:lookup>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="severity" value='error'/>
				<ics:argument name="msgtext" value='<%= ics.GetVar("errormsg")%>'/>
			</ics:callelement>
<%
		} else {
%>	
			<xlat:lookup key="fatwire/admin/devicerepository/UploadedNewRepositoryFiles" varname="successmsg1" evalall="false">
				<xlat:argument name="filename" value='<%=validxmlfiles %>'/>
			</xlat:lookup>
			<xlat:lookup key="fatwire/admin/devicerepository/ActiveRepositorySet" varname="successmsg2" evalall="false" encode="false">
				<xlat:argument name="devicerepository" value='<%= ics.GetVar("activeDeviceRepo") %>'/>
			</xlat:lookup>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="severity" value='info'/>
				<ics:argument name="msgtext" value='<%= ics.GetVar("successmsg1") + "<br/>" + ics.GetVar("successmsg2")  %>'/>
			</ics:callelement>  
<%		
		}
	} else if(nonvalidxmlfiles == "") {
%>	
		<xlat:lookup key="fatwire/admin/devicerepository/ActiveRepositorySet" varname="successmsg" evalall="false" encode="false">
			<xlat:argument name="devicerepository" value='<%= ics.GetVar("activeDeviceRepo") %>'/>
		</xlat:lookup>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value='info'/>
			<ics:argument name="msgtext" value='<%= ics.GetVar("successmsg")%>'/>
		</ics:callelement>  
<% 
	}

	if(showwarnmessage){
%>	
		<xlat:lookup key="fatwire/admin/devicerepository/DeviceNamesOrCustomFiltersStop" varname="warningmsg" encode="false"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value='warning'/>
			<ics:argument name="msgtext" value='<%= ics.GetVar("warningmsg") %>'/>
		</ics:callelement>  
<%
	} 
	
	if(nonvalidxmlfiles!=""){
%>
		<xlat:lookup key="fatwire/admin/devicerepository/UploadedFileIsNotInValidFormat" varname="errormsg" evalall="false" encode="false">
			<xlat:argument name="filename" value='<%= nonvalidxmlfiles %>'/>
		</xlat:lookup>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value='error'/>
			<ics:argument name="msgtext" value='<%= ics.GetVar("errormsg")%>'/>
		</ics:callelement>
<%
	} 
	} else if(!isValid) {
%>	
		<xlat:lookup key="UI/UC1/JS/UploadFailed" varname="errormsg1" evalall="false"/>
		<xlat:lookup key="fatwire/admin/seelogerror" varname="errormsg2" evalall="false"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value='error'/>
			<ics:argument name="msgtext" value='<%= ics.GetVar("errormsg1") + "<br/>" + ics.GetVar("errormsg2")  %>'/>
		</ics:callelement>  
		
<%	} else {
%>
		<xlat:lookup key="fatwire/admin/devicerepository/PleaseAddWURFLjarInClasspath" varname="warningmsg" encode="false"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value='warning' />
			<ics:argument name="msgtext" value='<%= ics.GetVar("warningmsg")%>' />
		</ics:callelement>
<%		
	}
	
	ics.RemoveVar("old-device-repository-type"); 
	ics.RemoveVar("device-repository-type"); 
%>
	<ics:callelement element="OpenMarket/Xcelerate/Actions/Mobility/DeviceRepositoryFront">
		<ics:argument name="PostPage" value='DeviceRepositoryPost' />
		<ics:argument name="PostOnly" value='true' />
	</ics:callelement>
	         
</cs:ftcs>