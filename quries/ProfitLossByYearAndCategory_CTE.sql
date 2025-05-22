with ProfitLoss as (    SELECT    
        YEAR([ShipDate]) AS SaleYear,
        [OrderQuantity] * [UnitPrice] AS GrossSale,
        ([OrderQuantity] * [UnitPrice]) - ([DiscountAmount] + [TaxAmt] + [Freight]) AS NetSale,
        [TotalProductCost] AS TotalCost      
		,p.EnglishProductName as Product
		,psc.EnglishProductSubcategoryName as SubCategory
		,pc.EnglishProductCategoryName as Category
    FROM [AdventureWorksDW2020].[dbo].[FactInternetSales] as FS 
	inner join DimProduct as P on fs.ProductKey = p.ProductKey
	inner join DimProductSubcategory psc on p.ProductSubcategoryKey = psc.ProductCategoryKey 
	inner join DimProductCategory pc on pc.ProductCategoryKey = psc.ProductCategoryKey
	where ShipDate is not null ) 

SELECT 
    SaleYear,Category,
    SUM(GrossSale) AS GrossSale,
    SUM(NetSale) AS NetSale,
    SUM(TotalCost) AS TotalCost,
    SUM(NetSale) - SUM(TotalCost) AS Profit
FROM ProfitLoss
GROUP BY SaleYear,category
ORDER BY SaleYear;
