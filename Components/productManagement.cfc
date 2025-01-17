<cfcomponent >
  <cffunction name="addCategory"  access="remote" returntype="void">
      <cfargument name="categoryName" type="string" required="true">
      <cfset local.result = {success = false}>
      <cftry>
        <cfquery>
               INSERT INTO tblcategory(
                    fldCategoryName
                    ,fldCreatedBy
                ) VALUES(
                   <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                   ,<cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
               )
         </cfquery>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
             <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
      </cftry>
    </cffunction>

    <cffunction name="fetchAllCategories"  access="public" returntype="struct">
       <cfset local.result = {success = false,categories = [],categoryId = []}>
      <cftry>
         <cfquery  name="local.fetchCategories">
            SELECT 
                fldCategory_Id
                ,fldCategoryName
                ,fldCreatedBy
            FROM
                tblcategory
            WHERE
                fldCreatedBy = <cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfcatch >
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
      </cftry>
      <cfset local.result.success = true>
      <cfloop query="local.fetchCategories">
        <cfset arrayAppend(local.result.categories,local.fetchCategories.fldCategoryName)>
        <cfset arrayAppend(local.result.categoryId,local.fetchCategories.fldCategory_Id)>
      </cfloop>
      <cfreturn local.result>
    </cffunction>

    <cffunction name="editCategory" access="remote">
        <cfargument name="categoryId" required="true" type="integer" >
        <cfargument name="newCategory" required="true" type="string" >
        <cftry>
             <cfquery>
                  UPDATE
                      tblcategory
                  SET
                      fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">,
                      fldUpdatedBy = <cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
                  WHERE
                      fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchSingleCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.structCategory={}>
        <cftry>
            <cfquery name="local.fetchCategory">
               SELECT
                   fldCategory_Id
                   ,fldCategoryName
                   ,fldCreatedBy
               FROM
                   tblcategory
               WHERE
                   fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
        <cfcatch>
            <cfset local.structCategory.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
        <cfset local.structCategory['categoryId'] = local.fetchCategory.fldCategory_Id>
        <cfset local.structCategory['name'] = local.fetchCategory.fldCategoryName>
        <cfset local.structCategory['createdBy'] = local.fetchCategory.fldCreatedBy>
        <cfset local.structCategory['createdDate'] = local.fetchCategory.fldCreatedBy>
        <cfreturn local.structCategory>
    </cffunction>

    <cffunction name="deleteCategory" access="remote" returntype="void">
        <cfargument name="categoryId" required="true" type="integer">
         <cfset local.result = {success = false}>
        <cftry>
            <cfquery>
            UPDATE
                tblcategory
            SET
                fldActive = 0
            WHERE
                fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfcatch type="any">
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="insertSubCategory" access="public" returntype="void">
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subcategoryName"  type="string" required="true">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery>
               INSERT
               INTO
                   tblsubcategory(
                       fldCategoryId
                       ,fldSubCategoryName
                       ,fldCreatedBy
                   )
               VALUES(
                   <cfqueryparam value="#arguments.categoryId#">
                   ,<cfqueryparam value="#arguments.subcategoryName#">
                   ,<cfqueryparam value="#session.loginuserId#">
               )
        </cfquery>
        <cfcatch >
            <cfset local.result.message = "Database error: " & cfcatch.message>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.result={success = false,subcategoryIds = [],subCategoryNames = []}>
        <cftry>
            <cfquery  name="local.fetchSubCategories">
               SELECT 
                   fldSubCategory_Id
                   ,fldSubCategoryName
                   ,fldCreatedBy
               FROM
                   tblsubcategory
               WHERE   
                   fldCreatedBy = <cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
                   AND fldActive = 1
                   AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfset local.result.success = true>
            <cfloop query="local.fetchSubCategories">
                <cfset arrayAppend(local.result.subcategoryIds,local.fetchSubCategories.fldSubCategory_Id)>
                <cfset arrayAppend(local.result.subCategoryNames,local.fetchSubCategories.fldSubCategoryName)>
            </cfloop>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="updateSubCategory" access="public" returntype="void">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfargument name="newCategoryName" type="string" required="true" >
        <cfargument name="categoryId" type="integer" required="true">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery>
                UPDATE
                     tblsubcategory
                SET
                    fldSubCategoryName = <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="varchar">,
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
        <cfcatch >
             <cfset local.result.message = "Database error: " & cfcatch.message>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="softDeleteSubCategory" access="remote" returntype="void">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfset local.result = {success = false}>
        <cftry>
             <cfquery>
                UPDATE
                    tblsubcategory
                SET
                    fldActive = 0
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                    AND fldActive = 1
        </cfquery>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction  name="insertProduct" access="public" returntype="void">
        <cfargument name="subCategoryId" required="true" type="integer">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="integer">
        <cfargument name="description" required="true" type="string">
        <cfargument  name="unitPrice" required="true" type="integer">
        <cfargument name="unitTax" required="true" type="integer" >
        <cfargument name="productImages" required="true" type="string">
        <cftry>
            <cfquery result="product">
                INSERT
                INTO
                    tblproduct(
                      fldSubCategoryId
                      ,fldProductName
                      ,fldBrandId
                      ,fldDescription
                      ,fldUnitPrice
                      ,fldUnitTax
                      ,fldCreatedBy
                    )
                VALUES(
                    <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.productName#" cfsqltype="varchar">
                    ,<cfqueryparam value="#arguments.brandId#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.description#" cfsqltype="varchar">
                    ,<cfqueryparam value="#arguments.unitPrice#" cfsqltype="integer">
                    ,<cfqueryparam value="#arguments.unitTax#" cfsqltype="integer">  
                    ,<cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
                )
            </cfquery>
            <cfset productDirectory = expandPath('Assets/uploads/product'&product.GENERATEDKEY)>
            <cfdirectory action="create" directory="#productDirectory#">
            <cffile
		    action="uploadall"
		    destination="#productDirectory#"
		    nameconflict="MakeUnique"
            filefield = "#arguments.productImages#"
            allowedExtensions="jpg,png,gif,jpeg,webp"
		    strict="true"
		    result="local.newPath"
		    >
         <cfloop array="#local.newPath#" index="i"  item="image">
            <cfquery>
               INSERT
               INTO
                  tblproductimages(
                      fldProductId
                      ,fldImageFilePath
                      ,fldCreatedBy
                      ,fldDefaultImage
                  )
               VALUES(
                  <cfqueryparam value="#product.GENERATEDKEY#" cfsqltype="integer">,
                  <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                  <cfqueryparam value="#session.loginuserId#" cfsqltype="varchar">,
                  <cfif i EQ 1>
                     <cfqueryparam value=1 cfsqltype="integer">
                  <cfelse>
                     <cfqueryparam value=0 cfsqltype="integer">
                  </cfif>
               )
            </cfquery>
         </cfloop>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #functionName#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchBrands" access="public"  returntype="struct" >
        <cfset  local.result={success = false,brandIds = [],brandNames = []}>
        <cftry>
             <cfquery  name="local.fetchBrands">
                SELECT
                   fldBrand_Id
                   ,fldBrandName
                FROM
                    tblbrand
            </cfquery>
            <cfset local.result.success =true>
            <cfloop query="local.fetchBrands">
                <cfset arrayAppend(local.result.brandIds,local.fetchBrands.fldBrand_Id)>
                <cfset arrayAppend(local.result.brandNames,local.fetchBrands.fldBrandName)>
            </cfloop>
        <cfcatch>
            <cfmail 
                from = "adarshus1999@gmail.com" 
                to = "adarshus123@gmail.com" 
                subject = "Error in Function: #local.currentFunction#"
                >
                <h3>An error occurred in function: #functionName#</h3>
                <p><strong>Error Message:</strong> #cfcatch.message#</p>
            </cfmail>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchProducts" access="public" returntype="struct">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfset local.result = {"success": false, "data": []}>
        <cftry>
            <cfquery name="local.fetchProducts">
                SELECT
                    P.fldProduct_Id,
                    P.fldSubCategoryId,
                    P.fldProductName,
                    B.fldBrandName,
                    P.fldDescription,
                    P.fldUnitPrice,
                    P.fldUnitTax,
                    PI.fldImageFilePath
                FROM
                    tblproduct P
                LEFT JOIN 
                    tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                    AND PI.fldDefaultImage = 1
                INNER JOIN 
                    tblbrand B ON P.fldBrandId = B.fldBrand_Id
                WHERE
                    P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                    AND P.fldActive = 1;
            </cfquery>
    
            <cfif local.fetchProducts.recordCount gt 0>
                <cfloop query="local.fetchProducts">
                    <cfset arrayAppend(local.result.data, {
                        "productId": local.fetchProducts.fldProduct_Id,
                        "subCategoryId": local.fetchProducts.fldSubCategoryId,
                        "productName": local.fetchProducts.fldProductName,
                        "brandName": local.fetchProducts.fldBrandName,
                        "description": local.fetchProducts.fldDescription,
                        "unitPrice": local.fetchProducts.fldUnitPrice,
                        "unitTax": local.fetchProducts.fldUnitTax,
                        "imageFilePath": local.fetchProducts.fldImageFilePath
                    })>
                </cfloop>
            </cfif>
    
            <cfset local.result.success = true>
        <cfcatch>            
            <cfmail 
                from="adarshus1999@gmail.com" 
                to="adarshus123@gmail.com" 
                subject="Error in Function: fetchProducts">
                <h3>An error occurred in function: fetchProducts</h3>
                <p><strong>Error Message:</strong> #cfcatch.message#</p>
            </cfmail>
        </cfcatch>
        </cftry>        
        <cfreturn local.result>
    </cffunction>

   <cffunction name="fetchSingleProduct" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="integer">
    <cfset local.structProduct = {}>
    <cftry>
        <cfquery name="local.fetchProduct">
            SELECT
                TP.fldProduct_Id,
                TP.fldProductName,
                TP.fldDescription,
                TP.fldUnitPrice,
                TP.fldUnitTax,
                TPI.fldImageFilePath,
                TB.fldBrandName,
                TB.fldBrand_Id
            FROM
                tblbrand AS TB
            INNER JOIN 
                tblproduct AS TP
            ON
                TB.fldBrand_Id = TP.fldBrandId
            INNER JOIN
                tblProductImages AS TPI
            ON
                TP.fldProduct_Id = TPI.fldProductId
            WHERE
                TP.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            AND
                TP.fldActive = 1
            AND
                TPI.fldActive = 1
            AND
                TPI.fldDefaultImage = 1
        </cfquery>
    <cfcatch>
        <cfset local.structProduct = {"message": cfcatch.message}>
         <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
    <cfif local.fetchProduct.recordCount gt 0>
            <cfset local.structProduct = {
                "productId": local.fetchProduct.fldProduct_Id,
                "productName": local.fetchProduct.fldProductName,
                "description": local.fetchProduct.fldDescription,
                "unitPrice": local.fetchProduct.fldUnitPrice,
                "unitTax": local.fetchProduct.fldUnitTax,
                "imageFilePath": local.fetchProduct.fldImageFilePath,
                "brandName": local.fetchProduct.fldBrandName,
                "brandId": local.fetchProduct.fldBrand_Id
            }>
        </cfif>
    <cfreturn local.structProduct>
