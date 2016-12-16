//
//  PhotoViewController.m
//  YLTagView
//
//  Created by yongliangP on 2016/12/7.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "PhotoViewController.h"
#import "ShowPhotoViewController.h"
@interface PhotoViewController ()<YLTagViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) YLTagView *currentTagView;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, strong) NSMutableArray *tags;
@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.editImage;
    self.imageViewHeight.constant = kWindowWidth*self.editImage.size.height/self.editImage.size.width;
    self.navigationItem.title = @"点图标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
}

#pragma mark - Getter

-(NSMutableArray *)tags
{
    if (!_tags)
    {
        _tags = [NSMutableArray array];
    }
    
    return _tags;
}


-(UIView *)backView
{
    
    if (!_backView)
    {
        UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.width-100)/2, self.view.height-100, 100, 100);
        btn.backgroundColor = [UIColor purpleColor];
        btn.layer.cornerRadius = 50;
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
        backView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backView.tag = 1000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
        [backView addGestureRecognizer:tap];
        
        [self.view addSubview:backView];
        
        _backView = backView;
        
    }
    
    return _backView;
    
}

#pragma mark - privacy

-(void)rightBarButtonItemClick:(UIBarButtonItem*)item
{
    
    ShowPhotoViewController * showVC = [[ShowPhotoViewController alloc] init];
    showVC.image = self.editImage;
    NSMutableArray * mArray = [NSMutableArray array];
    for (YLTagView * tagView in self.tags)
    {
        
        YLTagModel * tagModel = [[YLTagModel alloc] init];
        tagModel.direction = tagView.direction;
        tagModel.title = tagView.text;
        tagModel.point = CGPointMake(tagView.circlePoint.x/self.imageView.width, tagView.circlePoint.y/self.imageView.height);
        [mArray addObject:tagModel];
    }
    showVC.dataArray = mArray;
    [self.navigationController pushViewController:showVC animated:YES];
    
}


- (IBAction)imageViewTap:(UITapGestureRecognizer *)sender
{
    
    CGPoint curentPoint = [sender locationInView:sender.view];
    
    YLTagView * tagView = [[YLTagView alloc] initWithPoint:curentPoint];
    tagView.delegate = self;
    [tagView onlyAddtags];
    [self.imageView addSubview:tagView];
    self.currentTagView = tagView;
    self.backView.hidden = NO;
}



-(void)hideView:(UITapGestureRecognizer*)tap
{
    
    [self.currentTagView removeFromSuperview];
    self.backView.hidden = YES;
    
}


-(void)btnClick:(UIButton*)btn
{

    UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加",nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alerView.delegate = self;
    alerView.tag = 100;
    [alerView show];
}


#pragma mark - YLTagViewDelegate

-(void)changeText:(YLTagView *)tagView
{
    
    self.currentTagView = tagView;
    UIAlertView * alerView = [[UIAlertView alloc]initWithTitle:@"编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加",nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alerView.delegate = self;
    UITextField * newGroup = [alerView textFieldAtIndex:0];
    newGroup.text = tagView.text;
    newGroup.tag = 1001;
    [alerView show];
    
}


-(void)deletedTagView:(YLTagView *)lagView
{
    
    [lagView removeFromSuperview];
    
    if ([self.tags containsObject:lagView])
    {
        [self.tags removeObject:lagView];
    }
    
}



#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0)
        
    {
        if (alertView.tag==100)
        {
            [self.currentTagView removeFromSuperview];
            
            if ([self.tags containsObject:self.currentTagView])
            {
                [self.tags removeObject:self.currentTagView];
            }
            self.backView.hidden = YES;
        }
        
        
    }else if (buttonIndex == 1)
        
    {
        UITextField * textField = nil;
        
        textField = [alertView textFieldAtIndex:0];
        
        if (textField.text.length>20)
        {
            return;
        }
        [self.currentTagView setText:textField.text];
        
        if (alertView.tag==100)
        {
            self.backView.hidden = YES;
            
            [self.tags addObject:self.currentTagView];
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
