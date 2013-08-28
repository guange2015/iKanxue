//
//  Widget.m
//  MBaby
//
//  Created by huang xiaoguang on 12-9-12.
//
//

#import "Widget.h"
#import "Other.h"

#define Lable_Width 70

@interface UIClickView : UIView

@property (nonatomic,assign)UITextField* edit;
@property (nonatomic,assign)BOOL hasBtn;
@end

@implementation UIClickView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p = [self convertPoint:point toView:self.edit];
    float w = self.edit.frame.origin.x+self.edit.frame.size.width;
    if(self.hasBtn) w+=70;
    if (p.x>0 && p.y>0
        && p.x <= w
        && p.y <= self.edit.frame.origin.y+self.edit.frame.size.height) {
        return nil;
    }
//    return [super hitTest:point withEvent:event];
    else return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self.edit];
    [self.edit resignFirstResponder];
}
@end

@implementation Widget

- (void)dealloc
{
    [_title release];
    [super dealloc];
}

//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(UIView *)getMainView {
    UIViewController *c = [self viewController];
    return c.view;
}

- (void)highlightButton:(UIButton *)b {
    [b setHighlighted:YES];
}

-(void)setTitle:(NSString *)title {
    NSString *s = [title copy];
    [_title release];
    _title = s;
    
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Lable_Width, self.frame.size.height)];
    l.textAlignment = UITextAlignmentCenter;
    l.text = _title;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor clearColor];
    [self addSubview:l];
    [l release];
    [l setTagName:@"title_label"];
    
    for (UIView *v in [self subviews]) {
        if (v!=l) {
        v.center = CGPointMake(v.center.x+Lable_Width, v.center.y);            
        }
    }
    
    CGRect rc = self.frame;
    rc.size.width += Lable_Width;
    self.frame =  rc;
}

@end


@implementation SexChoice

-(int)getSelected{
    if (leftBtn.highlighted) {
        return 1;
    }
    return 2;
}

