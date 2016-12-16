//
//  ShowPhotoViewController.m
//  YLTagView
//
//  Created by yongliangP on 2016/12/15.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "ShowPhotoViewController.h"
@interface ShowPhotoViewController ()<YLTagViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *showTextLabel;

@end

@implementation ShowPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"展示标签";
    
    self.imageView.image = self.image;

    for (YLTagModel * tagModel in self.dataArray)
    {
        YLTagView * tagView = [[YLTagView alloc] initWithPoint:CGPointMake(tagModel.point.x*kWindowWidth, tagModel.point.y*kWindowWidth) direction:tagModel.direction text:tagModel.title];
        [tagView onlyShowTags];
        tagView.delegate = self;
        [self.imageView addSubview:tagView];
    }
}


#pragma mark  - YLTagViewDelegate

-(void)clickTagToDoSomething:(YLTagView *)tagView
{

    self.showTextLabel.text = [NSString stringWithFormat:@"点击了:%@",tagView.text];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