</cffunction>

<cffunction name="updateProduct" access="public" returntype="void">
    <cfargument name="productId" required="true" type="integer">    
    <cfargument name="subCategoryId" required="true" type="integer">
    <cfargument name="productName" required="true" type="string">
    <cfargument name="brandId" required="true" type="integer">
    <cfargument name="productDescription" required="true" type="string">
    <cfargument name="unitPrice" required="true" type="integer">
    <cfargument name="unitTax" required="true" type="integer">
    <cfargument name="productImages" required="true" type="string">

    <cftry>
        <cfquery>
            UPDATE
                tblproduct
            SET
                fldSubCategoryId = <cfqueryparam value = #arguments.subCategoryId# cfsqltype="integer">,
                fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">,
                fldBrandId = <cfqueryparam value = #arguments.brandId# cfsqltype="integer">,
                fldDescription = <cfqueryparam value = #arguments.productDescription# cfsqltype="varchar">,
                fldUnitPrice = <cfqueryparam value = #arguments.unitPrice# cfsqltype="integer">,
                fldUnitTax = <cfqueryparam value = #arguments.unitTax# cfsqltype="integer">,
                fldUpdatedBy = <cfqueryparam value = #session.loginuserId# cfsqltype="integer">
            WHERE
                fldProduct_Id = <cfqueryparam value="#arguments.productId#">
        </cfquery>
        <cfif LEN(arguments.productImages)>
          <cfset productDirectory = expandPath('Assets/uploads/product'&arguments.productId)>
          <cffile
	        action="uploadall"
	        destination="#productDirectory#"
	        nameconflict="MakeUnique"
            filefield = "#arguments.productImages#"
            allowedExtensions="jpg,png,gif,jpeg,webp"
	        strict="true"
	        result="local.newPath"
	        >
             <cfloop array="#local.newPath#" index="i"  item="image">
                <cfquery>
                   INSERT
                   INTO
                      tblproductimages(
                          fldProductId
                          ,fldImageFilePath
                          ,fldCreatedBy
                          ,fldDefaultImage
                      )
                   VALUES(
                      <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                      <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                      <cfqueryparam value="#session.loginuserId#" cfsqltype="varchar">,
                      <cfif i EQ 1>
                         <cfqueryparam value=1 cfsqltype="integer">
                      <cfelse>
                         <cfqueryparam value=0 cfsqltype="integer">
                      </cfif>
                   )
                </cfquery>
             </cfloop>
        </cfif>
    <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="deleteProduct" access="remote" returntype="void">
    <cfargument name="productId" required="true" type="numeric">
    <cftry>
         <cfquery>
            UPDATE
                tblproduct
            SET
                fldActive = 0
            WHERE
                fldProduct_Id  = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
    <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="fetchProductImages" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="numeric">
    <cfset var local = structNew()>
    <cftry>
        <cfquery name="local.fetchImages">
            SELECT
                PI.fldImageFilePath,
                PI.fldProductImage_Id,
                PI.fldDefaultImage
            FROM
                tblproductimages PI
            INNER JOIN
                tblproduct P
            ON
                PI.fldProductId = P.fldProduct_Id
            WHERE
                P.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                AND
                PI.fldActive = 1
        </cfquery>
        <cfset var result = { images = [],productImagesId=[]}>
        <cfloop query="local.fetchImages">
            <cfif local.fetchImages.fldDefaultImage EQ 1>
                <cfset result.defaultImageId = local.fetchImages.fldProductImage_Id >
            </cfif>
            <cfset arrayAppend(result.images, local.fetchImages.fldImageFilePath)>
            <cfset arrayAppend(result.productImagesId, local.fetchImages.fldProductImage_Id)>
        </cfloop>
    <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
    <cfreturn result>
