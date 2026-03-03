class AppStrings {

  static const String appName = "SSMA - Stream Settings";


  static const String menuSettings = "Yayın Ayarlarım";
  static const String menuBackup = "Yedekleme Sistemi";
  static const String menuLinks = "Bağlantı Adreslerim";
  static const String menuConnect = "Hesabını Bağla";
  static const String menuLightMode = "Aydınlık Mod";
  static const String menuDarkMode = "Karanlık Mod";
  static const String menuSubtitle = "Yayıncı Paneli";


  static const String statFollower = "Takipçi";
  static const String statSubscriber = "Abone";


  static const String pageTitle = "Yayın Şablonlarım";
  static const String addPresetTitle = "Yeni Şablon Ekle";
  static const String addPresetSub = "Ayarlarını kaydet ve hızlı başla";


  static const String btnApply = "Uygula";
  static const String applySuccess = "Kick Dashboard'una uygulandı! ✅";
  static const String applyFail = "Hata oluştu! ❌";
  static const String categoryNotFound = "Kategori Kick üzerinde bulunamadı! ❌";


  static const String dialogTitle = "Yeni Şablon Oluştur";
  static const String fieldTitle = "Yayın Başlığı";
  static const String fieldCategory = "Kategori (örn: Just Chatting)";
  static const String fieldTag = "Etiket Yaz";
  static const String btnSave = "Şablonu Kaydet";
  static const String categoryOk = "Kategori Onaylandı! ✅";
  static const String matureLabel = "+18 (Mature Content)";
  static const String presetValidationError =
      "Başlık ve kategori alanları boş bırakılamaz!";


  static const String backupTitle = "Yedekleme & Geri Yükleme";
  static const String backupSubtitle =
      "Şablonlarını .ssma dosyası olarak kaydedebilir veya yedeklerini sisteme aktarabilirsin.";
  static const String exportBtn = "Dışarı Aktar (.ssma)";
  static const String importBtn = "İçeri Aktar (.ssma)";
  static const String exportSuccess = "Yedek başarıyla oluşturuldu!";
  static const String importSuccess = "Şablonlar başarıyla içeri aktarıldı!";
  static const String backupDialog = "Yedeği Nereye Kaydedeyim?";
  static const String backupFileName = "ayarlarim.ssma";


  static const String loginSuccess =
      '''<html><body style="background:#0F0F0F;color:#00E701;text-align:center;padding-top:50px;font-family:sans-serif;"><h1>Giris Basarili! ✅</h1></body></html>''';


  static const String logExportErr = "Export hatası";
  static const String logImportErr = "Import hatası";
  static const String logLoginErr = "Giriş hatası";
  static const String logSearchErr = "Kategori arama hatası";
  static const String logNoToken = "Token bulunamadı";
  static const String logApiPayload = "Kick'e giden paket";
  static const String logApiResponse = "Kick yanıt";
  static const String logApiCrash = "API isteği başarısız";
  static const String logParseErr = "Preset parse hatası";
  static const String logDbErr = "Veritabanı yükleme hatası";
  static const String dialogEditTitle = "Şablonu Düzenle";
  static const String btnUpdate = "Değişiklikleri Kaydet";


  static const String unknownPreset = "Bilinmeyen Şablon";
  static const String brokenPreset = "Hatalı Veri";


  static const String createdLabel = "Oluşturulma:";


  static const String menuTrash = "Çöp Kutusu";
  static const String trashTitle = "Çöp Kutusu";
  static const String trashSubtitle =
      "Silinen şablonlar 4 gün sonra otomatik olarak kalıcı silinir.";
  static const String trashEmpty = "Çöp kutusu boş";
  static const String trashRestore = "Geri Yükle";
  static const String trashDeleteForever = "Kalıcı Sil";
  static const String trashDaysLeft = "Kalan:";
  static const String trashDays = "gün";
  static const String trashDeleteConfirmTitle = "Kalıcı Silme";
  static const String logFollowerErr =
      "Takipçi verisi alınamadı";
  static const String trashDeleteConfirmBody =
      "Bu şablon kalıcı olarak silinecek, geri alınamaz.";

  static const String trashDeleteConfirmBtn = "Sil";
  static const String cancel = "Vazgeç";
  static const List<String> scopes = [
    'user:read',
    'channel:read',
    'channel:write',
  ];
  static const String logTokenExpired   = "Token süresi doldu, yeniden bağlanılması gerekiyor";
  static const String notConnectedError = "Kick hesabın bağlı değil!";
  static const String menuLogout        = "Hesabı Bağlantısını Kes";
  static const String menuConnecting    = "Bağlanıyor...";
  static const String logLoginTimeout = "Giriş zaman aşımına uğradı";

}
