/*

Cleaning Data in SQL Queries

*/
select *
from PortifolioProject..NashvilleHousing nash



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
select SaleDate 
from PortifolioProject..NashvilleHousing 

alter  table NashvilleHousing
alter column SaleDate Date 



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT *
FROM PortifolioProject..NashvilleHousing 
--where PropertyAddress is null
order by ParcelID

 
SELECT  A.ParcelID , A.PropertyAddress  , B.ParcelID , B.PropertyAddress , ISNULL(A.PropertyAddress , B.PropertyAddress ) 
FROM PortifolioProject..NashvilleHousing  A 
JOIN PortifolioProject..NashvilleHousing  B
	ON A.ParcelID =B.ParcelID AND A.[UniqueID]<> B.[UniqueID]
where A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress , B.PropertyAddress ) 
FROM PortifolioProject..NashvilleHousing  A 
JOIN PortifolioProject..NashvilleHousing  B
	ON A.ParcelID =B.ParcelID AND A.[UniqueID]<> B.[UniqueID]
where A.PropertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT *
FROM PortifolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as adress , 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as CITY

FROM PortifolioProject.dbo.NashvilleHousing



alter  table NashvilleHousing
ADD  PropertySplitAddresss NVARCHAR(255) 

UPDATE NashvilleHousing
SET PropertySplitAddresss =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
FROM PortifolioProject.dbo.NashvilleHousing

alter  table NashvilleHousing
ADD  PropertySplitcity  NVARCHAR(255) 
UPDATE NashvilleHousing
SET PropertySplitcity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))
FROM PortifolioProject.dbo.NashvilleHousing

SELECT    PropertyAddress,   PropertySplitAddresss,  PropertySplitcity 
FROM PortifolioProject.dbo.NashvilleHousing



select OwnerAddress FROM PortifolioProject.dbo.NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM PortifolioProject.dbo.NashvilleHousing


alter  table NashvilleHousing
ADD  OwnersplitAddress NVARCHAR(255) 

UPDATE NashvilleHousing
SET OwnersplitAddress =PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
FROM PortifolioProject.dbo.NashvilleHousing

alter  table NashvilleHousing
ADD  OwnersplitCity  NVARCHAR(255) 
UPDATE NashvilleHousing
SET OwnersplitCity =PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
FROM PortifolioProject.dbo.NashvilleHousing

alter  table NashvilleHousing
ADD  OwnersplitState  NVARCHAR(255) 
UPDATE NashvilleHousing
SET OwnersplitState =PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM PortifolioProject.dbo.NashvilleHousing


select OwnerAddress , OwnersplitAddress , OwnersplitCity , OwnersplitState
FROM PortifolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select SoldAsVacant , count(SoldAsVacant)
FROM PortifolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	else SoldAsVacant
	END
FROM PortifolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant= CASE
	WHEN SoldAsVacant ='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	else SoldAsVacant
	END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH rownNumCTE AS (
select * , 
	ROW_NUMBER() over(partition by ParcelID,PropertyAddress,SaleDate, SalePrice, LegalReference	order by UniqueID )row_num
FROM PortifolioProject.dbo.NashvilleHousing
)
SELECT *
FROM rownNumCTE
where row_num > 1






---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortifolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN LandUse , TaxDistrict , OwnerAddress , PropertyAddress










-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------