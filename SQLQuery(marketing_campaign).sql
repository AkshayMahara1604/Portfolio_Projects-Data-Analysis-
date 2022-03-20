select *
from customer_analysis..marketing_campaign


--Removing NULL from column Teenhome

update  customer_analysis..marketing_campaign
set Teenhome = 0 
where Teenhome is NULL

 -- Avg expenditure on various items

 select avg(MntWines) as avg_mnt_wines , avg(MntFruits) as avg_mnt_fruits , avg(MntMeatProducts) as avg_mnt_meat,
avg(MntFishProducts) as avg_mnt_fish , avg(MntSweetProducts) as avg_mnt_sweet , avg(MntGoldProds) as avg_mnt_gold
 from customer_analysis..marketing_campaign


 --Count of people based on the campaign purchase

select sum(AcceptedCmp1) as campaign_1, sum(AcceptedCmp2) as campaign_2, sum(AcceptedCmp3)as campaign_3, sum(AcceptedCmp4) as campaign_4, sum(AcceptedCmp5) as campaign_5, sum(Response) as last_campaign
from customer_analysis..marketing_campaign
 

 
--Deals and web visits

select NumDealsPurchases , NumWebVisitsMonth
from customer_analysis..marketing_campaign

--Adding a new column 'age_category' to show the current age of customers 

alter table customer_analysis..marketing_campaign
drop column age_category

alter table customer_analysis..marketing_campaign
drop column age_group


alter table customer_analysis..marketing_campaign
add age_group int;

update customer_analysis..marketing_campaign
set age_group = 2022 - Year_Birth;

-- Grouping age by creating a new column 'age_group'

alter table customer_analysis..marketing_campaign
add age_group int;


UPDATE customer_analysis..marketing_campaign
set age_group = 
case 
when age_group < 30 then 20
when age_group < 40 then 30
when age_group < 50 then 40
when age_group < 60 then 50
when age_group < 70 then 60
when age_group < 80 then 70
when age_group < 90 then 80
when age_group < 100 then 90
else 100
end
from customer_analysis..marketing_campaign ;

--To find the number of family members using Marital_Status , Kidhome and Teenhome

with family(Kidhome , Teenhome , kids , Marital_Status, Education,  total_expenses,no_family_members,Income)
as 
(

SELECT Kidhome , Teenhome , (Kidhome + Teenhome) as kids , Marital_Status, Education,(MntWines + MntFruits + MntMeatProducts +MntFishProducts
+MntSweetProducts+MntGoldProds) as total_expenses,
case 
when Marital_Status = 'Married' then Kidhome + Teenhome +2
when Marital_Status = 'Together' then Kidhome + Teenhome +2 
else Kidhome + Teenhome + 1 
end as no_family_members, Income 
from customer_analysis..marketing_campaign
)

-- Family members and total expenses 

select no_family_members, avg(total_expenses) AS avg_total_expenses, count(total_expenses) as count_total
from family
group by no_family_members
order by no_family_members 

--Size of family and thier different expenses 
with family_1(No_family_members,total_expenses,Income,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds)
as 
(

SELECT 
case 
when Marital_Status = 'Married' then Kidhome + Teenhome +2
when Marital_Status = 'Together' then Kidhome + Teenhome +2 
else Kidhome + Teenhome + 1 
end as No_family_members,  (MntWines + MntFruits + MntMeatProducts +MntFishProducts+MntSweetProducts+MntGoldProds) as total_expenses,Income 
,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds
from customer_analysis..marketing_campaign

)
select No_family_members , avg(MntWines) as avg_mnt_wines , avg(MntFruits) as avg_mnt_fruits , avg(MntMeatProducts) as avg_mnt_meat,
avg(MntFishProducts) as avg_mnt_fish , avg(MntSweetProducts) as avg_mnt_sweet , avg(MntGoldProds) as avg_mnt_gold, count(No_family_members) as total_count,
avg(Income) as avg_income
from family_1
group by No_family_members 
order by No_family_members

-- Age and average income

select  age_group , avg(Income) as avg_income
 from customer_analysis..marketing_campaign
 group by age_group
 order by age_group

 -- Education and income

 select Education , count(Education) as count_total, avg(Income) as avg_income
 from customer_analysis..marketing_campaign
 group by Education




 -- Age and Place of Purchase 

 select age_group ,count(ID) as total_count,avg(NumWebPurchases) as avg_web, avg(NumCatalogPurchases)as avg_catalog, avg(NumStorePurchases) as avg_store,avg(NumWebVisitsMonth) as avg_web_visit
  from customer_analysis..marketing_campaign
group by age_group 
order by age_group

-- Age and expenses

select age_group , count(ID) as total_count,avg(Income) as avg_income,avg(MntWines + MntFruits + MntMeatProducts +MntFishProducts+MntSweetProducts+MntGoldProds) as avg_total_expenses
from customer_analysis..marketing_campaign
group by age_group 
order by age_group

--Age and family members 

with family_2(No_family_members,age_group,total_expenses)
as 
(

SELECT 
case 
when Marital_Status = 'Married' then Kidhome + Teenhome +2
when Marital_Status = 'Together' then Kidhome + Teenhome +2 
else Kidhome + Teenhome + 1 
end as No_family_members,age_group,  (MntWines + MntFruits + MntMeatProducts +MntFishProducts+MntSweetProducts+MntGoldProds) as total_expenses
from customer_analysis..marketing_campaign

)
select  age_group , avg(total_expenses) as avg_expenses  ,avg(No_family_members) as avg_family_members 
from family_2
group by age_group
order by age_group




--Income vs Expenses 

 with income(Income_group , expenses )
 as
 (
 select 
 case 
 when Income <= 10000 then '10k'
  when Income <= 20000 then '20k'
   when Income <= 30000 then '30k'
  when Income <= 40000 then '40k'
  when Income <= 50000 then '50k'
  when Income <= 60000 then '60k'
   when Income <= 70000 then '70k'
  when Income <= 80000 then '80k'
   when Income <= 90000 then '90k'
  when Income <= 100000 then '1000k'
  else 'over100k'
  end as Income_group
  , (MntWines + MntFruits + MntMeatProducts +MntFishProducts+MntSweetProducts+MntGoldProds)
  from customer_analysis..marketing_campaign
  )
 select Income_group , avg(expenses) as avg_expenses, count(Income_group) as total_count
 from income
 group by Income_group
 order by Income_group

