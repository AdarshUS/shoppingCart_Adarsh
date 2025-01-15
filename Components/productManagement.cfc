<cffunction name="insertCategories"  access="remote" returntype="void">
      <cfargument name="categoryName" type="string">
      <cfset local.result = {success = false}>
      <cftry>
          <cfquery name = local.insertCategory>
               INSERT
               INTO
                   tblcategory(
                       fldCategoryName
                       ,fldCreatedBy
                   )
               VALUES(
                   <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
                   ,<cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
               )
         </cfquery>
      <cfcatch >
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
                fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
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
             <cfquery name = local.editCategory>
                  UPDATE
                      tblcategory
                  SET
                      fldCategoryName = <cfqueryparam value="#arguments.newCategory#" cfsqltype="varchar">,
                      fldUpdatedBy = <cfqueryparam value="#session.userId#" cfsqltype="integer">
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
         <cfloop list="#local.fetchCategory.columnList#" index="colname">
            <cfset local.structCategory[colname] = local.fetchCategory[colname][1]>
        </cfloop>
        <cfreturn local.structCategory>
    </cffunction>

    <cffunction name="deleteCategory" access="remote">
        <cfargument name="categoryId" required="true" type="integer">
        <cfquery name = local.deleteCategory>
            UPDATE
                tblcategory
            SET
                fldActive 
                = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
            WHERE
                fldCategory_Id 
                =  <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
        </cfquery>    
    </cffunction>

    <cffunction name="insertSubCategory" access="public">        
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subcategoryName"  type="string" required="true">
        <cftry>
            <cfquery name = local.insertSubCategory>
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
                   ,<cfqueryparam value="#session.userId#">
               )                    
        </cfquery>
        <cfcatch >

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
                   fldCreatedBy = <cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">
                   AND
                   fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
                   AND
                   fldCategoryId = <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
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
        <cfquery name="local.updateSubCategory">
            UPDATE
                 tblsubcategory
            SET
                fldSubCategoryName = 
                <cfqueryparam value="#arguments.newCategoryName#" cfsqltype="cf_sql_varchar">,
                fldCategoryId = 
                <cfqueryparam value="#arguments.categoryId#" cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_Id = 
                <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">                
        </cfquery>
    </cffunction>

    <cffunction name="softDeleteSubCategory" access="remote" returntype="void" >
        <cfargument name="subCategoryId" type="integer" required="true" >
        <cfquery name = local.Deactivate>
             UPDATE
                tblsubcategory
            SET
                fldActive 
                = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
            WHERE
                fldSubCategory_Id 
                =  <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">                       
        </cfquery>            
    </cffunction>

    <cffunction  name="insertProduct" access="public" returntype="void">        
        <cfargument name="subCategoryId" required="true" type="string">
        <cfargument name="productName" required="true" type="string">
        <cfargument name="brandId" required="true" type="string">
        <cfargument name="description" required="true" type="string">
        <cfargument  name="unitPrice" required="true" type="string">
        <cfargument name="unitTax" required="true" type="string" >
        <cfargument name="productImages" required="true">
        
        	<cffile
			action="uploadall"
			destination="#expandpath("./Assets/Uploads/")#"
			nameconflict="MakeUnique"
			strict="true"
			result="local.newPath"
		   >       
        <cfquery name="local.insertProduct" result="product">
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
            <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">
            ,<cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">
            ,<cfqueryparam value="#arguments.brandId#" cfsqltype="cf_sql_integer">
            ,<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
            ,<cfqueryparam value="#arguments.unitPrice#" cfsqltype="cf_sql_varchar">
            ,<cfqueryparam value="#arguments.unitTax#" cfsqltype="cf_sql_varchar">  
            ,<cfqueryparam value="#session.userId#" cfsqltype="cf_sql_integer">          
        )
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
                  <cfqueryparam value="#product.GENERATEDKEY#" cfsqltype="integer">,
                  <cfqueryparam value="#image.serverFile#" cfsqltype="varchar">,
                  <cfqueryparam value="#session.userId#" cfsqltype="varchar">,
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
        INNER JOIN
            tblproductimages PI
        ON
            P.fldProduct_Id = PI.fldProductId
            AND PI.fldDefaultImage = 1
        INNER JOIN
            tblbrand B
        ON
            P.fldBrandId = B.fldBrand_Id
        WHERE
            P.fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="integer">
            AND P.fldActive = 1;
    </cfquery>
    
      <cfreturn local.fetchProducts>
   </cffunction>

   <cffunction name="fetchSingleProduct" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="numeric">   
    <cfset local.structProduct = {}>
    <cftry>        
        <cfquery name="local.fetchProduct">
            SELECT
                tp.fldProduct_Id,
                tp.fldProductName,
                tp.fldDescription,
                tp.fldUnitPrice,
                tp.fldUnitTax,                
                tpi.fldImageFilePath,
                tb.fldBrandName,
                tp.fldBrandId
            FROM
                tblbrand AS tb
            INNER JOIN 
                tblproduct AS tp
            ON
                tb.fldBrand_Id = tp.fldBrandId
            INNER JOIN
                tblProductImages AS tpi
            ON
                tp.fldProduct_Id = tpi.fldProductId
            WHERE
                tp.fldProduct_Id = <cfqueryparam value="#arguments.productId#" cfsqltype="cf_sql_integer">
            AND
                tp.fldActive = 1
            AND
                tpi.fldActive = 1
            AND
                tpi.fldDefaultImage = 1
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
    <cfargument name="productId" required="true" type="numeric">    
    <cfargument name="subCategoryId" required="true" type="numeric">
    <cfargument name="productName" required="true" type="string">
    <cfargument name="brandId" required="true" type="numeric">
    <cfargument name="productDescription" required="true" type="string">
    <cfargument name="unitPrice" required="true" type="numeric">
    <cfargument name="unitTax" required="true" type="numeric">
    <cfargument name="productImages" required="true">

            <cffile
			action="uploadall"
			destination="#expandpath("./Assets/Uploads/")#"
			nameconflict="MakeUnique"
			strict="true"
			result="local.newPath"
		   >       

    <cfquery name="local.updateProduct">
        UPDATE
            tblproduct
        SET
            fldSubCategoryId = <cfqueryparam value = #arguments.subCategoryId# cfsqltype="integer">,
            fldProductName = <cfqueryparam value = #arguments.productName# cfsqltype="varchar">,
            fldBrandId = <cfqueryparam value = #arguments.brandId# cfsqltype="integer">,
            fldDescription = <cfqueryparam value = #arguments.productDescription# cfsqltype="varchar">,
            fldUnitPrice = <cfqueryparam value = #arguments.unitPrice# cfsqltype="integer">,
            fldUnitTax = <cfqueryparam value = #arguments.unitTax# cfsqltype="integer">,
            fldUpdatedBy = <cfqueryparam value = #session.userId# cfsqltype="integer">
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
                      <cfqueryparam value="#session.userId#" cfsqltype="varchar">,                      
                      <cfqueryparam value=0 cfsqltype="integer">                      
                   )           
                </cfquery>                           
         </cfloop>          
   
