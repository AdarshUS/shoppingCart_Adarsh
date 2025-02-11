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
                <div class="dropdown">
                    <button class="btn btn-dark dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        Filter by Price
                    </button>
                    <div class="dropdown-menu" aria-labelledby="filterDropdown">
                        <h6 class="dropdown-header">Select Price Range</h6>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price1" value="0 AND 1000">
                            <label class="form-check-label" for="price1">0 to 1,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price2" value="1000 AND 10000">
                            <label class="form-check-label" for="price2">1,000 to 10,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price3" value="10000 AND 15000">
                            <label class="form-check-label" for="price3">10,000 to 15,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price4" value="15000 AND 25000">
                            <label class="form-check-label" for="price4">15,000 to 25,000</label>
                        </div>
                        <h6 class="mt-3">Custom Price</h6>
                        <div class="d-flex gap-2">
                            <input type="number" class="form-control" id="minimumPrice" placeholder="Min">
                            <span class="align-self-center">-</span>
                            <input type="number" class="form-control" id="maxPrice" placeholder="Max">
                        </div>
                        <button class="btn btn-dark mt-3 filter-btn" onclick="filterPrices('#url.subcategoryId#')">Apply Filter</button>
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