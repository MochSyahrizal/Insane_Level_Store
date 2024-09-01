/* DATA PREPARATION 
The case is you need to do data preparation, migration from other data source to MySQL
Cause there is no database yet in MySQl Server, lets make the database and schema
*/

-- Making database --
CREATE DATABASE insanelevelstore;

-- Creating employee(karyawan) data table --
CREATE TABLE karyawandata (
    admin_id VARCHAR(255),
    nama VARCHAR(255),
    tanggal_karyawan DATE,
    domisili VARCHAR(255),
    jenis_kelamin VARCHAR(10),
    gaji DECIMAL,
    PRIMARY KEY (admin_id)
);


-- Insert karyawandata from csv --
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/karyawandata.csv'
INTO TABLE karyawandata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Checking karyawandata table --
SELECT 
    *
FROM
    karyawandata;



-- Creating product data table --
CREATE TABLE productdata (
    product_id VARCHAR(255),
    produk VARCHAR(255),
    kategori VARCHAR(255),
    Harga DECIMAL,
    Modal DECIMAL,
    PRIMARY KEY (product_id)
);


-- Inserting product data from csv --
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/productdata.csv'
INTO TABLE productdata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Cheking productdata table --
SELECT 
    *
FROM
    productdata;



-- Creating customer data table --
CREATE TABLE customerdata (
    User_id VARCHAR(255),
    Tanggal_Registrasi DATE,
    Waktu_Registrasi TIME,
    Nama_Customer VARCHAR(255),
    No_Handphone VARCHAR(255),
    Email VARCHAR(255),
    Tanggal_Lahir DATE,
    Kota_Domisili VARCHAR(255),
    Pekerjaan VARCHAR(255),
    Status_Hubungan VARCHAR(255),
    Jenis_Kelamin VARCHAR(255),
    PRIMARY KEY (User_id)
);

-- Inserting customr data from csv
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/customerdata.csv'
INTO TABLE customerdata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Checking customerdata table
SELECT 
    *
FROM
    customerdata;



-- Creating order data table --
CREATE TABLE orderdata (
    order_id VARCHAR(255),
    Tanggal_Order VARCHAR(255),
    Waktu_Pesan TIME NULL,
    Nama_Pemesan VARCHAR(255),
    No_Resi VARCHAR(255),
    Produk VARCHAR(255),
    Kategori VARCHAR(255),
    Jumlah_Pesanan INT,
    Harga VARCHAR(255),
    Diskon VARCHAR(255),
    Total_Harga VARCHAR(255),
    Profit VARCHAR(255),
    Kota_PengirimanMedia_Pemesanan VARCHAR(255),
    Admin_Proses VARCHAR(255),
    Ekspedisi VARCHAR(255),
    Rating VARCHAR(255),
    PRIMARY KEY (order_id)
);

-- Inserting order data from csv --
-- there is 3 file csv : backup_2018_raw, backup_2019_raw and backup_2020_raw --

-- inserting 2018 order data --
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/Order_Datasets_ Raw/backup_2018_raw.csv'
INTO TABLE orderdata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- inserting 2019 order data --
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/Order_Datasets_ Raw/backup_2019_raw.csv'
INTO TABLE orderdata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- inserting 2020 order data --
LOAD DATA INFILE 'E:/Project Porto Data/Insane Level Store/Order_Datasets_ Raw/backup_2020_raw.csv'
INTO TABLE orderdata
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- checking order data  table --
SELECT 
    *
FROM
    orderdata;



/* DATA CLEANING AND NORMALIZATION
This section you need to remove duplicates, removing null in some core column like tanggal_order, nama_pemesan, produk etc (confirmed that null is error),
after that you need to remove unnecery colum or redundance data by making good table relationship, filling the important missing value like harga(price) etc
and change the data type for proper use for each column
*/

-- Make an orderdata backup table in database --
CREATE TABLE orderdata_backup AS
SELECT *
FROM orderdata;

-- Checking if there are missing value in the core column/variable --
-- delete it cause its confirmed that the missing is error from the data system --
SELECT 
    *
FROM
    orderdata
