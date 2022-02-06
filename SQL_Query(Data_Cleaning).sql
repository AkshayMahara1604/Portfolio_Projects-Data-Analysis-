--Selecting Table Nashville_Housing
select *
from Portfolio_Project_1.dbo.Nashville_Housing

--Correcting Sale Date Coloumn format

 alter table Portfolio_Project_1.dbo.Nashville_Housing 
 add Sale_Date date


update Portfolio_Project_1.dbo.Nashville_Housing
set Sale_Date = convert(date,SaleDate)

--Populate Data in property address for nulls
select *
from Portfolio_Project_1.dbo.Nashville_Housing a 
join Portfolio_Project_1.dbo.Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set a.PropertyAddress =  isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolio_Project_1.dbo.Nashville_Housing a 
join Portfolio_Project_1.dbo.Nashville_Housing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID

select * 
from Portfolio_Project_1.dbo.Nashville_Housing
where PropertyAddress is null

--Breaking out Address into individual columns

select substring(PropertyAddress ,1,charindex(',',PropertyAddress) -1) 
from Portfolio_Project_1.dbo.Nashville_Housing


alter table  Portfolio_Project_1.dbo.Nashville_Housing  --Extracting new column "Street_Address" from Column "PropertyAddress"
add Street_Address nvarchar(255) 

update   Portfolio_Project_1.dbo.Nashville_Housing
set Street_Address = substring(PropertyAddress ,1,charindex(',',PropertyAddress) -1)
from Portfolio_Project_1.dbo.Nashville_Housing

select substring(PropertyAddress ,charindex(',',PropertyAddress) +1, len(PropertyAddress)) as City
from Portfolio_Project_1.dbo.Nashville_Housing   --Extracting new column "City" from Column "PropertyAddress"

alter table Portfolio_Project_1.dbo.Nashville_Housing
add City_Name nvarchar(255)

update Portfolio_Project_1.dbo.Nashville_Housing
set City_Name = substring(PropertyAddress ,charindex(',',PropertyAddress) +1, len(PropertyAddress))
from Portfolio_Project_1.dbo.Nashville_Housing

alter table Portfolio_Project_1.dbo.Nashville_Housing
drop column City_Name;


select parsename(replace (OwnerAddress , ',','.'),1) --using PARSENAME to extract state name from column " OwnerAddress"
from Portfolio_Project_1.dbo.Nashville_Housing

alter table Portfolio_Project_1.dbo.Nashville_Housing
add state nvarchar(255)

update Portfolio_Project_1.dbo.Nashville_Housing
set state = parsename(replace (OwnerAddress , ',','.'),1)
from Portfolio_Project_1.dbo.Nashville_Housing

--Change Y and N to Yes and No in 'SoldAsVacant' column

select distinct(SoldAsVacant),count(SoldAsVacant)
from  Portfolio_Project_1.dbo.Nashville_Housing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant, 
case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
     else SoldAsVacant
	 end
from Portfolio_Project_1.dbo.Nashville_Housing


update Portfolio_Project_1.dbo.Nashville_Housing
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant = 'Y' then 'Yes'
     else SoldAsVacant
	 end
from Portfolio_Project_1.dbo.Nashville_Housing
select *
from Portfolio_Project_1.dbo.Nashville_Housing


--Removing Duplicates

drop table if exists  #Row_Num;
with Row_Num as (
select * , row_number()
over(partition by ParcelID,LandUse,PropertyAddress,SaleDate,SalePrice,LegalReference 
order by City) as new_one
from Portfolio_Project_1.dbo.Nashville_Housing
)

select *
from Row_Num
--where new_one > 1












