<cfparam name="url.page" default="1">
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
            <input class="form-control me-2" type="search" placeholder="Search orderId" aria-label="Search" name ="orderId" required>
            <button class="btn btn-outline-success" type="submit" name="submit">Search</button>
        </form>
    </div>
    <cfset variables.orderHistory = application.objCart.getOrderedItems(page = url.page)>
        <cfloop array = "#variables.orderHistory.orders#" item="order">
            <div class="order_container">
                <div class="order-header">
                    <span>Order Number: <br><strong>#order.orderId#</strong></span>
                    <span>Order Date: <br><strong>#order.orderDate#</strong></span>
                    <span>Total Amount: <br><strong>#order.totalPrice+order.totalTax#</strong></span>
                    <span class="order-status text-success">Paid</span>
                </div>
                <cfloop array="#order.products#" item="product">
                        <cfset totalPrice = (product.unitPrice + (product.unitTax / 100) * product.unitPrice) * product.quantity>
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
                        <span><strong>#order.address1#</strong></span>
                        <span><strong>#order.address2#</strong></span>
                        <span><strong>#order.city#</strong></span>
                        <span><strong>#order.state#</strong></span>
                        <span><strong>#order.pincode#</strong></span>
                    </div>
                    <button onclick="location.href='orderInvoice.cfm?orderId=#order.orderId#'">
                        <img src="./Assets/Images/pdfIcon.png" alt="pdfIcon" width="60">
                    </button>
                </div>
            </div>
        </cfloop>
        <div class="d-flex justify-content-end p-3">
            <ul class="pagination">
                <cfif url.page GT 1>
                    <li class="page-item">
                        <a class="page-link" href="orderHistory.cfm?page=#url.page-1#">Previous</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="orderHistory.cfm?page=#url.page-1#">#url.page-1#</a>
                    </li>
                <cfelse>
                    <li class="page-item disabled">
                        <span class="page-link">Previous</span>
                    </li>
                </cfif>
                <li class="page-item active">
                    <span class="page-link">
                        <span class="">#url.page#</span>
                    </span>
                </li>
                <cfif url.page LT 5>
                    <li class="page-item">
                        <a class="page-link" href="orderHistory.cfm?page=#url.page+1#">#url.page+1#</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="orderHistory.cfm?page=#url.page+1#">Next</a>
                    </li>
                <cfelse>
                     <li class="page-item disabled">
                        <a class="page-link" href="">Next</a>
                    </li>
                </cfif>
            </ul>
        </div>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/orderSummary.js"></script>
    <script src="./Script/userPageScript.js"></script>
</body>
</html>
</cfoutput>