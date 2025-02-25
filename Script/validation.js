// Helper function to set error messages
function setError(errorElementId, message) {
    document.getElementById(errorElementId).textContent = message;
}

function validateAdminLogin() {
    let validInput = true;
    let userName = document.getElementById("userName").value;
    let password = document.getElementById("password").value;
    let userNameError = "userNameError";
    let passwordError = "passwordError";

    // Clear previous error messages
    setError(userNameError, "");
    setError(passwordError, "");

    // Determine if userName is an email or phone number
    if (userName.includes("@")) {
        // Validate as email
        if (!isValidEmail(userName, userNameError)) {
            validInput = false;
        }
    } else {
        // Validate as phone number
        if (!isValidPhone(userName, userNameError)) {
            validInput = false;
        }
    }

    // Validate password
    if (!isValidPassword(password, passwordError)) {
        validInput = false;
    }

    return validInput;
}

function validateUserDetails()
{
    let validDetails = true;
    const firstName = document.getElementById("firstName").value;
    const lastName = document.getElementById("lastName").value;
    const userEmail = document.getElementById("userEmail").value;
    const userPhone = document.getElementById("userPhone").value;
    const userPassword = document.getElementById("userPassword").value;

    let firstNameError = firstNameError;
    let lastNameError = lastNameError;
    let userEmailError = userEmailError;
    let userPhoneError = userPhoneError;
    let userPasswordError = userPasswordError;

     setError(firstNameError, "");
     setError(lastNameError, "");
     setError(userEmailError, "");
     setError(userPhoneError, "");
     setError(userPasswordError, "");

    if (!isValidName(firstName, firstNameError)) {
        validDetails = false;
    }
    if (!isValidName(lastName, lastNameError)) {
        validDetails = false;
    }
    if(!isValidEmail(userEmail, userEmailError))
    {
        validDetails = false;
    }
    if(!isValidPhone(userPhone,userPhoneError))
    {
        validDetails = false;
    }
    if(!isValidPassword(userPassword,userPasswordError))
    {
        validDetails = false;
    }

    return validDetails;
}

function validateUserLogin() {
    let validUserInput = true;
    const userName = document.getElementById("userName").value.trim();
    const password = document.getElementById("userPassword").value.trim();

    let userNameError = userNameError;
    let userPasswordError = userPasswordError;
    setError(userNameError, "");
    setError(userPasswordError, "");

    if(!isValidName(userName,userNameError))
    {
        validUserInput = false;
    }

    if (userName === "") {
        document.getElementById("userNameError").innerHTML = "Enter the UserName";
        validUserInput = false;
    } else if (
        !isValidEmail(userName) && !isValidPhone(userName)
    ) {
        document.getElementById("userNameError").innerHTML = "UserName must be a valid email or phone number";
        validUserInput = false;
    }

    if (password === "") {
        document.getElementById("userPasswordError").innerHTML = "Enter the Password";
        validUserInput = false;
    }
    return validUserInput;
}

function isValidName(name, errorElementId) {
    if (name.trim() === "") {
        setError(errorElementId, "Name cannot be empty");
        return false;
    } else if (!/^[a-zA-Z]+$/.test(name)) {
        setError(errorElementId, "Invalid Name");
        return false;
    } else {
        setError(errorElementId, ""); // Clear error if valid
        return true;
    }
}

function isValidEmail(email, errorElementId) {
    if (email.trim() === "") {
        setError(errorElementId, "Email cannot be empty");
        return false;
    } else if (!(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email))) {
        setError(errorElementId, "Invalid Email");
        return false;
    } else {
        setError(errorElementId, ""); // Clear error if valid
        return true;
    }
}

function isValidPhone(phone, errorElementId) {
    if (phone.trim() === "") {
        setError(errorElementId, "Phone cannot be empty");
        return false;
    } else if (!(phone.length === 10 && /^\d+$/.test(phone))) {
        setError(errorElementId, "Invalid Phone (must be 10 digits)");
        return false;
    } else {
        setError(errorElementId, ""); // Clear error if valid
        return true;
    }
}

function isValidPassword(password, errorElementId) {
    if (password.trim() === "") {
        setError(errorElementId, "Password cannot be empty");
        return false;
    } else if (password.search(/[a-z]/i) < 0 || password.search(/[0-9]/) < 0 || password.length < 6) {
        setError(errorElementId, "Password must be at least 6 characters long & should contain 1 letter and digit");
        return false;
    } else {
        setError(errorElementId, ""); // Clear error if valid
        return true;
    }
}