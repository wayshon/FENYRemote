//
//  ODXGuideViewController.m
//  ipadDemo
//
//  Created by 王旭 on 15/11/27.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "ODXGuideViewController.h"
#import "TabBarController.h"

@interface ODXGuideViewController ()

@end

@implementation ODXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuide];
}

- (void)initGuide{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rect];
    [scrollView setContentSize:CGSizeMake(w * 4, 0)];
    [scrollView setPagingEnabled:YES];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"第一页"]];
    [scrollView addSubview:imageView];
    
    UIImageView* imageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(w, 0, w, h)];
    [imageView_1 setImage:[UIImage imageNamed:@"第二页"]];
    [scrollView addSubview:imageView_1];
    
    UIImageView* imageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(w * 2, 0, w, h)];
    [imageView_2 setImage:[UIImage imageNamed:@"第三页"]];
    [scrollView addSubview:imageView_2];
    
    UIImageView* imageView_3 = [[UIImageView alloc] initWithFrame:CGRectMake(w * 3, 0, w, h)];
    [imageView_3 setImage:[UIImage imageNamed:@"第四页"]];
    [scrollView addSubview:imageView_3];
    imageView_3.userInteractionEnabled = YES;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"开始使用" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 40.0];
    [button.titleLabel setTextColor:[UIColor greenColor]];
    [button setFrame:CGRectMake(0.2 * w, 0.8 * h, 0.6 * w, 0.25 * w)];
    [button addTarget:self action:@selector(firstPress) forControlEvents:UIControlEventTouchUpInside];
    [imageView_3 addSubview:button];
    
    [self.view addSubview:scrollView];
    
}

- (void)firstPress{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarController *tabBarVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabBarController"];
        [self presentViewController:tabBarVC animated:YES completion:nil];
    } else {
        UIStoryboard *iPhoneStoryBoard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        TabBarController *tabBarVC = [iPhoneStoryBoard instantiateViewControllerWithIdentifier:@"phoneTabVC"];
        [self presentViewController:tabBarVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
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
