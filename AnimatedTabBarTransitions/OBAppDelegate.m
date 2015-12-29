//
//  OBAppDelegate.m
//  AnimatedTabBarTransitions
//
//  Created by Ivan Golikov on 26.12.15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import "OBAppDelegate.h"
#import "OBTabBarController.h"

@interface OBAppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) OBTabBarController *tbc;

@end

@implementation OBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _tbc = [[OBTabBarController alloc]init];
    
    _tbc.delegate = self;
    
    self.window.rootViewController = self.tbc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSUInteger controllerIndex = [self.tbc.viewControllers indexOfObject:viewController];
    
    if (controllerIndex == tabBarController.selectedIndex) {
        return NO;
    }
    
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [tabBarController.viewControllers[controllerIndex] view];
    
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    [fromView.superview addSubview:toView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    toView.frame = CGRectMake((scrollRight ? screenWidth : -screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         fromView.frame = CGRectMake((scrollRight ? -screenWidth : screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
                         toView.frame = CGRectMake(0, viewSize.origin.y, screenWidth, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [fromView removeFromSuperview];
                             tabBarController.selectedIndex = controllerIndex;
                         }
                     }];
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
