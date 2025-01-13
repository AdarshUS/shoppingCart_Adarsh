<cfcomponent >   
   <cfset this.name = "shoppingCart">
   <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)> 
   <cfset this.datasource = "shopping_cart">
   <cfset this.sessionManagement = true>
   <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)>  
   <cfset application.objShoppingCart = createObject("component","Components.ShoppingCart")>  
   <cffunction name="onApplicationStart" returnType="boolean">
		
      <cfreturn true>
   </cffunction>

   <cffunction name="onRequestStart" returnType="void">
      <cfargument name="requestname" required="true">
       <cfif structKeyExists(url,"reload") AND url.reload EQ true>
         <cfset onApplicationStart()>         
      </cfif>
      <cfset local.pages = ["admin.cfm"]>
      <cfif NOT structKeyExists(session,"userId") AND NOT arrayFindNoCase(local.pages, ListLast(CGI.SCRIPT_NAME,'/'))>
		 <cflocation url="admin.cfm" addToken="no">
	   </cfif>
   </cffunction>
</cfcomponent>