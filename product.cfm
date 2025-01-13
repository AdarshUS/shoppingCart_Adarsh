<cfoutput>
<cfset categories = application.objShoppingCart.fetchAllCategories()>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>product page</title>
   <link rel="stylesheet" href="./Style/bootstrap.css">
   <link rel="stylesheet" href="./Style/fontawesome.css">
   <link rel="stylesheet" href="./Style/productStyle.css">
</head>
<body>
   <header>
      <div class="headerLeftItem">
         <div class="headerLeftItem-1"> <img src="./Assets/Images/cart.png" alt="cartImage" width="40"></div>
         <div class="headerLeftItem-2">Admin</div>         
      </div>
       <div class="headerRightItem">
         <button class="logout">
            <span class="headerRightItem-1">LogOut</span>
            <i class="fa-solid fa-right-from-bracket"></i>
         </button>        
      </div>
   </header>
   <main>
      <div class="productContainer">
         <div class="productheader">
            <h5>products</h5>
            <button data-bs-toggle="modal" data-bs-target="##productModal" class="productAddbtn" onclick="createproduct()"><span>Add</span><i class="fa-solid fa-plus productPlus"></i></button>         
         </div>
      </div>
   </main>
   <div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="productModalLabel">Add product</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <div class="mb-3">                      
                  <label for="categoryNameSelectPr" class="form-label">Select Category Name</label>
                  <select class="form-control" id="categoryNameSelectPr" name = "categoryNameSelectPr">
                     <option>--</option> 
                     <cfloop query="categories">
                        <option value="#categories.fldCategory_Id#">#categories.fldCategoryName#</option>
                     </cfloop>                                                   
                  </select>                  
               </div>
               <div class="mb-3">                      
                  <label for="selectSubCategory" class="form-label">Select SubCategory Name</label>
                  <select class="form-control" id="selectSubCategory" name = "selectSubCategory">
                     <option>--</option>                                             
                  </select>                  
               </div>
               <div class="mb-3">
                  <label for="productName" class="form-label">Enter SubCategory Name</label>
                  <input type="text" class="form-control" id="productName" name="productName">                  
               </div>
               <div class="mb-3">
                  <label for="productBrand" class="form-label">Enter Product Brand</label>
                  <input type="text" class="form-control" id="productBrand" name="productBrand">                  
               </div> 
               <div class="mb-3">
                  <label for="productDesc" class="form-label">Enter Product Description</label>
                  <input type="text" class="form-control" id="productDesc" name="productDesc">                  
               </div> 
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
               <button type="button" class="btn btn-primary" class="insertBtn" onclick="insertEditproduct()">Save changes</button>
            </div>
         </div>
      </div>
   </div>
   <script src="./Script/bootstrapScript.js"></script>
   <script src="./Script/jquery-3.7.1.min.js"></script>     
   <script src="./Script/script.js"></script>   
</body>
</html>
</cfoutput>