//
//  MyMenuBar.h
//  CloudLife
//
//  Created by huang xiaoguang on 12-11-3.
//
//

#import <Foundation/Foundation.h>

#define TOOL_BAR_HEIGHT 50

@protocol MyMenuBarProtocol <NSObject>
-(void)onMenuClick:(int)n;
@end

//需要三张图，从右往左椱盖
@interface MyMenuBar : UIView<UIScrollViewDelegate>
{
    int btnCount;
    NSArray *data_list;
    int menu_count;
}

-(id)initWithFrame:(CGRect)frame data_list:(NSArray *)datalist;

@property (nonatomic,assign)id<MyMenuBarProtocol> delegate;
@end
