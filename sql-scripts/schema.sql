-- =====================================================
-- SatışPro - Satış Yönetim Sistemi
-- Veritabanı Şeması ve Sorgular
-- Marmara Üniversitesi - VTYS Dersi 2025-2026
-- =====================================================

-- =====================================================
-- DDL: TABLO OLUŞTURMA
-- =====================================================

-- 1. Kategoriler Tablosu
CREATE TABLE kategoriler (
    kategoriid SERIAL PRIMARY KEY,
    kategoriad VARCHAR(100) NOT NULL UNIQUE,
    aciklama TEXT
);

-- 2. Müşteriler Tablosu
CREATE TABLE musteriler (
    musteriid SERIAL PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefon VARCHAR(20),
    cinsiyet VARCHAR(10) CHECK (cinsiyet IN ('Erkek', 'Kadın')),
    sehir VARCHAR(50),
    musteri_tipi VARCHAR(20) DEFAULT 'Bireysel' CHECK (musteri_tipi IN ('Bireysel', 'Kurumsal')),
    kayittarihi DATE DEFAULT CURRENT_DATE
);

-- 3. Ürünler Tablosu
CREATE TABLE urunler (
    urunid SERIAL PRIMARY KEY,
    urunadi VARCHAR(150) NOT NULL,
    kategoriid INTEGER REFERENCES kategoriler(kategoriid),
    fiyat NUMERIC(10,2) NOT NULL CHECK (fiyat > 0),
    stok INTEGER DEFAULT 0 CHECK (stok >= 0),
    aciklama TEXT
);

-- 4. Siparişler Tablosu
CREATE TABLE siparisler (
    siparisid SERIAL PRIMARY KEY,
    musteriid INTEGER NOT NULL REFERENCES musteriler(musteriid),
    siparistarihi DATE DEFAULT CURRENT_DATE,
    toplamtutar NUMERIC(12,2) DEFAULT 0,
    durum VARCHAR(20) DEFAULT 'Beklemede' 
        CHECK (durum IN ('Beklemede', 'Onaylandı', 'Kargoda', 'Teslim Edildi', 'İptal')),
    odemeyontemi VARCHAR(20) CHECK (odemeyontemi IN ('Nakit', 'Kredi Kartı', 'Havale'))
);

-- 5. Sipariş Detayları Tablosu
CREATE TABLE siparisdetaylari (
    detayid SERIAL PRIMARY KEY,
    siparisid INTEGER NOT NULL REFERENCES siparisler(siparisid) ON DELETE CASCADE,
    urunid INTEGER NOT NULL REFERENCES urunler(urunid),
    miktar INTEGER NOT NULL CHECK (miktar > 0),
    birimfiyat NUMERIC(10,2) NOT NULL,
    aratoplam NUMERIC(12,2) GENERATED ALWAYS AS (miktar * birimfiyat) STORED
);

-- INDEX'ler (Performans için)
CREATE INDEX idx_siparisler_musteri ON siparisler(musteriid);
CREATE INDEX idx_siparisler_tarih ON siparisler(siparistarihi);
CREATE INDEX idx_urunler_kategori ON urunler(kategoriid);
CREATE INDEX idx_detay_siparis ON siparisdetaylari(siparisid);

-- =====================================================
-- DML: VERİ EKLEME (INSERT)
-- =====================================================

-- Kategoriler
INSERT INTO kategoriler (kategoriad, aciklama) VALUES
('Elektronik', 'Elektronik cihazlar ve aksesuarlar'),
('Bilgisayar', 'Dizüstü ve masaüstü bilgisayarlar'),
('Telefon', 'Akıllı telefonlar ve tabletler'),
('Giyim', 'Giyim ürünleri'),
('Ev & Yaşam', 'Ev elektroniği ve yaşam ürünleri'),
('Spor', 'Spor ekipmanları');

