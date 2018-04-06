<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
	<% %>
<html>
	<head>
		<script src="Risk_Engineering\angular.js"></script>
		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script src="Risk_Engineering\node_modules\angular-sanitize\angular-sanitize.js"></script>
		<link href="Risk_Engineering\bootstrap\css\bootstrap.min.css" rel="stylesheet">
		<style type="text/css">
			body{
				background-color: aliceblue; 
			}
			.custom-div{
				background-color: burlywood;
				margin: 3px;
				padding: 6px;
				word-break: break-word;
			}
		</style>
	</head>
	<body>
		<div class="container" ng-app="wcsApp">
			<div class="row" ng-controller="testController as test">
				<div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
					<div class="custom-div">
						<span class="h1">{{test.menu}}</span><hr>
						<form name="form">
							<div class="radio">
								<label><input type="radio" id="StringResponse" value="STRING" ng-model="test.userInput"/> Get STRING Data</label>
							</div>
							<div class="radio">
								<label><input type="radio" id="XMLResponse" value="XML" ng-model="test.userInput"/> Get XML Data</label>
							</div>
							<div class="radio">
								<label><input type="radio" id="JSONResponse" value="JSON" ng-model="test.userInput"/> Get JSON Data</label>
							</div>														
							<input type="submit" class="btn btn-default" value="Get Data" ng-click="test.processInput()" />
						</form>
					</div>
				</div>
				<div class="col-lg-8 col-md-8 col-sm-12 col-xs-12">
					<div class="custom-div">
						<span class="h1">{{test.content}}</span><hr>						
						<span class="h4 text-danger" ng-if="test.responseType == undefined">Please Select one Option</span>
						<span ng-if="test.responseType.length > 0"> 
							<span class="h4">Asset Data in {{test.responseType}} format : </span>
							<br/><br/>
							<span ng-if="test.responseType == 'STRING' || test.responseType == 'JSON'">
								<span ng-bind-html="test.answer"></span>
							</span>
							<span ng-if="test.responseType == 'XML'">
								<span ng-bind="test.answer"></span>
							</span>
							<span id="answer"></span>
						</span>
					</div>
				</div>	
			</div>
		</div>
		<script type="text/javascript">
			var mainModule = angular.module('wcsApp',['ngSanitize']);
			mainModule.controller('testController',function($sce, $http){
				this.menu = "MENU";
				this.content = "CONTENT";
				this.displayOutput = false;
				this.processInput = function(){
					this.responseType = this.userInput;
					var targetUrl = "";
					//this.responaseData = "";
					console.log(this.responseType);
					
					if(this.responseType == "XML"){						
						targetUrl = "http://localhost:9080/cs/ContentServer?pagename=Risk_Engineering/GetXML";
						this.displayOutput = true;
					}					
					else if(this.responseType == "JSON"){
						targetUrl = "http://localhost:9080/cs/ContentServer?pagename=Risk_Engineering/GetJSON";
						this.displayOutput = true;
					}else if(this.responseType == "STRING"){
						targetUrl = "http://localhost:9080/cs/ContentServer?pagename=Risk_Engineering/GetString";
						this.displayOutput = true;
					}
					
					//Method-1 : use async: false & global: false; Not at all recommended
					/* this.responseData = $.ajax({
							url: targetUrl,
							data: "",
							type: 'GET',
							global: false,
    						async: false, 
							success: function (resp) {
								ajaxResponse = resp;					    
							},
							error: function(e) {
							    console.log('Error: '+e);
							}  
						}).responseText.trim();
					$sce.trustAsHtml(this.responseData); */
					
					//Method-2 : use $.Defered but does not display o/p
					/*$.ajax({ url: targetUrl }).done(function( data ) {
					    this.responseData = data.trim();
					  	console.log( "Sample of data:", this.responseData );
					    return this.responseData; 
					}).fail(function( data ) {
					    console.log( "FAIL:", this.responseData );
					});
					console.log( "this.temp:",  this.responseData );
					------------------------------------------------------------
					     .error(function(data) { console.log("error" , data); })
					    .complete(function(data) { 
					    	console.log("complete"); 
					    	this.responseData = data.responseText.trim(); 
					    	console.log(this.responseData);
					    }); */
					
					//Method-3 : use callbacks but does not display o/p
					/* this.responseData = function(callBack) {
						console.log("Two : ");
  						$.ajax({
    							url:targetUrl,  
    							success:function(data) {
    								console.log("Three : ");
      								callBack(data); 
    							}
  						});                                                        
					}
					this.responseData(function(output){
  						console.log("One : ");
                       	this.answer = output.trim();
                       	$sce.trustAsHtml(this.answer);
                       	console.log(this.answer);
                       	$("#answer").html("");
                       	$("#answer").html(this.answer);
					}); */
					
					//Method-4 : use promises : most prefered
					var reference = this;
					reference.responseData = $http.get(targetUrl).then(function(response){
						reference.HTTPStatus = response.status;
						reference.answer = response.data.trim();
						$sce.trustAsHtml(reference.answer);
						console.log("Promise Success : ", reference.HTTPStatus);
						//console.log("Promise Response : ", reference.answer);
					},
					function(response){
						console.log("Promise Error : ", response.status);
						console.log("Error Details : ", response.data);
					});		
				}				
			});
		</script>
	</body>
</html>
</cs:ftcs>