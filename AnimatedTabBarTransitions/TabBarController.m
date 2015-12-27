//
//  TabBarController.m
//  AnimatedTabBarTransitions
//
//  Created by AIR on 27.12.15.
//  Copyright © 2015 Ivan Golikov. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@property (nonatomic, strong) UIView        *firstTabBarView;
@property (nonatomic, strong) UIView        *secondTabBarView;

@property (nonatomic, assign) CGFloat       tabBarWidth;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *firstVC = [UIViewController new];
    
    UIViewController *secondVC = [UIViewController new];
    
    UIViewController *thirdVC = [UIViewController new];
    
    firstVC.view.backgroundColor = [UIColor greenColor];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:firstVC, secondVC, thirdVC, nil];
    
    CALayer *layer = [CALayer new];
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    UITabBarItem *tabBarItemOne = [self.tabBar.items objectAtIndex:0];
    
    UITabBarItem *tabBarItemTwo = [self.tabBar.items objectAtIndex:1];
    
    UITabBarItem *tabBarItemThree = [self.tabBar.items objectAtIndex:2];
    
    self.tabBarWidth = self.tabBar.frame.size.width / self.viewControllers.count;
    
    tabBarItemOne.title = @"FirstVC";
    tabBarItemTwo.title = @"SecondVC";
    tabBarItemThree.title = @"ThirdVC";
    
    _firstTabBarView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.tabBarWidth, self.tabBar.frame.size.height)];
    
    self.firstTabBarView.backgroundColor = [UIColor redColor];
    self.firstTabBarView.alpha = 0.2;
    self.firstTabBarView.userInteractionEnabled = NO;
    
    [self.tabBar addSubview:self.firstTabBarView];
    
    _secondTabBarView = [[UIView alloc]initWithFrame:CGRectMake(self.tabBarWidth, 0.0, 0.0, self.tabBar.frame.size.height)];
    
    self.secondTabBarView.backgroundColor = [UIColor blueColor];
    self.secondTabBarView.alpha = 0.2;
    self.secondTabBarView.userInteractionEnabled = NO;
    
    [self.tabBar addSubview:self.secondTabBarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)clickAction {
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect firstRect = self.firstTabBarView.frame;
        firstRect.origin.x = self.tabBarWidth;
        firstRect.size.width = 0.0;
        self.firstTabBarView.frame = firstRect;
        CGRect secondRect = self.secondTabBarView.frame;
        secondRect.size.width = self.tabBarWidth;
        self.secondTabBarView.frame = secondRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect firstRect = self.firstTabBarView.frame;
            firstRect.origin.x = self.tabBarWidth;
            firstRect.size.width = 0.0;
            self.firstTabBarView.frame = firstRect;
            CGRect secondRect = self.secondTabBarView.frame;
            secondRect.size.width = self.tabBarWidth;
            self.secondTabBarView.frame = secondRect;
        } completion:<#^(BOOL finished)completion#>]
    }];
}

+ (CGRect)frameForTabInTabBar:(UITabBar*)tabBar withIndex:(NSUInteger)index
{
    NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[tabBar.items count]];
    for (UIView *view in tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")] && [view respondsToSelector:@selector(frame)]) {
            // check for the selector -frame to prevent crashes in the very unlikely case that in the future
            // objects thar don't implement -frame can be subViews of an UIView
            [tabBarItems addObject:view];
        }
    }
    if ([tabBarItems count] == 0) {
        // no tabBarItems means either no UITabBarButtons were in the subView, or none responded to -frame
        // return CGRectZero to indicate that we couldn't figure out the frame
        return CGRectZero;
    }
    
    // sort by origin.x of the frame because the items are not necessarily in the correct order
    [tabBarItems sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        if (view1.frame.origin.x < view2.frame.origin.x) {
            return NSOrderedAscending;
        }
        if (view1.frame.origin.x > view2.frame.origin.x) {
            return NSOrderedDescending;
        }
        NSAssert(NO, @"%@ and %@ share the same origin.x. This should never happen and indicates a substantial change in the framework that renders this method useless.", view1, view2);
        return NSOrderedSame;
    }];
    
    CGRect frame = CGRectZero;
    if (index < [tabBarItems count]) {
        // viewController is in a regular tab
        UIView *tabView = tabBarItems[index];
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    }
    else {
        // our target viewController is inside the "more" tab
        UIView *tabView = [tabBarItems lastObject];
        if ([tabView respondsToSelector:@selector(frame)]) {
            frame = tabView.frame;
        }
    }
    return frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