-- Müşteriler
INSERT INTO musteriler (ad, soyad, email, telefon, cinsiyet, sehir, musteri_tipi) VALUES
('Ali', 'Yılmaz', 'ali.yilmaz@email.com', '0532-111-1111', 'Erkek', 'İstanbul', 'Kurumsal'),
('Ayşe', 'Demir', 'ayse.demir@email.com', '0533-222-2222', 'Kadın', 'Ankara', 'Bireysel'),
('Mehmet', 'Kaya', 'mehmet.kaya@email.com', '0534-333-3333', 'Erkek', 'İzmir', 'Bireysel'),
('Fatma', 'Çelik', 'fatma.celik@email.com', '0535-444-4444', 'Kadın', 'Bursa', 'Bireysel'),
('Can', 'Özkan', 'can.ozkan@email.com', '0536-555-5555', 'Erkek', 'Antalya', 'Kurumsal'),
('Zeynep', 'Aydın', 'zeynep.aydin@email.com', '0537-666-6666', 'Kadın', 'İstanbul', 'Bireysel'),
('Emre', 'Şahin', 'emre.sahin@email.com', '0538-777-7777', 'Erkek', 'Ankara', 'Bireysel'),
('Elif', 'Arslan', 'elif.arslan@email.com', '0539-888-8888', 'Kadın', 'İzmir', 'Bireysel'),
('Burak', 'Koç', 'burak.koc@email.com', '0530-999-9999', 'Erkek', 'İstanbul', 'Kurumsal'),
('Selin', 'Yıldız', 'selin.yildiz@email.com', '0531-000-0000', 'Kadın', 'Ankara', 'Bireysel');

-- Ürünler
INSERT INTO urunler (urunadi, kategoriid, fiyat, stok, aciklama) VALUES
('Laptop Pro 15', 2, 24999.99, 50, 'Intel i7, 16GB RAM, 512GB SSD'),
('Laptop Air 14', 2, 18999.99, 35, 'Intel i5, 8GB RAM, 256GB SSD'),
('SmartPhone X', 3, 14999.99, 100, '6.5 inch, 128GB, 5G'),
('SmartPhone Lite', 3, 8999.99, 150, '6.1 inch, 64GB, 4G'),
('Tablet Pro', 3, 12999.99, 45, '10.5 inch, 256GB'),
('Kablosuz Mouse', 2, 299.99, 200, 'Ergonomik tasarım'),
('Mekanik Klavye', 2, 899.99, 80, 'RGB aydınlatma'),
('Bluetooth Kulaklık', 1, 2499.99, 60, 'Noise cancelling'),
('4K Monitor 27"', 2, 6999.99, 40, '4K UHD, 144Hz'),
('Spor Ayakkabı', 6, 1299.99, 120, 'Koşu için ideal'),
('Elektrikli Süpürge', 5, 4999.99, 30, 'Kablosuz, güçlü emiş'),
('Kahve Makinesi', 5, 2499.99, 45, 'Otomatik, 15 bar basınç'),
('Robot Süpürge', 5, 8999.99, 20, 'Akıllı haritalama'),
('Air Fryer', 5, 3499.99, 35, '5L kapasite'),
('Koşu Bandı', 6, 15999.99, 10, 'Katlanabilir, 18km/h'),
('Dambıl Seti', 6, 1999.99, 50, '2-20kg arası'),
('Yoga Matı', 6, 299.99, 100, 'Kaymaz, 6mm'),
('Erkek Mont', 4, 1999.99, 40, 'Su geçirmez, kışlık'),
('Kadın Ceket', 4, 1499.99, 35, 'Deri, şık tasarım');

-- Siparişler
INSERT INTO siparisler (musteriid, siparistarihi, toplamtutar, durum, odemeyontemi) VALUES
(1, '2024-01-15', 25299.98, 'Teslim Edildi', 'Kredi Kartı'),
(2, '2024-01-18', 14999.99, 'Teslim Edildi', 'Havale'),
(3, '2024-02-05', 9899.97, 'Teslim Edildi', 'Kredi Kartı'),
(4, '2024-02-12', 18999.99, 'Teslim Edildi', 'Nakit'),
(5, '2024-03-01', 3699.97, 'Kargoda', 'Kredi Kartı'),
(6, '2024-03-10', 44999.97, 'Onaylandı', 'Havale'),
(7, '2024-03-15', 27499.98, 'Teslim Edildi', 'Kredi Kartı'),
(1, '2024-04-02', 2499.99, 'Teslim Edildi', 'Kredi Kartı'),
(8, '2024-04-10', 8999.99, 'Kargoda', 'Havale'),
(9, '2024-04-20', 1499.98, 'Beklemede', 'Nakit'),
(2, '2024-05-05', 6999.99, 'Teslim Edildi', 'Kredi Kartı'),
(10, '2024-05-12', 3499.99, 'Onaylandı', 'Havale');

