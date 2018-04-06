<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/ui/admin/user/ImageUploadHandler
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.util.ImageUtil"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.net.URI" %>
<%@ page import="java.io.*" %>
<%@ page import="com.openmarket.gator.blobservice.*"%>
<%@ page import="com.fatwire.rest.util.BeanFactory"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="java.awt.image.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="javax.imageio.stream.*" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="COM.FutureTense.Interfaces.FTVAL"%>
<cs:ftcs>
<%
String fieldName = ics.GetVar("fieldName");
String uploaderType = ics.GetVar("uploaderType");
//Get the image data and process it
byte[] imageBytes = null;
boolean isFlash = false;
boolean isHTML = false;
String imgDimensions = "";

if (uploaderType == null) 
	isFlash = true; /*Flash does not send the uploaderType variable*/
else 
	isHTML = true;
if (fieldName != null) {
	FTVAL bindata = ics.GetCgi(fieldName);
	if (bindata != null) {
		imageBytes = bindata.getBlob();			
		if(imageBytes != null){
			String fileType = ImageUtil.getImageFormat(imageBytes);
			if (fileType != null)
				imgDimensions = ImageUtil.getImageDimensions(imageBytes);
		}
	}
}

String height = ics.GetVar("imageHeight");
String width = ics.GetVar("imageWidth");
if(height == null){
	height="90";
}
if(width == null){
	width="90";
}
String imagesrc = ImageUtil.encodeBase64(imageBytes,false);
int imgHeight = Integer.parseInt(height);
int imgWidth =  Integer.parseInt(width);
if(imageBytes != null && imageBytes.length > 0){
String imgformat = ImageUtil.getImageFormat(imageBytes);
if(null != imgformat){
	String mimetype = "image/" + imgformat.toLowerCase();
	ByteArrayInputStream bis = new ByteArrayInputStream(imageBytes);
	ImageInputStream iis = ImageIO.createImageInputStream( bis);
	BufferedImage image = ImageIO.read(iis);
	byte[] thumbImg  = imageBytes;
	if(!(image.getHeight() < imgHeight && image.getWidth() < imgWidth))
		thumbImg = ImageUtil.createThumbnail(image,imgHeight,imgWidth);
	String thumbimagesrc = ImageUtil.encodeBase64(thumbImg,false); 
	String _jsonResp= null;
	StringBuilder _jsonBuilder = new StringBuilder("");
	
	//for html file uploader
	if (isHTML) {
		//[Dojo 1.6] embed HTML response properties within an additionalParams
		//property, to match behavior of Flash response.
		_jsonResp =
			"<textarea>[{ \"additionalParams\": { \"width\" : \"" + image.getWidth() +
			"\",\"height\" : \"" + image.getHeight() +
			"\",\"mimetype\" : \"" + mimetype +
			"\",\"imagesrc\" : \"" + imagesrc +
			"\",\"thumbimagesrc\" : \"" + thumbimagesrc +
			"\"} }]</textarea>"; //for HTML version
	}	
	//for flash uploader
	if(isFlash)
		_jsonBuilder.append("{\"width\":\"" + image.getWidth() + "\",\"height\":\"" + image.getHeight() + "\",\"mimetype\":\"" + mimetype + "\",\"imagesrc\":\"" + imagesrc + "\",\"thumbimagesrc\":\"" + thumbimagesrc + "\"}");
		
	if(_jsonResp != null && isHTML) out.write(_jsonResp);	
	
	if(_jsonBuilder != null && isFlash)
%>	
		<%= _jsonBuilder.toString() %>
<%		
} else {
	response.setStatus(HttpServletResponse.SC_NO_CONTENT);
} // end if (image format recognized)
} else {
	response.setStatus(HttpServletResponse.SC_NO_CONTENT);
} // end if (image has content)
%>
</cs:ftcs>

