
 CREATE TABLE tblkhoa(
Makhoa char (10) PRIMARY KEY,
Tenkhoa char(30),
Dienthoai char(10)
);

CREATE TABLE tblsinhvien(		
Masv int (11) PRIMARY KEY,		
Hotensv char(40),		
Makhoa char (10),
		
Namsinh int (11),		
Quequan char (30)	,

FOREIGN KEY(Makhoa) REFERENCES tblkhoa(Makhoa)
);

CREATE TABLE tblgiangvien(		
Magv int (11)PRIMARY KEY,		
Hotengv char(30),		
Luong DECIMAL(5,2),		
Makhoa char (10),
FOREIGN KEY(Makhoa) REFERENCES  tblkhoa(Makhoa)	
);		

CREATE TABLE tbldetai(
Madt char (10)PRIMARY KEY,
Tendt char(30),
Kinhphi int(11),
Noithuctap char(30)
);

CREATE TABLE tblhuongdan(
Masv int(11) PRIMARY KEY,
Madt char(10),

Magv int (11),

KetQua DECIMAL(5,2),
FOREIGN KEY(Madt) REFERENCES  tbldetai(Madt),
FOREIGN KEY(Magv) REFERENCES  tblgiangvien(Magv)

);

INSERT INTO TBLKhoa VALUES
('Geo','Dia ly va QLTN',3855413),
('Math','Toan',3855411),
('Bio','Cong nghe Sinh hoc',3855412);

INSERT INTO TBLGiangVien VALUES
(11,'Thanh Binh',700,'Geo'),
(12,'Thu Huong',500,'Math'),
(13,'Chu Vinh',650,'Geo'),
(14,'Le Thi Ly',500,'Bio'),
(15,'Tran Son',900,'Math');

INSERT INTO TBLSinhVien VALUES
(1,'Le Van Son','Bio',1990,'Nghe An'),
(2,'Nguyen Thi Mai','Geo',1990,'Thanh Hoa'),
(3,'Bui Xuan Duc','Math',1992,'Ha Noi'),
(4,'Nguyen Van Tung','Bio',null,'Ha Tinh'),
(5,'Le Khanh Linh','Bio',1989,'Ha Nam'),
(6,'Tran Khac Trong','Geo',1991,'Thanh Hoa'),
(7,'Le Thi Van','Math',null,'null'),
(8,'Hoang Van Duc','Bio',1992,'Nghe An');

INSERT INTO TBLDeTai VALUES
('Dt01','GIS',100,'Nghe An'),
('Dt02','ARC GIS',500,'Nam Dinh'),
('Dt03','Spatial DB',100, 'Ha Tinh'),
('Dt04','MAP',300,'Quang Binh' );

INSERT INTO TBLHuongDan VALUES
(1,'Dt01',13,8),
(2,'Dt03',14,0),
(3,'Dt03',12,10),
(5,'Dt04',14,7),
(6,'Dt01',13,Null),
(7,'Dt04',11,10),
(8,'Dt03',15,6);

SELECT tblgiangvien.Magv, tblgiangvien.Hotengv, tblkhoa.Tenkhoa 
FROM tblgiangvien JOIN  tblkhoa
ON  tblgiangvien.Makhoa = tblkhoa.Makhoa 

-- 6. (CACH 1) Cho biết thông tin về sinh viên không tham gia thực tập
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv, tblsinhvien.Makhoa, tblsinhvien.Namsinh, tblsinhvien.Quequan 
FROM tblsinhvien  
WHERE (SELECT COUNT(tblhuongdan.Masv) FROM tblhuongdan WHERE Masv = tblsinhvien.Masv) = 0;
  

-- 6.(CACH 2) Cho biết thông tin về sinh viên không tham gia thực tập
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv, tblsinhvien.Makhoa, tblsinhvien.Namsinh, tblsinhvien.Quequan 
FROM tblsinhvien LEFT JOIN  tblhuongdan
ON  tblsinhvien.Masv =  tblhuongdan.Masv
WHERE tblhuongdan.Masv IS NULL;


-- 6.(CACH 3) Cho biết thông tin về sinh viên không tham gia thực tập
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv, tblsinhvien.Makhoa, tblsinhvien.Namsinh, tblsinhvien.Quequan 
FROM tblsinhvien  
WHERE NOT EXISTS (SELECT tblhuongdan.Masv FROM tblhuongdan WHERE Masv = tblsinhvien.Masv);
  

-- 7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
SELECT 
	Makhoa, 
  Tenkhoa, 
	(SELECT COUNT(Magv) FROM tblgiangvien WHERE tblkhoa.Makhoa = Makhoa) AS Sogvmoikhoa
FROM tblkhoa;

-- 4. Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa TOAN 
-- CACH 1:
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv,
-- (SELECT YEAR(CURDATE()) - tblsinhvien.Namsinh ) AS Tuoi
IFNULL((SELECT YEAR(CURDATE()) - tblsinhvien.Namsinh), 0) AS Tuoi
FROM tblsinhvien;

-- CACH 2:
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv,
-- (SELECT YEAR(CURDATE()) - tblsinhvien.Namsinh ) AS Tuoi
IFNULL((SELECT YEAR(CURDATE()) - tblsinhvien.Namsinh), 0) AS Tuoi
FROM tblsinhvien;

-- CACH 3:
SELECT tblsinhvien.Masv, tblsinhvien.Hotensv,
(CASE
WHEN tblsinhvien.Namsinh IS NULL THEN 0
ELSE YEAR(CURDATE()) - tblsinhvien.Namsinh
END) AS Tuoi  
FROM tblsinhvien;

-- 8. Cho biết số điện thoại của khoa mà sinh viên có tên Le van son đang theo học
SELECT tblkhoa.Dienthoai
FROM tblkhoa JOIN  tblsinhvien
ON  tblkhoa.Makhoa = tblsinhvien.Makhoa
WHERE tblsinhvien.Hotensv = 'Le Van Son'

-- II
-- 1. Cho biết mã số và tên của các đề tài do giảng viên Tran son hướng dẫn
SELECT tbldetai.Madt, tbldetai.Tendt 
FROM tbldetai JOIN tblhuongdan
ON  tbldetai.Madt = tblhuongdan.Madt
JOIN tblgiangvien
ON  tblgiangvien.Magv = tblhuongdan.Magv
WHERE tblgiangvien.Hotengv = 'Tran son'

-- 2. Cho biết tên đề tài không có sinh viên nào thực tập
SELECT tbldetai.Madt,  
FROM tbldetai  
WHERE NOT EXISTS (SELECT tblhuongdan.Masv FROM tblhuongdan WHERE Madt = tbldetai.Madt);


SELECT tbldetai.Madt,  
FROM tbldetai
WHERE (SELECT COUNT(tblhuongdan.Masv) FROM tblhuongdan WHERE Masv = tblsinhvien.Masv) = 0;

-- 3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
SELECT tblgiangvien.Magv, tblgiangvien.Hotengv, tblkhoa.Tenkhoa 
FROM tblgiangvien JOIN tblkhoa
ON tblgiangvien.Makhoa = tblkhoa.Makhoa
WHERE (SELECT COUNT(tblhuongdan.Magv) FROM tblhuongdan WHERE tblgiangvien.Magv = tblhuongdan.Magv) >= 3;


-- 4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất

-- CACH 1: 
SELECT tbldetai.Madt, tbldetai.Tendt
FROM tbldetai
ORDER BY Kinhphi DESC
LIMIT 1;
