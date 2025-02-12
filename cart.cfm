<cfif NOT structKeyExists(session,"loginuserId")>
    <cfif structKeyExists(url,"redirect")>
        <cflocation url="userLogin.cfm?redirect=cartpage" addtoken="no">
    </cfif>
   <cflocation url="userLogin.cfm" addtoken="no">
</cfif>
<cfset variables.addresses = application.objUser.fetchAddress()>
<cfset variables.cart = application.objCart.fetchCart()>
<!DOCTYPE html>
<cfoutput>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Your Cart</title>
        <link rel="stylesheet" href="./Style/bootstrap.css">
        <link rel="stylesheet" href="./Style/fontawesome.css">
        <link rel="stylesheet" href="Style/homestyle.css">
    </head>
    <body>
        <cfinclude template = "header.cfm">
        <h1 class="cart_heading">Your Cart</h1>
        <cfif arrayIsEmpty(variables.cart.data)>
            <h1>Your Cart is Empty</h1>
        <cfelse>
            <div class="cartBox">
            <div class="cart-container">
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array = #variables.cart.data# item = product>
                            <tr id="#product.cartId#">
                                <td>
                                   <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilepath#" alt="Analog Magazine Rack">
                                   #product.productName#<br>
                                   <small></small>
                                </td>
                                <td class="cartProductPrice"><div><i class="fa-solid fa-indian-rupee-sign"></i><span id="productPrice#product.cartId#">#(product.unitPrice + (product.unitPrice * (product.unittax / 100)))#
                                    </span></div><span id="actualprice#product.cartId#" class="actualPric">actualprice:<span class="actualPriceCart">#product.unitPrice#</span></span><span id="productTax#product.cartId#" class="productTaxes">Tax:<span class="productTax">#product.unittax#</span>%</span>
                                </td>
                                <td>
                                    <div class="quantity-controls">
                                       <button onclick="decreaseQuantity('#product.cartId#','decrement')" id="decreaseQntyBtn">-</button>
                                       <input type="text" value="#product.quantity#" id="qntyNo#product.cartId#" class="qntyNo">
                                       <button onclick="increaseQuantity('#product.cartId#','increment')">+</button>
                                    </div>
                                </td>
                                <td><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalPrice#product.cartId#" class="totalPrice">#(product.unitPrice + (product.unitPrice * (product.unittax / 100))) * product.quantity#</span></td>
                                <td><button class="remove-item" onclick = "deleteCartItem('#product.cartId#')"><i class="fa-solid fa-xmark"></i></button></td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
            <div class="order-summary">
               <h2>Order Summary</h2>
               <p>TotalActualPrice: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalActualprice"></span></strong></p>
               <p>TotalTax: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalTax"></span></strong></p>
               <p>Shipping: <strong>Free</strong></p>
               <p>Total: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="subtotal"></span></strong></p>
               <button class="checkout-btn" data-bs-toggle="modal" data-bs-target="##selectAddressModal">CheckOut</button>
            </div>
        </div>
        </cfif>
        <div class="modal fade" id="selectAddressModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="selectAddress"></div>
                    </div>
                    <div class="modal-body">
                        <div class="savedAddressText">Saved Addresses</div>
                            <cfloop array = #variables.addresses.address# item = "address">
                                <div class="addressItem">
                                    <input type="radio" name="address" id="address" value=#urlEncodedFormat(address.addressId)#>
                                    <div class="addressContent">
                                        <div>
                                            <span class="firstName">#address.firstName#</span>
                                            <span class="lastName">#address.lastName#</span>
                                            <span class="phone">#address.phone#</span>
                                            <div class="addressLine1">#address.addressline1#</div>
                                            <div class="addressLine2">#address.addressline2#</div>
                                            <div class="city">#address.city#</div>
                                            <div class="state">#address.state#</div>
                                            <div class="pincode">#address.pincode#</div>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-success addressAddBtn" id="addAddressBtn" name="submit" data-bs-toggle="modal" data-bs-target="##addressAddModal">Add Address</button>
                        <button type="button" class="btn btn-primary" id="submit" name="submit" onclick="redirectCartToorder()">Payment Details</button>
                    </div>
                </div>
            </div>
        </div>
        <cfinclude template="addAdress.cfm">
        <script src="./Script/jquery-3.7.1.min.js"></script>
        <script src="./Script/bootstrapScript.js"></script>
        <script src="./Script/userPageScript.js"></script>
    </body>
</html>
</cfoutput>