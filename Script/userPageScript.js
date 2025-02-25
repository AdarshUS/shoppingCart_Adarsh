let startindex = 0;
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


function filterPrices(subcategoryId,searchText) {
    let priceRange = document.querySelector('input[name="filterPrice"]:checked');
    let minPrice;
    let maxPrice;
    document.getElementById("productContainer").innerHTML = "";
    document.getElementById("viewMoreBtn").style.display = "none";
    document.getElementById("priceSort").innerHTML = "";
    if(priceRange.value === "custom")
    {
        minPrice = document.getElementById("minimumPrice").value;
        maxPrice = document.getElementById("maxPrice").value;
        if(minPrice.trim() === "" || maxPrice.trim() === "")
        {
            alert("Please enter the price range");
            return;
        }
        if(parseInt(minPrice) > parseInt(maxPrice))
        {
            alert("Minimum price should be less than Maximum price");
            return;
        }
    }
    else
    {
        minPrice = priceRange.dataset.start;
        maxPrice = priceRange.dataset.end;
    }
    if(searchText)
    {
        fetchProductsRemote("fetchProducts", {
            searchText: searchText,
            startPrice: minPrice,
            endPrice: maxPrice
        });
    }
    else
    {
    fetchProductsRemote("fetchProducts", {
        subcategoryId: subcategoryId,
        startPrice: minPrice,
        endPrice: maxPrice
    });
    }
}

document.getElementById("searchForm").addEventListener("submit", function(event) {
    window.location.href = "subCategorylist.cfm?searchText=" + document.getElementById("searchInput").value;
    event.preventDefault();
    });


async function fetchProductsRemote(methodName, parameters) {
    try {
        const result = await $.ajax({
            url: `components/ProductManagement.cfc?method=${methodName}`,
            type: 'POST',
            data: parameters,
        });
        const parsedResult = JSON.parse(result);
        const products = parsedResult.products;
        const productContainer = document.getElementById("productContainer");
        if(products.length === 0)
        {
            document.getElementById("viewMoreBtn").style.display = "none";
        }
        if(!parameters.startindex)
        {
            productContainer.innerHTML = "";
        }
        
        for (const item of products) {
            try {
                const decryptResult = await $.ajax({
                    url: 'components/User.cfc?method=decryptId',
                    type: 'POST',
                    data: {
                        encryptedId: item.productId,
                    },
                });
                const decryptedId = decryptResult.trim();
                const productBox = document.createElement("a");
                productBox.className = "productBox";
                productBox.href = `./productDetails.cfm?productId=${item.productId}`;

                const productImage = document.createElement("div");
                productImage.className = "productImage";
                const img = document.createElement("img");
                img.src = `./Assets/uploads/product${decryptedId}/${item.imageFilePath}`;
                img.alt = "productImage";
                img.className = "prodimg";
                productImage.appendChild(img);

                const productName = document.createElement("div");
                productName.className = "productName";
                productName.textContent = item.productName;

                const productPrice = document.createElement("div");
                productPrice.className = "productPrice";
                productPrice.innerHTML = `<i class="fa-solid fa-indian-rupee-sign"></i> ${item.unitPrice}`;

                productBox.appendChild(productImage);
                productBox.appendChild(productName);
                productBox.appendChild(productPrice);

                productContainer.appendChild(productBox);
            } catch (decryptError) {
                alert("Error decrypting product ID");
            }
        }
    } catch (fetchError) {
        console.error(fetchError);
    }
}

async function loadMoreProducts(subcategoryId,sort,searchText) 
{
    startindex+=4;
    if(searchText)
    {
        fetchProductsRemote("fetchProducts", {
            startindex: startindex,
            searchText: searchText,
            limit: 4
        });
    }
    else
    {
        fetchProductsRemote("fetchProducts", {
        subcategoryId: subcategoryId,
        sort: sort,
        limit: 4,
        startindex: startindex
        });
    }
}

