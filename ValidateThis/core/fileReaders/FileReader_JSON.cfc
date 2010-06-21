<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false" extends="BaseFileReader" hint="I am a responsible for reading and processing a JSON file.">

	<cffunction name="processFile" returnType="any" access="public" output="false" hint="I read the validations JSON file and reformat it into a struct">
		<cfargument name="fileName" type="any" required="true" />

		<cfset var ReturnStruct = {PropertyDescs = StructNew(), ClientFieldDescs = StructNew(), FormContexts = StructNew(), Validations = {Contexts = {___Default = ArrayNew(1)}}} />
		
		
		<cfset var theXML = 0 />
		<cfset var xmlConditions = 0 />
		<cfset var theConditions = {} />
		<cfset var theCondition = 0 />
		<cfset var xmlContexts = 0 />
		<cfset var theContexts = {} />
		<cfset var theContext = 0 />
		<cfset var xmlProperties = 0 />
		<cfset var theProperty = 0 />
		<cfset var theName = 0 />
		<cfset var theDesc = 0 />
		<cfset var theRules = 0 />
		<cfset var theRule = 0 />
		<cfset var theVal = 0 />
		<cfset var theParams = 0 />
		<cfset var theParam = 0 />
		<cfset var PropertyType = 0 />
		
		<cfset fileContent = variables.FileSystem.read(arguments.fileName).getContent() />
		<cfset theStruct = deserializeJSON(fileContent) />
		<cfreturn theStruct />		
		
		<!---
		<cfset theXML = XMLParse(arguments.fileName) />
		<cfset xmlConditions = XMLSearch(theXML,"//condition") />
		<cfset xmlContexts = XMLSearch(theXML,"//context") />
		<cfset xmlProperties = XMLSearch(theXML,"//property") />

		<cfloop array="#xmlConditions#" index="theCondition">
			<cfset theConditions[theCondition.XmlAttributes.name] = theCondition.XmlAttributes />
		</cfloop>

		<cfloop array="#xmlContexts#" index="theContext">
			<cfset theContexts[theContext.XmlAttributes.name] = theContext.XmlAttributes />
			<cfset ReturnStruct.FormContexts[theContext.XmlAttributes.name] = theContext.XmlAttributes.formName />
		</cfloop>

		<cfloop array="#xmlProperties#" index="theProperty">
			<cfset theName = theProperty.XmlAttributes.name />
			<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
				<cfset theDesc = theProperty.XmlAttributes.desc />
			<cfelse>
				<cfset theDesc = determineLabel(theName) />
			</cfif>
			<cfif theDesc NEQ theName>
				<cfset ReturnStruct.PropertyDescs[theName] = theDesc />
				<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
					<cfset ReturnStruct.ClientFieldDescs[theProperty.XmlAttributes.clientfieldname] = theDesc />
				<cfelse>
					<cfset ReturnStruct.ClientFieldDescs[theName] = theDesc />
				</cfif>
			</cfif>
		</cfloop>
		<cfloop array="#xmlProperties#" index="theProperty">
			<cfset theRules = XMLSearch(theProperty,"rule") />
			<cfloop array="#theRules#" index="theRule">
				<cfset theVal = {} />
				<cfset theVal.PropertyName = theProperty.XmlAttributes.name />
				<cfif StructKeyExists(theProperty.XmlAttributes,"desc")>
					<cfset theVal.PropertyDesc = theProperty.XmlAttributes.desc />
				<cfelse>
					<cfset theVal.PropertyDesc = determineLabel(theVal.PropertyName) />
				</cfif>
				<cfif StructKeyExists(theProperty.XmlAttributes,"clientfieldname")>
					<cfset theVal.ClientFieldName = theProperty.XmlAttributes.clientfieldname />
				<cfelse>
					<cfset theVal.ClientFieldName = theVal.PropertyName />
				</cfif>
				<cfset theVal.ValType = theRule.XmlAttributes.type />
				<cfset theVal.Parameters = StructNew() />
				<cfset theParams = XMLSearch(theRule,"param") />
				<cfloop array="#theParams#" index="theParam">
					<cfset StructAppend(theVal.Parameters,theParam.XmlAttributes) />
					<cfloop list="CompareProperty,DependentProperty" index="PropertyType">
						<cfif StructKeyExists(theParam.XmlAttributes,PropertyType & "Name")>
							<cfif StructKeyExists(ReturnStruct.PropertyDescs,theParam.XmlAttributes[PropertyType & "Name"])>
								<cfset theVal.Parameters[PropertyType & "Desc"] = ReturnStruct.PropertyDescs[theParam.XmlAttributes[PropertyType & "Name"]] />
							<cfelse>
								<cfset theVal.Parameters[PropertyType & "Desc"] = determineLabel(theParam.XmlAttributes[PropertyType & "Name"]) />
							</cfif>
						</cfif>
					</cfloop>
				</cfloop>
				<cfif StructKeyExists(theRule.XmlAttributes,"failureMessage")>
					<cfset theVal.FailureMessage = theRule.XmlAttributes.failureMessage />
				</cfif>
				<cfif StructKeyExists(theRule.XmlAttributes,"condition") AND StructKeyExists(theConditions,theRule.XmlAttributes.condition)>
					<cfset theVal.Condition = theConditions[theRule.XmlAttributes.condition] />
				<cfelse>
					<cfset theVal.Condition = {} />
				</cfif>
				<cfif StructKeyExists(theRule.XmlAttributes,"contexts") AND NOT ListFindNoCase(theRule.XmlAttributes.contexts,"*")>
					<cfloop list="#theRule.XmlAttributes.contexts#" index="theContext">
						<cfif NOT StructKeyExists(ReturnStruct.Validations.Contexts,theContext)>
							<cfset ReturnStruct.Validations.Contexts[theContext] = ArrayNew(1) />
						</cfif>
						<cfif StructKeyExists(theContexts,theContext)>
							<cfset theVal.FormName = theContexts[theContext].formName />
						</cfif>
						<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
					</cfloop>
				<cfelse>
					<cfset ArrayAppend(ReturnStruct.Validations.Contexts["___Default"],theVal) />
					<cfset theVal.FormName = variables.defaultFormName />
				</cfif>
			</cfloop>
		</cfloop>
		<!--- Add all default rules back into each context --->
		<cfloop collection="#ReturnStruct.Validations.Contexts#" item="theContext">
			<cfif theContext NEQ "___Default">
				<cfloop array="#ReturnStruct.Validations.Contexts.___Default#" index="theVal">
					<cfset ArrayAppend(ReturnStruct.Validations.Contexts[theContext],theVal) />
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn ReturnStruct />
		--->
	</cffunction>
	
</cfcomponent>
	

