//
//  YLTagView.m
//  YLTagView
//
//  Created by yongliangP on 16/5/5.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "YLTagView.h"
#import "YLInsetLabel.h"
#define kWindowWidth        [UIScreen mainScreen].bounds.size.width

#define kFontNum 15.0
#define kScale  kWindowWidth/414.0
#define kSpace 5  //原点到label的距离

@interface YLTagView ()<UIGestureRecognizerDelegate>
{
    CGPoint lastPoint;
}
///记录标签的原点
@property (nonatomic, assign) CGPoint circlePoint;

@property (nonatomic, strong) CALayer *circleLayer;

@property (nonatomic, strong)CAAnimationGroup * animationGroup;

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UIView *bigCircleView;

@property (nonatomic, strong)  YLInsetLabel *textLabel;
///实心圆点的大小
@property (nonatomic, assign) CGSize circleSize;
//解决在menu出现后的问题
@property (nonatomic, weak) UIButton * backButton;

@end

@implementation YLTagView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPoint:(CGPoint)point direction:(YLTagDirection)direction text:(NSString*)text
{
    if (self = [super init])
    {
        self.circlePoint = point;
        self.direction = direction;
        [self initializationWithPoint:point];
        self.text = text;
    }
    return self;
}

-(instancetype)initWithPoint:(CGPoint)point
{
    if (self = [super init])
    {
       return [self initWithPoint:point direction:YLTagDirectionLeft text:nil];
    }
    return self;
}

- (void)initializationWithPoint:(CGPoint)point
{
    //1.设置圆的大小
    self.circleSize = CGSizeMake(6, 6);
    //2.设置自己的大小,初始时和原点一样大
    CGFloat selfW = self.circleSize.width+2;
    CGFloat selfH = selfW;
    self.frame = CGRectMake(point.x-selfW/2, point.y-selfH/2, selfW, selfH);
    //3.加圆
    [self creatCircleView];
    //4.初始化控件属性
    self.canMove= YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.circlrColor = [UIColor whiteColor];
    self.circlrShadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.bigCircleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
}


-(UIButton *)backButton
{
    if (!_backButton)
    {
        UIButton * backView = [[UIButton alloc] initWithFrame:self.superview.bounds];
        backView.backgroundColor = [UIColor clearColor];
        [backView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:backView];
        _backButton = backView;
    }
    
    return _backButton;
}



-(UIFont*)calculateFont
{
    NSInteger fontNum = kScale*kFontNum;
    return [UIFont systemFontOfSize:fontNum];
}



