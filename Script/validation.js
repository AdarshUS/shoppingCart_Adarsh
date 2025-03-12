function setError(errorElementId, message) {
    document.getElementById(errorElementId).textContent = message;
}

function isEmpty(value, errorElementId, fieldName) {
    if (value.trim() === "") {
        setError(errorElementId, `${fieldName} cannot be empty`);
        return true; 
    }
    setError(errorElementId, "");
    return false;
}

function validateAdminLogin() {
    let validInput = true;
    let userName = document.getElementById("userName").value;
    let password = document.getElementById("password").value;
    let userNameError = "userNameError";
    let passwordError = "passwordError";
    
    setError(userNameError, "");
    setError(passwordError, "");
    
    if(isEmpty(userName,userNameError,"userName"))
    {
         validInput = false;
    }
   
    if(isEmpty(password,passwordError,"password"))
    {
        validInput = false;
    }
  
    return validInput;
}

function validateUserDetails() {
    let validDetails = true;
    const firstName = document.getElementById("firstName").value;
    const lastName = document.getElementById("lastName").value;
    const userEmail = document.getElementById("userEmail").value;
    const userPhone = document.getElementById("userPhone").value;
    const userPassword = document.getElementById("userPassword").value;

    let firstNameError = "firstNameError";
    let lastNameError = "lastNameError";
    let userEmailError = "userEmailError";
    let userPhoneError = "userPhoneError";
    let userPasswordError = "userPasswordError";
    
    if (isEmpty(firstName, firstNameError, "First Name")) {
        validDetails = false;
    }
    else if(!isValidName(firstName, firstNameError))
    {
        validDetails = false;
    }
    if (isEmpty(lastName, lastNameError, "Last Name")) {
        validDetails = false;
    }
    else if(!isValidName(lastName, lastNameError))
    {
         validDetails = false;
    }
    if (isEmpty(userEmail, userEmailError, "Email")) {
        validDetails = false;
    }
    else if(!isValidEmail(userEmail, userEmailError))
    {
        validDetails = false;
    }
    if (isEmpty(userPhone, userPhoneError, "Phone")) {
        validDetails = false;
    }
    else if(!isValidPhone(userPhone, userPhoneError))
    {
        validDetails = false;
    }
    if (isEmpty(userPassword, userPasswordError, "Password")) {
        validDetails = false;
    }
    else if(!isValidPassword(userPassword, userPasswordError))
    {
        validDetails = false;
    }

    return validDetails;
}

function validateUserLogin() {
    let validUserInput = true;
    const userName = document.getElementById("userName").value.trim();
    const password = document.getElementById("userPassword").value.trim();

    let userNameError = "userNameError";
    let userPasswordError = "userPasswordError";
    
    if (isEmpty(userName, userNameError, "Username")) {
        validUserInput = false;
    }
   
    if (isEmpty(password, userPasswordError, "Password")) {
        validUserInput = false;
    }
    
    return validUserInput;
}

function validateAddress() {
    let validAddress = true;
    const firstName = document.getElementById("firstName").value;
    const phone = document.getElementById("phone").value;
    const address1 = document.getElementById("address1").value;
    const city = document.getElementById("city").value;
    const state = document.getElementById("state").value;
    const pincode = document.getElementById("pincode").value;

    let firstNameError = "firstNameError"
    let phoneError = "phoneError"
    let address1Error = "address1Error"
    let cityError = "cityError"
    let stateError = "stateError"
    let pincodeError = "pincodeError"

    setError(firstNameError, "");
    setError(phoneError, "");
    setError(address1Error, "");
    setError(cityError, "");
    setError(stateError, "");
    setError(pincodeError, "");
    
    if (isEmpty(firstName, firstNameError, "First Name")) {
        validAddress = false;
    }
    else if(!isValidName(firstName, firstNameError))
    {
        validAddress = false;
    }
    if (isEmpty(phone, phoneError, "Phone")) {
        validAddress = false;
    }
    else if(!isValidPhone(phone, phoneError))
    {
        validAddress = false;
    }

    if(isEmpty(address1,address1Error,"Address1"))
    {
        validAddress = false;
    }
    if(isEmpty(city,cityError,"city"))
    {
        validAddress = false;
    }

    if(isEmpty(state,stateError,"state"))
    {
        validAddress = false;
    }

    if(isEmpty(pincode,pincodeError,"pincode"))
    {
        validAddress = false;
    }

    return validAddress;
}

function validateProfile()
{
    let isValid = true;
    const firstName = document.getElementById("userFirstName").value;
    const lastName = document.getElementById("userLastName").value;
    const email = document.getElementById("userEmail").value;
    const phone = document.getElementById("userPhone").value;

    let firstNameError = "userFirstNameError"
    let lastNameError = "userLastNameError"
    let emailError = "userEmailError"
    let phoneError = "userPhoneError"

    setError(firstNameError, "");
    setError(lastNameError, "");
    setError(emailError, "");
    setError(phoneError, "");

    if(isEmpty(firstName,firstNameError,"firstName"))
    {
        isValid = false;
    }
    else if(!isValidName(firstName,firstNameError))
    {
        isValid = false;
    }

    if(isEmpty(lastName,lastNameError,"lastName"))
    {
        isValid = false;
    }
    else if(!isValidName(lastName,lastNameError))
    {
        isValid = false;
    }

     if (isEmpty(email, emailError, "Email")) {
        isValid = false;
    }
    else if(!isValidEmail(email, emailError))
    {
        isValid = false;
    }

    if (isEmpty(phone, phoneError, "Phone")) {
        isValid = false;
    }
    else if(!isValidPhone(phone, phoneError))
    {
        isValid = false;
    }
    return isValid;
}

