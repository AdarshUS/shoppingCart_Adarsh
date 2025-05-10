<cfset variables.categoriesResultNav = application.objProductManagement.fetchAllCategories()>
<cfset variables.subcategoriesResultNav = application.objProductManagement.fetchSubCategories()>
<cfoutput>
<div class="categoriesContainer">
    <cfloop array="#variables.categoriesResultNav.categories#" item="category">
        <div class="dropdown">
            <a class="category" aria-expanded="false" href="categoryList.cfm?categoryId=#URLEncodedFormat(category.categoryId)#">
                #category.categoryName#
            </a>
            <ul class="dropdown-menu">
                <cfloop array = #subcategoriesResultNav.subcategory# item = "subcategory">
                    <cfif subcategory.categoryId EQ category.categoryId>
                        <li>
                            <a
                                class="dropdown-item"
                                href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(subcategory.subCategoryId)#">#subCategory.subCategoryname#
                            </a>
                        </li>
                    </cfif>
                </cfloop>
            </ul>
        </div>
    </cfloop>
</div>
</cfoutput>

