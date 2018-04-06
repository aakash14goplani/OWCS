<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<div id="ProfileDetailView">
<%-- This page relies on context-based data (session data).  We need to be very
     careful about page caching here, or else we could run into problems with
     the context data.
     
     On Satellite Server, the DetailView template is rendered as a separate 
     pagelet, so that means that there is no cached wrapper around this 
     particular page invocation.  That means our context data is safe.  However,
     while FirstSiteII is designed for use with Satellite Server, users can
     still run it directly through Content Server.  If this were to happen,
     we would run into a page caching problem as soon as we try to access the
     session variables.  
     
     Therefore, as a safety measure for users who are requesting this page
     through Content Server only, we need to forcibly disable caching of this
     page and all parent pages (but not nested pagelets).  This represents
     an acceptable use of the ics:disablecache tag.  Mis-use of this tag can
     lead to catastrophic performance problems.  Any page that was otherwise
     going to be cached until invocation of this tag will be served 
     single-threaded, meaning that it will be a performance bottleneck.  In this
     case, however, the page was never going to be cached anyway, so its use is 
     safe because Satellite Server is being used. --%>
<ics:disablecache recursive="false"/>

<ics:if condition='<%=ics.GetVar("form-to-render") != null%>'>


<ics:then>

	<%-- look up the form and call its element --%>
	<render:lookup varname="formCSElement" key='<%=ics.GetVar("form-to-render")%>' match=":x"/>
	<render:callelement elementname='<%=ics.GetVar("formCSElement")%>' scoped="global"/>

</ics:then>




<ics:else>

	<%-- If form-to-process is there, process it --%>
	<ics:if condition='<%=ics.GetVar("form-to-process") != null%>'>
	<ics:then>
		<render:lookup varname="formProcessingCSElement" key='<%=ics.GetVar("form-to-process")%>' match=":x"/>
	<%-- If there was a reference by that name, we will have a lookup variable.  
		 call the element with global scope and then continue processing.  
		   
		 Form processing in this location will result in output being streamed
		 above the rest of the site.  Ideally, form-processing pages should be
		 very careful what they stream.  In order to prevent extraneous content
		 from landing on the browser's pages, we wrap the output in an xml
		 comment.  This is not guaranteed to work but it is a helpful
		 safety feature.
	
		 It should be noted though, that form processing need not occur only in
		 this location.  Fors can be processed inside any uncached pagelet,
		 provided that Satellite Server is used and the form method is POST.
		 This is possible because Satellite Server will send all of the posted
		 parameters to any uncached pagelet, regardless of the page criteria or
		 current variable scope.  
		
		 Therefore, this form processing location is useful for back-end state
		 changes, whereas the nested pagelet approach may be more useful for
		 rendering searches and so-on. --%>
		<ics:if condition='<%=ics.GetVar("formProcessingCSElement")!=null%>'>
		<ics:then>
			<ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="info" msg='<%="ProfileDetailView processing form "+ics.GetVar("form-to-process")+" using element "+ics.GetVar("formProcessingCSElement")%>'/>
			<render:callelement elementname='<%=ics.GetVar("formProcessingCSElement")%>' scoped="global"/>
			<ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="debug" msg="...form processing complete"/>
		</ics:then>
		</ics:if>
		
	</ics:then>
	</ics:if>

	<%-- display the standard view --%>
	<ics:if condition='<%=ics.GetSSVar("VisitorID")==null%>'>
	<ics:then>
	
	
		<%-- user is not logged in --%>
		<h3><xlat:stream key="dvin/Common/LoginorRegister"/></h3>
		
		<div id="WelcomeUser"><p><xlat:stream key="dvin/Common/NotCurrentlyloggedin"/></p></div>

		<%-- display the login form --%>
		<render:lookup varname="LoginFormCSElement" key='LoginForm' match=":x"/>
		<render:callelement elementname='<%=ics.GetVar("LoginFormCSElement")%>' scoped="global"/>
		
		<%-- Display a link that lets them register
		
			 this link goes back to this page but it has special processing.--%>
		<div id="RegisterLink">
			<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
			<render:lookup varname="LayoutVar" key="Layout" />
			<ics:setvar name="form-to-render" value="RegisterForm" />
			<render:gettemplateurl outstr="aUrl" args="c,cid,p,form-to-render" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
			<p><a href='<string:stream variable="aUrl"/>'>Register as a new user</a></p>
		</div>

	
	</ics:then>
	<ics:else>
	
	
		<%-- user is logged in --%>
		<h3><xlat:stream key="dvin/Common/LogoutorEditProfile"/></h3>
		
		<div id="WelcomeUser"><p><xlat:stream key="dvin/Common/Currentlyloggedin"/> <strong><string:stream ssvariable="VisitorUserName"/></strong>.</p></div>
		
		<div id="LogoutLink">
			<render:lookup key="Wrapper" varname="WrapperVar" match=":x" />
			<render:lookup key="Layout" varname="LayoutVar" />
			<ics:setvar name="form-to-process" value="LogoutUser" />
			<render:gettemplateurl outstr="aUrl" args="c,cid,p,form-to-process" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
			<a href='<string:stream variable="aUrl"/>'><p>Logout</p></a>
		</div>
	
		<div id="EditProfileLink">
			<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
			<render:lookup varname="LayoutVar" key="Layout" />
			<ics:setvar name="form-to-render" value="EditProfileForm" />
			<render:gettemplateurl outstr="aUrl" args="c,cid,p,form-to-render" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
			<a href='<string:stream variable="aUrl"/>'><p>Edit profile</p></a>
		</div>
		
		
	</ics:else>
	</ics:if>

</ics:else>
</ics:if>
</div>
</cs:ftcs>