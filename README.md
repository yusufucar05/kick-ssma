# SSMA - Stream Settings Manager for Kick

Kick yayıncılarının yayın ayarlarını (başlık, kategori) şablon olarak kaydedip tek tıkla uygulayabilmesini sağlayan bir Windows masaüstü uygulamasıdır.

## İndir

👉 [SSMA v1.0.0 - Windows](https://github.com/yusufucar05/kick-ssma/releases/tag/v1.0.0)

## Özellikler

- 🎮 Yayın şablonları oluştur ve kaydet
- ⚡ Tek tıkla Kick Dashboard'una uygula
- 🗑️ Çöp kutusu sistemi (4 gün geri yükleme)
- 💾 Yedekleme ve geri yükleme (.ssma formatı)
- 🌙 Karanlık / Aydınlık mod
- 🔐 OAuth 2.0 ile güvenli Kick girişi

## Kurulum

1. [Releases](https://github.com/yusufucar05/kick-ssma/releases) sayfasından `SSMA-Windows-v1.0.0.zip` dosyasını indir
2. Zip'i bir klasöre çıkart
3. `ssma.exe` dosyasını çalıştır
4. Sol menüden **Hesabını Bağla**'ya tıkla, Kick hesabınla giriş yap

## Bilinen Sorunlar

> ⚠️ **Etiket ve +18 özellikleri** şu an Kick API tarafından desteklenmiyor.
> Sorun Kick geliştirici ekibine iletildi → [Issue #344](https://github.com/KickEngineering/KickDevDocs/issues/344)

## Geliştirici Kurulumu

Projeyi kendin derlemek istiyorsan:

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

## Lisans

MIT License
