<!DOCTYPE html>
<cfoutput>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="./Style/bootstrap.css">
    <link rel="stylesheet" href="./Style/fontawesome.css">
    <link rel="stylesheet" href="./Style/homestyle.css">
    <link rel="stylesheet" href="./Style/orderHistory.css">
</head>
<body>
    <cfinclude template = "header.cfm">
    <cfinclude template = "navbar.cfm">
    <cfset variables.orderHistory = application.objCart.getOrderedItems( orderId = url.orderId)>
    <cfif ArrayLen(variables.orderHistory.orderDetails)>
        <div class="order_container">
            <div class="order-header">
                <span>Order Number: <strong>#variables.orderHistory.orderDetails[1].orderId#</strong></span>
                <span>Order Date: <strong>#variables.orderHistory.orderDetails[1].orderDate#</strong></span>
                <span>Total Amount: <strong> #variables.orderHistory.orderDetails[1].totalPrice+variables.orderHistory.orderDetails[1].totalTax#</strong></span>
                <span class="order-status text-success">Processed</span>
            </div>
            <cfloop array="#variables.orderHistory.orderDetails#" item="product" index="i">
                <cfset totalPrice = product.unitPrice + (product.unitTax / 100) * product.unitPrice>
                <div class="order-item">
                    <img src="./Assets/uploads/product#product.productId#/#product.imagefilepath#" alt="product">
                    <div class="order-item-info">
                        <h4>#product.productName#</h4>
                        <p>Brand: #product.brandName#</p>
                        <p>Quantity: #product.quantity#</p>
                    </div>
                    <div class="priceCntr">
                        <span class="order-Actualprice"><span class="priceCntrText">Actual Price:</span>#product.unitPrice#</span>
                        <span class="order-ActualTax"><span class="priceCntrText">Tax: </span>#product.unitTax#%</span>
                        <span class="order-Total"><span class="priceCntrText">Total: </span>#totalPrice#</span>
                    </div>
                </div>
            </cfloop>
            <div class="order-footer">
            <div>
                <div>Shipping Address :</div>
                <span><strong>#variables.orderHistory.orderDetails[1].address1#</strong></span>
                <span><strong>#variables.orderHistory.orderDetails[1].address2#</strong></span>
                <span><strong>#variables.orderHistory.orderDetails[1].city#</strong></span>
                <span><strong>#variables.orderHistory.orderDetails[1].state#</strong></span>
                <span><strong>#variables.orderHistory.orderDetails[1].pincode#</strong></span>
            </div>
        </div>
    <cfelse>
        <div>No order Found on this orderId</div>
    </cfif>
</body>
</html>
</cfoutput>