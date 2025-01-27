<cfcomponent >
   <cfset this.name = "shoppingCart">
   <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)> 
   <cfset this.datasource = "shopping_cart">
   <cfset this.sessionManagement = true>
   <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)>

   <cffunction name="onApplicationStart" returnType="boolean">
		<cfset application.objProductManagement = createObject("component","Components.ProductManagement")>
      <cfset application.objUser = createObject("component","Components.User")>
      <cfset application.encryptionKey = generateSecretKey("AES")>
      <cfreturn true>
   </cffunction>   

   <cffunction name="onRequestStart" returnType="void">
      <cfargument name="requestname" required="true">
       <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
         <cfset onApplicationStart()>
      </cfif>
      <cfset local.pages = ["admin.cfm","userSignUp.cfm","userLogin.cfm","homePage.cfm","categoryList.cfm","subCategoryList.cfm"]>
      <!--- <cfif NOT structKeyExists(session,"loginuserId") AND NOT arrayFindNoCase(local.pages, ListLast(CGI.SCRIPT_NAME,'/'))>
		 <cflocation url="admin.cfm" addToken="no">
	   </cfif> --->
   </cffunction>
</cfcomponent>