<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent extends="UnitTests.BaseTestCase" output="false">
	
	<cffunction name="setUp" access="public" returntype="void">
		<cfscript>
			objectChecker = CreateObject("component","ValidateThis.util.ObjectChecker").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	</cffunction>
	
	<cffunction name="isCFCReturnsTrueforCFC" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(true,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isCFCReturnsFalseforNonObject" access="public" returntype="void">
		<cfscript>
			var obj = "x";
			assertEquals(false,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isCFCReturnsFalseForJavaObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("java","java.lang.Integer");
			assertEquals(false,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isWheelsReturnsTrueforWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","models.FakeWheelsObject_Fixture").init();
			debug(getMetadata(obj));
			assertEquals(true,objectChecker.isCFC(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isWheelsReturnsFalseforNonWheelsObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(false,objectChecker.isWheels(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsTrueforGroovyObject" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","groovy.lang.FakeGroovyObject_Fixture").init();
			debug(obj);
			debug(getMetadata(obj));
			assertEquals(true,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsFalseforCFC" access="public" returntype="void">
		<cfscript>
			var obj = CreateObject("component","fixture.APlainCFC_Fixture").init();
			assertEquals(false,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="isGroovyReturnsFalseforPOJO" access="public" returntype="void">
		<cfscript>
			// need to create a java object var obj = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(false,objectChecker.isGroovy(obj));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsTrueForExistingMethodInCFC" access="public" returntype="void">
		<cfscript>
			var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(true,objectChecker.propertyExists(cfc,"FirstName"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsFalseForNonExistentMethodInCFC" access="public" returntype="void">
		<cfscript>
			var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(false,objectChecker.propertyExists(cfc,"Blah"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsTrueForExistingMethodInWheelsObject" access="public" returntype="void">
		<cfscript>
			// must create a Wheels object var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(true,objectChecker.propertyExists(obj,"FirstName"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsFalseForNonExistentMethodInWheelsObject" access="public" returntype="void">
		<cfscript>
			// must create a Wheels object var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(false,objectChecker.propertyExists(obj,"Blah"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsTrueForExistingMethodInGroovyObject" access="public" returntype="void">
		<cfscript>
			// must create a groovy object var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(true,objectChecker.propertyExists(obj,"FirstName"));
		</cfscript>  
	</cffunction>

	<cffunction name="propertyExistsReturnsFalseForNonExistentMethodInGroovyObject" access="public" returntype="void">
		<cfscript>
			// must create a groovy object var cfc = CreateObject("component","fixture.ServerRuleValidatorTest_Fixture").init();
			assertEquals(false,objectChecker.propertyExists(obj,"Blah"));
		</cfscript>  
	</cffunction>

</cfcomponent>

