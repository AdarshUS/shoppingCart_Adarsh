<cfcomponent>
    <cffunction name="addAddress" access="public" returntype="struct">
        <cfargument name="firstName" required="true" type="string">
        <cfargument name="lastName" required="true" type="string">
        <cfargument name="phone" required="true" type="string">
        <cfargument name="address1" required="true" type="string">
        <cfargument name="address2" required="true" type="string">
        <cfargument name="city" required="true" type="string">
        <cfargument name="state" required="true" type="string">
        <cfargument name="pincode" required="true" type="string">
        <cfset local.result = {
            'success':'false',
            'message':''
        }>
        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT INTO tbladdress (
                    fldUserId,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldPhone,
                    fldState,
                    fldPincode,
                    fldCreatedDate
                )
                VALUES(
                    <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.address1#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.address2#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.city#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.state#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.pincode#" cfsqltype="varchar">,
                    now()
                )
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successfully Added">
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchAddress" access="public" returntype="struct">
        <cfargument name="addressId" required="false" type="string">
        <cfset local.result = {
            'success':'false',
            'message':'',
            'address':[]
        }>
        
        <cftry>
            <cfquery name="local.fetchAllAddress" datasource="#application.datasource#">
                SELECT
                    fldAddress_Id,
                    fldFirstName,
                    fldLastName,
                    fldAddressLine1,
                    fldAddressLine2,
                    fldCity,
                    fldState,
                    fldPincode,
                    fldPhone
                FROM
                    tbladdress
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                    AND fldActive = 1
                    <cfif structKeyExists(arguments,"addressId")>
                        AND fldAddress_Id = <cfqueryparam value="#application.objUser.decryptId(arguments.addressId)#" cfsqltype="integer">
                    </cfif>
            </cfquery>
            <cfloop query="local.fetchAllAddress">
                <cfset arrayAppend(local.result.address, {
                        "firstName": local.fetchAllAddress.fldFirstName,
                        "lastName": local.fetchAllAddress.fldLastName,
                        "addressline1": local.fetchAllAddress.fldAddressLine1,
                        "addressline2": local.fetchAllAddress.fldAddressLine2,
                        "city": local.fetchAllAddress.fldCity,
                        "state": local.fetchAllAddress.fldState,
                        "pincode": local.fetchAllAddress.fldPincode,
                        "phone": local.fetchAllAddress.fldPhone,
                        "addressId": application.objUser.encryptId(local.fetchAllAddress.fldAddress_Id)
                })>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfdump var="#cfcatch#" >
            <cfset applicationobjProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="deleteAddress" access="remote" returntype="void">
        <cfargument name="addessId" type="string" required="true">
        <cfset local.decryptedAddressId = application.objUser.decryptId(arguments.addessId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tbladdress
                SET
                    fldActive = 0,
                    fldDeactivatedDate = now()
                WHERE
                    fldAddress_Id = <cfqueryparam value="#local.decryptedAddressId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="updateProfile" access="public" returntype="void">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="email" type="string" required="true">
        <cfargument name="phone" type="string" required="true" >
        <cftry>
            <cfquery>
                UPDATE
                    tbluser
                SET
                    fldFirstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    fldLastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="ValidateCardDetails" access="public" returntype="struct">
        <cfset local.result = {}>
        <cfset local.cardNumber = 9526001384666666>
        <cfset local.month = "september">
        <cfset local.year = "2027">
        <cfset local.cvv = 89>

        <cfset local.result["cardNumber"] = local.cardNumber>
        <cfset local.result["cardMonth"] = local.month>
        <cfset local.result["cardYear"] = local.year>
        <cfset local.result["cvv"] = local.cvv>

        <cfreturn local.result>
    </cffunction>
</cfcomponent>