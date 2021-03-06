//
//  JKViewController.m
//  ipadDemo
//
//  Created by 王旭 on 15/11/2.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "JKViewController.h"
#import "LNNumberpad.h"
#import "YcKeyBoardView.h"
#import "OBShapedButton.h"
#import "ODXSocket.h"
#import "SocketModel.h"
#import "CustomIOSAlertView.h"
#import "ConttentView.h"
#import "CaptureView.h"
#import "DetailViewController3.h"
#import "DetailModel.h"
#import "StateAndKey.h"


@interface JKViewController ()<CustomIOSAlertViewDelegate,ContentViewDelegate,LNNumberpadDelegate,UITextFieldDelegate,modelDelegate,CaptureViewDelegate,YcKeyBoardViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *JKBottomView;
@property (weak, nonatomic) IBOutlet UITextField *SpeedText;

@property (nonatomic,strong) UISwipeGestureRecognizer *upGestureRecognizer;
@property (nonatomic,strong) YcKeyBoardView *key;
@property (strong, nonatomic) OBShapedButton *JKJDUser;
@property (nonatomic) ODXSocket *socket;
@property (nonatomic) SocketModel *model;
@property (nonatomic) NSMutableString *userName;
@property (nonatomic) NSMutableString *passWord;
@property (nonatomic) NSString *JKLineIP;
@property (nonatomic) NSString *JKLinePort;
@property (nonatomic) UIButton *CarNumber;//车牌号按钮，可以显示详情
@property (nonatomic) TTestState state;
@property (nonatomic) DetailModel *detail;

@property (weak, nonatomic) IBOutlet UILabel *standard;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *standard1;
@property (weak, nonatomic) IBOutlet UILabel *standard2;
@property (weak, nonatomic) IBOutlet UILabel *standard3;
@property (weak, nonatomic) IBOutlet UILabel *sample1;
@property (weak, nonatomic) IBOutlet UILabel *sample2;
@property (weak, nonatomic) IBOutlet UILabel *sample3;
@property (weak, nonatomic) IBOutlet UILabel *error1;
@property (weak, nonatomic) IBOutlet UILabel *error2;
@property (weak, nonatomic) IBOutlet UILabel *error3;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *lineHost;
@property (weak, nonatomic) IBOutlet UILabel *hyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jdLabel;
@property (nonatomic) BOOL hasCamera;
@property (nonatomic) BOOL hasBG;
@property (nonatomic) NSString *inputCarNo;
@property (nonatomic,copy) NSString *KeyBoardText;
@property (nonatomic) BOOL NumberPadFlag;

@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGesture];
    [self CreatBtns];
    _socket = [ODXSocket sharedSocket];
    _model = [SocketModel sharedModel];
    _model.delegate = self;
    
    self.SpeedText.inputView = [LNNumberpad defaultLNNumberpad];
    [LNNumberpad defaultLNNumberpad].delegate = self;
    _SpeedText.delegate = self;
    
    __block JKViewController *blockSelf = self;
    _model.modelBlock = ^(NSDictionary *dic){
        DetailModel *blockDetail = [[DetailModel alloc] init];
        [blockDetail setValuesForKeysWithDictionary:dic];
        [blockSelf performSegueWithIdentifier:@"JKtoresult" sender:blockDetail];
    };
    _lineHost.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LineIP"];
    _standard.text = @"--";
    _speed.text = @"--";
    
    _model.updateBlock = ^(TTestState state,NSString *tips,BOOL camera,BOOL bg,NSMutableString *hy,NSMutableString *jd,NSMutableString *car,NSMutableArray *sample,NSMutableArray *standArr,NSString *sd,NSString *sp){
        _state = state;
        _hasCamera = camera;
        _hasBG = bg;
        _userName = jd;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf updateView];
            blockSelf.tips.text = tips;
            blockSelf.hyLabel.text = hy;
            blockSelf.jdLabel.text = jd;
            if (_state == tsRunning) {
                blockSelf.standard.text = sd;
                blockSelf.speed.text = sp;
            }else {
                blockSelf.standard.text = @"--";
                blockSelf.speed.text = @"--";
            }
            [blockSelf.CarNumber setTitle: car forState: UIControlStateNormal];
            if (_state > tsEndTest || _state < tsRunning) {
                blockSelf.sample1.text = @"--";
                blockSelf.sample2.text = @"--";
                blockSelf.sample3.text = @"--";
                
                blockSelf.standard1.text = @"--";
                blockSelf.standard2.text = @"--";
                blockSelf.standard3.text = @"--";
            }else {
                NSInteger m1 = [sample count];
                blockSelf.sample1.text = sample[m1 - 3];
                blockSelf.sample2.text = sample[m1 - 2];
                blockSelf.sample3.text = sample[m1 - 1];
                
                NSInteger m2 = [standArr count];
                blockSelf.standard1.text = standArr[m2 - 3];
                blockSelf.standard2.text = standArr[m2 - 2];
                blockSelf.standard3.text = standArr[m2 - 1];
            }
            
            blockSelf.error1.text = [blockSelf calculateWithStandard:blockSelf.standard1.text Sample:blockSelf.sample1.text];
            blockSelf.error2.text = [blockSelf calculateWithStandard:blockSelf.standard2.text Sample:blockSelf.sample2.text];
            blockSelf.error3.text = [blockSelf calculateWithStandard:blockSelf.standard3.text Sample:blockSelf.sample3.text];
        });
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateView];
    [super viewWillAppear:animated];
}

