//
//  OBTabBarController.m
//  AnimatedTabBarTransitions
//
//  Created by Ivan Golikov on 27.12.15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import "OBTabBarController.h"

NSString *const OBTabBarControllerErrorDomain = @"OBTabBarControllerErrorDomain";

@interface OBTabBarController ()

@property (nonatomic, readonly) NSArray     *viewsArray;

@property (nonatomic, readonly) UIView      *actualView;

@property (nonatomic, assign) NSInteger     viewPosition;

@property (nonatomic, assign) CGFloat       tabBarWidth;

@end

@implementation OBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // creating VCs for example
    UIViewController *firstVC = [UIViewController new];
    UIViewController *secondVC = [UIViewController new];
    UIViewController *thirdVC = [UIViewController new];
    UIViewController *fourVC = [UIViewController new];
    UIViewController *fiveVC = [UIViewController new];
    
    firstVC.view.backgroundColor = [UIColor greenColor];
    secondVC.view.backgroundColor = [UIColor yellowColor];
    thirdVC.view.backgroundColor = [UIColor blueColor];
    fourVC.view.backgroundColor = [UIColor magentaColor];
    fiveVC.view.backgroundColor = [UIColor grayColor];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:firstVC, secondVC, thirdVC, fourVC, fiveVC, nil];
    
    UITabBarItem *tabBarItemOne = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItemTwo = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItemThree = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItemFour = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItemFive = [self.tabBar.items objectAtIndex:4];
    
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
    self.viewPosition = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
    
    // active view
    _actualView = (UIView *)self.viewsArray[self.viewPosition];
    
    [self rectForInitialView];
}

// setting frame for active view
- (void)rectForInitialView {
    CGRect viewRect = self.actualView.frame;
    viewRect.size.width = self.tabBarWidth;
    self.actualView.frame = viewRect;
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.tabBar.userInteractionEnabled = NO;
    [self animateViewToPositionOfItem:item];
}

- (void)animateViewToPositionOfItem:(UITabBarItem *)item {
    // getting gap between initial and target tabbaritem
    NSInteger delta = [self.tabBar.items indexOfObject:item] - self.viewPosition;
    CGFloat totalDuration = 1.0;
    CGFloat disappearanceRate = 0.9;
    NSError *error = [NSError errorWithDomain:OBTabBarControllerErrorDomain code:0 userInfo:nil];
    [UIView animateKeyframesWithDuration:totalDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewAnimationOptionCurveEaseInOut animations:^{
        // getting absolute value in order to code right-to-left animations
        NSInteger modulusDelta = labs(delta);
        __block CGFloat relativeStartTimeForAppearingView = 0.0;
        CGFloat relativeStartTimeForDisappearingView = disappearanceRate * totalDuration;
        for (int i = 0; i < modulusDelta; i++) {
            CGFloat relativeDuration = (totalDuration / modulusDelta);
            CGFloat relativeDurationForDisappearingView = disappearanceRate * relativeDuration;
            
            // using "child" keyframe animations
            // this part is responsible for disappearance of view
            [UIView addKeyframeWithRelativeStartTime:relativeStartTimeForDisappearingView relativeDuration:relativeDurationForDisappearingView animations:^{
                
//                relativeDurationForDisappearingView += 10;
                
                UIView *viewToDisappear = [self.viewsArray objectAtIndex:self.viewPosition];
                CGRect rectForDisappearingView = viewToDisappear.frame;
                if ([self.tabBar.items indexOfObject:item] > self.viewPosition) {
                    rectForDisappearingView.origin.x = ((UIView *)[self.viewsArray objectAtIndex:self.viewPosition + 1]).frame.origin.x;
                }
                rectForDisappearingView.size.width = 0.0;
                viewToDisappear.frame = rectForDisappearingView;
            }];
            relativeStartTimeForDisappearingView += relativeDuration;
            // part is responsible for appearance of view
            [UIView addKeyframeWithRelativeStartTime:relativeStartTimeForAppearingView relativeDuration:relativeDuration animations:^{
                
                UIView *viewToReveal = nil;
                if (delta > 0) {
                    viewToReveal = [self.viewsArray objectAtIndex:self.viewPosition + 1];
                    // for right-to-left transition
                } else if (delta < 0) {
                    viewToReveal = [self.viewsArray objectAtIndex:self.viewPosition - 1];
                } else if (delta == 0) {
                    NSLog(@"No step! Error is: %@", error);
                }
                CGRect rectForViewToReveal = viewToReveal.frame;
                if ([self.tabBar.items indexOfObject:item] > self.viewPosition) {
                    rectForViewToReveal.size.width = self.tabBarWidth;
                    self.viewPosition++;
                } else if ([self.tabBar.items indexOfObject:item] < self.viewPosition) {
                    // right-to-left transition
                    rectForViewToReveal.size.width -= self.tabBarWidth;
                    self.viewPosition--;
                }
                viewToReveal.frame = rectForViewToReveal;
            }];
            relativeStartTimeForAppearingView += relativeDuration;
        }
    } completion:^(BOOL finished) {
        self.tabBar.userInteractionEnabled = YES;
    }];
}

@end
