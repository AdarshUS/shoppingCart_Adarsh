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
      <div class="bannerContainer">
         <img src="./Assets/Images/cartnewbanner4.jpg" alt="cartbanner" class="bannerImage">
      </div>
      <h5 class="productText">Random Products</h5>
      <div class="randomProducts d-flex flex-wrap">
         <cfloop array = "#randomProducts.data#" item = product>
               <div class="productBox">
                  <div class="productImage">
                     <img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="productImage"  class="prodimg">
                  </div>
                  <div class="productName">#product.productName#</div>
                  <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
               </div>
         </cfloop>
      </div>
    </div>
   </body>
   <script src="./Script/bootstrapScript.js"></script>
</html>
</cfoutput>
