<cfcomponent >
    <cffunction name="adminLogin" access="public" returntype="struct">
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
      <cfargument name="inputId" required="true" type="string">
      <cfset local.encryptedId =  encrypt(arguments.inputId,application.encryptionKey,'AES','Base64')>
      <cfreturn local.encryptedId>
   </cffunction>

   <cffunction name="decryptId" access="public" returntype="string">
    <cfargument name="encryptedId" required="true" type="string">
    <cftry>
        <cfset var decryptedId = decrypt(arguments.encryptedId, application.encryptionKey, "AES", "Base64")>        
        <cfreturn decryptedId>
    <cfcatch>
        <cfdump var="#cfcatch#" label="Decryption Error">
        <cfthrow message="Decryption failed: #cfcatch.message#" detail="#cfcatch.detail#">
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
        <cftry>
            <cfquery name="checkUniqueEmailPhone" datasource="shopping_cart">
                SELECT
                    fldEmail,
                    fldPhone
                FROM
                    tbluser
                WHERE
                    fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="varchar">
                    OR fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="varchar">
            </cfquery>
            <cfif checkUniqueEmailPhone.RecordCount>
                <cfset local.result.success = false>
                <cfset local.result.message = "Email or Phone Already Exist">
            <cfelse>
                <cfquery datasource="shopping_cart">
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
        </cfcatch>
        </cftry>
        <cfreturn local.result>
   </cffunction>

   <cffunction name="userLogin" access="public" returntype="struct" >
		<cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">		
        <cfset local.result = {success = false,errors=[]}>
        <cfif len(trim(arguments.userName)) EQ 0>
           <cfset arrayAppend(local.result.errors, "userName is required")>
        </cfif>
        <cfif len(trim(arguments.password)) EQ 0>
           <cfset arrayAppend(local.result.errors, "password is required")>
        </cfif>
        <cftry>
          <cfquery name="local.getUserDetails">
              SELECT 
                  U.fldUser_Id, 
                  U.fldHashedPassword, 
                  U.fldUserSaltString
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
                  <cfset local.result.userId = local.getUserDetails.fldUser_Id>
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

   <cffunction name="logoutUser" access="remote" returntype="void">
      <cfset StructClear(Session)>
   </cffunction>
</cfcomponent>