-(id)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle
        rightTitle:(NSString *)rightTitle{
    self = [super initWithFrame:frame];
    if (self) {
        leftBtn = [UIButton buttonWithTitle:leftTitle target:JTargetMake(self, @selector(selectBtn:))];
        leftBtn.tag = 0x1001;
        leftBtn.frame = CGRectMake(0, 0, 97, 82/2);
        [self addSubview:leftBtn];
        [leftBtn setBackgroundImage:@"sex_btn_left" highlight_img:@""];

        if (self.defaultSelected==0) {
            leftBtn.highlighted = YES;
        }
        
        
        rightBtn = [UIButton buttonWithTitle:rightTitle target:JTargetMake(self, @selector(selectBtn:))];
        rightBtn.tag = 0x1001;
        rightBtn.frame = CGRectMake(97, 0, 97, 82/2);
        [self addSubview:rightBtn];
        [rightBtn setBackgroundImage:@"sex_btn_right" highlight_img:@""];
        
        if (self.defaultSelected==1) {
            rightBtn.selected = YES;
        }
        
        CGRect rc = self.frame;
        rc.size = CGSizeMake(97*2, 41);
        self.frame =  rc;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        leftBtn = [UIButton buttonWithTitle:@"男" target:JTargetMake(self, @selector(selectBtn:))];
        leftBtn.tag = 0x1001;
        leftBtn.frame = CGRectMake(0, 0, 97, 82/2);
        [self addSubview:leftBtn];
        [leftBtn setBackgroundImage:@"sex_btn_left" highlight_img:@""];
        [leftBtn setImage:[UIImage imageNamed:@"sex_boy"] forState:UIControlStateNormal];
        [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        if (self.defaultSelected==0) {
            leftBtn.highlighted = YES;
        }
        
        
        rightBtn = [UIButton buttonWithTitle:@"女" target:JTargetMake(self, @selector(selectBtn:))];
        rightBtn.tag = 0x1001;
        rightBtn.frame = CGRectMake(97, 0, 97, 82/2);
        [self addSubview:rightBtn];
        [rightBtn setBackgroundImage:@"sex_btn_right" highlight_img:@""];
        [rightBtn setImage:[UIImage imageNamed:@"sex_girl"] forState:UIControlStateNormal];
        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        if (self.defaultSelected==1) {
            rightBtn.selected = YES;
        }
        
        CGRect rc = self.frame;
        rc.size = CGSizeMake(97*2, 41);
        self.frame =  rc;
    }
    return self;
}

-(void)setDefaultSelected:(int)defaultSelected {
    _defaultSelected = defaultSelected;
    
    leftBtn.highlighted = NO;
    rightBtn.highlighted = NO;
    if (self.defaultSelected==0) {
        leftBtn.highlighted = YES;
    }
    if (self.defaultSelected==1) {
        rightBtn.selected = YES;
    }
}

-(void)selectBtn:(UIButton *)btn {
    
    leftBtn.highlighted = NO;
    rightBtn.highlighted = NO;
    [self performSelector:@selector(highlightButton:) withObject:btn afterDelay:0.0];
}

-(int)selected{
    if(leftBtn.highlighted) return 0;
    if(rightBtn.highlighted) return 1;
    return self.defaultSelected;
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
}

@end


@implementation SelectChoice

- (void)dealloc
{
    [_datas release];
    [super dealloc];
}

-(void)setDatas:(NSArray *)datas {
    [datas retain];
    [_datas release];
    _datas =datas;

    if ([datas count]>self.now_selected && self.now_selected>=0) {
        NSString *title = datas[self.now_selected];
        [btn setTitle:title forState:UIControlStateNormal];
    }
}



-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        btn = [UIButton buttonWithTitle:@"" target:JTargetMake(self, @selector(onChose:))];
        [btn setBackgroundImage:@"query_select_bg" highlight_img:@""];
        btn.frame = CGRectMake(0, 0, 212, 78/2);
        [self addSubview:btn];
        
        btn.titleLabel.textAlignment = UITextAlignmentLeft;
        btn.titleLabel.lineBreakMode = UILineBreakModeClip;
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
        
        CGRect rc = self.frame;
        rc.size = CGSizeMake(212, 78/2);
        self.frame =  rc;
    }
    return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        self.now_selected = buttonIndex;
        [btn setTitle:self.datas[self.now_selected] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(selected:)]) {
            [self.delegate selected:self.now_selected];
        }
    }
}

-(void)onChose:(id)btn {
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    
    for (NSString *s in self.datas) {
        [sheet addButtonWithTitle:s];
    }
    
    [sheet addButtonWithTitle:@"取消"];
    [sheet setCancelButtonIndex:sheet.numberOfButtons-1];
    [sheet showInView:[self getMainView]];
    [sheet release];
    
}

@end

static UITextField* currentField;
static CGSize gKbSize;
@implementation InputWidget
+(void)initialize {
    [super initialize];
    currentField = nil;
    gKbSize = CGSizeZero;
}

-(void) keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info =[notification userInfo];
    gKbSize =[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    [self moveUp];
}

-(void) keyboardWillHide:(NSNotification*)notification {
    
   
}

