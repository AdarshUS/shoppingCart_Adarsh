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
            <cfset sendOrderConfirmationMail(local.orderId)>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addOrderCart" access="remote" returntype="void">
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
            <cfset sendOrderConfirmationMail(local.orderId)>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="sendOrderConfirmationMail" access="public" returntype="void">
        <cfargument name="orderId" type="string" required="true">
        <cfset local.sender = "adarshus1999@gmail.com">
        <cfset local.receiver = "#session.loginuserMail#">
        <cfset local.subject = "order confirmation mail">

        <cfmail from="#local.sender#" subject="#local.subject#" to="#local.receiver#">
            Your order with orderId : #arguments.orderId# is confirmed.
        </cfmail>
    </cffunction>

    <cffunction name="getOrderedItems" access="public" returntype="struct">
        <cfset local.result = {
            "success": false,
            "orderDetails": [],
            "message":""
         }>
         <cfdump var="#session.loginuserId#" >
       <!---  <cftry> --->
            <cfquery name="local.fetchOrderItems" datasource="#application.datasource#">
                SELECT  
	                O.fldOrder_Id,  
	                O.fldTotalPrice, 
	                O.fldTotalTax, 
	                O.fldOrderDate, 
	                A.fldFirstName, 
	                A.fldLastName, 
	                A.fldAddressLine1, 
	                A.fldAddressLine2, 
	                A.fldCity, 
	                A.fldState, 
	                A.fldPincode, 
	                A.fldPhone,
	                GROUP_CONCAT(OI.fldProductId) AS productId, 
	                GROUP_CONCAT(OI.fldQuantity) AS productQuantity,
	                GROUP_CONCAT(OI.fldUnitPrice) AS unitPrice, 
	                GROUP_CONCAT(OI.fldUnitTax) AS unitTax,  
	                GROUP_CONCAT(P.fldProductName) AS productName, 
	                GROUP_CONCAT(PI.fldImageFilePath) AS productImage,
	                GROUP_CONCAT(B.fldBrandName) AS brandName
                FROM
                	tblorder O
                INNER JOIN tblorderitems OI ON OI.fldOrderId = O.fldOrder_Id
                INNER JOIN tbladdress A ON A.fldAddress_Id = O.fldAddressId
                INNER JOIN tblproduct P ON P.fldProduct_Id = OI.fldProductId
                LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                WHERE
                    O.fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="varchar">
                	AND A.fldActive = 1
                	AND P.fldActive = 1
                GROUP BY
                	O.fldOrder_Id,
                	O.fldTotalPrice,
                	O.fldTotalTax,
                	O.fldOrderDate,
                    A.fldFirstName,
                	A.fldLastName,
                	A.fldAddressLine1,
                	A.fldAddressLine2,
                	A.fldCity,
                	A.fldState,
                	A.fldPincode,
                	A.fldPhone
                </cfquery>
            <cfif local.fetchOrderItems.recordCount gt 0>
                <cfloop query="local.fetchOrderItems">
                    <cfset arrayAppend(local.result.orderDetails, {
                        "orderId": local.fetchOrderItems.fldOrder_Id,
                        "orderDate": local.fetchOrderItems.fldOrderDate,
                        "imagefilepath": local.fetchOrderItems.productImage,
                        "productName": local.fetchOrderItems.productName,
                        "productId": application.objUser.encryptId(local.fetchOrderItems.productId),
                        "brandName": local.fetchOrderItems.brandName,
                        "quantity": local.fetchOrderItems.productQuantity,
                        "unitPrice": local.fetchOrderItems.unitPrice,
                        "unittax": local.fetchOrderItems.unitTax,
                        "totalPrice": local.fetchOrderItems.fldTotalPrice,
                        "totalTax": local.fetchOrderItems.fldTotalTax,
                        "firstName": local.fetchOrderItems.fldFirstName,
                        "lastName": local.fetchOrderItems.fldLastName,
                        "address1": local.fetchOrderItems.fldAddressLine1,
                        "address2": local.fetchOrderItems.fldAddressLine2,
                        "city": local.fetchOrderItems.fldCity,
                        "state": local.fetchOrderItems.fldState,
                        "pincode": local.fetchOrderItems.fldPincode
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <!--- <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry> --->
        <cfreturn local.result>
    </cffunction>
</cfcomponent>