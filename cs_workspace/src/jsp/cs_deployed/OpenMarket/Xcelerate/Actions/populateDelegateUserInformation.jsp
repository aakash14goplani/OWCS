<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.fatwire.cs.mayura.ui.constant.CSServiceConstants" %>
<%@ page import="com.fatwire.cs.mayura.ui.model.bo.workflow.DelegateUserInformation"%>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<%@ page import="com.fatwire.cs.mayura.ui.model.service.ServiceParameter" %>	

<%@ page import="com.fatwire.cs.mayura.ui.model.bo.workflow.Workflow" %>	
<cs:ftcs>
<!-- 

				Element Name: populateDelegateUserInformation
				
				Purpose: This element is called by the XML element OpenMarket/Xcelerate/Actions/DelegateAssignmentFront.xml
				The main purpose of this element is to retrieve the data obtained from the ICS variables added as a hook in DelegateAssignmentFront.xml 
				for the Alloy UI and populate JAVA objects to be used by the Alloy JSF layer. The retrieved data consists of the following items:
				
				Workflow process name, 
				Workflow state desc, 
				List of assigned user roles (and their user names if current user is workflow admin)
				List of users that the asset can be delegated TO, for each of the roles (of the assignees)
				List of assignment ids corresponding to each of the roles retrieved
				Action taken (optional)
				
				Note that the data obtained here has a complicated structure.
				For each role, that the asset is currently assigned to, we have a list of users to whom the asset can be delegated to. 
				Hence we have a <rolename ,list of delegate users> structure. This is the case when the current user DOES NOT HAVE workflow admin roles/privileges.
				
				However when the current user is a workflow admin (i.e. he has atleast one of the roles in the list specified in Admin Roles in the workflow process defn)
				then we also have the user name as additional data. Note that neither the user name, nor the rolenames are unique. They can repeat: the asset can be assigned 
				to the same user for different roles, and different users with the same role can have the asset assigned to them. Hence we have to resort to an object structure
				to capture this data.  The class "DelegateUserInformation" (under the package com.fatwire.cs.mayura.ui.model.bo.workflow) has the attributes
						private String roleName;
						private String userName;
						private Long assignmentId;
						private ArrayList<String> listOfDelegateUsers;
				
				and this is enough to capture the essence of the relationship between the data retrieved from DelegateAssignmentFront.xml
				
				Read through OpenMarket/Xcelerate/Actions/DelegateAssignmentFront.xml to see how ICS variables are used as hooks to retrieve asset information for Alloy UI.
				
				Input:
						ICS Variables for Alloy UI are set in DelegateAssignmentFront.xml - they are 
						
								username_list_available_for_AlloyUI
								roleName_for_AlloyUI
								userName_for_AlloyUI
								list_of_delegates - list containing user names (string)
						
						Apart from these the following are also set in DelegateAssignmentFront.xml, but are read inside 
						"getDetailsForDelegateAssignment.jsp"

								workflowProcessName_for_AlloyUI
								workflowStateDesc_for_AlloyUI
						
						
				
				Output: 
						The above details are populated into the workflow options object (obtained from the UIWorkflow reference)						
						
				Author: Sathish Paul Leo, for the Alloy UI project
-->

<%
		// Retrieve the parameter map from the servlet request object.
		 ServiceParameter parameters = (ServiceParameter)ics.GetObj("IOMap");
		//Retrieve the workflow object from the parameter map
		Workflow uiWorkflowObject = (Workflow) parameters.get(CSServiceConstants.UI_WORKFLOW_OBJECT);

		if(uiWorkflowObject != null)
		{
			//Retrieve the reference to the array list of "DelegateUserInformation" objects to store the list of delegates, rolenames, and usernames, assignment id.
			ArrayList<DelegateUserInformation> delegateUserInfoList = uiWorkflowObject.getWorkflowOptionsObject().getDelegateAssigneeInformation();
			
			if(delegateUserInfoList != null)
			{
				//Create a new delegate info object to represent the data retrieved.
				DelegateUserInformation delegateUserInfo = new DelegateUserInformation();

%>
				<ics:if condition='<%=ics.GetVar("username_list_available_for_AlloyUI").equals("false")%>'>
				<ics:then>
					<ics:getvar name="roleName" output="roleName_for_AlloyUI"/>
					<%
						delegateUserInfo.setRoleName(ics.GetVar("roleName_for_AlloyUI"));
					%>
				</ics:then>
				<ics:else>
					<ics:getvar name="roleName" output="roleName_for_AlloyUI"/>		
					<ics:getvar name="userName" output="userName_for_AlloyUI"/> 
					<%
						// Only if the user has workflow admin roles - username and rolename will be available, otherwise only rolename is available
						delegateUserInfo.setRoleName(ics.GetVar("roleName_for_AlloyUI"));
						delegateUserInfo.setUserName(ics.GetVar("userName_for_AlloyUI"));
					%>
				</ics:else>
				</ics:if>
	
				<ics:if condition='<%= ics.GetList("list_of_delegates")!= null && ics.GetList("list_of_delegates").hasData() %>'>
				<ics:then>
					<ics:listloop listname="list_of_delegates" >
						<ics:listget listname="list_of_delegates" fieldname="delegates" output="delegate_userName"/>
						<% 	
							delegateUserInfo.addDelegateUser(ics.GetVar("delegate_userName")); 
						%>	
					</ics:listloop>
				</ics:then>
				</ics:if>
<%
				if(ics.GetVar("assignmentID_for_AlloyUI") != null)
					delegateUserInfo.setAssignmentId(new Long(ics.GetVar("assignmentID_for_AlloyUI")));
	
				// Add the newly created delegate user info object to the array list.
				delegateUserInfoList.add(delegateUserInfo);
				
			}//end of check for delegateUserInfoList !=null 
		}//end of check for uiWorkflowObject != null
%>
</cs:ftcs>