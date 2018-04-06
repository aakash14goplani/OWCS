<%@page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" 
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<div class="col-sm-12">
		<ics:setvar name="context" value='<%=ics.GetVar("c")+":InSiteEdit:"+ics.GetVar("cid") %>'/>
		Context Insite Edit: <ics:getvar name="context"/>
	</div>
	<assetset:setasset name="loadPracticeAsset" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>'/>	
	
	<%-- Edit Title --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="titleList" attribute="practice_title" typename="Practice_A"/>
	<%-- regular exp. to accept only alphabets with spaces in-between them --%>
	<div class="col-sm-6">
		<strong>
			<insite:edit field="practice_title" list="titleList" column="value" params="{noValueIndicator: '[ Enter id here ]', width: '300px', regExp: '[a-zA-Z][a-zA-Z ]+[a-zA-Z]$', invalidMessage: 'only alphabets allowed'}" />
		</strong>
	</div>
	
	<%-- Edit ID --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="IdList" attribute="practice_id" typename="Practice_A"/>
	<%-- METHOD-1 : code includes adding, removing, and reordering values --%>
	<insite:list field="practice_id" assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>'>
	  <div class="col-sm-3">
	  	<ics:listloop listname="IdList">	  	
	    	<insite:edit list="IdList" column="value" params="{noValueIndicator: '[ Enter id here ]'}"/>
	  	</ics:listloop>
	  </div>
	</insite:list>
	<%-- METHOD-2 : code just enables to edit every text list --%>
	<div class="col-sm-3">
		<ics:listloop listname="IdList">
		   <ics:listget listname="IdList" fieldname="#curRow" output="currentRowNb" />
		   <insite:edit assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>' field="practice_id" list="IdList" column="value" index='<%=ics.GetVar("currentRowNb")%>' params="{noValueIndicator: '[ Enter id here ]'}" />
	  	</ics:listloop>
  	</div>
	
	<%-- Edit money --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="priceList" attribute="practice_price" typename="Practice_A"/>
	<%-- METHOD-1 --%>
	<%-- constraints : digits should have fractions and max limit should be equal to or less than 10000.00 --%>
	<div class="col-sm-6">
		<strong>
			<insite:edit field="practice_price" list="priceList" column="value" params="{constraints: {fractional: true, max: 10000.00}, invalidMessage: 'Price must include cents', noValueIndicator: '[ Enter id here ]'}" />
		</strong>
	</div>
	
	<%-- METHOD-2 --%>
	<%-- <ics:listget fieldname="value" listname="priceList" output="price"/>
	<currency:create name="curname" isocurrency="INR" separator="comma"/> seperator = comma|dot|default
	<currency:getcurrency name="curname" value="price" varname='curout'/>
	<insite:edit field="practice_price" value='<%=ics.GetVar("curout")%>' params="{noValueIndicator: '[ Enter price here currency ]', currency:'INR'}"/>  --%>

	<%-- METHOD-3 --%>
	<%-- <ics:listget fieldname="value" listname="priceList" output="price"/>
	<fmt:formatNumber type="currency" value='<%=ics.GetVar("price")%>' var="formattedValue" currencySymbol="&inr;" /> 
	The price is: <insite:edit field="practice_price" value="${formattedValue}" params="{noValueIndicator: '[ Enter price here fmt ]', currency: 'INR'}" /> --%>
	
	<%-- Edit date-time --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="dateList" attribute="practice_date" typename="Practice_A"/>
	<ics:listget fieldname="value" listname="dateList" output="postDate"/>
	<dateformat:create name="df" datestyle="long" timestyle="long" timezoneid="IST"/>
	<%-- for timestamp use getdatetime else use getdate --%>
	<dateformat:getdatetime name="df" varname="formattedDate" valuetype="jdbcdate" value='<%=ics.GetVar("postDate") %>' />
	<div class="col-sm-6">
		<strong>
			<insite:edit field="practice_date" value='<%=ics.GetVar("formattedDate") %>' params="{noValueIndicator: '[ Enter time here ]',constraints:{formatLength: 'long'}, timePicker:true, timeZoneID:'IST'}"/>
		</strong>
	</div>
	
	<%-- Edit ckeditor --%>
  	<assetset:getattributevalues name="loadPracticeAsset" listvarname="bodyTextList" attribute="body_text" typename="Practice_A"/>
  	<ics:listget listname="bodyTextList" fieldname="value" output="BodyText" />
  	<div class="col-sm-6">
		<strong>
			<insite:edit field="body_text" variable="BodyText" editor="ckeditor" params="{noValueIndicator: '[ Enter body here ]', width: '100%'}" />
		</strong>
	</div>
	
	<%-- Edit blob --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="imageList" attribute="practice_image" typename="Practice_A"/>
	<render:getbloburl outstr="imageURL" c='<%=ics.GetVar("c")%>' cid='<%=ics.GetVar("cid")%>' field="practice_image"/><% 
	String imageWidth = Utilities.goodString(ics.GetVar("image-width")) ? ics.GetVar("image-width") : "300px";
	%><div class="col-sm-6">
		<insite:edit field="practice_image" assetid='<%=ics.GetVar("cid")%>' assettype='<%=ics.GetVar("c")%>' list="imageList" column="value" >
	  		<img src='<%=ics.GetVar("imageURL")%>' width="<%=imageWidth%>" height="auto" />
		</insite:edit>
	</div>
	
	<%-- Edit asset --%>
	<assetset:getattributevalues name="loadPracticeAsset" listvarname="assetList" attribute="practice_assets" typename="Practice_A"/>
	<%-- <ics:listloop listname="assetList">
	    <ics:listget fieldname="value" listname="assetList"/><br/>
	</ics:listloop>
	<br/> --%>
	<div class="col-sm-12">
		<insite:slotlist field="practice_assets" slotname="AssetDropzone_2">
		  	<ics:listloop listname="assetList">
		    	<ics:listget listname="assetList" fieldname="value" output="articleId" />
		    	<asset:load name="loadCurrentAsset" type="Practice_C" objectid='<%=ics.GetVar("articleId")%>'/>
		    	<asset:get name="loadCurrentAsset" field="template" output="templateName" />
		    	<insite:calltemplate tname='<%=ics.GetVar("templateName")%>' c="Practice_C" cid='<%=ics.GetVar("articleId")%>' />
		  	</ics:listloop>
		</insite:slotlist>
	</div>
</cs:ftcs>