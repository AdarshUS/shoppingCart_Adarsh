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
      document.getElementById("firstNameError").innerHTML = "Enter the LastName";
      validDetails = false;
   }

   if (userEmail.trim() === "" ||  !(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email)) )
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

function filterPrices(subcategoryId) {
    let priceRange = document.querySelector('input[name="filterPrice"]:checked');
    let priceRangeValue;
    document.getElementById("productContainer").innerHTML = ""; 
    
    if (priceRange != null) {
        priceRangeValue = priceRange.value;
        console.log(priceRangeValue);
    } else {
        let minvalue = document.getElementById("minimumPrice").value;
        let maxvalue = document.getElementById("maxPrice").value;
        priceRangeValue = minvalue+ " AND "+ maxvalue;
    }

    $.ajax({
        url: 'components/ProductManagement.cfc?method=fetchProducts',
        type: 'POST',
        data: { subcategoryId: subcategoryId, priceRange: priceRangeValue},
        success: function (result) {
            let products = JSON.parse(result).data;
            console.log(products);

            
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

               
                document.getElementById("productContainer").appendChild(productBox);
            });
        },
        error: function () {
            console.error("Error fetching products");
        },
    });
}

