<cfcomponent>
    <cffunction name="addTocart" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name = "productId" required="true" type="string">
        <cfargument name = "quantity" required="true" type="integer">
        <cfset local.result = {
            success = false,
            "message" = ""
        }>
        <cftry>
            <cfquery name = "local.checkProductExist" datasource="#application.datasource#">
                SELECT
                    fldCart_Id AS cartId
                FROM
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                    AND
                    fldProductId = <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">
            </cfquery>
            <cfif local.checkProductExist.RecordCount>
                <cfset updateCart(cartId = application.objUser.encryptId(checkProductExist.cartId), step="increment")>
                <cfset local.result.message = "product updated">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity
                        )
                    VALUES(
                        <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                        <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.result.message = "quantity Added">
            </cfif>
            <cfset local.result.success = true>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: addTocart", 
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
                    INNER JOIN tblproduct P ON C.fldProductId = P.fldProduct_Id
                    INNER JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND fldDefaultImage = 1
                WHERE 
                    fldUserId = <cfqueryparam value = #application.objUser.decryptId(session.loginuserId)# cfsqltype="integer">
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
                subject = "error in function: fetchCart", 
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
                    fldQuantity = 
                        CASE 
                            WHEN <cfqueryparam value="#arguments.step#" cfsqltype="varchar"> = 'increment' THEN fldQuantity + 1
                            WHEN fldQuantity > 1 THEN fldQuantity - 1
                            ELSE fldQuantity
                        END
                WHERE fldCart_Id = <cfqueryparam value="#application.objUser.decryptId(arguments.cartId)#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: updateCart",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteCart" access="remote" returntype="numeric" returnformat="JSON">
        <cfargument name="cartId" required="false" type="string"> 
        <cftry>
            <cftransaction>
                <cfquery datasource="#application.datasource#">
                    DELETE FROM 
                        tblcart
                    WHERE
                        fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                        AND fldCart_Id = <cfqueryparam value = "#application.objUser.decryptId(arguments.cartId)#" cfsqltype="integer">
                </cfquery>

                <cfquery name="local.remainingCartCount" datasource="#application.datasource#">
                    SELECT 
                        count(*) AS remainingCount
                    FROM
                        tblcart
                    WHERE
                        fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                </cfquery>
            </cftransaction>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: deleteCart",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.remainingCartCount.remainingCount>
    </cffunction>

    <cffunction name="getNumberOfCartItems" access="public" returntype="numeric">
        <cfset local.cartItemCount = 0>
        <cftry>
            <cfquery name="local.getNumberOfCartItems" datasource="#application.datasource#">
                SELECT
                    count(*) AS itemCount
                FROM 
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
            <cfset local.cartItemCount = local.getNumberOfCartItems.itemCount>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: getNumberOfCartItems",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.cartItemCount>
    </cffunction>

    <cffunction name="addOrder" access="remote" returntype="void">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">
        <cfargument name="productId" type="string" required="true">
        <cfargument name="quantity" type="integer" required="true">
        <cfset local.orderId = createUUID()>
        <cfset local.cardDigits = right(arguments.cardnumber,4)>
        <cftry>
            <cftransaction>
                <cfquery name="getPriceDetails" datasource="#application.datasource#">
                    SELECT
                        fldunitPrice,
                        fldunitTax
                    FROM
                        tblproduct
                    WHERE
                        fldProduct_Id = <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#">
                </cfquery>
                <cfset local.unitPrice = getPriceDetails.fldunitPrice>
                <cfset local.unitTax = getPriceDetails.fldunitTax>
                <cfset local.totalPrice = getPriceDetails.fldunitPrice * arguments.quantity>
                <cfset local.totalTax = arguments.quantity * (getPriceDetails.fldunitPrice * getPriceDetails.fldunitTax)/100>
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
                        <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                        <cfqueryparam value="#application.objUser.decryptId(arguments.addressId)#" cfsqltype="integer">,
                        <cfqueryparam value="#local.cardDigits#" cfsqltype="varchar">,
                        <cfqueryparam value="#local.totalPrice#" cfsqltype="integer">,
                        <cfqueryparam value="#local.totalTax#" cfsqltype="integer">,
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
                        <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">,
                        <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">,
                        <cfqueryparam value="#local.unitPrice#" cfsqltype="integer">,
                        <cfqueryparam value="#local.unitTax#" cfsqltype="integer">
                    )
                </cfquery>
                <cfquery datasource="#application.datasource#">
                    DELETE 
                    FROM
                        tblcart
                    WHERE
                        fldProductId = <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#">
                </cfquery>
            </cftransaction>
            <cfset sendOrderConfirmationMail(local.orderId)>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: addOrder",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="placeOrder" access="remote" returntype="void">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">
        <cfset local.cardDigits = right(arguments.cardnumber,4)>
        <cfset local.orderId = createUUID()>
        <cftry>
            <cfquery datasource="#application.datasource#">
                CALL placeOrder(
                    #Application.objUser.decryptId(session.loginuserId)#,
                    #Application.objUser.decryptId(arguments.addressId)#,
                    #local.cardDigits#,
                    '#local.orderId#'
                );
            </cfquery>
            <cfset sendOrderConfirmationMail(local.orderId)>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: placeOrder",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="sendOrderConfirmationMail" access="public" returntype="void">
        <cfargument name="orderId" type="string" required="true">
        <cfset local.orderDetails = getOrderedItems(arguments.orderId)>
        <cfset local.sender = "adarshus1999@gmail.com">
        <cfset local.receiver = "#session.loginuserMail#">
        <cfset local.subject = "order confirmation mail">

        <cfmail from="#local.sender#" subject="#local.subject#" to="#local.receiver#" type="html">
            <html>
                <body>
                    <p><strong>Your Order Confirmation</strong></p>
                    <p>Order ID: <strong>#arguments.orderId#</strong></p>
                    <p><strong>Order Details:</strong></p>
                    <ul>
                        <cfloop array="#local.orderDetails.orders[1].products#" item="product">
                            <li>
                                <p>Product: <strong>#product.productName#</strong></p>
                                <p>Quantity: <strong>#product.quantity#</strong></p>
                            </li>
                        </cfloop>
                    </ul>
                    <p><strong>Total Price:</strong> Rs. #local.orderDetails.orders[1].totalPrice + local.orderDetails.orders[1].totalTax#</p>
                    <p>Thank you for shopping with us!</p>
                </body>
            </html>
        </cfmail>
    </cffunction>

    <cffunction name="getOrderedItems" access="public" returntype="struct">
        <cfargument name="orderId" type="string" required="false">
        <cfargument name="page" type="integer" required="false">
        <cfif structKeyExists(arguments,"page")>
             <cfset local.startIndex = (arguments.page - 1) * 5>
        </cfif>
        <cfset local.result = {
            "success": false,
            "orders": [],
            "message":""
         }>
         <cfset local.orderSet = []>
        <cftry>
            <cfquery name="local.getDistinctOrders" datasource="#application.datasource#">
                SELECT
                    fldOrder_Id
                FROM
                    tblorder
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="varchar">
                ORDER BY fldOrderDate DESC
                Limit 5
                <cfif structKeyExists(arguments,"page") AND arguments.page NEQ 0>
                    OFFSET <cfqueryparam value="#local.startIndex#" cfsqltype="integer">;
                </cfif>
            </cfquery>
            <cfloop query="local.getDistinctOrders">
                <cfset arrayAppend(local.orderSet,local.getDistinctOrders.fldOrder_Id)>
            </cfloop>
            <cfquery name="local.fetchOrderItems" datasource="#application.datasource#">
                SELECT
	                O.fldOrder_Id,
	                O.fldTotalPrice,
	                O.fldTotalTax,
	                O.fldOrderDate,
                    OI.fldQuantity,
                    OI.fldunitPrice,
                    OI.fldunitTax,
	                A.fldFirstName,
	                A.fldLastName,
	                A.fldAddressLine1,
	                A.fldAddressLine2,
	                A.fldCity,
	                A.fldState,
	                A.fldPincode,
	                A.fldPhone,
                    P.fldProductName,
                    P.fldProduct_Id,
                    PI.fldImageFilePath,
                    B.fldBrandName
                FROM
                	tblorder O
                    INNER JOIN tblorderitems OI ON OI.fldOrderId = O.fldOrder_Id
                    INNER JOIN tbladdress A ON A.fldAddress_Id = O.fldAddressId
                    INNER JOIN tblproduct P ON P.fldProduct_Id = OI.fldProductId
                    INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                    INNER JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                WHERE
                    O.fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="varchar">
                <cfif structKeyExists(arguments,"orderId")>
                    AND O.fldOrder_Id LIKE <cfqueryparam value="%#arguments.orderId#%" cfsqltype="varchar">
                </cfif>
                <cfif structKeyExists(arguments,"page")>
                    AND O.fldOrder_Id IN (<cfqueryparam value='#arrayToList(local.orderSet)#' list="true">)
                </cfif>
                    ORDER BY O.fldOrderDate DESC
            </cfquery>
            <cfset local.orderItem = {}>
            <cfset local.orderIds = []>
            <cfif local.fetchOrderItems.recordCount>
                <cfloop query="local.fetchOrderItems">
                    <cfset local.currentOrderId = local.fetchOrderItems.fldOrder_Id>
                    <cfif NOT structKeyExists(local.orderItem,local.currentOrderId)>
                        <cfset arrayAppend(local.orderIds,local.currentOrderId)>
                        <cfset local.orderItem[local.currentOrderId] = {
                            "orderId": local.fetchOrderItems.fldOrder_Id,
                            "orderDate": dateTimeFormat(local.fetchOrderItems.fldOrderDate.toString()),
                            "totalPrice": local.fetchOrderItems.fldTotalPrice,
                            "totalTax": local.fetchOrderItems.fldTotalTax,
                            "firstName": local.fetchOrderItems.fldFirstName,
                            "lastName": local.fetchOrderItems.fldLastName,
                            "address1": local.fetchOrderItems.fldAddressLine1,
                            "address2": local.fetchOrderItems.fldAddressLine2,
                            "city": local.fetchOrderItems.fldCity,
                            "state": local.fetchOrderItems.fldState,
                            "pincode": local.fetchOrderItems.fldPincode,
                            "products":[]
                        }>
                    </cfif>
                    <cfset arrayAppend(local.orderItem[local.currentOrderId].products, {
                        "imagefilepath": local.fetchOrderItems.fldImageFilePath,
                        "productName": local.fetchOrderItems.fldProductName,
                        "productId": local.fetchOrderItems.fldProduct_Id,
                        "brandName": local.fetchOrderItems.fldBrandName,
                        "quantity": local.fetchOrderItems.fldQuantity,
                        "unitPrice": local.fetchOrderItems.fldunitPrice,
                        "unittax": local.fetchOrderItems.fldunitTax
                    })>
                </cfloop>
                <cfloop  array="#local.orderIds#" item="key">
                    <cfset arrayAppend(local.result.orders, local.orderItem[key])>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: getOrderedItems",
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>
    
</cfcomponent>