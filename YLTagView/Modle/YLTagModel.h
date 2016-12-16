//
//  YLTagModel.h
//  YLTagView
//
//  Created by yongliangP on 2016/12/15.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLTagModel : NSObject

@property (nonatomic, assign) CGPoint point;

@property (nonatomic, assign) YLTagDirection direction;

@property (nonatomic, copy) NSString *title;

@end