-(NSString *)text {
    return [self.input text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(done:)]) {
        [self.delegate done:self];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    currentField = textField;
    if ([self.delegate respondsToSelector:@selector(beginEdit:)]) {
        [self.delegate beginEdit:self];
    } 
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.haveCLickV) {
        UIView *mainV = [self getMainView];
        clickV = [[UIClickView alloc]initWithFrame:mainV.bounds];
        clickV.edit = self.input;
        [mainV addSubview:clickV];
        [mainV bringSubviewToFront:clickV];
        [clickV release];
    }
    
    //有值说明是别的框移过来的
    if (gKbSize.height>0){
        [self moveUp];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (currentField==textField) {
        [self moveDown];
        gKbSize = CGSizeZero;
    } else {
        
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [clickV removeFromSuperview];
    [super dealloc];
}

-(void) moveUp {
    UIView *mainV = [self getMainView];
    CGPoint p =[self convertPoint:CGPointMake(0, self.frame.size.height) toView:mainV];
    if (p.y + gKbSize.height > mainV.frame.size.height) {
        //这里要调整了
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:0.3];
        if ([self.delegate respondsToSelector:@selector(keyboardShow:moveH:)]) {
            [self.delegate keyboardShow:gKbSize moveH:(p.y + gKbSize.height - mainV.frame.size.height+4)];
        }
        if (self.autoReSize) {
            CGRect rc = mainV.frame;
            NSLog(@"before y = %f - %@",rc.origin.y,mainV);
            rc.origin.y = -(p.y + gKbSize.height - mainV.frame.size.height+4);
            NSLog(@"over   y = %f",rc.origin.y);
            mainV.frame = rc;
        }
        
        
        [UIView commitAnimations];
    }
}

-(void) moveDown {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationCurve:0.3];
    UIView *mainV = [self getMainView];
    if ([self.delegate respondsToSelector:@selector(keyboardHide:moveH:)]) {
        [self.delegate keyboardHide:gKbSize moveH:0];
    }
    if(self.autoReSize){
        CGRect rc = mainV.frame;
        rc.origin.y = 0;
        mainV.frame = rc;
    }
    showTime = 0;
    [UIView commitAnimations];
    
    if (self.haveCLickV) {
        [clickV removeFromSuperview];
    }
}


-(id)super_initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

-(id)initWithLoginFrame:(CGRect)frame config:(NSString *)config icon:(NSString *)icon_s{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *icon = [UIImageView imageViewWithImageName:icon_s];
        [self addSubview:icon];
        icon.frame = CGRectMake(23, 0, icon.frame.size.width, icon.frame.size.height);
        
        UIImageView *inputBg = [UIImageView imageViewWithImageName:@"login_input_bg"];
        inputBg.frame = CGRectMake(114/2, 0, 290/2, self.frame.size.height);
        [self addSubview:inputBg];
        _input = [[UITextField alloc]initWithFrame:CGRectMake(114/2+10, 0, 290/2-10, self.frame.size.height)];
        [_input setDelegate:self];
        _input.backgroundColor = [UIColor clearColor];
        _input.returnKeyType = UIReturnKeyDone;
        [_input jconfig:config];
        [self addSubview:_input];
        [_input release];
        _input.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
    }
    
    return self;
}


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *inputBg = [UIImageView imageViewWithImageName:@"query_input_bg"];
        inputBg.frame = CGRectMake(0, 0, 212, 78/2);
        [self addSubview:inputBg];
        _input = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 212-10, 78/2)];
        [_input setDelegate:self];
        _input.backgroundColor = [UIColor clearColor];
        _input.returnKeyType = UIReturnKeyDone;
        [_input jconfig:@"user.name|输入年龄|number|done"];
        [self addSubview:_input];
        [_input release];
        _input.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        CGRect rc = self.frame;
        rc.size = CGSizeMake(212, 78/2);
        self.frame =  rc;
        
    }
    
    return self;
}


-(id)initWithSettingFrame:(CGRect)frame title:(NSString *)title config:(NSString *)config{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *inputBg = [UIImageView imageViewWithImageName:@"body_widget_input"];
        inputBg.frame = CGRectMake(18+93, 0, 191, 78/2);
        [self addSubview:inputBg];
        _input = [[UITextField alloc]initWithFrame:CGRectMake(18+93+10, 0, 181, 78/2)];
        [_input setDelegate:self];
        _input.backgroundColor = [UIColor clearColor];
        _input.returnKeyType = UIReturnKeyDone;
        [_input jconfig:config];
        [self addSubview:_input];
        [_input release];
        _input.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 93, 40)];
        l.text = title;
        [self addSubview:l];
        [l release];
        l.backgroundColor = [UIColor clearColor];
        l.textColor = [UIColor blackColor];
        CGRect rc = self.frame;
        rc.size = CGSizeMake(280, 78/2);
        self.frame =  rc;
    }
    
    return self;
}


