<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<cs:ftcs>

<!-- OpenMarket/Gator/Scripts/ValidateFieldsJSP -->

<script type="text/javascript">

function checkNewEnumData (Type, EnumValue, Elength)
{	
	var obj = document.forms[0];
	
	if (obj.elements[Type].selectedIndex)
		var type= obj.elements[Type][obj.elements[Type].selectedIndex].value;
	else
		var type= obj.elements[Type].value;
		
	if (obj.elements[EnumValue].value=="")
	{
		alert('<xlat:stream key="dvin/UI/Error/specifyanvalueE" escape="true" encode="false"/>');
		obj.elements[EnumValue].focus();
		return false;
 	}

	if ( type=="string") 
	{ 
		if (obj.elements[Elength].value=="")
		{
			alert('<xlat:stream key="dvin/UI/ErrorspecifyanSTRINGLENGTHE" escape="true" encode="false"/>');
			obj.elements[Elength].focus();
			return false;	
		}
				 
		if (!IsInt(obj.elements[Elength].value))
		{	
			alert('<xlat:stream key="dvin/UI/Error/specifyanSTRINGLENGTHasNumberE" escape="true" encode="false"/>');
			obj.elements[Elength].focus();
			return false;	
		}	
					
	 	if (IsInt(obj.elements[Elength].value))
		{ 
			obj.elements[Elength].value = parseInt(obj.elements[Elength].value,10);
			
			if (obj.elements[Elength].value < 0 || obj.elements[Elength].value > 255) 
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyanSTRINGLENGTHbetween0and255E" escape="true" encode="false"/>');
				obj.elements[Elength].focus();
				return false;	
			}
        }
				    
   		if (obj.elements[EnumValue].value.length > parseInt(obj.elements[Elength].value))
	 	{ 
        	var replacestr=/\bVariables.value\b/ ;
            var xlatstr= '<xlat:stream key="dvin/UI/Error/lengthnolongerthanElengthvalueE" encode="false" escape="true"/>' ;
            alert(xlatstr.replace(replacestr, parseInt(obj.elements[Elength].value)));
 			obj.elements[EnumValue].focus();
			return false;
		}
	}
				
	if (type=="int")
	{
		if (!IsInt(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifythevalueasINTEGERE" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}

		if (!IsInteger(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
	}
		
	if (type=="short")
	{
		if (!IsInt(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifythevalueasSHORTINTEGERE" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
			
		if (!IsShort(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetween0AA255E" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
	}
		
	if (type=="long")
	{
		if (!IsInt(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifythevalueasLONGINTEGERE" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
			
		if (!IsLong(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
	}	
									
 	if (type=="double")
	{
		if (!IsNumber(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Error/specifythevalueasFLOATE" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
   	}	
 	
 	if (type=="money")
	{
		if (!IsNumber(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/AT/Common/specifyvalidmoneyvalue" escape="true" encode="false"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
   	}	
					
	if (type=="timestamp")
	{
		if (!IsDate(obj.elements[EnumValue].value))
		{
			alert('<xlat:stream key="dvin/UI/Common/PleaseEnterDateInFormat" encode="false" escape="true"/>');
			obj.elements[EnumValue].focus();
			return false;
		}
		
		if (!IsDateNumber(obj.elements[EnumValue].value))
		{
			obj.elements[EnumValue].focus();
			return false;
		}
	}		

	return true;
}

function checkAttributeFields (PType, PConstrainttype, PLength, PLowerrange, PUpperrange, PNullAllowed, PDefaultval, PEnumValues)
{ 	
	var obj = document.forms[0];
	
	var type = obj.elements[PType].value;
	var constraintType = obj.elements[PConstrainttype].value;
	var nullAllowed = obj.elements[PNullAllowed].value;
 
	// check type 
	if (type=="string") 
  	{			
		if (obj.elements[PLength].value == "")
	 	{
			alert('<xlat:stream key="dvin/UI/Error/specifyanSTRINGLENGTHasNumberE" escape="true" encode="false"/>');
			obj.elements[PLength].focus();
			return false;	
		}
		
		if (!IsInt(obj.elements[PLength].value))
		{	
			alert('<xlat:stream key="dvin/UI/Error/specifyanSTRINGLENGTHasNumberE" escape="true" encode="false"/>');
			obj.elements[PLength].focus();
			return false;	
		}	

		if (IsInt(obj.elements[PLength].value))
		{ 
		 	obj.elements[PLength].value= parseInt(obj.elements[PLength].value,10);
		 	
		 	if (obj.elements[PLength].value < 0 || obj.elements[PLength].value > 255) 
		 	{
				alert('<xlat:stream key="dvin/UI/Error/specifyanSTRINGLENGTHbetween0and255E" escape="true" encode="false"/>');
				obj.elements[PLength].focus();
				return false;	
		 	}
    	}
  	}

 	// check if PLowerrange, PUpperrange are empty
 	if (constraintType == 'range')
 	{
	  	if (obj.elements[PLowerrange])  
		{ 			
	      	if (obj.elements[PLowerrange].value=="")
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheLowerrangelimitE" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;
			}
	  	}
		
		if (obj.elements[PUpperrange]) 
		{
			if (obj.elements[PUpperrange].value=="")
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheUpperrangelimitE" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}
 	}
 	 
 	// check if PEnumValues is empty
 	if (constraintType == 'enum')
 	{
		if (obj.elements[PEnumValues]) 
		{            
			if (obj.elements[PEnumValues].options.length==0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyatleastoneenumerationvalueE" escape="true" encode="false"/>');
				obj.elements[PEnumValues].focus();
				return false;
			}
	  	}	
 	}
 	
	// check the Lowerrange and Upperrange are valid for type selected
	if( constraintType == 'range' && obj.elements[PLowerrange] && obj.elements[PUpperrange])
	{
    	if (type=="int")
		{
			if (!IsInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsInt(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (!IsInteger(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsInteger(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseInt(obj.elements[PUpperrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PLowerrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PUpperrange].value) < parseInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}
						
	  	if (type=="short")
		{
			if (!IsInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasSHORTINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsInt(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasSHORTINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}

			if (!IsShort(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetween0AA255E" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsShort(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetween0AA255E" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PUpperrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PLowerrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PUpperrange].value) < parseInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}
						
		if (type=="long")
		{
			if (!IsInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasLONGINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsInt(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasLONGINTtryagainE" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (!IsLong(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
						 
			if (!IsLong(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseInt(obj.elements[PUpperrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PLowerrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseInt(obj.elements[PUpperrange].value) < parseInt(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}
      		
		if (type=="double")
		{
        	if (!IsNumber(obj.elements[PLowerrange].value))
			{
        		alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasFLOATtryagainE" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
               
			if (!IsNumber(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasFLOATtryagainE" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseFloat(obj.elements[PUpperrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseFloat(obj.elements[PLowerrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseFloat(obj.elements[PUpperrange].value) < parseFloat(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}			

		if (type=="money")
		{
        	if (!IsNumber(obj.elements[PLowerrange].value))
			{
        		alert('<xlat:stream key="dvin/AT/Common/specifyvalidmoneyvalue" escape="true" encode="false"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
               
			if (!IsNumber(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/AT/Common/specifyvalidmoneyvalue" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseFloat(obj.elements[PUpperrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyUpperrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
							
			if (parseFloat(obj.elements[PLowerrange].value) < 0)
			{
				alert('<xlat:stream key="dvin/UI/Error/specifyLowerrangelimitValueasPositiveNum" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
			
			if (parseFloat(obj.elements[PUpperrange].value) < parseFloat(obj.elements[PLowerrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}			
		
		if (type=="timestamp")
		{
			if (!IsDate(obj.elements[PLowerrange].value))
			{ 
				alert('<xlat:stream key="dvin/UI/Common/PleaseEnterDateInFormat" encode="false" escape="true"/>');
				obj.elements[PLowerrange].focus();
				return false;	
			}	
												
			if (!IsDate(obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Common/PleaseEnterDateInFormat" encode="false" escape="true"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
								
			if (!IsDateNumber(obj.elements[PLowerrange].value))
			{
				obj.elements[PLowerrange].focus();
				return false;	
			}	
								
			if (!IsDateNumber(obj.elements[PUpperrange].value))
			{
				obj.elements[PUpperrange].focus();
				return false;
			}
								
			if (DateCompare(obj.elements[PLowerrange].value,obj.elements[PUpperrange].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/LowerUpperrangelimitDiff" escape="true" encode="false"/>');
				obj.elements[PUpperrange].focus();
				return false;
			}
		}	
  	}

	// check the 'Default Value' and Check validation for RANGE or ENUMERATION-->

	if (nullAllowed == "F" && obj.elements[PDefaultval])
	{   
		if (obj.elements[PDefaultval].value=="")
		{
			alert('<xlat:stream key="dvin/AT/HFields/MustspecDEFAULT" escape="true" encode="false"/>');
			obj.elements[PDefaultval].focus();
			return false;
		}
		
		if ( type=="string") 
		{
			if (obj.elements[PLength].value!="")
			{
				var lengthRequired=parseInt(obj.elements[PLength].value);
				var lengthEntered=parseInt(obj.elements[PDefaultval].value.length);
					       
				if (lengthEntered>lengthRequired)
				{
					alert('<xlat:stream key="dvin/UI/Error/defaultValuelengthlessthenallowedE" escape="true" encode="false"/>');
					obj.elements[PDefaultval].focus();
					return false;
				}
						 
			}
		}
		
		if (type=="int")
		{
			if (!IsInt(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifydefaultValueINTEGERtryagainE" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}

			if (!IsInteger(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
		}
				
		if (type=="short")
		{
			if (!IsInt(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifydefaultValueSHORTINTEGERtryagainE" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}

			if (!IsShort(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetween0AA255E" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
		}
				
		if (type=="long")
		{	
			if (!IsInt(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifydefaultValueLONGINTEGERtryagainE" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
				
			if (!IsLong(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifytheINTEGERvaluebetweenn65535and65535E" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
		}

		if (type=="double")
		{
			if (!IsNumber(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Error/specifydefaultValueFLOATtryagainE" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
        }	
			
		if (type=="money")
		{
			if (!IsNumber(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/AT/Common/specifyvalidmoneyvalue" escape="true" encode="false"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
        }	
		
		if (type=="timestamp")
		{   
			if (!IsDate(obj.elements[PDefaultval].value))
			{
				alert('<xlat:stream key="dvin/UI/Common/PleaseEnterDateInFormat" encode="false" escape="true"/>');
				obj.elements[PDefaultval].focus();
				return false;
			}
							
			if (!IsDateNumber(obj.elements[PDefaultval].value))
			{
				obj.elements[PDefaultval].focus();
				return false;
			} 
		}	

		if (type=="boolean")
		{   
			if (!IsBoolean(obj.elements[PDefaultval].value))
			{
// should not happen if we have a picker... so avoid confusing localization issues				
//				alert('You must specify \'true\' or \'false\'');
				obj.elements[PDefaultval].focus();
				return false;
			}	
		}
		
		// check Whether the value of Default Value is between Lowerrange and Upperrange Column! in RANGE

		if (constraintType == 'range' && obj.elements[PLowerrange] && obj.elements[PUpperrange])
		{
			if (type=="int" || type=="long" || type=="short")
			{
				var DefaultVal=parseInt(obj.elements[PDefaultval].value);
				var LowVal=parseInt(obj.elements[PLowerrange].value);
				var UpperVal=parseInt(obj.elements[PUpperrange].value);
				 
				if(DefaultVal>UpperVal || LowVal>DefaultVal)
				{	
					alert('<xlat:stream key="dvin/UI/Error/setdefaultvaluebetweenLowerUpperrangelimitE" escape="true" encode="false"/>');
					obj.elements[PDefaultval].focus();
					return false;	
				}	
			}

			if(type=="double" || type == "money")
			{
           		var DefaultVal=parseFloat(obj.elements[PDefaultval].value);
				var LowVal=parseFloat(obj.elements[PLowerrange].value);
				var UpperVal=parseFloat(obj.elements[PUpperrange].value);
				 
				if(DefaultVal>UpperVal || LowVal>DefaultVal)
				{	
					alert('<xlat:stream key="dvin/UI/Error/setdefaultvaluebetweenLowerUpperrangelimitE" escape="true" encode="false"/>');
					obj.elements[PDefaultval].focus();
					return false;	
				}
			}   
				
			if (type=="timestamp")
			{
				var DefaultVal=obj.elements[PDefaultval].value;
				var LowVal=obj.elements[PLowerrange].value;
				var UpperVal=obj.elements[PUpperrange].value;
																															
				if (DateCompare(DefaultVal,UpperVal)|| DateCompare(LowVal,DefaultVal))
				{	
					alert('<xlat:stream key="dvin/UI/Error/setdefaultvaluebetweenLowerUpperrangelimitE" escape="true" encode="false"/>');
					obj.elements[PDefaultval].focus();
					return false;	
				}
			}	
		}

		// check whether the value of Default Value is one of the enumerations

	  	if (constraintType == 'enum' && obj.elements[PEnumValues])
		{ 
			if(obj.elements[PEnumValues].options.length > 0)
			{
				var bFound = false;
				
				for (var i = 0; i < obj.elements[PEnumValues].options.length; i++)
				{ 
					if (obj.elements[PEnumValues].options[i].value == obj.elements[PDefaultval].value)
					{
						bFound = true;
						break;
					}
           		}
				
				if (!bFound)
				{	  
					alert('<xlat:stream key="dvin/UI/Error/selectdefaultvaluefromtheLegalvaluesE" escape="true" encode="false"/>');
					obj.elements[PDefaultval].focus();
					return false;	
				}	   	
			}
		}
	}	// Default value checking ended
 	 	
	return true;
}

function IsInt(str) 
{
	if (str == "")
		return false;
	
	/* strip leading zeroes to prevent false negative! */
	while (str.charAt(0) == '0' && str.length > 1) 
		str = str.substr(1);
	
	var i = parseInt(str);
	
	if (isNaN(i))
		return false;
	
	i = i.toString();
	
	if (i != str)
		return false;	// so although we strip leading zeroes, we don't tolerate them!
	
	return true;
}

// check if the string is 'Integer'

function IsInteger(StrVar)
{
 	var StrNum=parseInt(StrVar);

 	if(IsInt(StrVar))
 	{
  		if(StrNum >=-65535 && 65535 >= StrNum)
   			return true;
		else 
	 		return false; 
 	}
 	else
  	return false; 
}
// Check if the string is a positive int
function IsPositiveInt(StrVar) {
	if (!IsInt(StrVar)) return false;
	if (parseInt(StrVar) < 0) return false;
	return true;
}

// check if the string is 'Short'

function IsShort(StrVar)
{
 	var StrNum=parseInt(StrVar);

 	if(IsInt(StrVar))
 	{
  		if(StrNum >= 0 && 255 >= StrNum)
   			return true;
 	}
 	
	return false; 
}

// check if the string is the 'Long'

function IsLong(StrVar)
{
 	var StrNum=parseInt(StrVar);
	
 	if(IsInt(StrVar))
 	{
  		if(StrNum >= -65535 && 65535 >= StrNum)
   			return true;
 	}
	
  	return false; 
}

// check if the string is 'Float'

function IsNumber(str)
{
    return /^[-+]?\d*((\.\d+)([eE][-+]?\d+)?)?$/.test(str);
}

function IsBoolean(str)
{
	if ('true' == str || 'false' == str)
		return true;
	
	return false;
}

// check if the string is 'Date'

function IsDate(StrVar)
{
 	if (StrVar.length != 19)
 		return false;
  
	if(StrVar.charAt(4)!="-" || StrVar.charAt(7)!="-" || StrVar.charAt(10)!=" " || StrVar.charAt(13)!=":" || StrVar.charAt(16)!=":") 
 		return false;
 		
	if(!IsInt(StrVar.substring(0,4)))	return false;
	if(!IsInt(StrVar.substring(5,7))) 	return false;
	if(!IsInt(StrVar.substring(8,10))) 	return false;
	if(!IsInt(StrVar.substring(11,13)))	return false;
	if(!IsInt(StrVar.substring(14,16)))	return false;
	if(!IsInt(StrVar.substring(17,19))) return false;

	return true;
}

<!--to check the day, month, hour, minute and second number  -->

function IsDateNumber(StrVar)
{			
 	var lastNum=StrVar.length-1;
 	
 	if (StrVar.substring(5,7)>12 || 0>StrVar.substring(5,7))
  	{
 		alert('<xlat:stream key="dvin/UI/Error/specifyMonthNumberbetween0and12E" escape="true" encode="false"/>');
	 	return false;
	}
 
 	if (StrVar.substring(8,10)>31 || 0>StrVar.substring(8,10))
  	{
 		alert('<xlat:stream key="dvin/UI/Error/specifyDayNumberbetween0and31E" escape="true" encode="false"/>');
	 	return false;
	}
 
 	if (StrVar.substring(11,13)>23 || 0>StrVar.substring(11,13))
  	{
 		alert('<xlat:stream key="dvin/UI/Error/specifyHourNumberbetween0and23E" escape="true" encode="false"/>');
	 	return false;
	} 
 
 	if (StrVar.substring(14,16)>59 || 0>StrVar.substring(14,16))
  	{
 		alert('<xlat:stream key="dvin/UI/Error/specifyMinuteNumberbetween0and59E" escape="true" encode="false"/>');
	 	return false;
	}
	
 	if (StrVar.substring(17,19)>59 || 0>StrVar.substring(17,19))
  	{
 		alert('<xlat:stream key="dvin/UI/Error/specifySecondNumberbetween0and59E" escape="true" encode="false"/>');
	 	return false;
	}
 
 	return true;
}

// to compare the 'Date', if the Str1 later than Str2 return 'true', else return 'false'
// note: a true return is a FAIL

function DateCompare(Str1,Str2)
{	
 	var Data1=Str1.substring(0,4);
 	var Data2=Str2.substring(0,4);
 	
 	var DInt1=parseInt(Data1);
 	var DInt2=parseInt(Data2);
 	
 	if (DInt1 > DInt2)
 		return true;
 	
 	if(DInt1 == DInt2)				// same year
 	{      
		Data1=Str1.substring(5,7);
	 	Data2=Str2.substring(5,7);

	 	DInt1=parseInt(Data1);
	 	DInt2=parseInt(Data2);
	 	
	 	if (DInt1 >DInt2)
	 		return true;
	 	
	 	if(DInt1 == DInt2)			// same month
	 	{          
	  		Data1=Str1.charAt(8);	// testing only first char of day? why?
			Data2=Str2.charAt(8);
	 		DInt1=parseInt(Data1);
			DInt2=parseInt(Data2);
			
    		if(DInt1 > DInt2)
    			return true;
    		
			if(DInt1 == DInt2)		// eh?  
			{
				Data1=Str1.charAt(9);	// now testing the 2nd char?
				Data2=Str2.charAt(9);
				DInt1=parseInt(Data1);
				DInt2=parseInt(Data2);
				
				if (DInt1 > DInt2)
					return true;
				
				if (DInt1 == DInt2)		// same day 
					return false;		// allow same day? assume that time range is okay?
    		}
	 	}
 	}
 	
 	return false;
} 		 
  
</script>

</cs:ftcs>
