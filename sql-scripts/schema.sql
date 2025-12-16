-- =====================================================
-- KATEGORİLER TABLOSU
-- =====================================================
CREATE TABLE IF NOT EXISTS kategoriler (
    kategoriid SERIAL PRIMARY KEY,
    kategoriad VARCHAR(100) NOT NULL UNIQUE,
    aciklama TEXT
);

-- =====================================================
-- ÜRÜNLER TABLOSU
-- =====================================================
CREATE TABLE IF NOT EXISTS urunler (
    urunid SERIAL PRIMARY KEY,
    urunadi VARCHAR(150) NOT NULL,
    kategoriid INTEGER NOT NULL REFERENCES kategoriler(kategoriid),
    fiyat DECIMAL(10, 2) NOT NULL CHECK (fiyat >= 0),
    stok INTEGER NOT NULL CHECK (stok >= 0),
    aciklama TEXT
);

-- =====================================================
-- MÜŞTERİLER TABLOSU
-- =====================================================
CREATE TABLE IF NOT EXISTS musteriler (
    musteriid SERIAL PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    telefon VARCHAR(15),
    musteritipi VARCHAR(50),
    cinsiyet VARCHAR(10),
    sehir VARCHAR(50),
    kayittarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- SİPARİŞLER TABLOSU
-- =====================================================
CREATE TABLE IF NOT EXISTS siparisler (
    siparisid SERIAL PRIMARY KEY,
    musteriid INTEGER NOT NULL REFERENCES musteriler(musteriid),
    siparistarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    toplamtutar DECIMAL(12, 2) NOT NULL CHECK (toplamtutar >= 0),
    durum VARCHAR(50) DEFAULT 'Beklemede',
    odemeyontemi VARCHAR(50)
);

-- =====================================================
-- SİPARİŞ DETAYLARI TABLOSU
-- =====================================================
CREATE TABLE IF NOT EXISTS siparisdetaylari (
    detayid SERIAL PRIMARY KEY,
    siparisid INTEGER NOT NULL REFERENCES siparisler(siparisid),
    urunid INTEGER NOT NULL REFERENCES urunler(urunid),
    miktar INTEGER NOT NULL CHECK (miktar > 0),
    birimfiyat DECIMAL(10, 2) NOT NULL CHECK (birimfiyat >= 0),
    aratoplam DECIMAL(12, 2) NOT NULL CHECK (aratoplam >= 0)
);

-- =====================================================
-- İNDEKSLER
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_urunler_kategoriid ON urunler(kategoriid);
CREATE INDEX IF NOT EXISTS idx_siparisler_musteriid ON siparisler(musteriid);
CREATE INDEX IF NOT EXISTS idx_siparisler_tarih ON siparisler(siparistarihi);
CREATE INDEX IF NOT EXISTS idx_siparisdetaylari_siparisid ON siparisdetaylari(siparisid);
CREATE INDEX IF NOT EXISTS idx_siparisdetaylari_urunid ON siparisdetaylari(urunid);

-- =====================================================
-- KATEGORİLER - ÖRNEK VERİLER
-- =====================================================
INSERT INTO kategoriler (kategoriad, aciklama) VALUES
    ('Elektronik', 'Elektronik cihazlar ve aksesuarlar'),
    ('Bilgisayar', 'Dizüstü ve masaüstü bilgisayarlar'),
    ('Telefon', 'Akıllı telefonlar ve tabletler'),
    ('Giyim', 'Erkek ve kadın giyim ürünleri'),
    ('Ev & Yaşam', 'Ev dekorasyon ürünleri'),
    ('Spor', 'Spor ekipmanları')
ON CONFLICT DO NOTHING;

-- =====================================================
-- MÜŞTERİLER - ÖRNEK VERİLER
-- =====================================================
INSERT INTO musteriler (ad, soyad, email, telefon, musteritipi, cinsiyet, sehir, kayittarihi) VALUES
    ('Ali', 'Yılmaz', 'ali1@mail.com', '05310012345', 'Bireysel', 'Erkek', 'İstanbul', '2023-01-16'),
    ('Ayşe', 'Demir', 'ayse2@mail.com', '05320024690', 'Bireysel', 'Kadın', 'Ankara', '2023-01-31'),
    ('Mehmet', 'Kaya', 'mehmet3@mail.com', '05330037035', 'Kurumsal', 'Erkek', 'İzmir', '2023-02-15'),
    ('Elif', 'Şahin', 'elif4@mail.com', '05340049380', 'Bireysel', 'Kadın', 'Bursa', '2023-03-02'),
    ('Can', 'Koç', 'can5@mail.com', '05350061725', 'Kurumsal', 'Erkek', 'Antalya', '2023-03-17'),
    ('Zeynep', 'Acar', 'zeynep6@mail.com', '05360074070', 'Bireysel', 'Kadın', 'İstanbul', '2023-04-01'),
    ('Burak', 'Aslan', 'burak7@mail.com', '05370086415', 'Bireysel', 'Erkek', 'Adana', '2023-04-16'),
    ('Selin', 'Yıldız', 'selin8@mail.com', '05380098760', 'Kurumsal', 'Kadın', 'İzmir', '2023-05-01'),
    ('Emre', 'Çelik', 'emre9@mail.com', '05390111105', 'Bireysel', 'Erkek', 'Ankara', '2023-05-16'),
    ('Ceren', 'Kurt', 'ceren10@mail.com', '05400123450', 'Bireysel', 'Kadın', 'İstanbul', '2023-05-31'),
    ('Mert', 'Ak', 'mert11@mail.com', '05410135795', 'Kurumsal', 'Erkek', 'Bursa', '2023-06-15'),
    ('Derya', 'Öztürk', 'derya12@mail.com', '05420148140', 'Bireysel', 'Kadın', 'Antalya', '2023-06-30'),
    ('Onur', 'Polat', 'onur13@mail.com', '05430160485', 'Kurumsal', 'Erkek', 'İzmir', '2023-07-15'),
    ('Seda', 'Arslan', 'seda14@mail.com', '05440172830', 'Bireysel', 'Kadın', 'Ankara', '2023-07-30'),
    ('Tolga', 'Şen', 'tolga15@mail.com', '05450185175', 'Kurumsal', 'Erkek', 'İstanbul', '2023-08-14'),
    ('Pelin', 'Güneş', 'pelin16@mail.com', '05460197520', 'Bireysel', 'Kadın', 'Bursa', '2023-08-29'),
    ('Kaan', 'Demirtaş', 'kaan17@mail.com', '05470209865', 'Kurumsal', 'Erkek', 'Adana', '2023-09-13'),
    ('İrem', 'Kaplan', 'irem18@mail.com', '05480222210', 'Bireysel', 'Kadın', 'İzmir', '2023-09-28'),
    ('Serkan', 'Bozkurt', 'serkan19@mail.com', '05490234555', 'Kurumsal', 'Erkek', 'Ankara', '2023-10-13'),
    ('Ece', 'Bulut', 'ece20@mail.com', '05500246900', 'Bireysel', 'Kadın', 'İstanbul', '2023-10-28'),
    ('Hakan', 'Önal', 'hakan21@mail.com', '05510259245', 'Kurumsal', 'Erkek', 'Antalya', '2023-11-12'),
    ('Büşra', 'Kılıç', 'busra22@mail.com', '05520271590', 'Bireysel', 'Kadın', 'Bursa', '2023-11-27'),
    ('Umut', 'Karaca', 'umut23@mail.com', '05530283935', 'Kurumsal', 'Erkek', 'İzmir', '2023-12-12'),
    ('Naz', 'Yavuz', 'naz24@mail.com', '05540296280', 'Bireysel', 'Kadın', 'Ankara', '2023-12-27'),
    ('Furkan', 'Eren', 'furkan25@mail.com', '05550308625', 'Kurumsal', 'Erkek', 'İstanbul', '2023-01-11')
ON CONFLICT DO NOTHING;

-- =====================================================
-- ÜRÜNLER - ÖRNEK VERİLER
-- =====================================================
INSERT INTO urunler (urunid, urunadi, kategoriid, fiyat, stok, aciklama) VALUES
    (1, 'Bluetooth Kulaklık', 1, 1500.00, 100, 'Yüksek kaliteli elektronik ürün'),
    (2, 'Akıllı Saat', 1, 3200.00, 80, 'Yüksek kaliteli elektronik ürün'),
    (3, 'Powerbank', 1, 900.00, 150, 'Yüksek kaliteli elektronik ürün'),
    (4, 'Kablosuz Şarj', 1, 1100.00, 90, 'Yüksek kaliteli elektronik ürün'),
    (5, 'Webcam', 1, 1400.00, 70, 'Yüksek kaliteli elektronik ürün'),
    (6, 'Laptop Pro', 2, 28000.00, 30, 'Bilgisayar ve çevre birimleri'),
    (7, 'Mekanik Klavye', 2, 2500.00, 60, 'Bilgisayar ve çevre birimleri'),
    (8, 'Gaming Mouse', 2, 1800.00, 75, 'Bilgisayar ve çevre birimleri'),
    (9, 'SSD 1TB', 2, 3200.00, 50, 'Bilgisayar ve çevre birimleri'),
    (10, 'Monitör 27"', 2, 8500.00, 25, 'Bilgisayar ve çevre birimleri'),
    (11, 'Telefon X', 3, 18000.00, 40, 'Akıllı telefon ve mobil cihaz'),
    (12, 'Telefon Y', 3, 22000.00, 35, 'Akıllı telefon ve mobil cihaz'),
    (13, 'Telefon Z', 3, 26000.00, 20, 'Akıllı telefon ve mobil cihaz'),
    (14, 'Tablet A', 3, 12000.00, 30, 'Akıllı telefon ve mobil cihaz'),
    (15, 'Tablet B', 3, 16000.00, 25, 'Akıllı telefon ve mobil cihaz'),
    (16, 'Tişört', 4, 450.00, 200, 'Giyim ve tekstil ürünü'),
    (17, 'Kot Pantolon', 4, 900.00, 120, 'Giyim ve tekstil ürünü'),
    (18, 'Mont', 4, 2800.00, 50, 'Giyim ve tekstil ürünü'),
    (19, 'Spor Ayakkabı', 4, 3500.00, 60, 'Giyim ve tekstil ürünü'),
    (20, 'Eşofman', 4, 1300.00, 90, 'Giyim ve tekstil ürünü'),
    (21, 'Masa Lambası', 5, 1200.00, 70, 'Ev yaşam ve dekorasyon ürünü'),
    (22, 'Halı', 5, 4500.00, 40, 'Ev yaşam ve dekorasyon ürünü'),
    (23, 'Perde', 5, 2300.00, 60, 'Ev yaşam ve dekorasyon ürünü'),
    (24, 'Dekor Vazo', 5, 950.00, 80, 'Ev yaşam ve dekorasyon ürünü'),
    (25, 'Çay Seti', 5, 1700.00, 55, 'Ev yaşam ve dekorasyon ürünü'),
    (26, 'Dambıl Seti', 6, 3200.00, 45, 'Spor ve fitness ekipmanı'),
    (27, 'Yoga Matı', 6, 850.00, 100, 'Spor ve fitness ekipmanı'),
    (28, 'Koşu Bandı', 6, 24000.00, 10, 'Spor ve fitness ekipmanı'),
    (29, 'Futbol Topu', 6, 650.00, 150, 'Spor ve fitness ekipmanı'),
    (30, 'Spor Çanta', 6, 1800.00, 70, 'Spor ve fitness ekipmanı')
ON CONFLICT DO NOTHING;

-- =====================================================
-- SİPARİŞLER - ÖRNEK VERİLER
-- =====================================================
INSERT INTO siparisler (siparisid, musteriid, siparistarihi, toplamtutar, durum, odemeyontemi) VALUES
    (1, 1, '2024-01-05', 48000.00, 'Onaylandı', 'Kredi Kartı'),
    (2, 2, '2024-01-06', 3200.00, 'Teslim Edildi', 'Havale'),
    (3, 3, '2024-01-07', 9000.00, 'Kargoda', 'Nakit'),
    (4, 4, '2024-01-08', 1300.00, 'Beklemede', 'Kredi Kartı'),
    (5, 5, '2024-01-09', 1500.00, 'Onaylandı', 'Havale'),
    (6, 6, '2024-01-10', 54900.00, 'Teslim Edildi', 'Kredi Kartı'),
    (7, 7, '2024-01-11', 1500.00, 'Kargoda', 'Nakit'),
    (8, 8, '2024-01-12', 5500.00, 'Onaylandı', 'Kredi Kartı'),
    (9, 9, '2024-01-13', 45500.00, 'Beklemede', 'Havale'),
    (10, 10, '2024-01-14', 5150.00, 'Teslim Edildi', 'Kredi Kartı'),
    (11, 11, '2024-01-15', 13200.00, 'Onaylandı', 'Nakit'),
    (12, 12, '2024-01-16', 2150.00, 'Kargoda', 'Kredi Kartı'),
    (13, 13, '2024-01-17', 1500.00, 'Teslim Edildi', 'Havale'),
    (14, 14, '2024-01-18', 37400.00, 'Onaylandı', 'Kredi Kartı'),
    (15, 15, '2024-01-19', 16000.00, 'Beklemede', 'Nakit'),
    (16, 16, '2024-01-20', 1500.00, 'Kargoda', 'Havale'),
    (17, 17, '2024-01-21', 3700.00, 'Teslim Edildi', 'Kredi Kartı'),
    (18, 18, '2024-01-22', 13300.00, 'Onaylandı', 'Nakit'),
    (19, 19, '2024-01-23', 95300.00, 'Beklemede', 'Havale'),
    (20, 20, '2024-01-24', 1500.00, 'Kargoda', 'Kredi Kartı'),
    (21, 21, '2024-01-25', 1900.00, 'Teslim Edildi', 'Nakit'),
    (22, 22, '2024-01-26', 3600.00, 'Onaylandı', 'Havale'),
    (23, 23, '2024-01-27', 1500.00, 'Beklemede', 'Kredi Kartı'),
    (24, 24, '2024-01-28', 57200.00, 'Kargoda', 'Nakit'),
    (25, 25, '2024-01-29', 1500.00, 'Teslim Edildi', 'Havale'),
    (26, 1, '2024-02-01', 2900.00, 'Onaylandı', 'Kredi Kartı'),
    (27, 2, '2024-02-02', 1500.00, 'Kargoda', 'Havale'),
    (28, 3, '2024-02-03', 1500.00, 'Teslim Edildi', 'Nakit'),
    (29, 4, '2024-02-04', 14800.00, 'Beklemede', 'Kredi Kartı'),
    (30, 5, '2024-02-05', 10500.00, 'Onaylandı', 'Havale'),
    (31, 6, '2024-02-06', 1500.00, 'Kargoda', 'Kredi Kartı'),
    (32, 7, '2024-02-07', 1500.00, 'Teslim Edildi', 'Nakit'),
    (33, 8, '2024-02-08', 1500.00, 'Beklemede', 'Havale'),
    (34, 9, '2024-02-09', 3900.00, 'Onaylandı', 'Kredi Kartı'),
    (35, 10, '2024-02-10', 1500.00, 'Kargoda', 'Nakit'),
    (36, 11, '2024-02-11', 4150.00, 'Teslim Edildi', 'Havale'),
    (37, 12, '2024-02-12', 1500.00, 'Beklemede', 'Kredi Kartı'),
    (38, 13, '2024-02-13', 1500.00, 'Onaylandı', 'Nakit'),
    (39, 14, '2024-02-14', 1500.00, 'Kargoda', 'Havale'),
    (40, 15, '2024-02-15', 46500.00, 'Teslim Edildi', 'Kredi Kartı'),
    (41, 16, '2024-02-16', 1950.00, 'Beklemede', 'Nakit'),
    (42, 17, '2024-02-17', 1500.00, 'Onaylandı', 'Havale'),
    (43, 18, '2024-02-18', 1500.00, 'Kargoda', 'Kredi Kartı'),
    (44, 19, '2024-02-19', 28000.00, 'Teslim Edildi', 'Nakit'),
    (45, 20, '2024-02-20', 1350.00, 'Beklemede', 'Havale'),
    (46, 21, '2024-02-21', 1500.00, 'Onaylandı', 'Kredi Kartı'),
    (47, 22, '2024-02-22', 6650.00, 'Kargoda', 'Nakit'),
    (48, 23, '2024-02-23', 10300.00, 'Teslim Edildi', 'Havale'),
    (49, 24, '2024-02-24', 4600.00, 'Beklemede', 'Kredi Kartı'),
    (50, 25, '2024-02-25', 3000.00, 'Onaylandı', 'Nakit')
ON CONFLICT DO NOTHING;

-- =====================================================
-- SİPARİŞ DETAYLARI - ÖRNEK VERİLER
-- =====================================================
INSERT INTO siparisdetaylari (detayid, siparisid, urunid, miktar, birimfiyat, aratoplam) VALUES
    (1, 6, 3, 1, 900.00, 900.00),
    (2, 6, 13, 1, 26000.00, 26000.00),
    (3, 8, 23, 1, 2300.00, 2300.00),
    (4, 8, 26, 1, 3200.00, 3200.00),
    (5, 9, 13, 1, 26000.00, 26000.00),
    (6, 9, 11, 1, 18000.00, 18000.00),
    (7, 10, 9, 1, 3200.00, 3200.00),
    (8, 10, 4, 1, 1100.00, 1100.00),
    (9, 11, 10, 1, 8500.00, 8500.00),
    (10, 11, 4, 1, 1100.00, 1100.00),
    (11, 12, 1, 1, 1500.00, 1500.00),
    (12, 12, 29, 1, 650.00, 650.00),
    (13, 14, 13, 1, 26000.00, 26000.00),
    (14, 14, 3, 1, 900.00, 900.00),
    (15, 17, 7, 1, 2500.00, 2500.00),
    (16, 17, 21, 1, 1200.00, 1200.00),
    (17, 18, 14, 1, 12000.00, 12000.00),
    (18, 18, 20, 1, 1300.00, 1300.00),
    (19, 19, 6, 1, 28000.00, 28000.00),
    (20, 19, 20, 1, 1300.00, 1300.00),
    (21, 24, 26, 1, 3200.00, 3200.00),
    (22, 24, 11, 1, 18000.00, 18000.00),
    (23, 26, 27, 1, 850.00, 850.00),
    (24, 26, 4, 1, 1100.00, 1100.00),
    (25, 29, 14, 1, 12000.00, 12000.00),
    (26, 29, 4, 1, 1100.00, 1100.00),
    (27, 36, 29, 1, 650.00, 650.00),
    (28, 36, 8, 1, 1800.00, 1800.00),
    (29, 40, 22, 1, 4500.00, 4500.00),
    (30, 40, 28, 1, 24000.00, 24000.00),
    (31, 41, 20, 1, 1300.00, 1300.00),
    (32, 41, 29, 1, 650.00, 650.00),
    (33, 47, 27, 1, 850.00, 850.00),
    (34, 47, 9, 1, 3200.00, 3200.00),
    (35, 48, 8, 1, 1800.00, 1800.00),
    (36, 48, 10, 1, 8500.00, 8500.00),
    (37, 49, 25, 1, 1700.00, 1700.00),
    (38, 49, 4, 1, 1100.00, 1100.00),
    (39, 50, 25, 1, 1700.00, 1700.00),
    (40, 50, 16, 1, 450.00, 450.00),
    (41, 15, 15, 1, 16000.00, 16000.00),
    (42, 2, 26, 1, 3200.00, 3200.00),
    (43, 34, 20, 3, 1300.00, 3900.00),
    (44, 30, 19, 3, 3500.00, 10500.00),
    (45, 19, 12, 3, 22000.00, 66000.00),
    (46, 49, 8, 1, 1800.00, 1800.00),
    (47, 47, 20, 2, 1300.00, 2600.00),
    (48, 21, 24, 2, 950.00, 1900.00),
    (49, 50, 27, 1, 850.00, 850.00),
    (50, 3, 22, 2, 4500.00, 9000.00),
    (51, 22, 30, 2, 1800.00, 3600.00),
    (52, 24, 14, 3, 12000.00, 36000.00),
    (53, 44, 6, 1, 28000.00, 28000.00),
    (54, 45, 16, 3, 450.00, 1350.00),
    (55, 29, 25, 1, 1700.00, 1700.00),
    (56, 36, 27, 2, 850.00, 1700.00),
    (57, 14, 19, 3, 3500.00, 10500.00),
    (58, 4, 29, 2, 650.00, 1300.00),
    (59, 11, 21, 3, 1200.00, 3600.00),
    (60, 1, 28, 2, 24000.00, 48000.00),
    (61, 26, 24, 1, 950.00, 950.00),
    (62, 6, 6, 1, 28000.00, 28000.00),
    (63, 10, 27, 1, 850.00, 850.00),
    (64, 9, 1, 1, 1500.00, 1500.00),
    (65, 40, 11, 1, 18000.00, 18000.00),
    (66, 20, 1, 1, 1500.00, 1500.00),
    (67, 25, 1, 1, 1500.00, 1500.00),
    (68, 27, 1, 1, 1500.00, 1500.00),
    (69, 39, 1, 1, 1500.00, 1500.00),
    (70, 33, 1, 1, 1500.00, 1500.00),
    (71, 31, 1, 1, 1500.00, 1500.00),
    (72, 46, 1, 1, 1500.00, 1500.00),
    (73, 13, 1, 1, 1500.00, 1500.00),
    (74, 5, 1, 1, 1500.00, 1500.00),
    (75, 37, 1, 1, 1500.00, 1500.00),
    (76, 32, 1, 1, 1500.00, 1500.00),
    (77, 38, 1, 1, 1500.00, 1500.00),
    (78, 28, 1, 1, 1500.00, 1500.00),
    (79, 42, 1, 1, 1500.00, 1500.00),
    (80, 16, 1, 1, 1500.00, 1500.00),
    (81, 23, 1, 1, 1500.00, 1500.00),
    (82, 43, 1, 1, 1500.00, 1500.00),
    (83, 35, 1, 1, 1500.00, 1500.00),
    (84, 7, 1, 1, 1500.00, 1500.00)
ON CONFLICT DO NOTHING;
