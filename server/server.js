const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// PostgreSQL Bağlantısı
const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});

// Bağlantı testi
pool.connect((err, client, release) => {
    if (err) {
        console.error('❌ Veritabanı bağlantı hatası:', err.message);
    } else {
        console.log('✅ PostgreSQL bağlantısı başarılı!');
        release();
    }
});

// =====================================================
// DASHBOARD İSTATİSTİKLER
// =====================================================
app.get('/api/dashboard/stats', async (req, res) => {
    try {
        const stats = await pool.query(`
            SELECT 
                (SELECT COALESCE(SUM(toplamtutar), 0) FROM siparisler WHERE durum != 'İptal') as toplamsatis,
                (SELECT COUNT(*) FROM musteriler) as musterisayisi,
                (SELECT COUNT(*) FROM urunler) as urunsayisi,
                (SELECT COUNT(*) FROM siparisler) as siparissayisi
        `);
        res.json(stats.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Aylık satış trendi
app.get('/api/dashboard/aylik-satis', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                TO_CHAR(siparistarihi, 'YYYY-MM') as ay,
                SUM(toplamtutar) as toplam
            FROM siparisler
            WHERE durum != 'İptal'
            GROUP BY TO_CHAR(siparistarihi, 'YYYY-MM')
            ORDER BY ay
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Kategoriye göre satış
app.get('/api/dashboard/kategori-satis', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                k.kategoriad,
                SUM(sd.aratoplam) as toplam
            FROM kategoriler k
            JOIN urunler u ON k.kategoriid = u.kategoriid
            JOIN siparisdetaylari sd ON u.urunid = sd.urunid
            GROUP BY k.kategoriad
            ORDER BY toplam DESC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// MÜŞTERİLER CRUD
// =====================================================

// Tüm müşteriler
app.get('/api/musteriler', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM musteriler ORDER BY musteriid');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Tek müşteri
app.get('/api/musteriler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM musteriler WHERE musteriid = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Müşteri bulunamadı' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Yeni müşteri ekle
app.post('/api/musteriler', async (req, res) => {
    try {
        const { ad, soyad, email, telefon, cinsiyet, sehir } = req.body;
        const result = await pool.query(
            `INSERT INTO musteriler (ad, soyad, email, telefon, cinsiyet, sehir) 
             VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
            [ad, soyad, email, telefon, cinsiyet, sehir]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Müşteri güncelle
app.put('/api/musteriler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { ad, soyad, email, telefon, cinsiyet, sehir } = req.body;
        const result = await pool.query(
            `UPDATE musteriler SET ad=$1, soyad=$2, email=$3, telefon=$4, cinsiyet=$5, sehir=$6 
             WHERE musteriid=$7 RETURNING *`,
            [ad, soyad, email, telefon, cinsiyet, sehir, id]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Müşteri sil
app.delete('/api/musteriler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM musteriler WHERE musteriid = $1', [id]);
        res.json({ message: 'Müşteri silindi' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// ÜRÜNLER CRUD
// =====================================================

// Tüm ürünler (kategori adıyla)
app.get('/api/urunler', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT u.*, k.kategoriad 
            FROM urunler u 
            LEFT JOIN kategoriler k ON u.kategoriid = k.kategoriid 
            ORDER BY u.urunid
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Tek ürün
app.get('/api/urunler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(`
            SELECT u.*, k.kategoriad 
            FROM urunler u 
            LEFT JOIN kategoriler k ON u.kategoriid = k.kategoriid 
            WHERE u.urunid = $1
        `, [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Ürün bulunamadı' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Yeni ürün ekle
app.post('/api/urunler', async (req, res) => {
    try {
        const { urunadi, kategoriid, fiyat, stok, aciklama } = req.body;
        const result = await pool.query(
            `INSERT INTO urunler (urunadi, kategoriid, fiyat, stok, aciklama) 
             VALUES ($1, $2, $3, $4, $5) RETURNING *`,
            [urunadi, kategoriid, fiyat, stok, aciklama]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Ürün güncelle
app.put('/api/urunler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { urunadi, kategoriid, fiyat, stok, aciklama } = req.body;
        const result = await pool.query(
            `UPDATE urunler SET urunadi=$1, kategoriid=$2, fiyat=$3, stok=$4, aciklama=$5 
             WHERE urunid=$6 RETURNING *`,
            [urunadi, kategoriid, fiyat, stok, aciklama, id]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Ürün sil
app.delete('/api/urunler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM urunler WHERE urunid = $1', [id]);
        res.json({ message: 'Ürün silindi' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// KATEGORİLER
// =====================================================

app.get('/api/kategoriler', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM kategoriler ORDER BY kategoriid');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// SİPARİŞLER CRUD
// =====================================================

// Tüm siparişler (müşteri adıyla)
app.get('/api/siparisler', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT s.*, m.ad || ' ' || m.soyad as musteriadi
            FROM siparisler s
            JOIN musteriler m ON s.musteriid = m.musteriid
            ORDER BY s.siparistarihi DESC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Tek sipariş (detaylarıyla)
app.get('/api/siparisler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const siparis = await pool.query(`
            SELECT s.*, m.ad || ' ' || m.soyad as musteriadi
            FROM siparisler s
            JOIN musteriler m ON s.musteriid = m.musteriid
            WHERE s.siparisid = $1
        `, [id]);
        
        if (siparis.rows.length === 0) {
            return res.status(404).json({ error: 'Sipariş bulunamadı' });
        }
        
        const detaylar = await pool.query(`
            SELECT sd.*, u.urunadi
            FROM siparisdetaylari sd
            JOIN urunler u ON sd.urunid = u.urunid
            WHERE sd.siparisid = $1
        `, [id]);
        
        res.json({
            ...siparis.rows[0],
            detaylar: detaylar.rows
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Yeni sipariş ekle
app.post('/api/siparisler', async (req, res) => {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        
        const { musteriid, odemeyontemi, urunler } = req.body;
        
        const toplamtutar = urunler.reduce((sum, u) => sum + (u.miktar * u.birimfiyat), 0);
        
        const siparisResult = await client.query(
            `INSERT INTO siparisler (musteriid, toplamtutar, odemeyontemi) 
             VALUES ($1, $2, $3) RETURNING *`,
            [musteriid, toplamtutar, odemeyontemi]
        );
        
        const siparisid = siparisResult.rows[0].siparisid;
        
        for (const urun of urunler) {
            await client.query(
                `INSERT INTO siparisdetaylari (siparisid, urunid, miktar, birimfiyat) 
                 VALUES ($1, $2, $3, $4)`,
                [siparisid, urun.urunid, urun.miktar, urun.birimfiyat]
            );
            
            await client.query(
                `UPDATE urunler SET stok = stok - $1 WHERE urunid = $2`,
                [urun.miktar, urun.urunid]
            );
        }
        
        await client.query('COMMIT');
        res.status(201).json(siparisResult.rows[0]);
    } catch (err) {
        await client.query('ROLLBACK');
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});

// Sipariş durumu güncelle
app.put('/api/siparisler/:id/durum', async (req, res) => {
    try {
        const { id } = req.params;
        const { durum } = req.body;
        const result = await pool.query(
            `UPDATE siparisler SET durum=$1 WHERE siparisid=$2 RETURNING *`,
            [durum, id]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Sipariş sil
app.delete('/api/siparisler/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM siparisler WHERE siparisid = $1', [id]);
        res.json({ message: 'Sipariş silindi' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// RAPORLAR
// =====================================================

// Cinsiyete göre satış
app.get('/api/raporlar/cinsiyet', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT m.cinsiyet, SUM(s.toplamtutar) as toplam
            FROM siparisler s
            JOIN musteriler m ON s.musteriid = m.musteriid
            WHERE s.durum != 'İptal'
            GROUP BY m.cinsiyet
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Müşteri tipine göre satış
app.get('/api/raporlar/musteri-tipi', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT m.musteri_tipi, SUM(s.toplamtutar) as toplam
            FROM musteriler m
            JOIN siparisler s ON m.musteriid = s.musteriid
            WHERE s.durum != 'İptal'
            GROUP BY m.musteri_tipi
            ORDER BY toplam DESC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Şehre göre satış
app.get('/api/raporlar/sehir', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT m.sehir, SUM(s.toplamtutar) as toplam, COUNT(*) as siparissayisi
            FROM siparisler s
            JOIN musteriler m ON s.musteriid = m.musteriid
            WHERE s.durum != 'İptal'
            GROUP BY m.sehir
            ORDER BY toplam DESC
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Ödeme yöntemine göre
app.get('/api/raporlar/odeme', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT odemeyontemi, COUNT(*) as sayi, SUM(toplamtutar) as toplam
            FROM siparisler
            WHERE durum != 'İptal'
            GROUP BY odemeyontemi
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// En çok satan ürünler
app.get('/api/raporlar/top-urunler', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT u.urunadi, k.kategoriad, SUM(sd.miktar) as toplam_adet, SUM(sd.aratoplam) as toplam_gelir
            FROM siparisdetaylari sd
            JOIN urunler u ON sd.urunid = u.urunid
            LEFT JOIN kategoriler k ON u.kategoriid = k.kategoriid
            GROUP BY u.urunadi, k.kategoriad
            ORDER BY toplam_adet DESC
            LIMIT 10
        `);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// =====================================================
// SERVER BAŞLAT
// =====================================================
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server çalışıyor: http://localhost:${PORT}`);
});