//
//  C8JSearchBar.m
//  Speller
//
//  Created by liulei on 2/14/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JSearchBar.h"

#define C8JSearchBar_Height                     44.0
#define C8JSearchBar_padding                    10.0
#define C8JSearchBar_spacing                    10.0
#define C8JSearchBar_ButtonHeight               32.0
#define C8JSearchBar_ButtonWidth                70.0

@implementation C8JSearchBar

@synthesize delegate;
@synthesize text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, C8JSearchBar_Height)];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"noise-dark-gray.png"];
        
        _backView = [[UIImageView alloc] init];
        
        _backView.backgroundColor = [UIColor colorWithPatternImage:image];
        _backView.frame = CGRectMake(0, 0, frame.size.width, C8JSearchBar_Height);
        _backView.userInteractionEnabled = YES;
        CGRect a = CGRectMake(C8JSearchBar_padding,
                              5,
                              self.width - 2*C8JSearchBar_padding,
                              C8JSearchBar_Height-10);

        _textField = [[C8JTextField alloc] initWithFrame:a];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textField.borderStyle = UITextBorderStyleBezel;
        
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.frame = CGRectMake(C8JSearchBar_padding,
                                      5,
                                      self.width - 2*C8JSearchBar_padding,
                                      C8JSearchBar_Height-10);
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.placeholder = NSLocalizedString(@"search", nil);
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.frame = CGRectMake(_textField.right+2*C8JSearchBar_spacing,
                                         round((C8JSearchBar_Height-C8JSearchBar_ButtonHeight)/2),
                                         C8JSearchBar_ButtonWidth,
                                         C8JSearchBar_ButtonHeight);
        [_cancelButton setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _dimmingView = [[UIButton alloc] init];
        _dimmingView.frame = [[UIScreen mainScreen] bounds];
        _dimmingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _dimmingView.hidden = YES;
        [_dimmingView addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_dimmingView];
        [self addSubview:_backView];
        [_backView addSubview:_textField];
        [_backView addSubview:_cancelButton];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(CGRectContainsPoint(_textField.frame, point)){
        return _textField;
    }else if(CGRectContainsPoint(_cancelButton.frame, point)){
        return _cancelButton;
    }else if(!CGRectContainsPoint(_backView.frame, point)){
        if(_dimmingView.isHidden){
            return nil;
        }else{
            return _dimmingView;
        }
    }
    return nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _dimmingView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _textField.width = self.width - 2*C8JSearchBar_padding - 2*C8JSearchBar_spacing - _cancelButton.width;
        _cancelButton.left = _textField.right+2*C8JSearchBar_spacing;
    }];
    return YES;
}

- (void)searchBarCancelButtonClicked:(id)sender{
    _textField.text = @"";
    [delegate searchBarCancelButtonClicked:self];
    [_textField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _textField.width = self.width - 2*C8JSearchBar_padding;
        _cancelButton.left = _textField.right+2*C8JSearchBar_spacing;
    }];
    _dimmingView.hidden = YES;
}

-(NSString *)getText{
    return _textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField{
    [delegate searchBarSearchButtonClicked:self];
    [aTextField resignFirstResponder];
    _dimmingView.hidden = YES;
    return YES;
}

@end
