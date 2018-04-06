<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Stylesheet
//
// INPUT
//
// OUTPUT
//
%><cs:ftcs>
<ics:setvar name="commonImagePath" value='<%=ics.GetProperty("ft.cgipath") + "images"%>' />
body {
    background-color: #eaeaea;
    font-family: verdana,arial,helvetica,sans-serif;
    margin: 0;
    padding: 0;
}
         
.username {
    font-size: 11px;            
}

.username a:link, .username a:visited, .username a:active {
    color: #333333;
    font-weight: 700;
    text-decoration: underline;
    margin-right: 3px;
    margin-left: 3px;
}
<ics:getproperty name="xcelerate.imageurl" file="futuretense_xcel.ini" output="imageurl"/>
<ics:setvar name="cs_imagedir" value='<%=ics.GetProperty("ft.cgipath") + ics.GetVar("imageurl")%>' /> 
.titlebar {
    left: 0px;
    width:100%;
    height: 24px;
    text-align: left;
    border: 0;
    background-image: url('<ics:getvar name="cs_imagedir"/>/graphics/common/controlpanel/LeftNav-header.gif') ;
}

.title-image {
  height: 24px;
  border: 0;
}

#controlPanel {
	background-color: #fff;
	overflow: auto;
	height: 100%
}

#controlPanel td {
    padding: 0;
}
#controlPanel td.topButtons{
    padding: 2px 0px 0px 16px;
}

#controlPanel img {
    border: 0;
}

#controlPanel {
    font-size: x-small;
    width: 100%;
}

/*#controlPanel #siteName {
    width: 100%;
    min-height: 30px;
    height: 30px;
    color: #fff;
    background: #eaeaea;
    background-color: #9d9d9d;
    padding: 8px 0 5px 16px;
    margin: 1px;
	font-size:11px;
}*/

#siteNameTable {
	width: 100%;
	padding: 5px;
	spacing: 0;
	font-size: 11px;
	color: #fff;
	background-color: rgb( 157,157,157 );
}

.siteNameTableSpace {
	font-size: 1px;
	line-height: 1px;
}

.highlightOn {
    background-color: #fff;
    
}

.highlightOff {
    background-color: #eaf4fd;
}

.panelSection {
    margin: 0 0 10px 0;            
}

#controlPanel td.bottomBorder{
    background-color: #6785b7;
	padding:1px 0px 3px 0px;
}

#controlPanel a.paginate {
    color: #ffffff; 
    text-decoration: underline;
}


#controlPanel td.tableHeader
{
    background-image: url('<ics:getvar name="cs_imagedir"/>/graphics/common/controlpanel/tableHeader.gif') ;
   	color:#555555;
	padding:2px 2px 2px 2px;
	font-weight:bold;
    border-top-color:#6384b7;
    border-top-style:solid;
    border-top-width:1px;
        
    border-left-color:#999999;
    border-left-style:solid;
    border-left-width:1px;
        
    border-bottom-color:#6384b7;
    border-bottom-style:solid;
    border-bottom-width:1px;
    
}
 
#controlPanel td.tableCell
{
	padding:0px 2px 0px 2px;
   	color:#333333;
    
    border-bottom-color:#e4e4e4; 
    border-bottom-style:solid;
    border-bottom-width:1px;
    				  
    border-left-color:#999999; 
    border-left-style:solid;
    border-left-width:1px;
	
}



.panelSection h3, .panelSection h3 span {
    background-color: #eaeaea;
    color: #333333;            
    text-align: left;

    font-size: x-small;
    font-weight: bold;
    margin: 0;
}
    
.panelSection h3 {
    padding: 1px 0 1px 16px;
}


.panelSection table th {
    color: #333333;
    font-size: xx-small;
    font-weight: bold;
    text-align: left;
    vertical-align: top;
    padding-left: 16px;
    padding-right: 2px;
}

.panelSection table td {            
    font-size: xx-small;
    padding-left: 16px;
}


.panelSection span {
    color: #333333;
    font-size: xx-small;            
}


a.resultItem {
  line-height: 1.8em;
  font-size: xx-small;
  color: #3358c1;
  text-decoration: none;
}			 

a.resultItem:link  {
    /*width: 100%;*/  
    text-decoration: none;
}

a.resultItem:visited {
    /*font-size: xx-small;
    width: 100%;  
    color: #3358c1;*/        
    text-decoration: none;
}

a.resultItem:hover  {
    /*width: 100%;  */
    text-decoration: underline;
}					 

a.resultItem:active {        
    text-decoration: underline;
}

.searchForm {
    margin: 0;
    padding: 0;
}
.searchForm input {
    font-size: xx-small;
}

.searchForm select {
    font-size: xx-small;
}

a.paginate {
    color: #3358c1; 
    text-decoration: none;
}

#editedAssets {
    width: 100%;                        
    margin: 0;            
    border-bottom: 1px solid #eaeaea;
}

#editedAssets td {
    border-right: 1px solid #eaeaea;            
    padding: 1px;
}

.statusLine {
    font-size: xx-small;            
    color: #3358c1; 
    width: 100%;    
    margin-left: 10px;
	display: none;
}

.assignment {
	font-size: xx-small;	
	margin: 0;
	padding: 0;
}

.assignment h4 {
	font-size: xx-small;
	margin: 0;
    padding: 1px 0 1px 19px;
    color: #333333;
	/*font-weight: bold;*/
}

.assignment .step {
	font-size: xx-small;
	margin: 0;
    padding: 1px 0 1px 19px;
    color: #333333;
	/*font-weight: bold;*/
}

a.assignment:link  {
    font-size: xx-small;
    color: #3358c1;
    text-decoration: none;
}

a.assignment:visited {
    font-size: xx-small;
    color: #3358c1;        
    text-decoration: none;
}

a.assignment:active {        
    text-decoration: none;
}

a.assignment:hover  {
    text-decoration: underline;
}

#assignmentForm {
	margin: 0;
	padding: 0;
}

.pageTitle {
	width: 150px; 
	color: #333333; 
	font-size: medium
}

.PrevTempHeader_Title
{
	font-size:18px;
	font-weight:bold;
	color: #fff;
}
.PrevTempHeader_subTitle
{
	color: #fff;
	font-family: Tahoma;
    font-size: 12px;
    font-weight: bold;
	margin-right:7px;
}
.PrevTempHeader_select
{
	font-size:11px;
	height:24px;
	padding-top:4px;
	margin-right:15px;
}

a.getLink:link, a.getLink:visited, a.getLink:active {
    color: #3358c1; 
    text-decoration: none;
}

a.getLink:hover {
    text-decoration: underline;
}

#dateSelectionForm {
	display:inline;
}

label.form-label-text{
	width:70px;
	padding-right:10px;
	text-align:right;
	height:auto;
	display:inline-block;
}

.previewTemplateLeft{
	margin-top:30px;
}

.previewTemplateLeft .UIInput{
	width:210px;
}

div.rowspace{
	margin:0 0 10px;
}
</cs:ftcs>