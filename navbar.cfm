<cfset categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfoutput >
<div class="categoriesContainer">
         <cfloop array="#categoriesResult.categories#" item="category">
            <div class="dropdown">
               <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#URLEncodedFormat(application.objUser.encryptId(category.categoryId))#">
                 #category.categoryName#
               </a>
               <cfset subcategoriesResult = application.objProductManagement.fetchSubCategories(category.categoryId)>
               <ul class="dropdown-menu">
                  <cfloop array = #subcategoriesResult.subcategory# item = subcategory>
                     <li><a class="dropdown-item" href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(application.objUser.encryptId(subcategory.subCategoryId))#">#subCategory.subCategoryname#</a></li>
                  </cfloop>
               </ul>
            </div>
         </cfloop>
      </div>
   </cfoutput>

  