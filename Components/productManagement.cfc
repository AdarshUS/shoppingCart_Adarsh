<cfcomponent>
    <cffunction name="addCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryName" type="string" required="true">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfif LEN(trim(arguments.categoryName))>
                <cfquery name="local.checkCategoryExist" datasource="#application.datasource#">
                    SELECT
                        count(*) AS categoryCount
                    FROM
                        tblcategory
                    WHERE
                        fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                        AND fldActive = 1;
                </cfquery>
                <cfif local.checkCategoryExist.categoryCount>
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
            <cfelse>
                <cfset local.result.message = "empty CategoryName">
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
        <cfargument name="categoryId" required="true" type="integer">
        <cfargument name="newCategory" required="true" type="string">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cftry>
            <cfif LEN(trim(arguments.newCategory))>
                <cfquery name="checkExistingCategory" datasource="#application.datasource#">
                    SELECT
                        count(*) AS categoryCount
                    FROM
                        tblcategory
                    WHERE
                        fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">
                        AND fldCategory_Id != <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
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
            <cfelse>
                <cfset local.result.message = "empty category">
            </cfif>
        <cfcatch>
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
        <cftry>
            <cfset local.adminId = application.objUser.decryptId(session.loginAdminId)>
            <cfquery datasource="#application.datasource#">
                UPDATE 
                    tblcategory C
                    LEFT JOIN tblsubcategory SC ON SC.fldCategoryId = C.fldCategory_Id
                    LEFT JOIN tblproduct P ON P.fldSubcategoryId = SC.fldSubcategory_Id
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                SET 
                    C.fldActive = 0,
                    C.fldUpdatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    C.fldUpdatedDate = #now()#,
                    SC.fldActive = 0,
                    SC.fldUpdatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    SC.fldUpdatedDate = #now()#,
                    P.fldActive = 0,
                    P.fldUpdatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    P.fldUpdatedDate = #now()#,
                    PI.fldActive = 0,
                    PI.fldDeactivatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    PI.fldDeactivatedDate = #now()#
                WHERE
                    C.fldCategory_Id = <cfqueryparam value = "#application.objUser.decryptId(arguments.categoryId)#" cfsqltype = "integer">
                    AND C.fldActive = 1;
            </cfquery>
        <cfcatch type="any">
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
            <cfif LEN(trim(arguments.subcategoryName))>
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
                                fldCategoryId,
                                fldSubCategoryName,
                                fldCreatedBy
                            )
                        VALUES(
                            <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.subcategoryName#" cfsqltype="varchar">,
                            <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                        )
                    </cfquery>
                    <cfset local.result.success = true>
                    <cfset local.result.message = "successful Operation">
                </cfif>
            <cfelse>
                <cfset local.result.message = "empty subCategoryName">
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
        <cfset  local.result =
        {
            success = false,
            subcategory = [],
            message = ""
        }>
        <cftry>
            <cfquery  name="local.fetchSubCategories" datasource="#application.datasource#">
                SELECT
                    fldSubCategory_Id,
                    fldSubCategoryName,
                    fldCategoryId,
                    fldCreatedBy
                FROM
                    tblsubcategory
                WHERE
                    fldActive = 1
                <cfif structKeyExists(arguments,"categoryId")>
                    AND fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">
                </cfif>
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful operation">
            <cfloop query="local.fetchSubCategories">
                <cfset arrayAppend(local.result.subcategory, {
                    "subCategoryId": application.objUser.encryptId(local.fetchSubCategories.fldSubCategory_Id),
                    "subCategoryName": local.fetchSubCategories.fldSubCategoryName,
                    "categoryId": application.objUser.encryptId(local.fetchSubCategories.fldCategoryId)
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
        <cfargument name="newSubCategoryName" type="string" required="true">
        <cfargument name="categoryId" type="string" required="true">
        <cfset local.result = {success = false}>
        <cftry>
            <cfif LEN(trim(arguments.newSubCategoryName))>
                <cfquery name="local.checkExistingSubCategory" datasource="#application.datasource#">
                    SELECT
                        1
                    FROM
                        tblsubcategory
                    WHERE
                        fldSubCategoryName = <cfqueryparam value="#arguments.newSubCategoryName#" cfsqltype="varchar">
                        AND fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">
                        AND fldSubcategory_Id != <cfqueryparam value="#application.objUser.decryptId(arguments.subCategoryId)#" cfsqltype="integer">
                </cfquery>
                <cfif local.checkExistingSubCategory.RecordCount>
                    <cfset local.result.success = false>
                    <cfset local.result.message = "this subcategory Already Exist">
                <cfelse>
                    <cfquery datasource="#application.datasource#">
                        UPDATE
                            tblsubcategory
                        SET
                            fldSubCategoryName = <cfqueryparam value="#arguments.newSubCategoryName#" cfsqltype="varchar">,
                            fldCategoryId = <cfqueryparam value="#application.objUser.decryptId(arguments.categoryId)#" cfsqltype="integer">,
                            fldUpdatedDate = now(),
                            fldUpdatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                        WHERE
                            fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                    </cfquery>
                    <cfset local.result.success = true>
                    <cfset local.result.message = "successful Operation">
                </cfif>
            <cfelse>
                <cfset local.result.message = "empty subcategoryName">
            </cfif>
        <cfcatch>
            <cfset local.result.message = "error occured">
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
        <cfset local.result = {success = false}>
        <cftry>
            <cfset local.adminId = application.objUser.decryptId(session.loginAdminId)>
            <cfquery datasource="#application.datasource#">
                UPDATE 
                    tblsubcategory SC
                    LEFT JOIN tblproduct P ON P.fldSubcategoryId = SC.fldSubcategory_Id
                    LEFT JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                SET 
                    SC.fldActive = 0,
                    SC.fldUpdatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    SC.fldUpdatedDate = #now()#,
                    P.fldActive = 0,
                    P.fldUpdatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    P.fldUpdatedDate = #now()#,
                    PI.fldActive = 0,
                    PI.fldDeactivatedBy = <cfqueryparam value = "#local.adminId#" cfsqltype = "integer">,
                    PI.fldDeactivatedDate = #now()#
                WHERE
                    SC.fldSubCategory_Id = <cfqueryparam value = "#application.objUser.decryptId(arguments.subCategoryId)#" cfsqltype = "integer">
                    AND SC.fldCategoryId = <cfqueryparam value = "#application.objUser.decryptId(arguments.categoryId)#" cfsqltype = "integer">
                    AND SC.fldActive = 1;
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

    <cffunction name="updateDefaultImage" access="public" returntype="void">
        <cfargument name="defaultImageIndex" required="true" type="string">
        <cfargument name="productId" required="true" type="string">
        <cfset local.productId = application.objUser.decryptId(arguments.productId)>
        <cftry>
            <cftransaction>
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        tblproductimages
                    SET
                        fldDefaultImage = 0
                    WHERE
                        fldProductId = <cfqueryparam  value="#local.productId#" cfsqltype="integer">
                        AND fldDefaultImage = 1
                </cfquery>
                <cfif findNoCase("existing",arguments.defaultImageIndex)>
                    <cfset local.encryptedProductImageId = listLast(arguments.defaultImageIndex,"-")>
                    <cfset local.ProductImageId = application.objUser.decryptId(local.encryptedProductImageId)>
                    <cfquery datasource="#application.datasource#" result="local.updateDefaultImage">
                        UPDATE
                            tblproductimages
                        SET
                            fldDefaultImage = 1
                        WHERE
                            fldProductImage_Id = <cfqueryparam value="#local.ProductImageId#" cfsqltype="integer">
                            AND fldDefaultImage = 0
                    </cfquery>
                    <cfif local.updateDefaultImage.recordCount EQ 0>
                        <cftransaction action = "rollback">
                    </cfif>
                </cfif>
            </cftransaction>
        <cfcatch>
            <cfset sendErrorEmail(
                subject = "Error in function: updateDefaultImage "&cfcatch.message, 
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addProduct" access="public" returntype="struct">
        <cfargument name="subCategoryId" required="true" type="string">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="string">
        <cfargument name="description" required="true" type="string">
        <cfargument  name="unitPrice" required="true" type="integer">
        <cfargument name="unitTax" required="true" type="integer" >
        <cfargument name="productImages" required="true" type="string">
        <cfargument name="defaultImageIndex" required="true" type="string">
        <cfset local.result = {
            success = false,
            message = ""
        }>
        <cfset local.decryptedSubCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        <cfset local.decryptedBrandId = application.objUser.decryptId(arguments.brandId)>
        <cftry>
            <cfif len(trim(arguments.subCategoryId))
                AND len(trim(arguments.productName))
                AND len(trim(arguments.brandId))
                AND len(trim(arguments.description))
                AND len(trim(arguments.unitPrice))
                AND len(trim(arguments.unitTax))
            >
                <cfquery name="local.checkExistingProduct" datasource="#application.datasource#">
                    SELECT
                        1
                    FROM
                        tblproduct
                    WHERE
                        fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">
                        AND fldSubCategoryId = <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">
                        AND fldActive = 1
                </cfquery>
                <cfif local.checkExistingProduct.RecordCount>
                    <cfset local.result.message = "product Already Exist">
                <cfelse>
                    <cfquery result="product" datasource="#application.datasource#">
                        INSERT INTO tblproduct (
                            fldSubCategoryId,
                            fldProductName,
                            fldBrandId,
                            fldDescription,
                            fldUnitPrice,
                            fldUnitTax,
                            fldCreatedBy
                            )
                        VALUES(
                            <cfqueryparam value="#local.decryptedSubCategoryId#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.productName#" cfsqltype="varchar">,
                            <cfqueryparam value="#decryptedBrandId#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.description#" cfsqltype="varchar">,
                            <cfqueryparam value="#arguments.unitPrice#" cfsqltype="integer">,
                            <cfqueryparam value="#arguments.unitTax#" cfsqltype="integer">,
                            <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="integer">
                        )
                    </cfquery>
                    <cfif len(trim(arguments.productImages))>
                        <cfset insertProductImages(
                            productId = application.objUser.encryptId(product.generatedKey),
                            productImages = arguments.productImages,
                            adminId = session.loginAdminId,
                            defaultImageIndex = arguments.defaultImageIndex
                        )>
                    </cfif>
                    <cfset local.result.success = true>
                    <cfset local.result.message = "successful Operation">
                </cfif>
            </cfif>
        <cfcatch>
            <cfset local.result.message = "some error occured">
            <cfset sendErrorEmail(
                subject = "Error in function: addProduct "&cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchBrands" access="public" returntype="struct" >
        <cfset  local.result={
            success = false,
            brands = [],
            message = ""
        }>
        <cftry>
            <cfquery  name="local.fetchBrands" datasource="#application.datasource#">
                SELECT
                    fldBrand_Id,
                    fldBrandName
                FROM
                    tblbrand
                WHERE
                    fldActive = 1 
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
        <cfargument name="startPrice" type="any" required="false">
        <cfargument name="endPrice" type="any" required="false">
        <cfargument name="limit" type="integer" required="false">
        <cfargument name="searchText" type="string" required="false" >
        <cfargument name="sort" type="string" required="false">
        <cfargument name="random" type="string" required="false">
        <cfargument name="startIndex" type="integer" required="false" default="0">
        <cfargument name="productId" type="string" required="false">
        <cfif structKeyExists(arguments,"subCategoryId")>
            <cfset local.subCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        </cfif>
        <cfset local.result = {
            "success": false,
            "products": [],
            "message":""
         }>
         <cfset local.images = []>
        <cftry>
            <cfquery name="local.fetchProducts" datasource="#application.datasource#">
                SELECT
                    P.fldProduct_Id,
                    P.fldProductName,
                    P.fldDescription,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    P.fldSubCategoryId,
                    B.fldBrandName,
                    B.fldBrand_Id,
                    SC.fldSubCategoryName,
                    C.fldCategory_Id,
                    C.fldCategoryName,
                    PI.fldImageFilePath,
                    PI.fldProductImage_Id,
                    PI.fldDefaultImage,
                    count(*) over() AS totalProducts
                FROM
                    tblproduct P
                    INNER JOIN tblbrand B ON P.fldBrandId = B.fldBrand_Id
                    INNER JOIN tblsubcategory SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
                    INNER JOIN tblcategory C ON C.fldCategory_Id = SC.fldCategoryId
                    INNER JOIN  tblproductimages PI ON P.fldProduct_Id = PI.fldProductId
                    <cfif NOT structKeyExists(arguments,"productId")>
                        AND PI.fldDefaultImage = 1
                    </cfif>
                WHERE
                    P.fldActive = 1
                    AND PI.fldActive = 1
                     <cfif structKeyExists(arguments,"productId") AND len(arguments.productId)>
                        AND fldProduct_Id = <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "subCategoryId") AND arguments.subCategoryId NEQ 0>
                        AND P.fldSubCategoryId = <cfqueryparam value="#local.subCategoryId#" cfsqltype="integer">
                    </cfif>
                    <cfif
                        structKeyExists(arguments, "startPrice")
                        AND structKeyExists(arguments, "endPrice")
                        AND arguments.startPrice NEQ ""
                        AND arguments.endPrice NEQ ""
                    >
                        AND P.fldUnitPrice BETWEEN <cfqueryparam value='#arguments.startPrice#' cfsqltype="integer">
                        AND <cfqueryparam value='#arguments.endPrice#' cfsqltype="integer">
                    </cfif>
                    <cfif structKeyExists(arguments, "searchText") AND len(arguments.searchText)>
                        AND (P.fldDescription LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="varchar">
                            OR B.fldBrandName LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="varchar">
                            OR P.fldProductName LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="varchar">
                            OR  SC.fldSubCategoryName LIKE <cfqueryparam value="%#arguments.searchText#%" cfsqltype="varchar">)
                    </cfif>
                    ORDER BY
                    <cfif structKeyExists(arguments,"sort") AND arguments.sort EQ "ASC">
                        fldUnitPrice ASC
                    <cfelseif structKeyExists(arguments,"sort") AND arguments.sort EQ "DESC">
                        fldUnitPrice DESC
                    <cfelseif structKeyExists(arguments,"random")>
                        RAND()
                    <cfelse>
                        P.fldProductName
                    </cfif>
                    <cfif structKeyExists(arguments,"limit") AND len(arguments.limit)>
                        LIMIT <cfqueryparam value="#arguments.limit#" cfsqltype="integer">
                        <cfif structKeyExists(arguments,"startIndex")>
                            OFFSET <cfqueryparam value="#arguments.startIndex#" cfsqltype="integer">
                        </cfif>
                    </cfif>
            </cfquery>
            <cfif local.fetchProducts.recordCount gt 0>
                <cfif structKeyExists(arguments,"productId")>
                    <cfloop query="local.fetchProducts">
                        <cfset arrayAppend(local.images, {
                            "imageId": application.objUser.encryptId(local.fetchProducts.fldProductImage_Id),
                            "imagePath": local.fetchProducts.fldImageFilePath
                        })>
                        <cfif local.fetchProducts.fldDefaultImage EQ 1>
                            <cfset local.defaultImagePath = local.fetchProducts.fldImageFilePath> 
                        </cfif>
                    </cfloop>
                </cfif>
                <cfloop query="local.fetchProducts" group="fldproduct_Id">
                    <cfset arrayAppend(local.result.products, {
                        "productId": application.objUser.encryptId(local.fetchProducts.fldProduct_Id),
                        "subCategoryId": application.objUser.encryptId(local.fetchProducts.fldSubCategoryId),
                        "productName": local.fetchProducts.fldProductName,
                        "brandName": local.fetchProducts.fldBrandName,
                        "brandId" : application.objUser.encryptId(local.fetchProducts.fldBrand_Id),
                        "description": local.fetchProducts.fldDescription,
                        "unitPrice": local.fetchProducts.fldUnitPrice,
                        "unitTax": local.fetchProducts.fldUnitTax,
                        "imageFilePath": local.fetchProducts.fldImageFilePath,
                        "subcategoryName": local.fetchProducts.fldSubCategoryName,
                        "totalProducts" : local.fetchProducts.totalProducts,
                        "categoryId": application.objUser.encryptId(local.fetchProducts.fldcategory_Id),
                        "categoryName" : local.fetchProducts.fldCategoryName
                    })>
                </cfloop>
                 <cfif structKeyExists(arguments,"productId")>
                    <cfset local.result.products[1]["images"] = local.images>
                    <cfset local.result.products[1]["imageFilePath"] = local.defaultImagePath>
                </cfif>
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

    <cffunction name="updateProduct" access="public" returntype="struct">
        <cfargument name="productId" required="true" type="string">
        <cfargument name="subCategoryId" required="true" type="string">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="string">
        <cfargument name="productDescription" required="true" type="string">
        <cfargument name="unitPrice" required="true" type="integer">
        <cfargument name="unitTax" required="true" type="integer">
        <cfargument name="productImages" required="true" type="string">
        <cfargument name="defaultImageIndex" required="true" type="string">
        <cfset local.productId = application.objUser.decryptId(arguments.productId)>
        <cfset local.subCategoryId = application.objUser.decryptId(arguments.subCategoryId)>
        <cfset local.brandId = application.objUser.decryptId(arguments.brandId)>
        <cfset local.result = {
            "success": false,
            "message": ""
        }>
        <cftry>
            <cfif len(trim(arguments.productId))
                AND len(trim(arguments.subCategoryId))
                AND len(trim(arguments.productName))
                AND len(trim(arguments.brandId))
                AND len(trim(arguments.productDescription))
                AND len(trim(arguments.unitPrice))
                AND len(trim(arguments.unitTax))
            >
                <cfquery name = "local.checkExistingProduct" datasource="#application.datasource#">
                    SELECT
                        1
                    FROM
                        tblproduct
                    WHERE
                        fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">
                        AND fldSubCategoryId = <cfqueryparam value="#local.subCategoryId#" cfsqltype="integer">
                        AND fldProduct_Id != <cfqueryparam value="#local.productId#" cfsqltype="integer">
                        AND fldactive = 1
                </cfquery>
                <cfif local.checkExistingProduct.RecordCount>
                    <cfset local.result.message = "product Already Exist">
                <cfelse>
                    <cfquery datasource="#application.datasource#">
                        UPDATE
                            tblproduct
                        SET
                            fldSubCategoryId = <cfqueryparam value = #local.subCategoryId# cfsqltype="integer">,
                            fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">,
                            fldBrandId = <cfqueryparam value = #local.brandId# cfsqltype="integer">,
                            fldDescription = <cfqueryparam value = #arguments.productDescription# cfsqltype="varchar">,
                            fldUnitPrice = <cfqueryparam value = #arguments.unitPrice# cfsqltype="integer">,
                            fldUnitTax = <cfqueryparam value = #arguments.unitTax# cfsqltype="integer">,
                            fldUpdatedBy = <cfqueryparam value = #application.objUser.decryptId(session.loginAdminId)# cfsqltype="integer">,
                            fldUpdatedDate = now()
                        WHERE
                            fldProduct_Id = <cfqueryparam value="#local.productId#">
                    </cfquery>
                    <cfset updateDefaultImage(defaultImageIndex = arguments.defaultImageIndex,productId = arguments.productId)>
                    <cfif len(trim(arguments.productImages))>
                        <cfif findNoCase("existing",arguments.defaultImageIndex)>
                            <cfset insertProductImages(
                                productId = arguments.productId,
                                productImages = arguments.productImages,
                                adminId = session.loginAdminId
                            )>
                        <cfelse>
                            <cfset insertProductImages(
                                productId = arguments.productId,
                                productImages = arguments.productImages,
                                adminId = session.loginAdminId,
                                defaultImageIndex = arguments.defaultImageIndex
                            )>
                        </cfif>
                    </cfif>
                    <cfset local.result.success = true>
                    <cfset local.result.message = "successful Operation">
                </cfif>
            </cfif>
        <cfcatch>
            <cfset local.result.message = "some error occured">
            <cfset sendErrorEmail(
                subject = "Error in function: updateProduct "&cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="insertProductImages" access="private" returntype="void">
        <cfargument name="productId" required="true" type="string">
        <cfargument name="productImages" required="true" type="string">
        <cfargument name="adminId" required="true" type="string">
        <cfargument name="defaultImageIndex" required="false" type="string">
        <cfset local.productId = application.objUser.decryptId(arguments.productId)>
        <cfset local.productDirectory = expandPath('Assets/uploads/product' & local.productId)>
        <cfif NOT directoryExists(local.productDirectory)>
            <cfset DirectoryCreate(local.productDirectory)>
        </cfif>
        <cfset local.newPath = uploadFile(
            productImages = arguments.productImages,
            productDirectory = local.productDirectory
        )>
        <cfif structKeyExists(arguments,"defaultImageIndex")>
            <cfset local.imageIndex = ListLast(arguments.defaultImageIndex, "-")> 
        </cfif>
        <cftry>
            <cfquery datasource="#application.datasource#">
                INSERT INTO tblproductimages (
                    fldProductId,
                    fldImageFilePath,
                    fldCreatedBy,
                    fldDefaultImage
                ) 
                VALUES
                    <cfloop array="#local.newPath#" item = "image" index="i">
                        (
                            <cfqueryparam value="#application.objUser.decryptId(arguments.productId)#" cfsqltype="integer">,
                            <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                            <cfqueryparam value="#application.objUser.decryptId(arguments.adminId)#" cfsqltype="integer">,
                            <cfif structKeyExists(local,"imageIndex") AND i EQ local.imageIndex + 1>
                                1
                            <cfelse>
                                0
                            </cfif>
                        )
                        <cfif i NEQ arrayLen(local.newPath)>
                            ,
                        </cfif>
                    </cfloop>
            </cfquery>
        <cfcatch>
            <cfset sendErrorEmail(
                subject = "Error in function: insertProductImages "&cfcatch.message,
                body = "#cfcatch#"
            )>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteProduct" access="remote" returntype="void">
        <cfargument name="productId" required="true" type="string">
        <cfset local.decryptedProductId = application.objUser.decryptId(arguments.productId)>
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery datasource = "#application.datasource#">
                UPDATE
                    tblproduct P
                    LEFT JOIN tblproductimages PI ON P.fldProduct_Id = PI.fldProductId
                SET
                    P.fldActive = 0,
                    P.fldUpdatedBy = <cfqueryparam value = #application.objUser.decryptId(session.loginAdminId)# cfsqltype="integer">,
                    P.fldUpdatedDate = now(),
                    PI.fldActive = 0,
                    PI.fldDeactivatedBy = <cfqueryparam value = #application.objUser.decryptId(session.loginAdminId)# cfsqltype="integer">,
                    PI.fldDeactivatedDate = now()
                WHERE
                    P.fldProduct_Id = <cfqueryparam value="#local.decryptedProductId#" cfsqltype="integer">
                    AND P.fldActive = 1
                    AND PI.fldActive = 1
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

    <cffunction name="deleteProductImage" access="remote" returntype="void">
        <cfargument name="productImage" required="true" type="string">
        <cfargument name="productId" required="true" type="string">
        <cfargument name="productimageId" required="true" type="string">
        <cfset local.productId = application.objUser.decryptId(arguments.productId)>
        <cfset local.productImageId = application.objUser.decryptId(arguments.productimageId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE
                    tblproductimages
                SET
                    fldActive = 0,
                    fldDeactivatedBy = <cfqueryparam value="#application.objUser.decryptId(session.loginAdminId)#" cfsqltype="varchar">,
                    fldDeactivatedDate = now()
                WHERE
                    fldProductImage_Id = <cfqueryparam value="#local.productImageId#" cfsqltype="integer">
                    AND fldActive = 1
            </cfquery>
            <cfset local.imagePath = expandPath('../Assets/uploads/product' & local.productId & '/' & arguments.productImage)>
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
            errorLine: #arguments.body.TagContext[1].line#<br>
            File: #arguments.body.TagContext[1].template#">
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
            allowedExtensions="jpg,png,gif,jpeg,webp,avif"
            strict="true"
            result="local.newPath"
        >
        <cfset result = local.newPath>
        <cfreturn result>
    </cffunction>
</cfcomponent>


