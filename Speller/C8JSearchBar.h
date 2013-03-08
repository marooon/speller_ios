//
//  C8JSearchBar.h
//  Speller
//
//  Created by liulei on 2/14/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C8JTextField.h"

@protocol C8JSearchBarDelegate;

@interface C8JSearchBar : UIView <UITextFieldDelegate>{
    UIImageView *_backView;
    
    UIButton *_dimmingView;
    C8JTextField *_textField;
    UIButton *_cancelButton;
    id<UISearchBarDelegate> _delegate;
}

@property(nonatomic,assign) id<C8JSearchBarDelegate> delegate;              // weak reference. default is nil
@property(nonatomic,readonly)   NSString               *text;                  // current/starting search text

-(NSString *)getText;

@end

@protocol C8JSearchBarDelegate <NSObject>

@optional

//- (BOOL)searchBarShouldBeginEditing:(C8JSearchBar *)searchBar;                      // return NO to not become first responder
//- (void)searchBarTextDidBeginEditing:(C8JSearchBar *)searchBar;                     // called when text starts editing
//- (BOOL)searchBarShouldEndEditing:(C8JSearchBar *)searchBar;                        // return NO to not resign first responder
//- (void)searchBarTextDidEndEditing:(C8JSearchBar *)searchBar;                       // called when text ends editing
//- (void)searchBar:(C8JSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
//- (BOOL)searchBar:(C8JSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes

- (void)searchBarSearchButtonClicked:(C8JSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(C8JSearchBar *) searchBar;                    // called when cancel button pressed

@end
