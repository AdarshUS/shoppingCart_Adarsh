<cfif structKeyExists(form,"submitBtn")>
   <cfset result = application.objUserLogin.registerUser(firstName)>
</cfif>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/fontawesome.css">
   <link rel="stylesheet" href="./Style/userSignup.css">
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
         <form>
            <div class="mb-3">                      
               <label for="firstName" class="form-label">FirstName</label>
               <input type="text" class="form-control" placeholder="Enter the FirstName" id="firstName" name="firstName">              
               <div id="firstNameError" class="error"></div>
            </div>
            <div class="mb-3">                      
               <label for="lastName" class="form-label">LastName</label>
               <input type="text" class="form-control" placeholder="Enter the LastName" id="lastName" name="lastName">              
               <div id="lastNameError" class="error"></div>
            </div>
             <div class="mb-3">                      
               <label for="userEmail" class="form-label">Email</label>
               <input type="email" class="form-control" placeholder="Enter the Email" id="userEmail" name="userEmail">              
               <div id="userEmailError" class="error"></div>
            </div>
            <div class="mb-3">                      
               <label for="userPhone" class="form-label">Phone</label>
               <input type="text" class="form-control" placeholder="Enter the Phone" id="userPhone" name="userPhone">              
               <div id="userEmailError" class="error"></div>
            </div>
            <div class="mb-3">                      
               <label for="userPhone" class="form-label">Password</label>
               <input type="password" class="form-control" placeholder="Enter the Password" id="userPassword" name="userPassword">              
               <div id="userPasswordError" class="error"></div>
            </div>
            <div class="mb-3">              
               <input type="submit" class="form-control submitBtn btn btn-primary" placeholder="submit" id="submitBtn" name="submitBtn">               
            </div>
         </form>
      </div>
   </main>
</body>
</html>