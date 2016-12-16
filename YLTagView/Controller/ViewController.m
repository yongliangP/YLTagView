//
//  ViewController.m
//  YLTagView
//
//  Created by yongliangP on 2016/12/7.
//  Copyright © 2016年 yongliangP. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(UIButton *)sender
{
    UIImagePickerController * picVC = [[UIImagePickerController alloc] init];
    picVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picVC.delegate = self;
    picVC.allowsEditing = YES;
    [self presentViewController:picVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * editImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        PhotoViewController * photoVC = [[PhotoViewController alloc] init];
        photoVC.editImage = editImage;
        [self.navigationController pushViewController:photoVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
