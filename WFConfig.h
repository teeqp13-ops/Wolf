//
//  WFConfig.h
//  WolFox GPS Ultimate
//

#ifndef WFConfig_h
#define WFConfig_h

// ===== الإعدادات الأساسية =====
// ملاحظة: استبدل yoursite.com بنطاق موقعك الفعلي بعد رفع لوحة التحكم
#define WF_API_URL      @"https://yoursite.com/admin/api/activate.php"
#define WF_CHECK_URL    @"https://yoursite.com/admin/api/check.php"

// مفتاح الـ API المستخرج من النسخة السابقة لضمان التوافق
#define WF_API_KEY      @"gps_c11532a714400a3f53a0dffd1ea723e2511ede6bdcb3be9b"

// سر التشفير (HMAC) لزيادة الأمان
#define WF_HMAC_SECRET  @"wolfox_gps_ultimate_2026_key"

// مسار حفظ الإعدادات
#define WF_PREFS_PATH   @"/var/mobile/Library/Preferences/com.wolfox.gpsultimate.plist"

#endif
