<cfcomponent>
    <cffunction name="addAddress" access="public" returntype="struct">
        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT
                INTO
                
            </cfquery>
        <cfcatch>
            <cfset application.objUser.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"addAddress"
            )>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>