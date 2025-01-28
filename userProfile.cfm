<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/fontawesome.css">
   <link rel="stylesheet" href="./Style/homestyle.css">
</head>
<body>
    <cfinclude template = "header.cfm">
    <main>
        <div class="profileContainer">
            <div class="profileIcon">
                <img src="./Assets/Images/profile.png" alt="profileimg" width="30">
            </div>
            <div class="profileDetails">
                <div>hello,</div>
                <div class="profileName"></div>
                <div class="profileEmail"></div>
            </div>
        </div>
        <div class="addressContainer">
            <div>profile Informations</div>
            <div class="addressBox">
                <div class="addressItem">
                    <span class="firstName"></span>
                    <span class="lastName"></span>
                    <span class="phone"></span>
                    <div class="addressLine1"></div>
                    <div class="addressLine2"></div>
                    <div class="city"></div>
                    <div class="state"></div>
                    <div class="pincode"></div>
                </div>
                <button class="btn btn-primary">Add New Address</button>
                <button class="btn btn-info">order Details</button>
            </div>
        </div>
    </main>
</body>
</html>