//
//  WFActivation.mm
//  WolFox GPS Ultimate
//

#import "WFActivation.h"
#import "WFConfig.h"
#import <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>

@implementation WFActivation

+ (NSMutableDictionary *)loadPrefs {
    return [NSMutableDictionary dictionaryWithContentsOfFile:WF_PREFS_PATH] ?: [NSMutableDictionary dictionary];
}

+ (void)savePrefs:(NSDictionary *)prefs {
    [prefs writeToFile:WF_PREFS_PATH atomically:YES];
}

+ (BOOL)isActivated {
    NSDictionary *prefs = [self loadPrefs];
    return [prefs[@"is_activated"] boolValue];
}

+ (CLLocationCoordinate2D)savedCoordinate {
    NSDictionary *prefs = [self loadPrefs];
    double lat = [prefs[@"lat"] doubleValue];
    double lng = [prefs[@"lng"] doubleValue];
    return CLLocationCoordinate2DMake(lat, lng);
}

+ (void)saveCoordinate:(CLLocationCoordinate2D)coordinate {
    NSMutableDictionary *prefs = [self loadPrefs];
    prefs[@"lat"] = @(coordinate.latitude);
    prefs[@"lng"] = @(coordinate.longitude);
    [self savePrefs:prefs];
}

+ (BOOL)isSimulationEnabled {
    NSDictionary *prefs = [self loadPrefs];
    return [prefs[@"sim_enabled"] boolValue];
}

+ (void)setSimulationEnabled:(BOOL)enabled {
    NSMutableDictionary *prefs = [self loadPrefs];
    prefs[@"sim_enabled"] = @(enabled);
    [self savePrefs:prefs];
}

+ (void)activateWithCode:(NSString *)code completion:(void (^)(BOOL, NSString *))completion {
    NSString *deviceId = [[UIDevice currentDevice] identifierForVendor].UUIDString ?: @"unknown";
    NSString *deviceModel = [[UIDevice currentDevice] model] ?: @"iOS Device";

    NSDictionary *payload = @{
        @"code": code,
        @"device_id": deviceId,
        @"device_model": deviceModel,
        @"api_key": WF_API_KEY
    };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WF_API_URL]];
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    req.HTTPBody = jsonData;
    req.timeoutInterval = 15;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) { completion(NO, @"تعذّر الاتصال بالسيرفر"); return; }
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json[@"success"] boolValue]) {
                NSMutableDictionary *prefs = [self loadPrefs];
                prefs[@"is_activated"] = @(YES);
                prefs[@"code"] = code;
                [self savePrefs:prefs];
                completion(YES, json[@"message"] ?: @"تم التفعيل بنجاح");
            } else {
                completion(NO, json[@"message"] ?: @"الكود غير صحيح");
            }
        });
    }];
    [task resume];
}

@end
