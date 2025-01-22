<cfoutput>
<cfset categoriesStruct = application.objProductManagement.fetchAllCategories()>
<cfset brands = application.objProductManagement.fetchBrands()>
<cfset products = application.objProductManagement.fetchProducts(subCategoryId =url.subCategoryId)>
<cfif structKeyExists(form,"submit")>
   <cfif LEN(form.hiddenValue) GT 0>
      <cfset application.objProductManagement.updateProduct(productId = form.hiddenValue,subCategoryId = form.selectSubCategory,productName = form.productName,brandId = form.brandName,productDescription = form.productDesc,unitPrice = form.unitPrice,unitTax = form.unitTax,productImages = form.productImages)>      
   <cfelse>
      <cfset application.objProductManagement.insertProduct(subCategoryId = form.selectSubCategory,productName = form.productName,brandId = form.brandName,description = form.productDesc,unitPrice = form.unitPrice,unitTax = form.unitTax,productImages = form.productImages)>
      <cflocation url="product.cfm?subCategoryId=#url.subCategoryId#&categoryId=#url.categoryId#" addtoken="false">
   </cfif>
</cfif>
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
          <cfloop array = "#products.data#"  index="product">
            <div class="productBody" id="#product.productId#">
               <div class="productItem">
                  <div class="productItemLeft">
                     <h4 class="productName">#product.productName#</h4>
                     <h6 class="productBrand">#product.brandName#</h6>
                     <div class="productprice"><i class="fa-solid fa-indian-rupee-sign">#product.unitPrice#</i></div>
                  </div>
                  <div class="productItemImage" data-bs-toggle="modal" data-bs-target="##imageModal" onclick="editImages(#product.productId#)">
                     <img src="./Assets/uploads/product#product.productId#/#product.imageFilePath#" alt="productImage">
                  </div>
                  <div class="productItemRight">
                     <button class="productfnBtn" data-bs-toggle="modal" data-bs-target="##productModal" id="editProductBtn" value="#product.productId#" onclick="editProduct({productId :#product.productId#,categoryId:#url.categoryId#,subCategoryId:#url.subCategoryId#})"><i class="fa-solid fa-pen-to-square productfns" ></i></button>
                     <button class="productfnBtn" onclick="deleteProduct(#product.productId#)"><i class="fa-solid fa-trash productfns"></i></button>
                  </div>
               </div>
            </div>
         </cfloop>
      </div>
   </main>
   <div class="modal fade" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="productModalLabel">Add product</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="POST" enctype="multipart/form-data" onsubmit="return validateProduct()" id="productForm">
               <div class="modal-body">
                  <div class="mb-3">
                     <label for="categoryNameSelectPr" class="form-label">Select Category Name</label>
                     <select class="form-control" id="categoryNameSelectPr" name = "categoryNameSelectPr">
                        <option>--</option> 
                        <cfloop array="#categoriesStruct.categories#" index="i" item="category">
                           <option value="#categoriesStruct.categoryId[i]#">#categoriesStruct.categories[i]#</option>
                        </cfloop>
                     </select>
                     <div id="categorySelectError" class="error"></div>
                  </div>
                  <div class="mb-3">
                     <label for="selectSubCategory" class="form-label">Select SubCategory Name</label>
                     <select class="form-control" id="selectSubCategory" name = "selectSubCategory">
                        <option>--</option>
                     </select>
                     <div id="subCategorySelectError" class="error"></div>
                  </div>
                  <div class="mb-3">
                     <label for="productName" class="form-label">Enter Product Name</label>
                     <input type="text" class="form-control" id="productName" name="productName">
                     <div id="productNameError" class="error"></div>
                  </div>
                  <div class="mb-3">
                     <label for="brandName" class="form-label">Enter Product Brand</label>
                     <select class="form-control" id="brandName" name = "brandName">
                        <option id="0">--</option> 
                        <cfloop  array="#brands.brandIds#" index="i" item="brand">
                           <option value="#brands.brandIds[i]#">#brands.brandNames[i]#</option>
                        </cfloop>
                     </select>
                     <div id="brandNameError" class="error"></div>
                  </div> 
                  <div class="mb-3">
                     <label for="productDesc" class="form-label">Enter Product Description</label>
                     <input type="text" class="form-control" id="productDesc" name="productDesc">
                     <div id="productDescError" class="error"></div>
                  </div>
                   <div class="mb-3">
                     <label for="unitPrice" class="form-label">Select UnitPrice</label>
                     <input type="text" class="form-control" id="unitPrice" name="unitPrice">
                     <div id="unitPriceError" class="error"></div>
                  </div>
                  <div class="mb-3">
                     <label for="unitTax" class="form-label">Select UnitTax</label>
                     <input type="text" class="form-control" id="unitTax" name="unitTax">
                     <div id="unitTaxError" class="error"></div>
                  </div>
                  <div class="mb-3">
                     <label for="productImages">Select Product Images</label>
                     <input type="file" class="form-control-file" id="productImages" multiple name="productImages">
                     <div id="productImageError" class="error"></div>
                     <input type="hidden" id="hiddenValue" name="hiddenValue">
                  </div>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="submit" class="btn btn-primary" class="insertBtn" id="submit" name="submit">Save changes</button>
               </div>
            </form>
         </div>
      </div>
   </div>
   <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
         <div class="modal-content">
            <div class="modal-header">
            </div>
               <div class="modal-body">
                  <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
                     <div class="carousel-inner" id="carouselContainer">
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                      </button>
                      <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                      </button>
               </div>
               <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="submit" class="btn btn-primary" class="insertBtn" id="submit" name="submit">Save changes</button>
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