//
//  Widget.h
//  MBaby
//
//  Created by huang xiaoguang on 12-9-12.
//
//

#import <Foundation/Foundation.h>
#import "Api.h"

@interface Widget : UIView

@property (nonatomic,copy)NSString *title;
@end

@interface SexChoice : Widget
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}
@property (nonatomic,assign)int defaultSelected;
@property (nonatomic,readonly)int selected;
-(id)initWithFrame:(CGRect)frame leftTitle:(NSString *)leftTitle
        rightTitle:(NSString *)rightTitle;
-(int)getSelected;
@end


@protocol SelectChoiceProtocl <NSObject>
-(void)selected:(int)index;
@end

@interface SelectChoice : Widget<UIActionSheetDelegate>{
    UIButton *btn;
}
@property (nonatomic,retain)NSArray *datas;
@property (nonatomic,assign)int now_selected;
@property (nonatomic,assign)id<SelectChoiceProtocl> delegate;


@end

@class InputWidget;
@protocol InputWidgetProtocol <NSObject>
@optional
-(void)done:(InputWidget *)widget;
-(void)beginEdit:(InputWidget *)widget;
@optional
-(void)keyboardShow:(CGSize)kbSize moveH:(float)moveH;
-(void)keyboardHide:(CGSize)kbSize moveH:(float)moveH;
@end
@class UIClickView;
@interface InputWidget : Widget<UITextFieldDelegate>{
    int showTime;
    CGSize kbSize;
    UIClickView *clickV;
}

-(id)initWithLoginFrame:(CGRect)frame config:(NSString *)config icon:(NSString *)icon_s;
-(id)initWithSettingFrame:(CGRect)frame title:(NSString *)title config:(NSString *)config;
@property (nonatomic,readonly)UITextField *input;
@property (nonatomic,readonly)NSString *text;
@property (nonatomic,assign)id<InputWidgetProtocol> delegate;
@property (nonatomic,assign)BOOL haveCLickV;

@property (nonatomic)BOOL autoReSize;
@end

@protocol ScrollMenuProtocol <NSObject>
-(void)menuClick:(int)index;
@end
@interface ScrollMenu : Widget{
    UIScrollView *sv;
    UIImageView *arrow_icon;
}

@property (nonatomic,assign)int arrowIndex;
@property (nonatomic,retain)NSArray *titles;
@property (nonatomic,assign)id<ScrollMenuProtocol> delegate;
@property (nonatomic,assign)int lastMenuPos;
@end

@protocol DataListProtocol <NSObject>
-(void)dataClick:(int)index;
@end
@interface DataListWidget : Widget
{
    int maxW;
    int maxRow;
    CGPoint pressPos;
    NSTimeInterval pressTime;
    int clickRow;
    int column_widths[256];
}

@property (nonatomic,retain)NSArray *datas;
@property (nonatomic,assign)id<DataListProtocol> delegate;
@end

@interface SearchBar :InputWidget

@property (nonatomic,assign)JTarget target;
@end

@interface CommentBar :InputWidget

@property (nonatomic,assign)JTarget target;
@end