<cfif NOT structKeyExists(session,"loginuserId")>
    <cfif structKeyExists(url,"redirect")>
        <cflocation url="userLogin.cfm?redirect='cartpage'" addtoken="no">                    
    </cfif>
   <cflocation url="userLogin.cfm" addtoken="no">
</cfif>
<cfset cart = application.objCart.fetchCart(userId = application.objUser.decryptId(session.loginuserId))>
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
                  <cfloop array = #cart.data# item = product>
                     <tr id="#product.cartId#">
                        <td>
                           <img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="Analog Magazine Rack">
                           #product.productName#<br>
                           <small></small>
                        </td>
                        <td class="cartProductPrice"><div><i class="fa-solid fa-indian-rupee-sign"></i><span id="productPrice#product.cartId#">#(product.unitPrice + (product.unitPrice * (product.unittax / 100)))#
</span></div><span id="actualprice#product.cartId#" class="actualPric">actualprice:<span class="actualPriceCart">#product.unitPrice#</span></span><span id="productTax#product.cartId#" class="productTaxes">Tax:<span class="productTax">#product.unittax#</span>%</span></td>
                        <td>
                           <div class="quantity-controls">
                              <button onclick="decreaseQuantity(#product.cartId#,'decrement')" id="decreaseQntyBtn">-</button>
                              <input type="text" value="#product.quantity#" id="qntyNo#product.cartId#" class="qntyNo">
                              <button onclick="increaseQuantity(#product.cartId#,'increment')">+</button>
                           </div>
                        </td>
                        <td><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalPrice#product.cartId#" class="totalPrice">#(product.unitPrice + (product.unitPrice * (product.unittax / 100))) * product.quantity#</span></td>
                        <td><button class="remove-item" onclick = "deleteCartItem(#product.cartId#)"><i class="fa-solid fa-xmark"></i></button></td>
                     </tr>
                  </cfloop>
               </tbody>
            </table>
         </div>
         <div class="order-summary">
            <h2>Order Summary</h2>
            <p>TotalPrice: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalActualprice"></span></strong></p>
            <p>TotalTax: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalTax"></span>%</strong></p>
            <p>Shipping: <strong>Free</strong></p>
            <p>Subtotal: <strong><i class="fa-solid fa-indian-rupee-sign"></i><span id="subtotal"></span></strong></p>
            <p><span class="coupon-code">Add coupon code</span></p>
            <a href="" class="checkout-btn">Bought Together</a>
         </div>
      </div>
      <script src="./Script/jquery-3.7.1.min.js"></script>
      <script src="./Script/userPageScript.js"></script>
   </body>
</html>
</cfoutput>