function validateProduct() {
    let validProduct = true;
    const categoryName = document.getElementById("categoryNameSelectPr").value;
    const subCategoryName = document.getElementById("selectSubCategory").value;
    const productName = document.getElementById("productName").value;
    const brandName = document.getElementById("brandName").value;
    const productDesc = document.getElementById("productDesc").value;
    const unitPrice = document.getElementById("unitPrice").value;
    const unitTax = document.getElementById("unitTax").value;
    const productImages = document.getElementById("productImages");
    const hiddenValue = document.getElementById("hiddenValue").value;
    const categorySelectError = "categorySelectError";
    const subCategorySelectError = "subCategorySelectError";
    const productNameError = "productNameError";
    const brandNameError = "brandNameError";
    const productDescError = "productDescError";
    const unitPriceError = "unitPriceError";
    const unitTaxError = "unitTaxError";
    const productImageError = "productImageError";
   
    setError(categorySelectError, "");
    setError(subCategorySelectError, "");
    setError(productNameError, "");
    setError(brandNameError, "");
    setError(productDescError, "");
    setError(unitPriceError, "");
    setError(unitTaxError, "");
    
    if (categoryName.trim() === "" || categoryName.trim() === "--") {
        setError(categorySelectError, "Select Any Category");
        validProduct = false;
    }
    
    if (subCategoryName.trim() === "" || subCategoryName.trim() === "--") {
        setError(subCategorySelectError, "Select Any SubCategory");
        validProduct = false;
    }
   
    if (isEmpty(productName, productNameError, "Product Name")) {
        validProduct = false;
    }
    
    if (brandName.trim() === "" || brandName.trim() === "--") {
        setError(brandNameError, "Select Any Brand");
        validProduct = false;
    }
   
    if (isEmpty(productDesc, productDescError, "Product Description")) {
        validProduct = false;
    }
    
    if (isEmpty(unitPrice, unitPriceError, "Unit Price")) {
        validProduct = false;
    } else if (isNaN(unitPrice) || unitPrice < 0) {
        setError(unitPriceError, "Unit Price must be a positive number");
        validProduct = false;
    }
    
    if (isEmpty(unitTax, unitTaxError, "Unit Tax")) {
        validProduct = false;
    } else if (isNaN(unitTax) || unitTax < 0 || unitTax > 100) {
        setError(unitTaxError, "Unit Tax must be between 0 and 100");
        validProduct = false;
    }

    if(!hiddenValue)
    {
        if (productImages.files.length === 0) {
        setError(productImageError, "select atleast one image");
        validProduct = false;
        }
        else{
            for (let index = 0; index < productImages.files.length; index++) {
                const image = productImages.files[index];
                if (!productImages.files[0].name.match(/\.(jpg|jpeg|png|gif|webp|svg)$/i))
                {
                    setError(productImageError, "Invalid image format");
                    validProduct = false;
                }
                
            }
        }
    }
    return validProduct;
}

function validateSubCategory() {
    let validSubCategory = true;
    
    const categoryName = document.getElementById("categoryNameSelect").value;
    const subCategoryName = document.getElementById("subCategoryName").value;
    
    const categorySelectError = "categorySelectError";
    const subCategoryNameError = "subCategoryNameError";
   
    setError(categorySelectError, "");
    setError(subCategoryNameError, "");
   
    if (categoryName === "" || categoryName === "--") {
        setError(categorySelectError, "Category Cannot be Empty");
        validSubCategory = false;
    }
    if (isEmpty(subCategoryName, subCategoryNameError, "Subcategory")) {
        validSubCategory = false;
    }
    return validSubCategory;
}

function isValidName(name, errorElementId) {
    
    if (!/^[a-zA-Z]+$/.test(name)) {
        setError(errorElementId, "Invalid Name");
        return false;
    } else {
        setError(errorElementId, "");
        return true;
    }
}

function isValidEmail(email, errorElementId) {
   
    if (!(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email))) {
        setError(errorElementId, "Invalid Email");
        return false;
    } else {
        setError(errorElementId, "");
        return true;
    }
}

function isValidPhone(phone, errorElementId) {
   
    if (!(phone.length === 10 && /^\d+$/.test(phone))) {
        setError(errorElementId, "Invalid Phone (must be 10 digits)");
        return false;
    } else {
        setError(errorElementId, "");
        return true;
    }
}

function isValidPassword(password, errorElementId) {
    
    if (password.search(/[a-z]/i) < 0 || password.search(/[0-9]/) < 0 || password.length < 6) {
        setError(errorElementId, "Password must be at least 6 characters long & should contain 1 letter and digit");
        return false;
    } else {
        setError(errorElementId, "");
        return true;
    }

}