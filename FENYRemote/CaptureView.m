//
//  CaptureView.m
//  ipadDemo
//
//  Created by 王旭 on 15/12/25.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "CaptureView.h"

@implementation CaptureView

- (instancetype)initWithImg:(NSString *)img Pad:(BOOL)isPad {
    self = [super init];
    if (self) {
        [self creatViewNoCameraWithImg:img Pad:isPad];
    }
    return self;
}

- (void)creatViewNoCameraWithImg:(NSString *)img Pad:(BOOL)isPad {
    if (isPad) {
        self.frame = CGRectMake(0, 0, 500, 345);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 480, 320)];
        [imageView setImage:[UIImage imageNamed:img]];
        [self addSubview:imageView];
        _carNumber = [[UITextField alloc] initWithFrame:CGRectMake(60, 190, 380, 60)];
        _carNumber.font = [UIFont fontWithName:@"Times New Roman" size:45];
    }else {
        self.frame = CGRectMake(0, 0, 300, 200);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 280, 180)];
        [imageView setImage:[UIImage imageNamed:img]];
        [self addSubview:imageView];
        _carNumber = [[UITextField alloc] initWithFrame:CGRectMake(30, 110, 240, 50)];
        _carNumber.font = [UIFont fontWithName:@"Times New Roman" size:20];
    }
    
    [_carNumber setBorderStyle:UITextBorderStyleRoundedRect];
    _carNumber.placeholder = @"请输入车牌号";
    _carNumber.secureTextEntry = NO;
    _carNumber.textAlignment = NSTextAlignmentLeft;
    _carNumber.clearButtonMode = UITextFieldViewModeAlways;
    _carNumber.returnKeyType = UIReturnKeyDone;
    _carNumber.delegate = self;
    [self addSubview:_carNumber];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 6) {
        [_deledate captureCarNumber:textField.text];
    }else {
        NSLog(@"车号必需为6位");
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