function logoutUser() {

    Swal.fire({
        title: "Are you sure you want to logout?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "logout"
    }).then((result) => {
  if (result.isConfirmed) {
    
        $.ajax({
            url: 'components/User.cfc?method=logoutUser',
            type: 'POST',
            success: function(result) {
                location.reload();
            },
            error: function() {
                alert("Error in LogOut");
            }
        });
  }
})
}

 function handleCartAction(productId) {
        $.ajax({
            url: 'components/cart.cfc?method=addTocart',
            type: 'POST',
            data: {productId : productId,quantity:1},
            success: function(response) {
                let result = JSON.parse(response);
                if(result.message === "quantity Added")
                {
                    if(document.getElementById("itemcount").innerHTML == 0)
                    {
                        document.getElementById("itemcount").style.display="flex";
                        document.getElementById("itemcount").innerHTML = 1;
                    }
                    else
                    {
                        document.getElementById("itemcount").innerHTML = parseInt( document.getElementById("itemcount").innerHTML) +1;
                    }
                }
                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: "Added to cart",
                    showConfirmButton: false,
                    timer: 1500,
                    toast: true
                });
            },
            error: function() {
                alert("Error in addTocart");
            }
        });
        let cartButton = document.getElementById("cartButton");
        cartButton.textContent = "Go to Cart";
        cartButton.onclick = function () {
            window.location.href = "cart.cfm";
        };
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
            },
            error: function() {
                alert("failed to Update")
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
        },
        error: function() {
            alert("failed")
        }
    });
    document.getElementById("totalPrice" + cartId).innerHTML =
        document.getElementById("qntyNo" + cartId).value *
        document.getElementById("productPrice" + cartId).innerHTML;
    checkQnty();
    calculateTotalPrice();
}

function checkQnty() {
    let qnty = $(".qntyNo");
    for (let index = 0; index < qnty.length; index++) {
        if (qnty[index].value == 1) {
            qnty[index].previousElementSibling.disabled = true;
        } else {
            qnty[index].previousElementSibling.disabled = false;
        }
    }
}

$(document).ready(function() {

    if( $(".qntyNo").length >0)
    {
        checkQnty();
        calculateTotalPrice();
    }
    let cartItemCount = Number(document.getElementById("itemcount").innerHTML);
    if(cartItemCount<=0)
    {
        document.getElementById("itemcount").style.display="none";
    }
});

function deleteCartItem(cartId) {
    Swal.fire({
        title: "Are you sure you want to remove from cart?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "remove"
    }).then((result) => {
  if (result.isConfirmed) {
        $.ajax({
            url: 'components/cart.cfc?method=deleteCart',
            type: 'POST',
            data: {
                cartId: cartId
            },
            success: function(response) {
                document.getElementById(cartId).remove();
                document.getElementById("itemcount").innerHTML = parseInt( document.getElementById("itemcount").innerHTML) - 1;
                let remainingCount = JSON.parse(response);
                if(remainingCount === 0)
                {
                    location.reload();
                }
                calculateTotalPrice();
            },
            error: function() {
                alert("failed")
            }
        });
    }
    });
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
    let productPrices = document.getElementsByClassName("totalPrice");
    let actualPrices = document.getElementsByClassName("actualPriceCart");
    let quantities = document.getElementsByClassName("qntyNo");
    let taxes = document.getElementsByClassName("productTax");

    let totalPrice = 0;
    let totalActual = 0;
    let totalTax = 0;

    for (let index = 0; index < productPrices.length; index++) {
        let actualPrice = parseFloat(actualPrices[index].innerHTML);
        let quantity = parseInt(quantities[index].value);
        let taxPercentage = parseFloat(taxes[index].innerHTML);

        let actualTotal = actualPrice * quantity;
        let taxAmount = (taxPercentage / 100) * actualTotal;
        let totalItemPrice = actualTotal + taxAmount;

        totalActual += actualTotal;
        totalTax += taxAmount;
        totalPrice += totalItemPrice;
    }

    document.getElementById("totalActualprice").innerHTML = totalActual.toFixed(2);
    document.getElementById("totalTax").innerHTML = totalTax.toFixed(2);
    document.getElementById("subtotal").innerHTML = totalPrice.toFixed(2);
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
    return validAddress;
}

