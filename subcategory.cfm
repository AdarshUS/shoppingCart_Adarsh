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
            <button data-bs-toggle="modal" data-bs-target="#subCategoryModal" class="categoryAddbtn"><span>Add</span><i class="fa-solid fa-plus categoryPlus"></i></button>         
         </div>
         <div class="categoryBody">           
               <div class="categoryItem" id="">
                  <div class="categoryItemText"></div>               
                  <div class="categoryItemRight">
                     <button data-bs-toggle="modal" data-bs-target="#subCategoryModal" class="categoryBtn"><i class="fa-solid fa-pen-to-square categoryfns" ></i></button>
                     <button class="categoryBtn"><i class="fa-solid fa-trash categoryfns"></i></button>
                     <button class="categoryBtn"><i class="fa-solid fa-circle-arrow-right categoryfns"></i></button>
                  </div>              
               </div>            
         </div>
      </div>   
   </main>  
   <div class="modal fade" id="subCategoryModal" tabindex="-1" aria-labelledby="subCategoryModalLabel" aria-hidden="true">
      <div class="modal-dialog">
         <div class="modal-content">
            <div class="modal-header">
               <h5 class="modal-title" id="subCategoryModalLabel">Add Subcategory</h5>
               <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
               <div class="mb-3">
                  <label for="categoryName" class="form-label">Enter Subcategory Name</label>
                  <input type="text" class="form-control" id="categoryName">                  
               </div>
               <div class="mb-3">
                  <label for="subCategoryName" class="form-label">Enter Category Name</label>
                  <input type="text" class="form-control" id="subCategoryName">
               </div>               
            </div>
            <div class="modal-footer">
               <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
               <button type="button" class="btn btn-primary" class="insertBtn">Save changes</button>
            </div>
         </div>
      </div>
   </div>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>    
   <script src="https://cdnjs.cloudflare.com/ajax/libs/chosen/1.8.7/chosen.jquery.min.js" crossorigin="anonymous" referrerpolicy="no-referrer"></script>	   
   <script src="./Script/script.js"></script>   
</body>
</html>