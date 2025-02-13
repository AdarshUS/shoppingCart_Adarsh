<cfcomponent>
    <cffunction name="adminLogin" access="public" returntype="struct">
        <cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfquery name="local.getAdminDetails" datasource="#application.datasource#">
                SELECT 
                    U.fldUser_Id, 
                    U.fldHashedPassword, 
                    U.fldUserSaltString
                FROM 
                    tbluser U
                WHERE 
                    U.fldRoleId = 2
                    AND (U.fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                    OR U.fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">)
            </cfquery>
            <cfif local.getAdminDetails.RecordCount>
                <cfset local.saltString = local.getAdminDetails.fldUserSaltString>
                <cfset local.password = arguments.password>
                <cfset local.hashedPassword = hmac(local.password,local.saltString,"hmacSHA256")>
                <cfif local.hashedPassword EQ local.getAdminDetails.fldHashedPassword>
                    <cfset local.result.success = true>
                    <cfset session.loginAdminId = application.objUser.encryptId(local.getAdminDetails.fldUser_Id)>
                    <cfset local.result.message = "Login successful.">
                <cfelse>
                    <cfset local.result.message = "Invalid password.">
                </cfif>
            <cfelse>
                <cfset local.result.message = "User not Exist.">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function: adminLogin",body = cfcatch)>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>
    
    <cffunction name="logoutAdmin" access="remote" returntype="void">
        <cfset StructClear(Session)>
    </cffunction>

    <cffunction name="encryptId" access="public" returntype="string">
        <cfargument name="inputId" required="true" type="string">
        <cfset local.encryptedId =  encrypt(arguments.inputId,application.encryptionkey,'AES','Base64')>
        <cfreturn local.encryptedId>
    </cffunction>

    <cffunction name="decryptId" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="encryptedId" required="true" type="string">
        <cftry>
            <cfset var decryptedId = decrypt(arguments.encryptedId,application.encryptionkey, "AES", "Base64")>
            <cfreturn decryptedId>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function:decryptId",body = cfcatch)>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="registerUser" access="public" returntype="struct">
        <cfargument name="firstName" required="true" type="string">
        <cfargument name="lastName" required="true" type="string">
        <cfargument name="email" required="true" type="string">
        <cfargument name="phone" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.result = {
            success = false,
            errors = []
        }>
        <cftry>
            <cfif len(trim(arguments.firstName)) EQ 0>
            <cfset arrayAppend(local.result.errors, "firstName is required")>
            <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.firstName)>
		    	<cfset arrayAppend(local.result.errors, "*Enter a valid firstname")>
            </cfif>

            <cfif len(trim(arguments.lastName)) EQ 0>
                <cfset arrayAppend(local.result.errors, "*lastName is required")>
            <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.lastName)>
		    	<cfset arrayAppend(local.result.errors, "*Enter a valid lastname")>
            </cfif>
        
            <cfif len(trim(arguments.email)) EQ 0>
            	<cfset arrayAppend(local.result.errors, "*Email is required")>
            <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            	<cfset arrayAppend(local.result.errors, "*Enter a valid email")>
            </cfif>
       
            <cfif len(trim(arguments.phone)) EQ 0>
            	<cfset arrayAppend(local.result.errors, "*Please enter the phoneNumber")>
            <cfelseif NOT reFindNoCase("^\d{10}$", arguments.phone)>
            	<cfset arrayAppend(local.result.errors, "*Please enter a valid username")>
            </cfif>
       
            <cfif len(trim(arguments.password)) EQ 0>
            	<cfset arrayAppend(local.result.errors, "*Please enter the password")>
            <cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$", arguments.password)>
            	<cfset arrayAppend(local.result.errors, "*Please enter a valid password (minimum 6 characters, 1 lowercase, 1 uppercase)")>
            </cfif>
            <cfset local.saltString = generateSecretKey("AES")>
            <cfset local.hashedPassword =hmac(arguments.password,local.saltString,"hmacSHA256")>
            <cfquery name="local.checkUniqueEmailPhone" datasource="#application.datasource#">
                SELECT
                    1
                FROM
                    tbluser
                WHERE
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            </cfquery>
            <cfif local.checkUniqueEmailPhone.recordCount>
                <cfset local.result.success = false>
                <cfset local.result.message = "Email or Phone Already Exist">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tbluser(
                        fldFirstName,
                        fldLastName,
                        fldRoleId,
                        fldEmail,
                        fldPhone,
                        fldHashedPassword,
                        fldUserSaltString
                        )
                    VALUES(
                        <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                        1,
                        <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">,
                        <cfqueryparam value="#local.hashedPassword#" cfsqltype="varchar">,
                        <cfqueryparam value="#local.saltString#" cfsqltype="varchar">
                    )
                </cfquery>
                <cfset local.result.success = true>
                <cfset local.result.message = "Successfully Registered">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function: registerUser",body = cfcatch)>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="userLogin" access="public" returntype="struct" >
		<cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfif len(trim(arguments.userName)) NEQ 0 AND len(trim(arguments.password)) NEQ 0>
                <cfquery name="local.getUserDetails" datasource="#application.datasource#">
                    SELECT 
                        U.fldUser_Id, 
                        U.fldHashedPassword, 
                        U.fldUserSaltString,
                        U.fldFirstName,
                        U.fldLastName,
                        U.fldEmail
                    FROM 
                        tbluser U
                    WHERE 
                        U.fldRoleId = 1
                        AND (U.fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                        OR U.fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">)
                </cfquery>
                <cfif local.getUserDetails.RecordCount>
                    <cfset local.saltString = local.getUserDetails.fldUserSaltString>
                    <cfset local.password = arguments.password>
                    <cfset local.hashedPassword = hmac(local.password,local.saltString,"hmacSHA256")>
                    <cfif local.hashedPassword EQ local.getUserDetails.fldHashedPassword>
                        <cfset local.result.success = true>
                        <cfset session.loginuserId = application.objUser.encryptId(local.getUserDetails.fldUser_Id)>
                        <cfset session.loginuserfirstName = local.getUserDetails.fldFirstName>
                        <cfset session.loginuserlastName = local.getUserDetails.fldLastName>
                        <cfset session.loginuserMail = local.getUserDetails.fldEmail>
                        <cfset local.result.message = "Login successful.">
                    <cfelse>
                        <cfset local.result.message = "Invalid password.">
                    </cfif>
                <cfelse>
                <cfset local.result.message = "User not Exist.">
            </cfif>
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function: userLogin",body = cfcatch)>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="logoutUser" access="remote" returntype="void">
        <cfset StructClear(Session)>
    </cffunction>

    <cffunction name="fetchUserDetails" access="public" returntype="struct">
        <cfset local.result = {
            "success": false,
            "message": "",
            "userDetails":[]
        }>
        <cftry>
            <cfquery name="local.fetchUserDetails" datasource="#application.datasource#">
                SELECT
                    fldFirstName,
                    fldLastName,
                    fldEmail,
                    fldPhone
                FROM
                    tbluser
                WHERE
                    fldUser_Id = <cfqueryparam value="#decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
            <cfloop query="local.fetchUserDetails">
                <cfset arrayAppend(local.result.userDetails, {
                    "firstName": local.fetchUserDetails.fldFirstName,
                    "lastName": local.fetchUserDetails.fldLastName,
                    "email": local.fetchUserDetails.fldEmail,
                    "phone": local.fetchUserDetails.fldPhone
                })>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "Error in function: fetchUserDetails", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateProfile">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="email"  type="string" required="true">
        <cfargument name="phone" type="string" required="true">
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tbluser
                SET
                    fldFirstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="varchar">,
                    fldLastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="varchar">,
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
                WHERE
                    fldUser_Id = <cfqueryparam value="#decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "Error in function: updateProfile", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addAddress" access="public" returntype="struct">
        <cfargument name="addressData" required="true" type="struct">
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
                    <cfqueryparam value="#addressData.firstName#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.lastName#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.address1#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.address2#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.city#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.phone#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.state#" cfsqltype="varchar">,
                    <cfqueryparam value="#addressData.pincode#" cfsqltype="varchar">,
                    now()
                )
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successfully Added">
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "Error in function: addAddress", 
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
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "Error in function: fetchAddress", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="deleteAddress" access="remote" returntype="void">
        <cfargument name="addessId" type="string" required="true">
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tbladdress
                SET
                    fldActive = 0,
                    fldDeactivatedDate = now()
                WHERE
                    fldAddress_Id = <cfqueryparam value="#application.objUser.decryptId(arguments.addessId)#" cfsqltype="integer">
                    AND fldActive = 1
                    AND fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject ="Error in function: deleteAddress", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="ValidateCardDetails" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="number" required="true" type="string">
        <cfargument name="month" required="true" type="string">
        <cfargument name="year" required="true" type="string">
        <cfargument name="cvv" required="true" type="string">
        
        <cfset local.result = {
            'success':'false',
            'message':''
        }>
        <cfset local.cardNumber = 9526001384666666>
        <cfset local.month = 12>
        <cfset local.year = 2027>
        <cfset local.cvv = 123>

        <cfif len(trim(arguments.number)) NEQ 0 AND len(trim(arguments.month)) NEQ 0 AND len(trim(arguments.year)) NEQ 0 AND len(trim(arguments.cvv))>
            <cfif arguments.number NEQ local.cardNumber>
                <cfset local.result.message = "Invalid Card Number">
            <cfelseif arguments.month NEQ local.month>
                <cfset local.result.message = "Invalid Month">
            <cfelseif arguments.year NEQ local.year>
                <cfset local.result.message = "Invalid Year">
            <cfelseif arguments.cvv NEQ local.cvv>
                <cfset local.result.message = "Invalid CVV">
            <cfelse>
                <cfset local.result.success = true>
                <cfset local.result.message = "successfully verified">
            </cfif>
        </cfif>
            <cfreturn local.result>
    </cffunction>
</cfcomponent>