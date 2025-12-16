# 📊 Sales Dashboard - Satış Yönetim Sistemi

Türkiye'de satış ve müşteri yönetimi için geliştirilen modern, profesyonel bir web tabanlı satış panosu uygulaması.

## 🎯 Proje Özellikleri

### Dashboard
- **Gerçek Zamanlı İstatistikler**: Toplam satış, müşteri sayısı, ürün sayısı, sipariş sayısı
- **Aylık Satış Trendi**: Line chart ile satışların zaman içindeki değişimi
- **Kategori Bazlı Satışlar**: Doughnut chart ile ürün kategorilerinin dağılımı
- **Son Siparişler**: En son oluşturulan siparişlerin tablosu

### Müşteri Yönetimi
- ✅ Müşteri listeleme (tüm detaylarıyla)
- ✅ Yeni müşteri ekleme
- ✅ Müşteri bilgileri güncelleme
- ✅ Müşteri silme
- 📋 Müşteri türü: Bireysel / Kurumsal
- 📍 Şehir bazlı segmentasyon

### Ürün Yönetimi
- ✅ Ürün listeleme (kategori ile)
- ✅ Yeni ürün ekleme
- ✅ Ürün bilgileri güncelleme
- ✅ Ürün silme
- 📊 Stok seviyesi gösterimi (kritik stok uyarısı)
- 🏷️ 6 ana kategori:
  - Elektronik
  - Bilgisayar
  - Telefon & Tablet
  - Giyim
  - Ev & Yaşam
  - Spor & Fitness

### Sipariş Yönetimi
- ✅ Sipariş listeleme (müşteri bilgileri ile)
- ✅ Yeni sipariş oluşturma (birden fazla ürün seçebilir)
- ✅ Sipariş durumu güncelleme (5 farklı durum)
- ✅ Sipariş detaylarını görüntüleme
- 💳 Ödeme yöntemleri: Kredi Kartı, Havale, Nakit
- 📦 Sipariş durumları: Beklemede, Onaylandı, Kargoda, Teslim Edildi, İptal

### Raporlar & Analitikler
- 👥 **Cinsiyet Bazlı Satış**: Doughnut chart ile erkek/kadın dağılımı
- 🏪 **Müşteri Tipi Analizi**: Bireysel vs Kurumsal satışlar
- 🗺️ **Şehir Bazlı Raporlar**: Şehirlere göre satış ve sipariş dağılımı
- 💰 **Ödeme Yöntemi Analizi**: Ödeme türlerine göre gelir dağılımı
- 📈 **Top 10 Ürünler**: En çok satan ürünlerin listesi
- 📊 **Aylık Satış Trendi**: Bar chart ile aylık satış performansı

## 📁 Proje Yapısı

```
sales-dashboard/
│
├── README.md                 # Proje dokümantasyonu
├── package.json             # Backend bağımlılıkları
│
├── client/                  # Frontend dosyaları
│   ├── index.html           # Dashboard ana sayfası
│   ├── musteriler.html      # Müşteri yönetimi sayfası
│   ├── urunler.html         # Ürün yönetimi sayfası
│   ├── satislar.html        # Sipariş yönetimi sayfası
│   ├── raporlar.html        # Raporlar ve analitikler sayfası
│   ├── app.js               # Frontend JavaScript kodu
│   └── style.css            # Tüm sayfaların CSS stilleri
│
├── server/                  # Backend dosyaları
│   ├── server.js            # Express.js API sunucusu
│   └── package.json         # Backend bağımlılıkları
│
└── sql-scripts/             # Veritabanı scriptleri
    └── schema.sql           # PostgreSQL şema ve örnek veriler
```

## 🗄️ Veritabanı Şeması

