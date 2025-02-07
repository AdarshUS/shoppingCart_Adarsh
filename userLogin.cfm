<!DOCTYPE html>
<cfoutput>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Login</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/fontawesome.css">
   <link rel="stylesheet" href="./Style/userLoginStyle.css">
</head>
<body>
   <header>
       <div class="headerLeftItem">
         <div class="headerLeftItem-1">
            <img src="./Assets/Images/cart.png" alt="cartImage" width="40">
         </div>
      </div>
      <div class="headerRightItem">
         <div class="headerRightItem-1">LogIn</div>
         <div class="headerRightItem-2">
            <i class="fa-solid fa-arrow-right-to-bracket"></i>
         </div>
      </div>
   </header>
   <main>
      <div class="signupContainer">
         <form method="POST" onsubmit="return validateUserLogin()">
            <div class="mb-3">
               <label for="userName" class="form-label">UserName</label>
               <input type="text" class="form-control" placeholder="Email or Phone" id="userName" name="userName" required>
               <div id="userNameError" class="error"></div>
            </div>
            <div class="mb-3 passwordCntr">
               <label for="userPassword" class="form-label">Password</label>
               <input type="password" class="form-control" placeholder="Enter the Password" id="userPassword" name="userPassword" required>
               <div class="passwordToggle" onclick="togglePassword()">
                  <i class="fa-solid fa-eye"></i>
               </div>
               <div id="userPasswordError" class="error"></div>
            </div>
            <div class="mb-3">
               <input type="submit" class="form-control submitBtn btn btn-primary" value="Login" name="submitBtn">
               <div class="registerContainer">Don't have an account? <a href="./userSignUp.cfm">Register Here</a></div>
            </div>
         </form>
         <cfif structKeyExists(form, "submitBtn")>
            <cfset result = application.objUser.userLogin(userName = form.userName, password = form.userPassword)>
            <cfif NOT result.success>
               <div class="alert alert-danger">#result.message#</div>
            <cfelse>
               <cfif structKeyExists(url, "redirect")>
                  <cfif url.redirect EQ "cart" AND structKeyExists(url, "productId")>
                     <cfset application.objCart.addTocart(url.productId, 1)>
                     <cflocation url="cart.cfm" addtoken="no">
                  <cfelseif url.redirect EQ "cartpage">
                     <cflocation url="cart.cfm" addToken="no">
                  <cfelseif url.redirect EQ "product" AND structKeyExists(url, "productId")>
                     <cflocation url="productDetails.cfm?productId=#url.productId#" addtoken="no">
                  <cfelse>
                     <cflocation url="homePage.cfm" addtoken="no">
                  </cfif>
               <cfelse>
                  <cflocation url="homePage.cfm" addtoken="no">
               </cfif>
            </cfif>
         </cfif>
      </div>
   </main>
   <script src="./Script/userPageScript.js"></script>   
</body>
</html>
</cfoutput>
