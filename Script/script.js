function validate() {
    let validInput = true;
    let username = document.getElementById("userName").value;
    let passsword = document.getElementById("password").value;
    let usernameError = document.getElementById("userNameError");
    let passswordError = document.getElementById("passwordError");

    usernameError.textContent = "";
    passswordError.textContent = "";

    if (username.trim() === "") {
        usernameError.textContent = "userName cannot be empty";
        validInput = false;
    }

    if (passsword.trim() === "") {
        passswordError.textContent = "password cannot be empty";
        validInput = false;
    }

    return validInput;
}

function resetErrorMsg()
{
    document.getElementById("categoryError").innerHTML = " ";
}

function validateSubCategory() {
    let validSubCategory = true;
    let categoryName = document.getElementById("categoryNameSelect").value;
    let subCategoryName = document.getElementById("subCategoryName").value;

    let categorySelectError = document.getElementById("categorySelectError");
    let subCategoryNameError = document.getElementById("subCategoryNameError");

    categorySelectError.innerHTML = "";
    subCategoryNameError.innerHTML = "";

    if (categoryName === "" || categoryName === "--") {
        categorySelectError.innerHTML = "Category Cannot be Empty"
        validSubCategory = false;
    }
    if (subCategoryName.trim() === "") {
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
                alert("error occured in logout");
            }
        });
    }
});

$(document).on("click", function() {
    $("#user_error").hide();
});

$(".subcategoryAddbtn").click(function() {
    document.getElementById("categorySelectError").innerHTML = "";
    document.getElementById("subCategoryNameError").innerHTML = "";
});

function insertEditCategory() {
    let inputValue = $("#categoryInput").val();
    if (inputValue.trim() === "") {
        document.getElementById("categoryError").innerHTML = "Enter a Category Name";
        return;
    }
    let hiddenValue = $("#distinguishCreateEdit").val();
    if (hiddenValue.trim() === "") {
        $.ajax({
            url: 'components/ProductManagement.cfc?method=addCategory',
            data: {
                categoryName: inputValue
            },
            type: 'POST',
            success: function(response) {
                let result = JSON.parse(response);
                if (result.SUCCESS) {
                    $('#categoryModal').modal('hide');
                    location.reload();
                } else {
                    document.getElementById("categoryError").innerHTML = result.MESSAGE;
                }

            },
            error: function() {
                onsole.error("Error in insertion.");
            }
        });
    } else {
        $.ajax({
            url: 'components/ProductManagement.cfc?method=editCategory',
            data: {
                categoryId: hiddenValue,
                newcategory: inputValue
            },
            type: 'POST',
            success: function(response) {
                let result = JSON.parse(response);
                if (result.SUCCESS) {
                    $('#categoryModal').modal('hide');
                    location.reload();
                } else {
                    document.getElementById("categoryError").innerHTML = result.MESSAGE;
                }
            },
            error: function() {
                onsole.error("Error in deletion.");
            }
        });
    }
}

function editCategory(editBtn) {
    document.getElementById("categoryModalLabel").textContent = "Edit Category";

    $.ajax({
        url: 'components/ProductManagement.cfc?method=fetchAllCategories',
        data: {
            categoryId: editBtn.value
        },
        type: 'POST',
        success: function(result) {
            let parsedResult = JSON.parse(result);
            let categoryId = parsedResult.CATEGORIES[0].categoryId;
            let categoryName = parsedResult.CATEGORIES[0].categoryName;
            
            $.ajax({
                url: 'components/User.cfc?method=decryptId',
                data: {
                    encryptedId: categoryId
                },
                type: 'POST',
                success: function(decryptResult) {
                    let decryptedId = JSON.parse(decryptResult);
                    document.getElementById("categoryInput").value = categoryName;
                    document.getElementById("distinguishCreateEdit").value = decryptedId;
                },
                error: function() {
                    alert("Error decrypting category ID.");
                }
            });
        },
        error: function() {
            alert("Error fetching category data.");
        }
    });
}

function deleteCategory(dltBtn) {
    if (confirm("Are you sure you want to delete")) {

        $.ajax({
            url: 'components/ProductManagement.cfc?method=deleteCategory',
            type: 'POST',
            data: {
                categoryId: dltBtn.value
            },
            success: function() {
                document.getElementById(dltBtn.value).remove();
            },
            error: function() {
                alert("Error deleting category");
            }
        });
    }
}

function createCategory() {
    document.getElementById("categoryModalLabel").textContent = "Create Category";
    document.getElementById("categoryInput").value = "";
}

function editSubCategory(subCategory) {
    document.getElementById("subCategoryName").value = subCategory.subCategoryName;
    document.getElementById("subCategoryModalLabel").innerHTML = "Edit SubCategory";
    document.getElementById('distinguishSubCreateEdit').value = subCategory.subCategoryId;
}

