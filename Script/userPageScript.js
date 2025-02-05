function validateUserDetails() {
    let validDetails = true;
    const firstName = document.getElementById("firstName").value;
    const lastName = document.getElementById("lastName").value;
    const userEmail = document.getElementById("userEmail").value;
    const userPhone = document.getElementById("userPhone").value;
    const userPassword = document.getElementById("userPassword").value;

    document.getElementById("firstNameError").innerHTML = "";
    document.getElementById("lastNameError").innerHTML = "";
    document.getElementById("userEmailError").innerHTML = "";
    document.getElementById("userPhoneError").innerHTML = "";
    document.getElementById("userPasswordError").innerHTML = "";

    if (firstName.trim() === "") {
        document.getElementById("firstNameError").innerHTML = "Enter the FirstName";
        validDetails = false;
    }

    if (lastName.trim() === "") {
        document.getElementById("lastNameError").innerHTML = "Enter the LastName";
        validDetails = false;
    }

    if (userEmail.trim() === "" || !(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(userEmail))) {
        document.getElementById("userEmailError").innerHTML = "Please enter a valid email address";
        validDetails = false;
    }

    if (userPhone.trim() === "" || !(userPhone.length == 10)) {
        document.getElementById("userPhoneError").innerHTML = "Please enter a valid 10-digit phone number";
        validDetails = false;
    }

    if (userPassword.trim() === "" || userPassword.search(/[a-z]/i) < 0 || userPassword.search(/[0-9]/) < 0 || userPassword.length < 6) {
        document.getElementById("userPasswordError").innerHTML = "Password must be at least 6 characters long & should contain 1 letter and digit";
        validDetails = false;
    }

    return validDetails;
}

function validateUserLogin() {
    let validUserInput = true;
    const userName = document.getElementById("userName").value.trim();
    const password = document.getElementById("userPassword").value.trim();

    document.getElementById("userNameError").innerHTML = "";
    document.getElementById("userPasswordError").innerHTML = "";

    if (userName === "") {
        document.getElementById("userNameError").innerHTML = "Enter the UserName";
        validUserInput = false;
    } else if (
        !isValidEmail(userName) && !isValidPhone(userName)
    ) {
        document.getElementById("userNameError").innerHTML = "UserName must be a valid email or phone number";
        validUserInput = false;
    }

    if (password === "") {
        document.getElementById("userPasswordError").innerHTML = "Enter the Password";
        validUserInput = false;
    }
    return validUserInput;
}

function isValidEmail(email) {
    const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
    return emailRegex.test(email);
}

function isValidPhone(phone) {
    const phoneRegex = /^[0-9]{10}$/;
    return phoneRegex.test(phone);
}


function filterPrices(subcategoryId) {
    let priceRange = document.querySelector('input[name="filterPrice"]:checked');
    let priceRangeValue;
    document.getElementById("productContainer").innerHTML = "";

    if (priceRange != null) {
        priceRangeValue = priceRange.value;
    } else {
        let minvalue = document.getElementById("minimumPrice").value;
        let maxvalue = document.getElementById("maxPrice").value;
        priceRangeValue = minvalue + " AND " + maxvalue;
    }
    fetchProductsRemote("fetchProducts", {
        subcategoryId: subcategoryId,
        priceRange: priceRangeValue
    });
}

function fetchProductsRemote(methodName, parameters) {
    $.ajax({
        url: `components/ProductManagement.cfc?method=${methodName}`,
        type: 'POST',
        data: parameters,
        success: function(result) {
            let parsedResult = JSON.parse(result);
            let products = parsedResult.products;
            let productContainer = document.getElementById("productContainer");
            productContainer.innerHTML = "";

            products.forEach((item) => {
                let productBox = document.createElement("a");
                productBox.className = "productBox";

                $.ajax({
                    url: 'components/User.cfc?method=decryptId',
                    type: 'POST',
                    data: {
                        encryptedId: item.productId
                    },
                    success: function(decryptResult) {
                        console.log(decryptResult);
                        let decryptedId = decryptResult.trim();
                        productBox.href = `./productDetails.cfm?productId=${item.productId}`;

                        let productImage = document.createElement("div");
                        productImage.className = "productImage";
                        let img = document.createElement("img");
                        img.src = `./Assets/uploads/product${decryptedId}/${item.imageFilePath}`;
                        img.alt = "productImage";
                        img.className = "prodimg";
                        productImage.appendChild(img);

                        let productName = document.createElement("div");
                        productName.className = "productName";
                        productName.textContent = item.productName;

                        let productPrice = document.createElement("div");
                        productPrice.className = "productPrice";
                        productPrice.innerHTML = `<i class="fa-solid fa-indian-rupee-sign"></i> ${item.unitPrice}`;

                        productBox.appendChild(productImage);
                        productBox.appendChild(productName);
                        productBox.appendChild(productPrice);

                        productContainer.appendChild(productBox);
                    },
                    error: function() {
                        console.error("Error decrypting product ID for:", item.productId);
                    }
                });
            });
        },
        error: function() {
            console.error("Error fetching products");
        }
    });
}