### ER Diyagramı

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ┌──────────────────┐      ┌──────────────────┐                │
│  │  KATEGORILER     │      │   MUSTERILER     │                │
│  ├──────────────────┤      ├──────────────────┤                │
│  │ kategoriid (PK)  │      │ musteriid (PK)   │                │
│  │ kategoriad       │      │ ad               │                │
│  │ aciklama         │      │ soyad            │                │
│  └──────────────────┘      │ email            │                │
│         △                   │ telefon          │                │
│         │                   │ musteritipi      │                │
│         │ (1:N)             │ cinsiyet         │                │
│         │                   │ sehir            │                │
│  ┌──────────────────┐      │ kayittarihi      │                │
│  │   URUNLER        │      └──────────────────┘                │
│  ├──────────────────┤               △                          │
│  │ urunid (PK)      │               │                          │
│  │ urunadi          │               │ (1:N)                    │
│  │ kategoriid (FK)  │───┐           │                          │
│  │ fiyat            │   │     ┌──────────────────┐             │
│  │ stok             │   └────→│   SIPARISLER     │             │
│  │ aciklama         │         ├──────────────────┤             │
│  └──────────────────┘         │ siparisid (PK)   │             │
│         △                     │ musteriid (FK)   │◄────────────┘
│         │                     │ siparistarihi    │
│         │ (1:N)               │ toplamtutar      │
│         │                     │ durum            │
│  ┌──────────────────┐         │ odemeyontemi     │
│  │SIPARISDETAYLARI  │         └──────────────────┘
│  ├──────────────────┤                △
│  │ detayid (PK)     │                │
│  │ siparisid (FK)   │────────────────┘
│  │ urunid (FK)      │───────┐
│  │ miktar           │       │
│  │ birimfiyat       │       │
│  │ aratoplam        │       │
│  └──────────────────┘       │
│                             │
│                    (1:N)    │
│                             ▼
│                  ┌──────────────────┐
│                  │   URUNLER        │
│                  └──────────────────┘
│
└─────────────────────────────────────────────────────────────────┘

Tablo İlişkileri:
================
1. KATEGORILER (1) ─── (N) URUNLER
   - Bir kategori birden fazla ürünü içerir

2. MUSTERILER (1) ─── (N) SIPARISLER
   - Bir müşteri birden fazla sipariş verebilir

3. SIPARISLER (1) ─── (N) SIPARISDETAYLARI
   - Bir sipariş birden fazla ürün içerebilir

4. URUNLER (1) ─── (N) SIPARISDETAYLARI
   - Bir ürün birden fazla siparişte yer alabilir
```

### Tablo Detayları

#### 📋 KATEGORILER
| Sütun | Tip | Açıklama |
|-------|-----|----------|
| kategoriid | SERIAL (PK) | Kategori ID |
| kategoriad | VARCHAR(100) | Kategori Adı (Elektronik, Bilgisayar, vb.) |
| aciklama | TEXT | Kategori Açıklaması |

**Veriler**: 6 kategori

#### 👥 MUSTERILER
| Sütun | Tip | Açıklama |
|-------|-----|----------|
| musteriid | SERIAL (PK) | Müşteri ID |
| ad | VARCHAR(50) | Müşteri Adı |
| soyad | VARCHAR(50) | Müşteri Soyadı |
| email | VARCHAR(100) | E-posta Adresi |
| telefon | VARCHAR(15) | Telefon Numarası |
| musteritipi | VARCHAR(50) | Bireysel / Kurumsal |
| cinsiyet | VARCHAR(10) | Erkek / Kadın |
| sehir | VARCHAR(50) | İkamet Şehri (Türkçe: İstanbul, İzmir, vb.) |
| kayittarihi | TIMESTAMP | Kayıt Tarihi |

**Veriler**: 25 müşteri
**Şehirler**: İstanbul, Ankara, İzmir, Bursa, Antalya, Adana

#### 📦 URUNLER
| Sütun | Tip | Açıklama |
|-------|-----|----------|
| urunid | SERIAL (PK) | Ürün ID |
| urunadi | VARCHAR(150) | Ürün Adı |
| kategoriid | INTEGER (FK) | Kategori ID (kategoriler tablosuna referans) |
| fiyat | DECIMAL(10,2) | Ürün Fiyatı (₺) |
| stok | INTEGER | Mevcut Stok Miktarı |
| aciklama | TEXT | Ürün Açıklaması |

**Veriler**: 30 ürün
**Fiyat Aralığı**: 450₺ - 28.000₺

#### 🛒 SIPARISLER
| Sütun | Tip | Açıklama |
|-------|-----|----------|
| siparisid | SERIAL (PK) | Sipariş ID |
| musteriid | INTEGER (FK) | Müşteri ID (musteriler tablosuna referans) |
| siparistarihi | TIMESTAMP | Sipariş Tarihi |
| toplamtutar | DECIMAL(12,2) | Sipariş Toplam Tutarı (₺) |
| durum | VARCHAR(50) | Durum (Beklemede, Onaylandı, Kargoda, Teslim Edildi, İptal) |
| odemeyontemi | VARCHAR(50) | Ödeme Yöntemi (Kredi Kartı, Havale, Nakit) |

**Veriler**: 50 sipariş
**Tarih Aralığı**: 2024-01-05 ile 2024-02-25

#### 📊 SIPARISDETAYLARI
| Sütun | Tip | Açıklama |
|-------|-----|----------|
| detayid | SERIAL (PK) | Detay ID |
| siparisid | INTEGER (FK) | Sipariş ID (siparisler tablosuna referans) |
| urunid | INTEGER (FK) | Ürün ID (urunler tablosuna referans) |
| miktar | INTEGER | Sipariş Edilen Ürün Miktarı |
| birimfiyat | DECIMAL(10,2) | Birim Fiyatı (₺) |
| aratoplam | DECIMAL(12,2) | Satır Toplam Tutarı (₺) |

**Veriler**: 84 sipariş detay satırı

## 🚀 Kurulum ve Çalıştırma

### Ön Gereksinimler
- Node.js (v14 veya üzeri)
- PostgreSQL (v12 veya üzeri)
- npm veya yarn

### Adım 1: Veritabanı Kurulumu

```bash
# PostgreSQL'de yeni veritabanı oluştur
createdb sales_dashboard

