//
//  C8JAboutViewController.h
//  Speller
//
//  Created by liulei on 2/12/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface C8JAboutViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    UIImageView *appIconView;
    
    UILabel *nameLabel;
    UILabel *versionLabel;
    
    UIScrollView *contentView;
    
    UIButton *rateMeButton;
    UIButton *emailButton;
}

@end
