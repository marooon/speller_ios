//
//  C8JAppDelegate.m
//  Speller
//
//  Created by liulei on 2/8/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JAppDelegate.h"
//#import "C8JCrosswordViewController.h"
//#import "C8JSpellViewController.h"
#import "C8JAboutViewController.h"
#import "C8JSearchViewController.h"
#import "AKTabBarController.h"

@implementation C8JAppDelegate

@synthesize dictionaryWords;
@synthesize tabBarController = _tabBarController;

- (void)prepareData{
    @synchronized(self) {
        if (dictionaryWords==nil) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"word" ofType:@"txt"];
            
            NSString* content = [NSString stringWithContentsOfFile:filePath
                                                          encoding:NSUTF8StringEncoding
                                                             error:NULL];
            
            dictionaryWords = [content componentsSeparatedByString: @"\n"];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
 //   UITableViewController *tableViewController = [[FirstViewController alloc] initWithStyle:UITableViewStylePlain];
    

    
    C8JSearchViewController *viewController1 = [[C8JSearchViewController alloc] initWithSearchMode:SearchModeCrossword];
    C8JSearchViewController *viewController2 = [[C8JSearchViewController alloc] initWithSearchMode:SearchModeSpell];
    
  //  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
    UIViewController *viewController3 = [[C8JAboutViewController alloc] init];
    
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50];
    [_tabBarController setMinimumHeightToDisplayTitle:40.0];
    
    //self.tabBarController = [[UITabBarController alloc] init];
  //  self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3];
    
    
    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:
                                           viewController1,
                                          viewController2,
                                          viewController3,nil]];
    
    // Tab background Image
    [_tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
    [_tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
    
    // Tabs top embos Color
    [_tabBarController setTabEdgeColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];
    
    // Tabs Colors settings
    [_tabBarController setTabColors:@[[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.0],
     [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]]]; // MAX 2 Colors
    
    [_tabBarController setSelectedTabColors:@[[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0],
     [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]]]; // MAX 2 Colors
    
    // Tab Stroke Color
    [_tabBarController setTabStrokeColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
    // Icons Color settings
    [_tabBarController setIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
    
    [_tabBarController setSelectedIconColors:@[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1],
     [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1]]]; // MAX 2 Colors
    
    // Text Color
    [_tabBarController setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
    [_tabBarController setSelectedTextColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    
    // Hide / Show glossy on tab icons
    [_tabBarController setIconGlossyIsHidden:YES];
    
    [self.window.layer setCornerRadius:4];
    [self.window.layer setMasksToBounds:YES];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

@end
