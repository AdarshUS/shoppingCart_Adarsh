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

function filterPrices() {
   let priceRange = document.getElementById("filterPrice").value;
   console.log(priceRange);
}
