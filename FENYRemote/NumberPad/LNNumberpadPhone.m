//
//  LNNumberpadPhone.m
//  RemoteController
//
//  Created by 王旭 on 16/1/26.
//  Copyright © 2016年 无锡市瑞丰精密机电技术有限公司. All rights reserved.
//



#import "LNNumberpadPhone.h"

#pragma mark - Private methods

@interface LNNumberpadPhone ()

@property (nonatomic, weak) UIResponder <UITextInput> *targetTextInput;

@end

#pragma mark - LNNumberpad Implementation

@implementation LNNumberpadPhone

@synthesize targetTextInput,delegate = _delegate;

#pragma mark - Shared LNNumberpad method

+ (LNNumberpadPhone *)defaultLNNumberpad {
    static LNNumberpadPhone *defaultLNNumberpad = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultLNNumberpad = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberPadPhone" owner:self options:nil] objectAtIndex:0];
    });
    
    return defaultLNNumberpad;
}

#pragma mark - view lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObservers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObservers];
    }
    return self;
}

- (void)addObservers {
    // Keep track of the textView/Field that we are editing
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidBegin:)
                                                 name:UITextFieldTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidBegin:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidEnd:)
                                                 name:UITextFieldTextDidEndEditingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editingDidEnd:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidEndEditingNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:nil];
    self.targetTextInput = nil;
}

#pragma mark - editingDidBegin/End

// Editing just began, store a reference to the object that just became the firstResponder
- (void)editingDidBegin:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[UIResponder class]])
    {
        if ([notification.object conformsToProtocol:@protocol(UITextInput)]) {
            self.targetTextInput = notification.object;
            return;
        }
    }
    
    // Not a valid target for us to worry about.
    self.targetTextInput = nil;
}

// Editing just ended.
- (void)editingDidEnd:(NSNotification *)notification {
    self.targetTextInput = nil;
}

#pragma mark - Keypad IBAction's

// A number (0-9) was just pressed on the number pad
// Note that this would work just as well with letters or any other character and is not limited to numbers.
- (IBAction)numberpadNumberPressed:(UIButton *)sender {
    if (self.targetTextInput) {
        NSString *numberPressed  = sender.titleLabel.text;
        if ([numberPressed length] > 0) {
            UITextRange *selectedTextRange = self.targetTextInput.selectedTextRange;
            if (selectedTextRange) {
                [self textInput:self.targetTextInput replaceTextAtTextRange:selectedTextRange withString:numberPressed];
            }
        }
    }
}

// The delete button was just pressed on the number pad
- (IBAction)numberpadDeletePressed:(UIButton *)sender {
    if (self.targetTextInput) {
        UITextRange *selectedTextRange = self.targetTextInput.selectedTextRange;
        if (selectedTextRange) {
            // Calculate the selected text to delete
            UITextPosition  *startPosition  = [self.targetTextInput positionFromPosition:selectedTextRange.start offset:-1];
            if (!startPosition) {
                return;
            }
            UITextPosition  *endPosition    = selectedTextRange.end;
            if (!endPosition) {
                return;
            }
            UITextRange     *rangeToDelete  = [self.targetTextInput textRangeFromPosition:startPosition
                                                                               toPosition:endPosition];
            
            [self textInput:self.targetTextInput replaceTextAtTextRange:rangeToDelete withString:@""];
        }
    }
}

// The clear button was just pressed on the number pad
- (IBAction)numberpadClearPressed:(UIButton *)sender {
    if (self.targetTextInput) {
        UITextRange *allTextRange = [self.targetTextInput textRangeFromPosition:self.targetTextInput.beginningOfDocument
                                                                     toPosition:self.targetTextInput.endOfDocument];
        
        [self textInput:self.targetTextInput replaceTextAtTextRange:allTextRange withString:@""];
    }
}

// The done button was just pressed on the number pad
- (IBAction)numberpadDonePressed:(UIButton *)sender {
    if (self.targetTextInput) {
        [self.targetTextInput resignFirstResponder];
        [_delegate SendFlag:YES];
    }
}
- (IBAction)ClosePad:(id)sender {
    [self.targetTextInput resignFirstResponder];
    [_delegate SendFlag:NO];
}

#pragma mark - text replacement routines

// Check delegate methods to see if we should change the characters in range
- (BOOL)textInput:(id <UITextInput>)textInput shouldChangeCharactersInRange:(NSRange)range withString:(NSString *)string {
    if (textInput) {
        if ([textInput isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)textInput;
            if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                if ([textField.delegate textField:textField
                    shouldChangeCharactersInRange:range
                                replacementString:string]) {
                    return YES;
                }
            } else {
                // Delegate does not respond, so default to YES
                return YES;
            }
        } else if ([textInput isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)textInput;
            if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                if ([textView.delegate textView:textView
                        shouldChangeTextInRange:range
                                replacementText:string]) {
                    return YES;
                }
            } else {
                // Delegate does not respond, so default to YES
                return YES;
            }
        }
    }
    return NO;
}

// Replace the text of the textInput in textRange with string if the delegate approves
- (void)textInput:(id <UITextInput>)textInput replaceTextAtTextRange:(UITextRange *)textRange withString:(NSString *)string {
    if (textInput) {
        if (textRange) {
            // Calculate the NSRange for the textInput text in the UITextRange textRange:
            NSInteger startPos                    = [textInput offsetFromPosition:textInput.beginningOfDocument
                                                                       toPosition:textRange.start];
            NSInteger length                      = [textInput offsetFromPosition:textRange.start
                                                                       toPosition:textRange.end];
            NSRange selectedRange           = NSMakeRange(startPos, length);
            
            if ([self textInput:textInput shouldChangeCharactersInRange:selectedRange withString:string]) {
                // Make the replacement:
                [textInput replaceRange:textRange withText:string];
            }
        }
    }
}

@end

