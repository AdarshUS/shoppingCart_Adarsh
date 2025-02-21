<cfoutput>
<cfparam name="url.sort" default="">
<cfparam name="url.subcategoryId" default="">
<cfparam name="startIndex" default="0">
<cfparam name="searchText" default="">
<cfset variables.categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfif structKeyExists(url,"searchText")>
    <cfset variables.message = "Search Results for ""#url.searchText#""">
    <cfset searchText = url.searchText>
    <cfset variables.productDetails = application.objProductManagement.fetchProducts(
        searchText = url.searchText,
        startIndex = startIndex,
        limit = 4,
        sort = url.sort
    )>
<cfelse>
    <cfset variables.productDetails = application.objProductManagement.fetchProducts(
        subCategoryId = url.subCategoryId,
        limit = 4,
        sort = url.sort
    )>
</cfif>
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
        <cfinclude template="navbar.cfm">
        <main>
            <cfif arrayIsEmpty(variables.productDetails.products)>
                <h4 class="subcategoryname">No Items Found</h4>
            <cfelse>
                <cfif structKeyExists(url,"searchText")>
                    <div class="searchResultText ">#variables.message#</div>
                <cfelse>
                    <h4 class="subcategoryname" id="subcategoryText">#variables.productDetails.products[1].subcategoryName#</h4>
                </cfif>
                <div class="priceFilterContainer">
                <div class="priceSort" id="priceSort">
                    <cfif structKeyExists(url,subcategoryId) AND url.subcategoryId NEQ "">
                        <a href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(url.subcategoryId)#&sort=ASC">price: Low to High</a>
                        <a href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(url.subcategoryId)#&sort=DESC">price :High to Low</a>
                    <cfelse>
                        <a href="subCategoryList.cfm?sort=ASC&searchText=#searchText#">price: Low to High</a>
                        <a href="subCategoryList.cfm?sort=DESC&searchText=#searchText#">price :High to Low</a>
                    </cfif>
                </div>
                <div class="dropdown">
                    <button class="btn btn-dark dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        Filter by Price
                    </button>
                    <div class="dropdown-menu" aria-labelledby="filterDropdown">
                        <h6 class="dropdown-header">Select Price Range</h6>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price1" data-start="0" data-end="1000">
                            <label class="form-check-label" for="price1">0 to 1,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price2" data-start="1000" data-end="10000">
                            <label class="form-check-label" for="price2">1,000 to 10,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price3" data-start="10000" data-end="15000">
                            <label class="form-check-label" for="price3">10,000 to 15,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="price4" data-start="15000" data-end="25000">
                            <label class="form-check-label" for="price4">15,000 to 25,000</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="filterPrice" id="customFilterInput" value="custom">
                            <label class="form-check-label" for="custom">Custom</label>
                        </div>
                        <div class="d-flex gap-2">
                            <input type="number" class="form-control" id="minimumPrice" placeholder="Min" disabled>
                            <span class="align-self-center">-</span>
                            <input type="number" class="form-control" id="maxPrice" placeholder="Max" disabled>
                        </div>
                        <button class="btn btn-dark mt-3 filter-btn" onclick="filterPrices('#url.subcategoryId#','#searchText#')">Apply Filter</button>
                    </div>
                </div>
            </div>
                <div class="productContainer" id="productContainer">
                    <cfloop array = "#variables.productDetails.products#" item = product>
                        <a 
                            class="productBox" 
                            id="productBox" 
                            href="productDetails.cfm?productId=#URLEncodedFormat(product.productId)#"
                        >
                            <div class="productImage">
                                <img 
                                    src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" 
                                    alt="productImage" 
                                    class="prodimg" 
                                    id="prodimg"
                                >
                            </div>
                            <div class="productName" id="productName">#product.productName#</div>
                            <div class="productPrice" id="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                        </a>
                    </cfloop>
                </div>
            <div 
                class="viewMoreBtn" 
                id="viewMoreBtn"
            >
                <button 
                    onclick="loadMoreProducts('#url.subcategoryId#','#url.sort#','#searchText#')" 
                    class="btn btn-primary">view More
                </button>
            </div>
            </cfif>
        </main>
        <script src="./Script/jquery-3.7.1.min.js"></script>
        <script src="./Script/userPageScript.js"></script>
    </body>
</html>
</cfoutput>