-- Sipariş Detayları
INSERT INTO siparisdetaylari (siparisid, urunid, miktar, birimfiyat) VALUES
(1, 1, 1, 24999.99),
(1, 6, 1, 299.99),
(2, 3, 1, 14999.99),
(3, 4, 1, 8999.99),
(3, 7, 1, 899.99),
(4, 2, 1, 18999.99),
(5, 10, 2, 1299.99),
(5, 17, 3, 299.99),
(6, 1, 1, 24999.99),
(6, 3, 1, 14999.99),
(6, 8, 2, 2499.99),
(7, 2, 1, 18999.99),
(7, 8, 1, 2499.99),
(7, 9, 1, 6999.99),
(8, 8, 1, 2499.99),
(9, 13, 1, 8999.99),
(10, 6, 2, 299.99),
(10, 7, 1, 899.99),
(11, 9, 1, 6999.99),
(12, 14, 1, 3499.99);

-- =====================================================
-- DML: GÜNCELLEME (UPDATE) ÖRNEKLERİ
-- =====================================================

-- Ürün fiyatını güncelle
UPDATE urunler SET fiyat = 22999.99 WHERE urunid = 1;

-- Sipariş durumunu güncelle
UPDATE siparisler SET durum = 'Kargoda' WHERE siparisid = 10;

-- Stok güncelle
UPDATE urunler SET stok = stok + 20 WHERE kategoriid = 5;

-- =====================================================
-- DML: SİLME (DELETE) ÖRNEKLERİ
-- =====================================================

-- İptal edilen siparişleri sil
-- DELETE FROM siparisler WHERE durum = 'İptal';

-- Stokta olmayan ürünleri sil
-- DELETE FROM urunler WHERE stok = 0;

-- =====================================================
-- SELECT SORGULARI (10 ADET)
-- =====================================================

-- 1. TEMEL SELECT: Tüm müşterileri listele
SELECT * FROM musteriler ORDER BY kayittarihi DESC;

-- 2. FİLTRELEME: İstanbul'daki kurumsal müşteriler
SELECT ad, soyad, email, sehir, musteri_tipi 
FROM musteriler 
WHERE sehir = 'İstanbul' AND musteri_tipi = 'Kurumsal';

-- 3. SIRALAMA: En pahalı 5 ürün
SELECT urunadi, fiyat, stok 
FROM urunler 
ORDER BY fiyat DESC 
LIMIT 5;

-- 4. JOIN (2 tablo): Siparişler ve müşteri adları
SELECT s.siparisid, m.ad || ' ' || m.soyad AS musteri, 
       s.toplamtutar, s.durum, s.odemeyontemi
FROM siparisler s
JOIN musteriler m ON s.musteriid = m.musteriid
ORDER BY s.siparistarihi DESC;

-- 5. JOIN + GROUP BY + SUM: Müşteri bazlı toplam harcama
SELECT m.ad || ' ' || m.soyad AS musteri, 
       m.musteri_tipi,
       COUNT(s.siparisid) AS siparis_sayisi,
       SUM(s.toplamtutar) AS toplam_harcama
FROM musteriler m
JOIN siparisler s ON m.musteriid = s.musteriid
GROUP BY m.musteriid, m.ad, m.soyad, m.musteri_tipi
ORDER BY toplam_harcama DESC;

-- 6. JOIN (3 tablo) + GROUP BY: Kategori bazlı satış geliri
SELECT k.kategoriad, 
       COUNT(sd.detayid) AS satis_adedi,
       SUM(sd.aratoplam) AS toplam_gelir
FROM kategoriler k
JOIN urunler u ON k.kategoriid = u.kategoriid
JOIN siparisdetaylari sd ON u.urunid = sd.urunid
GROUP BY k.kategoriad
ORDER BY toplam_gelir DESC;

-- 7. HAVING: 20.000₺ üstü harcayan müşteriler
SELECT m.ad || ' ' || m.soyad AS musteri,
       m.musteri_tipi,
       SUM(s.toplamtutar) AS toplam_harcama
FROM musteriler m
JOIN siparisler s ON m.musteriid = s.musteriid
GROUP BY m.musteriid, m.ad, m.soyad, m.musteri_tipi
HAVING SUM(s.toplamtutar) > 20000
ORDER BY toplam_harcama DESC;

-- 8. JOIN (4 tablo): Detaylı sipariş listesi
SELECT s.siparisid, 
       m.ad || ' ' || m.soyad AS musteri,
       u.urunadi, 
       k.kategoriad,
       sd.miktar, 
       sd.aratoplam
