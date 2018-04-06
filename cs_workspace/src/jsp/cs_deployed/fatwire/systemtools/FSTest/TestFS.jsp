<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// fatwire/systemtools/FSTest/TestFS
//
// INPUT
//
// OUTPUT
// 
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.FSTest"
%><%@ page import="com.fatwire.realtime.util.Util"
%><%@ page import="java.io.*"
%><cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urlTimeoutError"/>
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
    String hostname = "unknown";
	Map<String,String> benchMark = null ;
	String defaultLocale = "en_US";
try {
       hostname = java.net.InetAddress.getLocalHost().getHostName();
	   String iniPath = application.getInitParameter("inipath");
	    benchMark = FSTest.getBenchMark(iniPath,ics);

    } catch (java.net.UnknownHostException e){}
%>
<html>
<head>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<xlat:lookup key="fatwire/SystemTools/FSTest/Results" varname="Results" />
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/content.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/publish.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css,publish.css"/>
</ics:callelement>
<title><ics:getvar name="pagename"/></title>
<script type="text/javascript" src='<%=request.getContextPath() %>/js/prototype.js'></script>


<script type="text/javascript">

dojo.require("dojox.charting.Chart2D");
dojo.require("dojox.charting.action2d.Tooltip");
dojo.require("dojox.charting.widget.Legend");

var var_sizeOfFile = '<xlat:stream key="fatwire/SystemTools/FSTest/sizeOfFileMessage" />';
var var_numReadsMessage = '<xlat:stream key="fatwire/SystemTools/FSTest/numReadsMessage" />';
var var_fileLockedMessage = '<xlat:stream key="fatwire/SystemTools/FSTest/fileLockedMessage" />';
var var_fileAttributedMessage = '<xlat:stream key="fatwire/SystemTools/FSTest/fileAttributedMessage" />';
var var_rafOpenMessage = '<xlat:stream key="fatwire/SystemTools/FSTest/rafOpenMessage" />';
var var_where = '<xlat:stream key="fatwire/SystemTools/FSTest/where" />';
	
var var_dirImage = '<%=ics.GetVar("cs_imagedir")%>';
var var_threads = '<xlat:stream key="fatwire/SystemTools/FSTest/threads" />';
var var_files = '<xlat:stream key="fatwire/SystemTools/FSTest/files" />';
var var_test = '<xlat:stream key="fatwire/SystemTools/FSTest/test" />';
var var_run = '<xlat:stream key="fatwire/SystemTools/FSTest/run" />';

var  varThread = '<xlat:stream key="fatwire/SystemTools/FSTest/thread" />';
var varCreate = '<xlat:stream key="fatwire/SystemTools/FSTest/create" />'  ;
var varWrite = '<xlat:stream key="fatwire/SystemTools/FSTest/write" />' ;
var varRead = '<xlat:stream key="fatwire/SystemTools/FSTest/read" />' ;
var varDelete = '<xlat:stream key="fatwire/SystemTools/FSTest/delete" />' ;
	
	
//chart related variables
var done = false;
var chart1 = null ;

var createSeries = [];
var writeSeries = [];
var readSeries = [];
var deleteSeries = [];

var createSeries_1 = [];
var writeSeries_1 = [];
var readSeries_1 = [];
var deleteSeries_1 = [];

var chartMax = 5;
var countRender = 0;

var flag2 = false;

