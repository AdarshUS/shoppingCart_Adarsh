  <cfset local.orderHistory = application.objCart.getOrderedItems( orderId = url.orderId)>
        <cfset local.fileName = "orderSummary.pdf">
        <cfset local.pdfFilePath = "../Assets/Files/" & local.fileName>
        <cfset local.currentTime= dateTimeFormat(now(),"dd-mm-yyyy-HH-nn-ss")>
        <cfset local.pdfFileName = "#session.loginuserfirstName# #session.loginuserlastName# #local.currentTime#">
        <cfoutput>
            <cfheader name="Content-disposition" value="attachment; filename=#local.pdfFileName#.pdf">
            <cfdocument 
                format="PDF" 
                overwrite="yes">
                <h1 style="text-align: center;">Order Invoice</h1>
                <div class="order_container">
                    <div class="order-header">
                        <p><strong>Name:</strong>#local.orderHistory.orders[1].firstName# #local.orderHistory.orders[1].lastName#</p>
                        <p><strong>Order Number:</strong> #local.orderHistory.orders[1].orderId#</p>
                        <p><strong>Order Date:</strong> #local.orderHistory.orders[1].orderDate#</p>
                        <p><strong>Total Amount:</strong> #local.orderHistory.orders[1].totalPrice+local.orderHistory.orders[1].totalTax#</p>
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
                            <cfloop array="#local.orderHistory.orders[1].products#" item="product" index="i">
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
                        <p>#local.orderHistory.orders[1].address1#</p>
                        <p>#local.orderHistory.orders[1].address2#</p>
                        <p>#local.orderHistory.orders[1].city#, #local.orderHistory.orders[1].state# - #local.orderHistory.orders[1].pincode#</p>
                    </div>
                </div>
            </cfdocument>
        </cfoutput>
     