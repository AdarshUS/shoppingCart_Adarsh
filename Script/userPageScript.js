function validateUserDetails()
{
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

   if(firstName.trim() === "")
   {
      document.getElementById("firstNameError").innerHTML = "Enter the FirstName";
      validDetails = false;
   }

   if(lastName.trim() === "")
   {
      document.getElementById("lastNameError").innerHTML = "Enter the LastName";
      validDetails = false;
   }

   if (userEmail.trim() === "" ||  !(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(userEmail)) )
    {
       document.getElementById("userEmailError").innerHTML = "Please enter a valid email address";
      validDetails = false;
    }

   if (userPhone.trim() === "" || !(userPhone.length==10))
    {
     document.getElementById("userPhoneError").innerHTML  = "Please enter a valid 10-digit phone number";
     validDetails = false;
    }

   if (userPassword.trim() === "" || userPassword.search(/[a-z]/i) < 0 || userPassword.search(/[0-9]/) < 0 || userPassword.length<6)
    {
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


function filterPrices(subcategoryId) 
{
    let priceRange = document.querySelector('input[name="filterPrice"]:checked');
    let priceRangeValue;
    document.getElementById("productContainer").innerHTML = "";

    if (priceRange != null) 
    {
        priceRangeValue = priceRange.value;
    }
    else 
    {
        let minvalue = document.getElementById("minimumPrice").value;
        let maxvalue = document.getElementById("maxPrice").value;
        priceRangeValue = minvalue+ " AND "+ maxvalue;
    }
    fetchProductsRemote("fetchProducts",{subcategoryId: subcategoryId, priceRange: priceRangeValue});
}

function fetchProductsRemote(methodName, parameters) {
    $.ajax({
        url: `components/ProductManagement.cfc?method=${methodName}`,
        type: 'POST',
        data: parameters,
        success: function (result) {
            let products = JSON.parse(result).DATA;
            if (products === undefined) {
                products = JSON.parse(result).data;
            }
            let productContainer = document.getElementById("productContainer");
            productContainer.innerHTML = "";

            products.forEach((item) => {
                let productBox = document.createElement("div");
                productBox.className = "productBox";

                let productImage = document.createElement("div");
                productImage.className = "productImage";
                let img = document.createElement("img");
                img.src = `./Assets/uploads/product${item.productId}/${item.imageFilePath}`;
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
            });
        },
        error: function () {
            console.error("Error fetching products");
        },
    });
}

function logoutUser()
{
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

function toggleProducts(subcategoryId,sort) {
    fetchProductsRemote("fetchProducts",{subcategoryId: subcategoryId,sort:sort});
    document.getElementById("viewMoreBtn").style.display = "none";
    document.getElementById("viewLessBtn").style.display = "flex";
}

function toggleLessProducts(subcategoryId)
{
    fetchProductsRemote("getRandomProducts",{subcategoryId: subcategoryId});
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
        data: { cartId: cartId, step: step },
        success: function (result) {
            console.log("updated")
        },
        error: function () {
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
        data: { cartId: cartId, step: step },
        success: function (result) {
            console.log("successful Operation")
        },
        error: function () {
            console.error("failed")
        }
    });
    document.getElementById("totalPrice" + cartId).innerHTML =
        document.getElementById("qntyNo" + cartId).value *
        document.getElementById("productPrice" + cartId).innerHTML;
    checkQnty();
    calculateTotalPrice();
}

$( document ).ready(function() {
    checkQnty();
    calculateTotalPrice();
});

function checkQnty()
{
    let qnty = $(".qntyNo");
    for (let index = 0; index < qnty.length; index++) {
        console.log(qnty[index].value)
        if(qnty[index].value ==1)
    {
        qnty[index].previousElementSibling.disabled = true;
    }
    else
    {
        qnty[index].previousElementSibling.disabled = false;
    }
    }
}

function deleteCartItem(cartId)
{
    if(confirm("Are you sure you want to delete")) 
    {
        $.ajax({
            url: 'components/cart.cfc?method=deleteCart',
            type: 'POST',
            data: { cartId: cartId},
            success: function (result) {
                console.log("successful Operation");
                document.getElementById(cartId).remove();
                calculateTotalPrice();
            },
            error: function () {
                console.error("failed")
            }
        });
    }
}

function visiblePassword()
{   
    let x = document.getElementById("userPassword");
  if (x.type === "password")
   {
    x.type = "text";
  } else {
    x.type = "password";
  }
}

function hidePassword()
{
     let x = document.getElementById("userPassword");
     if (x.type === "password")
   {
    x.type = "text";
  } else {
    x.type = "password";
  }
}

function calculateTotalPrice()
{
    let productprices = document.getElementsByClassName("totalPrice"); 
    let actualprices = document.getElementsByClassName("actualPriceCart");
    console.log(actualprices);
    let taxes = document.getElementsByClassName("productTax");
    let totalPrice = 0;
    let totalActual = 0;
    let totalTax = 0;
    for (let index = 0; index < productprices.length; index++) {
        console.log(actualprices[index].innerHTML)
        totalPrice += parseFloat(productprices[index].innerHTML);
        totalActual += parseFloat(actualprices[index].innerHTML);
        totalTax+=parseFloat(taxes[index].innerHTML);
    }

    document.getElementById("totalActualprice").innerHTML = totalActual;
    document.getElementById("totalTax").innerHTML = totalTax;
    document.getElementById("subtotal").innerHTML = totalPrice;
}





