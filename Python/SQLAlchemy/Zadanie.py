import pandas as pd

# Loading data from an Excel file
file_path = 'D:\Battronics\Lithium.xlsm'  # Zmień na właściwą ścieżkę do pliku
df = pd.read_excel(file_path,skiprows=3)

# 1. Creating a dimension table 
dim_location = df[['Country','GPS coordinates','Major region','Site name']].drop_duplicates().reset_index(drop=True)
dim_location['LocationID'] = dim_location.index + 1

dim_ownership = df[['Ownership']].drop_duplicates().reset_index(drop=True)
dim_ownership['OwnershipID'] = dim_ownership.index + 1

dim_reporting_period = df[['Reporting period']].drop_duplicates().reset_index(drop=True)
dim_reporting_period['Reporting_periodID'] = dim_reporting_period.index + 1

dim_entry_type = df[['Entry type']].drop_duplicates().reset_index(drop=True)
dim_entry_type['Entry_typeID'] = dim_entry_type.index + 1

dim_source = df[['Source']].drop_duplicates().reset_index(drop=True)
dim_source['SourceID'] = dim_source.index + 1

dim_status = df[['Status']].drop_duplicates().reset_index(drop=True)
dim_status['StatusID'] = dim_status.index + 1

dim_comment = df[['Comment']].drop_duplicates().reset_index(drop=True)
dim_comment['CommentID'] = dim_comment.index + 1

dim_product = df[['Product']].drop_duplicates().reset_index(drop=True)
dim_product['ProductID'] = dim_product.index + 1

years = [2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 
         2026, 2027, 2028, 2029, 2030]
dim_year = pd.DataFrame({'Year': years})
dim_year['YearID'] = dim_year.index + 1

#%%

fact_sales = df.melt(id_vars=['Country','GPS coordinates','Major region','Site name' ,'Product', 'Ownership', 
                              'Reporting period', 'Entry type', 'Source', 'Status', 
                              'Comment','Purity'], 
                     value_vars=years, 
                     var_name='Year', 
                     value_name='Profit')

fact_sales['Profit'] = fact_sales['Profit'].replace({'\xa0': '', ',': ''}, regex=True)
fact_sales['Profit'] = fact_sales['Profit'].astype(float)
fact_sales['Purity'] = fact_sales['Purity'].astype(float)

#%%

# 2. Linking a fact table to dimension tables based on values
fact_sales = fact_sales.merge(dim_location[['Country','GPS coordinates', 'Major region','Site name','LocationID']], on=['Country','GPS coordinates', 'Major region','Site name'], how='left')
fact_sales = fact_sales.merge(dim_product[['Product', 'ProductID']], on='Product', how='left')
fact_sales = fact_sales.merge(dim_ownership[['Ownership', 'OwnershipID']], on='Ownership', how='left')
fact_sales = fact_sales.merge(dim_reporting_period[['Reporting period', 'Reporting_periodID']], on='Reporting period', how='left')
fact_sales = fact_sales.merge(dim_entry_type[['Entry type', 'Entry_typeID']], on='Entry type', how='left')
fact_sales = fact_sales.merge(dim_source[['Source', 'SourceID']], on='Source', how='left')
fact_sales = fact_sales.merge(dim_status[['Status', 'StatusID']], on='Status', how='left')
fact_sales = fact_sales.merge(dim_comment[['Comment', 'CommentID']], on='Comment', how='left')
fact_sales = fact_sales.merge(dim_year[['Year', 'YearID']], on='Year', how='left')

# 3. Selecting only ID and measure columns for the FactSales table
fact_sales = fact_sales[['LocationID', 'ProductID', 'OwnershipID', 
                         'Reporting_periodID', 'Entry_typeID', 'SourceID',
                         'StatusID', 'CommentID', 'YearID', 'Profit','Purity']]

#%%
from sqlalchemy import create_engine


# Creating a connection to the SQLite database
engine = create_engine('sqlite://')

