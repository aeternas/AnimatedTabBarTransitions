//
//  OBTabBarController.m
//  AnimatedTabBarTransitions
//
//  Created by Ivan Golikov on 27.12.15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import "OBTabBarController.h"

NSString *const OBTabBarControllerErrorDomain = @"OBTabBarControllerErrorDomain";

// globally define animation duration both for VCs and tabBarItems animations
CGFloat const animationDuration = 1.0;

@interface OBTabBarController ()

@property (nonatomic, readonly) NSArray     *viewsArray;

@property (nonatomic, readonly) UIView      *actualView;

@property (nonatomic, assign) NSInteger     viewPositionIndex;
@property (nonatomic, assign) NSInteger     supplementaryViewPositionIndex;

@property (nonatomic, assign) CGFloat       tabBarWidth;

@end

@implementation OBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // creating VCs for example
    UIViewController *firstVC       = [UIViewController new];
    UIViewController *secondVC      = [UIViewController new];
    UIViewController *thirdVC       = [UIViewController new];
    UIViewController *fourVC        = [UIViewController new];
    UIViewController *fiveVC        = [UIViewController new];
    
    firstVC.view.backgroundColor    = [UIColor greenColor];
    secondVC.view.backgroundColor   = [UIColor yellowColor];
    thirdVC.view.backgroundColor    = [UIColor blueColor];
    fourVC.view.backgroundColor     = [UIColor magentaColor];
    fiveVC.view.backgroundColor     = [UIColor grayColor];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:firstVC, secondVC, thirdVC, fourVC, fiveVC, nil];
    
    UITabBarItem *tabBarItemOne     = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItemTwo     = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItemThree   = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItemFour    = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItemFive    = [self.tabBar.items objectAtIndex:4];
    
    tabBarItemOne.title = @"FirstVC";
    tabBarItemTwo.title = @"SecondVC";
    tabBarItemThree.title = @"ThirdVC";
    tabBarItemFour.title = @"FourthVC";
    tabBarItemFive.title = @"FifthVC";
    
    // width of one tab bar item
    self.tabBarWidth = self.tabBar.frame.size.width / self.viewControllers.count;
    
    UIColor *customRedColor = [UIColor colorWithRed:212.0/255.0 green:108.0/255.0 blue:96.0/255.0 alpha:1.0];
    UIColor *customYellowColor = [UIColor colorWithRed:243.0/255.0 green:188.0/255.0 blue:123.0/255.0 alpha:1.0];
    UIColor *customBlueColor = [UIColor colorWithRed:127.0/255.0 green:175.0/255.0 blue:205.0/255.0 alpha:1.0];
    UIColor *customMagentaColor = [UIColor colorWithRed:211.0/255.0 green:118.0/255.0 blue:153.0/255.0 alpha:1.0];
    UIColor *customGreenColor = [UIColor colorWithRed:136.0/255.0 green:202.0/255.0 blue:180.0/255.0 alpha:1.0];
    
    NSArray *colors = [[NSArray alloc]initWithObjects:customRedColor, customYellowColor, customBlueColor, customMagentaColor, customGreenColor, nil];
    
    NSMutableArray *views = [NSMutableArray new];
    
    // setting color view for each tab bar item
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * (self.tabBar.frame.size.width / (self.tabBar.items.count)), 0.0, 0.0, self.tabBar.frame.size.height)];
        view.backgroundColor = colors[i];
        view.alpha = 1.0;
        [self.tabBar insertSubview:view atIndex:0];
        [views addObject:view];
    }
    
    _viewsArray = views.copy;
    
    // setting position for initially selected tab bar item
    self.viewPositionIndex = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
    self.supplementaryViewPositionIndex = self.viewPositionIndex;
    
    // active view
    _actualView = (UIView *)self.viewsArray[self.viewPositionIndex];
    
    [self rectForInitialView];
}

// setting frame for active view
- (void)rectForInitialView {
    CGRect viewRect = self.actualView.frame;
    viewRect.size.width = self.tabBarWidth;
    self.actualView.frame = viewRect;
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    // temporarily disable user interaction
    self.tabBar.userInteractionEnabled = NO;
    [self animateViewToPositionOfItem:item];
}

