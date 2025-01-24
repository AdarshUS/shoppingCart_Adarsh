<cfset cart = application.objProductManagement.fetchCart(userId = session.loginuserId)>
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
                     <tr>
                     <td>
                        <img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="Analog Magazine Rack">
                        #product.productName#<br>
                        <small></small>
                     </td>
                     <td><i class="fa-solid fa-indian-rupee-sign"></i><span id="actualprice#product.cartId#">#product.unitPrice#</span></td>
                     <td>
                        <div class="quantity-controls">
                           <button onclick="decreaseQuantity(#product.cartId#,'decrement')">-</button>
                           <input type="text" value="#product.quantity#" id="qntyNo#product.cartId#">
                           <button onclick="increaseQuantity(#product.cartId#,'increment')">+</button>
                        </div>
                     </td>
                     <td><i class="fa-solid fa-indian-rupee-sign"></i><span id="totalPrice#product.cartId#">#product.unitPrice*product.quantity#</span></td>
                     <td><a href="" class="remove-item"><i class="fa-solid fa-xmark"></i></a></td>
                  </tr>
                  </cfloop>
               </tbody>
            </table>
         </div>
         <div class="order-summary">
            <h2>Order Summary</h2>
            <p>Subtotal: <strong><i class="fa-solid fa-indian-rupee-sign"></i>418</strong></p>
            <p>Shipping: <strong>Free</strong></p>
            <p><span class="coupon-code">Add coupon code</span></p>
            <p>Total: <strong><i class="fa-solid fa-indian-rupee-sign"></i>418</strong></p>
            <a href="" class="checkout-btn">Checkout</a>
         </div>
      </div>
      <script src="./Script/jquery-3.7.1.min.js"></script>
      <script src="./Script/userPageScript.js"></script>
   </body>
</html>
</cfoutput>