# Saving dimension tables to the database
dim_location.to_sql('DimLocation', engine, index=False, if_exists='append')
dim_ownership.to_sql('DimOwnership', engine, index=False, if_exists='append')
dim_reporting_period.to_sql('DimReportingPeriod', engine, index=False, if_exists='append')
dim_entry_type.to_sql('DimEntryType', engine, index=False, if_exists='append')
dim_source.to_sql('DimSource', engine, index=False, if_exists='append')
dim_status.to_sql('DimStatus', engine, index=False, if_exists='append')
dim_comment.to_sql('DimComment', engine, index=False, if_exists='append')
dim_product.to_sql('DimProduct', engine, index=False, if_exists='append')
dim_year.to_sql('DimYear', engine, index=False, if_exists='append')

# Saving the FactSales table to the database
fact_sales.to_sql('FactSales', engine, index=False, if_exists='append')

#%%
query = """
    SELECT p.Product, y.Year, l.Country,l.'Site name', f.Profit, f.Purity
    FROM FactSales f
    JOIN DimProduct p ON f.ProductID = p.ProductID
    JOIN DimYear y ON f.YearID = y.YearID
    JOIN DimLocation l ON f.LocationID = l.LocationID
    JOIN DimComment c ON f.CommentID=c.CommentID
    WHERE y.Year = 2023 AND l.Country='Australia' AND l.'Site name'='Mt Cattlin'
    ORDER BY f.Profit DESC
"""

# Wykonywanie zapytania i przekształcanie wyników do DataFrame
df_results = pd.read_sql_query(query, engine)

print(df_results)











#%% NEW DATA
Dataframe = pd.read_excel(file_path,skiprows=3,sheet_name=['Ore mining',
                                                    'Ore processing',
                                                    'Brine extraction',
                                                    'Brine processing',
                                                    'Other processing'])

df=Dataframe['Ore processing']

#%% UPDATE

new_dim_location = df[['Country','GPS coordinates','Major region','Site name']].drop_duplicates().reset_index(drop=True)
new_dim_location['LocationID'] = new_dim_location.index + 1

new_dim_ownership = df[['Ownership']].drop_duplicates().reset_index(drop=True)
new_dim_ownership['OwnershipID'] = new_dim_ownership.index + 1

new_dim_reporting_period = df[['Reporting period']].drop_duplicates().reset_index(drop=True)
new_dim_reporting_period['Reporting_periodID'] = new_dim_reporting_period.index + 1

new_dim_entry_type = df[['Entry type']].drop_duplicates().reset_index(drop=True)
new_dim_entry_type['Entry_typeID'] = new_dim_entry_type.index + 1

new_dim_source = df[['Source']].drop_duplicates().reset_index(drop=True)
new_dim_source['SourceID'] = new_dim_source.index + 1

new_dim_status = df[['Status']].drop_duplicates().reset_index(drop=True)
new_dim_status['StatusID'] = new_dim_status.index + 1

new_dim_comment = df[['Comment']].drop_duplicates().reset_index(drop=True)
new_dim_comment['CommentID'] = new_dim_comment.index + 1

new_dim_product = df[['Product']].drop_duplicates().reset_index(drop=True)
new_dim_product['ProductID'] = new_dim_product.index + 1

years = [2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 
         2026, 2027, 2028, 2029, 2030]
new_dim_year = pd.DataFrame({'Year': years})
new_dim_year['YearID'] = new_dim_year.index + 1

new_fact_sales = df.melt(id_vars=['Country','GPS coordinates','Major region','Site name' ,'Product', 'Ownership', 
                              'Reporting period', 'Entry type', 'Source', 'Status', 
                              'Comment','Purity'], 
                     value_vars=years, 
                     var_name='Year', 
                     value_name='Profit')


new_fact_sales['Profit'] = new_fact_sales['Profit'].astype(float)
new_fact_sales['Purity'] = new_fact_sales['Purity'].astype(float)

