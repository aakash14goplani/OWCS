<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
	<!-- Here the field name is the index column on which the sort is performed.-->

	<sortconfig>
		<sortfields>		  
		    <sortfield id="name_asc">
		    	<fieldname>name</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/NameSort1" escape="true"/></displayname>
		    	<sortorder>ascending</sortorder>
		    </sortfield>		   
		    <sortfield id="name_dsc">
		    	<fieldname>name</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/NameSort2" escape="true"/></displayname>
		    	<sortorder>descending</sortorder>
		    </sortfield>
		    <sortfield id="AssetType_Description">
		    	<fieldname>AssetType_Description</fieldname>
		    	<displayname><xlat:stream key="dvin/Common/AssetType" escape="true"/></displayname>
		    	<sortorder>ascending</sortorder>
		    </sortfield>
		    <sortfield id="locale">
		    	<fieldname>locale</fieldname>
		    	<displayname><xlat:stream key="dvin/UI/Admin/Locale" escape="true"/></displayname>
		    	<sortorder>ascending</sortorder>
		    </sortfield>
		    <sortfield id="updateddate_dsc">
		    	<fieldname>updateddate</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/ModifiedSort1" escape="true"/></displayname>
		    	<sortorder>descending</sortorder>
		    </sortfield>
		    <sortfield id="updateddate_asc">
		    	<fieldname>updateddate</fieldname>
		    	<displayname><xlat:stream key="UI/UC1/Layout/ModifiedSort2" escape="true"/></displayname>
		    	<sortorder>ascending</sortorder>
		    </sortfield>
		</sortfields>
	</sortconfig>
</cs:ftcs>