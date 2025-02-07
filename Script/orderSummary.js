function decreaseQuantity() {
    let qnty = document.getElementById("orderInput").value;
    if (qnty == 1) {
        document.getElementById("decreaseQntyBtnCart").disabled = true;
        return;
    }
    let actualPrice = parseInt(document.getElementById("payableAmt").innerHTML) / qnty;
    qnty--;
    document.getElementById("orderInput").value = qnty;
    document.getElementById("payableAmt").innerHTML = actualPrice * qnty;
}

function increaseQuantity() {
    document.getElementById("decreaseQntyBtnCart").disabled = false;
    let qnty = document.getElementById("orderInput").value;
    let actualPrice = parseInt(document.getElementById("payableAmt").innerHTML) / qnty;
    qnty++;
    document.getElementById("orderInput").value = qnty;
    document.getElementById("payableAmt").innerHTML = actualPrice * qnty;
}

function checkout(addressId, productId, totalAmnt, unitPrice, totalTax) {
    let isValidData = true;
    let cardNumber = document.getElementById("cardNumber").value.trim();
    let cardYear = parseInt(document.getElementById("cardYear").value.trim(), 10);
    let cardMonth = parseInt(document.getElementById("cardMonth").value.trim(), 10);
    let cvv = document.getElementById("cardcvv").value.trim();
    let today = new Date();
    let qnty = document.getElementById("orderInput").value;

    document.getElementById("cardNoError").innerHTML = "";
    document.getElementById("cardMonthError").innerHTML = "";
    document.getElementById("cardCvvError").innerHTML = "";
    document.getElementById("cardYearError").innerHTML = "";

    if (cardNumber === "") {
        document.getElementById("cardNoError").innerHTML = "Enter Card Number";
        isValidData = false;
    } else if (!/^\d{16}$/.test(cardNumber)) {
        document.getElementById("cardNoError").innerHTML = "Enter valid 16-digit card number";
        isValidData = false;
    }

    if (isNaN(cardYear) || cardYear < today.getFullYear()) {
        document.getElementById("cardYearError").innerHTML = "Enter year";
        isValidData = false;
    }

    if (isNaN(cardMonth) || cardMonth < 1 || cardMonth > 12) {
        document.getElementById("cardMonthError").innerHTML = "Enter a valid month";
        isValidData = false;
    } else if (cardYear === today.getFullYear() && cardMonth < (today.getMonth() + 1)) {
        document.getElementById("cardMonthError").innerHTML = "expired date";
        isValidData = false;
    }

    if (cvv === "") {
        document.getElementById("cardCvvError").innerHTML = "Enter CVV";
        isValidData = false;
    } else if (!/^\d{3,4}$/.test(cvv)) {
        document.getElementById("cardCvvError").innerHTML = "Enter a valid CVV";
        isValidData = false;
    }

    if (isValidData) {
        $.ajax({
            url: 'components/User.cfc?method=ValidateCardDetails',
            type: 'POST',
            data: {
                number: cardNumber,
                month: cardMonth,
                year: cardYear,
                cvv: cvv
            },
            success: function(result) {
                let verifycardDetails = JSON.parse(result);

                if (verifycardDetails.success === true) {
                    if (productId.trim() === "") {
                        $.ajax({
                            url: 'components/cart.cfc?method=placeOrder',
                            type: 'POST',
                            data: {
                                addressId: addressId,
                                cardnumber: cardNumber
                            },
                            success: function(result) {
                                Swal.fire({
                                    position: "top-end",
                                    icon: "success",
                                    title: "Your order is confirmed",
                                    showConfirmButton: false,
                                    timer: 1500,
                                    imageUrl: "https://unsplash.it/400/200",
                                    imageWidth: 400,
                                    imageHeight: 200,
                                    imageAlt: "Custom image"
                                });
                            },
                            error: function() {

                            }
                        });
                    } else {
                        console.log(totalTax);
                        $.ajax({
                            url: 'components/cart.cfc?method=addOrder',
                            type: 'POST',
                            data: {
                                addressId: addressId,
                                cardnumber: cardNumber,
                                totalPrice: totalAmnt,
                                totalTax: totalTax,
                                productId: productId,
                                quantity: qnty,
                                unitPrice: unitPrice,
                                unitTax: totalTax
                            },
                            success: function(result) {
                                Swal.fire({
                                    position: "center",
                                    icon: "success",
                                    title: "Your order is confirmed",
                                    showConfirmButton: false,
                                    imageAlt: "Custom image"
                                });
                            },
                            error: function() {

                            }
                        });
                    }
                } else {
                    document.getElementById("cardVerify").innerHTML = verifycardDetails.message;
                }
            },
            error: function() {}
        });
    }
}

$('.place-order').click(function() {
    document.getElementById("cardNoError").innerHTML = "";
    document.getElementById("cardMonthError").innerHTML = "";
    document.getElementById("cardCvvError").innerHTML = "";
    document.getElementById("cardYearError").innerHTML = "";
})

function getOrderInvoicePdf(orderId)
{
     $.ajax({
        url: 'components/cart.cfc?method=getOrderHistoryPdf',
        type: 'POST',
        data: {
            orderId : orderId
        },
        success: function(result) {
            let jsonObj = JSON.parse(result);
            console.log(jsonObj.FILEPATH)
            console.log(jsonObj)
		    let a = document.createElement("a");
		    a.download = jsonObj.FILENAME;
		    a.href = jsonObj.FILEPATH;
		    a.click();
        },
        error: function()
        {

        }
        })
    
}