<cfcomponent>
    <cffunction name="addOrder" access="remote" returntype="void">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">
        <cfargument name="totalPrice" type="integer" required="true">
        <cfargument name="totalTax" type="integer" required="true">
        <cfargument name="productId" type="string" required="true">
        <cfargument name="quantity" type="integer" required="true" >
        <cfargument name="unitPrice" type="integer" required="true">
        <cfargument name="unitTax" type="integer" required="true">
       
        <cfset local.decryptedAddressId = application.objUser.decryptId(arguments.addressId)>
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cfset local.decryptedUserId = application.objUser.decryptId(session.loginuserId)>
        <cfset local.orderId = createUUID()>

        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT INTO  tblorder (
                    fldOrder_Id,
                    fldUserId,
                    fldAddressId,
                    fldCardNumber,
                    fldTotalPrice,
                    fldTotalTax,
                    fldOrderDate
                )
                VALUES(
                    <cfqueryparam value="#local.orderId#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.decryptedUserId#" cfsqltype="integer">,
                    <cfqueryparam value="#local.decryptedAddressId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.cardnumber#" cfsqltype="varchar">,
                    <cfqueryparam value="#arguments.totalPrice#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.totalTax#" cfsqltype="integer">,
                    now()
                )
            </cfquery>
            <cfquery datasource="#application.datasource#">
                INSERT INTO tblorderitems (
                    fldOrderId,
                    fldProductId,
                    fldQuantity,
                    fldUnitPrice,
                    fldUnitTax
                )
                VALUES (
                    <cfqueryparam value="#local.orderId#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.unitPrice#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.unitTax#" cfsqltype="integer">
                )
            </cfquery>
        <cfcatch>
            <cfset applicationobjProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addOrderCart" access="remote" returntype="void" >
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">

        <cfset local.decryptedAddressId = application.objUser.decryptId(arguments.addressId)>
        <cfset local.decryptedUserId = application.objUser.decryptId(session.loginuserId)>
        <cfset local.orderId = createUUID()>
        <cfset local.cartDetails = application.objCart.fetchCart()>
        <cfset local.totalActualPrice = 0>
        <cfset local.totalTax = 0>
        <cfloop array="#local.cartDetails.data#" item="cartItem">
            <cfset local.totalActualPrice+=cartItem.unitPrice>
            <cfset local.totalTax+=cartItem.unitTax>
        </cfloop>
        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT INTO  tblorder (
                    fldOrder_Id,
                    fldUserId,
                    fldAddressId,
                    fldCardNumber,
                    fldTotalPrice,
                    fldTotalTax,
                    fldOrderDate
                )
                VALUES(
                    <cfqueryparam value="#local.orderId#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.decryptedUserId#" cfsqltype="integer">,
                    <cfqueryparam value="#local.decryptedAddressId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.cardnumber#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.totalActualPrice#" cfsqltype="integer">,
                    <cfqueryparam value="#local.totalTax#" cfsqltype="integer">,
                    now()
                )
            </cfquery>
            <cfloop array="#local.cartDetails.data#" item="cartItem">
                <cfset local.decryptedProductId = application.objUser.decryptId(cartItem.productId)>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblorderitems (
                        fldOrderId,
                        fldProductId,
                        fldQuantity,
                        fldUnitPrice,
                        fldUnitTax
                    )
                    VALUES (
                        <cfqueryparam value="#local.orderId#" cfsqltype="varchar">,
                        <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">,
                        <cfqueryparam value="#cartItem.quantity#" cfsqltype="integer">,
                        <cfqueryparam value="#cartItem.unitPrice#" cfsqltype="integer">,
                        <cfqueryparam value="#cartItem.unitTax#" cfsqltype="integer">
                    )
                </cfquery>
            </cfloop>
            <cfquery datasource="#application.datasource#">
                DELETE
                FROM
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#local.decryptedUserId#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset applicationobjProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>