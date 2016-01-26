//
//  ConttentView.h
//  ipadDemo
//
//  Created by 王旭 on 15/11/10.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewDelegate <NSObject>

@optional

- (void)GetUserNameWithStr:(NSString *)userName;
- (void)GetPassWordWithStr:(NSString *)passWord;

@end

@interface ConttentView : UIView<UITextFieldDelegate>

@property (nonatomic) UITextField *userName;
@property (nonatomic) UITextField *passWord;
@property id <ContentViewDelegate> delegate;


- (instancetype)initWithImg:(NSString *)img;

@end
