<cfset variables.randomProducts = application.objProductManagement.fetchProducts(random = true,limit = 4)>
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
        <div class="SliderContainer">
            <div id="carouselExampleControlsNoTouching" class="carousel slide" data-bs-touch="false" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="./Assets/Images/sliderimage4.png" class="d-block w-100" alt="...">
                    </div>
                    <div class="carousel-item">
                        <img src="./Assets/Images/sliderimage1.png" class="d-block w-100" alt="...">
                    </div>
                    <div class="carousel-item">
                        <img src="./Assets/Images/sliderimage2.png" class="d-block w-100" alt="...">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControlsNoTouching" data-bs-slide="prev">
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControlsNoTouching" data-bs-slide="next">
                </button>
            </div>
        </div>
        <h5 class="productText">Popular Products</h5>
        <div class="randomProducts d-flex flex-wrap">
            <cfloop array = "#variables.randomProducts.products#" item = product>
                <a class="productBox" href="productDetails.cfm?productId=#URLEncodedFormat(product.productId)#">
                    <div class="productImage">
                        <img 
                            src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" 
                            alt="productImage" 
                            class="prodimg"
                        >
                    </div>
                    <div class="productName">#product.productName#</div>
                    <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                </a>
            </cfloop>
        </div>
        <cfinclude template="footer.cfm">
    </body>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/bootstrapScript.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="./Script/userPageScript.js"></script>
</html>
</cfoutput>
