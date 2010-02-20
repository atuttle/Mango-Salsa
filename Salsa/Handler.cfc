<!---
LICENSE INFORMATION:

Copyright 2010, Adam Tuttle

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.

You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Salsa.
--->
<cfcomponent displayname="Handler" extends="org.mangoblog.plugins.BasePlugin">
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />

		<cfset var paths = arrayNew(1) />
		<cfset var javaLoader = '' />

		<cfset setManager(arguments.mainManager) />
		<cfset setPreferencesManager(arguments.preferences) />
		<cfset setPackage("com/fusiongrokker/plugins/Salsa") />

		<cfset paths[1] = getDirectoryFromPath(getCurrentTemplatePath()) & '/markdownj-1.0.2b4-0.3.0.jar' />
		<cfset javaloader = createObject('component','JavaLoader').init(paths) />
		<cfset variables.markdownUtil = javaloader.create('com.petebevin.markdown.MarkdownProcessor') />

		<!--- setup default preferences --->
		<cfset initSettings(
			formatTarget = 'None'
		) />

		<cfreturn this/>
	</cffunction>
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "Plugin activated. Would you like to <a href='generic_settings.cfm?event=Salsa-settings&amp;owner=Salsa&amp;selected=Salsa-settings'>configure it</a>?" />
	</cffunction>
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "Plugin De-activated" />
	</cffunction>
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<!--- doesn't respond to any asynch events --->
		<cfreturn />
	</cffunction>
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var local = StructNew() />

		<!--- display-formatting events --->
		<cfif left(event.name, 4) eq "post" or left(event.name, 4) eq "page">
			<!--- convert markdown to html --->
			<cfset local.converted = variables.markdownUtil.markdown( arguments.event.data.AccessObject.getContent() ) />
			<!--- get preference of syntax highlighter used --->
			<cfset local.formatTarget = getSetting('formatTarget') />
			<!--- update code blocks for syntax highlighter of choice --->
			<cfif local.formatTarget eq 'ColorCoding'>
				<cfset local.converted = formatForColorCoding( local.converted ) />
			<cfelseif local.formatTarget eq 'Prettify'>
				<cfset local.converted = formatForPrettify( local.converted ) />
			<cfelseif local.formatTarget eq 'SyntaxHighlighter'>
				<cfset local.converted = formatForSyntaxHighlighter( local.converted ) />
			</cfif>
			<!--- yeah baby! --->
			<cfset arguments.event.data.AccessObject.setContent( local.converted ) />

		<cfelseif event.name EQ "settingsNav">
			<!--- add our settings link --->
			<cfset local.link = structnew() />
			<cfset local.link.owner = "Salsa">
			<cfset local.link.page = "settings" />
			<cfset local.link.title = "Salsa" />
			<cfset local.link.eventName = "Salsa-settings" />
			<cfset arguments.event.addLink(local.link)>

		<cfelseif event.name EQ "Salsa-settings">
			<!--- render settings page --->
			<cfsavecontent variable="local.content">
				<cfoutput>
					<cfinclude template="settings.cfm">
				</cfoutput>
			</cfsavecontent>
			<cfset local.data = arguments.event.data />
			<cfset local.data.message.setTitle("Markdown formatting settings") />
			<cfset local.data.message.setData(local.content) />
		</cfif>

		<cfreturn arguments.event />
	</cffunction>
	<cffunction name="formatForPrettify" output="false" returntype="String">
		<cfargument name="data" type="string" required="true" />
		<cfset replList = "<pre><code>,</code></pre>,<code>" />
		<cfset withList = "<pre class='prettyprint'>,</pre>,<code class='prettyprint'>" />
		<cfreturn replaceList(arguments.data, replList, withList) />
	</cffunction>
	<cffunction name="formatForColorCoding" output="false" returntype="String">
		<cfargument name="data" type="string" required="true" />
		<cfset replList = "<pre><code>,</code></pre>,&lt;,&gt;" />
		<cfset withList = "<code>,</code>,<,>" />
		<cfreturn replaceList(arguments.data, replList, withList) />
	</cffunction>
	<cffunction name="formatForSyntaxHighlighter" output="false" returntype="String">
		<cfargument name="data" type="string" required="true" />
		<cfset replList = "<pre><code>,</code></pre>" />
		<cfset withList = "[code:cf],[/code]" />
		<cfreturn replaceList(arguments.data, replList, withList) />
	</cffunction>
</cfcomponent>