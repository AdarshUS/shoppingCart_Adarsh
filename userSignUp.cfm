<cfoutput>
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
        <a class="headerRightItem" href="./userLogin.cfm">
            <div class="headerRightItem-1">LogIn</div>
            <div class="headerRightItem-2">
                <i class="fa-solid fa-arrow-right-to-bracket"></i>
            </div>  
        </a>
    </header>
    <main>
        <div class="signupContainer">
            <form method="POST" onsubmit="return validateUserDetails()">
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
                   <div id="userPhoneError" class="error"></div>
                </div>
                <div class="mb-3">
                   <label for="userPassword" class="form-label">Password</label>
                   <input type="password" class="form-control" placeholder="Enter the Password" id="userPassword" name="userPassword">
                   <div id="userPasswordError" class="error"></div>
                </div>
                <div class="mb-3">
                   <input type="submit" class="form-control submitBtn btn btn-primary" placeholder="submit" id="submitBtn" name="submitBtn">
                </div>
            </form>
            <cfif structKeyExists(form,"submitBtn")>
                <cfset variables.result = application.objUser.registerUser(firstName = form.firstName,lastName = form.lastName,email = form.userEmail,phone = form.userPhone,password = form.userPassword)>
                <cfif variables.result.success AND ArrayLen(variables.result.errors) EQ 0>
                    <p class="text-primary">#variables.result.message#</p>
                <cfelse>
                    <p class="text-danger">#variables.result.message#</p>
              </cfif>
            </cfif>
        </div>
    </main>
   <script src="./Script/userPageScript.js"></script>
</body>
</html>
</cfoutput>