<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternUICSS
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<style>
.fw .form .row {
    padding-top: 30px !important;
}
.webRefPattern .form  {
	width: auto;
	min-width: 960px;
	float: none;
	margin-right: 20px;
}
.webRefPattern .UITextarea textarea {
	resize: vertical;
}
.webRefPattern .dojoxGrid {
	margin: 0 !important;
}
.webRefPattern .dojoxGridCell {
	line-height: normal;
}
.webRefTabContainer {
	border: 1px solid #ddd;
	padding: 1px;
}
.webRefTabContainer .dijitContentPaneSingleChild {
	overflow-y: auto;
}
.webRefPattern h3 {
	font-size: 14px;
	border-bottom: 1px dashed #b9b9b9;
	padding-bottom: 12px;
	margin-top: 0;
}
.helptext {
	font-size: 9px;	
}
.webRefPattern .msgBoxWrapper {
	display: none;
	margin-bottom: 20px;
}
.webRefPattern .icon-img {
	display: inline-block;
	height: 18px;
	width: 18px;
	background: url("<%=ics.GetVar("cs_imagedir")%>/../Xcelerate/graphics/common/msg/info.png") no-repeat;
}
.webRefPattern .message-error .icon-img {
	background-image: url("<%=ics.GetVar("cs_imagedir")%>/../Xcelerate/graphics/common/msg/error.png");
}
.webRefPattern .message-warning .icon-img {
	background-image: url("<%=ics.GetVar("cs_imagedir")%>/../Xcelerate/graphics/common/msg/warning.png");
}
.webRefPattern .dijitTextBox {
	width: 400px !important;
}
.webRefPattern .argContentPane .dijitTextBox {
	width: 10em;
}
.tabButtonPane .dijitButton {
	background: url("<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/tree/tabBg.png") repeat-x;
	height: 31px;
	margin: 0 1px 1px;
	border: 1px solid #c5c5c5;
	display: block;
}
.tabButtonPane .dijitButtonNode {
	border: 0;
	padding: 8px 12px 0;
	text-align: left;
	display: block;
	height: 23px;
}
.tabButtonPane .dijitButtonText {
	color: #000;
	font-weight: bold;
}
.tabButtonPane .dijitButtonSelected  {
	background: url("<%=ics.GetVar("cs_imagedir")%>/../js/fw/images/ui/tree/tabBgActive.png") repeat-x;
	border: 1px solid #435b7f;
}
.tabButtonPane .dijitButtonSelected .dijitButtonText {
	color: #fff;
}
.webRefPattern .searchContainer .dojoxGridMasterMessages {
	width: 100%;
	padding-top: 20px;
	top: -2px !important;
}
.webRefFunction {
	padding: 10px;
}
.fw li.defaultMenuItem {
    font-style: italic;
}
.fw .dijitInputInner.defaultMenuItem {
    font-style: italic;
}
.webRefPattern .buttonsrow {
	margin: 5px 0 0;
}
.webRefPattern .form label {
	width: 150px;
	vertical-align: top;
	padding: 0 20px 0 20px;
	display: inline-block;
	float: none;
}
.webRefPattern .form .argContentPane label {
	width: 110px;
}

.fw .argContentPane {
    display: inline-block;
    margin-left: 31px;
    margin-top: 20px;
}
</style>
</cs:ftcs>