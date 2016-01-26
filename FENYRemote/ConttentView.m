//
//  ConttentView.m
//  ipadDemo
//
//  Created by 王旭 on 15/11/10.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "ConttentView.h"

@interface ConttentView ()
@end

@implementation ConttentView

- (instancetype)initWithImg:(NSString *)img{
    self = [super init];
    if (self) {
        [self CreatViewWithImg:img];
    }
    return self;
}

- (void)CreatViewWithImg:(NSString *)img{
    self.frame = CGRectMake(0, 0, 500, 345);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 480, 320)];
    [imageView setImage:[UIImage imageNamed:img]];
    [self addSubview:imageView];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(60, 155, 380, 60)];
    [_userName setBorderStyle:UITextBorderStyleRoundedRect];
    _userName.tag =1;
    _userName.placeholder = @"账号";
    _userName.secureTextEntry = NO;
    _userName.textAlignment = NSTextAlignmentLeft;
    _userName.clearButtonMode = UITextFieldViewModeAlways;
    _userName.returnKeyType = UIReturnKeyNext;
    _userName.font = [UIFont fontWithName:@"Times New Roman" size:45];
    _userName.delegate = self;
    [self addSubview:_userName];
    
    _passWord = [[UITextField alloc] initWithFrame:CGRectMake(60, 235, 380, 60)];
    _passWord.tag = 2;
    [_passWord setBorderStyle:UITextBorderStyleRoundedRect];
    _passWord.placeholder = @"密码";
    _passWord.secureTextEntry = YES;
    _passWord.textAlignment = NSTextAlignmentLeft;
    _passWord.clearsOnBeginEditing = YES;
    _passWord.returnKeyType = UIReturnKeyDone;
    _passWord.font = [UIFont fontWithName:@"Times New Roman" size:45];
    _passWord.delegate = self;
    [self addSubview:_passWord];
    
    //设置文本框左边空白
    _userName.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,60, _userName.frame.size.height)];
    //设置显示模式为永远显示(默认不显示)
    _userName.leftViewMode = UITextFieldViewModeAlways;
    
    _passWord.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,60, _passWord.frame.size.height)];
    //设置显示模式为永远显示(默认不显示)
    _passWord.leftViewMode = UITextFieldViewModeAlways;
    
    //设置文本框图标
    UIImage *userimag = [UIImage imageNamed:@"icon username"];
    UIImageView *usericon = [[UIImageView alloc]init];
    usericon.image = userimag;
    usericon.frame = CGRectMake(0, 0, 40, 40);
    [usericon setCenter:CGPointMake(30, 30)];
    [_userName addSubview:usericon];
    
    UIImage *keyimag = [UIImage imageNamed:@"icon password"];
    UIImageView *passwordicon = [[UIImageView alloc]init];
    passwordicon.image = keyimag;
    passwordicon.frame = CGRectMake(0, 0, 40, 40);
    [passwordicon setCenter:CGPointMake(30, 30)];
    [_passWord addSubview:passwordicon];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_delegate GetUserNameWithStr:_userName.text];
    [_delegate GetPassWordWithStr:_passWord.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [_passWord becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
