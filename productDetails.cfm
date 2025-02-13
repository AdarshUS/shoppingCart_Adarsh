<cfset variables.categoriesResult = application.objProductManagement.fetchAllCategories()>
<cfset variables.productDetails = application.objProductManagement.getProductDetails(productId = url.productId)>
<cfset addresses = {}>
<cfif structKeyExists(session, "loginuserId")>
    <cfset addresses = application.objUser.fetchAddress()>
</cfif>
<!DOCTYPE html>
<cfoutput>
    <html lang="en">
        <head>
           <meta charset="UTF-8">
           <meta name="viewport" content="width=device-width, initial-scale=1.0">
           <title>Document</title>
           <link rel="stylesheet" href="./Style/bootstrap.css">
           <link rel="stylesheet" href="./Style/fontawesome.css">
           <link rel="stylesheet" href="./Style/productDetails.css">
           <link rel = "stylesheet" href="./Style/homestyle.css">
        </head>
        <body>
            <cfinclude template = "header.cfm">
            <div class="categoriesContainer">
                <cfloop array="#variables.categoriesResult.categories#" item="category">
                    <div class="dropdown">
                        <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#URLEncodedFormat(category.categoryId)#">
                            #category.categoryName#
                        </a>
                        <cfset variables.subCategoriesResult = application.objProductManagement.fetchSubCategories(category.categoryId)>
                        <ul class="dropdown-menu">
                            <cfloop array = #variables.subCategoriesResult.subCategory# item = subcategory>
                               <li><a class="dropdown-item" href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(subcategory.subCategoryId)#">#subcategory.subCategoryName#</a></li>
                            </cfloop>
                        </ul>
                    </div>
                </cfloop>
            </div>
            <div class="productContainer">
               <div class="productImageBox">
                  <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel"> 
                       <div class="carousel-inner">
                           <cfloop array="#variables.productDetails.data.images#" item = image>
                              <cfif image EQ variables.productDetails.data.defaultImagePath>
                                 <div class="carousel-item active">
                                    <img src="#'./Assets/uploads/product'&application.objUser.decryptId(variables.productDetails.data.productId)#/#image#">
                                 </div>
                                 <cfelse>
                                 <div class="carousel-item">
                                    <img src="#'./Assets/uploads/product'&application.objUser.decryptId(variables.productDetails.data.productId)#/#image#">
                                 </div>
                              </cfif>
                           </cfloop>
                       </div>
                       <button class="carousel-control-prev" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="prev">
                           <span class="carousel-control-prev-icon bg-secondary" aria-hidden="true"></span>
                           <span class="visually-hidden">Previous</span>
                       </button>
                       <button class="carousel-control-next" type="button" data-bs-target="##carouselExampleControls" data-bs-slide="next">
                           <span class="carousel-control-next-icon bg-secondary" aria-hidden="true"></span>
                           <span class="visually-hidden">Next</span>
                       </button>
                  </div>
               </div>
               <div class="productDetail">
                    <div class="pathtext">
                        <a href="subCategoryList.cfm?subcategoryId=#URLEncodedFormat(variables.productDetails.data.subcategoryId)#">#variables.productDetails.data.subcategoryName#</a><i class="fa-solid fa-angle-right"></i>
                        <a href="./categoryList.cfm?categoryId=#URLEncodedFormat(variables.productDetails.data.categoryId)#">#variables.productDetails.data.categoryName#</a><i class="fa-solid fa-angle-right"></i>
                        <a href="">#variables.productDetails.data.productName#</a>
                    </div>
                    <h4 class="productName">#variables.productDetails.data.productName#</h4>
                    <div class="brandName">#variables.productDetails.data.brandName#</div>
                    <p class="productDescription"><span>description:</span>#variables.productDetails.data.description#</p>
                    <div class="pricecontainer">
                        <div class="price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.productDetails.data.unitPrice#</div>
                        <div class="tax">Tax:#variables.productDetails.data.unitTax#%</div>
                    </div>
                    <form method="post">
                        <div class="buttonContainer">
                            <cfif NOT structKeyExists(session, "loginuserId")>
                                <button type="button" class="btn btn-info p-2" 
                                onclick="window.location.href='userLogin.cfm?productId=#URLEncodedFormat(variables.productDetails.data.productId)#&redirect=product'">
                                    Buy Now
                                </button>
                                <button type="button" class="btn btn-success p-2" id="cartButton" onclick="window.location.href='userLogin.cfm?productId=#URLEncodedFormat(variables.productDetails.data.productId)#&redirect=cart'">
                                    Add to Cart
                                </button>
                            <cfelse>
                                <button type="button" class="btn btn-info p-2" data-bs-toggle="modal" data-bs-target="##selectAddressModal">
                                    Buy Now
                                </button>
                                 <button type="button" class="btn btn-success p-2" id="cartButton" onclick="handleCartAction('#variables.productDetails.data.productId#')">
                                    Add to Cart
                                </button>
                            </cfif>
                        </div>
                    </form>
               </div>
            </div>
            <cfinclude template="footer.cfm">
             <div class="modal fade" id="selectAddressModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="selectAddress"></div>
                        </div>
                        <div class="modal-body">
                            <div class="savedAddressText">Saved Addresses</div>
                            <cfif structKeyExists(addresses, "address") AND isArray(addresses.address)>
                                <cfloop array = #addresses.address# item = "address">
                                    <div class="addressItem">
                                        <input type="radio" name="address" id="address" value=#urlEncodedFormat(address.addressId)#>
                                        <div class="addressContent">
                                            <div>
                                                <span class="firstName">#address.firstName#</span>
                                                <span class="lastName">#address.lastName#</span>
                                                <span class="phone">#address.phone#</span>
                                                <div class="addressLine1">#address.addressline1#</div>
                                                <div class="addressLine2">#address.addressline2#</div>
                                                <div class="city">#address.city#</div>
                                                <div class="state">#address.state#</div>
                                                <div class="pincode">#address.pincode#</div>
                                            </div>
                                        </div>
                                    </div>
                                </cfloop>
                            </cfif>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-success" id="addAddressBtn" name="submit">Add Address</button>
                            <button type="button" class="btn btn-primary" id="submit" name="submit" onclick="redirectToOrder('#url.productId#')">Payment Details</button>
                        </div>
                    </div>
                </div>
            </div>
            <cfinclude  template="addAdress.cfm">
            <script src="./Script/jquery-3.7.1.min.js"></script>
            <script src="./Script/bootstrapScript.js"></script>
            <script src="./Script/userPageScript.js"></script>
        </body>
    </html>
</cfoutput>