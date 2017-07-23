<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<assetset:setasset name="fetchPriceDateAssetDetails" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' /> 
	<assetset:getattributevalues name="fetchPriceDateAssetDetails" typename="Practice_A" attribute="practice_title" listvarname="titleList"/>
	<assetset:getattributevalues name="fetchPriceDateAssetDetails" typename="Practice_A" attribute="practice_price" listvarname="priceList"/>
	<assetset:getattributevalues name="fetchPriceDateAssetDetails" typename="Practice_A" attribute="practice_date" listvarname="dateList"/>
	<div class="col-sm-12">
		<ics:setvar name="context" value='<%=ics.GetVar("c")+":DatePrice:"+ics.GetVar("cid") %>'/>
		Context Date-Price Edit: <ics:getvar name="context"/>
	</div>
	<div class="col-sm-4">
		<strong>
			Title: <insite:edit field="practice_title" list="titleList" column="value" params="{noValueIndicator: '[ Enter title here ]', width: '50%', regExp: '[a-zA-Z][a-zA-Z ]+[a-zA-Z]$', invalidMessage: 'only alphabets allowed'}" />
		</strong>
	</div>
	<div class="col-sm-4">
		<strong>
			Price: <insite:edit field="practice_price" list="priceList" column="value" params="{constraints: {fractional: true}, width: '50%', invalidMessage: 'Price must include cents', noValueIndicator: '[ Enter price here ]'}" />
		</strong>
	</div>	
	<ics:listget fieldname="value" listname="dateList" output="postDate"/>
	<dateformat:create name="df" datestyle="long" timestyle="long" timezoneid="IST"/>
	<dateformat:getdatetime name="df" varname="formattedDate" valuetype="jdbcdate" value='<%=ics.GetVar("postDate") %>' />
	<div class="col-sm-4">
		<strong>
			Date: <insite:edit field="practice_date" value='<%=ics.GetVar("formattedDate") %>' params="{width: '50%', noValueIndicator: '[ Enter date-time here ]',constraints:{formatLength: 'long'}, timePicker:true, timeZoneID:'IST'}"/>
		</strong>
	</div>
</cs:ftcs>