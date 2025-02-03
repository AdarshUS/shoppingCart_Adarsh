function decreaseQuantity()
{
    let qnty = document.getElementById("orderInput").value;
    if(qnty == 1)
    {
        document.getElementById("decreaseQntyBtnCart").disabled = true;
        return;
    }
    let actualPrice = parseInt(document.getElementById("payableAmt").innerHTML)/qnty;
    qnty--;
    document.getElementById("orderInput").value = qnty;
    document.getElementById("payableAmt").innerHTML = actualPrice*qnty;
}

function increaseQuantity()
{
    document.getElementById("decreaseQntyBtnCart").disabled = false;
    let qnty = document.getElementById("orderInput").value;
    let actualPrice = parseInt(document.getElementById("payableAmt").innerHTML)/qnty;
    qnty++;
    document.getElementById("orderInput").value = qnty;
    document.getElementById("payableAmt").innerHTML = actualPrice*qnty;
}