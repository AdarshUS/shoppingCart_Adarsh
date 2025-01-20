<cfoutput>
<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfset subCategories = application.objProductManagement.fetchSubCategories(#url.categoryId#)>
<cfset products = application.objProductManagement.fetchProducts()>
<!Doctype html>
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
               <cfset subCategoriesList = application.objProductManagement.fetchSubCategories(categories.categoryId[i])>
               <ul class="dropdown-menu">
                  <cfloop array = #subCategoriesList.subCategoryNames# index = i item = subcategory>
                     <li><a class="dropdown-item" href="">#subCategoriesList.subCategoryNames[i]#</a></li>
                  </cfloop>
               </ul>
            </div>
         </cfloop>
      </div>
      <main>
         <cfloop array = "#subCategories.subcategoryIds#" item="subCategoryId" index = i>
            <a class="subcategoryName p-3" href="subCategoryList.cfm?subcategoryId=#subCategories.subcategoryIds[i]#">#subCategories.subcategoryNames[i]#</a>
            <div class="productContainer d-flex gap-3 p-3">
            <cfloop array = "#products.data#" item = "product">
               <cfif subCategoryId EQ product.subCategoryId>
                      <div class="productBox">
                        <div class="productImage"><img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="productImage" class="prodimg"></div>
                        <div class="productName">#product.productName#</div>
                        <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                     </div>
               </cfif>
            </cfloop>
             </div>
         </cfloop>
      </main>
</body>
</html>
</cfoutput>