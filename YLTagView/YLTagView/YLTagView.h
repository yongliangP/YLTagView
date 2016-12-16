//
//  YLTagView.h
//  YLTagView
//
//  Created by yongliangP on 16/5/5.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLTagView;

@protocol YLTagViewDelegate <NSObject>

@optional
/**改变标签的值*/
-(void)changeText:(YLTagView*)tagView;
/** 删除标签*/
-(void)deletedTagView:(YLTagView*)tagView;
/**点击了哪一个标签*/
-(void)clickTagToDoSomething:(YLTagView*)tagView;

@end

typedef NS_ENUM(NSInteger,YLTagDirection)
{
    YLTagDirectionLeft,
    YLTagDirectionRight
};

@interface YLTagView : UIView 
/// 标签是否可以移动，默认为Yes
@property (nonatomic, assign) BOOL canMove;
///text
@property (nonatomic, copy) NSString *text;
///文本的颜色，默认为白色
@property (nonatomic, strong) UIColor *textColor;
///tag的方向，默认为向左
@property (nonatomic, assign) YLTagDirection direction;
///文本的字体
@property (nonatomic, strong) UIFont *font;
///tag的背景色
@property (nonatomic, strong) UIColor *backgroundColor;
///实心圆点的颜色
@property (nonatomic, strong) UIColor *circlrColor;
///实心圆点周围的颜色
@property (nonatomic, strong) UIColor *bigCircleColor;
///阴影的颜色
@property (nonatomic, strong) UIColor *circlrShadowColor;
///代理方法，可根据自己修改
@property (nonatomic, weak) id <YLTagViewDelegate> delegate;
///记录标签的原点(传数据时需要)
@property (nonatomic,assign,readonly) CGPoint circlePoint;
/**添加标签 point:点*/
- (instancetype)initWithPoint:(CGPoint)point;
/**添加标签 point:点 direction：方向 text：文本*/
- (instancetype)initWithPoint:(CGPoint)point direction:(YLTagDirection)direction text:(NSString*)text;
/**编辑图片时用来添加标签*/
-(void)onlyAddtags;
/**用来显示标签*/
-(void)onlyShowTags;
@end

