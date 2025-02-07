<cfoutput>
    <cfset categories = application.objProductManagement.fetchAllCategories()>
    <cfif structKeyExists(form,"searchInput")>
        <cfif len(trim(form.searchInput)) EQ 0>
           <cflocation url="homePage.cfm" addtoken="no">
        </cfif>
        <cfset productDetails =  application.objProductManagement.fetchProducts(searchText = form.searchInput)>
        <cfif ArrayIsEmpty(productDetails.products)>
           <cfset message = "No Results Found for ""<span class=""searchText"">#form.searchInput#</span>""">
        <cfelse>
           <cfset message = "Search Result for ""<span class=""searchText"">#form.searchInput#</span>""">
        </cfif>
    </cfif>
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Document</title>
            <link rel="stylesheet" href="Style/bootstrap.css">
            <link rel="stylesheet" href="Style/fontawesome.css">
            <link rel="stylesheet" href="Style/homestyle.css">
        </head>
        <body>
            <cfinclude template = "header.cfm">
            <div class="searchResultText">#message#</div>
            <div class="productContainer" id="productContainer">
                <cfloop array = "#productDetails.products#" item = product>
                    <a class="productBox" id="productBox" href="productDetails.cfm?productId=#product.productId#">
                       <div class="productImage"><img src="#'./Assets/uploads/product'&application.objUser.decryptId(product.productId)#/#product.imageFilePath#" alt="productImage" class="prodimg" id="prodimg"></div>
                       <div class="productName" id="productName">#product.productName#</div>
                       <div class="productPrice" id="productPrice"><i class="fa-solid fa-indian-rupee-sign"></i>#product.unitPrice#</div>
                    </a>
                </cfloop>
            </div>
        </body>
    </html>
</cfoutput>