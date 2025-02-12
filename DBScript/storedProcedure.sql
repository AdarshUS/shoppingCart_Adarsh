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
   
    SELECT COUNT(*) INTO cartItemCount 
    FROM tblCart 
    WHERE fldUserId = userId;

    IF cartItemCount = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cart is empty, order cannot be placed.';
    END IF;
   
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
  
    START TRANSACTION;
   
    INSERT INTO tblOrder (
        fldOrder_ID, fldUserId, fldAddressId, fldTotalPrice, fldTotalTax, fldCardNumber
    ) VALUES (
        orderId, userId, addressId, totalPrice, totalTax, cardPart
    );
    
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
   
    DELETE FROM tblCart WHERE fldUserId = userId;
  
    COMMIT;

END $$

DELIMITER ;
