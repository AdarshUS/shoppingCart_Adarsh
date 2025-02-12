DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `placeOrder`(
    IN userId INTEGER,
    IN addressId INTEGER,
    IN cardPart INTEGER,
    IN orderId VARCHAR(64)
)
BEGIN
    DECLARE totalPrice DECIMAL(10, 2);
    DECLARE totalTax DECIMAL(10, 2);
    DECLARE cartItemCount INTEGER;

    -- Check if the user's cart has items
    SELECT COUNT(*) INTO cartItemCount 
    FROM tblCart 
    WHERE fldUserId = userId;

    IF cartItemCount = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cart is empty, order cannot be placed.';
    END IF;

    -- Calculate total price and tax
    SELECT 
        IFNULL(SUM(C.fldQuantity * P.fldunitPrice), 0),
        IFNULL(SUM(C.fldQuantity * (P.fldunitPrice * P.fldunitTax)/100), 0)
    INTO 
        totalPrice, 
        totalTax
    FROM 
        tblCart C
    INNER JOIN tblProduct P 
        ON P.fldProduct_ID = C.fldProductId 
        AND P.fldActive = 1
    WHERE 
        C.fldUserId = userId;

    -- Start transaction to ensure atomicity
    START TRANSACTION;

    -- Insert order details
    INSERT INTO tblOrder (
        fldOrder_ID, fldUserId, fldAddressId, fldTotalPrice, fldTotalTax, fldCardNumber
    ) VALUES (
        orderId, userId, addressId, totalPrice, totalTax, cardPart
    );

    -- Insert order items
    INSERT INTO tblOrderItems (
        fldOrderId, fldProductId, fldQuantity, fldUnitPrice, fldUnitTax
    ) 
    SELECT
        orderId, C.fldProductId, C.fldQuantity, P.fldunitPrice, P.fldunitTax
    FROM
        tblCart C
    INNER JOIN tblProduct P 
        ON P.fldProduct_ID = C.fldProductId 
        AND P.fldActive = 1
    WHERE
        C.fldUserId = userId;

    -- Delete items from cart after successful order placement
    DELETE FROM tblCart WHERE fldUserId = userId;

    -- Commit transaction
    COMMIT;

END $$

DELIMITER ;
