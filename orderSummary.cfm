<cfset variables.selectedAddress = application.objUser.fetchAddress(url.addressId)>
<cfparam name="url.productId" type="string" default="">
<cfparam name="product" type="struct" default="#StructNew()#">
<cfset variables.payableAmount = 0>
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
    <link rel="stylesheet" href="./Style/orderSummary.css">
</head>
<body>
    <cfinclude  template="header.cfm">
    <div class="order-summary">
        <h2>ORDER SUMMARY</h2>
        <div class="address">
            <span class="firstName">#session.loginuserfirstName#</span>
            <span class="lastName">#session.loginuserlastName#</span>
            <span class="phone">#variables.selectedAddress.Address[1].phone#</span>
            <div class="addressLine1">#variables.selectedAddress.Address[1].addressline1#</div>
            <div class="addressLine2">#variables.selectedAddress.Address[1].addressline2#</div>
            <div class="city">#variables.selectedAddress.Address[1].city#</div>
            <div class="state">#variables.selectedAddress.Address[1].state#</div>
            <div class="pincode">#variables.selectedAddress.Address[1].pincode#</div>
        </div>
        <cfif structKeyExists(url,"type") AND url.type EQ "cart">
            <cfset variables.totalPrice = 0>
            <cfset variables.totalTax = 0>
            <cfset variables.cartItems = application.objCart.fetchCart()>
            <cfloop array="#variables.cartItems.data#" item="product">
            <cfset variables.payableAmount = 0>
                <div class="product">
                    <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" alt="productImage">
                    <div class="details">
                        <cfset variables.payableAmount = (product.unitPrice + (product.unitPrice * product.unitTax / 100) )* product.quantity>
                        <cfset variables.totalPrice += product.unitPrice * product.quantity>
                        <cfset variables.totalTax += (product.unitPrice * product.unitTax / 100) * product.quantity>
                        <p><strong>#product.productName#</strong></p>
                        <p class="price">Actual Price: <i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</p>
                        <p>Tax: #product.unitTax#%</p>
                        <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i><span id="payableAmt">#variables.payableAmount#</span></p>
                        <div class="quantity">
                            <button>-</button>
                            <input type="text" name="" id="orderInput" class="orderInput" value="#product.quantity#">
                            <button>+</button>
                        </div>
                    </div>
                </div>
            </cfloop>
            <div class="totals">
                <p class="totlPrice"><strong>Total Price: </strong><i class="fa-solid fa-indian-rupee-sign"></i> #variables.totalPrice#</p>
                <p class="totlTax"><strong>Total Tax: </strong><i class="fa-solid fa-indian-rupee-sign"></i> #variables.totalTax#</p>
                <p class="payable"><strong>Total Payable Amount: </strong><i class="fa-solid fa-indian-rupee-sign"></i> #variables.totalPrice + variables.totalTax#</p>
            </div>
        <cfelse>
            <cfset variables.payableAmount = 0>
            <cfset variables.product = application.objProductManagement.getProductDetails(url.productId)>
            <cfset variables.payableAmount =  variables.product.data.unitPrice + ( variables.product.data.unitPrice *  variables.product.data.unitTax / 100)>
            <div class="product">
                <img src="#'./Assets/uploads/product'&application.objUser.decryptId(variables.product.data.productId)#/#variables.product.data.defaultImagePath#" alt="productImage">
                <div class="details">
                    <p><strong>#variables.product.data.productName#</strong></p>
                    <p class="price">Actual Price: <i class="fa-solid fa-indian-rupee-sign"></i> #variables.product.data.unitPrice#</p>
                    <p>Tax: #variables.product.data.unitTax#%</p>
                    <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i><span id="payableAmt">#variables.payableAmount#</span></p>
                    <div class="quantity">
                        <button onclick="decreaseQuantity()" id="decreaseQntyBtnCart">-</button>
                        <input type="text" name="" id="orderInput" class="orderInput" value="1">
                        <button onclick="increaseQuantity()">+</button>
                    </div>
                </div>
            </div>
        </cfif>
        <button class="place-order" data-bs-toggle="modal" data-bs-target="##cardModal">Place Order</button>
    </div>
    <div class="modal fade" id="cardModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Credit Card Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3 cardFeild">
                        <input type="text" class="form-control" name="cardNumber" id="cardNumber" placeholder="Card Number">
                        <div id ="cardNoError" class="error"></div>
                    </div>
                    <div class="mb-3 cardFeild card_date">
                        <input type="text" class="form-control cardMonth" name="cardMonth" id="cardMonth" placeholder="month">
                        <input type="text" class="form-control cardYear" name="cardYear" id="cardYear" placeholder="year">
                    </div>
                        <div class="errorCntr cardFeild d-flex justify-content-between">
                            <div id ="cardMonthError"  class="error"></div>
                            <div id ="cardYearError"  class="error"></div>
                        </div>
                    <div class="mb-3 cardFeild cvvCntr">
                        <input type="text" class="form-control" name="cardcvv" id="cardcvv" placeholder="CVV">
                        <div class="cvvText">3 or 4 digits usually found on the signature strip</div>
                    </div>
                        <div id ="cardCvvError"  class="error"></div>
                    <cfif structKeyExists(url,"type") AND url.type EQ "single">
                        <button class="cardButton cardproceedBtn" onclick="checkout('#url.addressId#','#url.productId#',#variables.payableAmount#,#product.data.unitPrice#,#product.data.unitTax#)">
                            Proceed
                        </button>
                    <cfelse>
                        <button class="cardButton cardproceedBtn" onclick="checkout('#url.addressId#','#url.productId#',#variables.payableAmount#)">
                            Proceed
                        </button>
                    </cfif>
                    <div id="cardVerify"></div>
                </div>
            </div>
        </div>
    </div>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/bootstrapScript.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="./Script/orderSummary.js"></script>
</body>
</html>
</cfoutput>