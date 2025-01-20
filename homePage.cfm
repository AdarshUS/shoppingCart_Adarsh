<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfset randomProducts = application.objProductManagement.getRandomProducts() >
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
               <button class="btn btn-secondary dropdown-toggle category border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                 #categories.categories[i]#
               </button>
               <cfset subCategories = application.objProductManagement.fetchSubCategories(categories.categoryId[i])>               
               <ul class="dropdown-menu">
                  <cfloop array = #subCategories.subCategoryNames# index = i item = subcategory>
                     <li><a class="dropdown-item" href="">#subCategories.subCategoryNames[i]#</a></li>
                  </cfloop>
               </ul>
            </div>
         </cfloop>
      </div>
      <div class="bannerContainer">
         <img src="./Assets/Images/cartnewbanner4.jpg" alt="cartbanner" class="bannerImage">
      </div>
      <h5>Random Products</h5>
      <div class="randomProducts d-flex flex-wrap">
         <cfloop array = "#randomProducts.data#" item = product>
            <div class="productBox">
               <div class="productImage">
                  <img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="productImage" width=220 height=220>
               </div>
               <div class="productName">#product.brandName#</div>               
            </div>
         </cfloop>
      </div>
    </div>
   </body>
   <script src="./Script/bootstrapScript.js"></script>
</html>
</cfoutput>
