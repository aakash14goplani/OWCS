<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" %>
<%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" %>
<%@ taglib prefix="url" uri="futuretense_cs/url.tld" %>

<%@ page import="com.fatwire.util.BlobUtil"%>


<%//
// OpenMarket/Gator/FlexibleAssets/Common/DisplayCKEditorURLValue
//
// INPUT
//
// OUTPUT
//%>

<%@ page import="com.openmarket.xcelerate.publish.EmbeddedLink" %>
<cs:ftcs>
<%
	String urlValue = ics.GetVar("attrListUrlValue");
	int last = urlValue.lastIndexOf(java.io.File.separator);
	String fileName = urlValue.substring(last + 1);
	String fileType = BlobUtil.getContentTypeFromName(ics, fileName);
%>

	<ics:if condition='<%="url".equals(ics.GetVar("curType"))%>'>
	<ics:then>
		<ics:setvar name="tablename" value='<%=ics.GetVar("AssetType") + "_Mungo" %>'/>
		<ics:setvar name="errno" value="0"/>
		<%
		//Url is not supported for multiple values so no need to provide the ordinal condition
		String sql = "SELECT id FROM "+ ics.GetVar("tablename") + " WHERE cs_ownerid=" + ics.GetVar("id") + " AND cs_attrid=" + ics.GetVar("curAssetId");
		//Following code is needed incase url supports the multi value.
		/*if(!"single".equals(ics.GetVar("EditingStyle")))	
			sql = sql + " AND cs_ordinal=" + ics.GetList("AttrValueList").currentRow();*/
		%>
		<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
			<ics:argument name = "val_variable" value ='<%=ics.GetVar("id")%>'/>
			<ics:argument name = "dataType" value ="long"/>
		</ics:callelement>
		<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	    <ics:then>
			<ics:callelement element='OpenMarket/Xcelerate/Util/ValidateData'>
				<ics:argument name = "val_variable" value ='<%=ics.GetVar("curAssetId")%>'/>
				<ics:argument name = "dataType" value ="long"/>
			</ics:callelement>
			<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
 	        <ics:then>
				<ics:sql sql='<%=sql%>' listname="_BlobidList" table='<%=ics.GetVar("tablename")%>' />
			</ics:then>
			</ics:if>
		</ics:then>
		</ics:if>
		<ics:setvar name='<%="BLOBID_" + ics.GetList("AttrValueList").getValue("urlvalue") %>' value='<%=ics.GetList("_BlobidList").getValue("id")%>'/>
		<ics:setvar name="blobtable" value='<%=ics.GetVar("tablename")%>'/>
		<ics:setvar name="blobkey" value="id"/>
		<ics:setvar name="blobwhere" value='<%=ics.GetList("_BlobidList").getValue("id")%>'/>
		<ics:setvar name="blobcol" value="urlvalue"/>
	</ics:then>
	<ics:else>
		<assetset:setasset name="as" type='<%= ics.GetVar("AssetType") %>' id='<%= ics.GetVar("id") %>'/>
		<assetset:getattributevalues name="as" typename='<%=ics.GetVar("attributetype")%>' attribute='<%=ics.GetVar("curName")%>' listvarname="blobidlist" />
		<ics:listloop listname="blobidlist">
			<ics:listget listname="blobidlist" fieldname="value" output="blobid" />
			<blobservice:readdata id='<%=ics.GetVar("blobid")%>' listvarname="bloburldatalist" />
			<ics:listget listname="bloburldatalist" fieldname="urldata" output="bloburldata"/>
			<%
				if (urlValue != null && urlValue.equals(ics.GetVar("bloburldata")))
				{
					ics.SetVar("blobwhere", ics.GetVar("blobid"));
				}
			%>
		</ics:listloop>
		<ics:setvar name="tablename" value='MungoBlobs'/>
		<ics:setvar name="blobcol" value="urldata"/>
	</ics:else>
	</ics:if>
	<url:unpack value='%0D%0A' varname='CRLF'/>
	<url:pack value='<%= fileName %>' varname='encodedFileName'/>
	<url:pack value='<%= fileType %>' varname='packedCT'/>
	<ics:setvar name="bheadcontent-type" value='<%= ics.GetVar("packedCT") %>'/>
	<% String headContentDisposition = "attachment; filename=" + ics.GetVar("encodedFileName"); %>		
	<ics:setvar name="bheadContent-Disposition" value='<%= headContentDisposition %>'/>
	<ics:setvar name="bheadMDT-Type" value='abinary; charset=UTF-8'/>
	
	<satellite:blob assembler="query"
		blobtable='<%=ics.GetVar("tablename")%>'
		blobkey='id'
		blobwhere='<%=ics.GetVar("blobwhere")%>'
		blobcol='<%=ics.GetVar("blobcol")%>'
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		blobnocache='true'
		outstring="textbloburl">
		<satellite:parameter name='blobheadername1' value='content-type'/>
		<satellite:parameter name='blobheadervalue1' value='<%= ics.GetVar("bheadcontent-type") %>'/>
		
		<satellite:parameter name='blobheadername2' value='Content-Disposition'/>
		<satellite:parameter name='blobheadervalue2' value='<%= ics.GetVar("bheadContent-Disposition") %>'/>
		
		<satellite:parameter name='blobheadername3' value='MDT-Type'/>
		<satellite:parameter name='blobheadervalue3' value='<%= ics.GetVar("bheadMDT-Type") %>'/>	
	</satellite:blob>
	
	<a href='<%= ics.GetVar("textbloburl") %>'>
		<img src='' name='iconImg'/>
	</a>

</cs:ftcs>