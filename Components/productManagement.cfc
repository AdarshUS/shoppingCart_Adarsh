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
        </cfcatch>
      </cftry>      
    </cffunction>

    <cffunction name="fetchAllCategories"  access="public" returntype="query">
       <cfset local.result = {success = false}>
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
        </cfcatch>               
      </cftry>        
      <cfreturn local.fetchCategories>
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
        </cfcatch>
        </cftry>        
        <cfset local.structCategory['categoryId'] = local.fetchCategory.fldCategory_Id>
        <cfset local.structCategory['name'] = local.fetchCategory.fldCategoryName>
        <cfset local.structCategory['createdBy'] = local.fetchCategory.fldCreatedBy>
        <cfset local.structCategory['createdDate'] = local.fetchCategory.fldCreatedBy>
        <cfreturn local.structCategory>
    </cffunction>

    <cffunction name="deleteCategory" access="remote">       
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
        </cfcatch>                    
        </cftry>
            
    </cffunction>

    <cffunction name="insertSubCategory" access="public">        
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

    <cffunction name="fetchSubCategories" access="remote" returntype="query" returnformat="JSON">
        <cfargument name="categoryId" type="integer" required="true">
        <cfset  local.result={}>
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
        <cfcatch>
            <cfset local.result.message = "Database error: " & cfcatch.message> 
        </cfcatch>                  
        </cftry>               
        <cfreturn local.fetchSubCategories>
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
        <cfargument name="productImages" required="true" type="struct">
        
        <cffile
		action="uploadall"
		destination="#expandpath("./Assets/Uploads/")#"
		nameconflict="MakeUnique"
		strict="true"
		result="local.newPath"
		>       
        <cfquery>
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
            ,<cfqueryparam value="#arguments.unitPrice#" cfsqltype="varchar">
            ,<cfqueryparam value="#arguments.unitTax#" cfsqltype="varchar">  
            ,<cfqueryparam value="#session.loginuserId#" cfsqltype="integer">          
        )
        </cfquery>        
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
    </cffunction>

    <cffunction name="fetchBrands" access="public"  returntype="query" >          
        <cfquery  name="local.fetchBrands">
            SELECT
               fldBrand_Id
               ,fldBrandName
            FROM
                tblbrand
        </cfquery>
        <cfreturn local.fetchBrands>
    </cffunction>

    <cffunction name="fetchProducts" access="public" returntype="query" >
      <cfargument name="subCategoryId" type="integer" required="true">
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
          INNER JOIN tblproductimages PI ON PI.fldProductId = P.fldProduct_Id
            AND PI.fldDefaultImage = 1
          INNER JOIN tblbrand B ON P.fldBrandId = B.fldBrand_Id
        WHERE
            P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            AND P.fldActive = 1;
    </cfquery>
    
      <cfreturn local.fetchProducts>
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
                TB.fldBrandId
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
        <cfif local.fetchProduct.recordCount gt 0>            
            <cfset local.structProduct = {
                "productId": local.fetchProduct.fldProduct_Id,
                "productName": local.fetchProduct.fldProductName,
                "description": local.fetchProduct.fldDescription,
                "unitPrice": local.fetchProduct.fldUnitPrice,
                "unitTax": local.fetchProduct.fldUnitTax,
                "imageFilePath": local.fetchProduct.fldImageFilePath,
                "brandName": local.fetchProduct.fldBrandName,
                "brandId": local.fetchProduct.fldBrandId
            }>
        </cfif>
        <cfcatch>            
            <cfset local.structProduct = {"message": cfcatch.message}>
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
    <cfargument name="productImages" required="true">

            <cffile
			action="uploadall"
			destination="#expandpath("./Assets/Uploads/")#"
			nameconflict="MakeUnique"
			strict="true"
			result="local.newPath"
		   >       

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
           <cfloop array="#local.newPath#" index="i"  item="image">
                <cfquery name="local.insertProductImages">
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
   
</cffunction>

<cffunction name="deleteProduct" access="remote" returntype="void">
    <cfargument name="productId" required="true" type="numeric" >
    <cfquery>
        UPDATE
            tblproduct
        SET
            fldActive = 0
        WHERE
            fldProduct_Id  = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">
            AND fldActive = 1
    </cfquery>    
</cffunction>

<cffunction name="fetchProductImages" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="numeric">
    <cfset var local = structNew()>
    <cfquery>
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
            PI.fldActive = <cfqueryparam value="1" cfsqltype="integer">
    </cfquery>
    
    <cfset var result = { images = [],productImagesId=[]}>
    <cfloop query="local.fetchImages">
        <cfif local.fetchImages.fldDefaultImage EQ 1>
            <cfset result.defaultImageId = local.fetchImages.fldProductImage_Id >                    
        </cfif>
        <cfset arrayAppend(result.images, local.fetchImages.fldImageFilePath)>
        <cfset arrayAppend(result.productImagesId, local.fetchImages.fldProductImage_Id)>
    </cfloop>
    <cfreturn result>
</cffunction>

<cffunction name="updateThumbnail" access="remote" returntype="void">
    <cfargument name="productImageId" required="true" type="numeric">
    <cfargument name="productId" required="true" type="numeric" >       
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
</cffunction>

<cffunction name="deleteProductImage" access="remote" returntype="void" >
    <cfargument name="productImageId" required="true" type="numeric">    
    <cfquery>
        UPDATE
            tblproductimages
        SET
            fldActive = 0
        WHERE
            fldProductImage_Id = <cfqueryparam value="#arguments.productImageId#" cfsqltype="integer">
            AND fldActive = 1
    </cfquery>
  </cffunction>  
</cfcomponent>


