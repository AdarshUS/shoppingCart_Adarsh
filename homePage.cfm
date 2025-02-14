<cfset variables.randomProducts = application.objProductManagement.fetchProducts(random = true)>
<!Doctype html>
<cfoutput>
<html>
    <head>
       <title>MyCart</title>
       <link rel="stylesheet" href="./Style/bootstrap.css">
       <link rel="stylesheet" href="./Style/fontawesome.css">
       <link rel="stylesheet" href="Style/homestyle.css">
    </head>
    <body>
        <cfinclude template="header.cfm">
        <cfinclude template="navbar.cfm">
        <div class="bannerContainer">
           <img src="./Assets/Images/9167.jpg" alt="cartbanner" class="bannerImage">
        </div>
        <h5 class="productText">Products</h5>
        <div class="randomProducts d-flex flex-wrap">
            <cfloop array = "#variables.randomProducts.products#" item = product>
                <a class="productBox" href="productDetails.cfm?productId=#URLEncodedFormat(product.productId)#">
                    <div class="productImage">
                        <img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" alt="productImage"  class="prodimg">
                    </div>
                    <div class="productName">#product.productName#</div>
                    <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                </a>
            </cfloop>
        </div>
    </body>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/bootstrapScript.js"></script>
    <script src="./Script/userPageScript.js"></script>
</html>
</cfoutput>
