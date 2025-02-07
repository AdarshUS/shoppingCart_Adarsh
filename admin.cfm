<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>AdminLogin</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/all.min.css"> 
   <link rel="stylesheet" href="./Style/style.css">
</head>
<body>
   <header>
      <div class="headerLeftItem">
         <div class="headerLeftItem-1"> <img src="./Assets/Images/cart.png" alt="cartImage" width="40"></div>
         <div class="headerLeftItem-2">Admin</div>
      </div>
      <div class="headerRightItem">
         <div class="headerRightItem-1">LogIn</div>
         <div class="headerRightItem-2">
            <i class="fa-solid fa-arrow-right-to-bracket"></i>
         </div>  
      </div>
   </header>
   <main>
      <div class="loginContainer">
         <form method="POST" onsubmit="return validate()">
            <div class="loginContainer-heading">LOGIN</div>
            <div class="userName inputArea">
               <input type="text" id="userName" name="userName" placeholder="Username">
            </div>
             <div id="userNameError" class="error"></div> 
            <div class="password inputArea">
               <input type="password" name="password" id="password" placeholder="Password">
            </div>
            <div id="passwordError" class="error"></div>
            <div class="bottomContainer">
               <button class="loginBtn" id="submit" name="submit">LOGIN</button>
            </div>
         </form>
         <cfif structKeyExists(form,"submit")>
            <cfset result = application.objUser.adminLogin(userName = form.userName,password = form.password)>
            <cfif result.success>
               <cflocation url="./category.cfm"  addtoken="no">
            <cfelse>
               <p class="error" id="user_error">#result.message#</p>
            </cfif>
         </cfif>
      </div>
   </main>
   <script src="./Script/jquery-3.7.1.min.js"></script>
   <script src="./Script/script.js"></script>
</body>
</html>
</cfoutput>