function logoutUser() {
    if (confirm("Are you sure you want to Logout")) {
        $.ajax({
            url: 'components/User.cfc?method=logoutUser',
            type: 'POST',
            success: function(result) {
                location.reload();
            },
            error: function() {
                console.error("Error in LogOut");
            }
        });
    }
}

function toggleProducts(subcategoryId, sort) {
    fetchProductsRemote("fetchProducts", {
        subcategoryId: subcategoryId,
        sort: sort
    });
    document.getElementById("viewMoreBtn").style.display = "none";
    document.getElementById("viewLessBtn").style.display = "flex";
}

function toggleLessProducts(subcategoryId) {
    console.log(subcategoryId);
    fetchProductsRemote("fetchProducts", {
        subcategoryId: subcategoryId,
        limit: 4,
        sort: 'ASC'
    });
    document.getElementById("viewLessBtn").style.display = "none";
    document.getElementById("viewMoreBtn").style.display = "flex";
}

function increaseQuantity(cartId, step) {
    document.getElementById("decreaseQntyBtn").disabled = false;
    let qnty = document.getElementById("qntyNo" + cartId).value;
    qnty++;
    document.getElementById("qntyNo" + cartId).value = qnty;

    $.ajax({
        url: 'components/cart.cfc?method=updateCart',
        type: 'POST',
        data: {
            cartId: cartId,
            step: step
        },
        success: function(result) {
            console.log("updated")
        },
        error: function() {
            console.error("failed to Update")
        }
    });
    document.getElementById("totalPrice" + cartId).innerHTML =
        document.getElementById("qntyNo" + cartId).value *
        document.getElementById("productPrice" + cartId).innerHTML;
    checkQnty();
    calculateTotalPrice();
}

function decreaseQuantity(cartId, step) {
    let qnty = document.getElementById("qntyNo" + cartId).value;
    qnty--;
    document.getElementById("qntyNo" + cartId).value = qnty;
    $.ajax({
        url: 'components/cart.cfc?method=updateCart',
        type: 'POST',
        data: {
            cartId: cartId,
            step: step
        },
        success: function(result) {
            console.log("successful Operation")
        },
        error: function() {
            console.error("failed")
        }
    });
    document.getElementById("totalPrice" + cartId).innerHTML =
        document.getElementById("qntyNo" + cartId).value *
        document.getElementById("productPrice" + cartId).innerHTML;
    checkQnty();
    calculateTotalPrice();
}

$(document).ready(function() {
    checkQnty();
    calculateTotalPrice();
});

function checkQnty() {
    let qnty = $(".qntyNo");
    for (let index = 0; index < qnty.length; index++) {
        console.log(qnty[index].value)
        if (qnty[index].value == 1) {
            qnty[index].previousElementSibling.disabled = true;
        } else {
            qnty[index].previousElementSibling.disabled = false;
        }
    }
}

function deleteCartItem(cartId) {
    if (confirm("Are you sure you want to delete")) {
        $.ajax({
            url: 'components/cart.cfc?method=deleteCart',
            type: 'POST',
            data: {
                cartId: cartId
            },
            success: function(result) {
                console.log("successful Operation");
                document.getElementById(cartId).remove();
                calculateTotalPrice();
            },
            error: function() {
                console.error("failed")
            }
        });
    }
}

