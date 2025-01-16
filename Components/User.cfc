<cfcomponent >
    <cffunction name="validateAdminLogin" access="public" returntype="struct">
        <cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery name="local.getAdminDetails">
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
                    <cfset local.result.userId = local.getAdminDetails.fldUser_Id>
                    <cfset local.result.message = "Login successful.">
                <cfelse>
                    <cfset local.result.message = "Invalid password.">
                </cfif>
            <cfelse>
                <cfset local.result.message = "User not Exist.">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>
    
   <cffunction name="logoutAdmin" access="remote" returntype="void">
      <cfset StructClear(Session)>
   </cffunction>

   <cffunction name="encryptId" access="public" returntype="string">
      <cfargument name="inputId" required="true" type="integer" >
      <cfset local.encryptedId =  encrypt(arguments.inputId,application.encryptionKey,'AES','Base64')>
      <cfreturn local.encryptedId>
   </cffunction>

   <cffunction name="decryptId" access="public" returntype="integer" >
      <cfargument name="encryptedId" required="true" type="string">
      <cfset local.decryptedId =  decrypt(arguments.encryptedId,application.encryptionKey,'AES','Base64')>
      <cfreturn local.decryptedId>
   </cffunction>

   <cffunction name="registerUser" access="public" returntype="struct">
        <cfargument name="firstName" required="true" type="string" >
        <cfargument name="lastName" required="true" type="string" >
        <cfargument name="email" required="true" type="string" >
        <cfargument name="phone" required="true" type="string" >
        <cfargument name="password" required="true" type="string" >
        <cfset local.result = {success = false}>
        <cfset local.saltString = generateSecretKey("AES")>
        <cfset local.hashedPassword =hmac(arguments.password,local.saltString,"hmacSHA256")>
        <cftry>
            <cfquery name="local.registerUser">
                INSERT
                INTO
                    tbluser(
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
                    <cfqueryparam value="2" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.email#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.hashedPassword#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.saltString#" cfsqltype="varchar">
                )
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "Successfully Registered">
        <cfcatch>
           <cfset local.result.message = "Database error: " & cfcatch.message> 
        </cfcatch>
        </cftry>
        <cfreturn local.result>
   </cffunction>

   <cffunction name="validateUser" access="public" returntype="struct" >
        
   </cffunction>

   
</cfcomponent>