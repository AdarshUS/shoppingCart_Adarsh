<cfif structKeyExists(form,"submit")>
    <cflocation url="orderSearchResult.cfm?orderId=#form.orderId#" addtoken="no">
</cfif>
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
    <div class="mb-4 m-3">
        <form class="d-flex align-items-center" method="post">
            <span class="font-weight-bold">Order History</span>
            <input class="form-control me-2" type="search" placeholder="Search orderId" aria-label="Search" name ="orderId">
            <button class="btn btn-outline-success" type="submit" name="submit">Search</button>
        </form>
    </div>
    <cfset variables.orderHistory = application.objCart.getOrderedItems()>
    <cfloop array = "#variables.orderHistory.orderDetails#" item = "order">
        <cfset variables.productId = listToArray(order.productId)>
        <cfset variables.productNames = listToArray(order.productName)>
        <cfset variables.quantity = listToArray(order.quantity)>
        <cfset variables.unitPrices = listToArray(order.unitPrice)>
        <cfset variables.unitTaxes = listToArray(order.unittax)>
        <cfset variables.imagePath = listToArray(order.imagefilepath)>
        <cfset variables.brandNames= listToArray(order.brandName)>
        <div class="order_container">
            <div class="order-header">
                <span>Order Number: <strong>#order.orderId#</strong></span>
                <span>Order Date: <strong>#order.orderDate#</strong></span>
                <span>Total Amount: <strong>#order.totalPrice#</strong></span>
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
                <span><strong>#order.address1#</strong></span>
                <span><strong>#order.address2#</strong></span>
                <span><strong>#order.city#</strong></span>
                <span><strong>#order.state#</strong></span>
                <span><strong>#order.pincode#</strong></span>
            </div>
            <button onclick="getOrderInvoicePdf('#order.orderId#')">
                <img src="./Assets/Images/pdfIcon.png" alt="pdfIcon" width="60">
            </button>
        </div>
        </div>
    </cfloop>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/orderSummary.js"></script>
</body>
</html>
</cfoutput>