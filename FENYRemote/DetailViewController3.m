//
//  demoViewController3.m
//  10.19demo
//
//  Created by 王旭 on 15/10/19.
//  Copyright (c) 2015年 王旭. All rights reserved.
//

#import "DetailViewController3.h"
#import "ODXSocket.h"
#import "DropDownMenue.h"
#import "SocketModel.h"
#import "DetailModel.h"

@interface DetailViewController3 ()<DropDownMenueDelegate,UITextFieldDelegate,modelDelegate>
@property (nonatomic) UIButton *JDUserBtn;
@property (nonatomic) ODXSocket *socket;
@property (nonatomic) SocketModel *model;
@property (nonatomic) NSString *JDuserName;

@end

@implementation DetailViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self CreatBtns];
    _socket = [ODXSocket sharedSocket];
    _model = [SocketModel sharedModel];
    _model.delegate = self;
    [self CreatTexts];
}

- (void)CreatTexts {
    UITextField *text1 = [[UITextField alloc] initWithFrame:CGRectMake(217, 125, 531, 55)];
    text1.tag = 1;
    text1.delegate = self;
    text1.returnKeyType = UIReturnKeyDone;
    text1.font = [UIFont fontWithName:@"Times New Roman" size:30];
    text1.borderStyle = UITextBorderStyleRoundedRect;
    text1.text = _detail.chehao;
    [self.view addSubview:text1];
    
    DropDownMenue *text2 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 189, 531, 55) Tag:2];
    text2.tag = 2;
    text2.delegate = self;
    text2.mytextField.text = _detail.chexing;
    text2.tableArray = _detail.cx;
    [self.view addSubview:text2];
    
    DropDownMenue *text3 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 253, 531, 55) Tag:3];
    text3.tag = 3;
    text3.delegate = self;
    text3.mytextField.text = _detail.jijiaqixinghao;
    text3.tableArray = _detail.jjqxh;
    [self.view addSubview:text3];
    
    DropDownMenue *text4 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 317, 531, 55) Tag:4];
    text4.tag = 4;
    text4.delegate = self;
    text4.mytextField.text = _detail.jijiaqiqihao;
    text4.tableArray = _detail.jjqqh;
    [self.view addSubview:text4];
    
    DropDownMenue *text5 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 381, 531, 55) Tag:5];
    text5.tag = 5;
    text5.delegate = self;
    text5.mytextField.text = _detail.jijiaqiKzhi;
    text5.tableArray = _detail.jjqkz;
    [self.view addSubview:text5];
    
    DropDownMenue *text6 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 445, 531, 55) Tag:6];
    text6.tag = 6;
    text6.delegate = self;
    text6.mytextField.text = _detail.luntaixinghao;
    text6.tableArray = _detail.ltxh;
    [self.view addSubview:text6];
    
    DropDownMenue *text7 = [[DropDownMenue alloc] initWithFrame:CGRectMake(217, 509, 531, 55) Tag:7];
    text7.tag = 7;
    text7.delegate = self;
    text7.mytextField.text = _detail.xiuzhengzhi;
    text7.tableArray = _detail.xzz;
    [self.view addSubview:text7];
    
    UITextField *text8 = [[UITextField alloc] initWithFrame:CGRectMake(217, 573, 531, 55) ];
    text8.tag = 8;
    text8.delegate = self;
    text8.returnKeyType = UIReturnKeyDone;
    text8.font=[UIFont fontWithName:@"Times New Roman" size:30];
    text8.borderStyle = UITextBorderStyleRoundedRect;
    text8.text = _detail.youxiaoqizhi;
    [self.view addSubview:text8];
    
    UITextField *text9 = [[UITextField alloc] initWithFrame:CGRectMake(217, 637, 531, 55)];
    text9.tag = 9;
    text9.delegate = self;
    text9.returnKeyType = UIReturnKeyDone;
    text9.font=[UIFont fontWithName:@"Times New Roman" size:30];
    text9.borderStyle = UITextBorderStyleRoundedRect;
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    
    NSCalendarUnitDay;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    
    //然后就可以从d中获取具体的年月日了；
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day  =  [d day];
    NSMutableString *nowDate = [NSMutableString stringWithFormat:@"%ld-",(long)year];
    [nowDate appendFormat:@"%ld-",(long)month];
    [nowDate appendFormat:@"%ld",(long)day];
    text9.text = nowDate;
    [self.view addSubview:text9];
}

- (void)CreatBtns {
    _JDUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 85, 46, 46)];
    [_JDUserBtn addTarget:self action:@selector(JDIconBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_JDUserBtn setBackgroundImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [self.view addSubview:_JDUserBtn];
}

- (void)JDIconBtnAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前检定员为:%@",_JDuserName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
#warning Incomplete implementation
        //这里发送推出命令
        //要不要加个定时器，显示登入不成功
        uint8_t CMD = 0x3D;
        TKeyValue myaction = kvUserExit;
        uint8_t content[7];
        content[0] = myaction;
        for (int i = 1; i < 7; i++) {
            content[i] = [_JDuserName characterAtIndex:i-1];
        }
        [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)detailReturn:(id)sender {
    #warning Incomplete implementation
    //发送修改后的数据
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (long tag = 2; tag < 8; tag ++) {
        DropDownMenue *text = (DropDownMenue *)[self.view viewWithTag:tag];
        text.tv.hidden = YES;
        text.showList = NO;
        CGRect frame = text.frame;
        text.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 55);
        text.tv.frame = CGRectMake(0, 55, frame.size.width, 0);
    }
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 110 - (self.view.frame.size.height - 264.0);//键盘高度264
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark -DropDownMenueDelegate
- (void)HideMenuesWithTag:(long)tag {
    DropDownMenue *text = (DropDownMenue *)[self.view viewWithTag:tag];
    text.tv.hidden = YES;
    text.showList = NO;
    CGRect frame = text.frame;
    text.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 55);
    text.tv.frame = CGRectMake(0, 55, frame.size.width, 0);
}

#pragma mark -modelDelegate
- (void)UnconnectionTips {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
