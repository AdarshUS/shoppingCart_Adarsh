<cfset categories = application.objProductManagement.fetchAllCategories()>
<cfset productDetails = application.objProductManagement.fetchSingleProduct(productId = url.productId,allImagesNeeded = true)>
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
            <cfloop array="#categories.categoryId#" index="i" item="category">
               <div class="dropdown">
                  <a class="category"  aria-expanded="false" href="categoryList.cfm?categoryId=#categories.categoryId[i]#">
                  #categories.categories[i]#
                  </a>
                  <cfset subCategories = application.objProductManagement.fetchSubCategories(categories.categoryId[i])>
                  <ul class="dropdown-menu">
                     <cfloop array = #subCategories.subCategoryNames# index = i item = subcategory>
                        <li><a class="dropdown-item" href="subCategoryList.cfm?subcategoryId=#subCategories.subCategoryIds[i]#">#subCategories.subCategoryNames[i]#</a></li>
                     </cfloop>
                  </ul>
               </div>
            </cfloop>
         </div>
         <div class="productContainer">
            <div class="productImageBox">
               <div id="carouselExampleControls" class="carousel slide" data-bs-ride="carousel">
                  <div class="carousel-inner">
                     <cfloop array="#productDetails.data.images#" item = image>
                        <cfif image EQ productDetails.data.defaultImagePath>
                           <div class="carousel-item active">
                              <img src="./Assets/uploads/product#productDetails.data.productId#/#image#">
                           </div>
                           <cfelse>
                           <div class="carousel-item">
                              <img src="./Assets/uploads/product#productDetails.data.productId#/#image#">
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
                  <a href="subCategoryList.cfm?subcategoryId=#productDetails.data.subcategoryId#">#productDetails.data.subcategoryName#</a><i class="fa-solid fa-angle-right"></i>
                  <a href="./categoryList.cfm?categoryId=#productDetails.data.categoryId#">#productDetails.data.categoryName#</a><i class="fa-solid fa-angle-right"></i>
                  <a href="">#productDetails.data.productName#</a>
               </div>
               <h4 class="productName">#productDetails.data.productName#</h4>
               <div class="brandName">#productDetails.data.brandName#</div>
               <p class="productDescription"><span>description:</span>#productDetails.data.description#</p>
               <div class="pricecontainer">
                  <div class="price"><i class="fa-solid fa-indian-rupee-sign"></i>#productDetails.data.unitPrice#</div>
                  <div class="tax">Tax:#productDetails.data.unitTax#%</div>
               </div>
               <div class="buttonContainer">
                  <button class="btn btn-info p-2">Buy Now</button>
                  <button class="btn btn-success p-2">Add to Cart</button>
               </div>
            </div>
         </div>
         <footer>
            <div class="footer_Container">
               <div class="footerItem">
                  <div class="footerItemCaption">ABOUT</div>
                  <ul class="">
                     <li Contact Us</li>
                     <li>About Us</li>
                     <li> </li>
                     <li>Flipkart Stories</li>
                     <li>Press</li>
                     <li>Corporate Information</li>
                  </ul>
               </div>
               <div class="footerItem">
                  <div class="footerItemCaption">GROUP COMPANIES</div>
                  <ul class="p-0">
                     <li>Myntra</li>
                     <li>Cleartrip</li>
                     <li>Shopsy</li>
                  </ul>
               </div>
               <div class="footerItem">
                  <div class="footerItemCaption">HELP</div>
                  <ul class="">
                     <li>Payments</li>
                     <li>Shipping</li>
                     <li>Cancellation & returns</li>
                     <li>FAQ</li>
                     <li>Report Infringement</li>
                  </ul>
               </div>
               <div class="footerItem">
                  <div class="footerItemCaption">CONSUMER POLICY</div>
                  <ul class="">
                     <li>Cancellation & Returns</li>
                     <li>Terms Of Use</li>
                     <li>Security</li>
                     <li>Privacy</li>
                     <li>Sitemap</li>
                     <li>Grievance Redressal</li>
                     <li>EPR Compilance</li>
                  </ul>
               </div>
               <div class="footerItem">
                  <div class="footerItemCaption">Mail Us:</div>
                  <div class="contact">
                     Flipkart Internet Private Limited, Buildings Alyssa, Begonia & Clove Embassy Tech Village, Outer Ring Road, Devarabeesanahalli Village, Bengaluru, 560103, Karnataka, India
                  </div>
                  <div>Social</div>
                  <div><i class="fa-brands fa-facebook"></i> <i class="fa-brands fa-x-twitter"></i> <i class="fa-brands fa-square-youtube"></i></div>
               </div>
               <div class="footerItem">
                  <div class="footerItemCaption">Registered Office Address</div>
                  <div class="contact">Flipkart Internet Private Limited, Buildings Alyssa, Begonia & Clove Embassy Tech Village, Outer Ring Road, Devarabeesanahalli Village, Bengaluru, 560103, Karnataka, India CIN: U51109KA2012PTC066107 Telephone: 044-45614700/044-67415800</div>
               </div>
            </div>
            <div class="footerBottom_container">
               <div>
                  <i class="fa-solid fa-suitcase suitcase"></i><span>Become a Seller</span>
               </div>
               <div>
                  <i class="fa-solid fa-circle-star star"></i><span>Advertise</span>
               </div>
               <div>
                  <i class="fa-solid fa-gift-card gift-card"></i><span>Gift Cards</span>
               </div>
               <div>
                  <i class="fa-regular fa-circle-question Question"></i><span>Help Center</span>
               </div>
               <div>
                  <i class="fa-regular fa-copyright cpright"></i><span>2007-2024 Flipkart.com</span>
               </div>
               <div>
                  <img src="./Assets/images/paymentimage.svg" alt="">
               </div>
            </div>
            <div>
            </div>
            <div>
            </div>
         </footer>
         <script src="./Script/jquery-3.7.1.min.js"></script>
         <script src="./Script/bootstrapScript.js"></script>
          <script src="./Script/userPageScript.js"></script>
      </body>
   </html>
</cfoutput>