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

   <cffunction name="insertCategories"  access="remote" returntype="void">
      <cfargument name="categoryName" type="string">
      <cfquery name = local.insertCategory>
        INSERT
        INTO
            tblcategory(
                fldCategoryName
                ,fldCreatedBy
            )
        VALUES(
            <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
            ,<cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
        )
     </cfquery>     
    </cffunction>

    <cffunction name="fetchAllCategories"  access="public" returntype="query">
        <cfquery  name="local.fetchCategories">
            SELECT 
                fldCategory_Id
                ,fldCategoryName
                ,fldCreatedBy
            FROM
                tblcategory
            WHERE   
                fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.fetchCategories>
    </cffunction>

    <cffunction name="editCategory" access="remote">
        <cfargument name="categoryId" required="true" type="integer" >
        <cfargument name="newCategory" required="true" type="string" >
        <cfquery name = local.editCategory>
            UPDATE
                tblcategory
            SET
                fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="cf_sql_varchar">
                ,  fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
            WHERE
                fldCategory_Id 
                =  <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>            
    </cffunction>

    <cffunction name="fetchSingleCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.structCategory={}>
        <cfquery name="local.fetchCategory">
            SELECT
                fldCategory_Id
                ,fldCategoryName
                ,fldCreatedBy
            FROM
                tblcategory
            WHERE
                fldCategory_Id
                = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>
         <cfloop list="#local.fetchCategory.columnList#" index="colname">
            <cfset local.structCategory[colname] = local.fetchCategory[colname][1]>
        </cfloop>
        <cfreturn local.structCategory>
    </cffunction>

    <cffunction name="deleteCategory" access="remote">
        <cfargument name="categoryId" required="true" type="integer">
        <cfquery name = local.deleteCategory>
            UPDATE
                tblcategory
            SET
                fldActive 
                = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
            WHERE
                fldCategory_Id 
                =  <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>    
    </cffunction>

    <cffunction name="insertSubCategory" access="public">        
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subcategoryName"  type="string" required="true">        
        <cfquery name = local.insertSubCategory>
            INSERT
            INTO
                tblsubcategory(
                    fldCategoryId
                    ,fldSubCategoryName
                    ,fldCreatedBy
                )
            VALUES(
                <cfqueryparam value="#arguments.categoryId#">
                ,<cfqueryparam value="#arguments.subcategoryName#">
                ,<cfqueryparam value="#session.userId#">
            )                    
        </cfquery>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returntype="query" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.structSubCategory={}>
        <cfquery  name="local.fetchSubCategories">
            SELECT 
                fldSubCategory_Id
                ,fldSubCategoryName
                ,fldCreatedBy
            FROM
                tblsubcategory
            WHERE   
                fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
                AND
                fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>       
        <cfreturn local.fetchSubCategories>
    </cffunction>

    <cffunction name="updateSubCategory" access="public" returntype="void">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfargument name="newCategoryName" type="string" required="true" >
        <cfargument name="categoryId" type="integer" required="true">
        <cfquery name="local.updateSubCategory">
            UPDATE
                 tblsubcategory
            SET
                fldSubCategoryName = 
                <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="cf_sql_varchar">,
                fldCategoryId = 
                <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_Id = 
                <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">                
        </cfquery>
    </cffunction>

    <cffunction name="softDeleteSubCategory" access="remote" returntype="void" >
        <cfargument name="subCategoryId" type="integer" required="true" >
        <cfquery name = local.Deactivate>
             UPDATE
                tblsubcategory
            SET
                fldActive 
                = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_Id 
                =  <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">                       
        </cfquery>            
    </cffunction>
    
</cfcomponent>