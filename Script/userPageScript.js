let startindex = 0;
function filterPrices(subcategoryId,searchText) {
    let priceRange = document.querySelector('input[name="filterPrice"]:checked');
    let minPrice;
    let maxPrice;
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
        if(parseInt(minPrice) < 0 || parseInt(maxPrice) < 0)
        {
            alert("enter positive range");
            return;
        }
    }
    else
    {
        minPrice = priceRange.dataset.start;
        maxPrice = priceRange.dataset.end;

        document.getElementById("productContainer").innerHTML = "";
        document.getElementById("viewMoreBtn").style.display = "none";
        document.getElementById("priceSort").innerHTML = "";
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

let searchElement = document.getElementById("searchForm");
if(searchElement)
{
    document.getElementById("searchForm").addEventListener("submit", function(event) {
    window.location.href = "subCategorylist.cfm?searchText=" + document.getElementById("searchInput").value;
    event.preventDefault();
    });
}

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
        if(products.length < 4)
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

function loadMoreProducts(subcategoryId,sort,searchText) 
{
    startindex+=4;
    if(searchText)
    {
        fetchProductsRemote("fetchProducts", {
            startindex: startindex,
            searchText: searchText,
             sort: sort,
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
            data: {productId : productId},
            success: function(response) {
                let result = JSON.parse(response);
                if(result.message === "product added")
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

    function updateQuantity(cartId, step) {
        document.getElementById("decreaseQntyBtn").disabled = false;
        let qnty = parseInt(document.getElementById("qntyNo" + cartId).value);
        qnty+=step;
        document.getElementById("qntyNo" + cartId).value = qnty;

        $.ajax({
            url: 'components/cart.cfc?method=updateCartQnty',
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
            (document.getElementById("qntyNo" + cartId).value *
            document.getElementById("productPrice" + cartId).innerHTML).toFixed(2);
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
    let itemCountElement = document.getElementById("itemcount");
    if (itemCountElement) {
        let cartItemCount = parseInt(itemCountElement.innerHTML, 10) || 0;
        if (cartItemCount <= 0) {
            itemCountElement.style.display = "none";
        }
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

function placeOrder(productId) {
    let selectedAddress = document.querySelector('input[name="address"]:checked');
    let addressId = selectedAddress.value;
    if(productId)
    {
        handleCartAction(productId);
        window.location.href = `orderSummary.cfm?addressId=${addressId}&productId=${encodeURIComponent(productId)}&type=single`;
    }
    else
    {
        window.location.href = `orderSummary.cfm?addressId=${addressId}&type=cart`;
    }
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

$(document).on("click", function() {
    $(".userLoginError").hide();
});
