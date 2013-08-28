//
//  MyMenuBar.m
//  CloudLife
//
//  Created by huang xiaoguang on 12-11-3.
//
//

#import "MyMenuBar.h"
#import "Api.h"
#import "Other.h"

#define TAG_INC 0x2000

@implementation MyMenuBar

- (void)dealloc
{
    [data_list release];
    [super dealloc];
}

- (void)highlightButton:(UIButton *)b {
    [b setHighlighted:YES];
    UIView *icon_img_v = [b viewWithTagName:@"icon_img_v"];
    icon_img_v.alpha = 1.0;

}

-(void)onGotoWhitIndex:(int)n{
    UIButton *btn = (UIButton *)[self viewWithTag:TAG_INC+n];
    if ([btn isKindOfClass:[UIButton class]]) {
        [self    onGoto:btn];
    }
}

-(void)onGoto:(UIButton *)sender
{
    //重排
    for (int i=0; i<6; ++i) {
        int tag = TAG_INC+i;
        UIButton *btn = (UIButton *)[self viewWithTag:tag];
        [self bringSubviewToFront:btn];
        btn.highlighted = NO;
        
        
        
            UIView *icon_img_v = [btn viewWithTagName:@"icon_img_v"];
            icon_img_v.alpha = 0.4;
        
    }
    
    
    UIImageView *click_bg_v = [self viewWithTagName:@"toolbar_click_hight"];
    
    CGRect rc = click_bg_v.frame;
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	rc.origin.x = sender.frame.origin.x;
    
    click_bg_v.frame =rc;
	[UIView commitAnimations];
    
    
    [self bringSubviewToFront:sender];
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.0];
    
    if ([self.delegate respondsToSelector:@selector(onMenuClick:)]) {
        [self.delegate onMenuClick:sender.tag-TAG_INC];
    }

}

-(void)resetTheme{
    UIImageView *b_v = [self viewWithTagName:@"b_v"];
    
    UIImageView *click_bg_v = [self viewWithTagName:@"toolbar_click_hight"];
    
    [click_bg_v setImage:[[UIImage imageNamed:@"toolbar_click_hight"] stretchableImageWithCenter]];
    

    CGRect rc = click_bg_v.frame;
    rc.origin.y = 0;
    //rc.origin.x = (rc.size.width-112/2) /2;
    rc.size.width = 112/2;
    rc.size.height = self.frame.size.height;
    click_bg_v.frame = rc;

    [b_v setImage:[[UIImage imageNamed:@"tab2_toolbar_bg"]stretchableImageWithCenter] ];
    
}

-(id)initWithFrame:(CGRect)frame data_list:(NSArray *)datalist{
    self = [super initWithFrame:frame];
    if (self) {
        
        data_list = [datalist retain];
        menu_count = [datalist count];
        
        UIImageView *b_v = [[UIImageView alloc]initWithFrame:self.bounds];
        [b_v setTagName:@"b_v"];
        [self addSubview:b_v];
        
        //底部平分为4个
        int n = self.frame.size.width / 6.0;
        
        UIImageView *click_bg_v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, n, 47)];
        [click_bg_v setTagName:@"toolbar_click_hight"];
        [self addSubview:click_bg_v ];
        
        [self resetTheme];
        
        float fontSize = 14;
        float btnWidth = n-2;

        fontSize = 12;
        btnWidth = 112/2;
        
        //第四个其实少占了20左右
        int i = 0;
        for (NSDictionary* o in data_list) {
            
            NSString *s = o[@"groupname"];
            
            NSString *icon_path = o[@"iconurl"];
            UIImageView *icon_img_v = [UIImageView imageViewWithImageName:icon_path];
            UIButton *btn = [UIButton buttonWithTitle:s
                                               target:JTargetMake(self, @selector(onGoto:))];
            
            CGRect rc = CGRectZero;
            rc.size = CGSizeMake(btnWidth, self.bounds.size.height);
            rc.origin.x = n *i;
            btn.frame = rc;
            [btn addSubview:icon_img_v];
            [icon_img_v setTagName:@"icon_img_v"];
            
            
            //67 54
            icon_img_v.frame = CGRectMake(20, 12, 70/2, 70/2);
            icon_img_v.center = CGPointMake(rc.size.width/2, rc.size.height/2 );
            
            [btn setTag:TAG_INC+i];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize] ;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 5, 0, 5)];
            

                [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
                icon_img_v.center = CGPointMake(rc.size.width/2, 22 );
                [icon_img_v setAlpha:0.4];
                [btn setTitleColor:[UIColor colorWithInt:0x838281] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithInt:0xffffff] forState:UIControlStateHighlighted];

            btn.titleLabel.textAlignment = UITextAlignmentCenter;
            btn.titleLabel.lineBreakMode = UILineBreakModeClip;
            
            [self addSubview:btn];
                        
            ++i;
            
            
        }
        
        btnCount = i;
    }
    
    [self setOrder:0];
    return self;
}

-(void)setOrder:(int)order {
    UIView *click_bg_v = [self viewWithTagName:@"toolbar_click_hight"];
    CGRect rr = click_bg_v.frame;
    rr.origin.x = (self.frame.size.width/6)*order;
    click_bg_v.frame =rr;
    UIView *btn = [self viewWithTag:TAG_INC+order];
    [self performSelector:@selector(highlightButton:) withObject:btn afterDelay:0.1];
}


@end
