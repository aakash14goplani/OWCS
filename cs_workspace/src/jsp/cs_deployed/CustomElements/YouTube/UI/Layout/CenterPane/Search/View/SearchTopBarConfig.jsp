<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
	<!-- Here the field name is the index column on which the sort is performed.-->
	<sortconfig>
		<sortfields>		  
		    <sortfield id="title">
		    	<fieldname>title</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/NameSort1" escape="true"/></displayname>
		    	<sortorder>ascending</sortorder>
		    </sortfield>
		    <sortfield id="updateddate_dsc">
		    	<fieldname>published</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/ModifiedSort1" escape="true"/></displayname>
		    	<sortorder>descending</sortorder>    	
		    </sortfield>
		    <sortfield id="viewCount">
		    	<fieldname>viewCount</fieldname>	    	
		    	<displayname><xlat:stream key="UI/UC1/Layout/ViewCountSort" escape="true"/></displayname>
		    	<sortorder>descending</sortorder>		    	
		    </sortfield>
		</sortfields>
	</sortconfig>
</cs:ftcs>