WHERE
    order_id = '' OR Tanggal_Order = ''
        OR Waktu_Pesan = ''
        OR Nama_Pemesan = ''
        OR No_Resi = ''
        OR Produk = ''
        OR Kota_PengirimanMedia_Pemesanan = ''
;

-- Deleting rows who have mising value and checking it --
START TRANSACTION;

DELETE FROM orderdata 
WHERE
    order_id = '' OR Tanggal_Order = ''
    OR Waktu_Pesan = ''
    OR Nama_Pemesan = ''
    OR No_Resi = ''
    OR Produk = ''
    OR Kota_PengirimanMedia_Pemesanan = ''
;

-- checking --
SELECT 
    *
FROM
    orderdata;

-- commit changes --
COMMIT;

-- checking duplicates 1 --
SELECT 
    order_id,
    Tanggal_Order,
    Waktu_Pesan,
    Nama_Pemesan,
    No_Resi,
    Produk,
    Kategori,
    Jumlah_Pesanan,
    Harga,
    Diskon,
    Total_Harga,
    Profit,
    Kota_PengirimanMedia_Pemesanan,
    Admin_Proses,
    Ekspedisi,
    Rating,
    COUNT(*) AS total
FROM
    orderdata
GROUP BY order_id , Tanggal_Order , Waktu_Pesan , Nama_Pemesan , No_Resi , Produk , Kategori , Jumlah_Pesanan , Harga , Diskon , Total_Harga , Profit , Kota_PengirimanMedia_Pemesanan , Admin_Proses , Ekspedisi , Rating
HAVING COUNT(*) > 1;


-- Checking duplicates 2 --
SELECT 
    *
FROM
    orderdata
WHERE
    (order_id , Tanggal_Order,
        Waktu_Pesan,
        Nama_Pemesan,
        No_Resi,
        Produk,
        Kategori,
        Jumlah_Pesanan,
        Harga,
        Diskon,
        Total_Harga,
        Profit,
        Kota_PengirimanMedia_Pemesanan,
        Admin_Proses,
        Ekspedisi,
        Rating) IN (SELECT 
            order_id,
                Tanggal_Order,
                Waktu_Pesan,
                Nama_Pemesan,
                No_Resi,
                Produk,
                Kategori,
                Jumlah_Pesanan,
                Harga,
                Diskon,
                Total_Harga,
                Profit,
                Kota_PengirimanMedia_Pemesanan,
                Admin_Proses,
                Ekspedisi,
                Rating
        FROM
            orderdata
        GROUP BY order_id , Tanggal_Order , Waktu_Pesan , Nama_Pemesan , No_Resi , Produk , Kategori , Jumlah_Pesanan , Harga , Diskon , Total_Harga , Profit , Kota_PengirimanMedia_Pemesanan , Admin_Proses , Ekspedisi , Rating
        HAVING COUNT(*) > 1);


-- Remove duplicates --
-- There is no duplicates --
/*
DELETE t1
FROM orderdata t1
JOIN orderdata t2 
ON 
  t1.order_id > t2.order_id 
  AND t1.Tanggal_Order = t2.Tanggal_Order
  AND t1.Waktu_Pesan = t2.Waktu_Pesan
  AND t1.Nama_Pemesan = t2.Nama_Pemesan
  AND t1.No_Resi = t2.No_Resi
  AND t1.Produk = t2.Produk
  AND t1.Kategori = t2.Kategori
  AND t1.Jumlah_Pesanan = t2.Jumlah_Pesanan
  AND t1.Harga = t2.Harga
  AND t1.Diskon = t2.Diskon
  AND t1.Total_Harga = t2.Total_Harga
  AND t1.Profit = t2.Profit
  AND t1.Kota_Pengiriman = t2.Kota_Pengiriman
  AND t1.Media_Pemesanan = t2.Media_Pemesanan
  AND t1.Admin_Proses = t2.Admin_Proses
  AND t1.Ekspedisi = t2.Ekspedisi
  AND t1.Rating = t2.Rating;
*/



/* DATA NORMALIZATION AND REDUNDANCY FIX
There are some column not in correct data type like tanggal_order, diskon, total_harga, profit and rating
*/

START TRANSACTION;

