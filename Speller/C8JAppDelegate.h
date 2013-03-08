//
//  C8JAppDelegate.h
//  Speller
//
//  Created by liulei on 2/8/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"

@interface C8JAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    NSArray *dictionaryWords;
   // NSDictionary *dictionaryWords2;
}

@property (readonly, nonatomic)NSArray *dictionaryWords;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AKTabBarController *tabBarController;

@end
