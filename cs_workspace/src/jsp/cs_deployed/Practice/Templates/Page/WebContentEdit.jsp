<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
	<html>
		<head>
			<link href="/cs/Practice_Site/styles/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<div class="container">
				<div class="row">
					<div class="col-sm-12">
						<ics:setvar name="context" value='<%=ics.GetVar("c")+":"+ics.GetVar("cid")+":WebContentEditing" %>'/>
						Context Presentation Edit: <ics:getvar name="context"/>
					</div>
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Content Editable Dropzone</h2><hr/>
					<insite:calltemplate site="Practice" tname="ContentEditableDropzone" clegal="Practice_C:practice_asset_dropzone" slotname="ContentEditableDropzone121" emptytext="Practice Asset Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">In-Site Drop Zone</h2><hr/>
					<insite:calltemplate site="Practice" tname="InSiteEdit" clegal="Practice_C:insite_edit" slotname="InsiteDropZone121" emptytext="In-Site Edit Asset Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Body Text Drop Zone</h2><hr/>
					<insite:calltemplate site="Practice" tname="RenderBodyText" clegal="Practice_C:practice_body_text" slotname="BodyTextDropzone142" emptytext="Body Text Asset Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Price-Date Drop Zone</h2><hr/>
					<insite:calltemplate site="Practice" tname="RenderPriceDate" clegal="Practice_C:practice_date_price" slotname="PriceDateDropzone421" emptytext="Price Date Asset Dropzone" />
				</div>
				<div class="row">
					<hr/><h2 class="text-center">Image Drop Zone</h2><hr/>
					<insite:calltemplate site="Practice" tname="RenderImage" clegal="ImageAsset" slotname="ImageDropzone985" emptytext="ImageAsset Dropzone" />
				</div>
			</div>
		</body>
	</html>
</cs:ftcs>