-(id)initWithSearchBarFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *searchBtn = [UIButton buttonWithTitle:@"" target:JTargetMake(self, @selector(search:))];
        [searchBtn setBackgroundImage:@"search_query_btn" highlight_img:@""];
        
        UIImageView *inputBg = [UIImageView imageViewWithImageName:@"search_input_bg"];
        inputBg.frame = CGRectMake(0, 0, frame.size.width-40, 68/2);
        [self addSubview:inputBg];
        _input = [[UITextField alloc]initWithFrame:CGRectMake(inputBg.frame.origin.x+10, inputBg.frame.origin.y, inputBg.frame.size.width-10, inputBg.frame.size.height)];
        [self.input setDelegate:self];
        self.input.backgroundColor = [UIColor clearColor];
        self.input.returnKeyType = UIReturnKeyDone;
        [self.input jconfig:@"search.content|请输入查询关键字||done"];
        [self addSubview:_input];
        [_input release];
        _input.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        searchBtn.frame = CGRectMake(inputBg.frame.origin.x+inputBg.frame.size.width, inputBg.frame.origin.y, 40, 68/2);
        [self addSubview:searchBtn];
    }
    
    return self;
}

-(id)initWithCommentBarFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *searchBtn = [UIButton buttonWithTitle:@"发表" target:JTargetMake(self, @selector(search:))];
        [searchBtn setBackgroundImage:@"comment_btn" highlight_img:@""];
        
        UIImageView *inputBg = [UIImageView imageViewWithImageName:@"search_input_bg"];
        inputBg.frame = CGRectMake(0, 0, frame.size.width-40-25, 68/2);
        [self addSubview:inputBg];
        _input = [[UITextField alloc]initWithFrame:CGRectMake(inputBg.frame.origin.x+10, inputBg.frame.origin.y, inputBg.frame.size.width-10, inputBg.frame.size.height)];
        [self.input setDelegate:self];
        self.input.backgroundColor = [UIColor clearColor];
        self.input.returnKeyType = UIReturnKeyDone;
        [self.input jconfig:@"search.content|输入评论内容||done"];
        [self addSubview:_input];
        [_input release];
        _input.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        searchBtn.frame = CGRectMake(inputBg.frame.origin.x+inputBg.frame.size.width, inputBg.frame.origin.y, 65, 68/2);
        [self addSubview:searchBtn];
        
        
    }
    
    return self;
}


@end


#define ScrollMenu_Btn_Prefix 0x20000

@implementation ScrollMenu

- (void)dealloc
{
    [_titles release];
    [super dealloc];
}

-(void)setLastMenuPos:(int)lastMenuPos {
    _lastMenuPos = lastMenuPos;

    UIButton *btn = (UIButton *)[self viewWithTag:lastMenuPos+ScrollMenu_Btn_Prefix];
    
    for (int i=0; i<[self.titles count]; ++i) {
        UIButton *btn1 = (UIButton *)[self viewWithTag:ScrollMenu_Btn_Prefix + i];
        [btn1 setHighlighted:NO];
    }
    arrow_icon.center = btn.center;
}

