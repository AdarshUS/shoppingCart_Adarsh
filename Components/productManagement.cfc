<cfcomponent>
  <cffunction name="addCategory"  access="remote" returntype="struct" returnformat="JSON">
      <cfargument name="categoryName" type="string" required="true">
      <cfset local.result = {success = false}>
      <cftry>
        <cfquery name = "local.checkCategory" datasource="shopping_cart">
            SELECT
                fldCategory_Id,
                fldCategoryName
            FROM
                tblcategory
            WHERE
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                AND fldActive = 1;
        </cfquery>
        <cfif local.checkCategory.RecordCount>
            <cfset local.result.message = "Category Already Exist">
        <cfelse>
            <cfquery datasource="shopping_cart">
                INSERT INTO tblcategory(
                     fldCategoryName
                     ,fldCreatedBy
                 ) VALUES(
                    <cfqueryparam value="#arguments.categoryName#" cfsqltype="varchar">
                    ,<cfqueryparam value="#session.loginuserId#" cfsqltype="integer">
                )
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful operation">
        </cfif>        
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
             <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
      </cftry>
      <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchAllCategories"  access="public" returntype="struct">
       <cfset local.result = {success = false,categories = [],categoryId = []}>
      <cftry>
         <cfquery  name="local.fetchCategories" datasource="shopping_cart">
            SELECT 
                fldCategory_Id
                ,fldCategoryName
                ,fldCreatedBy
            FROM
                tblcategory
            WHERE
                fldActive = 1
        </cfquery>
        <cfset local.result.success = true>
        <cfset local.result.message = "successful operation">
        <cfcatch >
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
      </cftry>
      <cfloop query="local.fetchCategories">
        <cfset arrayAppend(local.result.categories,local.fetchCategories.fldCategoryName)>
        <cfset arrayAppend(local.result.categoryId,local.fetchCategories.fldCategory_Id)>
      </cfloop>
      <cfreturn local.result>
    </cffunction>

    <cffunction name="editCategory" access="remote" returntype="struct">
        <cfargument name="categoryId" required="true" type="integer">
        <cfargument name="newCategory" required="true" type="string">
        <cfset local.result = {success = false}>
        <cftry>
             <cfquery datasource="shopping_cart">
                  UPDATE
                      tblcategory
                  SET
                      fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">,
                      fldUpdatedBy = <cfqueryparam value="#session.loginuserId#" cfsqltype="integer">,
                      fldUpdatedDate = <cfqueryparam value="#now()#" cfsqltype="timestamp">
                  WHERE
                      fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchSingleCategory" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.structCategory={success = false}>
        <cftry>
            <cfquery name="local.fetchCategory" datasource="shopping_cart">
               SELECT
                   fldCategory_Id
                   ,fldCategoryName
                   ,fldCreatedBy
               FROM
                   tblcategory
               WHERE
                   fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
            </cfquery>
            <cfset local.structCategory.success = true>
            <cfset local.structCategory.message = "successful Operation">
        <cfcatch>
            <cfset local.structCategory.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
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
            <cfquery datasource="shopping_cart">
            UPDATE
                tblcategory
            SET
                fldActive = 0
            WHERE
                fldCategory_Id = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
        <cfcatch type="any">
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addSubCategory" access="public" returntype="void">
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subcategoryName"  type="string" required="true">
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery name="local.checkSubCategory" datasource="shopping_cart">
                SELECT
                    fldSubCategory_Id
                FROM
                    tblsubcategory
                WHERE
                    fldSubCategoryName = <cfqueryparam value="#arguments.subcategoryName#">
                    AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#">
                    AND fldActive = 1
            </cfquery>
            <cfif local.checkSubCategory.RecordCount>
                <cfset local.result.message = "SubCategory Already Exist"> 
            <cfelse>
                <cfquery datasource="shopping_cart">
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
             <cfset local.result.success = true>
             <cfset local.result.message = "successful Operation">
            </cfif>            
        <cfcatch >
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchSubCategories" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="categoryId" type="string" required="false">
        <cfset  local.result={success = false,subcategoryIds = [],subCategoryNames = []}>
        <cftry>
            <cfquery  name="local.fetchSubCategories" datasource="shopping_cart">
               SELECT 
                   fldSubCategory_Id
                   ,fldSubCategoryName
                   ,fldCreatedBy
               FROM
                   tblsubcategory
               WHERE
                   fldActive = 1
                   AND fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="varchar">
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful operation">
            <cfloop query="local.fetchSubCategories">
                <cfset arrayAppend(local.result.subcategoryIds,local.fetchSubCategories.fldSubCategory_Id)>
                <cfset arrayAppend(local.result.subCategoryNames,local.fetchSubCategories.fldSubCategoryName)>
            </cfloop>
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message>
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
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
            <cfquery datasource="shopping_cart">
                UPDATE
                     tblsubcategory
                SET
                    fldSubCategoryName = <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="varchar">,
                    fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="integer">,
                    fldUpdatedDate = <cfqueryparam value="#now()#" cfsqltype="timestamp">
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            </cfquery>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch >
             <cfset local.result.message = "Database error: " & cfcatch.message>
             <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="softDeleteSubCategory" access="remote" returntype="void">
        <cfargument name="subCategoryId" type="integer" required="true">
        <cfset local.result = {success = false}>
        <cftry>
             <cfquery datasource="shopping_cart">
                UPDATE
                    tblsubcategory
                SET
                    fldActive = 0
                WHERE
                    fldSubCategory_Id = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
                    AND fldActive = 1
        </cfquery>
        <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
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
        <cfset local.result = {success = false}>
        <cftry>
            <cfquery result="product" datasource="shopping_cart">
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
        <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
                <cfmail 
                    from = "adarshus1999@gmail.com" 
                    to = "adarshus123@gmail.com" 
                    subject = "Error in Function: #local.currentFunction#"
                >
                    <h3>An error occurred in function: #local.currentFunction#</h3>
                    <p><strong>Error Message:</strong> #cfcatch.message#</p>
                </cfmail>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="fetchBrands" access="public"  returntype="struct" >
        <cfset  local.result={success = false,brandIds = [],brandNames = []}>
        <cftry>
            <cfquery  name="local.fetchBrands" datasource="shopping_cart">
                SELECT
                   fldBrand_Id
                   ,fldBrandName
                FROM
                    tblbrand
            </cfquery>
            <cfloop query="local.fetchBrands">
                <cfset arrayAppend(local.result.brandIds,local.fetchBrands.fldBrand_Id)>
                <cfset arrayAppend(local.result.brandNames,local.fetchBrands.fldBrandName)>
            </cfloop>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
            <cfmail 
                from = "adarshus1999@gmail.com" 
                to = "adarshus123@gmail.com" 
                subject = "Error in Function: #local.currentFunction#"
                >
                <h3>An error occurred in function: #local.currentFunction#</h3>
                <p><strong>Error Message:</strong> #cfcatch.message#</p>
            </cfmail>
        </cfcatch>
        </cftry>
        <cfreturn local.result>
    </cffunction>

    <cffunction name="fetchProducts" access="remote" returntype="struct" returnformat="JSON">
        <cfargument name="subCategoryId" type="string" required="false">
        <cfargument name="priceRange" type="string" required="false">
        <cfargument name="limit" type="integer" required="false">
        <cfargument name="searchText" type="string" required="false" >
        <cfargument name="sort" required="false" type="string">
        <cfset local.result = {"success": false, "data": []}>
        <cftry>
            <cfquery name="local.fetchProducts" datasource="shopping_cart">
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
                LEFT JOIN
                    tblsubcategory SC ON P.fldSubCategoryId = SC.fldSubCategory_Id
                LEFT JOIN 
                    tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                    AND PI.fldDefaultImage = 1
                LEFT JOIN 
                    tblbrand B ON P.fldBrandId = B.fldBrand_Id
                WHERE
                    P.fldActive = 1
                    <cfif structKeyExists(arguments, "subCategoryId") AND arguments.subCategoryId NEQ 0>
                        AND P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
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
                        "imageFilePath": local.fetchProducts.fldImageFilePath,
                        "subcategoryName": local.fetchProducts.fldSubCategoryName
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
            <cfset local.currentFunction = getFunctionCalledName()>
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
    <cfargument name="allImagesNeeded" required="false" type="boolean" default="false">
    <cfset local.structProduct = {success: false, message: "", data: {}}>
    <cfset local.imageList = []>
    <cftry>
        <cfquery name="local.fetchProduct" datasource="shopping_cart">
            SELECT
                TP.fldProduct_Id,
                TP.fldProductName,
                TP.fldDescription,
                TP.fldUnitPrice,
                TP.fldUnitTax,
                TPI.fldImageFilePath,
                TB.fldBrandName,
                TB.fldBrand_Id,
                SC.fldCategoryId,
                TP.fldSubCategoryId,
                TC.fldCategoryName,
                SC.fldSubCategoryName
            FROM
                tblbrand AS TB
            INNER JOIN 
                tblproduct AS TP ON TB.fldBrand_Id = TP.fldBrandId
            LEFT JOIN
                tblProductImages AS TPI ON TP.fldProduct_Id = TPI.fldProductId
            LEFT JOIN
                tblsubcategory AS SC ON SC.fldSubCategory_Id = TP.fldSubCategoryId
			LEFT join
				tblcategory AS TC ON TC.fldCategory_Id = SC.fldCategoryId
            WHERE
                TP.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            AND
                TP.fldActive = 1
            <cfif NOT arguments.allImagesNeeded>
                AND TPI.fldDefaultImage = 1
            </cfif>
        </cfquery>
        <cfif local.fetchProduct.recordCount GT 0>
            <cfif arguments.allImagesNeeded>
                <cfloop query="local.fetchProduct">
                    <cfset arrayAppend(local.imageList, local.fetchProduct.fldImageFilePath)>
                </cfloop>
            <cfelse>
                <cfset local.imageList = [local.fetchProduct.fldImageFilePath]>
            </cfif>

            <cfset local.structProduct.success = true>
            <cfset local.structProduct.message = "Successful operation">
            <cfset local.structProduct.data = {
                "productId": local.fetchProduct.fldProduct_Id,
                "productName": local.fetchProduct.fldProductName,
                "description": local.fetchProduct.fldDescription,
                "unitPrice": local.fetchProduct.fldUnitPrice,
                "unitTax": local.fetchProduct.fldUnitTax,
                "images": local.imageList,
                "brandName": local.fetchProduct.fldBrandName,
                "brandId": local.fetchProduct.fldBrand_Id,
                "defaultImagePath":local.fetchProduct.fldImageFilePath,
                "categoryName":local.fetchProduct.fldCategoryName,
                "categoryId":local.fetchProduct.fldCategoryId,
                "subcategoryName":local.fetchProduct.fldSubCategoryName,
                "subcategoryId":local.fetchProduct.fldSubCategoryId
            }>
        <cfelse>
            <cfset local.structProduct.message = "No product found">
        </cfif>
    <cfcatch>
        <cfset local.structProduct.message = "An error occurred. Please try again later.">
        <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: fetchSingleProduct">
            <h3>An error occurred in function: fetchSingleProduct</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
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
    <cfset local.structProduct = {"success": false}>
    <cftry>
        <cfquery datasource="shopping_cart">
            UPDATE
                tblproduct
            SET
                fldSubCategoryId = <cfqueryparam value = #arguments.subCategoryId# cfsqltype="integer">,
                fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">,
                fldBrandId = <cfqueryparam value = #arguments.brandId# cfsqltype="integer">,
                fldDescription = <cfqueryparam value = #arguments.productDescription# cfsqltype="varchar">,
                fldUnitPrice = <cfqueryparam value = #arguments.unitPrice# cfsqltype="integer">,
                fldUnitTax = <cfqueryparam value = #arguments.unitTax# cfsqltype="integer">,
                fldUpdatedBy = <cfqueryparam value = #session.loginuserId# cfsqltype="integer">,
                fldUpdatedDate = <cfqueryparam value="#now()#" cfsqltype="timestamp">
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
                      <cfqueryparam value=0 cfsqltype="integer">                      
                   )
                </cfquery>
             </cfloop>             
        </cfif>
        <cfset local.structProduct.success = true>
        <cfset local.structProduct.message = "successful Operation">
    <cfcatch >
        <cfset local.structProduct = {"message": cfcatch.message}>
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="deleteProduct" access="remote" returntype="void">
    <cfargument name="productId" required="true" type="numeric">
    <cfset local.result = {success = false}>
    <cftry>
         <cfquery datasource="shopping_cart">
            UPDATE
                tblproduct
            SET
                fldActive = 0
            WHERE
                fldProduct_Id  = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>
        <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
    <cfcatch >
         <cfset local.result.message = "Database error: " & cfcatch.message>
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="fetchProductImages" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="numeric">
    <cfset var local = structNew()>
    <cftry>
        <cfquery name="local.fetchImages" datasource="shopping_cart">
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
            <h3>An error occurred in function: #local.currentFunction#</h3>
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
        <cfquery datasource="shopping_cart">
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
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
</cffunction>

