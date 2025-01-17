function validate()
{
   let validInput = true;
   let username = document.getElementById("userName").value;
   let passsword =  document.getElementById("password").value;

   let usernameError = document.getElementById("userNameError");
   let passswordError =  document.getElementById("passwordError");

   usernameError.textContent = "";
   passswordError.textContent = "";

   if(username.trim() === "")
   {
      usernameError.textContent = "userName cannot be empty";
      validInput = false;
   }

    if(passsword.trim() === "")
   {
      passswordError.textContent = "password cannot be empty";
      validInput = false;
   }

   return validInput;
}

function validateSubCategory()
{
  
  let validSubCategory = true;
  let categoryName = document.getElementById("categoryNameSelect").value;
  let subCategoryName = document.getElementById("subCategoryName").value;
  
  let categorySelectError = document.getElementById("categorySelectError");
  let subCategoryNameError = document.getElementById("subCategoryNameError");

  categorySelectError.innerHTML = "";
  subCategoryNameError.innerHTML = "";

  if(categoryName === "" || categoryName === "--")
  {
    categorySelectError.innerHTML = "Category Cannot be Empty"
    validSubCategory = false;
  }

  if(subCategoryName.trim() === "")
  {
    subCategoryNameError.innerHTML = "Subcategory Cannot be Empty"
    validSubCategory = false;
  }
  return validSubCategory;
}

$(".logout").click(function() {
    if (confirm("Are you sure you want to Logout")) {
        $.ajax({
            url: 'components/User.cfc?method=logoutAdmin',
            type: 'POST',
            success: function(result) {
              location.reload();
            },
            error: function() {
                
            }
        });
    }
});

$(document).on("click", function(){
    $("#user_error").hide();
});

$(".subcategoryAddbtn").click(function() {
   document.getElementById("categorySelectError").innerHTML = "";
  document.getElementById("subCategoryNameError").innerHTML = "";
});

function insertEditCategory() {

    let inputValue = $("#categoryInput").val();
    if(inputValue.trim() === "")
    {
      document.getElementById("categoryError").innerHTML = "Enter a Category Name";
      return;
    }
    let hiddenValue = $("#distinguishCreateEdit").val();
      if(hiddenValue.trim() === "")
      {
         $.ajax({
          url: 'components/ProductManagement.cfc?method=addCategory',
          data: {categoryName:inputValue},
          type: 'POST',
          success: function() {
            location.reload();
          },
          error: function() {
          }
         });
      }
      else
      {
          $.ajax({
          url: 'components/ProductManagement.cfc?method=editCategory',
          data: {categoryId:hiddenValue,newcategory:inputValue},
          type: 'POST',
          success: function() {
            location.reload();
          },
          error: function() {
              
          }
      });        
      }      
}

function editCategory(editBtn)
{   
   document.getElementById("categoryModalLabel").textContent = "Edit Category";   
   $.ajax({
          url: 'components/ProductManagement.cfc?method=fetchSingleCategory',
          data: {categoryId:editBtn.value},
          type: 'POST',
          success: function(result) {
            let category = JSON.parse(result);
            document.getElementById("categoryInput").value = category.name;
            document.getElementById("distinguishCreateEdit").value = category.categoryId;
          },
          error: function() {
              
          }
      });        
}

function deleteCategory(dltBtn)
{
   if (confirm("Are you sure you want to delete"))
	{
		$.ajax({		
   	 url: 'components/ProductManagement.cfc?method=deleteCategory',
   	 type: 'POST',
   	 data: {categoryId:dltBtn.value},
   	 success: function() {			
			document.getElementById(dltBtn.value).remove();
   	 },
   	 error: function() {		
   	 }
      });
	}	
}

function createCategory()
{
  document.getElementById("categoryModalLabel").textContent = "Create Category";
  document.getElementById("categoryInput").value = "";
}

function editSubCategory(subCategory)
{
  document.getElementById("subCategoryName").value = subCategory.subCategoryName;
  document.getElementById("categoryNameSelect").value = subCategory.categoryId;
  document.getElementById("subCategoryModalLabel").innerHTML = "Edit SubCategory";
  document.getElementById('distinguishSubCreateEdit').value = subCategory.subCategoryId;
}

$(".subcategoryAddbtn").click(function() {
  document.getElementById("subCategoryModalLabel").innerHTML = "Create SubCategory";
  document.getElementById("subCategoryName").value = "";
  document.getElementById("categoryNameSelect").value = "";
});

