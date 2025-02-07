<cfcomponent>
    <cfset this.name = "shoppingCart">
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)>
    <cfset this.sessionManagement = true>
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)>

    <cffunction name="onApplicationStart" returnType="boolean">
        <cfset application.objProductManagement = createObject("component","Components.ProductManagement")>
        <cfset application.objUser = createObject("component","Components.User")>
        <cfset application.objCart = createObject("component","Components.cart")>
        <cfset application.encryptionKey = "p085TCupwllF2ks0JiBD3Q==">
        <cfset application.datasource = "shopping_cart">
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="void">
        <cfargument name="requestname" required="true">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1 <!--- AND structKeyExists(session,"loginuserId") --->>
            <cfset onApplicationStart()>
        </cfif>
        <cfset local.Adminpages = ["category.cfm","subcategory.cfm","product.cfm"]>
        <cfif NOT structKeyExists(session,"loginadminid") AND  arrayFindNoCase(local.Adminpages, ListLast(CGI.SCRIPT_NAME,'/'))>
	    	 <cflocation url="admin.cfm" addToken="no">
	    </cfif>
         <cfset local.Userpages = ["orderSummary.cfm","orderSearchResult.cfm","orderhistory.cfm","orderConfirmation.cfm"]>
        <cfif NOT structKeyExists(session,"loginuserid") AND arrayFindNoCase(local.Userpages, ListLast(CGI.SCRIPT_NAME,'/'))>
	    	 <cflocation url="homePage.cfm" addToken="no">
	    </cfif>
    </cffunction>
</cfcomponent> 