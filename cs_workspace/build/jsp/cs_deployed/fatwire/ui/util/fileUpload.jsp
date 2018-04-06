<%@ page import="com.fatwire.ui.util.InsiteUtil"%>
<%@ page import="com.fatwire.util.BlobUtil"%>
<%@ page import="com.fatwire.util.ImageUtil"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.fatwire.assetapi.data.BlobObjectImpl"%>
<%@ page import="com.fatwire.assetapi.data.BlobAddressImpl"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.fatwire.services.ServicesManager"%>
<%@ page import="java.util.Map,java.util.HashMap,java.util.Map.Entry"%>
<%@ page import="com.fatwire.system.SessionFactory"%>
<%@ page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.services.exception.ValidationException"%>
<%@page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTVAL"%>
<%//
// fatwire/ui/util/fileUpload
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<%
	String fieldName = ics.GetVar("fieldName");
	String uploaderType = ics.GetVar("uploaderType");
	if(uploaderType == null)
	{
		// Flash does not send the uploaderType variable
		uploaderType = "flash";
	}	
	Map<String , Long> fileNameIdMap = new HashMap<String , Long>();
	String fileName = ics.GetVar(fieldName + "_file");
	String uploadtoken = ics.GetVar("token");
	String identifier = ics.GetVar("identifier");
	String isBase64 = ics.GetVar("isBase64");
	boolean base64Encoded = false;
	StringBuilder builder = new StringBuilder("");
	
	if(isBase64 != null)
	{
		base64Encoded = Boolean.parseBoolean(isBase64);
	}
	String maxWidth = ics.GetVar("maxwidth");
	String minWidth = ics.GetVar("minwidth");
	String maxHeight = ics.GetVar("maxheight");
	String minHeight = ics.GetVar("minheight");
	String isValidImgDimensions = "true";
	byte[] bytes = null;
	if (fieldName != null) {
		FTVAL bindata = ics.GetCgi(fieldName);
		if (bindata != null) {
			bytes = bindata.getBlob();			
			if(bytes != null){
				//Validate the upoaded file
				FTValList args = new FTValList();
				args.setVal("fileBytes",bindata);
				args.setValString("fileName",fileName);
                ics.CallElement("fatwire/ui/util/ValidateFileUpload", args);
                args.removeAll();
                if(!Boolean.parseBoolean(ics.GetVar("fileValidated"))){
					throw new ValidationException("File Upload could not be validated");	
				}
			}
		}
	}
	if (null != bytes && null != maxWidth && null != minWidth && null != maxHeight && null != minHeight) {
		if (!base64Encoded) {
			String imgDimensions = "";
			int imageWidth = -1;
			int imageHeight = -1;
			FTVAL bindata = ics.GetCgi(fieldName);
			String fileType = ImageUtil.getImageFormat(bytes);
			if (fileType != null)
				imgDimensions = ImageUtil.getImageDimensions(bytes);
			try
			{	
				int i = 0;		
				if(!imgDimensions.equals("") && imgDimensions.contains("x")) {
					for(String str : imgDimensions.split("x")) {
						if(i == 0)
							imageWidth = Integer.parseInt(str.trim());
						else
							imageHeight = Integer.parseInt(str.trim());
						i++;	
					}
				}
			}
			catch(Exception e)
			{
				throw e;
			}
			if (imageWidth > 0 && Integer.parseInt(maxWidth.trim()) > 0 && imageWidth > Integer.parseInt(maxWidth.trim())){
				builder.append("{\"cause\":\"Uploaded image width exceeded than maximum width set.\", ");
				builder.append("\"uploadvalid\":\"failed\"}");
				isValidImgDimensions = "false";
			}
			if (imageWidth > 0 && Integer.parseInt(minWidth.trim()) > 0 && imageWidth < Integer.parseInt(minWidth.trim())){
				builder.append("{\"cause\":\"Uploaded image width should be more than minimum width set.\", ");
				builder.append("\"uploadvalid\":\"failed\"}");
				isValidImgDimensions = "false";
			}
			if (imageHeight > 0 && Integer.parseInt(maxHeight.trim()) > 0 && imageHeight > Integer.parseInt(maxHeight.trim())){
				builder.append("{\"cause\":\"Uploaded image height exceeded than maximum width set.\", ");
				builder.append("\"uploadvalid\":\"failed\"}");
				isValidImgDimensions = "false";
			}
			if (imageHeight > 0 && Integer.parseInt(minHeight.trim()) > 0 &&  imageHeight < Integer.parseInt(minHeight.trim())){
				builder.append("{\"cause\":\"Uploaded image height should be more than minimum height set.\", ");
				builder.append("\"uploadvalid\":\"failed\"}");
				isValidImgDimensions = "false";
			}
		}
	}	
	if (!"false".equalsIgnoreCase(isValidImgDimensions)) {
		try 
		{
			Session ses = SessionFactory.getSession();
			if(fileName != null)
			{				
				// Single file upload		
				long objectId = InsiteUtil.uploadToTempObjects(ics,uploadtoken,identifier,fieldName,fileName , base64Encoded);
				if(objectId > 0 && objectId != 01)
				{
					fileNameIdMap.put(fileName , objectId);
				}
			} else
			{
				
				// May be multi file upload
				fileName = ics.GetVar(fieldName + "0_file");
				if(fileName != null)
				{
					// Yes it is multifile Upload
					for(int count= 0; (fileName = ics.GetVar(fieldName + count + "_file")) != null; count ++)
					{
						long objectId = InsiteUtil.uploadToTempObjects(ics, uploadtoken,identifier,fieldName + count,fileName ,base64Encoded);
						if(objectId > 0)
						{
							fileNameIdMap.put(fileName , objectId);
						}
					}
				}	
			} 
		} catch (Exception e)
		{
			// Service will throw exception if the user is invalid. Service will log the message.We don't have to do anything here.
		}
		if(uploaderType.equals("html")) {
			builder.append("<html><textarea>");
		}
		if(fileNameIdMap.size() > 0)
		{
			Iterator iterator = fileNameIdMap.entrySet().iterator();       
			int counter = 0;
			while(iterator.hasNext())
			{
				if(counter != 0)
				{
					builder.append(",");
				}
				Map.Entry entry = (Entry) iterator.next();
				fileName = (String)entry.getKey();
				Long tempObjectId = (Long)entry.getValue();
				BlobAddressImpl blobAddress = new BlobAddressImpl("TempObjects", "id",tempObjectId, "urldata");
				BlobObjectImpl blobObject =  new BlobObjectImpl(fileName, null, null, blobAddress);
				builder.append("{\"tempObjectId\":\"").append(tempObjectId)  
						.append("\", \"filename\": \"").append(fileName) 
						.append("\", \"blobURL\":\"").append(BlobUtil.getBlobUrl(ics, blobObject, null));
				String _fileType = StringUtils.defaultString(BlobUtil.getContentTypeFromName(ics,fileName),"unknown");
				if (_fileType.contains("image")) {
					byte[] imageBytes = BlobUtil.getURLColumnBytes(ics, "TempObjects", "urldata", String.valueOf(tempObjectId));
					builder.append("\", \"dimension\":\"").append(ImageUtil.getImageDimensions(imageBytes));
				}
				builder.append("\", \"filetype\":\"").append(_fileType);
				builder.append("\", \"uploadstatus\":\"success\"").append("}");
				counter ++;
			}
		} 
		else 
		{
			builder.append("{\"uploadstatus\":\"failed\"}");
		}
		if(uploaderType.equals("html")) {
			builder.append("</textarea></html>");
		}
	}
	else 
	{
		Session ses = SessionFactory.getSession();
		try {
			InsiteUtil.validateUser(ics, uploadtoken, identifier);		
		}
		catch(Exception ex){
			// Service will throw exception if the user is invalid. Service will log the message.We don't have to do anything here.
		}
	}	
%>
<%=builder.toString()%>
</cs:ftcs>