function deleteSubCategory(subCategoryId)
{
  if (confirm("Are you sure you want to delete"))
	{
		$.ajax({		
   	 url: 'components/ProductManagement.cfc?method=softDeleteSubCategory',
   	 type: 'POST',
   	 data: {subCategoryId:subCategoryId},
   	 success: function() {			
			document.getElementById(subCategoryId).remove();
   	 },
   	 error: function() {		
   	 }
      });
	}	
}

$("#categoryNameSelectPr").change(function() {
    let categorySelected = $('#categoryNameSelectPr').val();
    let subCategoryElement  = document.getElementById("selectSubCategory");
    if(categorySelected === "--")
    {
      categorySelected="0";
    }
    if(categorySelected.trim() != "")
    {
      $.ajax({		
   	 url: 'components/ProductManagement.cfc?method=fetchSubCategories',
   	 type: 'POST',
   	 data: {categoryId:categorySelected},
   	 success: function(result) {
      let subcategoryIdArray = JSON.parse(result).SUBCATEGORYIDS;
      let subcategoryNames = JSON.parse(result).SUBCATEGORYNAMES;      
      subCategoryElement.innerHTML = "";
      for(let i = 0;i<subcategoryIdArray.length;i++)
      {        
        let opt = document.createElement('option');
        opt.value = subcategoryIdArray[i];
        opt.innerHTML = subcategoryNames[i];
        subCategoryElement.appendChild(opt); 
      }
   	 },
   	 error: function() {		
   	 }
      });
    }
});

function validateProduct()
{
  let validProduct = true;
  let categoryName = document.getElementById("categoryNameSelectPr").value;
  let subCategoryName = document.getElementById("selectSubCategory").value;
  let productName = document.getElementById("productName").value;
  let brandName = document.getElementById("brandName").value;
  let productDesc = document.getElementById("productDesc").value;
  let unitPrice =  document.getElementById("unitPrice").value;
  let unitTax = document.getElementById("unitTax").value;
  let productImage  = document.getElementById("productImages");

  let categorySelectError = document.getElementById("categorySelectError");
  let subCategorySelectError  = document.getElementById("subCategorySelectError");
  let productNameError = document.getElementById("productNameError");
  let brandNameError = document.getElementById("brandNameError");
  let productDescError = document.getElementById("productDescError");
  let unitPriceError =  document.getElementById("unitPriceError");
  let unitTaxError = document.getElementById("unitTaxError");
  let productImageError  = document.getElementById("productImageError");

  categorySelectError.innerHTML = "";
  subCategorySelectError.innerHTML = "";
  productNameError.innerHTML = "";
  brandNameError.innerHTML = "";
  productDescError.innerHTML = "";
  unitPriceError.innerHTML = "";
  unitTaxError.innerHTML = "";
  productImageError.innerHTML = "";

  if(categoryName.trim() === "" || categoryName.trim() === "--")
  {
    categorySelectError.innerHTML = "Select Any Category";
    validProduct = false;
  }

  if(subCategoryName.trim() === "" || subCategoryName.trim() === "--")
  {
    subCategorySelectError.innerHTML = "Select Any SubCategory";
    validProduct = false;
  }

  if(productName.trim() === "")
  {
    productNameError.innerHTML = "Enter the ProductName";
    validProduct = false;
  }

  if(brandName.trim() ==="" || brandName.trim() ==="--")
  {
    brandNameError.innerHTML = "Select Any Brand";
    validProduct = false;
  }

  if(productDesc.trim() === "")
  {
    productDescError.innerHTML = "Enter the pro Desc";
    validProduct = false;
  }

  if(unitPrice.trim() === "")
  {
    unitPriceError.innerHTML = "Enter the UnitPrice";
    validProduct = false;
  }

  if(unitTax.trim() === "")
  {
    unitTaxError.innerHTML = "Enter the unit Tax";
    validProduct = false;
  }

  return validProduct;
}

function createproduct()
{
  let categorySelectError = document.getElementById("categorySelectError");
  let subCategorySelectError  = document.getElementById("subCategorySelectError");
  let productNameError = document.getElementById("productNameError");
  let brandNameError = document.getElementById("brandNameError");
  let productDescError = document.getElementById("productDescError");
  let unitPriceError =  document.getElementById("unitPriceError");
  let unitTaxError = document.getElementById("unitTaxError");
  let productImageError  = document.getElementById("productImageError");

  categorySelectError.innerHTML = "";
  subCategorySelectError.innerHTML = "";
  productNameError.innerHTML = "";
  brandNameError.innerHTML = "";
  productDescError.innerHTML = "";
  unitPriceError.innerHTML = "";
  unitTaxError.innerHTML = "";
  productImageError.innerHTML = "";
}

