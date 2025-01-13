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

$(".logout").click(function() {
    if (confirm("Are you sure you want to Logout")) {
        $.ajax({
            url: 'components/shoppingCart.cfc?method=logoutAdmin',
            type: 'POST',
            success: function(result) {
              location.reload();
            },
            error: function() {
                
            }
        });
    }
});

function insertEditCategory() {
   
    let inputValue = $("#categoryInput").val();
    let hiddenValue = $("#distinguishCreateEdit").val();
      if(hiddenValue.trim() === "")
      {
         $.ajax({
          url: 'components/shoppingCart.cfc?method=insertCategories',
          data: {categoryName:inputValue},
          type: 'POST',
          success: function() {
            $('#categoryModal').modal('hide')
          },
          error: function() {              
          }
         });
      }
      else
      {
          $.ajax({
          url: 'components/shoppingCart.cfc?method=editCategory',
          data: {categoryId:hiddenValue,newcategory:inputValue},
          type: 'POST',
          success: function() {
            $('#categoryModal').modal('hide')
          },
          error: function() {
              
          }
      });        
      }      
}

function editCategory(editBtn)
{
   console.log(editBtn.value)
   document.getElementById("categoryModalLabel").textContent = "Edit Category";   
   $.ajax({
          url: 'components/shoppingCart.cfc?method=fetchSingleCategory',
          data: {categoryId:editBtn.value},
          type: 'POST',
          success: function(result) {
            let category = JSON.parse(result);
            console.log(category)
            document.getElementById("categoryInput").value = category.FLDCATEGORYNAME;
            document.getElementById("distinguishCreateEdit").value = category.FLDCATEGORY_ID;
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
   	 url: 'components/shoppingCart.cfc?method=deleteCategory',
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
   	 url: 'components/shoppingCart.cfc?method=softDeleteSubCategory',
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
    if(categorySelected.trim() != "")
    {
      $.ajax({		
   	 url: 'components/shoppingCart.cfc?method=fetchSubCategories',
   	 type: 'POST',
   	 data: {categoryId:categorySelected},
   	 success: function(result) {
      let subCategories = JSON.parse(result);
      const subcategoryIndex = subCategories.COLUMNS.indexOf("FLDSUBCATEGORYNAME");
      const subcategoryNames = subCategories.DATA.map((row) => row[subcategoryIndex]);
      for(let i = 0;i<subcategoryNames.length;i++)
      {
        let opt = document.createElement('option');
        opt.value = i;
        opt.innerHTML = subcategoryNames[i];
        select.appendChild(opt); 
      }
   	 },
   	 error: function() {		
   	 }
      });
    }
});

function createproduct()
{

}

