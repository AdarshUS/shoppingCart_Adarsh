<!DOCTYPE html>
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
    <cfset local.productId = listToArray(local.orderHistory.orderDetails[1].productId)>
    <cfset local.productNames = listToArray(local.orderHistory.orderDetails[1].productName)>
    <cfset local.quantity = listToArray(local.orderHistory.orderDetails[1].quantity)>
    <cfset local.unitPrices = listToArray(local.orderHistory.orderDetails[1].unitPrice)>
    <cfset local.unitTaxes = listToArray(local.orderHistory.orderDetails[1].unittax)>
    <cfset local.imagePath = listToArray(local.orderHistory.orderDetails[1].imagefilepath)>
    <cfset local.brandNames= listToArray(local.orderHistory.orderDetails[1].brandName)>
    <div class="order_container">
        <div class="order-header">
            <span>Order Number: <strong>#local.orderHistory.orderDetails[1].orderId#</strong></span>
            <span>Order Date: <strong>#local.orderHistory.orderDetails[1].orderDate#</strong></span>
            <span>Total Amount: <strong>#local.orderHistory.orderDetails[1].totalPrice#</strong></span>
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
            <span><strong>#local.orderHistory.orderDetails[1].address1#</strong></span>
            <span><strong>#local.orderHistory.orderDetails[1].address2#</strong></span>
            <span><strong>#local.orderHistory.orderDetails[1].city#</strong></span>
            <span><strong>#local.orderHistory.orderDetails[1].state#</strong></span>
            <span><strong>#local.orderHistory.orderDetails[1].pincode#</strong></span>
        </div>
    </div>
</body>
</html>