-- Make a new column for order_date / tannga_order_new --
ALTER TABLE orderdata ADD COLUMN tanggal_order_new DATE AFTER tanggal_order;

-- Set value for the new colum with right format or data type --
UPDATE orderdata 
SET tanggal_order_new = STR_TO_DATE(tanggal_order, '%d/%m/%Y');

-- cheking the orderdata table structure --
DESCRIBE orderdata;

-- deleting older colum tanggal_order --
ALTER TABLE orderdata DROP COLUMN tanggal_order;

-- change the new column name to the tanggal_order --
ALTER TABLE orderdata CHANGE tanggal_order_new tanggal_order DATE;

-- checking the table --
SELECT 
    *
FROM
    orderdata;

-- commit change for column date done --
COMMIT;


-- moving to customer_name (Nama_Pemesan) column --
/* Cause we have a dedicated customer table for data, we have to change Nama_Pemesan column become user_id and fill the value with the ID,
and then we remove Nama_Pemesan column since we have id for reference to customerdata table
*/
-- make new column for user_id --
ALTER TABLE orderdata ADD COLUMN user_id varchar(255) AFTER Nama_Pemesan;

-- filling the user_id column --
UPDATE orderdata o
JOIN customerdata c ON o.Nama_Pemesan = c.Nama_Customer
SET o.user_id = c.user_id
WHERE o.user_id IS NULL;

-- checking if there any mistakes --
SELECT *
FROM orderdata o
LEFT JOIN customerdata c ON o.Nama_Pemesan = c.Nama_Customer
WHERE o.user_id IS NULL AND c.user_id IS NULL;

-- drop column nama_pemesan --
ALTER TABLE orderdata
DROP COLUMN Nama_Pemesan;

-- checking the table --
SELECT 
    *
FROM
    orderdata;




-- moving to Product (Produk) column --
/* Cause we have a dedicated produk table for data, we have to change produk column become produk_id and fill the value with the ID,
and then we remove produk. category (kategori) and price (harga) column since we have id for reference to productdata table
*/

-- make new column for product_id --
ALTER TABLE orderdata ADD COLUMN product_id varchar(255) AFTER Produk;

-- filling the product_id column --
UPDATE orderdata o
JOIN productdata p ON o.Produk = p.produk
SET o.product_id = p.product_id
WHERE o.product_id IS NULL;

-- Removing produk, kategori, and harga column
ALTER TABLE orderdata
DROP COLUMN produk,
DROP COLUMN kategori,
DROP COLUMN harga;

-- checking the table --
SELECT * FROM orderdata;



/* Moving to diskon column
there is some null, lets set it to zero
*/
UPDATE orderdata 
SET Diskon = 0
WHERE Diskon = '';

-- checking Diskon column --
SELECT Diskon
FROM orderdata
WHERE Diskon NOT REGEXP '^[0-9]+$';

-- Change data type column to int --
ALTER TABLE orderdata
MODIFY COLUMN Diskon INT;




-- Moving to Total_Harga Column --

-- fill the value with = (jumlah_pesanan x harga) x (1 - diskon / 100) --
UPDATE orderdata o
JOIN productdata p ON o.product_id = p.product_id
SET o.total_harga = (p.harga * o.jumlah_pesanan) * (1 - o.diskon / 100);

-- change total_harga to decimal data type --
ALTER TABLE orderdata
MODIFY COLUMN Total_Harga DECIMAL(10, 2);




-- Moving to profit column --
-- fill the value by = total_harga - (jumlah_pesanan x modal)
UPDATE orderdata o
JOIN productdata p ON o.product_id = p.product_id
SET o.Profit = o.Total_Harga - (o.Jumlah_Pesanan * p.Modal);

-- change total_harga to decimal data type --
ALTER TABLE orderdata
MODIFY COLUMN Profit DECIMAL(10, 2);



-- Moving to Kota_PengirimanMedia_Pemesanan column --
-- we need to use substring the column into 2 column each for each data --

-- add 2 column for each data --
ALTER TABLE orderdata
ADD COLUMN Media_Pemesanan VARCHAR(255) after Kota_PengirimanMedia_Pemesanan,
ADD COLUMN Kota VARCHAR(255) after Kota_PengirimanMedia_Pemesanan;

