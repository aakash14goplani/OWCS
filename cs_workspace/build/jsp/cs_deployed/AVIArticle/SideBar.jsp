<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>

<ics:callelement element="avisports/checkcommunity"/>

<ics:callelement element="avisports/getdata">
	<ics:if condition='<%=ics.GetVar("community")=="true"%>'>
		<ics:then>
			<ics:argument name="attributes" value="relatedStories,relatedLinks,poll" /> 
		</ics:then>
		<ics:else>
			<ics:argument name="attributes" value="relatedStories,relatedLinks" />  
		</ics:else>
	</ics:if>
</ics:callelement>

<insite:slotlist field="relatedStories" tname="Summary/Highlight"
				 countervar="articleNb" emptytext=" [ Drop Article #$(Variables.articleNb) Here ]"
				 >
<div class="box">
<h2 class="title">Related Stories</h2>
	<c:forEach var="article" items="${asset.relatedStories}" end="2">
		<insite:calltemplate c="AVIArticle" cid="${article.id}" cssstyle="highlight" />
	</c:forEach>
	<insite:ifedit>
		<% // in edit mode, draw up to 2 empty slots with Summary/Highlight %>
		<c:forEach begin="${fn:length(asset.relatedStories) + 1}" end="2">
			<% // tag inherits all attributes from parent insite:slotlist tag %>
			<insite:calltemplate cssstyle="highlight" />
		</c:forEach>
	</insite:ifedit>
</div>
</insite:slotlist>
<insite:slotlist field="relatedLinks" tname="Summary/Link"
				 countervar="articleNb" emptytext=" [ Drop Article #$(Variables.articleNb) Here ]">
	<div class="box">
		<h2 class="title">Related Links</h2>
		<ul>
			<c:forEach var="article" items="${asset.relatedLinks}">
				<li><insite:calltemplate c="AVIArticle" cid="${article.id}" /></li>
			</c:forEach>
			<insite:ifedit>
				<% // in edit mode, draw up to 5 empty slots with Summary/SideBar %>
				<c:forEach begin="${fn:length(asset.relatedLinks) + 1 }" end="6">
					<% // tag inherits all attributes from parent insite:slotlist tag %>
					<li><insite:calltemplate /></li>
				</c:forEach>
			</insite:ifedit>
		</ul>
	</div>
</insite:slotlist>

<ics:if condition='<%=ics.GetVar("community")=="true"%>'>
	<ics:then>
		<style>
		#poll .fw_poll {
		  font: 11px Arial, Helvetica, sans-serif;
		  color:
		}
		#poll .fw_poll .fw_polls_widgetBorder {
		   background-color: #eff0f0;
		}
		#poll .fw_poll .fw_polls_themeOne_Heading {
		   background-color: #D5D5D5;
		   margin-bottom: 15px;
		}
		#poll .fw_poll .fw_polls_themeOne_questionBox {
		   padding: 0 40px 10px 0;
		}
		#poll .fw_poll .fw_polls_themeOne_checkBoxText {
		  font-family: Arial;
		  font-weight: bold; 
		}
		#poll .fw_poll.fw_poll_open_design .fw_polls_themeOne_HeadingText {
		  color: black;
		}
		#poll .fw_poll .fw_poll_open_design .fw_polls_themeOne_checkBoxText {
		  color: black;
		}

		#poll .fw_poll .fw_poll_open_design .fw_polls_leftButton,
		#poll .fw_poll .fw_poll_open_design .fw_polls_leftButtonHover,
		#poll .fw_poll .fw_poll_open_design .fw_polls_leftButtonClick {
		  background:url("../../static/poll/1.0/images/buttons/button_left_blue.png") no-repeat;
		}

		#poll .fw_poll .fw_poll_open_design .fw_polls_middleButton,
		#poll .fw_poll .fw_poll_open_design .fw_polls_middleButtonHover,
		#poll .fw_poll .fw_poll_open_design .fw_polls_middleButtonClick {
		  background:url("../../static/poll/1.0/images/buttons/button_middle_blue.png") repeat-x;
		}
		#poll .fw_poll .fw_poll_open_design .fw_polls_rightButton,
		#poll .fw_poll .fw_poll_open_design .fw_polls_rightButtonHover,
		#poll .fw_poll .fw_poll_open_design .fw_polls_rightButtonClick {
		  background:url("../../static/poll/1.0/images/buttons/button_right_blue.png") no-repeat;
		}

		</style>
		<div id="poll">
			<insite:calltemplate slotname="poll" field="poll" tname="/CGTemplate" c="CGPoll" cid='${not empty asset.poll ? asset.poll.id : ""}' emptytext="[ Drop Poll ]" />
		</div>
	</ics:then>
</ics:if>
</cs:ftcs>