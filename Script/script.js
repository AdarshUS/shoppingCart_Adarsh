function resetErrorMsg() {
    document.getElementById("categoryError").innerHTML = " ";
}

$(".logout").click(function() {
    if (confirm("Are you sure you want to Logout")) {
        $.ajax({
            url: 'components/User.cfc?method=logoutUser',
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
    $(".subcategoryMsg").hide();
    $(".productMsg").hide();
});

function resetSubcategoryError() {
    document.getElementById("subCategoryNameError").innerHTML = "";
}

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

function getSubcategory(urlSubCategoryId) {
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
                    if (urlSubCategoryId != undefined) {
                        if (urlSubCategoryId === opt.value) {
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

function createproduct(subCategoryId) {
    getSubcategory(subCategoryId);
}

function resetProducterror() {
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
    document.getElementById("imageCntr").innerHTML = "";
    document.getElementById("productForm").reset();
    markedImages = [];
}

function setClassForDefault(imageId)
{
    alert("dd")
    $(".defaultImage").removeClass("defaultImage");
    document.getElementById(imageId).classList.add("defaultImage");
}
function editProduct(editObj) {
    let subCategoryElement = document.getElementById("selectSubCategory");
    let imageContainer = document.getElementById("imageCntr");
    let decryptedId;
    $.ajax({
        url: 'components/User.cfc?method=decryptId',
        data: {
            encryptedId: editObj.productId
        },
        type: 'POST',
        success: function(decryptResult) {
            decryptedId = JSON.parse(decryptResult);
            $.ajax({
                url: 'components/ProductManagement.cfc?method=getProductDetails',
                data: {
                    productId: editObj.productId
                },
                type: 'POST',
                success: function(result) {
                    let product = JSON.parse(result);
                    let defaultImage = product.DATA.defaultImagePath;
                    for (let i = 0; i < product.DATA.images.length; i++) {
                        let mainContainer = document.createElement('div');
                        mainContainer.classList.add("existingImage");
                        let imgBox = document.createElement('div');
                        imgBox.classList.add("imageBox");
                       
                        mainContainer.id = product.DATA.images[i].imageId;
                        let img = document.createElement('img');
                        img.classList.add("ProdImg");
                        img.src = `./Assets/uploads/product${decryptedId}/${product.DATA.images[i].imagePath}`;
                        imgBox.style.border = product.DATA.images[i].imagePath === defaultImage ? "2px solid green" : "1px solid gray";
                        imgBox.appendChild(img);
                        let dltBtn = document.createElement('div');
                        dltBtn.classList.add("deleteBtn");
                        imgBox.appendChild(dltBtn);
                        let imageControlsCntr = document.createElement('div');
                        imageControlsCntr.classList.add("imageControlsCntr");
                        let label = document.createElement('label');
                        label.innerHTML = "Set Default";
                        label.classList.add('imgLabel');
                        imageControlsCntr.appendChild(label);
                        let radioInput = document.createElement('input');
                        radioInput.onclick = function() {
                            setClassForDefault(product.DATA.images[i].imageId);
                        }
                        radioInput.setAttribute('type', 'radio');
                        radioInput.setAttribute('name', "defaultImg");
                        radioInput.setAttribute('value', `existing-${product.DATA.images[i].imageId}`);
                        radioInput.classList.add('setDefaultBtn');
                        imageControlsCntr.appendChild(radioInput);
                        if (product.DATA.images[i].imagePath === defaultImage) {
                            mainContainer.classList.add("defaultImage");
                            mainContainer.classList.add("currentImage");
                            radioInput.checked = true;
                            radioInput.classList.add("defaultImg");
                            label.innerHTML = "current default";
                        }
                            let removeBtn = document.createElement('i');
                            removeBtn.classList.add("fa-solid");
                            removeBtn.classList.add("fa-trash");
                            removeBtn.classList.add("removeBtn");
                      
                            removeBtn.onclick = function() {
                                markImagesForDeletion(product.DATA.images[i].imageId, product.DATA.images[i].imagePath, editObj.productId);
                            };
                            dltBtn.appendChild(removeBtn);
                        
                        mainContainer.appendChild(imgBox);
                        mainContainer.appendChild(imageControlsCntr);
                        imageContainer.appendChild(mainContainer);
                    }
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
                            subCategoryElement.value = editObj.subCategoryId;

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
    })

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

function deleteProductImage(productImageId, productImage, productId) {
    Swal.fire({
        title: "Are you sure you want to delete Image?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "remove"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: 'components/ProductManagement.cfc?method=deleteProductImage',
                type: 'POST',
                data: {
                    productImage: productImage,
                    productId: productId,
                    productImageId: productImageId
                },
                success: function() {
                    document.getElementById(productImageId).remove();
                },
                error: function() {
                    alert("Error deleting image.");
                }
            });
        }
    })
}

function readURL(input) {
    $(".newImage").remove();
    if (input.files && input.files.length > 0) {
        for (let i = 0; i < input.files.length; i++) {
            const reader = new FileReader();
            reader.onload = function(e) {
                let mainContainer = createImageContainer(imageId = "image"+i, imageSrc = e.target.result, isExisting = false, productId = null, imagePath = file.name);
                // let mainContainer = document.createElement('div');
                // mainContainer.classList.add("newImage");
                // mainContainer.id = "image" + i;
                // let imageBox = document.createElement('div');
                // imageBox.classList.add("imageBox");
                // let img = document.createElement("img");
                // img.classList.add("ProdImg");
                // img.src = e.target.result;
                // imageBox.appendChild(img);
                // let dltBtn = document.createElement('div');
                // dltBtn.classList.add("deleteBtn");
                // imageBox.appendChild(dltBtn);
                createDefaultImageControls(imageId = "image"+i, isDefault = , isExisting)
                let imageControlsCntr = document.createElement('div');
                imageControlsCntr.classList.add("imageControlsCntr");
                let label = document.createElement('label');
                label.innerHTML = "Set Default";
                label.classList.add('imgLabel')
                imageControlsCntr.appendChild(label);
                let radioInput = document.createElement('input');
                radioInput.onclick = function() {
                    setClassForDefault("image"+i);
                }
                radioInput.setAttribute('type', 'radio');
                radioInput.setAttribute('name', "defaultImg");
                radioInput.setAttribute('value', `new-${i}`);
                let radios = document.getElementsByName("defaultImg");
                let isChecked = Array.from(radios).some(radio => radio.checked);
                if (i === 0 && !isChecked) {
                    radioInput.checked = true;
                    mainContainer.classList.add("defaultImage");
                }
                let removeBtn = document.createElement('i');
                removeBtn.classList.add("fa-solid", "fa-trash","removeBtn");
                removeBtn.setAttribute("onclick", `deleteImage('${input.files[i].name}','image${i}')`);
                imageControlsCntr.appendChild(radioInput);
                dltBtn.appendChild(removeBtn);
                mainContainer.appendChild(imageBox);
                mainContainer.appendChild(imageControlsCntr);
                document.getElementById("imageCntr").appendChild(mainContainer);
            };
            reader.readAsDataURL(input.files[i]);
        }
    }

}

function createImageContainer(imageId, imageSrc, isExisting, productId, imagePath) {
    let mainContainer = document.createElement('div');
    mainContainer.classList.add(isExisting ? "existingImage" : "newImage");
    mainContainer.id = imageId;

    let imageBox = document.createElement('div');
    imageBox.classList.add("imageBox");
    let img = document.createElement("img");
    img.classList.add("ProdImg");
    img.src = imageSrc;
    imageBox.appendChild(img);

    let dltBtn = document.createElement('div');
    dltBtn.classList.add("deleteBtn");
    let removeBtn = document.createElement('i');
    removeBtn.classList.add("fa-solid", "fa-trash", "removeBtn");

    if (isExisting) {
        removeBtn.onclick = function() {
            markImagesForDeletion(imageId, imagePath, productId);
        };
    } else {
        removeBtn.onclick = function() {
            deleteImage(imagePath, imageId);
        };
    }

    dltBtn.appendChild(removeBtn);
    imageBox.appendChild(dltBtn);
    mainContainer.appendChild(imageBox);
    
    return mainContainer;
}

function createDefaultImageControls(imageId, isDefault, isExisting) {
    let imageControlsCntr = document.createElement('div');
    imageControlsCntr.classList.add("imageControlsCntr");

    let label = document.createElement('label');
    label.innerHTML = isDefault ? "Current Default" : "Set Default";
    label.classList.add('imgLabel');
    imageControlsCntr.appendChild(label);

    let radioInput = document.createElement('input');
    radioInput.onclick = function() {
        setClassForDefault(imageId);
    };
    radioInput.setAttribute('type', 'radio');
    radioInput.setAttribute('name', "defaultImg");
    radioInput.setAttribute('value', `${isExisting ? "existing" : "new"}-${imageId}`);

    if (isDefault) {
        radioInput.checked = true;
    }

    imageControlsCntr.appendChild(radioInput);
    return imageControlsCntr;
}



function deleteImage(fileName, ImageContainerId) {
    console.log(ImageContainerId);
    let imageData = new DataTransfer();
    let images = document.getElementById("productImages").files;
    for (let index = 0; index < images.length; index++) {
        if (images[index].name != fileName) {
            imageData.items.add(images[index]);
        }

    }
    document.getElementById("productImages").files = imageData.files;
    document.getElementById(ImageContainerId).remove();
    readURL(document.getElementById("productImages"));
}

let markedImages = [];
function markImagesForDeletion(productImageId,imagePath)
{
    if(!markedImages.includes(productImageId))
    {
        markedImages.push({imageId:productImageId,imagePath:imagePath});
        document.getElementById(productImageId).remove();
    }
}

$( "#productForm").on( "submit", function( event ) {
    let productId = document.getElementById("hiddenValue").value;
    if(markedImages.length > 0)
    {
        markedImages.forEach(productImage => {
            $.ajax({
                url: 'components/ProductManagement.cfc?method=deleteProductImage',
                type: 'POST',
                data: {
                    productImage: productImage.imagePath,
                    productId: productId,
                    productImageId: productImage.imageId
                },
                success: function() {
                    document.getElementById(productImageId).remove();
                },
                error: function() {
                    alert("Error deleting image.");
                }
            });
            
        })
    }
});