- (void)foldBackAllViewsButItem:(UITabBarItem *)item {
    for (UIView *view in self.viewsArray) {
        CGRect viewRect = view.frame;
        viewRect.origin.x = ([self.viewsArray indexOfObject:view] * self.tabBarWidth);
        view.frame = viewRect;
    }
}
- (void)animateDisappearanceVersatile:(UITabBarItem *)item {
    
    NSInteger delta = self.supplementaryViewPositionIndex - [self.tabBar.items indexOfObject:item];
    
    CGFloat disappearanceRate = 0.35;
    NSInteger modulusDelta = labs(delta);
    __block CGFloat relativeStartTimeForAppearingView = 0.0;
    __block CGFloat relativeDuration = (animationDuration / modulusDelta);
    __block CGFloat relativeStartTimeForDisappearingView = disappearanceRate * animationDuration;
    [UIView animateKeyframesWithDuration:relativeStartTimeForDisappearingView delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        for (int i = 0; i < modulusDelta; i++) {
            
            [UIView addKeyframeWithRelativeStartTime:relativeStartTimeForAppearingView relativeDuration:relativeDuration / modulusDelta animations:^{
                
                UIView *viewToReveal = nil;
                
                viewToReveal = [self.viewsArray objectAtIndex:self.supplementaryViewPositionIndex];
                
                CGRect rectForViewToReveal = viewToReveal.frame;
                
                if (delta < 0) {
                    rectForViewToReveal.origin.x = ((UIView *)[self.viewsArray objectAtIndex:self.viewPositionIndex]).frame.origin.x;
                }
                rectForViewToReveal.size.width = 0.0;
                
                viewToReveal.frame = rectForViewToReveal;
                
                self.supplementaryViewPositionIndex = delta < 0 ? self.supplementaryViewPositionIndex + 1 : self.supplementaryViewPositionIndex - 1;
            }];
        }
    } completion:^(BOOL finished) {
        [self foldBackAllViewsButItem:item];
        self.tabBar.userInteractionEnabled = YES;
    }];
}

- (void)animateViewToPositionOfItem:(UITabBarItem *)item {
    NSInteger delta = [self.tabBar.items indexOfObject:item] - self.viewPositionIndex;
    NSError *error = [NSError errorWithDomain:OBTabBarControllerErrorDomain code:0 userInfo:nil];
    NSInteger modulusDelta = labs(delta);
    __block CGFloat relativeStartTimeForAppearingView = 0.0;
    __block CGFloat relativeDuration = (animationDuration / modulusDelta);
    
    // prep work for left-directed animation
    if (delta < 0) {
        for (UIView *view in self.viewsArray) {
            NSLog(@"viewPositionIndex is %li", (long)self.viewPositionIndex);
            if ([self.viewsArray indexOfObject:view] !=  self.viewPositionIndex) {
                CGRect viewRect = view.frame;
                viewRect.origin.x = ([self.viewsArray indexOfObject:view] + 1)  * self.tabBarWidth;
                view.frame = viewRect;
            }
        }
    }
    [UIView animateKeyframesWithDuration:animationDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationCurveEaseInOut animations:^{
        for (int i = 0; i < modulusDelta; i++) {
            [UIView addKeyframeWithRelativeStartTime:relativeStartTimeForAppearingView relativeDuration:relativeDuration animations:^{
                UIView *viewToReveal = nil;
                if (delta > 0) {
                    // get view which frames should be unwrapped
                    viewToReveal = [self.viewsArray objectAtIndex:self.viewPositionIndex + 1];
                    // for left-directed transition
                } else if (delta < 0) {
                    viewToReveal = [self.viewsArray objectAtIndex:self.viewPositionIndex - 1];
                } else if (delta == 0) {
                    NSLog(@"No step! Error is: %@", error);
                }
                CGRect rectForViewToReveal = viewToReveal.frame;
                if ([self.tabBar.items indexOfObject:item] > self.viewPositionIndex) {
                    rectForViewToReveal.size.width = self.tabBarWidth;
                    self.viewPositionIndex++;
                } else if ([self.tabBar.items indexOfObject:item] < self.viewPositionIndex) {
                    rectForViewToReveal.size.width -= self.tabBarWidth;
                    self.viewPositionIndex--;
                }
                viewToReveal.frame = rectForViewToReveal;
                relativeStartTimeForAppearingView += relativeDuration;
            }];
        }
    } completion:^(BOOL finished) {
        if (delta > 0) {
            self.supplementaryViewPositionIndex = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
            [self animateDisappearanceVersatile:item];
        } else if (delta < 0) {
            self.supplementaryViewPositionIndex = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
            [self animateDisappearanceVersatile:item];
        } else {
            NSLog(@"No step! Error is: %@", error);
        }
    }];
}

@end