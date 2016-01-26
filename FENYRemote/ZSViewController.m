//
//  ZSViewController.m
//  ipadDemo
//
//  Created by 王旭 on 15/11/2.
//  Copyright © 2015年 王旭. All rights reserved.
//

#import "ZSViewController.h"

@interface ZSViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *bubble1;
@property (weak, nonatomic) IBOutlet UIImageView *bubble2;
@property (weak, nonatomic) IBOutlet UIImageView *bubble3;
@property (weak, nonatomic) IBOutlet UIImageView *bubble4;
@property (weak, nonatomic) IBOutlet UIImageView *bubble5;
@property (weak, nonatomic) IBOutlet UIImageView *toptext;
@property (weak, nonatomic) IBOutlet UIImageView *bottomtext;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ZSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    [self setBubblesTransform];
    [self bubblesAppear];
    [self setTextLocation];
    [self textAppear];
}

- (void)setBubblesTransform {
    _bubble1.transform = CGAffineTransformMakeScale(0, 0);
    _bubble2.transform = CGAffineTransformMakeScale(0, 0);
    _bubble3.transform = CGAffineTransformMakeScale(0, 0);
    _bubble4.transform = CGAffineTransformMakeScale(0, 0);
    _bubble5.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)bubblesAppear {
    [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _bubble1.transform = CGAffineTransformMakeScale(1, 1);
        _bubble5.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    [UIView animateWithDuration:0.4 delay:0.4 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _bubble2.transform = CGAffineTransformMakeScale(1, 1);
        _bubble4.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    [UIView animateWithDuration:0.4 delay:0.5 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _bubble3.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)setTextLocation {
    _toptext.center = CGPointMake(-592, _toptext.frame.origin.y);
    _bottomtext.center = CGPointMake(-197, _bottomtext.frame.origin.y);
}

- (void)textAppear {
    [UIView animateWithDuration:0.5 delay:0.6 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _toptext.center = CGPointMake(84, 270);
    }completion:nil];
    [UIView animateWithDuration:5 delay:0.7 usingSpringWithDamping:0.1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _bottomtext.center = CGPointMake(284, 450);
    }completion:nil];
}

- (IBAction)require:(id)sender {
    [_textfield resignFirstResponder];
    NSString *path = @"http://1.iloveyc.sinaapp.com/";
    NSURL *url = [NSURL URLWithString:path];
    //NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    //NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    CGRect screen = [ UIScreen mainScreen ].bounds;
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    _bgView.hidden = YES;
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"出错" message:@"网页加载出错" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *path = _textfield.text;
        NSURL *url = [NSURL URLWithString:path];
        //NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
