--Cleaning Data in SQL Queries

Select * 
from PortfolioProject2..NashvilleHousing


-- Standardize Date Format

Alter table PortfolioProject2..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject2..NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)


--Populate Property Address data


Select *
from PortfolioProject2..NashvilleHousing
--where PropertyAddress is null  
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2..NashvilleHousing a
join PortfolioProject2..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null  


update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject2..NashvilleHousing a
join PortfolioProject2..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null  

--Breaking out Address into Individual Columns(Address, City, State)


Select PropertyAddress
from PortfolioProject2..NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))


from PortfolioProject2..NashvilleHousing


Alter table PortfolioProject2..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject2..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)



Alter table PortfolioProject2..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject2..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress))


Select *
from PortfolioProject2..NashvilleHousing




Select OwnerAddress
from PortfolioProject2..NashvilleHousing


Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject2..NashvilleHousing



Alter table PortfolioProject2..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject2..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject2..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject2..NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject2..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject2..NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)




--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject2..NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant,
Case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject2..NashvilleHousing

Update PortfolioProject2..NashvilleHousing
 Set SoldAsVacant = Case when SoldAsVacant= 'Y' then 'Yes'
          when SoldAsVacant= 'N' then 'No'
          else SoldAsVacant
          end



--Remove Duplicates

WITH RowNumCTE as(
Select *,

ROW_NUMBER() over(
Partition by ParcelID,
             PropertyAddress,	     
			 Convert(BIGINT, SalePrice),
			 SaleDate,
			 LegalReference
			 ORDER BY
				UniqueID
				) as row_num



from PortfolioProject2..NashvilleHousing)

Select *
from RowNumCTE
Where row_num>1
order by PropertyAddress


-- Delete Unused Columns

Select *
from PortfolioProject2..NashvilleHousing

Alter table PortfolioProject2..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter table PortfolioProject2..NashvilleHousing
Drop Column SaleDate