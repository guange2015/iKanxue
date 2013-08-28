//
//  Util.h
//  CloudLife
//
//  Created by huang xiaoguang on 12-11-3.
//
//

#import <Foundation/Foundation.h>

@class CommonC;
@interface Util : NSObject

+(void)saveController:(UIViewController *)c withType:(NSString *)type;
+(void)saveController:(UIViewController *)c withType:(NSString *)type loadType:(NSString *)ltype;
+(void)removeAllController;
+(void)removeLastController;

+(CommonC *)loadView;

+(UINavigationController *)getNavc;
+(BOOL)showController:(int)tag;
+(CommonC *)showController:(int)tag loadType:(NSString *)loadType;

+(NSString *)hummanDate :(NSString *)datestr;
+(NSString *)formateDate :(NSString *)datestr fmt:(NSString *)fmt;


+(NSURL *)processPicUrl:(NSString *)url;
+ (NSString *)GetUUID;



+ (NSString *)saveImage:(NSData *)imageData WithName:(NSString *)imageName;
+(NSData *)loadImage:(NSString *)imageName;
+(NSString *)getImgFullPath:(NSString *)imageName;

+(NSString *)getBookSavePath;
@end


@interface NSString (md5)
- (NSString *) md5;
@end

@interface NSData (md5)
- (NSString*)md5;
@end

