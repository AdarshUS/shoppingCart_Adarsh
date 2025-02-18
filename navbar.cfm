<cfset variables.categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfset variables.subcategoriesResult = application.objProductManagement.fetchSubCategories()>
<cfoutput>
<div class="categoriesContainer">
    <cfloop array="#variables.categoriesResult.categories#" item="category">
        <div class="dropdown">
            <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#URLEncodedFormat(category.categoryId)#">
                #category.categoryName#
            </a>
            <ul class="dropdown-menu">
                <cfloop array = #subcategoriesResult.subcategory# item = "subcategory">
                    <cfif category.categoryId EQ subcategory.categoryId>
                        <li><a class="dropdown-item" href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(subcategory.subCategoryId)#">#subCategory.subCategoryname#</a></li>
                    </cfif>
                </cfloop>
            </ul>
        </div>
    </cfloop>
</div>
</cfoutput>

