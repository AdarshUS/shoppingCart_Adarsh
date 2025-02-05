<cfoutput>
<cfparam name="url.sort" default="ASC">
<cfset categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfset productDetails = application.objProductManagement.fetchProducts(subCategoryId = url.subCategoryId,limit = 4,sort = url.sort)>
<!Doctype html>
<html>
   <head>
      <title>MyCart</title>
      <link rel="stylesheet" href="./Style/bootstrap.css">
      <link rel="stylesheet" href="./Style/fontawesome.css">
      <link rel="stylesheet" href="Style/homestyle.css">
   </head>
   <body>
      <cfinclude template = "header.cfm">
      <div class="categoriesContainer">
         <cfloop array="#categoriesResult.categories#" item="category">
            <div class="dropdown">
               <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#URLEncodedFormat(category.categoryId)#">
                 #category.categoryName#
               </a>
               <cfset subCategoriesResult = application.objProductManagement.fetchSubCategories(category.categoryId)>
               <ul class="dropdown-menu">
                  <cfloop array = #subCategoriesResult.subcategory# item = subcategory>
                     <li><a class="dropdown-item" href="subCategoryList.cfm?subcategoryId=#subcategory.subCategoryId#">#subcategory.subCategoryName#</a></li>
                  </cfloop>
               </ul>
            </div>
         </cfloop>
      </div>
      <main>
         <cfif arrayIsEmpty(productDetails.products)>
            <h4 class="subcategoryname">No Items Found</h4>
         <cfelse>
            <h4 class="subcategoryname">#productDetails.products[1].subcategoryName#</h4>
             <div class="priceFilterContainer">
            <div class="priceSort">
               <a href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(url.subcategoryId)#&sort=ASC">price: Low to High</a>
               <a href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(url.subcategoryId)#&sort=DESC">price :High to Low</a>
            </div>
            <div class="filterBox">
               <div class="dropdown">
                  <button class="btn btn-secondary dropdown-toggle filterBtn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                     Filter<i class="fa-solid fa-filter"></i>
                  </button>
                  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                    <li><input type="radio" name="filterPrice" id="filterPrice1"  class="dropdown-item" value="0 AND 1000"><span>0 to 1000</span></li>
                    <li><input type="radio" name="filterPrice" id="filterPrice2"  class="dropdown-item" value="1000 AND 10000"><span>1000 to 10,000</span></li>
                    <li><input type="radio" name="filterPrice" id="filterPrice3"  class="dropdown-item" value = "10000 AND 15000"><span>10,000 to 15,000</span></li>
                    <li><input type="radio" name="filterPrice" id="filterPrice4"  class="dropdown-item" value = "15000 AND 25000"><span>15,000 to 25,000</span></li>
                    <label for="minimumPrice"></label><input type="number" id="minimumPrice">
                    <label for="maxPrice"></label><input type="number" id="maxPrice">
                    <button class="btn btn-secondary" onclick="filterPrices('#url.subcategoryId#')">Submit</button>
                  </ul>
               </div>
            </div>
         </div>
         </cfif>
         <div class="viewMoreBtn" id="viewMoreBtn"><span onclick="toggleProducts('#url.subcategoryId#','#url.sort#')">view All<i class="fa-solid fa-caret-down"></i></span></div>
         <div class="productContainer" id="productContainer">
            <cfloop array = "#productDetails.products#" item = product>
                  <a class="productBox" id="productBox" href="productDetails.cfm?productId=#URLEncodedFormat(product.productId)#">
                     <div class="productImage"><img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" alt="productImage" class="prodimg" id="prodimg"></div>
                     <div class="productName" id="productName">#product.productName#</div>
                     <div class="productPrice" id="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                  </a>
            </cfloop>
         </div>
         <div class="viewMoreBtn" id="viewLessBtn"><span onclick="toggleLessProducts('#url.subcategoryId#','#url.sort#')">see Less<i class="fa-solid fa-caret-down"></i></span></div>
      </main>
      <script src="./Script/jquery-3.7.1.min.js"></script>
      <script src="./Script/userPageScript.js"></script>
   </body>
</html>
</cfoutput>