-(void)setArrowIndex:(int)arrowIndex {
    [self setArrowIndex:arrowIndex annimation:YES];
}
-(void)setArrowIndex:(int)arrowIndex annimation:(BOOL)annimation{
    UIButton *btn = (UIButton *)[self viewWithTag:arrowIndex+ScrollMenu_Btn_Prefix];

    for (int i=0; i<[self.titles count]; ++i) {
        UIButton *btn1 = (UIButton *)[self viewWithTag:ScrollMenu_Btn_Prefix + i];
        [btn1 setHighlighted:NO];
    }
    
    if (annimation) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationCurve:0.5];
    }
    arrow_icon.center = btn.center;
    if (arrowIndex==0) {
        [sv setContentOffset:CGPointMake(0, sv.contentOffset.y) animated:YES];
    } else  if(arrowIndex == [self.titles count]-1) {
        float w = (self.frame.size.width-30)/4-30;
        [sv setContentOffset:CGPointMake(w, sv.contentOffset.y) animated:YES ];
    }
    [self performSelector:@selector(highlightButton:) withObject:btn afterDelay:0.0];
    if (annimation) {
        [UIView commitAnimations];
    }
}

-(void)menuClick:(UIButton *)btn {
    int index = btn.tag - ScrollMenu_Btn_Prefix;
//    [self setArrowIndex:index ];
    if ([self.delegate respondsToSelector:@selector(menuClick:)]) {
        [self.delegate menuClick:index];
    }
}

-(void)setTitles:(NSArray *)titles {
    [titles retain];
    [_titles release];
    _titles = titles;
    
    //50 * 76
    arrow_icon = [UIImageView imageViewWithImageName:@"arrow_three_icon"];
    arrow_icon.userInteractionEnabled = YES;
    //
    
    int i = 0;
    float w = (self.frame.size.width-30)/4;
    for (NSString *title  in self.titles) {
        UIButton *btn = [UIButton buttonWithTitle:title target:JTargetMake(self, @selector(menuClick:))];
        [btn setBackgroundColor:[UIColor clearColor]];
        [sv addSubview:btn];
        btn.tag = ScrollMenu_Btn_Prefix + i;
        
        btn.frame = CGRectMake(w*i, 0, w, sv.bounds.size.height);
        
        [btn setTitleColor:[UIColor colorWithInt:0x888b81] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithInt:0x1d8d5f] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 6, 0)];
                
        ++i;
    }
    
    [sv addSubview:arrow_icon];
    CGRect rc = arrow_icon.frame;
    rc.origin.x = 0;
    arrow_icon.frame = rc;
    
    sv.contentSize = CGSizeMake(w*[self.titles count], sv.frame.size.height);
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *svBg = [UIImageView imageViewWithImageName:@"sv_bg"];
        svBg.frame = self.bounds;
        [self addSubview:svBg];

        sv = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:sv];
        [sv release];
        sv.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

@end


#define Widget_Content_Font_Size 14
#define Green1 0x0d8653
#define Green2 0xdde4c0
#define Row_Height 30
#define Border_Width 3/2.0
#define Line_Weight 2/2.0
#define Click_Color 0x93dda3

@implementation DataListWidget

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		CGPoint p = [touch locationInView:self];
//		double cur=[touch timestamp];
		double d=(p.x-pressPos.x)*(p.x-pressPos.x) + (p.y-pressPos.y)*(p.y-pressPos.y);
		if(d<120 ){
            [self touch:touches withEvent:event];
            clickRow = 0;
            [self setNeedsDisplay];
		} else{
            clickRow = 0;
            [self setNeedsDisplay];
        }
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    clickRow = 0;
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if([touches count]==1){
		UITouch *touch = [touches anyObject];
		pressPos = [touch locationInView:self];
		pressTime=[touch timestamp];
        clickRow = pressPos.y / Row_Height;
        [self setNeedsDisplay];
	}
}


-(void)touch:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    int row = location.y / Row_Height;
    if( [self.delegate respondsToSelector:@selector(dataClick:)] ){
        [self.delegate dataClick:row];
    }
}

