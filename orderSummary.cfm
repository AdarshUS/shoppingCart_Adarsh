<cfset selectedAddress = application.objProfile.fetchAddress(url.addressId)>
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
                        <p><strong>#product.productName#</strong></p>
                        <p class="price">Actual Price: <i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</p>
                        <p>Tax: #product.unitTax#%</p>
                        <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i>999.00</p>
                        <div class="quantity">
                            <button>-</button>
                            <input type="text" name="" id="orderInput" class="orderInput" value="1">
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
        <p class="payable">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i> #payableAmount#</p>
        <div class="quantity">
            <button>-</button>
            <input type="text" name="" id="orderInput" class="orderInput" value="1">
            <button>+</button>
        </div>
    </div>
</div>

            
        </cfif>
        <button class="place-order">Place Order</button>
    </div>
</body>
</html>
</cfoutput>