- (YLInsetLabel *)textLabel
{
    if (_textLabel == nil)
    {
        YLInsetLabel *textLabel = [[YLInsetLabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.userInteractionEnabled = YES;
        textLabel.font = [self calculateFont];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _textLabel = textLabel;
    }
    return _textLabel;
}

//处理label的形状
- (void)triangle:(UILabel *)label
{
    CGFloat angleWidth = 10;
    CGFloat labelCornerRadius = 4;
    CGFloat lineCornerRadius = 2;
    CGFloat arrowCornerRadious = 1;
    UIBezierPath  * path =  [UIBezierPath  new];
    switch (self.direction)
    {
        case YLTagDirectionRight:
            
            [path moveToPoint:( CGPoint ) { labelCornerRadius, 0}];
            [path addQuadCurveToPoint:( CGPoint ) {0, labelCornerRadius}  controlPoint:( CGPoint ) { 0,0}];
            [path addLineToPoint :( CGPoint ) { 0, CGRectGetHeight(label.frame)-labelCornerRadius}];
            [path addQuadCurveToPoint:( CGPoint ) {labelCornerRadius, CGRectGetHeight(label.frame)}  controlPoint:( CGPoint ) { 0, CGRectGetHeight(label.frame)}];
            [path addLineToPoint :( CGPoint ) { CGRectGetWidth(label.frame) - angleWidth-lineCornerRadius, CGRectGetHeight(label.frame)}];
            [path addQuadCurveToPoint:( CGPoint ) {CGRectGetWidth(label.frame) - angleWidth+lineCornerRadius, CGRectGetHeight(label.frame)-lineCornerRadius}  controlPoint:( CGPoint ) { CGRectGetWidth(label.frame)-angleWidth, CGRectGetHeight(label.frame)}];
            [path addLineToPoint :( CGPoint ) { CGRectGetWidth(label.frame)-arrowCornerRadious, CGRectGetHeight(label.frame)/2.0+arrowCornerRadious}];
            [path addQuadCurveToPoint:( CGPoint ) {CGRectGetWidth(label.frame)-arrowCornerRadious,CGRectGetHeight(label.frame)/2.0-arrowCornerRadious}  controlPoint:( CGPoint ) { CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)/2.0}];
            [path addLineToPoint :( CGPoint ) { CGRectGetWidth(label.frame) - angleWidth+lineCornerRadius, lineCornerRadius}];
            [path addQuadCurveToPoint:( CGPoint ) {CGRectGetWidth(label.frame) - angleWidth-lineCornerRadius, 0}  controlPoint:( CGPoint ) { CGRectGetWidth(label.frame)-angleWidth,0}];
            [path addLineToPoint :( CGPoint ) { labelCornerRadius, 0}];
            
            break;
        case YLTagDirectionLeft:
        default:
           
            [path moveToPoint :( CGPoint ) { angleWidth+lineCornerRadius ,  0 }];
            [path addQuadCurveToPoint:( CGPoint ) { angleWidth-lineCornerRadius,lineCornerRadius}  controlPoint:( CGPoint ) {angleWidth , 0}];
            [path addLineToPoint :( CGPoint ) { arrowCornerRadious, CGRectGetHeight(label.frame)/2.0-arrowCornerRadious}];
            [path addQuadCurveToPoint:( CGPoint ) {arrowCornerRadious, CGRectGetHeight(label.frame)/2.0+arrowCornerRadious}  controlPoint:( CGPoint ) { 0, CGRectGetHeight(label.frame)/2.0}];
            [path addLineToPoint :( CGPoint ) { angleWidth-lineCornerRadius, CGRectGetHeight(label.frame)-lineCornerRadius}];
            [path addQuadCurveToPoint:( CGPoint ) { angleWidth+lineCornerRadius, CGRectGetHeight(label.frame)}  controlPoint:( CGPoint ) { angleWidth, CGRectGetHeight(label.frame)}];
            [path addLineToPoint :( CGPoint ) { CGRectGetWidth(label.frame)-labelCornerRadius, CGRectGetHeight(label.frame)}];
            [path addQuadCurveToPoint:( CGPoint ) { CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)-labelCornerRadius}  controlPoint:( CGPoint ) { CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)}];
            [path addLineToPoint :( CGPoint ) { CGRectGetWidth(label.frame), labelCornerRadius}];
            [path addQuadCurveToPoint:( CGPoint ) { CGRectGetWidth(label.frame)-labelCornerRadius, 0}  controlPoint:( CGPoint ) { CGRectGetWidth(label.frame),0}];
            [path addLineToPoint :( CGPoint ) { angleWidth, 0}];
            break;
    }
    
    CAShapeLayer* mask = [CAShapeLayer layer];
    mask.path = path.CGPath ;
    label.layer.mask = mask;
}

- (void)creatCircleView
{   //circleLayer
    CGSize circleSize = self.circleSize;
    self.circleLayer =[CALayer new];
    self.circleLayer.position = CGPointMake(circleSize.width/2, circleSize.height/2);
    self.circleLayer.bounds = CGRectMake(0, 0, circleSize.width, circleSize.height);
    self.circleLayer.cornerRadius = circleSize.width/2;
    [self.layer addSublayer:self.circleLayer];
    //circleView
    self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleSize.width, circleSize.height)];
    self.circleView.layer.cornerRadius = self.circleView.frame.size.width / 2;
    self.circleView.layer.masksToBounds = YES;
    self.circleView.center = CGPointMake(10, CGRectGetHeight(self.frame)/2.0);
    self.circleLayer.position = self.circleView.center;
    //bigCircleView
    self.bigCircleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleSize.width+2, circleSize.height+2)];
    self.bigCircleView.layer.cornerRadius = self.bigCircleView.frame.size.width / 2;
    self.bigCircleView.layer.masksToBounds = YES;
    self.bigCircleView.center = CGPointMake(10, CGRectGetHeight(self.frame)/2.0);
    
    [self addSubview:self.bigCircleView];
    [self addSubview:self.circleView];
   
    //添加动画
    [self circleAnimation:self.circleLayer];
    
}