- (void)dealloc
{
    [_datas release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setDatas:(NSArray *)datas {
    [datas retain];
    [_datas release];
    _datas = datas;
    maxW = 0;
    maxRow = 0;
    memset(column_widths, 0, sizeof(column_widths)/sizeof(int));
    
    //将每一列最大宽度算好
    int i = 0;
    for (NSArray* cols in datas) {
        int j = 0;
        for (NSString *content in cols) {
            CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:Widget_Content_Font_Size] constrainedToSize:CGSizeMake(9999, 30)];
            if (column_widths[i] < size.width) {
                column_widths[i] = size.width + 5*2 + 2*2;
            }
            ++j;
        }
        if (maxRow<j) {
            maxRow = j;
        }
        maxW += column_widths[i] ;
        ++i;
    }
    
    CGRect rc = self.frame;
    rc.size = CGSizeMake(maxW, maxRow*Row_Height);
    self.frame = rc;
    
    [self setNeedsDisplay];
}

#define View_BackGround_Color 0xecf0e2
-(void)drawRect:(CGRect)rect {
    if (maxW<=0 || maxRow<=0) {
        return;
    }
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //横线
    for (int i =0; i<maxRow; ++i) {
        if (i%2==0) {
            [[UIColor colorWithInt:Green2]set];
            CGContextFillRect(context, CGRectMake(Border_Width, Row_Height*(i+1)+Line_Weight, maxW-Border_Width*2, Row_Height-Line_Weight));
        }
        
        [[UIColor colorWithInt:Green1]set];
        CGContextFillRect(context, CGRectMake(0, Row_Height*(i+1), maxW, Line_Weight));
        
        if (i==clickRow && i!=0) {
            [[UIColor colorWithInt:Click_Color]set];
            CGContextFillRect(context, CGRectMake(Border_Width, Row_Height*(i)+Line_Weight, maxW-Border_Width*2, Row_Height-Line_Weight));
        } else if(i%2!=0) {
        }
    }
    
    [[UIColor colorWithInt:Green1]set];
    //列线
    float lastW = 0;
    for (int i =0; i<[self.datas count]-1; ++i) {
        lastW += column_widths[i];
        CGContextFillRect(context, CGRectMake(lastW, 0, Line_Weight, maxRow*Row_Height));
    }
    
    //一列一列写字
    int i = 0;
    lastW = 0;
    [[UIColor colorWithInt:0x292929]set];
    for (NSArray* cols in self.datas) {
        float lastH = 0;
        for (NSString *content in cols) {
            CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:Widget_Content_Font_Size]];
            [content drawInRect:CGRectMake(lastW+(column_widths[i]-size.width)/2, lastH+5, column_widths[i], Row_Height) withFont:[UIFont systemFontOfSize:Widget_Content_Font_Size]];
            lastH += Row_Height;
        }
        lastW += column_widths[i]; 
        ++i;
    }
    
    //先把框框给画了
    // top 3像素

    [[UIColor colorWithInt:Green1]set];
    CGContextFillRect(context, CGRectMake(0, 0, maxW, Border_Width));
    // bottom
    CGContextFillRect(context, CGRectMake(0, rect.size.height-Border_Width, maxW, Border_Width));
    // left 4
    CGContextFillRect(context, CGRectMake(0, 0, Border_Width, maxRow*Row_Height));
    //right 4
    CGContextFillRect(context, CGRectMake(maxW-Border_Width, 0, Border_Width, maxRow*Row_Height));
    
}

@end


@implementation SearchBar

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    clickV.hasBtn = YES;
}


-(id)initWithFrame:(CGRect)frame {
    return [super initWithSearchBarFrame:frame];
}

-(void)search:(UIButton *)btn {
    NSString *text = [[self.input text]trim];
//    if ([text length]<=0) {
//        [Api alert:@"查询内容不能为空！"];
//        return;
//    }
    [self.target.ins performSelector:self.target.act withObject:text];
}

@end

@implementation CommentBar

-(id)initWithFrame:(CGRect)frame {
    return [super initWithCommentBarFrame:frame];
}

-(void)search:(UIButton *)btn {
    NSString *text = [[self.input text]trim];
    if ([text length]<=0) {
        [Api alert:@"内容不能为空！"];
        return;
    }
    [self.target.ins performSelector:self.target.act withObject:text];
}

@end