-- fill the value from Kota_PengirimanMedia_Pemesanan --
UPDATE orderdata
SET
    Kota = TRIM(SUBSTRING_INDEX(Kota_PengirimanMedia_Pemesanan, ' - ', 1)),
    Media_Pemesanan = TRIM(SUBSTRING_INDEX(Kota_PengirimanMedia_Pemesanan, ' - ', -1))
;

-- remove unused column --
ALTER TABLE orderdata
DROP COLUMN Kota_PengirimanMedia_Pemesanan;

-- checking the table --
SELECT 
    *
FROM
    orderdata;




/* MOVING TO Admin_Proses column
since we have dedicated table data in karyawandata table, we are gonna change the column and using admin_id instead
*/
-- make new column for admin_id --
ALTER TABLE orderdata ADD COLUMN admin_id varchar(255) AFTER Admin_Proses;

-- filling the admin_id column --
UPDATE orderdata o
JOIN karyawandata k ON o.Admin_Proses = k.nama
SET o.admin_id = k.admin_id
WHERE o.admin_id IS NULL;

-- Removing Admin_Proses column --
ALTER TABLE orderdata
DROP COLUMN Admin_Proses;

-- checking the table --
SELECT 
    *
FROM
    orderdata;



-- Moving to Ekspedisi column --
-- checking the value --
SELECT 
    *
FROM
    orderdata
WHERE
    Ekspedisi = '';

-- There are some blank value, fill these with unknown for default blank or null --
UPDATE orderdata
SET Ekspedisi = 'unknown'
WHERE Ekspedisi = '';




/* EXPLORATORY DATA ANALYSIS (EDA)
Now lets try find some several basic insights from the data like basic statictics, the most high sales product, the most less sales category etc
*/

-- Basic statistics descriptive --
SELECT 
    COUNT(*) AS Jumlah_Pesanan,
    AVG(Jumlah_Pesanan) AS RataRata_Pesanan,
    MIN(Jumlah_Pesanan) AS Min_Pesanan,
    MAX(Jumlah_Pesanan) AS Max_Pesanan,
    STD(Jumlah_Pesanan) AS StdDev_Pesanan,
    AVG(Diskon) AS RataRata_Diskon,
    AVG(Total_Harga) AS RataRata_TotalHarga,
    AVG(Profit) AS RataRata_Profit
FROM
    orderdata;
 
-- How many each unique user making order -- 
SELECT 
    user_id, COUNT(order_id) AS Jumlah_Pesanan
FROM
    orderdata
GROUP BY user_id
ORDER BY Jumlah_Pesanan DESC;


-- Let see how each product performed --
SELECT 
    product_id,
    COUNT(order_id) AS Jumlah_Pesanan,
    SUM(Jumlah_Pesanan) AS Total_Pesanan,
    SUM(Total_Harga) AS Total_Penjualan,
    SUM(Profit) AS Total_Profit
FROM
    orderdata
GROUP BY product_id
ORDER BY Total_Penjualan DESC;


-- How admin works --
SELECT 
    admin_id,
    COUNT(order_id) AS Jumlah_Pesanan,
    SUM(Total_Harga) AS Total_Penjualan,
    SUM(Profit) AS Total_Profit
FROM
    orderdata
GROUP BY admin_id
ORDER BY Total_Penjualan DESC;


-- The most shipping brand used --
SELECT 
    Ekspedisi,
    COUNT(order_id) AS Jumlah_Pesanan,
    SUM(Jumlah_Pesanan) AS Total_Pesanan
FROM
    orderdata
GROUP BY Ekspedisi
ORDER BY Jumlah_Pesanan DESC;

-- How each city performed --
SELECT 
    Kota,
    COUNT(order_id) AS Jumlah_Pesanan,
    SUM(Jumlah_Pesanan) AS Total_Pesanan
FROM
    orderdata
GROUP BY Kota
ORDER BY Jumlah_Pesanan DESC;


-- How each platform referral performed --
SELECT 
    Media_Pemesanan,
    COUNT(order_id) AS Jumlah_Pesanan,
    SUM(Jumlah_Pesanan) AS Total_Pesanan,
    SUM(Total_Harga) AS Total_Penjualan,
    SUM(Profit) AS Total_Profit
