SELECT 
    SaleYear,
    SUM(GrossSale) AS GrossSale,
    SUM(NetSale) AS NetSale,
    SUM(TotalCost) AS TotalCost,
    SUM(NetSale) - SUM(TotalCost) AS Profit
FROM (
    SELECT    
        YEAR([ShipDate]) AS SaleYear,
        [OrderQuantity] * [UnitPrice] AS GrossSale,
        ([OrderQuantity] * [UnitPrice]) - ([DiscountAmount] + [TaxAmt] + [Freight]) AS NetSale,
        [TotalProductCost] AS TotalCost      
    FROM [AdventureWorksDW2020].[dbo].[FactInternetSales]
	where ShipDate is not null 
) AS ProfitLoss
GROUP BY SaleYear
ORDER BY SaleYear;
