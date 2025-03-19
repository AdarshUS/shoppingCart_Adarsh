<cfcomponent>
    <cffunction name="userLogin" access="public" returntype="struct">
        <cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfargument name="role" required="true" type="integer">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cfif len(trim(arguments.userName)) AND len(trim(arguments.password))>
            <cftry>
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
                        U.fldRoleId = <cfqueryparam value="#arguments.role#" cfsqltype="integer">
                        AND (U.fldEmail = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">
                        OR U.fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="varchar">)
                </cfquery>
                <cfif local.getUserDetails.RecordCount>
                    <cfset local.saltString = local.getUserDetails.fldUserSaltString>
                    <cfset local.password = arguments.password>
                    <cfset local.hashedPassword = hmac(local.password,local.saltString,"hmacSHA256")>
                    <cfif local.hashedPassword EQ local.getUserDetails.fldHashedPassword>
                        <cfset local.result.success = true>
                        <cfset local.result.message = "Login successful.">
                        <cfif arguments.role EQ 2>
                            <cfset session.loginAdminId = application.objUser.encryptId(local.getUserDetails.fldUser_Id)>
                        <cfelse>
                            <cfset session.loginuserId = application.objUser.encryptId(local.getUserDetails.fldUser_Id)>
                            <cfset session.loginuserfirstName = local.getUserDetails.fldFirstName>
                            <cfset session.loginuserlastName = local.getUserDetails.fldLastName>
                            <cfset session.loginuserMail = local.getUserDetails.fldEmail>
                            <cfset session.cartItemCount = application.objCart.getNumberOfCartItems()>
                        </cfif>
                    <cfelse>
                        <cfset local.result.message = "Invalid password.">
                    </cfif>
                <cfelse>
                    <cfset local.result.message = "User not Exist.">
                </cfif>
            <cfcatch>
                <cfset local.result.message = "error occured">
                <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function: adminLogin",body = cfcatch)>
            </cfcatch>
            </cftry>
        <cfelse>
            <cfset local.result.message = "empty UserName or Password">
        </cfif>
        <cfreturn local.result>
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
            message = ""
        }>
        <cftry>
            <cfif len(trim(arguments.firstName))
                AND len(trim(arguments.lastName))
                AND len(trim(arguments.email))
                AND len(trim(arguments.phone))
                AND len(trim(arguments.password))
            >
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
            <cfelse>
                <cfset local.result.message = "empty User Input field">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset application.objProductManagement.sendErrorEmail(subject = "Error in function: registerUser",body = cfcatch)>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="logout" access="remote" returntype="void">
        <cfargument name="roleId" required="true" type="integer">
        <cfif arguments.roleId EQ 1>
            <cfset structDelete(session,"loginuserId")>
            <cfset structDelete(session,"loginuserfirstName")>
            <cfset structDelete(session,"loginuserlastName")>
            <cfset structDelete(session,"loginuserMail")>
            <cfset structDelete(session,"cartItemCount")>
        <cfelse>
            <cfset structDelete(session,"loginAdminId")>
        </cfif>
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
            <cfif len(trim(arguments.firstName))
                AND len(trim(arguments.lastName)) 
                AND len(trim(arguments.email)) 
                AND len(trim(arguments.phone))>
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
            </cfif>
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
            <cfif
                len(trim(arguments.addressData.firstName))
                AND
                len(trim(arguments.addressData.lastName))
                AND
                len(trim(arguments.addressData.address1))
                AND
                len(trim(arguments.addressData.city))
                AND
                len(trim(arguments.addressData.state))
                AND
                len(trim(arguments.addressData.phone))
                AND
                len(trim(arguments.addressData.pincode))
            >
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
            <cfelse>
                <cfset local.result.message = "empty User Input">
            </cfif>
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
        <cfset local.cardNumber = 1111111111111111>
        <cfset local.month = 12>
        <cfset local.year = 2027>
        <cfset local.cvv = 123>

        <cfif 
            len(trim(arguments.number))
            AND len(trim(arguments.month))
            AND len(trim(arguments.year))
            AND len(trim(arguments.cvv))
        >
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
        <cfelse>
            <cfset local.result.message = "Enter all Fields">
        </cfif>
            <cfreturn local.result>
    </cffunction>
</cfcomponent>