$(".subcategoryAddbtn").click(function() {
    document.getElementById("subCategoryModalLabel").innerHTML = "Create SubCategory";
    document.getElementById("subCategoryName").value = "";
});

function deleteSubCategory(subCategoryId, categoryId) {
    if (confirm("Are you sure you want to delete")) {
        $.ajax({
            url: 'components/ProductManagement.cfc?method=DeleteSubCategory',
            type: 'POST',
            data: {
                subCategoryId: subCategoryId,
                categoryId: categoryId
            },
            success: function() {
                document.getElementById(subCategoryId).remove();
            },
            error: function() {
                alert("Error deleting SubCategory");
            }
        });
    }
}

$("#categoryNameSelectPr").change(function() {
    getSubcategory();
});

function getSubcategory(urlSubCategoryId){
    let categorySelected = $('#categoryNameSelectPr').val();
    let subCategoryElement = document.getElementById("selectSubCategory");
    if (categorySelected === "--") {
        categorySelected = "0";
    }
    if (categorySelected.trim() != "") {
        $.ajax({
            url: 'components/ProductManagement.cfc?method=fetchSubCategories',
            type: 'POST',
            data: {
                categoryId: categorySelected
            },
            success: function(result) {
                let subcategories = JSON.parse(result).SUBCATEGORY;
                subCategoryElement.innerHTML = "";
                for (let i = 0; i < subcategories.length; i++) {
                    let opt = document.createElement('option');
                    opt.value = subcategories[i].subCategoryId;
                    if(urlSubCategoryId != undefined)
                    {
                        if(urlSubCategoryId === opt.value)
                        {
                            opt.selected = true;
                        }
                    }
                    opt.innerHTML = subcategories[i].subCategoryName;
                    subCategoryElement.appendChild(opt);
                }
            },
            error: function() {
                alert("Error fetching SubCategory");
            }
        });
    }
}
function validateProduct() {
    let validProduct = true;
    let categoryName = document.getElementById("categoryNameSelectPr").value;
    let subCategoryName = document.getElementById("selectSubCategory").value;
    let productName = document.getElementById("productName").value;
    let brandName = document.getElementById("brandName").value;
    let productDesc = document.getElementById("productDesc").value;
    let unitPrice = document.getElementById("unitPrice").value;
    let unitTax = document.getElementById("unitTax").value;
    let productImage = document.getElementById("productImages");

    let categorySelectError = document.getElementById("categorySelectError");
    let subCategorySelectError = document.getElementById("subCategorySelectError");
    let productNameError = document.getElementById("productNameError");
    let brandNameError = document.getElementById("brandNameError");
    let productDescError = document.getElementById("productDescError");
    let unitPriceError = document.getElementById("unitPriceError");
    let unitTaxError = document.getElementById("unitTaxError");
    let productImageError = document.getElementById("productImageError");

    categorySelectError.innerHTML = "";
    subCategorySelectError.innerHTML = "";
    productNameError.innerHTML = "";
    brandNameError.innerHTML = "";
    productDescError.innerHTML = "";
    unitPriceError.innerHTML = "";
    unitTaxError.innerHTML = "";
    productImageError.innerHTML = "";

    if (categoryName.trim() === "" || categoryName.trim() === "--") {
        categorySelectError.innerHTML = "Select Any Category";
        validProduct = false;
    }

    if (subCategoryName.trim() === "" || subCategoryName.trim() === "--") {
        subCategorySelectError.innerHTML = "Select Any SubCategory";
        validProduct = false;
    }

    if (productName.trim() === "") {
        productNameError.innerHTML = "Enter the ProductName";
        validProduct = false;
    }

    if (brandName.trim() === "" || brandName.trim() === "--") {
        brandNameError.innerHTML = "Select Any Brand";
        validProduct = false;
    }

    if (productDesc.trim() === "") {
        productDescError.innerHTML = "Enter the pro Desc";
        validProduct = false;
    }

    if (unitPrice.trim() === "") {
        unitPriceError.innerHTML = "Enter the UnitPrice";
        validProduct = false;
    }

    if (unitTax.trim() === "") {
        unitTaxError.innerHTML = "Enter the unit Tax";
        validProduct = false;
    }

    return validProduct;
}

function createproduct(subCategoryId) {
    let categorySelectError = document.getElementById("categorySelectError");
    let subCategorySelectError = document.getElementById("subCategorySelectError");
    let productNameError = document.getElementById("productNameError");
    let brandNameError = document.getElementById("brandNameError");
    let productDescError = document.getElementById("productDescError");
    let unitPriceError = document.getElementById("unitPriceError");
    let unitTaxError = document.getElementById("unitTaxError");
    let productImageError = document.getElementById("productImageError");

    categorySelectError.innerHTML = "";
    subCategorySelectError.innerHTML = "";
    productNameError.innerHTML = "";
    brandNameError.innerHTML = "";
    productDescError.innerHTML = "";
    unitPriceError.innerHTML = "";
    unitTaxError.innerHTML = "";
    productImageError.innerHTML = "";
    document.getElementById('productForm').reset();
    getSubcategory(subCategoryId);
}

