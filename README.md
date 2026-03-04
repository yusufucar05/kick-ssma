# SSMA - Stream Settings Manager for Kick

Kick yayıncılarının yayın ayarlarını (başlık, kategori, etiket) şablon olarak kaydedip tek tıkla uygulayabilmesini sağlayan bir Windows masaüstü uygulamasıdır.

## Ekran Görüntüleri

![Ana Ekran](<img width="1377" height="943" alt="Ekran görüntüsü 2026-03-04 155856" src="https://github.com/user-attachments/assets/de64e39b-e685-4b8a-b3b4-bf263911dbc1" />

)

![Şablon Oluşturma](<img width="1377" height="943" alt="Ekran görüntüsü 2026-03-04 155903" src="https://github.com/user-attachments/assets/32af95b2-91ab-4d09-b321-3a3e306b4aaa" />

)

![Şablon Düzenleme](<img width="1377" height="943" alt="Ekran görüntüsü 2026-03-04 155911" src="https://github.com/user-attachments/assets/88fefe3a-719e-4cf4-ae01-fd9fdb453832" />

)

![Yedekleme](<img width="1377" height="943" alt="Ekran görüntüsü 2026-03-04 155916" src="https://github.com/user-attachments/assets/4997870f-f953-4bae-a479-7dd859ec0ca7" />

)

![Çöp Kutusu](<img width="1377" height="943" alt="Ekran görüntüsü 2026-03-04 155958" src="https://github.com/user-attachments/assets/5b1cb52d-f6fb-4ba6-88c1-21cfc4b04fce" />

)

## İndir

👉 [SSMA v1.0.0 - Windows](https://github.com/yusufucar05/kick-ssma/releases/tag/v1.0.0)

## Özellikler

- 🎮 Yayın şablonları oluştur ve kaydet
- ⚡ Tek tıkla Kick Dashboard'una uygula (başlık + kategori + etiketler)
- 🗑️ Çöp kutusu sistemi (4 gün geri yükleme)
- 💾 Yedekleme ve geri yükleme (.ssma formatı)
- 🌙 Karanlık / Aydınlık mod
- 🔐 OAuth 2.0 ile güvenli Kick girişi

## Kurulum

1. [Releases](https://github.com/yusufucar05/kick-ssma/releases) sayfasından `SSMA-Windows-v1.0.0.zip` dosyasını indir
2. Zip'i bir klasöre çıkart
3. `ssma.exe` dosyasını çalıştır
4. Sol menüden **Hesabını Bağla**'ya tıkla, Kick hesabınla giriş yap

> ⚠️ Windows "Bu uygulama tanınmıyor" uyarısı verebilir.
> **Daha fazla bilgi** → **Yine de çalıştır**

## Bilinen Sorunlar

> ⚠️ **+18 (Mature)** özelliği Kick API tarafından henüz desteklenmiyor.

## Geliştirici Kurulumu

### Gereksinimler
- Flutter SDK 3.x
- [Kick Developer Panel](https://kick.com/developer) üzerinden API key

### Adımlar
```bash
git clone https://github.com/yusufucar05/kick-ssma.git
cd kick-ssma
flutter pub get
```

Proje kök dizininde `.env` dosyası oluştur:
```
KICK_CLIENT_ID=senin_client_id
KICK_CLIENT_SECRET=senin_client_secret
```
```bash
flutter run -d windows
```

## Teknolojiler

- Flutter / Dart
- Kick Public API v1
- SQLite
- OAuth 2.0 + PKCE

## İletişim

Öneri ve istekleriniz için: ssma.oficall@gmail.com

## Lisans

MIT License
