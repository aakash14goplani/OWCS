<%@page import="java.util.Date"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"%>
<%@ taglib prefix="ccuser" uri="futuretense_cs/ccuser.tld"%>
<%@ taglib prefix="mail" uri="futuretense_cs/mail.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="java.util.Properties"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.MessagingException"%>
<%@ page import="javax.mail.PasswordAuthentication"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
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
	<%-- Fetch pubid on the basis of site given (site_name) --%>
<%
	String site = ics.GetVar("site_name");
	String fetch_pubid = "select id from publication where name='" + site + "'";	
%>	
	<ics:sql table="Publication" listname="pubid_list" sql='<%=fetch_pubid %>' />
	<ics:listget fieldname="id" listname="pubid_list" output="pubid"/>
	<%-- Fetch all assettypes on the basis of pubid fetched above --%>
<%
	String fetch_asset_types = "select assettype from assetpublication where pubid=" + ics.GetVar("pubid") + "";	
%>
	<ics:sql table="AssetPublication" listname="asset_type_list" sql='<%=fetch_asset_types %>' />
	<ics:if condition='<%=null != ics.GetList("asset_type_list") && ics.GetList("asset_type_list").hasData()%>'>
		<ics:then>
			<ics:setvar name="count" value="0"/>
			<ics:listloop listname="asset_type_list">
				<ics:listget fieldname="assettype" listname="asset_type_list" output="asset_type"/>
				<%-- Fetch all asset details of given asset type --%>
			<%
				String asset_type = ics.GetVar("asset_type");
				if(Utilities.goodString(asset_type)){
					String fetch_asset_details = "select id, name, createdby, createddate, updatedby, updateddate from " + asset_type + " where status != 'VO'";
			%>
			 		<ics:sql table='<%=asset_type %>' listname="asset_detail_list" sql='<%=fetch_asset_details %>' />
			 		<ics:listget fieldname="id" listname="asset_detail_list" output="asset_id"/>
			 		<ics:listget fieldname="name" listname="asset_detail_list" output="asset_name"/>
			 		<ics:listget fieldname="createdby" listname="asset_detail_list" output="createdby"/>
			 		<ics:listget fieldname="createddate" listname="asset_detail_list" output="createddate"/>
			 		<ics:listget fieldname="updatedby" listname="asset_detail_list" output="updatedby"/>
			 		<ics:listget fieldname="updateddate" listname="asset_detail_list" output="updateddate"/>
			 		<ics:setvar name="count" value='<%=String.valueOf(Integer.valueOf(ics.GetVar("count")) + 1) %>'/>
			 		asset_type : <ics:getvar name="asset_type" /><br/>
			 		asset_id : <ics:getvar name="asset_id" /><br/>
			 		asset_name : <ics:getvar name="asset_name" /><br/>
			 		createdby : <ics:getvar name="createdby" /><br/>
			 		createddate : <ics:getvar name="createddate" /><br/>
			 		updatedby : <ics:getvar name="updatedby" /><br/>
			 		updateddate : <ics:getvar name="updateddate" /><br/><br/><br/>
			<%
			 	}
			%>	
			</ics:listloop>
		</ics:then>
	</ics:if>
	total assets : <ics:getvar name="count"/> <br/><br/>
	
<%
	String fetch_user_id = "select DISTINCT username from userpublication"; 
%>	
 	<%-- Get all users and their email in WCS --%>
 	<ics:sql table="UserPublication" listname="user_list" sql="select DISTINCT username from userpublication" />
 	<ics:if condition='<%=null != ics.GetList("user_list") && ics.GetList("user_list").hasData()%>'>
		<ics:then>
			<ics:listloop listname="user_list">
				<ics:listget fieldname="username" listname="user_list" output="loggedInUserId"/>
				<usermanager:getuser user='<%= ics.GetVar("loggedInUserId")%>' objvarname="userObj" />
				<ccuser:getname name="userObj" varname="uname"/>
				<ccuser:getemail name="userObj" varname="uemail" />
				<ics:getvar name="uname" /> : <ics:getvar name="uemail" /><br/>
				<ics:if condition='<%=Utilities.goodString(ics.GetVar("uemail")) %>'>
					<ics:then>
						<ics:setvar name='<%=ics.GetVar("uname") %>' value='<%=ics.GetVar("uemail") %>' />
					</ics:then>
				</ics:if>
			</ics:listloop>
		</ics:then>
	</ics:if>	
	
<%
	// smtp.mail.yahoo.com, smtp.live.com, smtp.gmail.com
	/* try{
		final String username = "kinley.christian1988@gmail.com";
		final String password = "fake_E-mail_id123";
	
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "465");
		props.put("mail.smtp.user", username);
		props.put("mail.smtp.socketFactory.port", 465);
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.socketFactory.fallback", "false");

		Session session1 = Session.getDefaultInstance(props);
			
		Message message = new MimeMessage(session1);
		message.setFrom(new InternetAddress(username));
		InternetAddress[] toAddresses = { new InternetAddress("goplaniaakash14@gmail.com") };
        message.setRecipients(Message.RecipientType.TO, toAddresses);
		message.setSubject("Testing Subject");
		message.setSentDate(new Date());
		message.setText("Dear Mail Crawler,\n\n No spam to my email, please!");

		Transport t = session1.getTransport("smtp");
        t.connect("smtp.gmail.com", 465, username, password);
        t.sendMessage(message, message.getAllRecipients());
        t.close();

		out.println("Done");
	}catch (Exception e) {
		out.println("Exception Occured : " + e.getMessage());
	}*/
	try{
		String to = "sachinicon1@gmail.com";
		String username = "kinley.christian1988@gmail.com";
		String password = "fake_E-mail_id123";
%>	
		<ics:clearerrno/>
		<mail:send to='<%=to %>' from='<%=username %>' body="Hello World" subject="Hello" />
		Error : <ics:geterrno/>
<%
	}catch (Exception e) {
		out.println("Exception Occured : " + e.getMessage());
	}
 %>
</cs:ftcs>