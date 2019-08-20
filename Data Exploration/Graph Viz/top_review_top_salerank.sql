use Amazone_Product_Metadata
go
select top 15 n.asin, count(*) as numReviews 
from New_Full_Review n 
group by n.asin
order by count(*) desc
/*
	B004D1GZ2E	1953
	B0026P3G12	1926
*/
update New_Product_Music
set title = 'Gangnam Style (강남스타일)', salesRank=1523
where asin = 'B00970FKQ8'


WITH CTE (asin, numReviews) AS(
   SELECT TOP 50 asin, count(*)
   FROM dbo.New_Full_Review
   GROUP BY asin
   ORDER BY count(*) desc
)
SELECT TOP 50 c.asin, p.title, p.salesRank, p.price, 'top_review' as category, c.numReviews 
FROM CTE c left join New_Product_Music p ON p.asin=c.asin order by c.numReviews desc

go

SELECT top 50 np.asin, np.title, np.salesRank, np.price, 'top_salesrank' as category, nr.numReviews
FROM New_Product_Music np
	left join (
		select asin as asin_2, count(*) as numReviews
		from New_Full_Review
		group by asin
	) nr ON nr.asin_2 = np.asin 
WHERE title is not null and salesRank != 0 order by salesRank asc


select top 10 * from New_Review_Music where asin = 'B000002WPI'




