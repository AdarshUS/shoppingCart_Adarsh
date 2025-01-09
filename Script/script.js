function validate()
{
   let validInput = true;
   let username = document.getElementById("userName").value;
   let passsword =  document.getElementById("password").value;

   let usernameError = document.getElementById("userNameError");
   let passswordError =  document.getElementById("passwordError");

   usernameError.textContent = "";
   passswordError.textContent = "";

   if(username.trim() === "")
   {
      usernameError.textContent = "userName cannot be empty";
      validInput = false;
   }

    if(passsword.trim() === "")
   {
      passswordError.textContent = "password cannot be empty";
      validInput = false;
   }

   return validInput;
}

$(".logout").click(function() {
        if (confirm("Are you sure you want to Logout")) {
            $.ajax({
                url: 'components/shoppingCart.cfc?method=logoutAdmin',
                type: 'POST',
                success: function(result) {
                  location.reload();
                },
                error: function() {
                    
                }
            });
        }
});