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
        <form class="d-flex align-items-center">
            <span class="font-weight-bold">Order History</span>
            <input class="form-control me-2" type="search" placeholder="Search orderId" aria-label="Search">
            <button class="btn btn-outline-success" type="submit">Search</button>
        </form>
    </div>
    <cfset variables.orderHistory = application.objOrder.getOrderedItems()>
    <cfdump var="#variables.orderHistory#" >
    <cfloop array = "#variables.orderHistory.orderDetails#" item = "order">
        <div class="container">
            <div class="order-header">
                <span>Order Number: <strong>#order.orderId#</strong></span>
                <span>Order Date: <strong>#order.orderDate#</strong></span>
                <span>Total Amount: <strong>#order.totalPrice#</strong></span>
                <span class="order-status">Processed</span>
            </div>
            <cfloop array = "#variables.orderHistory.orderDetails#" item = "product">
                <cfif product.orderId EQ order.orderId>
                    <div class="order-item">
                        <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imagefilepath#" alt="Travelling Bag">
                        <div class="order-item-info">
                            <h4>#product.productName#</h4>
                            <p>Brand: #product.brandName#</p>
                            <p>Size: 67" | Color: Blue | Quantity: #product.quantity#</p>
                        </div>
                        <span class="order-price">$80.00</span>
                    </div>
                </cfif>
            </cfloop>
        </div>
    </cfloop>
</body>
</html>
</cfoutput>