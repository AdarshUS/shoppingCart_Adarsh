<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfoutput >
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
   </cfoutput>

  