new_fact_sales = new_fact_sales.merge(new_dim_location[['Country','GPS coordinates', 'Major region','Site name','LocationID']], on=['Country','GPS coordinates', 'Major region','Site name'], how='left')
new_fact_sales = new_fact_sales.merge(new_dim_product[['Product', 'ProductID']], on='Product', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_ownership[['Ownership', 'OwnershipID']], on='Ownership', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_reporting_period[['Reporting period', 'Reporting_periodID']], on='Reporting period', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_entry_type[['Entry type', 'Entry_typeID']], on='Entry type', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_source[['Source', 'SourceID']], on='Source', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_status[['Status', 'StatusID']], on='Status', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_comment[['Comment', 'CommentID']], on='Comment', how='left')
new_fact_sales = new_fact_sales.merge(new_dim_year[['Year', 'YearID']], on='Year', how='left')

new_fact_sales = new_fact_sales[['LocationID', 'ProductID', 'OwnershipID', 
                         'Reporting_periodID', 'Entry_typeID', 'SourceID',
                         'StatusID', 'CommentID', 'YearID', 'Profit','Purity']]

#%%
# Zapisanie tabel wymiarów do bazy danych
new_dim_location.to_sql('NewDimLocation', engine, index=False, if_exists='replace')
new_dim_ownership.to_sql('NewDimOwnership', engine, index=False, if_exists='replace')
new_dim_reporting_period.to_sql('NewDimReportingPeriod', engine, index=False, if_exists='replace')
new_dim_entry_type.to_sql('NewDimEntryType', engine, index=False, if_exists='replace')
new_dim_source.to_sql('NewDimSource', engine, index=False, if_exists='replace')
new_dim_status.to_sql('NewDimStatus', engine, index=False, if_exists='replace')
new_dim_comment.to_sql('NewDimComment', engine, index=False, if_exists='replace')
new_dim_product.to_sql('NewDimProduct', engine, index=False, if_exists='replace')
new_dim_year.to_sql('NewDimYear', engine, index=False, if_exists='replace')
new_fact_sales.to_sql('NewFactSales', engine, index=False, if_exists='replace')

#%%
query = '''
INSERT INTO DimLocation (Country, 'GPS coordinates', 'Major region', 'Site name')
SELECT Country, 'GPS coordinates', 'Major region', 'Site name'
FROM NewDimLocation
WHERE (Country, 'GPS coordinates', 'Major region', 'Site name') NOT IN (
    SELECT Country, 'GPS coordinates', 'Major region', 'Site name' FROM DimLocation
);
'''
pd.read_sql_query(query, engine)


query = '''
INSERT INTO DimOwnership (Ownership)
SELECT Ownership
FROM NewDimLocation
WHERE (Ownership) NOT IN (
    SELECT Ownership FROM DimOwnership
);
'''
pd.read_sql_query(query, engine)


query = '''
INSERT INTO DimReportingPeriod (Reporting period)
SELECT 'Reporting Period'
FROM NewDimReportingPeriod
WHERE (Reporting period) NOT IN (
    SELECT Ownership FROM DimReportingPeriod
);
'''
pd.read_sql_query(query, engine)



########################

query = '''
UPDATE NewFactSales
SET LocationID = (
    SELECT LocationID FROM DimLocation
    WHERE NewFactSales.Country = DimLocation.Country 
    AND NewFactSales.GPS_coordinates = DimLocation.GPS_coordinates 
    AND NewFactSales.Major_region = DimLocation.Major_region 
    AND NewFactSales.Site_name = DimLocation.Site_name
),
ProductID = (
    SELECT ProductID FROM DimProduct
    WHERE NewFactSales.Product = DimProduct.Product
),
YearID = (
    SELECT YearID FROM DimYear
    WHERE NewFactSales.Year = DimYear.Year
);
'''
pd.read_sql_query(query, engine)

# Następnie wstawiamy nowe rekordy do FactSales

query = '''
INSERT INTO FactSales (LocationID, ProductID, YearID, Profit, Purity)
SELECT LocationID, ProductID, YearID, Profit, Purity
FROM NewFactSales
WHERE (LocationID, ProductID, YearID) NOT IN (
    SELECT LocationID, ProductID, YearID FROM FactSales
);
'''
pd.read_sql_query(query, engine)



#%% POTENTIAL METADATA CHECK
#allowed_countries=(read from excel metadata)




