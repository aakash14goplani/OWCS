
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/DisplayIMAGEEDITOR
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.FTVAL" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.gator.common.FileValue2StringList"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.awt.Image" %>
<%@ page import="java.io.File" %>
<%!
String formatBytes(long size)
{
    NumberFormat formatter = new DecimalFormat("#0.00 KB");                                       
    return formatter.format( size / 1024d );                    
}

boolean getDimensions(ICS ics, String widthVar, String heightVar, String sizeVar, String pathVar)
{
    Image image = null;
    int width = 0;
    int height = 0;
    try
    {  
    	if (ics.GetVar(pathVar) != null)
	{
		File blobFile = new File(ics.GetVar(pathVar));
	        ics.SetVar(sizeVar, formatBytes(blobFile.length()));
		image = ImageIO.read(blobFile);                    
        	width = image.getWidth(null);
	        height = image.getHeight(null);        
	        ics.SetVar(widthVar, String.valueOf(width));
	        ics.SetVar(heightVar, String.valueOf(height));
        }
    }
    catch(Exception e)
    {
        ics.LogMsg(e.toString() + " (" + ics.GetVar(pathVar) + ")");
    }            
    return (width <= height); // returns true/false for portrait/landscape
}
%>

<cs:ftcs>

<%
ics.SetVar("doDefaultDisplay","no");
ics.RemoveVar("_imgAttr");
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>
	<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
	<td></td>
	<td>

<% ics.SetVar("imgEditorValueJSON", "{"); %>
	

<%