- (void)circleAnimation:(CALayer *)layer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        [animationGroup setDuration:1.0];
        animationGroup.repeatCount = INFINITY;
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        animationGroup.timingFunction = timingFunction;
        
        CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.5];
        fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.removedOnCompletion = NO;
        fadeAnimation.fillMode = kCAFillModeForwards;
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:5.0];
        scaleAnimation.removedOnCompletion =  NO;
        fadeAnimation.fillMode = kCAFillModeForwards;
        
        animationGroup.animations = [NSArray arrayWithObjects:fadeAnimation, scaleAnimation, nil];
        //保持一直动画状态
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        self.animationGroup = animationGroup;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [layer addAnimation:animationGroup forKey:@"fadeAnimation"];
            
        });
        
    });
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    if (text.length>0)
    {
        self.textLabel.text = text;
        [self.textLabel sizeToFit];
        CGRect rect = self.textLabel.frame;
        //给出额外的距离
        rect.size.height += 8;
        rect.size.width += 15;
        self.textLabel.frame = rect;
        //处理label的形状
        [self triangle:self.textLabel];
        //处理完判断边界fram，赋值方向
        CGFloat selfW = rect.size.width + CGRectGetWidth(self.bigCircleView.frame) + kSpace;

        if (CGRectGetWidth(self.superview.frame)>0)
        {
            if (self.direction == YLTagDirectionLeft)
            {
                CGFloat maxX = self.circlePoint.x - CGRectGetWidth(_bigCircleView.frame)/2 + selfW;
                if (maxX>self.superview.frame.size.width)
                {
                    self.direction = YLTagDirectionRight;
                }
                
            }else
            {
                CGFloat minX = self.circlePoint.x + CGRectGetWidth(_bigCircleView.frame) - selfW;
                if (minX<0)
                {
                    self.direction = YLTagDirectionLeft;
                }
                
            }
        }
        
        self.width = selfW;
        self.height = rect.size.height;
        //处理label的位置
        [self handelFrameWithRect:rect];
    }

}

//change frame
- (void)handelFrameWithRect:(CGRect)rect
{
    //设置自己的大小
    CGFloat selfW = CGRectGetWidth(self.bigCircleView.frame)+kSpace+rect.size.width;
    CGFloat selfH = rect.size.height;
    
    switch (self.direction)
    {
        case YLTagDirectionLeft:
            self.bigCircleView.middleX = CGRectGetWidth(self.bigCircleView.frame)/2;
            self.circleView.middleX = self.bigCircleView.middleX;
            self.textLabel.frame = CGRectMake(kSpace+CGRectGetMaxX(self.bigCircleView.frame),0, rect.size.width, rect.size.height);
            self.frame = CGRectMake(self.circlePoint.x- CGRectGetWidth(self.bigCircleView.frame)/2, self.circlePoint.y-rect.size.height/2, selfW, selfH);
            break;
        case YLTagDirectionRight:
            self.textLabel.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            self.bigCircleView.middleX = rect.size.width + kSpace + CGRectGetWidth(_bigCircleView.frame)/2;
            self.circleView.middleX = self.bigCircleView.middleX;
            self.frame = CGRectMake(self.circlePoint.x-CGRectGetWidth(self.bigCircleView.frame)/2-kSpace-rect.size.width, self.circlePoint.y-rect.size.height/2, selfW, selfH);
            break;
    }
    
    //调整原点的Y
    self.circleView.middleY = selfH/2;
    self.bigCircleView.middleY = self.circleView.middleY;
    self.circleLayer.position = self.circleView.center;
    
    //加上label
    [self addSubview:self.textLabel];

}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textLabel.font = font;
    
    [self setText:self.textLabel.text];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.textLabel.backgroundColor = backgroundColor;
}

- (void)setCirclrColor:(UIColor *)circlrColor
{
    _circlrColor = circlrColor;
    self.circleView.backgroundColor = circlrColor;
}

-(void)setBigCircleColor:(UIColor *)bigCircleColor
{
    _bigCircleColor = bigCircleColor;
    self.bigCircleView.backgroundColor = bigCircleColor;


}

- (void)setCirclrShadowColor:(UIColor *)circlrShadowColor
{
    _circlrShadowColor = circlrShadowColor;
    self.circleLayer.backgroundColor = circlrShadowColor.CGColor;
}