<cffunction name="deleteProductImage" access="remote" returntype="void">
    <cfargument name="productImageId" required="true" type="numeric">
    <cfargument name="productId" required="true" type="numeric">
    <cfargument name="productFileName" required="true" type="string">
    <!--- <cftry> --->
        <cfquery datasource="shopping_cart">
            UPDATE
                tblproductimages
            SET
                fldActive = 0,
                fldDeactivatedBy = <cfqueryparam value="#session.loginuserId#" cfsqltype="varchar">,
                fldDeactivatedDate = <cfqueryparam value="#now()#" cfsqltype="timestamp">
            WHERE
                fldProductImage_Id = <cfqueryparam value="#arguments.productImageId#" cfsqltype="integer">
                AND fldActive = 1
        </cfquery>    
        <cfset local.imagePath = expandPath('../Assets/uploads/product' & arguments.productId & '/' & arguments.productFileName)>
        <cffile
         action = "delete"
         file = "#local.imagePath#"
        >
    <!---  <cfcatch >
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry> --->
  </cffunction>

  <cffunction name="getRandomProducts" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="subCategoryId" required="false" type="integer">
    <cfset local.result = {success = false,data = []}>
    <cftry>
        <cfquery name="local.getRandomProducts" datasource="shopping_cart">
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
            LEFT JOIN 
                tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
                AND PI.fldDefaultImage = 1
            LEFT JOIN
                tblsubcategory AS SC ON SC.fldSubCategory_Id = P.fldSubCategoryId
            INNER JOIN 
                tblbrand B ON P.fldBrandId = B.fldBrand_Id
            WHERE
                P.fldActive = 1
                <cfif structKeyExists(arguments,"subCategoryId")>
                    AND P.fldSubCategoryId = #arguments.subCategoryId#
                </cfif>
                ORDER BY RAND() LIMIT 4;
        </cfquery>
        <cfif local.getRandomProducts.recordCount>
                <cfloop query="local.getRandomProducts">
                    <cfset arrayAppend(local.result.data, {
                        "productId": local.getRandomProducts.fldProduct_Id,
                        "subCategoryId": local.getRandomProducts.fldSubCategoryId,
                        "productName": local.getRandomProducts.fldProductName,
                        "brandName": local.getRandomProducts.fldBrandName,
                        "description": local.getRandomProducts.fldDescription,
                        "unitPrice": local.getRandomProducts.fldUnitPrice,
                        "unitTax": local.getRandomProducts.fldUnitTax,
                        "imageFilePath": local.getRandomProducts.fldImageFilePath,
                        "subCategoryName": local.getRandomProducts.fldSubCategoryName
                    })>
                </cfloop>
            </cfif>
            <cfset local.result.success = true>
            <cfset local.result.message = "successful Operation">
    <cfcatch>
        <cfdump var="#cfcatch#" >
        <cfset local.result.message = "Database error: " & cfcatch.message>
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
    <cfreturn local.result>
  </cffunction>
   
  <cffunction name="addcart" access="public" returntype="struct">
     <cfargument name = "userId" required="true" type="integer">
     <cfargument name = "productId" required="true" type="integer">
     <cfargument name = "quantity" required="true" type="integer">
     <cfset local.result = {success = false}>
     <cftry>
        <cfquery name = "local.checkProductExist" datasource="shopping_cart">
            SELECT
                fldCart_Id,
                fldUserId,
                fldProductId,
                fldQuantity
            FROM
                tblcart
            WHERE
                fldUserId = <cfqueryparam value="#arguments.userId#" cfsqltype="integer">
                AND
                fldProductId = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
        </cfquery>
        <cfif local.checkProductExist.RecordCount>
            <cfquery datasource="shopping_cart">
                UPDATE tblcart
                SET fldQuantity = fldQuantity + <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                WHERE fldCart_Id = <cfqueryparam value="#local.checkProductExist.fldCart_Id#" cfsqltype="integer">
            </cfquery>
        <cfelse>
            <cfquery>
                INSERT
                INTO
                    tblcart(
                        fldUserId,
                        fldProductId,
                        fldQuantity
                    )
                VALUES(
                    <cfqueryparam value="#arguments.userId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.productId#" cfsqltype="integer">,
                    <cfqueryparam value="#arguments.quantity#" cfsqltype="integer">
                )
            </cfquery>
        </cfif>
         <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
     <cfcatch>
        <cfdump var="#cfcatch#" >
        <cfset local.result.message = "Database error: " & cfcatch.message>
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
    <cfreturn local.result>
  </cffunction>

  <cffunction name="fetchCart" access="public" returntype="struct">
    <cfargument name="userId" required="true" type="integer">
     <cfset local.result = {success = false,data=[]}>
    <cftry>
        <cfquery name="local.fetchCart">
            SELECT
                PI.fldImageFilePath,
                P.fldUnitPrice,
                P.fldProductName,
                P.fldProduct_Id,
                C.fldQuantity,
                C.fldCart_Id
            FROM
                tblcart C
            INNER JOIN 
                tblproduct P
            ON
                C.fldProductId = P.fldProduct_Id
            LEFT JOIN
                tblproductimages PI 
            ON
                P.fldProduct_Id = PI.fldProductId
            WHERE 
                fldDefaultImage = 1
                AND fldUserId = <cfqueryparam value = #arguments.userId#>
        </cfquery>
        <cfif local.fetchCart.recordCount>
            <cfloop query="local.fetchCart">
                <cfset arrayAppend(local.result.data, {
                    "imageFilePath": local.fetchCart.fldImageFilePath,
                    "unitPrice": local.fetchCart.fldUnitPrice,
                    "productName": local.fetchCart.fldProductName,
                    "productId":local.fetchCart.fldProduct_Id,
                    "quantity": local.fetchCart.fldQuantity,
                    "cartId":local.fetchCart.fldCart_Id
                })>
            </cfloop>
        </cfif>
        <cfset local.result.success = true>
        <cfset local.result.message = "successful Operation">
    <cfcatch>
        <cfdump var="#cfcatch#">
        <cfset local.result.message = "Database error: " & cfcatch.message>
        <cfset local.currentFunction = getFunctionCalledName()>
         <cfmail 
            from = "adarshus1999@gmail.com" 
            to = "adarshus123@gmail.com" 
            subject = "Error in Function: #local.currentFunction#"
            >
            <h3>An error occurred in function: #local.currentFunction#</h3>
            <p><strong>Error Message:</strong> #cfcatch.message#</p>
        </cfmail>
    </cfcatch>
    </cftry>
    <cfreturn local.result>
  </cffunction>

  <cffunction name="updateCart" access="remote" returntype="void"> 
   <cfargument name="cartId" required = "true" type = "integer">
    <cfargument name="step" required="true" type="string">
    <cftry>
        <cfquery datasource="shopping_cart">
            UPDATE
                tblcart
            SET
                fldQuantity = fldQuantity
                <cfif structKeyExists(arguments,"step") AND arguments.step EQ "increment">
                    +1
                <cfelse>
                    -1
                </cfif>
            WHERE
                fldCart_Id = <cfqueryparam value = #arguments.cartId# cfsqltype = "integer">
        </cfquery>
    <cfcatch>
         <cfdump var="#cfcatch#">
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>


