<!---
	
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="UnitTests.BaseForServerRuleValidatorTests" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			super.setup();
			SRV = getSRV("MaxLength");
			parameters = {MaxLength=5};
			validation.getParameters().returns(parameters);
		</cfscript>
	</cffunction>
	
	<cffunction name="validateReturnsTrueForValidMaxLength" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns(1);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
	<cffunction name="validateReturnsFalseForInvalidMaxLength" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns(123456);
			SRV.validate(validation);
			validation.verifyTimes(1).setIsSuccess(false); 
		</cfscript>  
	</cffunction>

	<cffunction name="validateReturnsFalseForEmptyPropertyIfRequired" access="public" returntype="void" 
		hint="Need to override this from the base test as it isn't valid in here">
	</cffunction>
	
	<cffunction name="validateReturnsTrueForEmptyPropertyIfRequired" access="public" returntype="void">
		<cfscript>
			validation.getObjectValue().returns("");
			validation.getIsRequired().returns(true);
			SRV.validate(validation);
			validation.verifyTimes(0).setIsSuccess(false); 
		</cfscript>  
	</cffunction>
	
</cfcomponent>
