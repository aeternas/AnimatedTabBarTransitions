//
//  TabBarController.m
//  AnimatedTabBarTransitions
//
//  Created by Ivan Golikov on 27.12.15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController () <UITabBarControllerDelegate, UITabBarDelegate>

@property (nonatomic, strong) UIView        *firstTabBarView;
@property (nonatomic, strong) UIView        *secondTabBarView;
@property (nonatomic, strong) UIView        *thirdTabBarView;

@property (nonatomic, readonly) NSArray     *viewsArray;

@property (nonatomic, assign) CGFloat       tabBarWidth;

@property (nonatomic, strong) UIView        *actualView;

@property (nonatomic, assign) NSInteger     viewPosition;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *firstVC = [UIViewController new];
    
    UIViewController *secondVC = [UIViewController new];
    
    UIViewController *thirdVC = [UIViewController new];
    
    UIViewController *fourVC = [UIViewController new];
    
    UIViewController *fiveVC = [UIViewController new];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:firstVC, secondVC, thirdVC, fourVC, fiveVC, nil];
    
    UITabBarItem *tabBarItemOne = [self.tabBar.items objectAtIndex:0];
    
    UITabBarItem *tabBarItemTwo = [self.tabBar.items objectAtIndex:1];
    
    UITabBarItem *tabBarItemThree = [self.tabBar.items objectAtIndex:2];
    
    UITabBarItem *tabBarItemFour = [self.tabBar.items objectAtIndex:3];
    
    UITabBarItem *tabBarItemFive = [self.tabBar.items objectAtIndex:4];
    
    self.tabBarWidth = self.tabBar.frame.size.width / self.viewControllers.count;
    
    tabBarItemOne.title = @"FirstVC";
    tabBarItemTwo.title = @"SecondVC";
    tabBarItemThree.title = @"ThirdVC";
    tabBarItemFour.title = @"FourthVC";
    tabBarItemFive.title = @"FifthVC";
    
    NSArray *colors = [[NSArray alloc]initWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor blueColor], [UIColor magentaColor], [UIColor greenColor], nil];
    
    NSMutableArray *views = [NSMutableArray new];
    
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * (self.tabBar.frame.size.width / (self.tabBar.items.count)), 0.0, 0.0, self.tabBar.frame.size.height)];
        view.backgroundColor = colors[i];
        view.alpha = 0.4;
        [self.tabBar addSubview:view];
        [views addObject:view];
    }
    
    _viewsArray = views.copy;
    
    NSLog(@"now item is selected: %u", [self.tabBar.items indexOfObject:self.tabBar.selectedItem]);
    
    self.viewPosition = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];

    _actualView = (UIView *)self.viewsArray[self.viewPosition];

    [self rectForInitialView];
}

- (void)rectForInitialView {
    CGRect viewRect = self.actualView.frame;
    viewRect.size.width = self.tabBarWidth;
    self.actualView.frame = viewRect;
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    while (self.viewPosition != [self.tabBar.items indexOfObject:item]) {
    
        [self letDisappearPreviousViewToItem:item];
//    }
    
}

- (void)letDisappearPreviousViewToItem:(UITabBarItem *)item {
    int delta = [self.tabBar.items indexOfObject:item] - self.viewPosition;
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        for (CGFloat fl = 0; fl < delta; fl++) {
            [UIView addKeyframeWithRelativeStartTime:fl / delta relativeDuration:0.5 animations:^{
                CALayer *viewToDisappear = [self.viewsArray objectAtIndex:self.viewPosition];
                CGRect rectForDisappearingView = viewToDisappear.frame;
                if ([self.tabBar.items indexOfObject:item] > self.viewPosition) {
                    rectForDisappearingView.origin.x = ((UIView *)[self.viewsArray objectAtIndex:self.viewPosition + 1]).frame.origin.x;
                }
                rectForDisappearingView.size.width = 0.0;
                viewToDisappear.frame = rectForDisappearingView;
                CALayer *viewToReveal = [self.viewsArray objectAtIndex:self.viewPosition + 1];
                CGRect rectForViewToReveal = viewToReveal.frame;
                if ([self.tabBar.items indexOfObject:item] > self.viewPosition) {
                    rectForViewToReveal.size.width = self.tabBarWidth;
                    self.viewPosition++;
                } else if ([self.tabBar.items indexOfObject:item] < self.viewPosition) {
                    rectForViewToReveal.size.width -= self.tabBarWidth;
                    self.viewPosition--;
                }
                viewToReveal.frame = rectForViewToReveal;
                NSLog(@"%d", self.viewPosition);
                
            }];
        
        }
    } completion:nil];
}

@end
