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
    <cfloop array = "#variables.orderHistory.orderDetails#" item = "order">
        <div class="order-card">
        <div class="order-header">
            <span class="order-id">#order.orderId#</span>
            <span class="order-time">
                #order.orderDate#
            </span>
        </div>
        <cfloop array = "#variables.orderHistory.orderDetails#" item = "product">
            <cfif product.orderId EQ order.orderId>
                <div class="product-details">
                    <img class="product-img" src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imagefilepath#" alt="">
                    <div class="product-info">
                        <a href="" class="product-title">#product.productName#</a><br>
                        <span>Brand: #product.brandName#</span><br>
                        <span>Quantity: #product.quantity#</span>
                    </div>
                    <div class="price-details">
                        <div>Actual Price: #product.unitPrice#</div>
                        <div>Tax: #product.unittax#</div>
                        <div class="total-price">Total Price: </div>
                    </div>
                </div>
            </cfif>
        </cfloop>
        <div class="total-cost">Total Cost: </div>
        <div class="shipping-info">
            <b>Shipping Address:</b> gsfgdxv adfszfd, szsfvs, asfasfSd 123123<br>
            <b>Contact:</b> ewrwe - 1234567890
        </div>
    </div>
    </cfloop>
</body>
</html>
</cfoutput>