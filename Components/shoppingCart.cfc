<cfcomponent >
   <cffunction name="validateAdminLogin" access="public" returntype="struct">
      <cfargument name="userName" required="true" type="string">
      <cfargument name="password" required="true"  type="string">
      <cfset local.result ={}>
      <cfquery name="local.getAdminDetails">
         SELECT
             u.*, r.*
         FROM
             tbluser u
         INNER JOIN
             tblrole r
         ON
             u.fldRoleId = r.fldRole_Id
         WHERE (u.fldemail = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">
         OR u.fldPhone = <cfqueryparam value="#arguments.userName#" cfsqltype="cf_sql_varchar">)
         AND r.fldRoleName = <cfqueryparam value="Admin" cfsqltype="cf_sql_varchar">
      </cfquery>      
      <cfif local.getAdminDetails.RecordCount>        
         <cfset local.saltString = local.getAdminDetails.fldUserSaltString>
         <cfset local.password = arguments.password>
         <cfset local.saltedPassword = local.password & local.saltString>         
         <cfset hashedPassword = hash(local.saltedPassword, "SHA-384")>
         <cfif hashedPassword EQ local.getAdminDetails.fldHashedPassword>            
           <cfset local.result.success = true>
           <cfset local.result.userName = local.getAdminDetails.fldemail>
         <cfelse>
             <cfset local.result.success = false>
         </cfif>
      </cfif>
      <cfreturn local.result>
   </cffunction>

   <cffunction name="logoutAdmin" access="remote" returntype="void">
      <cfset StructClear(Session)>         
   </cffunction>
</cfcomponent>