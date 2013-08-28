//
//  Util.m
//  CloudLife
//
//  Created by huang xiaoguang on 12-11-3.
//
//

#import "Util.h"
#import "AppDelegate.h"
#import "CommonC.h"
#import "Api.h"

#import <QuartzCore/QuartzCore.h>

@implementation Util

+(void)showAni:(NSString*)typeName withView:(UIView*)view commit:(BOOL)commit{
	//typeName=NULL;
	if(typeName==NULL || [typeName length]<=0){
		return;
	}
	int hash=0;
	if(typeName!=NULL){
		hash=[Api hashCode:typeName];
	}
	
	UIViewAnimationTransition im=UIViewAnimationTransitionCurlUp;
	NSString * sm=NULL;
	NSString * ssm=NULL;
	NSTimeInterval time=0.3f;
	
	switch (hash) {
		case 640685:case 682356:{//上卷 卷下
			im=UIViewAnimationTransitionCurlDown;
			time=1.0f;
			break;
		}
		case 640716:case 682355:{//下卷 卷上
			im=UIViewAnimationTransitionCurlUp;
			time=1.0f;
			break;
		}
		case 777941:case 1037144:{//左翻 翻右
			im=UIViewAnimationTransitionFlipFromLeft;
			time=0.7f;
			break;
		}
		case 698984:case 1039691:{//右翻 翻左
			im=UIViewAnimationTransitionFlipFromRight;
			time=0.7f;
			break;
		}
		case 892836:case 892985:{//淡入 淡出
			sm=kCATransitionFade;
			ssm=kCATransitionFromTop;
			break;
		}
		case 4647718:case 899418:{//下滑 滑下
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 647687:case 899417:{//上滑 滑上
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromTop;
			break;
		}
		case 773547:case 903477:{//左滑 滑左
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromRight;
			break;
		}
		case 694590:case 900930:{//右滑 滑右
			sm=kCATransitionMoveIn;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 658379:case 1229908:{//下顶 顶上
			sm=kCATransitionPush;
			ssm=kCATransitionFromTop;
			break;
		}
		case 658348:case 1229909:{//上顶 顶下
			sm=kCATransitionPush;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 784208:case 1231421:{//左顶 顶右
			sm=kCATransitionPush;
			ssm=kCATransitionFromRight;
			break;
		}
		case 705251:case 1233968:{//右顶 顶左
			sm=kCATransitionPush;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 27706573:{//淡出左
			sm=kCATransitionReveal;
			ssm=kCATransitionFromLeft;
			break;
		}
		case 27702513:{//淡出上
			sm=kCATransitionReveal;
			ssm=kCATransitionFromTop;
			break;
		}
		case 27702514:{//淡出下
			sm=kCATransitionReveal;
			ssm=kCATransitionFromBottom;
			break;
		}
		case 27704026:{//淡出右
			sm=kCATransitionReveal;
			ssm=kCATransitionFromRight;
			break;
		}
		default:{
			
			return;
		}
	}
	
	if(sm){
		CATransition *animation = [CATransition animation];
		[animation setDelegate:view];
		[animation setDuration:time];
		[animation setType: sm];
		[animation setSubtype: ssm];
		//[win exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
		[[[self getNavc].view layer] addAnimation:animation forKey:@"transitionViewAnimation"];
	}
	else{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationTransition: im forView:view cache:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:time];
		//[win exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
		if(commit){
			[UIView commitAnimations];
		}
	}
}


+(UINavigationController *)getNavc {
    UINavigationController *navc = (UINavigationController * )APP.window.rootViewController;
    return navc;
}

+(void)removeAllController {
    UINavigationController *navc = [self getNavc];
    NSArray *cs = [navc viewControllers];
    for(int i = [cs count]-1; i>=1; --i){
        [cs[i] removeFromParentViewController];
    }
}

+(void)removeLastController {
    UINavigationController *navc = [self getNavc];
    NSArray *cs = [navc viewControllers];
    for(int i = [cs count]-1; i>=1; --i){
        [cs[i] removeFromParentViewController];
        break;
    }

}

+(void)saveController:(UIViewController *)c withType:(NSString *)type {
    if ([c isKindOfClass:[CommonC class]]) {
        if ([((CommonC *)c).loadType length]<=0) {
            ((CommonC *)c).loadType = type;
        };
    }

    UINavigationController *navc = [self getNavc];
    if([type isEqualToString:@"auto"]){
        [navc pushViewController:c animated:YES];
	} else {
        [self showAni:type withView:navc.view commit:YES];
        [navc pushViewController:c animated:NO];
    }
    
    if (((CommonC *)c).hiddenNav) {
        
    }
}



+(void)saveController:(UIViewController *)c withType:(NSString *)type loadType:(NSString *)ltype {
    if ([c isKindOfClass:[CommonC class]]) {
        ((CommonC *)c).loadType = ltype;
    }
    [self saveController:c withType:type];
}

+(CommonC *)loadView {
    UINavigationController *navc = [self getNavc];
    NSArray *cs = [navc viewControllers];
    if ([cs count]>=2) {
        CommonC *c = [cs objectAtIndex:[ cs count]-1];
        if ([c isKindOfClass:[CommonC class]]) {
            if([c.loadType isEqualToString:@"auto"]  || [c.loadType length]<=0){
                [navc popViewControllerAnimated:YES];
            } else {
                [self showAni:c.loadType withView:navc.view commit:YES];
                [navc popViewControllerAnimated:NO];
            }
        } else if([c isKindOfClass:[UIViewController class]]) {
            [navc popViewControllerAnimated:YES];
        }
        return c;
    }
    return nil;
}

+(BOOL)showController:(int)tag {
    UINavigationController *navc = [self getNavc];
    NSArray *cs = [navc viewControllers];
    for (CommonC *c in cs) {
        if ([c isKindOfClass:[CommonC class]]) {
            if (c.tag == tag) {
                //find and show.
                if([c.loadType isEqualToString:@"auto"]){
                    [navc popToViewController:c animated:YES];
                } else {
                    [self showAni:c.loadType withView:navc.view commit:YES];
                    [navc popToViewController:c animated:NO];
                }
                return YES;
            }
        }
    }
    
    return NO;
}

+(CommonC *)showController:(int)tag loadType:(NSString *)loadType {
    UINavigationController *navc = [self getNavc];
    NSArray *cs = [navc viewControllers];
    for (CommonC *c in cs) {
        if ([c isKindOfClass:[CommonC class]]) {
            if (c.tag == tag) {
                //find and show.
                [ c loadMenu];
                if([loadType isEqualToString:@"auto"]){
                    [navc popToViewController:c animated:YES];
                } else {
                    [self showAni:loadType withView:navc.view commit:YES];
                    [navc popToViewController:c animated:NO];
                }
                return c;
            }
        }
    }
    
    return nil;
}

+(NSString *)hunmanDate:(NSDate *)date {
    NSTimeInterval n = [date timeIntervalSinceNow];
    long n1 = (long)ABS(n);
    
    int days = 0;
    int hour = 0;
    int min = 0;
    if (n1/60/60>0) {
        hour = n1/60/60;
    } else {
        min = n1/60;
    }
    
    if (hour/24>0) {
        days = hour/24;
    }
    NSString* time = @"刚刚";
    if (min>0){
        time = [NSString stringWithFormat:@"%d分钟前", min];
    }
    if (hour>0) {
        time = [NSString stringWithFormat:@"%d小时前", hour]; //需计算
    }
    if (days>0) {
        time = [NSString stringWithFormat:@"%d天前", days]; //需计算
    }
    
    if (days>=6) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        time = [format stringFromDate:date];
        [format release];
    }
    return time;
}


+(NSString *)hummanDate :(NSString *)datestr {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
        
    NSDate *date = [format dateFromString:datestr];
        [format release];
    
    NSString *s = [self hunmanDate:date];
    return s;

}

+(NSString *)formateDate :(NSString *)datestr fmt:(NSString *)fmt{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    
    NSDate *date = [format dateFromString:datestr];
    [format release];
    
    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:fmt];
    NSString *s = [format stringFromDate:date];
    [format release];
    return s;
    
}



+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}


#pragma mark 保存数据到document
+ (NSString *)saveImage:(NSData *)imageData WithName:(NSString *)imageName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    return fullPathToFile;
}

+(NSString *)getImgFullPath:(NSString *)imageName{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    return fullPathToFile;
}

+(NSData *)loadImage:(NSString *)imageName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    return [NSData dataWithContentsOfFile:fullPathToFile];
}

+(NSString*) getBookSavePath {
    NSString *os5 = @"5.0";    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedAscending) //lower than 4
    {
    }
    else if ([currSysVer compare:os5 options:NSNumericSearch] == NSOrderedDescending) //5.0.1 and above
    {
    }
    else // IOS 5
    {
        path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    }
    return [path stringByAppendingPathComponent:@"pub_book"];
}


@end



#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#pragma mark - MD5
@implementation NSString (MyExtensions)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (MyExtensions)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
