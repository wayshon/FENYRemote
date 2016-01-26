//
//  CaptureView.h
//  ipadDemo
//
//  Created by 王旭 on 15/12/25.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaptureViewDelegate <NSObject>

@optional
- (void)captureCarNumber:(NSString *)car;

@end

@interface CaptureView : UIView<UITextFieldDelegate>

@property (nonatomic) UITextField *carNumber;
@property id <CaptureViewDelegate> deledate;

- (instancetype)initWithImg:(NSString *)img Pad:(BOOL)isPad;

@end