function editProduct(editObj) {
    let subCategoryElement = document.getElementById("selectSubCategory");
    $.ajax({
        url: 'components/ProductManagement.cfc?method=getProductDetails',
        data: {
            productId: editObj.productId
        },
        type: 'POST',
        success: function(result) {
            let product = JSON.parse(result);
            document.getElementById("productName").value = product.DATA.productName;
            document.getElementById("brandName").value = product.DATA.brandId;
            document.getElementById("productDesc").value = product.DATA.description;
            document.getElementById("unitPrice").value = product.DATA.unitPrice;
            document.getElementById("unitTax").value = product.DATA.unitTax;
            document.getElementById("categoryNameSelectPr").value = editObj.categoryId;
            document.getElementById("hiddenValue").value = editObj.productId;
            $.ajax({
                url: 'components/ProductManagement.cfc?method=fetchSubCategories',
                type: 'POST',
                data: {
                    categoryId: editObj.categoryId
                },
                success: function(result) {
                    let subcategories = JSON.parse(result).SUBCATEGORY;
                    subCategoryElement.innerHTML = "";
                    for (let i = 0; i < subcategories.length; i++) {
                        let opt = document.createElement('option');
                        opt.value = subcategories[i].subCategoryId;
                        opt.innerHTML = subcategories[i].subCategoryName;
                        subCategoryElement.appendChild(opt);
                    }
                },
                error: function() {
                    alert("Error fetching SubCategory");
                }
            });
        },
        error: function() {
            alert("Failed to edit product");
        }
    });
}

function deleteProduct(productId) {
    if (confirm("Are you sure you want to delete")) {
        $.ajax({
            url: 'components/ProductManagement.cfc?method=deleteProduct',
            type: 'POST',
            data: {
                productId: productId
            },
            success: function() {
                document.getElementById(productId).remove();
            },
            error: function() {
                alert("Failed to delete product");
            }
        });
    }
}

function editImages(productId) {
    $.ajax({
        url: 'components/ProductManagement.cfc?method=getProductDetails',
        data: {
            productId: productId
        },
        type: 'POST',
        success: function(result) {
            let productData = JSON.parse(result).DATA;
            let images = productData.images;
            let defaultImage = productData.defaultImagePath;
            $.ajax({
                url: 'components/User.cfc?method=decryptId',
                data: {
                    encryptedId: productId
                },
                type: 'POST',
                success: function(decryptResult) {
                    let decryptedId = JSON.parse(decryptResult);

                    let carouselContainer = document.getElementById("carouselContainer");
                    carouselContainer.innerHTML = '';

                    images.forEach((image, i) => {
                        let div = document.createElement("div");
                        div.setAttribute('class', image === defaultImage ? 'carousel-item active' : 'carousel-item');

                        const img = document.createElement('img');
                        img.src = `./Assets/uploads/product${decryptedId}/${image}`;
                        img.alt = `Product Image ${i + 1}`;

                        if (image !== defaultImage) {
                            let setThumbnailBtn = document.createElement('button');
                            setThumbnailBtn.innerHTML = "Set Thumbnail";
                            setThumbnailBtn.className = 'thumbnailBtn btn btn-success m-2';
                            setThumbnailBtn.onclick = function() {
                                setThumbnail(image, productId);
                            };

                            let deleteImageBtn = document.createElement('button');
                            deleteImageBtn.innerHTML = "Delete Image";
                            deleteImageBtn.className = 'deleteImageBtn btn btn-danger m-2';
                            deleteImageBtn.onclick = function() {
                                deleteProductImage(image, productId);
                            };

                            div.appendChild(setThumbnailBtn);
                            div.appendChild(deleteImageBtn);
                        }

                        div.appendChild(img);
                        carouselContainer.appendChild(div);
                    });
                },
                error: function() {
                    alert("Failed to decrypt product ID.");
                }
            });
        },
        error: function() {
            alert("Failed to fetch product details.");
        }
    });
}

function setThumbnail(productImage, productId) {
    $.ajax({
        url: 'components/ProductManagement.cfc?method=updateDefaultImage',
        type: 'POST',
        data: {
            productImage: productImage,
            productId: productId
        },
        success: function() {
            editImages(productId);
            location.reload()
        },
        error: function() {
            alert("Error setting thumbnail.");
        }
    });
}

function deleteProductImage(productImage, productId) {
    $.ajax({
        url: 'components/ProductManagement.cfc?method=deleteProductImage',
        type: 'POST',
        data: {
            productImage: productImage,
            productId: productId
        },
        success: function() {
            editImages(productId);
        },
        error: function() {
            alert("Error deleting image.");
        }
    });
}