FROM
    orderdata
GROUP BY Media_Pemesanan
ORDER BY Total_Penjualan DESC;


-- Profit performed by each discount --
SELECT 
    Diskon, AVG(Profit) AS RataRata_Profit
FROM
    orderdata
GROUP BY Diskon
ORDER BY Diskon;



/* AD-HOC REQUEST
This session is making query for every ad-hoc request case, and export the data into file
*/


-- adhoc request 1 --
/*
I hope this email finds you well. As part of our CRM follow-up program, we are looking to target customers who have made purchases below the average sales amount in 2020.
Could you please provide us with a list of these customers, including their name, phone number, email, gender, domicile, and total purchase amount?
*/

SELECT 
    c.Nama_Customer,
    c.No_Handphone,
    c.Email,
    c.Jenis_Kelamin,
    c.Kota_Domisili,
    SUM(o.Total_Harga) AS Jumlah_Pembelian
FROM
    orderdata o
        JOIN
    customerdata c ON o.user_id = c.User_id
WHERE
    YEAR(o.tanggal_order) = 2020
GROUP BY c.Nama_Customer , c.No_Handphone , c.Email , c.Jenis_Kelamin , c.Kota_Domisili
HAVING SUM(o.Total_Harga) < (SELECT 
        AVG(Total_Harga)
    FROM
        orderdata
    WHERE
        YEAR(tanggal_order) = 2020);


-- adhoc request 2 --
/*
For our end-of-year analysis, we need sales data for the last three months (October to December) of each year from 2018 to 2020.
Additionally, we would like to see sales performance by city during this period.
*/

SELECT 
    YEAR(o.tanggal_order) AS Tahun,
    MONTH(o.tanggal_order) AS Bulan,
    o.Kota,
    SUM(o.Total_Harga) AS Total_Penjualan,
    COUNT(o.order_id) AS Jumlah_Order
FROM
    orderdata o
WHERE
    (MONTH(o.tanggal_order) IN (10 , 11, 12))
        AND YEAR(o.tanggal_order) IN (2018 , 2019, 2020)
GROUP BY YEAR(o.tanggal_order) , MONTH(o.tanggal_order) , o.Kota
ORDER BY Tahun , Bulan , o.Kota;


-- adhoc request 3 --
/*
HR needs to evaluate the performance of each employee/admin and identify those who have surpassed the average performance to reward them with a 25% bonus on their base salary.
Could you provide us with a report listing the employee name, domicile, gender, total sales, salary, and bonus amount (if applicable)?
*/

SELECT 
    k.nama AS nama_admin,
    k.domisili,
    k.jenis_kelamin,
    SUM(Jumlah_Pesanan) AS total_penjualan,
    k.gaji,
    CASE
        WHEN
            SUM(Jumlah_Pesanan) > (SELECT 
                    AVG(total_orders)
                FROM
                    (SELECT 
                        SUM(Jumlah_Pesanan) AS total_orders
                    FROM
                        orderdata
                    GROUP BY admin_id) AS avg_orders)
        THEN
            k.gaji * 0.25
        ELSE 0
    END AS besaran_bonus
FROM
    karyawandata k
        LEFT JOIN
    orderdata o ON k.admin_id = o.admin_id
GROUP BY k.nama , k.domisili , k.jenis_kelamin , k.gaji
ORDER BY total_penjualan DESC;


-- adhoc request 4 --
/*
We are preparing for a product review meeting next week, and we need data on product performance for Q2 2020.
Specifically, we want to identify the products with the highest and lowest ratings.
*/

SELECT 
    p.product_id,
    p.produk,
    p.kategori,
    AVG(o.Rating) AS avg_rating,
    COUNT(o.order_id) AS total_time_orders
FROM
    orderdata o
        JOIN
    productdata p ON o.product_id = p.product_id
WHERE
    YEAR(o.tanggal_order) = 2020
        AND MONTH(o.tanggal_order) BETWEEN 4 AND 6
GROUP BY p.product_id , p.produk , p.kategori
ORDER BY avg_rating DESC;
