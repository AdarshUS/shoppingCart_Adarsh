<cfoutput>
<cfset variables.categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfset variables.subCategoriesResult = application.objProductManagement.fetchSubCategories(url.categoryId)>
<cfset variables.randProducts = application.objProductManagement.fetchProducts(random = true)>
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
        <cfinclude template="navbar.cfm" >
        <main>
            <cfloop array = "#variables.subCategoriesResult.subcategory#" item="subCategory">
                <a 
                    class="subcategoryName p-3" 
                    href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(subCategory.subcategoryId)#">#subCategory.subcategoryName#
                </a>
                <div class="productContainer d-flex gap-3 p-3">
                <cfset variables.productCount = 0>
                    <cfloop array = "#variables.randProducts.products#" item = "product">
                        <cfif subCategory.subcategoryId EQ product.subcategoryId AND variables.productCount LT 4>
                            <a class="productBox" href="productDetails.cfm?productId=#URLEncodedFormat(product.productId)#">
                                <div class="productImage">
                                    <img 
                                        src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" 
                                        alt="productImage" class="prodimg"
                                    >
                                </div>
                                <div class="productName">#product.productName#</div>
                                <div class="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                            </a>
                        <cfset variables.productCount++>
                        </cfif>
                    </cfloop>
                </div>
            </cfloop>
        </main>
    </body>
</html>
</cfoutput>