function togglePassword() {
    var passwordField = document.getElementById("userPassword");
    var icon = document.querySelector(".passwordToggle i");
    if (passwordField.type === "password") {
        passwordField.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        passwordField.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}

function calculateTotalPrice() {
    let productprices = document.getElementsByClassName("totalPrice");
    let actualprices = document.getElementsByClassName("actualPriceCart");
    let qnty = document.getElementsByClassName("qntyNo");
    let taxes = document.getElementsByClassName("productTax");
    let totalPrice = 0;
    let totalActual = 0;
    let totalTax = 0;
    for (let index = 0; index < productprices.length; index++) {
        console.log(parseFloat(actualprices[index].innerHTML) * parseFloat(qnty[index].value));
        totalPrice += parseFloat(productprices[index].innerHTML);
        totalActual += parseFloat(actualprices[index].innerHTML) * parseFloat(qnty[index].value);
        totalTax += parseFloat(taxes[index].innerHTML);
    }
    document.getElementById("totalActualprice").innerHTML = totalActual;
    document.getElementById("totalTax").innerHTML = totalTax;
    document.getElementById("subtotal").innerHTML = totalPrice;
}

function validateAddress() {
    let validAddress = true;
    const firstName = document.getElementById("firstName").value;
    const phone = document.getElementById("phone").value;
    const address1 = document.getElementById("address1").value;
    const city = document.getElementById("city").value;
    const state = document.getElementById("state").value;
    const pincode = document.getElementById("pincode").value;

    document.getElementById("firstNameError").innerHTML = "";
    document.getElementById("phoneError").innerHTML = "";
    document.getElementById("address1Error").innerHTML = "";
    document.getElementById("cityError").innerHTML = "";
    document.getElementById("stateError").innerHTML = "";
    document.getElementById("pincodeError").innerHTML = "";

    if (firstName.trim() === "") {
        document.getElementById("firstNameError").innerHTML = "firstName cannot be empty";
        validAddress = false;
    }

    if (phone.trim() === "") {
        document.getElementById("phoneError").innerHTML = "phone cannot be empty";
        validAddress = false;
    } else if (!/^[0-9]{10}$/.test(phone)) {
        document.getElementById("phoneError").innerHTML = "Enter valid phoneNumber";
        validAddress = false;
    }

    if (address1.trim() === "") {
        document.getElementById("address1Error").innerHTML = "address cannot be empty";
        validAddress = false;
    }

    if (city.trim() === "") {
        document.getElementById("cityError").innerHTML = "city cannot be empty";
        validAddress = false;
    }

    if (state.trim() === "") {
        document.getElementById("stateError").innerHTML = "state cannot be empty";
        validAddress = false;
    }

    if (pincode.trim() === "") {
        document.getElementById("pincodeError").innerHTML = "pincode cannot be empty";
        validAddress = false;
    } else if (!/^[0-9]{6}$/.test(pincode)) {
        document.getElementById("pincodeError").innerHTML = "Enter a valid pincode";
        validAddress = false;
    }
    console.log(validAddress)
    return validAddress;
}

function deleteAddress(addressId) {
    if (confirm("Are you sure you want to delete")) {
        $.ajax({
            url: 'components/profile.cfc?method=deleteAddress',
            type: 'POST',
            data: {
                addessId: addressId
            },
            success: function(result) {
                console.log("successful Operation");
                document.getElementById(addressId).remove();
            },
            error: function() {
                console.error("failed")
            }
        });
    }
}

$(document).ready(function() {
    $("#addAddressBtn").click(function() {
        $("#selectAddressModal").modal("hide");
        setTimeout(function() {
            $("#addressAddModal").modal("show");
        }, 500);
    });
    $("#addressAddModal").on("hidden.bs.modal", function() {
        $("#selectAddressModal").modal("show");
    });
})

function redirectToOrder(productId) {

    let selectedAddress = document.querySelector('input[name="address"]:checked');
    let addressId = selectedAddress.value;
    window.location.href = `orderSummary.cfm?addressId=${addressId}&productId=${productId}&type=single`;
}

function redirectCartToorder() {
    let selectedAddress = document.querySelector('input[name="address"]:checked');
    let addressId = selectedAddress.value;
    console.log(addressId)
    window.location.href = `orderSummary.cfm?addressId=${addressId}&type=cart`;
}