<cfcomponent>
    <cffunction name="addAddress" access="public" returntype="struct">
        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT
                INTO
                
            </cfquery>
        <cfcatch>
            <cfset application.objUser.sendErrorEmail(
                errorMessage=cfcatch.message, 
                functionName="addAddress"
            )>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>