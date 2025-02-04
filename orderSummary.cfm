<cfset selectedAddress = application.objProfile.fetchAddress(url.addressId)>
<cfparam name="url.productId" type="string" default="">
<cfparam name="product" type="struct" default="#StructNew()#">
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
            <span class="phone">#selectedAddress.Address[1].phone#</span>
            <div class="addressLine1">#selectedAddress.Address[1].addressline1#</div>
            <div class="addressLine2">#selectedAddress.Address[1].addressline2#</div>
            <div class="city">#selectedAddress.Address[1].city#</div>
            <div class="state">#selectedAddress.Address[1].state#</div>
            <div class="pincode">#selectedAddress.Address[1].pincode#</div>
        </div>
        <cfif structKeyExists(url,"type") AND url.type EQ "cart">
            <cfset cartItems = application.objCart.fetchCart()>
            <cfloop array="#cartItems.data#" item="product">
                <div class="product">
                    <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" alt="productImage">
                    <div class="details">
                        <cfset payableAmount = product.unitPrice + (product.unitPrice * product.unitTax / 100) * product.quantity>
                        <p><strong>#product.productName#</strong></p>
                        <p class="price">Actual Price: <i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</p>
                        <p>Tax: #product.unitTax#%</p>
                        <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i><span id="payableAmt">#payableAmount#</span></p>
                        <div class="quantity">
                            <button>-</button>
                            <input type="text" name="" id="orderInput" class="orderInput" value="#product.quantity#">
                            <button>+</button>
                        </div>
                    </div>
                </div>
            </cfloop>
        <cfelse>
            <cfset product = application.objProductManagement.getProductDetails(url.productId)>
            <cfset payableAmount = product.data.unitPrice + (product.data.unitPrice * product.data.unitTax / 100)>
            <div class="product">
                <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.data.productId)#/#product.data.defaultImagePath#" alt="productImage">
                <div class="details">
                    <p><strong>#product.data.productName#</strong></p>
                    <p class="price">Actual Price: <i class="fa-solid fa-indian-rupee-sign"></i> #product.data.unitPrice#</p>
                    <p>Tax: #product.data.unitTax#%</p>
                    <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i><span id="payableAmt">#payableAmount#</span></p>
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
                    <cfif structKeyExists(url,"type")>
                            buy now
                          <button class="cardButton cardproceedBtn" onclick="checkout('#url.addressId#','#url.productId#',#payableAmount#,#product.data.unitPrice#,#product.data.unitTax#)">
                            Proceed
                        </button>
                    <cfelse>
                        cart
                        <button class="cardButton cardproceedBtn" onclick="checkout('#url.addressId#','#url.productId#',#payableAmount#)">
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
    <script src="./Script/orderSummary.js"></script>
</body>
</html>
</cfoutput>