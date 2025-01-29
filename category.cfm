<cfset result = application.objProductManagement.fetchAllCategories()>
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>AdminLogin</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/all.min.css">
   <link rel="stylesheet" href="./Style/categoryStyle.css">
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
            <h5>Categories</h5>
            <button data-bs-toggle="modal" data-bs-target="##categoryModal" class="categoryAddbtn" onclick="createCategory()"><span>Add</span><i class="fa-solid fa-plus categoryPlus"></i></button>         
         </div>
         <div class="categoryBody">
            <cfloop array="#result.categories#" item="category">
               <div class="categoryItem" id="#application.objUser.decryptId(category.categoryId)#">
                  <div class="categoryItemText">#category.categoryName#</div>
                  <div class="categoryItemRight">
                     <button data-bs-toggle="modal" data-bs-target="##categoryModal" onclick="editCategory(this)" value = #application.objUser.decryptId(category.categoryId)# class="categoryBtn"><i class="fa-solid fa-pen-to-square categoryfns" ></i></button>
                     <button class="categoryBtn" onclick="deleteCategory(this)" value = #application.objUser.decryptId(category.categoryId)#><i class="fa-solid fa-trash categoryfns"></i></button>
                     <a class="categoryBtn" href="./subcategory.cfm?categoryId=#URLEncodedFormat(category.categoryId)#"><i class="fa-solid fa-circle-arrow-right categoryfns"></i></a>
                  </div>
               </div>
            </cfloop>
         </div>
      </div>
   </main>
   <div class="modal fade" id="categoryModal" tabindex="-1" aria-labelledby="categoryModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="categoryModalLabel">Add Category</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <div class="mb-3">
                  <label for="exampleInputText" class="form-label">Enter Category Name</label>
                  <input type="text" class="form-control" id="categoryInput">
                  <div class="error" id="categoryError"></div>
                  <input type="hidden" id="distinguishCreateEdit">
               </div>
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
               <button type="button" class="btn btn-primary" class="insertBtn" onclick="insertEditCategory()">Save changes</button>
            </div>
            <div class="categoryExistError" id="categoryExistError"></div>
         </div>
      </div>
   </div>
   <script src="./Script/bootstrapScript.js"></script>
   <script src="./Script/jquery-3.7.1.min.js"></script>
   <script src="./Script/script.js"></script>
</body>
</html>
</cfoutput>