FROM siparisler s
JOIN musteriler m ON s.musteriid = m.musteriid
JOIN siparisdetaylari sd ON s.siparisid = sd.siparisid
JOIN urunler u ON sd.urunid = u.urunid
JOIN kategoriler k ON u.kategoriid = k.kategoriid
ORDER BY s.siparisid;

-- 9. AGGREGATE + GROUP BY: Şehir bazlı satış analizi
SELECT m.sehir,
       COUNT(DISTINCT m.musteriid) AS musteri_sayisi,
       COUNT(s.siparisid) AS siparis_sayisi,
       SUM(s.toplamtutar) AS toplam_satis,
       ROUND(AVG(s.toplamtutar), 2) AS ortalama_siparis
FROM musteriler m
JOIN siparisler s ON m.musteriid = s.musteriid
WHERE s.durum != 'İptal'
GROUP BY m.sehir
ORDER BY toplam_satis DESC;

-- 10. GROUP BY + HAVING: En çok satan ürünler (min 2 satış)
SELECT u.urunadi, 
       k.kategoriad,
       SUM(sd.miktar) AS toplam_adet,
       SUM(sd.aratoplam) AS toplam_gelir
FROM urunler u
JOIN kategoriler k ON u.kategoriid = k.kategoriid
JOIN siparisdetaylari sd ON u.urunid = sd.urunid
GROUP BY u.urunid, u.urunadi, k.kategoriad
HAVING SUM(sd.miktar) >= 2
ORDER BY toplam_adet DESC;

-- =====================================================
-- VIEW: Müşteri Satış Özeti
-- =====================================================

CREATE VIEW v_musteri_satis_ozeti AS
SELECT 
    m.musteriid,
    m.ad || ' ' || m.soyad AS musteri_adi,
    m.musteri_tipi,
    m.sehir,
    COUNT(s.siparisid) AS siparis_sayisi,
    COALESCE(SUM(s.toplamtutar), 0) AS toplam_harcama,
    MAX(s.siparistarihi) AS son_siparis_tarihi
FROM musteriler m
LEFT JOIN siparisler s ON m.musteriid = s.musteriid AND s.durum != 'İptal'
GROUP BY m.musteriid, m.ad, m.soyad, m.musteri_tipi, m.sehir;

-- View kullanımı
SELECT * FROM v_musteri_satis_ozeti WHERE toplam_harcama > 10000;

-- =====================================================
-- STORED PROCEDURE: Yeni Sipariş Oluşturma
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_yeni_siparis(
    p_musteriid INTEGER,
    p_urunid INTEGER,
    p_miktar INTEGER,
    p_odemeyontemi VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_siparisid INTEGER;
    v_fiyat NUMERIC(10,2);
    v_toplam NUMERIC(12,2);
BEGIN
    -- Ürün fiyatını al
    SELECT fiyat INTO v_fiyat FROM urunler WHERE urunid = p_urunid;
    v_toplam := v_fiyat * p_miktar;
    
    -- Siparişi oluştur
    INSERT INTO siparisler (musteriid, toplamtutar, odemeyontemi)
    VALUES (p_musteriid, v_toplam, p_odemeyontemi)
    RETURNING siparisid INTO v_siparisid;
    
    -- Sipariş detayını ekle
    INSERT INTO siparisdetaylari (siparisid, urunid, miktar, birimfiyat)
    VALUES (v_siparisid, p_urunid, p_miktar, v_fiyat);
    
    -- Stoku güncelle
    UPDATE urunler SET stok = stok - p_miktar WHERE urunid = p_urunid;
    
    RAISE NOTICE 'Sipariş oluşturuldu. ID: %', v_siparisid;
END;
$$;

-- Stored Procedure kullanımı
-- CALL sp_yeni_siparis(1, 3, 2, 'Nakit');

-- =====================================================
-- TRANSACTION ÖRNEĞİ
-- =====================================================

-- BEGIN;
-- INSERT INTO siparisler (musteriid, toplamtutar, odemeyontemi) 
-- VALUES (1, 25299.98, 'Kredi Kartı') RETURNING siparisid;
-- INSERT INTO siparisdetaylari (siparisid, urunid, miktar, birimfiyat) VALUES (13, 1, 1, 24999.99);
-- UPDATE urunler SET stok = stok - 1 WHERE urunid = 1;
-- COMMIT;
```
