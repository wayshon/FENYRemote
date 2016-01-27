//
//  remotecontrolViewController.m
//  10.19demo
//
//  Created by 王旭 on 15/10/19.
//  Copyright (c) 2015年 王旭. All rights reserved.
//

#import "remotecontrolViewController.h"
#import "LNNumberpad.h"
#import "OBShapedButton.h"
#import "ODXSocket.h"
#import "SocketModel.h"
#import "CustomIOSAlertView.h"
#import "ConttentView.h"
#import "CaptureView.h"
#import "YcKeyBoardView.h"
#import "DetailViewController3.h"
#import "DetailModel.h"

@interface remotecontrolViewController ()<CustomIOSAlertViewDelegate,YcKeyBoardViewDelegate,ContentViewDelegate,LNNumberpadDelegate,modelDelegate,CaptureViewDelegate>

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *passWord;
@property (nonatomic,strong) UISwipeGestureRecognizer *upGestureRecognizer;
@property (nonatomic,strong) YcKeyBoardView *key;
@property (nonatomic) UIButton *JDUserBtn;
@property (nonatomic) NSString *KeyBoardText;

@property (weak, nonatomic) IBOutlet OBShapedButton *SlipIn;
@property (weak, nonatomic) IBOutlet OBShapedButton *SlipOut;
@property (weak, nonatomic) IBOutlet OBShapedButton *GearUp;
@property (weak, nonatomic) IBOutlet OBShapedButton *GearDown;
@property (nonatomic) OBShapedButton *SlipAndGearBtn;
@property (nonatomic) BOOL isAnimation;
@property (atomic,strong) ODXSocket *socket;
@property (nonatomic) SocketModel *model;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (nonatomic) TTestState state;
@property (nonatomic) DetailModel *detail;
@property (nonatomic) NSString *tip;
@property (nonatomic) BOOL hasCamera;
@property (nonatomic) BOOL hasBG;
@property (nonatomic) NSString *inputCarNo;
@property (nonatomic) BOOL NumberPadFlag;

@end
@implementation remotecontrolViewController
@synthesize upGestureRecognizer;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGesture];
    [self CreatBtns];
    _socket = [ODXSocket sharedSocket];
    _model = [SocketModel sharedModel];
    _model.delegate = self;
    
    __block remotecontrolViewController *blockSelf = self;
    _model.modelBlock = ^(NSDictionary *dic){
        DetailModel *blockDetail = [[DetailModel alloc] init];
        [blockDetail setValuesForKeysWithDictionary:dic];
        [blockSelf performSegueWithIdentifier:@"REtoresult" sender:blockDetail];
    };
    
    _model.updateBlock = ^(TTestState state,NSString *tips,BOOL camera,BOOL bg,NSMutableString *jd){
        _state = state;
        _hasCamera = camera;
        _hasBG = bg;
        _userName = jd;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf updateView];
            blockSelf.tips.text = tips;
        });
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateView];
    //[_SlipAndGearBtn setBackgroundImage:[UIImage imageNamed:@"SlipAndGear0"] forState:UIControlStateNormal];
    //[self setAnimationLocation];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_SlipAndGearBtn setBackgroundImage:[UIImage imageNamed:@"SlipAndGear0"] forState:UIControlStateNormal];
    [self setAnimationLocation];
}

