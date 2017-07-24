<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>

	<assetset:setasset name="loadPracticeAsset" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>'/>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="titleList" attribute="practice_title" typename="WebContent_A"/>
	<h1>title from asset : <ics:listget fieldname="value" listname="titleList"/></h1>	
	<h1>title from insite : <insite:edit field="practice_title" list="titleList" column="value" params="{width: '300px', regExp: '[a-zA-Z][a-zA-Z ]+[a-zA-Z]$', invalidMessage: 'only alphabets allowed'}" /></h1>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="bodyTextList" attribute="body_text" typename="WebContent_A"/>
	<h3>body text from asset : <ics:listget fieldname="value" listname="bodyTextList"/></h3>
	<h3>body text from insite : 
		<insite:edit field="body_text" variable="BodyText" editor="ckeditor" params="{noValueIndicator: '[ Enter body here ]', width: '100%'}" />
	</h3>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="IdList" attribute="practice_id" typename="WebContent_A"/>
	
	<insite:list field="practice_id" assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>'>
   		<ics:listloop listname="IdList">
   			id : <insite:edit list="IdList" column="value" params="{noValueIndicator: '[ Enter price here ]'}"/> <br/>
   		</ics:listloop>
  	</insite:list>
	
	<%-- <h3>ID from asset : <ics:listget fieldname="value" listname="IdList"/></h3>
	<h3>ID from insite : 
		<insite:edit field="practice_id" list="IdList" column="value" params="{width: '300px', invalidMessage: 'only numbers allowed'}" />
	</h3> --%>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="priceList" attribute="practice_price" typename="WebContent_A"/>
	<ics:listget fieldname="value" listname="priceList" output="price"/>
	<h3>Price from asset : <%=ics.GetVar("price") %></h3>
	<h3>Price from insite : 
		<insite:edit field="practice_price" list="priceList" column="value" params="{constraints: {fractional: true, max: 10000.00}, invalidMessage: 'Price must include cents'}" />
	</h3>
	<%-- <currency:create name="curname" isocurrency="INR" separator="dot"/>
   	<currency:getcurrency varname='curout' name="curname" value="price"/>  
   	<insite:edit field="practice_price" value='<%=ics.GetVar("curout")%>' params="{noValueIndicator: '[ Enter price here ]',currency:'INR'}"/> --%>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="dateList" attribute="practice_date" typename="WebContent_A"/>
	<ics:listget fieldname="value" listname="dateList" output="postDate"/>
	<h3>Date from asset : <%=ics.GetVar("postDate") %></h3>
	<dateformat:create name="df" datestyle="long" timestyle="long" timezoneid="IST"/>
   	<dateformat:getdatetime name="df" varname="formattedDate" valuetype="jdbcdate" value='<%=ics.GetVar("postDate") %>' />
   	<h3>Date from insite : 
		<insite:edit field="practice_date" value='<%=ics.GetVar("formattedDate") %>' params="{constraints:{formatLength: 'long'}, timePicker:true, timeZoneID:'IST'}"/>
	</h3>
	
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="imageList" attribute="practice_image" typename="WebContent_A"/>
	
	<%-- single image field
		<render:getbloburl outstr="imageURL" c='<%=ics.GetVar("c")%>' cid='<%=ics.GetVar("cid")%>' field="practice_image"/>
		<h3>Image from asset : <%=ics.GetVar("img") %> => <img src='<%=ics.GetVar("imageURL") %>'> </h3>
		<h3>Image from insite :
			<insite:edit field="practice_image" assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>' list="imageList" column="value" >
		    	<img src='<%=ics.GetVar("imageURL")%>' />
		   	</insite:edit>
	  	</h3>
	--%>
	
	<ics:clearerrno/>
	<%-- multiple image fields --%>	
	<insite:list field="practice_image" assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>'>
   		<ics:listloop listname="imageList">
   			<ics:listget listname="imageList" fieldname="value" output="currentImageId" />
   			<ics:listget listname="imageList" fieldname="#curRow" output="currentRow" />
   			<blobservice:gettablename varname="tablename"/> 
			<blobservice:getidcolumn varname="columnID"/>
			<blobservice:geturlcolumn varname="columnURL"/>
			<render:getbloburl outstr="imageURL" blobtable='<%=ics.GetVar("tablename") %>' blobwhere='<%=ics.GetVar("currentImageId") %>' blobkey='<%=ics.GetVar("columnID") %>' blobcol='<%=ics.GetVar("columnURL") %>' />   			   			
   			<ics:clearerrno/>
   			<insite:edit list="imageList" column="value" index='<%=ics.GetVar("currentRow") %>' >
   				<%=ics.GetVar("imageURL")%><br/>
   				<%=ics.GetVar("currentRow")%><br/>
    			<img src='<%=ics.GetVar("imageURL")%>' />
    		</insite:edit> 
    		<br/>in-site edit error : <ics:geterrno/>
    		<br/>
   		</ics:listloop>
  	</insite:list>
  	insite-list error : <ics:geterrno/>
  	
</cs:ftcs>
