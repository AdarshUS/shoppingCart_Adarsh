<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfset productDetails = application.objProductManagement.fetchSingleProduct(productId = url.productId,allImagesNeeded = true)>
<cfdump var="#productDetails#">
<!DOCTYPE html>
<cfoutput>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Document</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/fontawesome.css">
   <link rel="stylesheet" href="./Style/productDetails.css">
</head>
<body>
   <header>
      <div class="header_logo">
         <img src="./Assets/Images/cart1.jpeg" alt="logo" width="60">
         <span class="header_logoText">My Cart</span>
      </div>
      <div class="header_searchBar">
         <i class="fa-solid fa-magnifying-glass"></i>
         <input type="text" placeholder="Search for Products, Brands and More">
      </div>
      <div class="header_menu">
         <i class="fa-solid fa-right-from-bracket"></i>  
         <div class="header_menutext">LogOut</div>
      </div>
   </header>
   <div class="categoriesContainer">
      <cfloop array="#categories.categoryId#" index="i" item="category">
         <div class="dropdown">
            <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#categories.categoryId[i]#">
              #categories.categories[i]#
            </a>
            <cfset subCategories = application.objProductManagement.fetchSubCategories(categories.categoryId[i])>
            <ul class="dropdown-menu">
               <cfloop array = #subCategories.subCategoryNames# index = i item = subcategory>
                  <li><a class="dropdown-item" href="">#subCategories.subCategoryNames[i]#</a></li>
               </cfloop>
            </ul>
         </div>
      </cfloop>
   </div>
   <div class="productContainer">
      <div class="productImageBox">
         <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
         <div class="carousel-inner">
           <cfloop array="#productDetails.data.images#" item = image>
               <cfif image EQ productDetails.data.defaultImagePath>
                  <div class="carousel-item active">
                     <img src="./Assets/uploads/product#productDetails.data.productId#/#image#">
                  </div>
               <cfelse>
                  <div class="carousel-item">
                     <img src="./Assets/uploads/product#productDetails.data.productId#/#image#">
                  </div>
               </cfif>
            </cfloop>
         </div>
         <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="prev">
           <span class="carousel-control-prev-icon bg-secondary" aria-hidden="true"></span>
           <span class="visually-hidden">Previous</span>
         </button>
         <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="next">
           <span class="carousel-control-next-icon bg-secondary" aria-hidden="true"></span>
           <span class="visually-hidden">Next</span>
         </button>
      </div>
      </div>
      <div class="productDetail">
         <div class="pathtext">
            <a href="subCategoryList.cfm?subcategoryId=#productDetails.data.subcategoryId#">#productDetails.data.subcategoryName#</a><i class="fa-solid fa-angle-right"></i>
            <a href="./categoryList.cfm?categoryId=#productDetails.data.categoryId#">#productDetails.data.categoryName#</a><i class="fa-solid fa-angle-right"></i>
            <a href="">#productDetails.data.productName#</a>
         </div>
      </div>
   </div>
   <script src="./Script/bootstrapScript.js"></script>
</body>
</html>
</cfoutput>