#pragma -markSetGesture
- (void)setGesture{
    self.upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (_state <= tsWaitLogIn) {
        [self alertView];
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        if(self.key == nil){
            self.key = [[YcKeyBoardView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 60)];
        }
        self.key.delegate = self;
        [self.key.textView becomeFirstResponder];
        self.key.textView.textAlignment = NSTextAlignmentCenter;
        self.key.textView.font = [UIFont systemFontOfSize:50];
        self.key.textView.inputView = [LNNumberpad defaultLNNumberpad];
        [LNNumberpad defaultLNNumberpad].delegate = self;
        [self.view addSubview:self.key];
    }
}

//上滑键盘的方法
-(void)keyboardShow:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.key.transform = CGAffineTransformMakeTranslation(0, -410);//origin.y - 253
    }];
}
-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        //重置位置坐标
        self.key.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _KeyBoardText = self.key.textView.text;
        self.key.textView.text = @"";
        [self.key removeFromSuperview];
        if (_NumberPadFlag) {
            [self sendAssignSpeed];
        }
    }];
}

-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    [contentView resignFirstResponder];
    //接口请求
    
}

#pragma mark -CreatBtns
- (void)CreatBtns {
    _CarNumber = [[UIButton alloc] initWithFrame:CGRectMake(350, 80, 277, 51)];
    _CarNumber.titleLabel.textAlignment = NSTextAlignmentLeft;
    _CarNumber.titleLabel.font = [UIFont systemFontOfSize: 30.0];
    _CarNumber.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
    [_CarNumber addTarget:self action:@selector(CarNumberDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_CarNumber];
    
    _JKJDUser = [[OBShapedButton alloc] initWithFrame:CGRectMake(198, 367, 60, 60)];
    [_JKJDUser addTarget:self action:@selector(JKJDUserAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_JKJDUser];
}

- (void)JKJDUserAction {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            [self JKJDRemoveUser];
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            [self JKJDRemoveUser];
            break;
        case tsRunning:
            
            break;
        case tsStop:
            [self JKJDRemoveUser];
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark -alertView

- (void)tsInitAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:_tips.text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tsWaitVerifyInAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请核验员至后台登入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检定员登入" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"登入" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self alertViewJD];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertViewJD {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    ConttentView *contentView = [[ConttentView alloc] initWithImg:@"JDenterBG"];
    [contentView.userName becomeFirstResponder];
    [alert setContainerView:contentView];
    contentView.delegate = self;
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"登入", nil]];
    [alert setDelegate:self];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [contentView.userName resignFirstResponder];
        [contentView.passWord resignFirstResponder];
        if (buttonIndex == 0) {
            [alertView close];
        }else if(buttonIndex == 1){
#warning Incomplete implementation
            //这里发送登入指令
            uint8_t CMD = 0x3D;
            TKeyValue action = kvUserEnter;
            NSMutableString *sendStr = _userName;
            [sendStr appendString:_passWord];
            uint8_t content[13];
            content[0] = action;
            for (int i = 1; i < 13; i++) {
                content[i] = [sendStr characterAtIndex:i-1];
            }
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
            printf("\n登入 : ");
            for (int j = 0; j < sizeof(content); j++) {
                printf("%x,",content[j]);
            }
            printf("\n");
            [alertView close];
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(EnterErrorAlertView) userInfo:nil repeats:NO];
        }
    }];
    
    //[alert setUseMotionEffects:YES];
    
    [alert show];
}