# schema.sql dosyasını çalıştır
psql -U postgres -d sales_dashboard -f sql-scripts/schema.sql
```

### Adım 2: Backend Kurulumu

```bash
cd server

# Bağımlılıkları yükle
npm install

# .env dosyası oluştur (örnek)
cat > .env << EOF
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sales_dashboard
DB_USER=postgres
DB_PASSWORD=your_password
PORT=3000
EOF

# Sunucuyu başlat
npm start
# veya geliştirme modu
npm run dev
```

### Adım 3: Frontend Çalıştırma

```bash
# Herhangi bir HTTP sunucusu ile client klasörünü serve et

# Seçenek 1: Node.js http-server
npx http-server client -p 8080

# Seçenek 2: Python
cd client
python -m http.server 8080

# Seçenek 3: Live Server (VS Code extension)
# VS Code'da Live Server uzantısını yükle ve index.html'de sağ tıkla -> Open with Live Server
```

### Adım 4: Tarayıcıda Aç

```
http://localhost:8080
```

## 📊 Veri Özeti

### Mevcut Veriler

| Öğe | Sayı |
|-----|------|
| 📊 Kategoriler | 6 |
| 👥 Müşteriler | 25 |
| 📦 Ürünler | 30 |
| 🛒 Siparişler | 50 |
| 📋 Sipariş Detayları | 84 |

### Toplam Satış Rakamları
- **Toplam Satış**: ₺768.475,00+
- **Ortalama Sipariş Değeri**: ₺15.369,50
- **En Yüksek Sipariş**: ₺95.300,00
- **En Düşük Sipariş**: ₺1.300,00

## 🔌 API Endpoints

### Dashboard
```
GET  /api/dashboard/stats           - İstatistikleri al
GET  /api/dashboard/aylik-satis     - Aylık satış trendi
GET  /api/dashboard/kategori-satis  - Kategori bazlı satışlar
```

### Müşteriler
```
GET    /api/musteriler              - Tüm müşterileri listele
GET    /api/musteriler/:id          - Tek müşteri getir
POST   /api/musteriler              - Yeni müşteri ekle
PUT    /api/musteriler/:id          - Müşteri güncelle
DELETE /api/musteriler/:id          - Müşteri sil
```

### Ürünler
```
GET    /api/urunler                 - Tüm ürünleri listele
GET    /api/urunler/:id             - Tek ürün getir
POST   /api/urunler                 - Yeni ürün ekle
PUT    /api/urunler/:id             - Ürün güncelle
DELETE /api/urunler/:id             - Ürün sil
```

### Siparişler
```
GET    /api/siparisler              - Tüm siparişleri listele
GET    /api/siparisler/:id          - Sipariş detaylarıyla getir
POST   /api/siparisler              - Yeni sipariş oluştur
PUT    /api/siparisler/:id/durum    - Sipariş durumu güncelle
DELETE /api/siparisler/:id          - Sipariş sil
```

### Raporlar
```
GET    /api/raporlar/cinsiyet       - Cinsiyet bazlı satışlar
GET    /api/raporlar/musteri-tipi   - Müşteri tipi bazlı satışlar
GET    /api/raporlar/sehir          - Şehir bazlı satışlar
GET    /api/raporlar/odeme          - Ödeme yöntemi bazlı satışlar
GET    /api/raporlar/top-urunler    - Top 10 ürünler
```

## 🎨 Teknoloji Stack

### Frontend
- **HTML5** - Sayfa yapısı
- **CSS3** - Responsive tasarım ve animasyonlar
- **JavaScript (Vanilla)** - İnteraktif özellikler
- **Chart.js** - Grafik ve raporlar
- **Font Awesome** - İkonlar
- **Google Fonts** - Tipografi

### Backend
- **Node.js** - Runtime ortamı
- **Express.js** - Web framework
- **PostgreSQL** - Veritabanı
- **pg** - PostgreSQL Node.js sürücüsü
- **CORS** - Cross-Origin Resource Sharing
- **dotenv** - Ortam değişkenleri

## 📱 Responsive Tasarım

- ✅ Masaüstü (1920px ve üzeri)
- ✅ Tablet (768px - 1024px)
- ✅ Mobil (320px - 767px)

Tüm sayfalar mobil cihazlar için optimize edilmiştir.

## 🔐 Özellikler

- ✅ Gerçek zamanlı veri güncellemeleri
- ✅ Form validasyonu
- ✅ Hata yönetimi
- ✅ Responsive UI
- ✅ İkonlar ve görseller
- ✅ Renk şeması (Light/Dark uyumlu)
- ✅ Türkçe lokalizasyon

## 📝 Örnek Veri Bilgileri

### Müşteri Örneği
```json
{
  "musteriid": 1,
  "ad": "Ali",
  "soyad": "Yılmaz",
  "email": "ali1@mail.com",
  "telefon": "05310012345",
  "musteritipi": "Bireysel",
  "cinsiyet": "Erkek",
  "sehir": "İstanbul",
  "kayittarihi": "2023-01-16T00:00:00.000Z"
}
```

### Ürün Örneği
```json
{
  "urunid": 6,
  "urunadi": "Laptop Pro",
  "kategoriid": 2,
  "fiyat": 28000.00,
  "stok": 30,
  "aciklama": "Bilgisayar ve çevre birimleri"
}
```

### Sipariş Örneği
```json
{
  "siparisid": 1,
  "musteriid": 1,
  "siparistarihi": "2024-01-05",
  "toplamtutar": 48000.00,
  "durum": "Onaylandı",
  "odemeyontemi": "Kredi Kartı"
}
```

## 🛠️ Geliştirme ve Bakım

### Proje Komut Satırı

```bash
# Veritabanını sıfırla
psql -U postgres -d sales_dashboard -f sql-scripts/schema.sql

# Backend sunucusu
cd server && npm start

# Frontend sunucusu
npx http-server client -p 8080
```

### Yeni Özellik Ekleme Rehberi

1. **Database**: schema.sql'de tablo/sütun ekle
2. **Backend**: server.js'de endpoint ekle
3. **Frontend**: İlgili HTML sayfasına UI ekle
4. **App.js**: Fetch çağrısı ve render fonksiyonu ekle
5. **CSS**: style.css'de stil ekle

## 📞 Destek ve İletişim

Sorular veya sorunlar için:
- GitHub Issues açın
- Email gönder: support@salesdashboard.com

## 📄 Lisans

MIT License - Kişisel ve ticari kullanım için özgür

## 👨‍💻 Geliştirici

**Taha Bas**
- Proje Sahibi ve Geliştirici

---

**Son Güncelleme**: 17 Aralık 2025
**Versiyon**: 1.0.0