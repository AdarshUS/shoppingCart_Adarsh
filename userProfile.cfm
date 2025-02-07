<cfif NOT structKeyExists(session,"loginuserId")>
    <cflocation url="userLogin.cfm" addtoken="no">
</cfif>
<cfset userdetailsResult = application.objUser.fetchUserDetails()>
<cfset addressResult = application.objUser.fetchAddress()>
<cfif structKeyExists(form,"editSubmitBtn")>
    <cfset application.objUser.updateProfile(firstName = form.firstName,lastName = form.lastName,email = form.email,phone = form.phone)>
     <cflocation url="userProfile.cfm" addtoken="no">
</cfif>
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
   <link rel="stylesheet" href="./Style/profile.css">
</head>
<body>
    <cfinclude template = "header.cfm">
    <main>
        <div class="profileinfoContainer">
            <div class="profileIcon">
                <img src="./Assets/Images/profile.png" alt="profileimg" width="60">
            </div>
            <div class="profileDetails">
                <div>hello,</div>
                <div class="profileName">#userdetailsResult.userDetails[1].firstName# #userdetailsResult.userDetails[1].lastName#</div>
                <div class="profileEmail">email: #userdetailsResult.userDetails[1].email#</div>
            </div>
            <button class="editProfBtn" data-bs-toggle="modal" data-bs-target="##editProfileModal"><i class="fa-solid fa-pen"></i></button>
        </div>
        <div class="addressContainer">
            <div class="profile-info">profile Informations</div>
            <div class="addressBox">
                <cfloop array="#addressResult.address#" item="address">
                    <div class="addressItem" id="#address.addressId#">
                        <div>
                            <span class="firstName">#address.firstName#</span>
                            <span class="lastName">#address.lastName#</span>
                            <span class="phone">#address.phone#</span>
                            <div class="addressLine1">#address.addressline1#</div>
                            <div class="addressLine2">#address.addressline2#</div>
                            <div class="city">#address.city#</div>
                            <div class="state">#address.state#</div>
                            <div class="pincode">#address.pincode#</div>
                        </div>
                        <div class="deleteAddressBtn">
                            <button onclick="deleteAddress('#address.addressId#')" class="deleteaddressbtn">
                                <i class="fa-solid fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </cfloop>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##addressAddModal">Add New Address</button>
                <a class="btn btn-info" href="./orderhistory.cfm">order Details</a>
            </div>
        </div>
    </main>
    <cfinclude template="addAdress.cfm">
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST">
                    <div class="modal-header">
                        <div class="editProfileText">Edit Profile</div>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="firstName" class="form-label">FirstName:</label>
                            <input type="text" class="form-control" name="firstName" id="firstName" value="#userdetailsResult.userDetails[1].firstName#">
                            <div id ="firstNameError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label">LastName:</label>
                            <input type="text" class="form-control" name="lastName" id="lastName" value="#userdetailsResult.userDetails[1].lastName#">
                            <div id ="lastNameError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email:</label>
                            <input type="text" class="form-control" name="email" id="email" value="#userdetailsResult.userDetails[1].email#">
                            <div id ="emailError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">phone:</label>
                            <input type="text" class="form-control" name="phone" id="phone" value="#userdetailsResult.userDetails[1].phone#">
                            <div id ="phoneError" class="error"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" id="editSubmitBtn" name="editSubmitBtn">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="./Script/bootstrapScript.js"></script>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/userPageScript.js"></script>
</body>
</html>
</cfoutput>