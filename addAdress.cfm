<cfif structKeyExists(form,"submit")>
    <cfset result = application.objProfile.addAddress(firstName = form.firstName,lastName = form.lastName,phone = form.phone,address1 = form.address1,address2 = form.address2,city = form.city,state = form.state,pincode = form.pincode)>    
</cfif>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
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
    <script src="./Script/bootstrapScript.js"></script>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/userPageScript.js"></script>
</body>
</html>