function editProduct(editObj) {   
   let subCategoryElement  = document.getElementById("selectSubCategory");
   $.ajax({
     url: 'components/ProductManagement.cfc?method=fetchSingleProduct',
     data:{productId:editObj.productId},
     type: 'POST',
     success: function(result) {
      let product = JSON.parse(result);
      document.getElementById("productName").value = product.productName;
      document.getElementById("brandName").value = product.brandId;
      document.getElementById("productDesc").value = product.description;
      document.getElementById("unitPrice").value = product.unitPrice;
      document.getElementById("unitTax").value = product.unitTax;
      document.getElementById("categoryNameSelectPr").value = editObj.categoryId;
      document.getElementById("hiddenValue").value = editObj.productId;
      $.ajax({		
        url: 'components/ProductManagement.cfc?method=fetchSubCategories',
        type: 'POST',
        data: {categoryId:editObj.categoryId},
        success: function(result) {
        let subcategoryIdArray = JSON.parse(result).SUBCATEGORYIDS;
        let subcategoryNames = JSON.parse(result).SUBCATEGORYNAMES;      
        subCategoryElement.innerHTML = "";
        for(let i = 0;i<subcategoryIdArray.length;i++)
        {        
          let opt = document.createElement('option');
          opt.value = subcategoryIdArray[i];
          opt.innerHTML = subcategoryNames[i];
          subCategoryElement.appendChild(opt); 
        }
        },
        error: function() {		
        }
        });
     },
     error: function() {
         
     }
    });
}

function deleteProduct(productId)
{
  if (confirm("Are you sure you want to delete"))
    {
      $.ajax({		
        url: 'components/ProductManagement.cfc?method=deleteProduct',
        type: 'POST',
        data: {productId:productId},
        success: function() {			
        document.getElementById(productId).remove();
        },
        error: function() {		
        }
        });
    }	
}

function editImages(productId) {   
    $.ajax({
        url: 'components/ProductManagement.cfc?method=fetchProductImages',
        data: { productId: productId },
        type: 'POST',
        success: function(result) {
            console.log(result)
            let productImages = JSON.parse(result).IMAGES;
            let productImagesId = JSON.parse(result).PRODUCTIMAGESID;
            let defaultImageId = JSON.parse(result).DEFAULTIMAGEID;
            let carouselContainer = document.getElementById("carouselContainer");
            carouselContainer.innerHTML = '';
            for (let i = 0; i < productImages.length; i++) {
                
                let div = document.createElement("div");
                div.setAttribute('class', i === 0 ? 'carousel-item active' : 'carousel-item'); 
                const img = document.createElement('img');
                img.src = "./Assets/uploads/product"+productId+"/"+productImages[i]; 
                img.alt = `Product Image ${i + 1}`;

                if(productImagesId[i] != defaultImageId)
                {                 
                  let setThumbnailBtn = document.createElement('button');
                  setThumbnailBtn.innerHTML = "setThumbnail"
                  setThumbnailBtn.setAttribute('class','thumbnailBtn btn btn-success'); 
                  setThumbnailBtn.setAttribute('onclick', `setThumbnail(${productImagesId[i]},${productId})`);
                  let deleteImageBtn = document.createElement('button');
                  deleteImageBtn.innerHTML = "deleteImage"
                  deleteImageBtn.setAttribute('class','deleteImageBtn btn btn-danger');
                  deleteImageBtn.setAttribute('onclick', `deleteProductImage(${productImagesId[i]},${productId},"${productImages[i]}")`);
                  div.appendChild(setThumbnailBtn);
                  div.appendChild(deleteImageBtn);  
                }
                div.appendChild(img);
                carouselContainer.appendChild(div);
            }
        },
        error: function() {
            alert("Failed to fetch product images.");
        }
    });
}
function setThumbnail(productImageId,productId)
{
  $.ajax({		
        url: 'components/ProductManagement.cfc?method=updateThumbnail',
        type: 'POST',
        data: {productImageId:productImageId,productId:productId},
        success: function() {			
          editImages(productId);
        },
        error: function() {		
        }
        });
}

function deleteProductImage(productImageId,productId,productImageFilename)
{
  alert(productImageFilename)
  $.ajax({		
     url: 'components/ProductManagement.cfc?method=deleteProductImage',
     type: 'POST',
     data: {productImageId:productImageId,productId:productId,productFileName:productImageFilename},
     success: function() {			
       editImages(productId);
     },
     error: function() {		
     }
     });
}

function getSubCategoryies()
{
  
}





