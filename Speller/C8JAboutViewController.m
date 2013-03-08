//
//  C8JAboutViewController.m
//  Speller
//
//  Created by liulei on 2/12/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JAboutViewController.h"
#import "UIDeviceHardware.h"
#import "C8JAppDelegate.h"

#define  BUTTON_FONT [UIFont fontWithName:@"Baskerville-Bold" size:24]

@interface C8JAboutViewController ()

@end

@implementation C8JAboutViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"about", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"image-3"];
    }
    return self;
}

- (void)arrangeView{
    
    contentView.frame = CGRectMake(0,
                                   0,
                                   self.view.width,
                                   self.view.height);
    nameLabel.left = 0;
    nameLabel.top = 0;
    nameLabel.width = self.view.width;
    
    versionLabel.left = nameLabel.left;
    versionLabel.top = nameLabel.bottom;
    versionLabel.width = self.view.width;
    
    
    rateMeButton.centerX = nameLabel.centerX;
    rateMeButton.top = versionLabel.bottom;
    
    emailButton.left = rateMeButton.left;
    emailButton.top = rateMeButton.bottom;
    
    [self.view addSubview:contentView];
    [contentView addSubview:nameLabel];
    [contentView addSubview:versionLabel];
    
    [contentView addSubview:rateMeButton];
    [contentView addSubview:emailButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = BackgroundColor;
    
    nameLabel = [C8JUIUtils createLabel:[UIFont fontWithName:@"Baskerville-Bold" size:24]
                                   text:@"Speller"
                              textColor:MainFontColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    versionLabel = [C8JUIUtils createLabel:[UIFont fontWithName:@"Baskerville-Bold" size:14]
                                      text:@"v 1.0"
                                 textColor:MainFontColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    rateMeButton = [C8JUIUtils createButton:NSLocalizedString(@"rate_me", nil)
                        touchUpInsideAction:@selector(rateMeButtonClicked:)
                                     target:self];
    [rateMeButton setBackgroundImage:[UIImage imageNamed:@"rate_button.png"] forState:UIControlStateNormal];
    [rateMeButton.titleLabel setFont:BUTTON_FONT];
    rateMeButton.width = [UIImage imageNamed:@"rate_button.png"].size.width;
    rateMeButton.height = [UIImage imageNamed:@"rate_button.png"].size.height;
    
    emailButton = [C8JUIUtils createButton:NSLocalizedString(@"email", nil)
                       touchUpInsideAction:@selector(emailButtonClicked:)
                                    target:self];
    [emailButton setBackgroundImage:[UIImage imageNamed:@"mail_button.png"] forState:UIControlStateNormal];
    [emailButton.titleLabel setFont:BUTTON_FONT];
    emailButton.size = rateMeButton.size;
    
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0,43,1,0);
    [rateMeButton setTitleEdgeInsets:inset];
    [emailButton setTitleEdgeInsets:inset];
    
    [self arrangeView];
}

- (void)rateMeButtonClicked:(id)sender{
    
}

- (NSString *)tabImageName
{
    return @"image-3";
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[controller dismissModalViewControllerAnimated:YES];
}

-(void)emailButtonClicked:(id)sender{
	if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
		mailVC.mailComposeDelegate = self;
        mailVC.modalPresentationStyle = UIModalPresentationCurrentContext;
		[mailVC setToRecipients:[NSArray arrayWithObject:@"cool8jay@gmail.com"]];
        
		UIDeviceHardware *hardware=[[UIDeviceHardware alloc] init];
		NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *modelAndiosString =  [NSString stringWithFormat:@"%@ iOS %@", [hardware platformString], [[UIDevice currentDevice] systemVersion]];
		NSString *subjectString = [NSString stringWithFormat:NSLocalizedString(@"compound_mail_subject_feedback",nil),versionString];
		[mailVC setSubject:subjectString];
		
		NSString *mailBodyString = [NSString stringWithFormat:@"\n\n\n--------------------------------------------------\n%@",
                                    modelAndiosString];
		
		[mailVC setMessageBody:mailBodyString isHTML:NO];
		[self presentModalViewController:mailVC animated:YES];
        
        C8JAppDelegate *delegate = (C8JAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate tabBarController];
//        [delegate.tabBarController hideTabBar:0 animated:NO];
	}
	else
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"sorry",nil)
                                                        message:NSLocalizedString(@"alert_mail_account_missing", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}


@end
