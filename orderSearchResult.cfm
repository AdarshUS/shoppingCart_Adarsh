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
        <cfset variables.productId = listToArray(variables.orderHistory.orderDetails[1].productId)>
        <cfset variables.productNames = listToArray(variables.orderHistory.orderDetails[1].productName)>
        <cfset variables.quantity = listToArray(variables.orderHistory.orderDetails[1].quantity)>
        <cfset variables.unitPrices = listToArray(variables.orderHistory.orderDetails[1].unitPrice)>
        <cfset variables.unitTaxes = listToArray(variables.orderHistory.orderDetails[1].unittax)>
        <cfset variables.imagePath = listToArray(variables.orderHistory.orderDetails[1].imagefilepath)>
        <cfset variables.brandNames= listToArray(variables.orderHistory.orderDetails[1].brandName)>
        <div class="order_container">
            <div class="order-header">
                <span>Order Number: <strong>#variables.orderHistory.orderDetails[1].orderId#</strong></span>
                <span>Order Date: <strong>#variables.orderHistory.orderDetails[1].orderDate#</strong></span>
                <span>Total Amount: <strong>#variables.orderHistory.orderDetails[1].totalPrice#</strong></span>
                <span class="order-status text-success">Processed</span>
            </div>
            <cfloop array="#variables.productId#" item="product" index="i">
                <cfset totalPrice = variables.unitPrices[i] + (variables.unitTaxes[i] / 100) * variables.unitPrices[i]>
                <div class="order-item">
                    <img src="./Assets/uploads/product#variables.productId[i]#/#variables.imagePath[i]#" alt="product">
                    <div class="order-item-info">
                        <h4>#variables.productNames[i]#</h4>
                        <p>Brand: #variables.brandNames[i]#</p>
                        <p>Quantity: #variables.quantity[i]#</p>
                    </div>
                    <div class="priceCntr">
                        <span class="order-Actualprice"><span class="priceCntrText">Actual Price:</span>#variables.unitPrices[i]#</span>
                        <span class="order-ActualTax"><span class="priceCntrText">Tax: </span>#variables.unitTaxes[i]#%</span>
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