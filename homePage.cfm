<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfset randomProducts = application.objProductManagement.getRandomProducts() >
<cfdump var = "#randomProducts#">
<!Doctype html>
<cfoutput>
<html>
   <head>
      <title>Flipkart</title>
      <link rel="stylesheet" href="./Style/bootstrap.css">
      <link rel="stylesheet" href="Style/homestyle.css">
      <link rel="stylesheet" href="./Style/fontawesome.css">
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
      </div>
      <div class="randomProducts d-flex flex-wrap">

      </div>
    </div>
   </body>
   <script src="./Script/bootstrapScript.js"></script>
</html>
</cfoutput>
