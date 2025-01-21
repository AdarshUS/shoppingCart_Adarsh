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
      <cfinclude template="header.cfm">
      <div class="categoriesContainer">
         <cfloop array="#categories.categoryId#" index="i" item="category">
            <div class="dropdown">
               <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#categories.categoryId[i]#">
                 #categories.categories[i]#
               </a>
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
                      <a class="productBox" href="productDetails.cfm?productId=#product.productId#">
                        <div class="productImage"><img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="productImage" class="prodimg"></div>
                        <div class="productName">#product.productName#</div>
                        <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                     </a>
               </cfif>
            </cfloop>
             </div>
         </cfloop>
      </main>
</body>
</html>
</cfoutput>