- (void)EnterErrorAlertView {
    if (_state <= tsWaitLogIn) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登入不成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (void)alertViewCaptureWithCamera:(BOOL)camera {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    CaptureView *captureView = [[CaptureView alloc] initWithImg:@"carNumberBG" Pad:YES];
    captureView.deledate = self;
    [alert setContainerView:captureView];
    [alert setDelegate:self];
    if (camera) {
        [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"拍照", @"确定", nil]];
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else if(buttonIndex == 1){
                //拍照
                uint8_t CMD = 0x3D;
                TKeyValue action = kvCapture;
                uint8_t content[1];
                content[0] = action;
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x3D;
                TKeyValue action = kvManualCapture;
                uint8_t content[7];
                content[0] = action;
                for (int i = 1; i < 7; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i-1];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                printf("\n手动车牌 : ");
                for (int j = 0; j < sizeof(content); j++) {
                    printf("%x,",content[j]);
                }
                printf("\n");
                [alertView close];
            }
        }];
    }else {
        [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", @"确定", nil]];
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x3D;
                TKeyValue action = kvManualCapture;
                uint8_t content[7];
                content[0] = action;
                for (int i = 1; i < 7; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i-1];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                printf("\n手动车牌 : ");
                for (int j = 0; j < sizeof(content); j++) {
                    printf("%x,",content[j]);
                }
                printf("\n");
                [alertView close];
            }
        }];
    }
    //[alert setUseMotionEffects:YES];
    
    [alert show];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"JKtoresult"]){
        DetailViewController3 *viewController = segue.destinationViewController;
        //*****************熟记*****************
        viewController.detail = sender;
        //***************************************
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

#pragma mark -ContentViewDelegate
- (void)GetUserNameWithStr:(NSString *)userName {
    if (userName.length > 0) {
        self.userName = [[NSMutableString alloc] initWithString:userName];
        self.JKLineIP = [[NSMutableString alloc] initWithString:userName];
        switch (_userName.length) {
            case 1:
                for (int i = 0; i < 5; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 2:
                for (int i = 0; i < 4; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 3:
                for (int i = 0; i < 3; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 4:
                for (int i = 0; i < 2; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 5:
                [self.userName appendString:@"0"];
                break;
                
            default:
                break;
        }
    }
}

- (void)GetPassWordWithStr:(NSString *)passWord {
    if (passWord.length > 0) {
        self.passWord = [[NSMutableString alloc] initWithString:passWord];
        self.JKLinePort = [[NSMutableString alloc] initWithString:passWord];
        switch (_passWord.length) {
            case 1:
                for (int i = 0; i < 5; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 2:
                for (int i = 0; i < 4; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 3:
                for (int i = 0; i < 3; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 4:
                for (int i = 0; i < 2; i++) {
                    [self.passWord appendString:@"0"];
                }
                break;
            case 5:
                [self.passWord appendString:@"0"];
                break;
                
            default:
                break;
        }
    }
}

- (void)JKJDRemoveUser {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前检定员为:%@",_userName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
#warning Incomplete implementation
        //这里发送推出命令
        //要不要加个定时器，显示推出不成功
        uint8_t CMD = 0x3D;
        TKeyValue myaction = kvUserExit;
        uint8_t content[7];
        content[0] = myaction;
        switch (_userName.length) {
            case 1:
                for (int i = 0; i < 5; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 2:
                for (int i = 0; i < 4; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 3:
                for (int i = 0; i < 3; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 4:
                for (int i = 0; i < 2; i++) {
                    [self.userName appendString:@"0"];
                }
                break;
            case 5:
                [self.userName appendString:@"0"];
                break;
                
            default:
                break;
        }
        for (int i = 1; i < 7; i++) {
            content[i] = [_userName characterAtIndex:i-1];
        }
        [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
        printf("\n退出 : ");
        for (int j = 0; j < sizeof(content); j++) {
            printf("%x,",content[j]);
        }
        printf("\n");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -updateView
- (void)updateView {
    if (_state <= tsWaitLogIn || _state == tsInputOffNo) {
        [_JKJDUser setBackgroundImage:[UIImage imageNamed:@"blueButton"] forState:UIControlStateNormal];
    }else {
        [_JKJDUser setBackgroundImage:[UIImage imageNamed:@"redButton"] forState:UIControlStateNormal];
    }
    if (_state == tsRunning) {
        _JKBottomView.hidden = YES;
    }else {
        _JKBottomView.hidden = NO;
    }
}

- (void)CarNumberDetail {
#warning Incomplete implementation
    //再次查询车辆详情
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvQueryCar;
            uint8_t content[7];
            content[0] = action;
            for (int i = 1; i < 7; i++) {
                content[i] = [_CarNumber.titleLabel.text characterAtIndex:i-1];
            }
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
            printf("\n查询详情 : ");
            for (int j = 0; j < sizeof(content); j++) {
                printf("%x,",content[j]);
            }
            printf("\n");
        }
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvQueryCar;
            uint8_t content[7];
            content[0] = action;
            for (int i = 1; i < 7; i++) {
                content[i] = [_CarNumber.titleLabel.text characterAtIndex:i-1];
            }
            for (int j = 0; j < sizeof(content); j++) {
                printf("%x,",content[j]);
            }
            printf("\n");
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)addSpeed:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvAddSpeed;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)downSpeed:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReduceSpeed;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKZeroBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvZero;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKSamplingBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSample;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)stop:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvStop;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

- (IBAction)ReStart:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvRun;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

- (IBAction)JKCapture:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            [self alertViewCaptureWithCamera:_hasCamera];
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

- (IBAction)JKEnter:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
        {
            if (!_hasBG) {
                uint8_t CMD = 0x3D;
                TKeyValue action = kvEnter;
                uint8_t content[1];
                content[0] = action;
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
            }
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSaveSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsEndTest:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvEnter;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}

- (IBAction)JKUpBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKDownBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKLeftBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvLeft;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKRightBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
            
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
            
            break;
        case tsRunning:
            
            break;
        case tsStop:
            
            break;
        case tsPreStop:
        
            break;
        case tsEditSample:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvRight;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}
- (IBAction)JKReturnBtn:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
            [self tsWaitVerifyInAlertView];
            break;
        case tsWaitLogIn:
            [self alertView];
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreMotorDevice:
            
            break;
        case tsAskLogin:
            
            break;
        case tsAskCarNumplate:
            
            break;
        case tsAskStartMotor:
            
            break;
        case tsWaitSaveSample:
            
            break;
        case tsInlineEditPar:
            
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsRunning:
            
            break;
        case tsStop:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvReturen;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsPreStop:
            
            break;
        case tsEditSample:
            
            break;
        case tsSendSample:
            
            break;
        case tsSaveSample:
            
            break;
        case tsAfterEditK:
            
            break;
        case tsAskEndChk:
            
            break;
        case tsSelectChkMode:
            
            break;
        case tsEndTest:
            
            break;
        case tsSetPar:
            
            break;
        case tSelfTest:
            
            break;
        case tsSysPar:
            
            break;
        case tsDirectDisp:
            
            break;
        case tsInputOffNo:
            
            break;
            
        default:
            
            break;
    }
}

- (IBAction)LineSwitch:(id)sender {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    ConttentView *contentView = [[ConttentView alloc] initWithImg:@"SwitchLineBG"];
    [contentView.userName becomeFirstResponder];
    [alert setContainerView:contentView];
    contentView.delegate = self;
    [alert setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"切换", nil]];
    [alert setDelegate:self];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [contentView.userName resignFirstResponder];
        [contentView.passWord resignFirstResponder];
        if (buttonIndex == 0) {
            [alertView close];
        }else if(buttonIndex == 1){
            if ([_JKLineIP isEqualToString:@""]) {
                [[NSUserDefaults standardUserDefaults] setObject:_JKLinePort forKey:@"LinePort"];
            }else if ([_JKLinePort isEqualToString:@""]){
                [[NSUserDefaults standardUserDefaults] setObject:_JKLineIP forKey:@"LineIP"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:_JKLineIP forKey:@"LineIP"];
                [[NSUserDefaults standardUserDefaults] setObject:_JKLinePort forKey:@"LinePort"];
            }
            [alertView close];
        }
    }];
    
    [alert setUseMotionEffects:YES];
    
    [alert show];
}

#pragma mark -textFieldDelegate
//*************防止键盘遮挡********************
//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 130 - (self.view.frame.size.height - 355.0);// -键盘高度
    //**************键盘弹出的动画效果*****************
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //**************键盘弹出的动画效果*****************
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _KeyBoardText = textField.text;
    if (_NumberPadFlag) {
        [self sendAssignSpeed];
    }
    textField.text = @"";
}
//*************防止键盘遮挡********************

#pragma mark -LNNumberpadDelegate
- (void)SendFlag:(BOOL)flag {
    _NumberPadFlag = flag;
}

- (void)sendAssignSpeed {
    if (![_KeyBoardText isEqualToString:@""]){
        switch (_state) {
            case tsInit:
                [self tsInitAlertView];
                break;
            case tsWaitVerifyIn:
                [self tsWaitVerifyInAlertView];
                break;
            case tsWaitLogIn:
                [self alertView];
                break;
            case tsInputCarNo:
                
                break;
            case tsPreMotorDevice:
                
                break;
            case tsAskLogin:
                
                break;
            case tsAskCarNumplate:
                
                break;
            case tsAskStartMotor:
                
                break;
            case tsWaitSaveSample:
                
                break;
            case tsInlineEditPar:
                
                break;
            case tsAskParList:
                
                break;
            case tsSaveParList:
                
                break;
            case tsWaitRunCmd:
                
                break;
            case tsRunning:
            {
                uint8_t CMD = 0x3D;
                TKeyValue action = kvAssignSpeed;
                uint8_t content[3];
                content[0] = action;
                content[1] = (unsigned char)(([_KeyBoardText intValue] * 10) >> 8);
                content[2] = (unsigned char)(([_KeyBoardText intValue] * 10) & 0xffu);
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:3];
            }
                break;
            case tsStop:
                
                break;
            case tsPreStop:
                
                break;
            case tsEditSample:
                
                break;
            case tsSendSample:
                
                break;
            case tsSaveSample:
                
                break;
            case tsAfterEditK:
                
                break;
            case tsAskEndChk:
                
                break;
            case tsSelectChkMode:
            {
                uint8_t CMD = 0x3D;
                TKeyValue action = kvSelectChkMode;
                uint8_t content[2];
                content[0] = action;
                if ([_KeyBoardText intValue] == 1 || [_KeyBoardText intValue] == 2) {
                    content[1] = [_KeyBoardText intValue];
                    [_socket sendRemoteThreadWithCMD:CMD Content:content len:2];
                }
            }
                break;
            case tsEndTest:
                
                break;
            case tsSetPar:
                
                break;
            case tSelfTest:
                
                break;
            case tsSysPar:
                
                break;
            case tsDirectDisp:
                
                break;
            case tsInputOffNo:
                
                break;
                
            default:
                
                break;
        }
    }
}

#pragma mark -modelDelegate
- (void)UnconnectionTips {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tips.text = @"未连接";
    });
}

- (NSString *)calculateWithStandard:(NSString *)standard Sample:(NSString *)sample {
    NSString *s = [NSString new];
    if ([standard isEqualToString:@"--"] || [sample isEqualToString:@"--"]) {
        s = @"--";
    }else {
        float m = [standard floatValue];
        float n = [sample floatValue];
        float i = (m - n) / n;
        s = [NSString stringWithFormat:@"%.2f%c",i,'%'];
    }
    return s;
}

#pragma mark -CaptureViewDelegate
- (void)captureCarNumber:(NSString *)car {
    _inputCarNo = car;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
