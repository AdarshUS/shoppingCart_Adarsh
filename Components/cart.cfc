<cfcomponent>
    <cffunction name="addcart" access="public" returntype="struct">
        <cfargument name = "userId" required="true" type="integer">
        <cfargument name = "productId" required="true" type="integer">
        <cfargument name = "quantity" required="true" type="integer">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery name = "local.checkProductExist" datasource="#application.datasource#">
                SELECT
                    fldCart_Id,
                    fldUserId,
                    fldProductId,
                    fldQuantity
                FROM
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                    AND
                    fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            </cfquery>
            <cfif local.checkProductExist.RecordCount>
                <cfquery datasource="#application.datasource#">
                    UPDATE tblcart
                    SET fldQuantity = fldQuantity + <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                    WHERE fldCart_Id = <cfqueryparam value="#local.checkProductExist.fldCart_Id#" cfsqltype="integer">
               </cfquery>
            <cfelse>
                <cfquery>
                    INSERT
                    INTO
                        tblcart(
                            fldUserId,
                            fldProductId,
                            fldQuantity
                        )
                    VALUES(
                        <cfqueryparam value="#arguments.userId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                    )
               </cfquery>
           </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
               subject=cfcatch.message, 
               body="#cfcatch#"
           )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchCart" access="public" returntype="struct">
        <cfargument name="userId" required="true" type="integer">
        <cfset local.result = {
            success = false,
            data=[]
        }>
        <cftry>
            <cfquery name="local.fetchCart">
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
                    AND fldUserId = <cfqueryparam value = #arguments.userId#>
            </cfquery>
            <cfif local.fetchCart.recordCount>
                <cfloop query="local.fetchCart">
                    <cfset arrayAppend(local.result.data, {
                        "imageFilePath": local.fetchCart.fldImageFilePath,
                        "unitPrice": local.fetchCart.fldUnitPrice,
                        "unitTax": local.fetchCart.fldUnitTax,
                        "productName": local.fetchCart.fldProductName,
                        "productId":local.fetchCart.fldProduct_Id,
                        "quantity": local.fetchCart.fldQuantity,
                        "cartId":local.fetchCart.fldCart_Id
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfdump var="#cfcatch#">
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateCart" access="remote" returntype="void"> 
        <cfargument name="cartId" required = "true" type = "integer">
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
                    fldCart_Id = <cfqueryparam value = #arguments.cartId# cfsqltype = "integer">
            </cfquery>
        <cfcatch>
            <cfdump var="#cfcatch#">
            <cfset sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteCart" access="remote" returntype="void">
        <cfargument name="cartId" required="true" type="integer">
        <cftry>
            <cfquery datasource="#application.datasource#">
                DELETE
                FROM
                    tblcart
                WHERE
                    fldCart_Id = <cfqueryparam value = #arguments.cartId# cfsqltype = "integer">
            </cfquery>
        <cfcatch>
            <cfdump var="#cfcatch#">
            <cfset sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getNumberOfCartItems" access="public" returntype="numeric">
        <cftry>
            <cfquery name="getNumberOfCartItems">
                SELECT
                    fldCart_Id 
                FROM 
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#">
            </cfquery>
        <cfcatch>
            <cfdump var="#cfcatch#">
            <cfset sendErrorEmail(
                subject=cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn getNumberOfCartItems.RecordCount>
    </cffunction>

</cfcomponent>