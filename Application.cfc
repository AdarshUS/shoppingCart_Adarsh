<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)>
    

    <cffunction name="onApplicationStart" returnType="boolean">
        <cfset application.objProductManagement = createObject("component","Components.ProductManagement")>
        <cfset application.objUser = createObject("component","Components.User")>
        <cfset application.objCart = createObject("component","Components.cart")>
        <cfset application.objProfile = createObject("component","Components.profile")>
        <cfset application.objOrder = createObject("component","Components.order")>
        <cfset application.encryptionKey = "p085TCupwllF2ks0JiBD3Q==">
        <cfset application.datasource = "shopping_cart">
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="void">
        <cfargument name="requestname" required="true">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1 <!--- AND structKeyExists(session,"loginuserId") --->>
            <cfset onApplicationStart()>
        </cfif>
      <!---   <cfset local.pages = ["admin.cfm","userSignUp.cfm","userLogin.cfm","homePage.cfm","categoryList.cfm","subCategoryList.cfm","productDetails.cfm","cart.cfm"]>
        <cfif NOT structKeyExists(session,"loginuserId") AND NOT arrayFindNoCase(local.pages, ListLast(CGI.SCRIPT_NAME,'/'))>
	    	 <cflocation url="admin.cfm" addToken="no">
	    </cfif> --->
    </cffunction>
</cfcomponent> 