#pragma mark ----touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (!self.canMove || touches.count > 1)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    UIView *superView = self.superview;
    lastPoint = [touch locationInView:superView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (!self.canMove || touches.count > 1)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];

    CGFloat centerX = self.center.x + point.x - lastPoint.x;
    CGFloat centerY = self.center.y + point.y - lastPoint.y;
    
    CGFloat selfX = centerX - self.frame.size.width/2;
    CGFloat selfY = centerY- self.frame.size.height/2;

    if (selfX>=self.superview.frame.size.width - self.frame.size.width)
    {
        centerX = self.superview.frame.size.width - self.frame.size.width/2;
    }
    
    if (selfY>=self.superview.frame.size.height - self.frame.size.height)
    {
        centerY = self.superview.frame.size.height - self.frame.size.height/2;
    }
    
    if (selfX<=0)
    {
        centerX = self.frame.size.width/2;
        
    }
    
    if (selfY<=0)
    {
        centerY = self.frame.size.height/2;
    }
    
    self.center = CGPointMake(centerX, centerY);
    
    lastPoint = point;
    
    CGPoint center = [self convertPoint:self.circleView.center toView:self.superview];
    self.circlePoint = center;
}



- (void)setDirection:(YLTagDirection)direction
{
    _direction = direction;
    self.textLabel.direction = self.direction;
    [self.textLabel setNeedsDisplay];
    [self triangle:self.textLabel];
    [self handelFrameWithRect:self.textLabel.frame];
}


#pragma mark - UIGestureRecognizerDelegate
//单击换方向
- (void)changeTagViewDirection:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    
    if (!CGRectContainsPoint(self.textLabel.frame, point))
    {
        CGFloat selfW = self.textLabel.width + (self.circleSize.width+2) + kSpace;
        if (self.direction==YLTagDirectionLeft)
        {
            CGFloat newX = self.circlePoint.x + CGRectGetWidth(self.bigCircleView.frame)/2 - selfW;
            if (newX>0)
            {
                self.direction = YLTagDirectionRight;
            }
        }else
        {
            CGFloat newX = self.circlePoint.x - CGRectGetWidth(self.bigCircleView.frame)/2 + selfW;
            if (newX<kWindowWidth)
            {
                self.direction = YLTagDirectionLeft;
            }
        }
    }
}

//长按手势,菜单操作
-(void)longGestureTagView:(UILongPressGestureRecognizer *)sender
{
    YLTagView * tagView =(YLTagView *)sender.view;
    
    if (sender.state ==UIGestureRecognizerStateBegan)
    {
        [self backButton];
        [tagView becomeFirstResponder];
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(menuItem1Pressed:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem2Pressed:)];
        NSArray *menuItems = [NSArray arrayWithObjects:item1,item2,nil];
        [popMenu setMenuItems:menuItems];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        [popMenu setTargetRect:tagView.frame inView:tagView.superview];
        [popMenu setMenuVisible:YES animated:YES];
    }
}

//展示标签的单击手势
-(void)showTagTap:(UITapGestureRecognizer*)tap
{
    YLTagView *tagViw = (YLTagView *)tap.view;
    
    if ([self.delegate respondsToSelector:@selector(clickTagToDoSomething:)])
    {
        [self.delegate clickTagToDoSomething:tagViw];
    }
}



#pragma mark - action

-(void)btnClick:(UIButton*)btn
{
    [btn removeFromSuperview];
}

-(void)menuItem1Pressed:(NSObject*)obj
{
    
    if ([self.delegate respondsToSelector:@selector(changeText:)])
    {
        [self.delegate changeText:self];
    }
    
}

-(void)menuItem2Pressed:(NSObject*)obj
{
    
    if ([self.delegate respondsToSelector:@selector(deletedTagView:)])
    {
        [self.backButton removeFromSuperview];
        
        [self.delegate deletedTagView:self];
    }
    
}

/**编辑图片用来添加标签 */
-(void)onlyAddtags
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTagViewDirection:)];
    [self addGestureRecognizer:tap];
    UILongPressGestureRecognizer * longPress =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureTagView:)];
    [self addGestureRecognizer:longPress];
}


/**展示标签,点击标签干嘛干嘛可自己定制*/
-(void)onlyShowTags
{
    self.canMove = NO;
    UITapGestureRecognizer * showTagTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTagTap:)];
    [self addGestureRecognizer:showTagTap];

}

#pragma mark - UIMenuControllerNotification


-(void)menuWillShow:(NSNotification*)note
{
    self.canMove = NO;
}

-(void)menuWillHide:(NSNotification*)note
{
    self.canMove = YES;
    [self.backButton removeFromSuperview];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}



@end
