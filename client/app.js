// API Base URL
const API = 'http://localhost:3000/api';

// Sayfa yüklendiğinde
document.addEventListener('DOMContentLoaded', () => {
    loadPage();
});

// Hangi sayfadayız kontrol et ve veri yükle
function loadPage() {
    const path = window.location.pathname;
    
    if (path.includes('index.html') || path.endsWith('/')) {
        loadDashboard();
    } else if (path.includes('musteriler.html')) {
        loadMusteriler();
    } else if (path.includes('urunler.html')) {
        loadUrunler();
    } else if (path.includes('satislar.html')) {
        loadSatislar();
    } else if (path.includes('raporlar.html')) {
        loadRaporlar();
    }
}

// =====================================================
// DASHBOARD
// =====================================================
async function loadDashboard() {
    try {
        // İstatistikler
        const stats = await fetch(`${API}/dashboard/stats`).then(r => r.json());
        
        document.querySelector('.stats').innerHTML = `
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-lira-sign"></i></div>
                <div class="stat-info"><h3>₺${Number(stats.toplamsatis).toLocaleString('tr-TR')}</h3><p>Toplam Satış</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-users"></i></div>
                <div class="stat-info"><h3>${stats.musterisayisi}</h3><p>Müşteri Sayısı</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-box"></i></div>
                <div class="stat-info"><h3>${stats.urunsayisi}</h3><p>Ürün Sayısı</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-receipt"></i></div>
                <div class="stat-info"><h3>${stats.siparissayisi}</h3><p>Sipariş Sayısı</p></div>
            </div>
        `;

        // Aylık satış grafiği
        const aylikSatis = await fetch(`${API}/dashboard/aylik-satis`).then(r => r.json());
        const labels = aylikSatis.map(a => a.ay);
        const data = aylikSatis.map(a => Number(a.toplam));

        new Chart(document.getElementById('salesChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    borderColor: '#4ecca3',
                    backgroundColor: 'rgba(78, 204, 163, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });

        // Kategori grafiği
        const kategoriSatis = await fetch(`${API}/dashboard/kategori-satis`).then(r => r.json());
        new Chart(document.getElementById('categoryChart'), {
            type: 'doughnut',
            data: {
                labels: kategoriSatis.map(k => k.kategoriad),
                datasets: [{
                    data: kategoriSatis.map(k => Number(k.toplam)),
                    backgroundColor: ['#4ecca3', '#3b82f6', '#f59e0b', '#8b5cf6', '#ec4899', '#ef4444'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, cutout: '65%', plugins: { legend: { position: 'bottom' } } }
        });

        // Son siparişler
        const siparisler = await fetch(`${API}/siparisler`).then(r => r.json());
        const son5 = siparisler.slice(0, 5);
        
        document.querySelector('tbody').innerHTML = son5.map(s => `
            <tr>
                <td>#${s.siparisid}</td>
                <td>${s.musteriadi}</td>
                <td>${new Date(s.siparistarihi).toLocaleDateString('tr-TR')}</td>
                <td>₺${Number(s.toplamtutar).toLocaleString('tr-TR')}</td>
                <td><span class="status ${getStatusClass(s.durum)}">${s.durum}</span></td>
            </tr>
        `).join('');

    } catch (err) {
        console.error('Dashboard yüklenemedi:', err);
    }
}

// =====================================================
// MÜŞTERİLER
// =====================================================
async function loadMusteriler() {
    try {
        const musteriler = await fetch(`${API}/musteriler`).then(r => r.json());
        
        document.querySelector('tbody').innerHTML = musteriler.map(m => `
            <tr>
                <td>${m.musteriid}</td>
                <td>${m.ad} ${m.soyad}</td>
                <td>${m.email}</td>
                <td>${m.telefon}</td>
                <td>${m.cinsiyet || '-'}</td>
                <td>${m.sehir}</td>
                <td><span class="badge blue">Bireysel</span></td>
                <td>${new Date(m.kayittarihi).toLocaleDateString('tr-TR')}</td>
                <td>
                    <button class="btn btn-icon btn-sm" onclick="editMusteri(${m.musteriid})"><i class="fas fa-edit"></i></button>
                    <button class="btn btn-icon btn-sm danger" onclick="deleteMusteri(${m.musteriid})"><i class="fas fa-trash"></i></button>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Müşteriler yüklenemedi:', err);
    }
}

async function deleteMusteri(id) {
    if (confirm('Bu müşteriyi silmek istediğinize emin misiniz?')) {
        await fetch(`${API}/musteriler/${id}`, { method: 'DELETE' });
        loadMusteriler();
    }
}

// =====================================================
// ÜRÜNLER
// =====================================================
async function loadUrunler() {
    try {
        const urunler = await fetch(`${API}/urunler`).then(r => r.json());
        
        document.querySelector('.cards-grid').innerHTML = urunler.map(u => `
            <div class="card">
                <div class="card-icon"><i class="fas fa-box"></i></div>
                <div class="card-title">${u.urunadi}</div>
                <div class="card-subtitle">${u.kategoriad || 'Kategori yok'}</div>
                <div style="margin-top: 15px;">
                    <div style="font-size: 1.4rem; font-weight: 700; color: var(--accent);">₺${Number(u.fiyat).toLocaleString('tr-TR')}</div>
                    <div style="color: var(--text-muted); font-size: 0.85rem; margin-top: 5px;">
                        Stok: <strong style="color: ${u.stok < 20 ? '#f59e0b' : 'var(--text)'};">${u.stok}</strong>
                        ${u.stok < 20 ? '<span style="color: #f59e0b;"> (Kritik)</span>' : ''}
                    </div>
                </div>
                <div class="card-footer">
                    <button class="btn btn-icon btn-sm"><i class="fas fa-edit"></i></button>
                    <button class="btn btn-icon btn-sm danger" onclick="deleteUrun(${u.urunid})"><i class="fas fa-trash"></i></button>
                </div>
            </div>
        `).join('');
    } catch (err) {
        console.error('Ürünler yüklenemedi:', err);
    }
}

async function deleteUrun(id) {
    if (confirm('Bu ürünü silmek istediğinize emin misiniz?')) {
        await fetch(`${API}/urunler/${id}`, { method: 'DELETE' });
        loadUrunler();
    }
}

// =====================================================
// SİPARİŞLER
// =====================================================
async function loadSatislar() {
    try {
        const siparisler = await fetch(`${API}/siparisler`).then(r => r.json());
        
        document.querySelector('tbody').innerHTML = siparisler.map(s => `
            <tr>
                <td>${s.siparisid}</td>
                <td>${s.musteriadi}</td>
                <td>-</td>
                <td>${new Date(s.siparistarihi).toLocaleDateString('tr-TR')}</td>
                <td>₺${Number(s.toplamtutar).toLocaleString('tr-TR')}</td>
                <td>₺0</td>
                <td>₺${Number(s.toplamtutar).toLocaleString('tr-TR')}</td>
                <td>${s.odemeyontemi}</td>
                <td><span class="status ${getStatusClass(s.durum)}">${s.durum}</span></td>
                <td>
                    <button class="btn btn-icon btn-sm"><i class="fas fa-eye"></i></button>
                    <button class="btn btn-icon btn-sm"><i class="fas fa-edit"></i></button>
                </td>
            </tr>
        `).join('');
    } catch (err) {
        console.error('Siparişler yüklenemedi:', err);
    }
}

// =====================================================
// RAPORLAR
// =====================================================
async function loadRaporlar() {
    try {
        // İstatistikler
        const stats = await fetch(`${API}/dashboard/stats`).then(r => r.json());
        
        // Cinsiyet grafiği
        const cinsiyet = await fetch(`${API}/raporlar/cinsiyet`).then(r => r.json());
        new Chart(document.getElementById('genderChart'), {
            type: 'doughnut',
            data: {
                labels: cinsiyet.map(c => c.cinsiyet || 'Belirtilmemiş'),
                datasets: [{
                    data: cinsiyet.map(c => Number(c.toplam)),
                    backgroundColor: ['#3b82f6', '#ec4899', '#f59e0b'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, cutout: '60%', plugins: { legend: { position: 'bottom' } } }
        });

        // Şehir grafiği
        const sehir = await fetch(`${API}/raporlar/sehir`).then(r => r.json());
        new Chart(document.getElementById('cityChart'), {
            type: 'bar',
            data: {
                labels: sehir.map(s => s.sehir),
                datasets: [{
                    data: sehir.map(s => Number(s.toplam)),
                    backgroundColor: ['#4ecca3', '#3b82f6', '#f59e0b', '#ec4899', '#8b5cf6'],
                    borderRadius: 6
                }]
            },
            options: { indexAxis: 'y', responsive: true, plugins: { legend: { display: false } } }
        });

        // Ödeme grafiği
        const odeme = await fetch(`${API}/raporlar/odeme`).then(r => r.json());
        new Chart(document.getElementById('paymentChart'), {
            type: 'pie',
            data: {
                labels: odeme.map(o => o.odemeyontemi),
                datasets: [{
                    data: odeme.map(o => Number(o.toplam)),
                    backgroundColor: ['#4ecca3', '#3b82f6', '#f59e0b'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });

        // Aylık satış
        const aylik = await fetch(`${API}/dashboard/aylik-satis`).then(r => r.json());
        new Chart(document.getElementById('salesChart'), {
            type: 'bar',
            data: {
                labels: aylik.map(a => a.ay),
                datasets: [{
                    label: 'Satış',
                    data: aylik.map(a => Number(a.toplam)),
                    backgroundColor: '#4ecca3',
                    borderRadius: 6
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });

    } catch (err) {
        console.error('Raporlar yüklenemedi:', err);
    }
}

// =====================================================
// YARDIMCI FONKSİYONLAR
// =====================================================
function getStatusClass(durum) {
    switch (durum) {
        case 'Teslim Edildi': return 'success';
        case 'Kargoda': return 'shipping';
        case 'Beklemede': return 'pending';
        case 'Onaylandı': return 'shipping';
        case 'İptal': return 'cancelled';
        default: return '';
    }
}

// Mobile menu
document.getElementById('menuToggle')?.addEventListener('click', () => {
    document.getElementById('sidebar').classList.toggle('active');
    document.getElementById('overlay').classList.toggle('active');
});

document.getElementById('overlay')?.addEventListener('click', () => {
    document.getElementById('sidebar').classList.remove('active');
    document.getElementById('overlay').classList.remove('active');
});