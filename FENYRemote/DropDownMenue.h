//
//  DropDownMenue.h
//  ipadDemo
//
//  Created by 王旭 on 15/11/18.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownMenueDelegate <NSObject>

- (void)HideMenuesWithTag:(long)tag;

@optional

@end

@interface DropDownMenue : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UITableView *tv;//下拉列表
    NSArray *tableArray;//下拉列表数据
    UITextField *mytextField;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *mytextField;
@property (nonatomic) BOOL showList;

@property id <DropDownMenueDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Tag:(long)tag;

@end
