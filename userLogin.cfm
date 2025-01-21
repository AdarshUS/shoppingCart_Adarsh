<cfoutput >
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" href="./Style/userLoginStyle.css">
   <link rel="stylesheet" href="./Style/bootstrap.css">
</head>
<body>
   <header>
       <div class="headerLeftItem">
         <div class="headerLeftItem-1"> <img src="./Assets/Images/cart.png" alt="cartImage" width="40"></div>
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
         <form method="POST" onsubmit="return validateUserDetails()">
             <div class="mb-3">
               <label for="userName" class="form-label">UserName</label>
               <input type="email" class="form-control" placeholder="Enter the UserName" id="userName" name="userName">
               <div id="userNameError" class="error"></div>
            </div>
            <div class="mb-3">
               <label for="userPassword" class="form-label">Phone</label>
               <input type="text" class="form-control" placeholder="Enter the Password" id="userPassword" name="userPassword">
               <div id="userPasswordError" class="error"></div>
            </div>
            <div class="mb-3">
               <input type="submit" class="form-control submitBtn btn btn-primary" placeholder="submit" id="submitBtn" name="submitBtn">
            </div>
         </form>
         <cfif structKeyExists(form,"submitBtn")>
            <cfset result = application.objUser.validateUser(userName = form.userName,password = form.userPassword)>            
               <p class="text-primary">#result.message#</p>
               <cfset encryptedUserId = application.objUser.encryptId(result.userId)>
               <cfset session.loginuserId = result.encryptedUserId>
               <cflocation url="homePage.cfm" addtoken="no">
         </cfif>
      </div>
   </main>
</body>
</html>
</cfoutput>