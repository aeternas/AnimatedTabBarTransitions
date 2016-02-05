//
//  OBTabBarController.h
//  AnimatedTabBarTransitions
//
//  Created by Ivan Golikov on 27.12.15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const OBTabBarControllerErrorDomain;

extern CGFloat const animationDuration;

@interface OBTabBarController : UITabBarController

@property (nonatomic, strong) UIView      *viewToReveal;

@end
