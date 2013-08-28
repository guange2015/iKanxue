//
//  CommonC.h
//  MBaby
//
//  Created by huang xiaoguang on 12-9-4.
//
//

#import <Foundation/Foundation.h>
#import "Api.h"
#import "MyMenuBar.h"

#define Blog_Tag       1
#define BlogDetail_Tag 2
#define ClassItem_Tag  3
#define Viedo_Tag      4
#define Book_Tag       5
#define Pepoles_TAG    6
#define Msgs_TAG    7
#define City_TAG    8


@interface MyNavigation : UIView{
    UILabel *l;
    UIImageView *imageV;
}

@property (nonatomic,assign)NSString *title;
@property (nonatomic,retain)UIButton *leftBtn;
@property (nonatomic,retain)UIButton *rightBtn;
@property (nonatomic,assign)NSString *imageUrl;
@end

@class SDZService;
@class MyNavigation;
@interface CommonC : UIViewController<MyMenuBarProtocol>

-(void)alert:(NSString *)s;

-(void)addCommonBtn:(BOOL)left right:(BOOL)right;
-(void)addNav;
-(void)oriLoadview;
-(void)endCall:(int)tag;

@property (nonatomic,readonly)MyNavigation *navigation;

@property (nonatomic,assign)BOOL hiddenNav;

@property (nonatomic,assign)BOOL atAction;
@property (nonatomic,assign)BOOL hasToolBar;
@property (nonatomic,copy)NSString *loadType;



@property (nonatomic,assign)int tag;

-(void)loadMenu;
-(void)reload;
@end


