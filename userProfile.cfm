<cfif structKeyExists(form,"submit")>
    <cfset result = application.objProfile.addAddress(firstName = form.firstName,lastName = form.lastName,phone = form.phone,address1 = form.address1,address2 = form.address2,city = form.city,state = form.state,pincode = form.pincode)>    
</cfif>
<cfset userdetailsResult = application.objUser.fetchUserDetails()>
<cfset addressResult = application.objProfile.fetchAddress()>
<cfif structKeyExists(form,"editSubmitBtn")>
    <cfset application.objUser.updateProfile(firstName = form.firstName,lastName = form.lastName,email = form.email,phone = form.phone)>
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
                <button class="btn btn-info">order Details</button>
            </div>
        </div>
    </main>
    <div class="modal fade" id="addressAddModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addressAddModal">Add Address</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="post" onsubmit="return validateAddress()">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="firstName" class="form-label required">FirstName:</label>
                            <input type="text" class="form-control" name="firstName" id="firstName" placeholder="Enter the first name">
                            <div class="error" id="firstNameError"></div>
                        </div>
                        <div class="mb-3">
                            <label for="lastName" class="form-label">LastName:</label>
                            <input type="text" class="form-control" name="lastName" id="lastName" placeholder="Enter the last name">
                            <div id ="lastNameError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label required">Phone:</label>
                            <input type="text" class="form-control" name="phone" id="phone" placeholder="Enter the phone">
                            <div id ="phoneError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="address1" class="form-label required">AddressLine1:</label>
                            <input type="text" class="form-control" name="address1" id="address1" placeholder="Enter the AddressLine1">
                            <div id ="address1Error" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="address2" class="form-label">AddressLine2:</label>
                            <input type="text" class="form-control" name="address2" id="address2" placeholder="Enter the AddressLine2">
                            <div id ="address2Error" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="city" class="form-label required">City:</label>
                            <input type="text" class="form-control" class="form-control" name="city" id="city" placeholder="Enter the City">
                            <div id ="cityError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="state" class="form-label required">State:</label>
                            <input type="text" class="form-control" name="state" id="state" placeholder="Enter the State">
                            <div id ="stateError" class="error"></div>
                        </div>
                        <div class="mb-3">
                            <label for="pincode" class="form-label required">Pincode:</label>
                            <input type="text" class="form-control" name="pincode" id="pincode" placeholder="Enter the Pincode">
                            <div id ="pincodeError" class="error"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" id="submit" name="submit">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
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