</cffunction>

<cffunction name="updateThumbnail" access="remote" returntype="void">
    <cfargument name="productImageId" required="true" type="numeric">
    <cfargument name="productId" required="true" type="numeric">
    <cftry>
        <cfquery>
             UPDATE
                tblproductimages
            SET
                fldDefaultImage = <cfqueryparam value = "0" cfsqltype="integer">
            WHERE
                fldProductId = <cfqueryparam  value="#arguments.productId#">
        </cfquery>    
        <cfquery>
            UPDATE
                tblproductimages
            SET
                fldDefaultImage = <cfqueryparam value = 1>
            WHERE
                fldProductImage_Id = <cfqueryparam value = #arguments.productImageId# cfsqltype="integer">
        </cfquery>
    <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="deleteProductImage" access="remote" returntype="void" >
    <cfargument name="productImageId" required="true" type="numeric">
    <cfargument name="productId" required="true" type="numeric">
    <cfargument name="productFileName" required="true" type="string">
    <cftry>
        <cfquery>
            UPDATE
                tblproductimages
            SET
                fldActive = 0
            WHERE
                fldProductImage_Id = <cfqueryparam value="#arguments.productImageId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>    
        <cfset local.imagePath = "#expandPath('Assets/uploads/product'&arguments.productId&'/'&arguments.productFileName)#">
        <cffile
         action = "delete"
         file = "#local.imagePath#"
        >
     <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #functionName#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>