function resetAddresseror()
{
    document.getElementById("firstNameError").innerHTML = "";
    document.getElementById("phoneError").innerHTML = "";
    document.getElementById("address1Error").innerHTML = "";
    document.getElementById("cityError").innerHTML = "";
    document.getElementById("stateError").innerHTML = "";
    document.getElementById("pincodeError").innerHTML = "";
}

function deleteAddress(addressId) {
    Swal.fire({
  title: "Are you sure you want to delete?",
  icon: "warning",
  showCancelButton: true,
  confirmButtonColor: "#3085d6",
  cancelButtonColor: "#d33",
  confirmButtonText: "delete"
}).then((result) => {
  if (result.isConfirmed) {
    $.ajax({
            url: 'components/User.cfc?method=deleteAddress',
            type: 'POST',
            data: {
                addessId: addressId
            },
            success: function(result) {
                document.getElementById(addressId).remove();
            },
            error: function() {
                alert("failed")
            }
        });
    Swal.fire({
      title: "Deleted!",
      text: "Your file has been deleted.",
      icon: "success"
    });
  }
});
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
    handleCartAction(productId);
    window.location.href = `orderSummary.cfm?addressId=${addressId}&productId=${encodeURIComponent(productId)}&type=single`;
}

function redirectCartToorder() {
    let selectedAddress = document.querySelector('input[name="address"]:checked');
    let addressId = selectedAddress.value;
    window.location.href = `orderSummary.cfm?addressId=${addressId}&type=cart`;
}

var input = document.getElementById('customFilterInput');
if(input)
{
    input.addEventListener('input', () => {
    if (input.checked) {
        document.getElementById("minimumPrice").disabled = false;
        document.getElementById("maxPrice").disabled = false;
    }
});
}

function validateProfile()
{
    let isValid = true;
    const firstName = document.getElementById("userFirstName").value;
    const lastName = document.getElementById("userLastName").value;
    const email = document.getElementById("userEmail").value;
    const phone = document.getElementById("userPhone").value;
    let namePattern = /^[a-zA-Z\s-]+$/;
    let emailPattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
    let firstNameError = document.getElementById("userFirstNameError");
    let lastNameError = document.getElementById("userLastNameError");
    let emailError = document.getElementById("userEmailError");
    let phoneError = document.getElementById("userPhoneError");

    firstNameError.innerHTML = "";
    lastNameError.innerHTML = "";
    emailError.innerHTML = "";
    phoneError.innerHTML = "";

    if(firstName.trim() === "")
    {
        firstNameError.innerHTML = "firstName cannot be empty";
        isValid = false;
    }
    else if(!namePattern.test(firstName))
    {
        firstNameError.innerHTML = "Invalid firstName";
        isValid = false;
    }

    if(lastName.trim() === "")
    {
        lastNameError.innerHTML = "lastName cannot be empty";
        isValid = false;
    }
    else if(!namePattern.test(lastName))
    {
        firstNameError.innerHTML = "Invalid lastName";
        isValid = false;
    }

    if(email.trim() === "")
    {
        emailError.innerHTML = "email cannot be empty";
        isValid = false;
    }
    else if(!emailPattern.test(email))
    {
        emailError.innerHTML = "Invalid Email";
        isValid = false;
    }

    if(phone.trim() === "")
    {
        phoneError.innerHTML = "Phone cannot be empty";
        isValid = false;
    }
    else if(phone.length != 10)
    {
        phoneError.innerHTML = "Invalid Phone";
        isValid = false;
    }
    return isValid;
}

function clearProfilErrorMsg()
{
    let firstNameError = document.getElementById("userFirstNameError");
    let lastNameError = document.getElementById("userLastNameError");
    let emailError = document.getElementById("userEmailError");
    let phoneError = document.getElementById("userPhoneError");

    firstNameError.innerHTML = "";
    lastNameError.innerHTML = "";
    emailError.innerHTML = "";
    phoneError.innerHTML = "";
    location.reload();
}
