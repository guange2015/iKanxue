//
//  CommonC.m
//  MBaby
//
//  Created by huang xiaoguang on 12-9-4.
//
//

#import "CommonC.h"
#import "AppDelegate.h"
#import "Other.h"
#import "Util.h"

@implementation MyNavigation

- (void)dealloc
{
    [_title release];
    [super dealloc];
}

-(void)setImageUrl:(NSString *)imageUrl {
    imageV.image = [UIImage imageNamed:imageUrl];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        imageV = [UIImageView imageViewWithImageName:@"nav_bar_bg"];
        imageV.frame = self.bounds;
        [self addSubview:imageV];
        
        l = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, self.frame.size.width-65*2, frame.size.height)];
        l.font = [UIFont boldSystemFontOfSize:20];
        l.textAlignment = UITextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        [self addSubview:l];
        l.backgroundColor = [UIColor clearColor];
        [l release];
    }
    
    return self;
}

-(void)setTitle:(NSString *)title {
    l.text = title;
}

-(void)setRightBtn:(UIButton *)rightBtn {
    UIButton *btn = [rightBtn retain];
    [_rightBtn removeFromSuperview];
    [_rightBtn release];
    btn.frame = CGRectMake(320-9-btn.frame.size.width, (44-btn.frame.size.height)/2, btn.frame.size.width,btn.frame.size.height);
    [self addSubview:btn];
    _rightBtn = btn;
}
-(void)setLeftBtn:(UIButton *)leftBtn {
    UIButton *btn = [leftBtn retain];
    [_leftBtn removeFromSuperview];
    [_leftBtn release];
    btn.frame = CGRectMake(9, (44-btn.frame.size.height)/2, btn.frame.size.width,btn.frame.size.height);
    [self addSubview:btn];
    _leftBtn = btn;
}

@end

@implementation CommonC

-(void)reload{
    
}

- (void)dealloc
{
    [_loadType release];
    [super dealloc];
}

-(void)setBusy:(int)n {
    
}

-(void)beforeCall:(int)tag {
    [self setBusy:1];
}
-(void)endCall:(int)tag{
    [self setBusy:-1];
}

-(id)init {
    self = [super init];
    if (self) {
        self.hiddenNav = YES;
    }
    return self;
}

-(void)alert:(NSString *)s {
    NSLog(@"%@",s);
}

-(bool)hiddenNavigationBar {
    return YES;
}

-(void)back:(id)btn {
    [Util loadView];
}

-(void)home:(id)btn {
    [Util showController:ClassItem_Tag loadType:@"auto"];
    [menu release],menu=nil;
}

-(void)addCommonBtn:(BOOL)left right:(BOOL)right
{
    if (left) {
        UIButton *rightButton = [UIButton buttonWithMy:@"nav_home_icon" higlight_img:@"" target:JTargetMake(self, @selector(home:))];
        rightButton.frame = CGRectMake(0, 0, 88/2.0, 72/2.0);
        rightButton.exclusiveTouch = YES; // 如果你同时放上左右两个button，最好加上这句使得两个按钮不会同时被按下
        self.navigation.leftBtn = rightButton;
    } else {
        self.navigation.leftBtn.enabled=NO;
    }
    
    if (right) {
        UIButton *leftButton = [UIButton buttonWithMy:@"back_icon" higlight_img:@"" target:JTargetMake(self, @selector(back:))];
        leftButton.frame = CGRectMake(0, 0, 88/2.0, 72/2.0);
        leftButton.exclusiveTouch = YES; // 如果你同时放上左右两个button，最好加上这句使得两个按钮不会同时被按下
        self.navigation.rightBtn = leftButton;
    } else {
        self.navigation.rightBtn.enabled=NO;
    }
    
    self.navigation.title = self.title;
}

-(void)addNav{
    if (!self.hiddenNav) {
        _navigation = [[MyNavigation alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.view addSubview:_navigation];
        [_navigation release];
    }
}

-(void)oriLoadview{
    [super loadView];
}

-(void)loadView {
    [super loadView];
    
    if (self.view==nil) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        self.view = v;
        self.view.backgroundColor = [UIColor clearColor];
        [v release];
    }
    
    [self addNav];
    
    [self loadMenu];
}

static MyMenuBar *menu = nil;
-(void)loadMenu {
    if(menu==nil){
        
        NSString *displayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            menu = [[MyMenuBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-TOOL_BAR_HEIGHT,self.view.frame.size.width, TOOL_BAR_HEIGHT)
                                         data_list:
                    @[
                    @{@"groupname" : @"云博",@"iconurl":@"menu_blog_icon"},
                    @{@"groupname" : @"微视",@"iconurl":@"menu_viedo_icon"},
                    @{@"groupname" : @"微刊",@"iconurl":@"menu_book_icon"},
                    @{@"groupname" : @"消息",@"iconurl":@"menu_msg_icon"},
                    @{@"groupname" : @"学习",@"iconurl":@"menu_person_icon"},
                    @{@"groupname" : @"广场",@"iconurl":@"menu_city_icon"}]];
        
        
        menu.tag = 0x10011;
    }
    
    if (self.hasToolBar) {
        menu.delegate = self;
        MyMenuBar *menu1 = (MyMenuBar *)[self.view viewWithTag:0x10011];
        if (menu1==nil) {
            [self.view addSubview:menu];
        }
    }
}

-(void)onMenuClick:(int)n {
    CommonC *c = nil;
    
}

@end