var fsTest = {
	    test: {
	        version:'2.0',
	        timestamp: new Date(),
	        hostname:'<%=hostname %>',
	        username: '<%= ics.GetSSVar("username")%>',
	        results: [] ,
			stats: {},
			benchMark: <%=benchMark.toString().replace("=",":")%>
	    },
		processResult: function processResult(result) {
		
		  var where = result.where;
		  
		  var avgCreateTime = result.avgCreateTime;
		  var avgReadTime = result.avgReadTime;
		  var avgWriteTime = result.avgWriteTime;
		  var avgDeleteTime = result.avgDeleteTime;
		  var testPre ='';
		  if ($('shorttest').checked){
			  testPre = 'short';
		  }else if($('mediumtest').checked) {
			  testPre = 'medium';
		  }else {
			  testPre = 'ext';
		  }
		  var key = testPre+where;
		  
		  if(!fsTest.test.stats.hasOwnProperty(where)) {
		    var data = [avgCreateTime,avgWriteTime,avgReadTime,avgDeleteTime,1];
			fsTest.test.stats[where] = data;
		  }
		  else{
			var data = fsTest.test.stats[result.where];
			data[0] = Math.round((data[0]*data[4] + avgCreateTime ) / (data[4] + 1));
			data[1] = Math.round((data[1]*data[4] + avgWriteTime ) / (data[4] + 1));
			data[2] = Math.round((data[2]*data[4] + avgReadTime ) / (data[4] + 1));
			data[3] = Math.round((data[3]*data[4] + avgDeleteTime ) / (data[4] + 1));
			data[4] = data[4] + 1;
		  }
		  
		  var obj_create = where + '_create';
		  $(obj_create).innerHTML = data[0] ;
		  
		  var obj_write = where + '_write';
		  $(obj_write).innerHTML = data[1] ;
		  
		  var obj_read = where + '_read';
		  $(obj_read).innerHTML = data[2]  ;
		  
		  var obj_delete = where + '_delete';
		  $(obj_delete).innerHTML = data[3] ;
		  
		  obj_create = where+'_bm_create';
		  obj_write = where+'_bm_write';
		  obj_read = where+'_bm_read';
		  obj_delete = where+'_bm_delete';
		  
		  $(obj_create).innerHTML = '<b>' + fsTest.test.benchMark[key+'_create'] +'</b>';
		  $(obj_write).innerHTML = '<b>' + fsTest.test.benchMark[key+'_write']+'</b>';
		  $(obj_read).innerHTML = '<b>' + fsTest.test.benchMark[key+'_read']+'</b>';
		  $(obj_delete).innerHTML = '<b>' + fsTest.test.benchMark[key+'_delete']+'</b>';
		  
		},
		
		getResults: function getResults() {
		 var len = fsTest.test.results.length;
		 var outPut = '<xlat:stream key="fatwire/SystemTools/FSTest/testResults"/>' +'\n';
		 var testText = '<xlat:stream key="fatwire/SystemTools/FSTest/test"/>';
		 
		 outPut+= var_test + ',' + var_threads+ ',' + var_files ;
		 outPut+= ',' + '<xlat:stream key="fatwire/SystemTools/FSTest/size"/>' +',' +  '<xlat:stream key="fatwire/SystemTools/FSTest/reads"/>' +',' + '<xlat:stream key="fatwire/SystemTools/FSTest/lock"/>' +',' ;
		 outPut+= '<xlat:stream key="fatwire/SystemTools/FSTest/attributes"/>' + ',' + '<xlat:stream key="fatwire/SystemTools/FSTest/rafMode"/>' + ',' + var_where + ',' + varCreate + ' \u00B5s,' + varWrite +' \u00B5s,' ;
		 outPut+= varRead + ' \u00B5s,' + varDelete +' \u00B5s,' + var_run +' \u00B5s\n\n';
		 
		 for(var i=0;i<len;i++){
			var resultsObj = fsTest.test.results[i];
			var jsSon = resultsObj;
			outPut+= (i+1) +',';
			outPut+= jsSon.numThreads +',';
			outPut+= jsSon.numFiles +',';
			outPut+= jsSon.fileSize +',';
			outPut+= jsSon.numReads +',';
			outPut+= jsSon.fileLock +',';
			outPut+= jsSon.fileAttr +',';
			outPut+= jsSon.where +',';
			outPut+= jsSon.rafMode +',';
			outPut+= jsSon.minCreateTime+'/'+jsSon.maxCreateTime+'/'+jsSon.avgCreateTime +',';
			outPut+= jsSon.minWriteTime+'/'+jsSon.maxWriteTime+'/'+jsSon.avgWriteTime +',';
			outPut+= jsSon.minReadTime+'/'+jsSon.maxReadTime+'/'+jsSon.avgReadTime +',';
			outPut+= jsSon.minDeleteTime+'/'+jsSon.maxDeleteTime+'/'+jsSon.avgDeleteTime +',';
			outPut+= jsSon.totalTime +'\n';
			
			var totalThreads = resultsObj.threads.length;
			outPut+= ',,'+ varThread+',' + varCreate +' \u00B5s,' + varWrite+' \u00B5s,'+varRead +' \u00B5s,' + varDelete +' \u00B5s\n';
			var threads = resultsObj.threads;
			for( var j = 0 ; j<totalThreads ; j++) 
			{
				outPut+= ',,' + (j+1) + ',' +  threads[j][0]+',' + threads[j][1] +' , ' + threads[j][2] +' , ' + threads[j][3] +'\n';
			}
			outPut+= '\n\n';
		 }
		 
		 var xlatLocation = '<xlat:stream key="fatwire/SystemTools/FSTest/where" />';
		 var xlatPath =  '<xlat:stream key="fatwire/SystemTools/FSTest/path" />';
		 var xlatBenchMark = '<xlat:stream key="fatwire/SystemTools/FSTest/benchMark" />';
		 outPut = outPut + '\n\n' +'<xlat:stream key="fatwire/SystemTools/FSTest/benchMarkResults" />' + '\n\n';
		 
		 outPut=outPut + xlatLocation + ',' + xlatPath + ',' +varCreate +' \u00B5s,' + varWrite+' \u00B5s,'+varRead +' \u00B5s,'+varDelete +' \u00B5s\n';
		 
		  var testPre ='';
		  if ($('shorttest').checked){
			  testPre = 'short';
		  }else if($('mediumtest').checked) {
			  testPre = 'medium';
		  }else {
			  testPre = 'ext';
		  }
		 for(var key in fsTest.test.stats ) {
			
			var key1 = testPre+key;
			var createBenchMark = fsTest.test.benchMark[key1+'_create'];
			var writeBenchMark = fsTest.test.benchMark[key1+'_write'];
			var readBenchMark = fsTest.test.benchMark[key1+'_read'];
			var deleteBenchMark = fsTest.test.benchMark[key1+'_delete'];
			var data = fsTest.test.stats[key];
			outPut+= key + ',' + $(key+'_1').innerHTML +','+ data[0] +','+ data[1]  +','+ data[2] + ',' + data[3] + ',\n';
			outPut+= xlatBenchMark + ',,' + createBenchMark +',' + writeBenchMark;
			outPut+=  ',' + readBenchMark + ',' + deleteBenchMark + '\n\n';
			
		 }
		 
		 return outPut;
		},
	    downloadResults: function downloadResults() {
			var headers = {
					<%
					if(session.getAttribute("X-CSRF-Token") != null){
					%>
						'X-CSRF-Token': '<%=session.getAttribute("X-CSRF-Token") %>'
					<%	  
					} else {
					%>
						'X-CSRF-Token': 'X-CSRF-Token'
					<%}%>
			};
			new Ajax.Request('ContentServer', {
	    	method : 'post',
			requestHeaders  : headers,
	    	parameters: {pagename:'fatwire/systemtools/FSTest/FileSystemTest', downloadFSResults: fsTest.getResults(),  cacheBust: (new Date()).getTime() },
	    	onSuccess: function(transport){
			var respText= transport.responseText;
			var index1 = respText.indexOf('_FW_MARKER1_');
			var index2 = respText.indexOf('_FW_MARKER2_');
			var json = respText.substring(index1+12,index2).evalJSON();
			var urlValue = json['outPutUrl'];
			if(urlValue != undefined && urlValue !== null && urlValue !== '')
				location.href=urlValue;
	        },
			onComplete: function(transport) { 
				var header = transport.getResponseHeader("userAuth");
				if(header == "false")
					parent.parent.location='<%=ics.GetVar("urlTimeoutError")%>';
			}
	    });
		},
	    addTests: function addTests(threads,files,sizes,reads,locations, fileLock, fileAttr,rafMode){
	        var ret=[];
	        for (var t=0; t<threads.length;t++){
	            for (var f=0; f<files.length;f++){
	                for (var s=0; s<sizes.length;s++){
	                    for (var r=0; r< reads.length;r++){
	                       for (var l=0; l<fileLock.length;l++){
	                           for (var a=0; a<fileAttr.length;a++){
	                               for (var mo=0; mo<rafMode.length;mo++){
	                                   for (var w=0; w<locations.length;w++){
	                                        var m ={};
	                                        m.thread=threads[t];
	                                        m.files=files[f];
	                                        m.size=sizes[s];
	                                        m.reads=reads[r];
	                                        m.where = locations[w];
	                                        m.fileLock = fileLock[l];
	                                        m.fileAttr = fileAttr[a];
	                                        m.rafMode = rafMode[mo];
	                                        ret.push(m);
	                                    }
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        return ret;
	    },
	    stopTest: function(){
	        fsTest.finishTest();
			done = true;
			$('controlPanel').style.display='';
			$('message').style.display='none';
	    },
		
	    submitTest: function(){
	 	var answer = confirm('<xlat:stream key="fatwire/SystemTools/FSTest/PerformanceWarning" encode="false" escape="true"/>');
	    	if(answer)
	    		{
		    		done = false;
					$('stats').style.display = '';
					$('downloadButton').style.display='none';
					
					$('visualization').innerHTML = '';
					
					while($('resultsbodyInner').rows.length > 0)
					{
						$('resultsbodyInner').deleteRow($('resultsbodyInner').rows.length -1);
					}
					
					fsTest.test.results = [];
					fsTest.test.stats = {};
					
			        if ($('shorttest').checked){
			            fsTest.sampleResult=fsTest.addTests([10],[10,100],[100,10240],[10],["local","data","spc","sync"],[true],[false],["r"]);
			        } else if ($('mediumtest').checked){
			            fsTest.sampleResult=fsTest.addTests([10],[10,100],[100,10240],[1,50],["local","data","spc","sync"],[true,false],[true],["r"]);
			        }else {
						fsTest.sampleResult=fsTest.addTests([25],[10,100],[100,10240],[10,50],["local","data","spc","sync"],[true,false],[true,false],["r","rw","rws"]);
			        }
			        $('shorttest').disabled=true;
			        $('mediumtest').disabled=true;
			        $('exttest').disabled=true;
					
			        fsTest.test.timestamp = new Date();
					
					chart1 = null ; 
					createSeries = [];
					writeSeries = [];
					readSeries = [];
					deleteSeries = [];
					
					createSeries_1 = [];
					writeSeries_1 = [];
					readSeries_1 = [];
					deleteSeries_1 = [];
					
					chartMax = 5;
					countRender = 0 ; 
					
			        $('message').style.display='block';
			        document.getElementById('secondTbodyID').style.display='block';
			        document.getElementById('bottom').style.display ='block';
			        
			        var button_start = $('controlButton_start');
			        button_start.style.display='none';
					
					var button_stop = $('controlButton_stop');
					button_stop.style.display='block';
					
			        if (fsTest.sampleResult.length>0)
					{
						fsTest.runTest(0);
					}
		        }
				
	    },
	    runTest: function(i){
		  
		    
	        if (done) return;
	        var mytest = fsTest.sampleResult[i];
	        var label= 't' + mytest.thread +'-f'+mytest.files + '-s' + mytest.size + '-r'+mytest.reads +'-l'+mytest.fileLock+'-a'+mytest.fileAttr+'-m'+mytest.rafMode+'-'+mytest.where;
	        $('message').style.display='block';
			$('messageText').update('<xlat:stream key="fatwire/SystemTools/FSTest/runningFSTestMessage" /> ('+ i + ' / ' + (fsTest.sampleResult.length ) +')  '  + '  <xlat:stream key="fatwire/SystemTools/FSTest/runningFSTestWait"/> ');
			$('resultsHeading').style.display='';
			
	        new Ajax.Request('ContentServer', {
	          method: 'get',
	          parameters: {pagename:'fatwire/systemtools/FSTest/FileSystemTest',numThreads: mytest.thread, numFiles: mytest.files,fileSize: mytest.size,numReads:mytest.reads,type:mytest.where,fileLock:mytest.fileLock,fileAttr:mytest.fileAttr,rafMode:mytest.rafMode,  cacheBust: (new Date()).getTime() },
	          onSuccess: function(response){
			  if(done) return;
	               
					try {
							
							var result = response.responseText.evalJSON();
							
							fsTest.test.results.push(result);
							fsTest.processResult(result);
							drawDojoGraph(result);
							fsTest.addTableRow(i,label,mytest,result);
						
					} catch (e){
					  if (window.console) console.log(e);
					}
	               i++;
	               if (i < fsTest.sampleResult.length) { fsTest.runTest(i);} else { fsTest.finishTest();}
	          },
	          onFailure: function(){ fsTest.stopTest() ;}
	        });
	    },
	    finishTest: function (){
				
			done = true;
			
			$('shorttest').disabled=false;
	        $('mediumtest').disabled=false;
	        $('exttest').disabled=false;
	        $('message').style.display='none';
			
			var button_start = $('controlButton_start');
			button_start.style.display = 'block';
			var button_stop = $('controlButton_stop');
			button_stop.style.display = 'none';
			
			button = $('downloadButton');
			button.style.display = 'block';
			
			createChart();
			
	    },
	    addTableRow :function addTableRow(rownum,label,mytest,result){

		    if($('resultsbodyInner').rows.length != 0) {
				var tr_1 = $('resultsbodyInner').insertRow($('resultsbodyInner').rows.length);
				var td_1 = document.createElement("TD");
				td_1.className ="light-line-color";
				td_1.setAttribute("colSpan", "29");
				var img_1= document.createElement("IMG");
				img_1.setAttribute("height","1");
				img_1.setAttribute("width","1");
				img_1.setAttribute("src",'<%=ics.GetVar("cs_imagedir")%>'+'/graphics/common/screen/dotclear.gif');
				td_1.appendChild(img_1);
				tr_1.appendChild(td_1);
			}
							
			var tr_2;
			if($('resultsbodyInner').rows.length != 0) {
				tr_2 = $('resultsbodyInner').insertRow($('resultsbodyInner').rows.length);
			} else {
				tr_2 = $('resultsbodyInner').insertRow(0);
			}
			
			tr_2.setAttribute('id','Main_' + rownum);
			tr_2.className= (rownum & 1)  === 0 ? "tile-row-highlight" : "tile-row-normal";
			var newCell = tr_2.insertCell(-1);
		
			var image1 = document.createElement('img');
			image1.setAttribute('id','image_'+rownum);
			image1.setAttribute('src','<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif');
			image1.setAttribute('style','vertical-align:middle;');
			
			if(Prototype.Browser.IE) {
			 image1.attachEvent('onclick',function(e) { toggleVisibility(rownum+''); });
			}
			else{
			image1.addEventListener("click",toggleVisibilityForNonIE,false);
			}
			
			newCell.appendChild(image1);
			
			addCell(tr_2,'' + (rownum+1) );
			addCell(tr_2,'' + mytest.thread );
			addCell(tr_2,'' + mytest.files );
			addCell(tr_2,'' + mytest.size );
			addCell(tr_2,'' + mytest.reads );
			addCell(tr_2,'' + mytest.fileLock );
			addCell(tr_2,'' + mytest.fileAttr );
			addCell(tr_2,'' + mytest.rafMode);
			addCell(tr_2,'' + mytest.where );
			addCell(tr_2,'' + result.minCreateTime + '/' + result.maxCreateTime +'/' + result.avgCreateTime );
			addCell(tr_2,'' + result.minWriteTime + '/' + result.maxWriteTime +'/' + result.avgWriteTime );
			addCell(tr_2,'' + result.minReadTime + '/' + result.maxReadTime +'/' + result.avgReadTime );
			addCell(tr_2,'' + result.minDeleteTime + '/' + result.maxDeleteTime +'/' + result.avgDeleteTime );
			addCell(tr_2,'' + result.totalTime);
			
	    },
		createDynamicInnerTable : function( testName ) {
			 var text = '';
			 text+='<table BORDER="0" CELLSPACING="0" CELLPADDING="0">';
			 text+='<tr><td></td><td class="tile-dark" HEIGHT="1">';
			 text+='<IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" /></td><td></td></tr>';
			 text+='<tr><td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td><td>';
			 text+='<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">';
			 text+='<tbody id="threadsResults_'+testName+'" >';
			 text+='<tr><td colspan="11" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" /></td></tr>';
			 text+='<tr>';
			 text+='<td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;</td>';
			 
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
			 text+='<DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/thread' /></DIV></td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;</td>';
			 
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
			 text+='<DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/create' />, &#956;s</DIV></td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
			 text+='<DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/write' />, &#956;s</DIV></td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
			 
			 text+='<DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/read' />, &#956;s</DIV></td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td>';
			 text+='<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">';
			 text+='<DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/delete' />, &#956;s</DIV></td>';
			 text+='<td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>';
			 text+='<tr><td colspan="11" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" /></td></tr>';
			 text+='</tbody></table></td><td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td></tr>';
			 text+='<tr><td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" /></td></tr>';
			 text+='<tr><td></td><td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif"><IMG WIDTH="1" HEIGHT="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" /></td>';
			 
			 text+='<td></td></tr></table>';
			 return text;
		}
		
	};
	
function addCell(tr_1,textToDisplay) {
		 
		 var newCell = tr_1.insertCell(-1);
		 var e = document.createElement("div");
		 e.className="small-text-inset";
		 var docForDisp = document.createTextNode(''+textToDisplay);
		 e.appendChild(docForDisp);
		 newCell.appendChild(e);
		 var newCell = tr_1.insertCell(-1);
		newCell.appendChild(document.createElement("BR"));
	}
	
	
function toggleVisibilityForNonIE() {
 var name = this.id;
 toggleVisibility(name.replace('image_',''));
}

function toggleVisibility(name) {

	var value = parseInt(name);
	if(document.getElementById('sub_'+name) == null)
	{
		createSubRow(value);
	}
	var theRow = document.getElementById('sub_'+name);
	if (theRow.style.display === "none") {
		theRow.style.display = "";
		$('image_'+name).setAttribute('src','<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Collapse.gif');
	} else {
		theRow.style.display = "none";
		$('image_'+name).setAttribute('src','<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif');
	}

}	

function createSubRow(mainRowID) {
		
		var trMainObject = $('Main_' + mainRowID).rowIndex;
		tr_2 = $('resultsbodyInner').insertRow(trMainObject-2);
		newCell = tr_2.insertCell(-1);
		newCell.appendChild(document.createElement("BR"));
		
		if(Prototype.Browser.IE)
			newCell.colSpan = 4;
		else
			newCell.setAttribute('colspan','4');
			
		tr_2.className= ((name) & 1)  === 0 ? "tile-row-highlight" : "tile-row-normal";
		tr_2.setAttribute('id','sub_'+mainRowID);
		tr_2.style.display = "none";
		var cell = document.createElement('td');
		if(document.all)
			cell.colSpan = 13;
		else
			cell.setAttribute('colspan','13');
		tr_2.appendChild(cell);
		
		var innerDIV = document.createElement('div');
		innerDIV.className = 'ODPanel';
		innerDIV.style.marginTop = '10px';
		innerDIV.style.width = '100%';
		
		var threads = fsTest.test.results[mainRowID].threads;
		
		var dynamicText=fsTest.createDynamicInnerTable(trMainObject+'');;
		innerDIV.innerHTML = dynamicText;
		cell.appendChild(innerDIV);
		
		cell = document.createElement('td');
		tr_2.appendChild(cell);
		
		var tbodyVar = $('threadsResults_'+trMainObject);
		
		for(var k=0;k<threads.length;k++)
		{
			var threadVar = threads[k];
			tr_2 = tbodyVar.insertRow(tbodyVar.rows.length);
			tr_2.className= (k & 1)  === 0 ? "tile-row-highlight" : "tile-row-normal";
			newCell = tr_2.insertCell(-1);
			newCell.appendChild(document.createElement("BR"));
			addCell(tr_2,(k+1)+' ');
			addCell(tr_2,threadVar[0]+' ');
			addCell(tr_2,threadVar[1]+' ');
			addCell(tr_2,threadVar[2]+' ');
			addCell(tr_2,threadVar[3]+' ');
		}
}

function drawDojoGraph(result) {
    
	createSeries.push(result.avgCreateTime/1000);
	writeSeries.push(result.avgWriteTime/1000);
	readSeries.push(result.avgReadTime/1000);
	deleteSeries.push(result.avgDeleteTime/1000);
	
	var maximum1 = Math.max(result.avgCreateTime/1000,result.avgWriteTime/1000);
	var maximum2 = Math.max(result.avgReadTime/1000,result.avgDeleteTime/1000);
	var max3 = Math.max(maximum1,maximum2);

	var yAxisMax = (Math.ceil(max3/10))*10;
	chartMax = yAxisMax > chartMax ? yAxisMax : chartMax;
	
	var REFRESH_RATE = 10;
	
	if(Prototype.Browser.IE && $('exttest').checked )
		REFRESH_RATE = 20;
	
	
	  if( ((countRender%REFRESH_RATE) == 2) || (countRender == 10) )
	  {
		createChart();
		}
	  
	countRender++;
}

function createChart()
{	
		   if(chart1 !== null )
		   {
				chart1.removeAxis("x");
				chart1.removeAxis("y");	
				chart1.removeSeries(varCreate);
				chart1.removeSeries(varWrite);
				chart1.removeSeries(varRead);
				chart1.removeSeries(varDelete);
				chart1.destroy();			
				
				$('visualization').innerHTML =  '';
			}
	
			createSeries_1 = [];
			writeSeries_1 = [];
			readSeries_1 = [];
			deleteSeries_1 = [];
		
			chart1 = new dojox.charting.Chart2D("visualization",{title:"<%=ics.GetVar("Results")%>"});
			chart1.addPlot("default", {
				type: "Markers",tension:"S"
			});
			
			if(!Prototype.Browser.IE)
			{
				var a = new dojox.charting.action2d.Tooltip(
				chart1,
				"default",
				{ text: function(o) {
					return setToolTip(o.x);
				} }
				);
			}
			
			
			chart1.addAxis("y", {
				vertical: true,
				max:chartMax,
				stroke:"green",
				fontColor:"red",
				fixed:false
			});
			
			chart1.addAxis("x", {fixed:true, natural:true});
			
			var minRender =  countRender > 64   ? countRender - 64 : 1;
			
			createSeries_1 =  done || countRender ==0 ? createSeries : createLimitedCopy(minRender,countRender,createSeries);
			writeSeries_1 = done || countRender ==0 || countRender ==0 ? writeSeries : createLimitedCopy(minRender,countRender,writeSeries);
			readSeries_1 = done || countRender ==0 ?  readSeries : createLimitedCopy(minRender,countRender,readSeries);
			deleteSeries_1 = done || countRender ==0 ? deleteSeries : createLimitedCopy(minRender,countRender,deleteSeries);
			
			
			chart1.addSeries(varCreate, createSeries_1,{stroke:{color:"blue" } });
			chart1.addSeries(varWrite, writeSeries_1,{stroke:{color:"red"}});
			chart1.addSeries(varRead, readSeries_1,{stroke:{color:"green"}});
			chart1.addSeries(varDelete, deleteSeries_1,{stroke:{color:"yellow"}});
		
			chart1.render();
			
			if(!flag2)
			{
				var legendTwo = new dojox.charting.widget.Legend({
				chart: chart1, horizontal: true},"visualization_legend");
				flag2  = true;
			}		
}

function createLimitedCopy (begin,end,series)
{
  var newSeries = [];
  for(var i=begin;i<=end;i++)
  {
     newSeries.push({x:i,y:series[i-1]});
	 
  }
 
  return newSeries;
}

function setToolTip(x)
{
	var ind = x - 1;
	var m = fsTest.sampleResult[ind];
	var testParam = "<font size='1'>" + varThread + " : " + m.thread +"<br/>";
	testParam += var_files +" : " + m.files +"<br/>";
	testParam += var_sizeOfFile + " : " + m.size +"<br/>";
	testParam += var_numReadsMessage + " : " + m.reads +"<br/>";
	testParam += var_fileLockedMessage + " : " + m.fileLock +"<br/>";
	testParam += var_fileAttributedMessage + " : " + m.fileAttr +"<br/>";
	testParam += "<b>" + var_where + " : " + m.where +"</b><br/>";
	testParam += var_rafOpenMessage + " : " + m.rafMode +"<br/><br/>";
	
	var createText = "<font color='#0000FF'><b>" + varCreate + ": </b></font>" + createSeries[ind];
	var writeText = "<font color='#FF0000'><b>" + varWrite  + ": </b></font>" + writeSeries[ind];
	var readText = "<font color='#387C44'><b>" + varRead + ": </b></font>" + readSeries[ind];
	var deleteText = "<font color='#FBB917'><b>" + varDelete + ": </b></font>" + deleteSeries[ind];
	return testParam + ' ' + createText+'<br/> '+writeText+'<br/> '+readText+'<br/> ' + deleteText + '</font>';
}

</script>
</head>
<body>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<h3><xlat:stream key="fatwire/SystemTools/FSTest/fsTest" /></h3>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<table class="width-outer-70" cellspacing='0' cellpadding='0'>
	<tbody id="firstTbodyID">
	<tr><td><div class="form-inset" ><xlat:stream key="fatwire/SystemTools/FSTest/fsTestDescription" /></div></td></tr>
	<tr>
	<td id="controlPanel">
	<table><tr><td>
	<div style="display:inline; float:left;display:block" id="controlButton_start" >
		<a onclick="fsTest.submitTest(); return false;" href="#" >
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/StartTest"/></ics:callelement>
		</a>
	</div>
	<div style="display:none; float:left;" id="controlButton_stop" >
		<a onclick="fsTest.stopTest(); return false;" href="#" >
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/StopTest"/></ics:callelement>
		</a>
	</div>
	</td><td>
	<div style="display:inline; float:left">
		<a onclick="fsTest.downloadResults(); return false;" href="#" id="downloadButton" style='display:none'>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Download"/></ics:callelement>
		</a>
	</div>
	</td><td>
	<div>
		<input type="radio" name="testsize" value="short" id="shorttest"/><xlat:stream key="fatwire/SystemTools/FSTest/shortTest" />
		<input type="radio" name="testsize" value="medium" id="mediumtest" checked="checked"/><xlat:stream key="fatwire/SystemTools/FSTest/mediumTest" />
		<input type="radio" name="testsize" value="extensive" id="exttest"/><xlat:stream key="fatwire/SystemTools/FSTest/extensiveTest" />
	</div>	
	</td></tr></table>
	</td>
	</tr>
	<tr><td class="light-line-color" colspan="1"><img height="1" width="1" src='<%= ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'></td></tr>
	<tr><td><br/></td></tr>
	<tr>
		<td>
		<div id="message" style="display: none">
			<b id="messageText"></b><img id="loadingimg" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif' onerror="this.remove();"/>
		</div>
		</td>
	</tr>
	</tbody>
	<tbody id="secondTbodyID" style="display:none">
	<tr>
	<td align="left">
	<div style="float:left">
	<div style="float:left;"><h3><xlat:stream key="fatwire/SystemTools/FSTest/performanceSummary" />&nbsp;&nbsp;<img style="vertical-align: middle" title='<xlat:stream key="fatwire/SystemTools/FSTest/benchmarkInfo" />' height="15" width="15" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/help_new.png'/></h3></div>	
	</div>
	</td>
	</tr>
	<tr>
		<td><table><tr><td>
			<table BORDER="0" CELLSPACING="0" CELLPADDING="0" id='stats' style='display:none;'>
			<tr> 
			    <td></td>
			    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
			<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap><BR/></td>
			<td>
			
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
					<tr>
						<td colspan="13" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
						<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/where" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/path" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/create" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/write" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/read" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/delete" />, &#956;s</DIV></td>
						<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td colspan="13" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif '/></td>
					</tr>
					<%
					String[] fsSystems = FSTest.getFileSystems();
					int count =0;
					for(String fs : fsSystems )
					{
					String className_1 =  ((count++ & 1) == 0 ) ? "tile-row-normal" : "tile-row-highlight";
					String location = ((File) (application.getAttribute("javax.servlet.context.tempdir"))).toString();
					if("sync".equals(fs))
						location = ics.GetProperty("ft.usedisksync");
					else if("spc".equals(fs))
						location = ics.ResolveVariables("CS.CatalogDir.SystemPageCache");
					else if("data".equals(fs))
						location = ics.ResolveVariables("CS.CatalogDir.MungoBlobs");
					%>
					<tr class='<%=className_1%>'>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
						<DIV id='<%=fs%>' title='<%=location %>' class="small-text-inset" ><%=fs +" - "+Util.xlatLookup(ics,"fatwire/SystemTools/FSTest/labelMessage"+fs)%></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
						<DIV id='<%=fs+"_1"%>' title='<%=location %>' class="small-text-inset" ><%=location%></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_create' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_write' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_read' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="center">
							<DIV id='<%=fs%>_delete' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
					</tr>
					<tr class='<%=className_1%>'>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"></td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"></td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_bm_create' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_bm_write' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV id='<%=fs%>_bm_read' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="center">
							<DIV id='<%=fs%>_bm_delete' class="small-text-inset"></DIV>
						</td>
						<td><BR/></td>
					</tr>
					<tr>
						<td class="light-line-color" colSpan="13"><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/Xcelerate/graphics/common/screen/dotclear.gif' complete="complete"/></td>
					</tr>
				<%}%>
					<tr>
						<td colspan="13" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif '/></td>
					</tr>
			</table>		
			
			</td>
			<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap><BR/></td>
			</tr>
			<tr>
				<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			</tr>
			<tr>
				<td></td>
				<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
		</table>
		</td>
		<td valign="top"></td>
		</tr>
		</table>		
		</td>
					
	</tr>
	<tr><td><br/></td></tr>
	<tr>
		<td class="light-line-color" colspan="1"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'></td>
	</tr>
	<tr><td>
	<div id="resultsHeading" style="display:none">
	<h3><xlat:stream key="fatwire/SystemTools/FSTest/testResults" />
	</h3>
	</div>
	</td>
	</tr>
	<tr><td align="right"><div id="visualization_legend" style="width: 90%; height: 400px;"></div></td></tr>
	<tr>
		<td><div><xlat:stream key="fatwire/SystemTools/FSTest/avgTimeInThousands"/>&#956;s</div></td>
	</tr>
	<tr><td><div id="visualization" style="width: 90%; height: 400px;"></div></td></tr>
	<tr><td align='center'><div><xlat:stream key="fatwire/SystemTools/FSTest/tests"/></div></td></tr>
	<tr><td><br/></td></tr>
	<tr><td class="light-line-color" colSpan='1'><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/Xcelerate/graphics/common/screen/dotclear.gif'/></td></tr>
	<tr><td><br/></td></tr>
	</table>
	<div id="bottom" style="display:none">
	<div style="float:left">
	<div style="clear:both"><br/></div>
	<div style="float:left">
		<font style="font-family: Verdana;font-size: 11px">
			<xlat:stream key="fatwire/SystemTools/FSTest/detailedInformation"/>&nbsp;&nbsp;<img style="vertical-align: bottom;" title='<xlat:stream key="fatwire/SystemTools/FSTest/resultsHeaderInfo" />' width="15" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/help_new.png'/>
			</font>
	</div>
	<div style="clear:both"><br/></div>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<tr> 
			    <td></td>
			    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				<td></td>
			</tr>
			<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap><BR/></td>
			<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tbody>
					<tr>
						<td colspan="29" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
						<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key='fatwire/SystemTools/FSTest/test'/></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/threads" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/files" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/size" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/reads" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/lock" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/attributes" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/rafMode" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/where" /></DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/create" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/write" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/read" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/delete" />, &#956;s</DIV></td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="fatwire/SystemTools/FSTest/run" />, &#956;s</DIV></td>
						<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif' class="tile-c">&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td colspan="29" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif '/></td>
					</tr>
					</tbody>
					<tbody id="resultsbodyInner" >
					</tbody>
				</table>
		</td>
		<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap><BR/></td>
		</tr>
		<tr>
			<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
			<td></td>
			<td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			<td></td>
		</tr>
	</table>
	</div>
	</div>
	<br/>
	<br/>
</body>
</html>
<%}
else
{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
	</div>
<%
}
%>
</cs:ftcs>