//
//  YLInsetLabel.m
//  YLTagView
//
//  Created by yongliangP on 2016/12/12.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "YLInsetLabel.h"

@implementation YLInsetLabel

- (void)drawTextInRect:(CGRect)rect
{
    if (self.direction==YLTagDirectionLeft)
    {
         UIEdgeInsets insets = {0, 5, 0, 0};
        
         [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
    }else
    {
       UIEdgeInsets insets = {0, 0, 0, 5};
        
       [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
    }
    
}

@end
