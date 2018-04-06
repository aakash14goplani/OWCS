<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
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
	<html>
		<head>
			<title>LUCENCE SEARCH</title>
			<link rel="stylesheet" type="text/css" href="Risk_Engineering/bootstrap/css/bootstrap.min.css">
			<script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4=" crossorigin="anonymous"></script>
			<script type="text/javascript" src="Risk_Engineering/bootstrap/js/bootstrap.min.js"></script>
		</head>
		<body>
			<div class="container">
				<div class="row">
					<div class="col-xs-12">
						<h1 class="text-center">LUCENCE SEARCH</h1>
					</div>
				</div>
				<hr>
				<div class="row">
					<div class="col-md-6 col-sm-12">
						<h3 class="text-center">SEARCH CRITERIA</h3>
						<form name="lucence_form" action="http://localhost:9080/cs/ContentServer">
							<input type="hidden" name="pagename" value="Risk_Engineering/LucenceSearch"/>
							<table class="table table-hover table-responsive">
								<tr>
									<th>Site</th>
									<td>
										<select name="selected_site" id="selected_site" required>
											<option value="">Select Site</option>
											<ics:sql table="Publication" listname="siteList" sql="select name from Publication" />
											<ics:if condition='<%=null!=ics.GetList("siteList") && ics.GetList("siteList").hasData() %>'>
												<ics:then>
													<ics:listloop listname="siteList">
														<ics:listget fieldname="name" listname="siteList" output="siteName"/>
														<option value='<%=ics.GetVar("siteName")%>'><%=ics.GetVar("siteName")%></option>
													</ics:listloop>
												</ics:then>
											</ics:if>
										</select>
									</td>
								</tr>
								<tr>
									<th>Asset Type</th>
									<td>
										<select name="selected_assetType" id="selected_assetType" required>
											<option value="">Select Asset Type</option>
											<ics:sql table="Publication,AssetPublication" listname="assetTypeList" sql="select distinct site.name, asset.assettype from Publication site, AssetPublication asset where site.id=asset.pubid" />
											<ics:if condition='<%=null!=ics.GetList("assetTypeList") && ics.GetList("assetTypeList").hasData() %>'>
												<ics:then>
													<ics:listloop listname="assetTypeList">
														<ics:listget fieldname="name" listname="assetTypeList" output="site_name"/>
														<ics:listget fieldname="assettype" listname="assetTypeList" output="asset_type"/>
														<option data-parent='<%=ics.GetVar("site_name")%>' value='<%=ics.GetVar("asset_type")%>'><%=ics.GetVar("asset_type")%></option>
													</ics:listloop>
												</ics:then>
											</ics:if>
										</select>
									</td>
								</tr>
								<tr>
									<th>Asset Name</th>
									<td><input type="text" name="asset_name" placeholder="Enter Asset Name"/></td>
								</tr>
								<tr>
									<th>Description</th>
									<td><input type="text" name="asset_description" placeholder="Some Description"/></td>
								</tr>
								<tr>
									<th>Tags</th>
									<td><input type="text" name="asset_tag" placeholder="Comma seperated values"/></td>
								</tr>
								<tr>
									<th>Id</th>
									<td><input type="text" name="asset_id" placeholder="Enter Asset Id" /></td>
								</tr>
								<tr>
									<th>Author</th>
									<td>
										<select name="selected_author" id="selected_author">
											<option value="">Created By</option>
											<ics:sql table="SystemUsers" listname="userList" sql="select username from SystemUsers" />
											<ics:if condition='<%=null!=ics.GetList("userList") && ics.GetList("userList").hasData() %>'>
												<ics:then>
													<ics:listloop listname="userList">
														<ics:listget fieldname="username" listname="userList" output="userName"/>
														<option id="userName" value='<%=ics.GetVar("userName")%>'><%=ics.GetVar("userName")%></option>
													</ics:listloop>
												</ics:then>
											</ics:if>
										</select>
									</td>
								</tr>
								<tr>
									<th>Modified</th>
									<td>
										From : <input type="date" name="from_date"><br/>
										To &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: <input type="date" name="to_date">
									</td>
								</tr>
								<tr>
									<td><input type="reset" value="CLEAR"></td>
									<td><input type="submit" value="SUBMIT"></td>
								</tr>
							</table>
						</form>
					</div>
					<div class="col-md-6 col-sm-12">
						<h3 class="text-center">SEARCH RESULTS</h3>
						
					</div>
				</div>
			</div>
			<script>
				$('#selected_site').change(function() {
				   var parent = $(this).val();
				   $('#selected_assetType').children().each(function() {
				      if($(this).data('parent') != parent) {
				      	$(this).hide();
				      }
				      else{
				      	$(this).show();
				      }
				   });
				});				
			</script>
		</body>
	</html>
</cs:ftcs>