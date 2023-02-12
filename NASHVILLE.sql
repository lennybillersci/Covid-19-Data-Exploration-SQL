SELECT *
FROM Nashville_Housing_Data


SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Nashville_Housing_Data

UPDATE Nashville_Housing_Data
SET SaleDate = CONVERT(Date, SaleDate)

SELECT *
FROM Nashville_Housing_Data
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_Housing_Data a
JOIN Nashville_Housing_Data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Nashville_Housing_Data a
JOIN Nashville_Housing_Data b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

SELECT PropertyAddress
FROM Nashville_Housing_Data

--SELECT
--SUBSTRING(PropertyAddress, 2 , CASE WHEN CHARINDEX(',', PropertyAddress ) =0 then LEN(PropertyAddress) 
--else CHARINDEX(' ', PropertyAddress) -2 end) AS Address
--, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +2 , LEN(PropertyAddress)) AS Address
--FROM NASHVILLE.dbo.Nashville_Housing_Data

--SELECT
--SUBSTRING(PropertyAddress, 2 , CASE WHEN CHARINDEX(',', PropertyAddress ) =0 then LEN(PropertyAddress) 
--else CHARINDEX(' ', PropertyAddress) -1 end) AS Address
--, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress ) +1 , LEN(PropertyAddress)) AS Address
--FROM NASHVILLE.dbo.Nashville_Housing_Data

--SELECT
--SUBSTRING(PropertyAddress, 2,ABS(CHARINDEX(',', PropertyAddress) -1 )) as Address
--, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

--SELECT SUBSTRING(PropertyAdress
--From NASHVILLE.dbo.Nashville_Housing_Data

SELECT
SUBSTRING(PropertyAddress, 1, ABS(CHARINDEX(',', PropertyAddress) - 1 )) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From NASHVILLE.dbo.Nashville_Housing_Data

--deletes left side, 1 character in
UPDATE Nashville_Housing_Data SET  PropertyAddress = RIGHT(PropertyAddress, LEN(PropertyAddress)-1)
	WHERE PropertyAddress LIKE '"%';
--delets right side, 1 character in
UPDATE Nashville_Housing_Data SET  PropertyAddress = LEFT(PropertyAddress, LEN(PropertyAddress)-1)
	WHERE PropertyAddress LIKE '%"';

SELECT PropertyAddress
FROM Nashville_Housing_Data

ALTER TABLE Nashville_Housing_Data
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Nashville_Housing_Data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, ABS(CHARINDEX(',', PropertyAddress) - 1 ))

ALTER TABLE Nashville_Housing_Data
ADD PropertySplitCity NVARCHAR(255);


UPDATE Nashville_Housing_Data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
From NASHVILLE.dbo.Nashville_Housing_Data

SELECT 
PARSENAME(REPLACE(OwnerAddress, '.', ',') ,1)
From NASHVILLE.dbo.Nashville_Housing_Data

UPDATE Nashville_Housing_Data
SET OwnerAddress = REPLACE(OwnerAddress, ',', '.')

 
--Select
--PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
--,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
--,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
--From NASHVILLE.dbo.Nashville_Housing_Data
--Did not work, cannot figure out how to convert NVARCHAR to string




SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NASHVILLE.dbo.Nashville_Housing_Data
GROUP BY SoldAsVacant
ORDER BY 2

--SELECT SoldAsVacant
--, CASE WHEN SoldAsVacant = '1' THEN 'Yes'
--		 WHEN SoldAsVacant = '0' THEN 'No'
--		 ELSE SoldAsVacant
--		END
--FROM NASHVILLE.dbo.Nashville_Housing_Data


WITH RowNumCTE AS(
SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num

FROM NASHVILLE.dbo.Nashville_Housing_Data
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

ALTER TABLE NASHVILLE.dbo.Nashville_Housing_Data
DROP COLUMN TaxDistrict, PropertyAddress

SELECT *
From NASHVILLE.dbo.Nashville_Housing_Data

UPDATE Nashville_Housing_Data SET  OwnerAddress = LEFT(OwnerAddress, LEN(OwnerAddress)+5)
	WHERE OwnerAddress LIKE '%TN';


ALTER TABLE Nashville_Housing_Data
DROP COLUMN OwnerAddress;

UPDATE Nashville_Housing_Data SET PropertySplitState = Right(OwnerAddress, 3) 
FROM NASHVILLE.dbo.Nashville_Housing_Data;