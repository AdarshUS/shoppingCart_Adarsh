<cfcomponent >
    <cffunction name="validateAdminLogin" access="public" returntype="struct">
        <cfargument name="userName" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.result = {success = false}>    
        <cftry>
            <cfquery name="local.getAdminDetails">
                SELECT 
                    u.fldUser_Id, 
                    u.fldHashedPassword, 
                    u.fldUserSaltString, 
                    r.fldRoleName
                FROM 
                    tbluser u
                INNER JOIN 
                    tblrole r
                ON 
                    u.fldRoleId = r.fldRole_Id
                WHERE 
                    (u.fldemail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
                    OR u.fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">)
                    AND r.fldRoleName = <cfqueryparam value="Admin" cfsqltype="cf_sql_varchar">
            </cfquery>    
            <cfif local.getAdminDetails.RecordCount>
                <cfset local.saltString = local.getAdminDetails.fldUserSaltString>
                <cfset local.password = arguments.password>
                <cfset local.saltedPassword = local.password & local.saltString>
                <cfset local.hashedPassword = hash(local.saltedPassword, "SHA-384")>    
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

   <cffunction name="registerUser" access="public" returntype="struct">
        <cfargument name="firstName" required="true" type="string" >
        <cfargument name="lastName" required="true" type="string" >
        <cfargument name="email" required="true" type="string" >
        <cfargument name="phone" required="true" type="string" >
        <cfargument name="password" required="true" type="string" >
        <cfset local.result = {success = false}>
        <cfset local.saltString = generateSecretKey("AES")>
        <cfset local.saltedPassword = arguments.password&local.saltString>
        <cfset local.hashedPassword = hash( local.saltedPassword,"SHA-256","UTF-8")>
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
        <cfcatch>
           <cfset local.result.message = "Database error: " & cfcatch.message> 
        </cfcatch>
        </cftry>
        <cfreturn local.result>
   </cffunction>

</cfcomponent>