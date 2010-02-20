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
<cfscript>
	if(structKeyExists(form, 'formatTarget')){
		setSettings(formatTarget: form.formatTarget);
		persistSettings();
		event.data.message.setstatus("success");
		event.data.message.setType("settings");
		event.data.message.settext("Settings Updated");
	}
</cfscript>
<form action="" method="post">
	<input type="hidden"
	<fieldset>
		<legend>Syntax Highlighting</legend>
		<p>Please select the syntax highlighting plugin you are using on your blog.</p>
		<p>
			<label for="formatTarget">Plugin:</label><br/>
			<select name="formatTarget" id="formatTarget" class="required">
				<option value="None"<cfif getSetting('formatTarget') eq "None"> selected="selected"</cfif>>None</option>
				<option value="ColorCoding"<cfif getSetting('formatTarget') eq "ColorCoding"> selected="selected"</cfif>>Color Coding</option>
				<option value="Prettify"<cfif getSetting('formatTarget') eq "Prettify"> selected="selected"</cfif>>Prettify</option>
				<option value="SyntaxHighlighter"<cfif getSetting('formatTarget') eq "SyntaxHighlighter"> selected="selected"</cfif>>Syntax Highlighter</option>
			</select>
		</p>
	</fieldset>
	<input type="submit" value="Save Changes" />
</form>