if (ics.GetList("AttrValueList",false)!=null && ics.GetList("AttrValueList",false).hasData())
{
%>
<div class='FormUploader'>
<%	
	FileValue2StringList fList=(FileValue2StringList)ics.GetList("AttrValueList",false);
	String revision = ics.GetVar("Revision");
%>
		<ics:listget listname="AttrValueList" fieldname="#numRows" output="avlNumRows"/>
		<ics:listloop listname="AttrValueList">
		<ics:listget listname="AttrValueList" fieldname="#curRow" output="avlCurRow"/>
<%
		FTVAL ftVal = fList.getFileContents("urlvalue");
		ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'" + ics.GetVar("avlCurRow") + "': { ");
%>		
			<ics:listget listname="AttrValueList" fieldname="urlvalue" output="urlvalue"/>
			<ics:setvar name="blobpath" value='<%=ftVal.getFile()%>' />                
<%
	boolean isPortrait = getDimensions(ics, "width", "height", "size", "blobpath");
	String urlValue = ics.GetVar("urlvalue");
	String fileName = "";
	if (urlValue != null)
	{
		int lastIndex = urlValue.lastIndexOf(java.io.File.separator);
		fileName = urlValue.substring(lastIndex+1);
	}        
%>      
			<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DetermineFileType">
				<ics:argument name="filename" value="<%=fileName %>" />
			</ics:callelement> 
<%
	ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'filename': '" + fileName + "', ");
%>
			<div class='UploaderMainDiv'>
				
<%-- 				<span style="font-weight:bold;display: block;"><%=fileName%></span>        
 					<span style="display:block;">Dimensions:--%> 
<%
	if (Utilities.goodString(ics.GetVar("width")) && Utilities.goodString(ics.GetVar("height")))
	{
%>
						<%-- <ics:getvar name="width" /> x <ics:getvar name="height" /> --%>
<%
		ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'dimension': '" + ics.GetVar("width") + "x" + ics.GetVar("height") + "', ");
		if (Integer.parseInt(ics.GetVar("width")) > Integer.parseInt(ics.GetVar("height"))) {
			ics.SetVar("_imgAttr", "width");
		} else {
			ics.SetVar("_imgAttr", "height");
		}

	}
	else
	{
		ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'dimension': 'Unknown', ");
%>
						<!-- Unknown -->
<%
	}
%>
<%--
					</span>
					<span style="display:block;">Size: <ics:getvar name="size"/></span>        
					<span style="display:block;">Type: <ics:getvar name="filetype"/></span>
 --%>                
				<div class='UploadFileDivInspect' name='imgEditorValue_<%= ics.GetVar("AttrName") %>_<%= ics.GetVar("avlCurRow") %>'>
<%
ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'size': '" + ics.GetVar("size") + "', ");
ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "'filetype': '" + ics.GetVar("filetype") + "'");

	if ("true".equals(ics.GetVar("displayable")))
	{
%>

<%
		if (revision == null || revision.length() == 0)
		{
			String svar="select id,filevalue,foldervalue from MungoBlobs where urldata='" +  ics.GetVar("urlvalue") + "'";
%>
					<ics:sql sql='<%=svar%>' listname="blob" table="MungoBlobs" />

        
					<ics:listget listname="blob" fieldname="id" output="imageId"/>
					<ics:listget listname="blob" fieldname="foldervalue" output="foldervalue"/>
        
					<satellite:blob blobtable="MungoBlobs" blobcol="urldata" blobkey="id" blobwhere='<%=ics.GetVar("imageId")%>' container="servlet" outstring="imgbloburl">
						<satellite:parameter name="border" value="0"/>                    
						<satellite:parameter name='<%=(isPortrait?"height":"width")%>' value="100"/>
					</satellite:blob>
					<img src='<%= ics.GetVar("imgbloburl") %>' data-dojo-type='fw.dijit.UILightbox' data-dojo-props="title:'<%= fileName %>', href:'<%=ics.GetVar("imgbloburl")%>'" style='<%= ics.GetVar("_imgAttr")%>: 96px;'/>					
<%
		}
		else
		{
			// There's a revision number.  The image will need to be displayed using StreamBinary or the equivalent.
			// Now, the problem is that the asset must be loaded when the generated link to the image is followed by the browser.
			// StreamBinary does this load.
			//
			// But in order to display the correct image, StreamBinary must know exactly how to
			// reach the image on the other end.  For a single-valued attribute this is straightforward: you need the
			// asset type, asset id, revision, and attribute id, and that's all.  For a multivalued attribute, there's nothing
			// really perfect for locating the correct value.  Doing it by position is a possibility, although that presumes that the
			// two asset loads will in fact do exactly the same thing both times.  An alternative is to use the filename part of the urlvalue
			// and hope that the same filename only exists in the multivalue list only once.
			//
			// For now, I've opted to send along the file name.  If that works, it's likely to be less problem-prone than the instance number,
			// except in pathological cases.
%>
					<satellite:link assembler="query" outstring="referURL" pagename="OpenMarket/Xcelerate/Util/StreamBinary">
						<satellite:parameter name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:parameter name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:parameter name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
						<satellite:parameter name="assetid" value='<%=ics.GetVar("id")%>'/>
						<satellite:parameter name="attrid" value='<%=ics.GetVar("AttrID")%>'/>
						<satellite:parameter name="mimetype" value='<%=ics.GetVar("filetype")%>'/>
						<satellite:parameter name="filename" value='<%=urlValue%>'/>
						<satellite:parameter name="Revision" value='<%=ics.GetVar("Revision")%>'/>
						<satellite:parameter name="filterId" value='<%=ics.GetVar("filterId")%>'/>
					</satellite:link>
					<img src='<%=ics.GetVar("referURL")%>' dojoType='fw.dijit.UILightbox' title='<%= fileName %>' href='<%=ics.GetVar("referURL")%>' border="0" <%=(isPortrait?"height":"width")+"=\"100\""%>/>
<%
		}
%>
<%
	}
%>
			</div>
			</div>
<%
	if (ics.GetVar("avlNumRows").equals(ics.GetVar("avlCurRow")))
		ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "} ");
	else
		ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "}, ");

%>		
		</ics:listloop>
<%
	ics.SetVar("imgEditorValueJSON", ics.GetVar("imgEditorValueJSON") + "}");
%>
</div>
<%
}
%>

	</td>
</tr>

<ics:callelement element="OpenMarket/Gator/Scripts/ApplyIconsAndTooltip">
	<ics:argument name="AttrName" value='<%= ics.GetVar("AttrName") %>' />
	<ics:argument name="fileInfoJSON" value='<%= ics.GetVar("imgEditorValueJSON") %>' />
	<ics:argument name="divNamePrefix" value='imgEditorValue_' />
</ics:callelement> 
</cs:ftcs>