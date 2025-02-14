<cfset variables.categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfset variables.message = "">
<cfif structKeyExists(form,"submit")>
    <cfif LEN(form.distinguishSubCreateEdit) GT 0>
        <cfset variables.result =  application.objProductManagement.updateSubCategory(subCategoryId = form.distinguishSubCreateEdit,newSubCategoryName = form.subCategoryName,categoryId = form.selectCategory)>
        <cfset variables.message = "#variables.result.message#">
    <cfelse>
        <cfset  variables.result = application.objProductManagement.addSubCategory(categoryId = form.selectCategory,subcategoryName = form.subCategoryName)>
        <cfset variables.message = "#variables.result.message#">
    </cfif>
</cfif>
<cfset variables.subcategoriesResult = application.objProductManagement.fetchSubCategories(categoryId = url.categoryId)>
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SubCategory</title>
    <link rel="stylesheet" href="./Style/bootstrap.css">
    <link rel="stylesheet" href="./Style/all.min.css">
    <link rel="stylesheet" href="./Style/subcategoryStyle.css">
</head>
<body>
    <header>
        <div class="headerLeftItem">
           <div class="headerLeftItem-1"> <img src="./Assets/Images/cart.png" alt="cartImage" width="40"></div>
           <div class="headerLeftItem-2">Admin DashBoard</div>
        </div>
        <div class="headerRightItem">
           <button class="logout">
              <span class="headerRightItem-1">LogOut</span>
              <i class="fa-solid fa-right-from-bracket"></i>
           </button>
        </div>
    </header>
   <main>
        <div class="categoryContainer">
            <div class="categoryheader">
                <h5>Sub Categories</h5>
                <button data-bs-toggle="modal" data-bs-target="##subCategoryModal" class="subcategoryAddbtn"><span>Add</span><i class="fa-solid fa-plus categoryPlus"></i></button>
            </div>
            <div class="categoryBody">
            <cfloop array="#variables.subcategoriesResult.subcategory#" item="subCategory">
                <div class="categoryItem" id="#subCategory.subcategoryId#">
                    <div class="categoryItemText">#subCategory.subCategoryName#</div>
                    <div class="categoryItemRight">
                        <button data-bs-toggle="modal" data-bs-target="##subCategoryModal"
                            class="categoryBtn"
                            value="#subCategory.subcategoryId#"
                            onclick="editSubCategory({
                                categoryId: '#application.objUser.decryptId(url.categoryId)#',
                                subCategoryName: '#JSStringFormat(subCategory.subCategoryName)#',
                                subCategoryId: '#application.objUser.decryptId(subCategory.subcategoryId)#'
                            })">
                            <i class="fa-solid fa-pen-to-square categoryfns"></i>
                        </button>
                        <button class="categoryBtn" onclick="deleteSubCategory('#subCategory.subcategoryId#','#url.categoryId#')"><i class="fa-solid fa-trash categoryfns"></i></button>
                        <a class="categoryBtn" href="./product.cfm?subCategoryId=#URLEncodedFormat(subcategory.subcategoryId)#&categoryId=#URLEncodedFormat(url.categoryId)#">
                           <i class="fa-solid fa-circle-arrow-right categoryfns"></i>
                        </a>
                    </div>
                </div>
            </cfloop>
        </div>
      </div>
    </main>
    <cfif len(trim(variables.message)) GT 0>
        <div class="alert alert-danger">#variables.message#</div>
    </cfif>
    <div class="modal fade" id="subCategoryModal" tabindex="-1" aria-labelledby="subCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                   <h5 class="modal-title" id="subCategoryModalLabel">Add Subcategory</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="POST" onsubmit="return validateSubCategory()">
                    <div class="modal-body">
                        <div class="mb-3">
                              <label for="categoryNameSelect" class="form-label">Select Category Name</label>
                              <select class="form-control" id="categoryNameSelect" name = "selectCategory">
                                 <option value="0">--</option>
                                 <cfloop array ="#variables.categoriesResult.categories#" item = category>
                                    <option value="#category.categoryId#"
                                        <cfif category.categoryId EQ url.categoryId>
                                            selected
                                        </cfif>
                                    >#category.categoryName#</option>
                                 </cfloop>
                              </select>
                              <div id = "categorySelectError" class = "error"></div>
                        </div>
                        <div class="mb-3">
                           <label for="subCategoryName" class="form-label">Enter SubCategory Name</label>
                           <input type="text" class="form-control" id="subCategoryName" name="subCategoryName">
                           <input type="hidden" id="distinguishSubCreateEdit" name = "distinguishSubCreateEdit" >
                            <div id = "subCategoryNameError" class = "error"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                       <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                       <button type="submit" class="btn btn-primary insertSubCategoryBtn" name="submit">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="./Script/bootstrapScript.js"></script>
    <script src="./Script/jquery-3.7.1.min.js"></script>
    <script src="./Script/script.js"></script>
</body>
</html>
</cfoutput>