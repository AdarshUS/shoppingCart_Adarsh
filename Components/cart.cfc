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

    <cffunction name="deleteCart" access="remote" returntype="void">
        <cfargument name="cartId" required="false" type="string">
        <cftry>
            <cfquery datasource="#application.datasource#">
                DELETE FROM tblcart
            WHERE 
                <cfif structKeyExists(arguments, "cartId") AND len(arguments.cartId)>
                    fldCart_Id = <cfqueryparam value = "#application.objUser.decryptId(arguments.cartId)#" cfsqltype="integer">
                <cfelseif structKeyExists(arguments, "productId") AND len(arguments.productId)>
                    tblproductId = <cfqueryparam value = "#arguments.productId#" cfsqltype="integer">
                </cfif>
            </cfquery>
        <cfcatch>
            <cfset application.objProductManagement.sendErrorEmail(
                subject = "error in function: deleteCart", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
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
        <cfargument name="totalPrice" type="integer" required="true">
        <cfargument name="totalTax" type="integer" required="true">
        <cfargument name="productId" type="string" required="true">
        <cfargument name="quantity" type="integer" required="true" >
        <cfargument name="unitPrice" type="integer" required="true">
        <cfargument name="unitTax" type="integer" required="true">
        <cfset local.orderId = createUUID()>
        <cfset local.cardDigits = right(arguments.cardnumber,4)>
        <cfset local.totalTax = Round((arguments.unitTax/100)*arguments.unitPrice*arguments.quantity)>
        <cfset local.totalPrice = Round(arguments.unitPrice * arguments.quantity)>
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
                    <cfqueryparam value="#arguments.unitPrice#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.unitTax#" cfsqltype="integer">
                )
            </cfquery>
            <cfquery datasource="#application.datasource#">
                DELETE 
                FROM
                    tblcart
                WHERE
                    fldProductId = <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#">
            </cfquery>
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
        <cftry>
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
                LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id AND fldDefaultImage = 1
                WHERE
                    O.fldUserId = <cfqueryparam value="#application.objUser.decryptId(session.loginuserId)#" cfsqltype="varchar">
                <cfif structKeyExists(arguments,"orderId") AND arguments.orderId NEQ 0>
                    AND  O.fldOrder_Id LIKE <cfqueryparam value="%#arguments.orderId#%" cfsqltype="varchar">
                </cfif>
                ORDER BY O.fldOrderDate DESC
            </cfquery>
            <cfif local.fetchOrderItems.recordCount>
                <cfloop query="local.fetchOrderItems">
                    <cfset arrayAppend(local.result.orderDetails, {
                        "orderId": local.fetchOrderItems.fldOrder_Id,
                        "orderDate": dateTimeFormat(local.fetchOrderItems.fldOrderDate.toString()),
                        "imagefilepath": local.fetchOrderItems.fldImageFilePath,
                        "productName": local.fetchOrderItems.fldProductName,
                        "productId": local.fetchOrderItems.fldProduct_Id,
                        "brandName": local.fetchOrderItems.fldBrandName,
                        "quantity": local.fetchOrderItems.fldQuantity,
                        "unitPrice": local.fetchOrderItems.fldunitPrice,
                        "unittax": local.fetchOrderItems.fldunitTax,
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
                subject = "error in function: getOrderedItems", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="getOrderHistoryPdf" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="orderId" required="true" type="string">
        <cfset local.orderHistory = getOrderedItems( orderId = arguments.orderId)>
        <cfset local.fileName = "orderSummary.pdf">
        <cfset local.pdfFilePath = "../Assets/Files/" & local.fileName>
        <cfset local.pdfdownloadStruct = {}>
        <cfoutput>
            <cfdocument 
                format="PDF" 
                filename="#local.pdfFilePath#" 
                overwrite="yes">
                <h1 style="text-align: center;">Order Invoice</h1>
                <div class="order_container">
                    <div class="order-header">
                        <p><strong>Name:</strong>#local.orderHistory.orderDetails[1].firstName# #local.orderHistory.orderDetails[1].lastName#</p>
                        <p><strong>Order Number:</strong> #local.orderHistory.orderDetails[1].orderId#</p>
                        <p><strong>Order Date:</strong> #local.orderHistory.orderDetails[1].orderDate#</p>
                        <p><strong>Total Amount:</strong> #local.orderHistory.orderDetails[1].totalPrice+local.orderHistory.orderDetails[1].totalTax#</p>
                        <p class="order-status text-success"><strong>Status:</strong> Paid</p>
                    </div>
                    <table border="1" cellspacing="0" cellpadding="5" width="100%">
                        <thead>
                            <tr>
                                <th>Product Name</th>
                                <th>Brand</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Tax (%)</th>
                                <th>Total Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop array="#local.orderHistory.orderDetails#" item="product" index="i">
                                <cfset totalPrice = (product.unitPrice + (product.unitTax / 100) * product.unitPrice) * product.quantity>
                                <tr>
                                    <td>#product.productName#</td>
                                    <td>#product.brandName#</td>
                                    <td>#product.quantity#</td>
                                    <td>#product.unitPrice#</td>
                                    <td>#product.unitTax#%</td>
                                    <td>#totalPrice#</td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                    <div class="order-footer">
                        <h3>Shipping Address:</h3>
                        <p>#local.orderHistory.orderDetails[1].address1#</p>
                        <p>#local.orderHistory.orderDetails[1].address2#</p>
                        <p>#local.orderHistory.orderDetails[1].city#, #local.orderHistory.orderDetails[1].state# - #local.orderHistory.orderDetails[1].pincode#</p>
                    </div>
                </div>
            </cfdocument>
        </cfoutput>
      <cfset local.currentTime= dateTimeFormat(now(),"dd-mm-yyyy-HH-nn-ss")>
      <cfset local.pdfFileName = "#session.loginuserfirstName# #session.loginuserlastName# #local.currentTime#">
      <cfset local.pdfdownloadStruct.fileName = local.pdfFileName>
      <cfset local.pdfdownloadStruct.filepath = "./Assets/Files/" & local.fileName>
      <cfreturn local.pdfdownloadStruct>
   </cffunction>

</cfcomponent>