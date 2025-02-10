<cfcomponent>
    <cffunction name="addCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryName" type="string" required="true">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfquery name="local.checkCategory" datasource="#application.datasource#">
                SELECT
                    count(*) AS categoryCount
                FROM
                    tblcategory
                WHERE
                    fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                    AND fldActive = 1;
            </cfquery>
            <cfif local.checkCategory.categoryCount>
                <cfset local.result.message = "Category Already Exist">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblcategory (
                        fldCategoryName,
                        fldCreatedBy
                    ) VALUES (
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">,
                        <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.result.success = true>
                <cfset local.result.message = "successful operation">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "error in function: addCategory", 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchAllCategories" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" required="false" type="numeric">
        <cfset local.result = {
            success = false,
            categories = [],
            message = ""
        }>
        <cftry>
            <cfquery name="local.fetchCategories" datasource="#application.datasource#">
                SELECT 
                    fldCategory_Id,
                    fldCategoryName,
                    fldCreatedBy
                FROM
                    tblcategory
                WHERE
                    fldActive = 1
                <cfif structKeyExists(arguments,"categoryId")>
                    AND
                    fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfif>
            </cfquery>
            <cfloop query="local.fetchCategories">
                <cfset arrayAppend(local.result.categories, {
                    "categoryId": application.objUser.encryptId(local.fetchCategories.fldCategory_Id),
                    "categoryName": local.fetchCategories.fldCategoryName
                })>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "Error in function: fetchAllCategories "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="editCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" required="true">
        <cfargument name="newCategory" required="true" type="string">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfquery name="checkExistingCategory" datasource="#application.datasource#">
                SELECT
                    count(*) AS categoryCount
                FROM
                    tblcategory
                WHERE
                    fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">
                    AND fldactive = 1
            </cfquery>
            <cfif checkExistingCategory.categoryCount>
                <cfset local.result.message = "this category Already Exist">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        tblcategory
                    SET
                        fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">,
                        fldUpdatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">,
                        fldUpdatedDate = now()
                    WHERE
                        fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                </cfquery>
                <cfset local.result.success = true>
                <cfset local.result.message = "successful Operation">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "Error in function: editCategory "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="deleteCategory" access="remote" returntype="void">
        <cfargument name="categoryId" required="true" type="string">
        <cfset local.decryptedCategoryId = application.objUser.decryptId(arguments.categoryId)>
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblcategory
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">,
                    fldUpdatedDate = now()
                WHERE
                    fldCategory_Id = <cfqueryparam value="#local.decryptedCategoryId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch type="any">
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject= "Error in function: deleteCategory "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addSubCategory" access="public" returntype="struct">
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subcategoryName"  type="string" required="true">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfquery name="local.checkSubCategory" datasource="#application.datasource#">
                SELECT
                    count(*) AS subcategoryCount
                FROM
                    tblsubcategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">
                    AND fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfif local.checkSubCategory.subcategoryCount>
                <cfset local.result.message = "SubCategory Already Exist"> 
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblsubcategory(
                            fldCategoryId
                            ,fldSubCategoryName
                            ,fldCreatedBy
                        )
                    VALUES(
                        <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">
                        ,<cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">
                        ,<cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                    )
                </cfquery>
                <cfset local.result.success = true>
                <cfset local.result.message = "successful Operation">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject= "Error in function: addSubCategory "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="string" required="false">
        <cfset local.decryptedCategoryId = application.objUser.decryptId(arguments.categoryId)>
        <cfset  local.result =
        {
            success = false,
            subcategory = [],
            message = ""
        }>
        <cftry>
            <cfquery  name="local.fetchSubCategories" datasource="#application.datasource#">
                SELECT 
                    fldSubCategory_Id
                    ,fldSubCategoryName
                    ,fldCreatedBy
               FROM
                    tblsubcategory
               WHERE
                    fldActive = 1
                    AND fldCategoryId = <cfqueryparam value="#local.decryptedCategoryId#" cfsqltype="varchar">
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful operation">
            <cfloop query="local.fetchSubCategories">
                <cfset arrayAppend(local.result.subcategory, {
                    "subCategoryId": application.objUser.encryptId(local.fetchSubCategories.fldSubCategory_Id),
                    "subCategoryName": local.fetchSubCategories.fldSubCategoryName
                })>
            </cfloop>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "Error in function: fetchSubCategories "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateSubCategory" access="public" returntype="struct">
        <cfargument name="subCategoryId" type="numeric" required="true">
        <cfargument name="newCategoryName" type="string" required="true">
        <cfargument name="categoryId" type="string" required="true">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery name="checkExistingSubCategory" datasource="#application.datasource#">
                SELECT
                    count(*) AS subCategoryCount
                FROM
                    tblsubcategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="varchar">
                    AND fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">
                    AND fldSubcategory_Id != #arguments.subCategoryId#
            </cfquery>
            <cfif checkExistingSubCategory.subCategoryCount>
                <cfset local.result.success = false>
                <cfset local.result.message = "this subcategory Already Exist">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        tblsubcategory
                    SET
                        fldSubCategoryName = <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="varchar">,
                        fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">,
                        fldUpdatedDate = now(),
                        fldUpdatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                    WHERE
                        fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                </cfquery>
                <cfset local.result.success = true>
                <cfset local.result.message = "successful Operation">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "Error in function: updateSubCategory "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="DeleteSubCategory" access="remote" returntype="void">
        <cfargument name="subCategoryId" type="string" required="true">
        <cfargument name="categoryId" type="string" required="true">
        <cfset local.decryptedSubCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        <cfset local.decryptedCategoryId = application.objUser.decryptId(arguments.categoryId)>
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblsubcategory
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">,
                    fldUpdatedDate = now()
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">
                    AND fldCategoryId = <cfqueryparam value="#local.decryptedCategoryId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset sendErrorEmail(
                subject = "Error in function: DeleteSubCategory "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="addProduct" access="public" returntype="void">
        <cfargument name="subCategoryId" required="true" type="string">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="string">
        <cfargument name="description" required="true" type="string">
        <cfargument  name="unitPrice" required="true" type="integer">
        <cfargument name="unitTax" required="true" type="integer" >
        <cfargument name="productImages" required="true" type="string">
        <cfset local.result = {success = false}>
        <cfset local.decryptedSubCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        <cfset local.decryptedBrandId = application.objUser.decryptId(arguments.brandId)>
        <cftry>
            <cfquery result="product" datasource="#application.datasource#">
                INSERT INTO tblproduct (
                        fldSubCategoryId
                        ,fldProductName
                        ,fldBrandId
                        ,fldDescription
                        ,fldUnitPrice
                        ,fldUnitTax
                        ,fldCreatedBy
                    )
                VALUES(
                    <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.productName#" cfsqltype="varchar">
                    ,<cfqueryparam value="#decryptedBrandId#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.description#" cfsqltype="varchar">
                    ,<cfqueryparam value="#arguments.unitPrice#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.unitTax#" cfsqltype="integer">
                    ,<cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                )
            </cfquery>
            <cfset productDirectory = expandPath('Assets/uploads/product'&product.GENERATEDKEY)>
            <cfdirectory action="create" directory="#productDirectory#">
            <cfset local.newPath = uploadFile(productImages = arguments.productImages,productDirectory = productDirectory)>
            <cfloop array="#local.newPath#" index="i"  item="image">
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblproductimages (
                        fldProductId
                        ,fldImageFilePath
                        ,fldCreatedBy
                        ,fldDefaultImage
                        )
                    VALUES(
                        <cfqueryparam value="#product.GENERATEDKEY#" cfsqltype="integer">,
                        <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                        <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="varchar">,
                        <cfif i EQ 1>
                            <cfqueryparam value=1 cfsqltype="integer">
                        <cfelse>
                            <cfqueryparam value=0 cfsqltype="integer">
                        </cfif>
                    )
                </cfquery>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
                subject = "Error in function: addProduct "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchBrands" access="public"  returntype="struct" >
        <cfset  local.result={
            success = false,
            brands = [],
            message = ""
        }>
        <cftry>
            <cfquery  name="local.fetchBrands" datasource="#application.datasource#">
                SELECT
                    fldBrand_Id
                    ,fldBrandName
                FROM
                    tblbrand
            </cfquery>
            <cfloop query="local.fetchBrands">
                <cfset arrayAppend(local.result.brands, {
                    "brandId": application.objUser.encryptId(local.fetchBrands.fldBrand_Id),
                    "brandName": local.fetchBrands.fldBrandName
                })>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
                 subject = "Error in function: fetchBrands "&cfcatch.message, 
                 body = "#cfcatch#"
             )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchProducts" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="subCategoryId" type="string" required="false">
        <cfargument name="priceRange" type="string" required="false">
        <cfargument name="limit" type="integer" required="false">
        <cfargument name="searchText" type="string" required="false" >
        <cfargument name="sort" type="string" required="false">
        <cfargument name="random" type="string" required="false">
        <cfif structKeyExists(arguments,"subCategoryId")>
            <cfset local.decryptedSubCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        </cfif>
        <cfset local.result = {
            "success": false,
            "products": [],
            "message":""
         }>
        <cftry>
            <cfquery name="local.fetchProducts" datasource="#application.datasource#">
                SELECT
                    P.fldProduct_Id,
                    P.fldSubCategoryId,
                    P.fldProductName,
                    B.fldBrandName,
                    P.fldDescription,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    PI.fldImageFilePath,
                    SC.fldSubCategoryName
                FROM
                    tblproduct P
                INNER JOIN
                    tblbrand B ON P.fldBrandId = B.fldBrand_Id
                INNER JOIN 
                    tblsubcategory SC ON P.fldSubCategoryId = SC.fldSubCategory_Id
                LEFT JOIN 
                    tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                    AND PI.fldDefaultImage = 1
                WHERE
                    P.fldActive = 1
                    <cfif structKeyExists(arguments, "subCategoryId") AND arguments.subCategoryId NEQ 0>
                        AND P.fldSubCategoryId = <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "priceRange") AND arguments.priceRange NEQ 0>
                        AND P.fldUnitPrice BETWEEN #arguments.priceRange#
                    </cfif>
                    <cfif structKeyExists(arguments, "searchText") AND len(arguments.searchText)>
                        AND (P.fldDescription LIKE "%#arguments.searchText#%" 
                            OR B.fldBrandName LIKE "%#arguments.searchText#%" 
                            OR P.fldProductName LIKE "%#arguments.searchText#%"
                            OR  SC.fldSubCategoryName LIKE "%#arguments.searchText#%")
                    </cfif>
                    <cfif structKeyExists(arguments,"sort") AND arguments.sort EQ "ASC">
                        ORDER BY fldUnitPrice ASC
                    <cfelseif structKeyExists(arguments,"sort") AND arguments.sort EQ "DESC">
                        ORDER BY fldUnitPrice DESC
                    </cfif>
                    <cfif structKeyExists(arguments,"limit") AND len(arguments.limit)>
                        LIMIT #arguments.limit#;
                    </cfif>
                    <cfif structKeyExists(arguments,"random")>
                        ORDER BY RAND() 
                        LIMIT 4;
                    </cfif>
            </cfquery>
            <cfif local.fetchProducts.recordCount gt 0>
                <cfloop query="local.fetchProducts">
                    <cfset arrayAppend(local.result.products, {
                        "productId": application.objUser.encryptId(local.fetchProducts.fldProduct_Id),
                        "subCategoryId": application.objUser.encryptId(local.fetchProducts.fldSubCategoryId),
                        "productName": local.fetchProducts.fldProductName,
                        "brandName": local.fetchProducts.fldBrandName,
                        "description": local.fetchProducts.fldDescription,
                        "unitPrice": local.fetchProducts.fldUnitPrice,
                        "unitTax": local.fetchProducts.fldUnitTax,
                        "imageFilePath": local.fetchProducts.fldImageFilePath,
                        "subcategoryName": local.fetchProducts.fldSubCategoryName
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
            subject = "Error in function: fetchProducts "&cfcatch.message, 
            body = "#cfcatch#"
        )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="getProductDetails" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="productId" required="true" type="string">
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cfset local.result = {
            success: false,
            message: "",
            data: {}
        }>
        <cfset local.images = []>
        <cfset local.defaultImagePath = "">
        <cftry>
            <cfquery name="local.fetchProduct" datasource="#application.datasource#">
                SELECT
                    TP.fldProduct_Id,
                    TP.fldProductName,
                    TP.fldDescription,
                    TP.fldUnitPrice,
                    TP.fldUnitTax,
                    TPI.fldImageFilePath,
                    TPI.fldDefaultImage,
                    TB.fldBrandName,
                    TB.fldBrand_Id,
                    TC.fldCategory_Id,
                    TC.fldCategoryName,
                    SC.fldSubCategoryName,
                    TP.fldSubCategoryId
                FROM
                    tblproduct AS TP
                INNER JOIN
                    tblbrand AS TB ON TB.fldBrand_Id = TP.fldBrandId
                INNER JOIN
                    tblsubcategory AS SC ON SC.fldSubCategory_Id = TP.fldSubCategoryId
                INNER JOIN
                    tblcategory AS TC ON TC.fldCategory_Id = SC.fldCategoryId
                LEFT JOIN
                    tblProductImages AS TPI ON TP.fldProduct_Id = TPI.fldProductId
                WHERE
                    TP.fldProduct_Id = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
                    AND TP.fldActive = 1
                    AND TPI.fldActive = 1
            </cfquery>
    
            <cfif local.fetchProduct.recordCount>
                <cfloop query="local.fetchProduct">
                    <cfif local.fetchProduct.fldImageFilePath NEQ "">
                        <cfset arrayAppend(local.images, local.fetchProduct.fldImageFilePath)>
                    </cfif>
                    <cfif local.fetchProduct.fldDefaultImage EQ 1>
                        <cfset local.defaultImagePath = local.fetchProduct.fldImageFilePath> 
                    </cfif>
                </cfloop>
    
                <cfif local.defaultImagePath EQ "" AND arrayLen(local.images) GT 0>
                    <cfset local.defaultImagePath = local.images[1]> 
                </cfif>
                <cfset local.result.success = true>
                <cfset local.result.message = "Successful operation">
                <cfset local.result.data = {
                    "productId": application.objUser.encryptId(local.fetchProduct.fldProduct_Id),
                    "productName": local.fetchProduct.fldProductName,
                    "description": local.fetchProduct.fldDescription,
                    "unitPrice": local.fetchProduct.fldUnitPrice,
                    "unitTax": local.fetchProduct.fldUnitTax,
                    "images": local.images,
                    "defaultImagePath": local.defaultImagePath,
                    "brandName": local.fetchProduct.fldBrandName,
                    "brandId": application.objUser.encryptId(local.fetchProduct.fldBrand_Id),
                    "categoryName": local.fetchProduct.fldCategoryName,
                    "categoryId": application.objUser.encryptId(local.fetchProduct.fldCategory_Id),
                    "subcategoryName": local.fetchProduct.fldSubCategoryName,
                    "subcategoryId": application.objUser.encryptId(local.fetchProduct.fldSubCategoryId)
                }>
            <cfelse>
                <cfset local.result.message = "No product found">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "An error occurred">
            <cfset sendErrorEmail(
                subject = "Error in function: getProductDetails "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateProduct" access="public" returntype="void">
        <cfargument name="productId" required="true" type="string">
        <cfargument name="subCategoryId" required="true" type="string">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="string">
        <cfargument name="productDescription" required="true" type="string">
        <cfargument name="unitPrice" required="true" type="integer">
        <cfargument name="unitTax" required="true" type="integer">
        <cfargument name="productImages" required="true" type="string">
        <cfset local.decryptedProductId = int(application.objUser.decryptId(arguments.productId))>
        <cfset local.decryptedSubCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        <cfset local.decryptedBrandId = application.objUser.decryptId(arguments.brandId)>
        <cfset local.structProduct = {
            "success": false,
            "message": ""
        }>
        <cftry>
            <cfquery name = "local.checkExistingProduct" datasource="#application.datasource#">
                SELECT
                    fldproduct_Id
                FROM
                    tblproduct
                WHERE
                    fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">
                    AND fldSubCategoryId = <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">
                    AND fldactive = 1
            </cfquery>
            <cfif local.checkExistingProduct.RecordCount AND local.checkExistingProduct.fldProduct_Id NEQ local.decryptedProductId>
                <cfset local.structProduct.message = "product Already Exist">
            <cfelse>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        tblproduct
                    SET
                        fldSubCategoryId = <cfqueryparam value = #local.decryptedSubCategoryId# cfsqltype="integer">,
                        fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">,
                        fldBrandId = <cfqueryparam value = #local.decryptedBrandId# cfsqltype="integer">,
                        fldDescription = <cfqueryparam value = #arguments.productDescription# cfsqltype="varchar">,
                        fldUnitPrice = <cfqueryparam value = #arguments.unitPrice# cfsqltype="integer">,
                        fldUnitTax = <cfqueryparam value = #arguments.unitTax# cfsqltype="integer">,
                        fldUpdatedBy = <cfqueryparam value = #application.objUser.decryptId(session.loginAdminId)# cfsqltype="integer">,
                        fldUpdatedDate = now()
                    WHERE
                        fldProduct_Id = <cfqueryparam value="#local.decryptedProductId#">
                </cfquery>
                <cfif LEN(arguments.productImages)>
                    <cfset insertProductImages(local.decryptedProductId, arguments.productImages, local.adminId)>
                </cfif>
                <cfset local.structProduct.success = true>
                <cfset local.structProduct.message = "successful Operation">
            </cfif>
        <cfcatch>
            <cfset local.structProduct = {"message": cfcatch.message}>
            <cfset sendErrorEmail(
                subject = "Error in function: updateProduct "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="insertProductImages" access="private" returntype="void">
        <cfargument name="productId" required="true" type="numeric">
        <cfargument name="productImages" required="true" type="string">
        <cfargument name="adminId" required="true" type="numeric">

        <cfset local.productDirectory = expandPath('Assets/uploads/product' & arguments.productId)>
        <cfset local.newPath = uploadFile(productImages = arguments.productImages, productDirectory = local.productDirectory)>

        <cfloop array="#local.newPath#" index="image">
            <cfif structKeyExists(image, "serverFile")>
                <cfquery datasource="#application.datasource#">
                    INSERT INTO tblproductimages (
                        fldProductId, fldImageFilePath, fldCreatedBy, fldDefaultImage
                    ) VALUES (
                        <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                        <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                        <cfqueryparam value="#arguments.adminId#" cfsqltype="integer">,
                        0
                    )
                </cfquery>
            </cfif>
        </cfloop>
    </cffunction>

    <cffunction name="deleteProduct" access="remote" returntype="void">
        <cfargument name="productId" required="true" type="string">
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery datasource = "#application.datasource#">
                UPDATE
                    tblproduct
                SET
                    fldActive = 0,
                    fldUpdatedBy = <cfqueryparam value = #application.objUser.decryptId(session.loginAdminId)# cfsqltype="integer">,
                    fldUpdatedDate = now()
                WHERE
                    fldProduct_Id  = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset sendErrorEmail(
                subject = "Error in function: deleteProduct "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="updateDefaultImage" access="remote" returntype="void">
        <cfargument name="productImage" required="true" type="string">
        <cfargument name="productId" required="true" type="string">
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 0
                WHERE
                    fldProductId = <cfqueryparam  value="#local.decryptedProductId#" cfsqltype="integer">
                    AND fldDefaultImage = 1
            </cfquery>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblproductimages
                SET
                    fldDefaultImage = 1
                WHERE
                    fldImageFilePath = <cfqueryparam value = #arguments.productImage# cfsqltype="varchar">
                    AND fldDefaultImage = 0
            </cfquery>
        <cfcatch>
            <cfset sendErrorEmail(
                subject = "Error in function: updateDefaultImage "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteProductImage" access="remote" returntype="void">
        <cfargument name="productImage" required="true" type="string">
        <cfargument name="productId" required="true" type="string">
        <cfset local.decryptedProductId =  application.objUser.decryptId(arguments.productId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblproductimages
                SET
                    fldActive = 0,
                    fldDeactivatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="varchar">,
                    fldDeactivatedDate = now()
                WHERE
                    fldImageFilePath = <cfqueryparam value="#arguments.productImage#" cfsqltype="varchar">
                    AND fldActive = 1
            </cfquery>
            <cfset local.imagePath = expandPath('../Assets/uploads/product' & local.decryptedProductId & '/' & arguments.productImage)>
            <cffile
             action = "delete"
             file = "#local.imagePath#"
            >
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset sendErrorEmail(
                subject = "Error in function: deleteProductImage "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>
  
    <cffunction name="sendErrorEmail" access="public" returntype="void" output="false">
        <cfargument name="subject" type="string" required="true">
        <cfargument name="body" type="any" required="true">
        <cfset local.sender = "adarshus1999@gmail.com">
        <cfset local.receiverAddress = "adarsh.us@techversantinfotech.com">
        <cfset local.errorMessage = "">
        <cfset local.errorMessage = 
            "Error Type: #arguments.body.type#<br>
            Message: #arguments.body.message#<br>
            Detail: #arguments.body.detail#<br>
            StackTrace: #arguments.body.stackTrace#">
        <cfmail 
            from = "#local.sender#" 
            to = "#local.receiverAddress#" 
            subject = "#arguments.subject#" 
            type="html">
            #local.errorMessage#
        </cfmail>
    </cffunction>

    <cffunction name="uploadFile" access="public" returntype="array">
        <cfargument name="productImages" type="string" required="true">
        <cfargument name="productDirectory" type="string" required="true">
        <cfset var result = {}>
        <cffile 
            action="uploadall" 
            destination="#arguments.productDirectory#" 
            nameconflict="MakeUnique" 
            filefield="#arguments.productImages#" 
            allowedExtensions="jpg,png,gif,jpeg,webp" 
            strict="true" 
            result="local.newPath"
        >
        <cfset result = local.newPath>
    <cfreturn result>
    </cffunction>
</cfcomponent>


