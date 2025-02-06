<cfcomponent>
    <cffunction name="addTocart" access="public" returntype="struct">
        <cfargument name = "productId" required="true" type="string">
        <cfargument name = "quantity" required="true" type="integer">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cftry>
            <cfquery name = "local.checkProductExist" datasource="#application.datasource#">
                SELECT
                    1
                FROM
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                    AND
                    fldProductId = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
            </cfquery>
            <cfif local.checkProductExist.RecordCount>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        tblcart
                    SET
                        fldQuantity = fldQuantity + 1
                    WHERE
                        fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                        AND
                        fldProductId = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
               </cfquery>
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity
                        )
                    VALUES(
                        <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                        <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                    )
               </cfquery>
           </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset application.objProductManagement.sendErrorEmail(
               subject = cfcatch.message, 
               body = "#cfcatch#"
           )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchCart" access="public" returntype="struct">
        <cfset local.result = {
            success = false,
            data=[],
            message = ""
        }>
        <cftry>
            <cfquery name="local.fetchCart" datasource="#application.datasource#">
                SELECT
                    PI.fldImageFilePath,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    P.fldProductName,
                    P.fldProduct_Id,
                    C.fldQuantity,
                    C.fldCart_Id
                FROM
                    tblcart C
                INNER JOIN 
                    tblproduct P
                ON
                    C.fldProductId = P.fldProduct_Id
                LEFT JOIN
                    tblproductimages PI 
                ON
                    P.fldProduct_Id = PI.fldProductId
                WHERE 
                    fldDefaultImage = 1
                    AND fldUserId = <cfqueryparam value = #application.objUser.decryptId(session.loginuserId)# cfsqltype="integer">
            </cfquery>
            <cfif local.fetchCart.recordCount>
                <cfloop query="local.fetchCart">
                    <cfset arrayAppend(local.result.data, {
                        "imageFilePath": local.fetchCart.fldImageFilePath,
                        "unitPrice": local.fetchCart.fldUnitPrice,
                        "unitTax": local.fetchCart.fldUnitTax,
                        "productName": local.fetchCart.fldProductName,
                        "productId":application.objUser.encryptId(local.fetchCart.fldProduct_Id),
                        "quantity": local.fetchCart.fldQuantity,
                        "cartId":application.objUser.encryptId(local.fetchCart.fldCart_Id)
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset application.objProductManagement.sendErrorEmail(
                subject = cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateCart" access="remote" returntype="void"> 
        <cfargument name="cartId" required = "true" type = "string">
        <cfargument name="step" required="true" type="string">
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblcart
                SET
                    fldQuantity = fldQuantity
                    <cfif structKeyExists(arguments,"step") AND arguments.step EQ "increment">
                        +1
                    <cfelse>
                        -1
                    </cfif>
                WHERE
                    fldCart_Id = <cfqueryparam value = #application.objUser.decryptId(arguments.cartId)# cfsqltype = "integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteCart" access="remote" returntype="void">
        <cfargument name="cartId" required="true" type="string">
        <cftry>
            <cfquery datasource="#application.datasource#">
                DELETE
                FROM
                    tblcart
                WHERE
                    fldCart_Id = <cfqueryparam value = #application.objUser.decryptId(arguments.cartId)# cfsqltype = "integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getNumberOfCartItems" access="public" returntype="numeric">
        <cftry>
            <cfquery name="getNumberOfCartItems" datasource="#application.datasource#">
                SELECT
                    1
                FROM 
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn getNumberOfCartItems.RecordCount>
    </cffunction>

</cfcomponent>