</cffunction>

<cffunction name="deleteProduct" access="remote" returntype="void">
    <cfargument name="productId" required="true" type="numeric" >
    <cfquery name="local.deleteProduct">
        UPDATE
            tblproduct
        SET
            fldActive = <cfqueryparam value="0" cfsqltype="integer">
        WHERE
            fldProduct_Id  = <cfqueryparam value="#arguments.productId#" cfsqltype="integer">                    
    </cfquery>    
</cffunction>

<cffunction name="fetchProductImages" access="remote" returntype="struct" returnformat="JSON">
    <cfargument name="productId" required="true" type="numeric">
    <cfset var local = structNew()>

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
    <cfquery name=local.resetAllThumbnail>
         UPDATE
            tblproductimages
        SET
            fldDefaultImage = <cfqueryparam value = "0" cfsqltype="integer">
        WHERE
            fldProductId = <cfqueryparam  value="#arguments.productId#">        
    </cfquery>
    <cfquery name = updateThumbnail>
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
    <cfquery name = local.softDeleteProductImage>
        UPDATE
            tblproductimages
        SET
            fldActive  = <cfqueryparam value='0' cfsqltype="integer">
        WHERE
            fldProductImage_Id = <cfqueryparam value="#arguments.productImageId#" cfsqltype="integer">
    </cfquery>
</cffunction>

