# SatışPro - Satış Yönetim Sistemi

Marmara Üniversitesi Teknoloji Fakültesi - Veritabanı Yönetim Sistemleri Dersi Projesi (2025-2026)

## 📋 Proje Hakkında

SatışPro, e-ticaret ve perakende işletmeleri için geliştirilmiş kapsamlı bir satış yönetim sistemidir. Müşteri yönetimi, ürün kataloğu, sipariş takibi ve detaylı raporlama özellikleri sunar.

## 🛠 Teknolojiler

| Katman | Teknoloji |
|--------|-----------|
| Veritabanı | PostgreSQL 15 |
| Backend | Node.js + Express.js |
| Frontend | HTML5, CSS3, JavaScript |
| Grafikler | Chart.js |
| Araçlar | Azure Data Studio, Docker, VS Code |

## 📁 Proje Yapısı
```
sales-dashboard/
├── client/                 # Frontend dosyaları
│   ├── index.html          # Dashboard
│   ├── satislar.html       # Satış yönetimi
│   ├── musteriler.html     # Müşteri yönetimi
│   ├── urunler.html        # Ürün yönetimi
│   ├── raporlar.html       # Raporlar
│   ├── style.css           # Stiller
│   └── app.js              # JavaScript
├── server/                 # Backend dosyaları
│   ├── server.js           # Express API
│   ├── package.json        # Bağımlılıklar
│   └── .env                # Ortam değişkenleri
├── database/               # Veritabanı dosyaları
│   └── schema.sql          # DDL, DML ve Sorgular
└── README.md
```

## 🗄 Veritabanı Yapısı

### Tablolar

| Tablo | Açıklama |
|-------|----------|
| kategoriler | Ürün kategorileri |
| musteriler | Müşteri bilgileri (Bireysel/Kurumsal) |
| urunler | Ürün kataloğu |
| siparisler | Sipariş başlık bilgileri |
| siparisdetaylari | Sipariş detayları |

### ER Diagramı
```
kategoriler (1) ──────< (N) urunler
musteriler  (1) ──────< (N) siparisler
siparisler  (1) ──────< (N) siparisdetaylari
urunler     (1) ──────< (N) siparisdetaylari
```

## ⚙️ Kurulum

### 1. Veritabanı
```bash
# PostgreSQL'de veritabanı oluştur
CREATE DATABASE satispro;

# schema.sql dosyasını çalıştır
```

### 2. Backend
```bash
cd server
npm install
npm start
# Server: http://localhost:3000
```

### 3. Frontend
```bash
# VS Code Live Server eklentisi ile
# client/index.html dosyasını aç
# Veya: http://localhost:5500
```

## ✨ Özellikler

### Dashboard
- Toplam satış, müşteri, ürün istatistikleri
- Aylık satış grafiği
- Kategori bazlı satış grafiği

### Satış Yönetimi
- Sipariş listesi ve filtreleme
- Yeni sipariş oluşturma
- Durum güncelleme (Beklemede, Onaylandı, Kargoda, Teslim Edildi, İptal)
- Müşteri tipi filtresi (Bireysel/Kurumsal)

### Müşteri Yönetimi
- Müşteri CRUD işlemleri
- Bireysel/Kurumsal müşteri desteği
- Cinsiyet, şehir filtreleme
- Arama özelliği

### Ürün Yönetimi
- Ürün CRUD işlemleri
- Kategori bazlı filtreleme
- Stok durumu takibi (Stokta, Az, Kritik)
- Kart görünümü

### Raporlar
- Aylık satış trendi
- Müşteri tipine göre satış
- Şehirlere göre satış
- Ödeme yöntemleri dağılımı
- Kategori satışları
- En çok satan ürünler

## 📊 SQL Sorguları

Projede kullanılan örnek sorgular:
```sql
-- Müşteri bazlı toplam harcama
SELECT m.ad || ' ' || m.soyad AS musteri, 
       SUM(s.toplamtutar) AS toplam_harcama
FROM musteriler m
JOIN siparisler s ON m.musteriid = s.musteriid
GROUP BY m.musteriid, m.ad, m.soyad
ORDER BY toplam_harcama DESC;

-- Kategori bazlı satış geliri
SELECT k.kategoriad, SUM(sd.aratoplam) AS toplam_gelir
FROM kategoriler k
JOIN urunler u ON k.kategoriid = u.kategoriid
JOIN siparisdetaylari sd ON u.urunid = sd.urunid
GROUP BY k.kategoriad
ORDER BY toplam_gelir DESC;
```

Tüm sorgular için: `database/schema.sql`



## 📝 Lisans

Bu proje Marmara Üniversitesi VTYS dersi kapsamında eğitim amaçlı geliştirilmiştir.