#pragma mark - BtnActions
- (IBAction)mainBtnActions:(id)sender {
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
            if (_hasBG) {
                [self alertViewCaptureWithCamera:_hasCamera];
            }else {
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

- (IBAction)UpBtnActions:(id)sender {
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

- (IBAction)DownBtnActions:(id)sender {
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
- (IBAction)LeftBtnActions:(id)sender {
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
- (IBAction)RightBtnActions:(id)sender {
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
- (IBAction)ReturnBtnActions:(id)sender {
    {
        uint8_t CMD = 0x3D;
        TKeyValue action = kvReturen;
        uint8_t content[1];
        content[0] = action;
        [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
    }
//    switch (_state) {
//        case tsInit:
//            [self tsInitAlertView];
//            break;
//        case tsWaitVerifyIn:
//            [self tsWaitVerifyInAlertView];
//            break;
//        case tsWaitLogIn:
//            [self alertView];
//            break;
//        case tsInputCarNo:
//        {
//            uint8_t CMD = 0x3D;
//            TKeyValue action = kvReturen;
//            uint8_t content[1];
//            content[0] = action;
//            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
//        }
//            break;
//        case tsPreMotorDevice:
//            
//            break;
//        case tsAskLogin:
//            
//            break;
//        case tsAskCarNumplate:
//            
//            break;
//        case tsAskStartMotor:
//            
//            break;
//        case tsWaitSaveSample:
//            
//            break;
//        case tsInlineEditPar:
//            
//            break;
//        case tsAskParList:
//            
//            break;
//        case tsSaveParList:
//            
//            break;
//        case tsWaitRunCmd:
//        {
//            uint8_t CMD = 0x3D;
//            TKeyValue action = kvReturen;
//            uint8_t content[1];
//            content[0] = action;
//            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
//        }
//            break;
//        case tsRunning:
//            
//            break;
//        case tsStop:
//        {
//            uint8_t CMD = 0x3D;
//            TKeyValue action = kvReturen;
//            uint8_t content[1];
//            content[0] = action;
//            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
//        }
//            break;
//        case tsPreStop:
//            
//            break;
//        case tsEditSample:
//            
//            break;
//        case tsSendSample:
//            
//            break;
//        case tsSaveSample:
//            
//            break;
//        case tsAfterEditK:
//            
//            break;
//        case tsAskEndChk:
//            
//            break;
//        case tsSelectChkMode:
//            
//            break;
//        case tsEndTest:
//            
//            break;
//        case tsSetPar:
//            
//            break;
//        case tSelfTest:
//            
//            break;
//        case tsSysPar:
//            
//            break;
//        case tsDirectDisp:
//            
//            break;
//        case tsInputOffNo:
//            
//            break;
//            
//        default:
//            
//            break;
//    }
}
- (IBAction)ZeroBtnActions:(id)sender {
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
- (IBAction)StopBtnActions:(id)sender {
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
- (IBAction)StartBtnActions:(id)sender {
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
- (IBAction)SamplingBtnActions:(id)sender {
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
- (IBAction)SlipInBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
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
            TKeyValue action = kvSlipIn;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipIn;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)SlipOutBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
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
            TKeyValue action = kvSlipOut;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvSlipOut;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)GearUpBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
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
            TKeyValue action = kvGearUp;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearUp;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}
- (IBAction)GearDownBtnAction:(id)sender {
    switch (_state) {
        case tsInit:
            [self tsInitAlertView];
            break;
        case tsWaitVerifyIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsWaitLogIn:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsInputCarNo:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
        case tsAskParList:
            
            break;
        case tsSaveParList:
            
            break;
        case tsWaitRunCmd:
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
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
            TKeyValue action = kvGearDown;
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
        {
            uint8_t CMD = 0x3D;
            TKeyValue action = kvGearDown;
            uint8_t content[1];
            content[0] = action;
            [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark -LNNumberpadDelegate
- (void)SendFlag:(BOOL)flag {
    _NumberPadFlag = flag;
}

- (void)sendAssignSpeed {
    if (![_KeyBoardText isEqualToString:@""]){
#warning Incomplete implementation
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
                uint8_t content[2];
                content[0] = action;
                content[1] = [_KeyBoardText intValue];
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

- (void)alertView{
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
    ConttentView *contentView = [[ConttentView alloc] initWithImg:@"carNumberBG"];
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
            [alertView close];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self EnterErrorAlertView];
            });
        }
    }];
    
    //[alert setUseMotionEffects:YES];
    
    [alert show];
}

- (void)EnterErrorAlertView {
    if (_state == tsWaitLogIn || _state == tsInit || _state == tsWaitVerifyIn) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登入不成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)alertViewCaptureWithCamera:(BOOL)camera {
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    CaptureView *captureView = [[CaptureView alloc] initWithImg:@"JDenterBG" Pad:YES];
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
                    content[i] = [_inputCarNo characterAtIndex:i];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:7];
                [alertView close];
            }
        }];
    }else {
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [captureView.carNumber resignFirstResponder];
            
            if (buttonIndex == 0) {
                [alertView close];
            }else {
#warning Incomplete implementation
                //这里发送车牌号
                uint8_t CMD = 0x33;
                uint8_t content[6];
                for (int i = 0; i < 6; i++) {
                    content[i] = [_inputCarNo characterAtIndex:i];
                }
                [_socket sendRemoteThreadWithCMD:CMD Content:content len:6];
            }
        }];
    }
    //[alert setUseMotionEffects:YES];
    
    [alert show];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"REtoresult"]){
        DetailViewController3 *viewController = segue.destinationViewController;
        //*****************熟记*****************
        viewController.detail = sender;
        //***************************************
    }
}

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
}

