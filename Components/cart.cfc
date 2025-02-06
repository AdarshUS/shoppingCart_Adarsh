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
                    count(*) AS existingProductCount
                FROM
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
                    AND
                    fldProductId = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
            </cfquery>
            <cfif local.checkProductExist.existingProductCount>
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
                    tblcart C INNER JOIN tblproduct P ON C.fldProductId = P.fldProduct_Id
                    LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId AND fldDefaultImage = 1
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
                    fldQuantity = 
                CASE 
                    WHEN <cfqueryparam value="#arguments.step#" cfsqltype="cf_sql_varchar"> = 'increment' THEN fldQuantity + 1
                    WHEN fldQuantity > 1 THEN fldQuantity - 1
                    ELSE fldQuantity
                END
                WHERE fldCart_Id = <cfqueryparam value="#decryptedCartId#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = cfcatch.message, 
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
        <cfset local.cartItemCount = 0>
        <cftry>
            <cfquery name="getNumberOfCartItems" datasource="#application.datasource#">
                SELECT
                    count(*) AS itemCount
                FROM 
                    tblcart
                WHERE
                    fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">
            </cfquery>
            <cfset local.cartItemCount = getNumberOfCartItems.itemCount>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.cartItemCount>
    </cffunction>

    <cffunction name="addOrder" access="remote" returntype="void">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">
        <cfargument name="totalPrice" type="integer" required="true">
        <cfargument name="totalTax" type="integer" required="true">
        <cfargument name="productId" type="string" required="true">
        <cfargument name="quantity" type="integer" required="true" >
        <cfargument name="unitPrice" type="integer" required="true">
        <cfargument name="unitTax" type="integer" required="true">
        
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
                    <cfqueryparam value="#createUUID()#" cfsqltype="varchar">,
                    <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                    <cfqueryparam value="#application.objUser.decryptId(arguments.addressId)#" cfsqltype="integer">,
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
                    <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">,
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

     <cffunction name="placeOrder" access="remote" returntype="void">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="cardnumber" type="string" required="true">
        
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
                    <cfqueryparam value="#createUUID()#" cfsqltype="varchar">,
                    <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="integer">,
                    <cfqueryparam value="#application.objUser.decryptId(arguments.addressId)#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.cardnumber#" cfsqltype="varchar">,
                    <cfqueryparam value="#local.totalActualPrice#" cfsqltype="integer">,
                    <cfqueryparam value="#local.totalTax#" cfsqltype="integer">,
                    now()
                )
            </cfquery>
            <cfloop array="#local.cartDetails.data#" item="cartItem"> 
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
                        <cfqueryparam value="#application.objUser.decryptId(cartItem.productId)#" cfsqltype="integer">,
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
        <cfargument name="orderId" type="string" required="false">
        <cfset local.result = {
            "success": false,
            "orderDetails": [],
            "message":""
         }>
        <cfdump var="#arguments.orderId#" abort>
        <cftry>
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
                INNER JOIN tblbrand B ON B.fldBrand_Id = P.fldBrandId
                LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                WHERE
                    O.fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="varchar">
                	AND A.fldActive = 1
                	AND P.fldActive = 1
                <cfif structKeyExists(arguments,"orderId") AND arguments.orderId NEQ 0>
                    AND  O.fldOrder_Id = <cfqueryparam value="#arguments.orderId#" cfsqltype="varchar">
                </cfif>
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
                        "productId": local.fetchOrderItems.productId,
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
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject=cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="getOrderHistoryPdf">
        <cfset local.orderHistory = getOrderedItems()>
        <cfdump var="#local.orderHistory#">
        <cfset local.fileName = "orderSummary.pdf">
        <cfset local.pdfFilePath = "../Assets/Files/" & local.fileName>
        <cfdocument 
            format="PDF" 
            filename="#local.pdfFilePath#" 
            overwrite="yes">
            <h1>Order Invoice</h1>
            <cfloop array = "#local.orderHistory.orderDetails#" item = "order">
                <cfset local.productId = listToArray(order.productId)>
                <cfset local.productNames = listToArray(order.productName)>
                <cfset local.quantity = listToArray(order.quantity)>
                <cfset local.unitPrices = listToArray(order.unitPrice)>
                <cfset local.unitTaxes = listToArray(order.unittax)>
                <cfset local.imagePath = listToArray(order.imagefilepath)>
                <cfset local.brandNames= listToArray(order.brandName)>
                <div class="order_container">
                    <div class="order-header">
                        <span>Order Number: <strong>#order.orderId#</strong></span>
                        <span>Order Date: <strong>#order.orderDate#</strong></span>
                        <span>Total Amount: <strong>#order.totalPrice#</strong></span>
                        <span class="order-status text-success">Processed</span>
                    </div>
                    <cfloop array="#local.productId#" item="product" index="i">
                        <cfset totalPrice = local.unitPrices[i] + (local.unitTaxes[i] / 100) * local.unitPrices[i]>
                        <div class="order-item">
                            <div class="order-item-info">
                                <h4>#local.productNames[i]#</h4>
                                <p>Brand: #local.brandNames[i]#</p>
                                <p>Quantity: #local.quantity[i]#</p>
                            </div>
                            <div class="priceCntr">
                                <span class="order-Actualprice"><span class="priceCntrText">Actual Price:</span>#local.unitPrices[i]#</span>
                                <span class="order-ActualTax"><span class="priceCntrText">Tax: </span>#local.unitTaxes[i]#%</span>
                                <span class="order-Total"><span class="priceCntrText">Total: </span>#totalPrice#</span>
                            </div>
                        </div>
                    </cfloop>
                    <div class="order-footer">
                    <div>
                        <div>Shipping Address :</div>
                        <span><strong>#order.address1#</strong></span>
                        <span><strong>#order.address2#</strong></span>
                        <span><strong>#order.city#</strong></span>
                        <span><strong>#order.state#</strong></span>
                        <span><strong>#order.pincode#</strong></span>
                    </div>
                </div>
            </cfloop>
        </cfdocument>
      <cfset local.currentTime= dateTimeFormat(now(),"dd-mm-yyyy-HH-nn-ss")>
      <cfset local.pdfFileName = "#session.loginuserfirstName# #session.loginuserlastName# #local.currentTime#">
   </cffunction>

</cfcomponent>