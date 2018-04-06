<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%
//
// OpenMarket/Gator/AttributeTypes/DisplayIMAGEFILE
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList,
				COM.FutureTense.Interfaces.ICS,
				COM.FutureTense.Interfaces.IList,
				COM.FutureTense.Interfaces.Utilities,
				COM.FutureTense.Util.ftErrors,
				COM.FutureTense.Util.ftMessage,
				javax.imageio.ImageIO,
				javax.swing.ImageIcon,
				java.awt.Image,
				java.awt.image.RenderedImage,
				java.net.URL,
				java.io.OutputStream,
				java.io.ByteArrayOutputStream,
				org.apache.commons.io.FileUtils"
%><cs:ftcs>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ASSETTYPENAME"/>
</ics:callelement>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ATTRIBUTETYPENAME"/>
</ics:callelement>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ATTRIBUTENAME"/>
</ics:callelement>


<ics:setvar name="doDefaultDisplay" value="no"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
<td></td>
<td>
<ics:if condition='<%=ics.GetList("AttrValueList",false)!=null && ics.GetList("AttrValueList",false).hasData()%>'>
<ics:then>

<div class='FormUploader'>
<% ics.SetVar("imgPickerValueJSON", "{"); %>
	<ics:listget listname="AttrValueList" fieldname="#numRows" output="avlNumRows"/>
	<ics:listloop listname="AttrValueList">
		<ics:listget listname="AttrValueList" fieldname="#curRow" output="avlCurRow"/>
		<assetset:setasset name="theImage" type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' id='<%=(ics.GetList("AttrValueList",false).getValue("value"))%>' />
		<assetset:getattributevalues name="theImage" attribute='<%=ics.GetVar("ATTRIBUTENAMEOUT")%>' listvarname="imageList" typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>' />
		<ics:listget listname="imageList" fieldname="value" output="imageId" />
		
		<asset:load name='ImgPickerAsset' type='<%=ics.GetVar("ASSETTYPENAMEOUT")%>' objectid='<%=(ics.GetList("AttrValueList",false).getValue("value"))%>' />
		<asset:scatter name="ImgPickerAsset" prefix="ipa" fieldlist="name"/>
		<% ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON")  + "'" + ics.GetVar("avlCurRow")+ "': { 'filename': '" + ics.GetVar("ipa:name") + "' "); %>

		<div class='UploaderMainDiv'>
			<satellite:blob blobtable="MungoBlobs" blobcol="urldata" blobkey="id" csblobid='<%=ics.GetSSVar("csblobid")%>' blobwhere='<%=ics.GetVar("imageId")%>' container="servlet" outstring='imgbloburl'>
				<satellite:parameter name="BORDER" value="0"/>
				<satellite:parameter name="WIDTH" value="100"/>
			</satellite:blob>
			<%
			URL url = new URL(request.getScheme(),request.getServerName(),request.getServerPort(),ics.GetVar("imgbloburl"));
			Image image = ImageIO.read(url);
			String imgDimension = "";
			String filesize = "";
			String filename = ics.GetVar("ipa:name");
			int _imgWidth = 0;
			int _imgHeight = 0;
			if(image != null){
				ImageIcon icon = new ImageIcon(image);
				imgDimension = icon.getIconWidth() + " x " + icon.getIconHeight() + " pixels";
				if (icon.getIconWidth() > 0)
					_imgWidth = icon.getIconWidth();					
				if (icon.getIconHeight() > 0)	
					_imgHeight = icon.getIconHeight();			
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ImageIO.write((RenderedImage)image, filename.substring(filename.lastIndexOf('.') + 1), baos);
				byte[] imageInBytes = baos.toByteArray();
				filesize = FileUtils.byteCountToDisplaySize(imageInBytes.length);
			}
			ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON")  + ", 'dimension': '" + imgDimension + "' ");
			ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON")  + ", 'size': '" + filesize + "' ");
			
			%>
			<div class='UploadFileDivInspect' name='imgPickerValue_<%= ics.GetVar("AttrName") %>_<%= ics.GetVar("avlCurRow") %>'>
				<img src='<%= ics.GetVar("imgbloburl") %>' data-dojo-type='fw.dijit.UILightbox' data-dojo-props="title:'<%= ics.GetVar("ipa:name") %>', href:'<%=ics.GetVar("imgbloburl")%>'" style='<%= _imgWidth > _imgHeight ? "width" : "height" %>:96px;'/>
			</div>
		</div>
		<%
		if (ics.GetVar("avlNumRows").equals(ics.GetVar("avlCurRow")))
			ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON") + "} ");
		else
			ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON") + "}, ");
		%>
	</ics:listloop>
<% ics.SetVar("imgPickerValueJSON", ics.GetVar("imgPickerValueJSON") + "}"); %>	


</div>
</ics:then>
</ics:if>
</td>
</tr>

<ics:callelement element="OpenMarket/Gator/Scripts/ApplyIconsAndTooltip">
	<ics:argument name="AttrName" value='<%= ics.GetVar("AttrName") %>' />
	<ics:argument name="fileInfoJSON" value='<%= ics.GetVar("imgPickerValueJSON") %>' />
	<ics:argument name="divNamePrefix" value='imgPickerValue_' />
</ics:callelement>
</cs:ftcs>