#pragma ContentViewDelegate
- (void)GetUserNameWithStr:(NSString *)userName {
    _userName = userName;
}

- (void)GetPassWordWithStr:(NSString *)passWord {
    _passWord = passWord;
}

#pragma mark -CreatBtns
- (void)CreatBtns {
    _JDUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 85, 64, 64)];
    [_JDUserBtn addTarget:self action:@selector(JDBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_JDUserBtn];
    
    _SlipAndGearBtn = [[OBShapedButton alloc] initWithFrame:CGRectMake(648, 127, 75, 75)];
    [_SlipAndGearBtn addTarget:self action:@selector(SlipAndGear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_SlipAndGearBtn];
}

- (void)JDBtnAction {
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
            [self JDRemoveUser];
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
            [self JDRemoveUser];
            break;
        case tsRunning:
            
            break;
        case tsStop:
            [self JDRemoveUser];
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

- (void)JDRemoveUser {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前检定员为:%@",_userName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
#warning Incomplete implementation
        //这里发送推出命令
        //要不要加个定时器，显示推出不成功
        uint8_t CMD = 0x3D;
        TKeyValue myaction = kvUserExit;
        uint8_t content[1];
        content[0] = myaction;
        [_socket sendRemoteThreadWithCMD:CMD Content:content len:1];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateView {
    _tips.text = _tip;
    if (_state <= tsWaitLogIn || _state == tsInputOffNo) {
        [_JDUserBtn setBackgroundImage:[UIImage imageNamed:@"Unuser"] forState:UIControlStateNormal];
    }else {
        [_JDUserBtn setBackgroundImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    }
}

#pragma Gesture
- (void)setGesture{
    self.upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.upGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (_state == tsWaitLogIn || _state == tsInit || _state == tsWaitVerifyIn) {
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

- (void)setAnimationLocation {
    _SlipIn.center = CGPointMake(850, 248);
    _SlipOut.center = CGPointMake(850, 321);
    _GearUp.center = CGPointMake(850, 394);
    _GearDown.center = CGPointMake(850, 467);
    _isAnimation = NO;
}

- (void)setAnimationAppear {
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _SlipIn.center = CGPointMake(700, 248);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.15 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _SlipOut.center = CGPointMake(700, 321);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _GearUp.center = CGPointMake(700, 394);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.25 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _GearDown.center = CGPointMake(700, 467);
    }completion:nil];
}

- (void)setAnimationDisappear {
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _SlipIn.center = CGPointMake(850, 248);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.15 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _SlipOut.center = CGPointMake(850, 321);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _GearUp.center = CGPointMake(850, 394);
    }completion:nil];
    [UIView animateWithDuration:0.3 delay:0.25 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _GearDown.center = CGPointMake(850, 467);
    }completion:nil];
}

- (void)SlipAndGear {
    if (_isAnimation) {
        [self setAnimationDisappear];
        [_SlipAndGearBtn setBackgroundImage:[UIImage imageNamed:@"SlipAndGear0"] forState:UIControlStateNormal];
        _isAnimation = NO;
    }else {
        [self setAnimationAppear];
        [_SlipAndGearBtn setBackgroundImage:[UIImage imageNamed:@"SlipAndGear1"] forState:UIControlStateNormal];
        _isAnimation = YES;
    }
}

#pragma mark -modelDelegate
- (void)UnconnectionTips {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tips.text = @"未连接";
    });
}

- (void)UpdateWithState:(TTestState)state Tips:(NSString *)tips Camera:(BOOL)camera Bg:(BOOL)bg HY:(NSMutableString *)hy JD:(NSMutableString *)jd Car:(NSMutableString *)car Sample:(NSMutableArray *)sample standArray:(NSMutableArray *)standArr Standard:(NSString *)sd Speed:(NSString *)sp{
//    _state = state;
//    _hasCamera = camera;
//    _hasBG = bg;
//    _userName = jd;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateView];
//        _tips.text = tips;
//    });
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
