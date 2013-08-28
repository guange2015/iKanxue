//
//  LoginC.m
//  CloudLife
//
//  Created by huaihuai on 12-10-23.
//
//

#import "LoginC.h"
#import "Other.h"
#import "Widget.h"
#import "StringHelper.h"
#import "AFJSONRequestOperation.h"

@interface LoginC()<UITextFieldDelegate>

@end

@implementation LoginC


-(void)keyboardShow:(CGSize)kbSize moveH:(float)moveH{
    CGRect rc = self.view.frame;
    rc.origin.y = -200;
    self.view.frame = rc;
}

-(void)keyboardHide:(CGSize)kbSize moveH:(float)moveH{
    CGRect rc = self.view.frame;
    rc.origin.y = 0;
    self.view.frame = rc;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)loadView {
    [super loadView];
    
    UIImageView *bgV = [UIImageView imageViewWithImageName:@"global_backgroup"];
    [self.view addSubview:bgV];

    
    UIImageView *logo = [UIImageView imageViewWithImageName: @"logo"];
    [self.view addSubview:logo];

    CGRect rc = logo.frame;
    rc.origin.y = 30;
    rc.origin.x = (self.view.frame.size.width - rc.size.width)/2;
    logo.frame = rc;
    
        
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    [self.view addSubview:text];
    [text release];
    text.center = CGPointMake(160, self.view.frame.size.height-45+8);
    text .font = [UIFont systemFontOfSize:12];
    text.textColor = [UIColor colorWithInt:0xcccccc];
    text.backgroundColor = [UIColor clearColor];
    text.text = @"© 2000-2013 看雪学院（PEdiy.com）";
    text.textAlignment = UITextAlignmentCenter;
    
    float h = 216/2-20;
    UIImageView *tfv = [UIImageView imageViewWithImageName:@"msjy_tf_bg"];
    tfv.frame = CGRectMake(60, h, 200, 34);
    
    
    UITextField *tf = [[[UITextField alloc]initWithFrame:CGRectMake(60+10, h, 200-20, 33)]autorelease];
    [self.view addSubview:tfv];
    [self.view addSubview:tf];
    tfv.userInteractionEnabled = YES;
    tf.placeholder = @"用户名";
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = self;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [tf setTagName:@"user.name"];
    
    
    tfv = [UIImageView imageViewWithImageName:@"msjy_tf_bg"];
    tfv.frame = CGRectMake(60, h+12+34, 200, 34);
    
    tf = [[[UITextField alloc]initWithFrame:CGRectMake(60+10, h+12+34, 200-20, 33)]autorelease];
    [self.view addSubview:tfv];
    [self.view addSubview:tf];
    tfv.userInteractionEnabled = YES;
    tf.placeholder = @"密码";
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.delegate = self;
    tf.secureTextEntry = YES;
    [tf setTagName:@"user.pwd"];
    
    h = h+12+34+34+12;
    UIButton *checkbox = [UIButton buttonWithMy:@"msjy_checkbox" higlight_img:@"" target:JTargetMake(self, @selector(onCheckBox:))];
    checkbox .frame = CGRectMake(64, h+3, 80, 14);
    [self.view addSubview:checkbox];
    [checkbox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    
    UILabel *l = [[[UILabel alloc]initWithFrame:CGRectMake(85, h, 200, 20)]autorelease];
    [self.view addSubview:l];
    l.backgroundColor = [UIColor clearColor];
    l.text = @"显示密码";
    l.textColor = [UIColor colorWithInt:0x666666];
    l.font = [UIFont systemFontOfSize:14];
    
    h+=20;
    UIButton *btn = [UIButton buttonWithTitle:@"登     录" target:JTargetMake(self, @selector(login:))];
    [btn setBackgroundImage:@"msjy_login_btn" highlight_img:@""];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(60, h+10, 200, 34);
    [btn setTitleColor:[UIColor colorWithInt:0x666666] forState:UIControlStateNormal];
    
    
    h+=44+10;
    btn = [UIButton buttonWithTitle:@"取回密码" target:JTargetMake(self, @selector(findpassword))];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(60, h+5, 60, 20);
    [btn setTitleColor:[UIColor colorWithInt:0x666666] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    btn = [UIButton buttonWithTitle:@"游客登录" target:JTargetMake(self, @selector(GuestLogin:))];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(388/2, h+5, 80, 20);
    [btn setTitleColor:[UIColor colorWithInt:0x666666] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    tapGesture.delegate = self;
	[self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UIView *v = [touch view];
    if ([v isKindOfClass:[UIControl class] ]) {
        return NO;
    }
    return YES;
}

- (void)handleTap {
    CGRect rc = self.view.frame;
    rc.origin.y = 0;
    self.view.frame = rc;
}

-(void)highLightBtn:(UIButton *)btn {
    btn.highlighted = YES;
}

static BOOL ischecked = NO;
-(void)onCheckBox:(UIButton *)btn {
    btn.highlighted = NO;
    UITextField *pwdInput = (UITextField *)[self.view viewWithTagName:@"user.pwd"];
    if (!ischecked) {
        [self performSelector:@selector(highLightBtn:) withObject:btn afterDelay:0.0];
    }
    pwdInput.secureTextEntry = ischecked;
    ischecked = !ischecked;
}



-(void)login:(id)btn {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bbs.pediy.com/getsecuritytoken.php?styleid=12"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *l = JSON;
        // 校验收回数据
        NSLog(@"%@",JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"%@",error);
    }];
    [operation start];
    
    UITextField *nameInput = (UITextField *)[self.view viewWithTagName:@"user.name"];
    if ([[[nameInput text]trim] length]<=0) {
        [super alert:@"请输入用户名"];
        [nameInput becomeFirstResponder];
        return;
    }
    UITextField *pwdInput = (UITextField *)[self.view viewWithTagName:@"user.pwd"];
    if ([[[pwdInput text]trim] length]<=0) {
        [super alert:@"请输入密码"];
        [pwdInput becomeFirstResponder];
        return;
    }
    
    

}



@end
