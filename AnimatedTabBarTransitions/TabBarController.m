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

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *firstVC = [UIViewController new];
    
    UIViewController *secondVC = [UIViewController new];
    
    UIViewController *thirdVC = [UIViewController new];
    
    UIViewController *fourVC = [UIViewController new];
    
    UIViewController *fiveVC = [UIViewController new];
    
//    firstVC.view.backgroundColor = [UIColor greenColor];
    
    self.viewControllers = [[NSArray alloc]initWithObjects:firstVC, secondVC, thirdVC, fourVC, fiveVC, nil];
    
    CALayer *layer = [CALayer new];
    layer.backgroundColor = [UIColor redColor].CGColor;
    
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
    
    NSMutableArray *viewsMutableArray = [NSMutableArray new];
    
    NSArray *colors = [[NSArray alloc]initWithObjects:[UIColor redColor], [UIColor orangeColor], [UIColor blueColor], [UIColor magentaColor], [UIColor greenColor], nil];
    
    NSMutableArray *layers = [NSMutableArray new];
    
    NSLog(@"%s %@", __PRETTY_FUNCTION__, self.tabBar.subviews);
    
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.tabBar.subviews[i].frame.origin.x, 0.0, 0.0, self.tabBar.frame.size.height)];
        CALayer *layer = [CALayer new];
        layer.frame = view.frame;
        layer.backgroundColor = ((UIColor *)colors[i]).CGColor;
        view.alpha = 0.4;
        [self.tabBar addSubview:view];
        [viewsMutableArray addObject:view];
        [layers addObject:layer];
    }
    
    _viewsArray = viewsMutableArray.copy;
    
    NSLog(@"view frames are %@", self.viewsArray);
    
    NSLog(@"tabbaritem frames are %.2f", self.tabBar.subviews[1].frame.origin.x);
    
    NSLog(@"now item is selected: %u", [self.tabBar.items indexOfObject:self.tabBar.selectedItem]);
    
    [self rectForInitialItem];
    
    _actualView = [self.viewsArray objectAtIndex:[self.tabBar.items indexOfObject:self.tabBar.selectedItem]];
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.tabBar.frame.size.width * (1.0 / (i + 1)) , 0.0, 0.0, self.tabBar.frame.size.height)];
    
    /*
    _firstTabBarView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.tabBarWidth, self.tabBar.frame.size.height)];
    
    self.firstTabBarView.backgroundColor = [UIColor redColor];
    self.firstTabBarView.alpha = 0.5;
    self.firstTabBarView.userInteractionEnabled = NO;
    
    [self.tabBar addSubview:self.firstTabBarView];
    
    _secondTabBarView = [[UIView alloc]initWithFrame:CGRectMake(self.tabBarWidth, 0.0, 0.0, self.tabBar.frame.size.height)];
    
    self.secondTabBarView.backgroundColor = [UIColor blueColor];
    self.secondTabBarView.alpha = 0.5;
    self.secondTabBarView.userInteractionEnabled = NO;
    
    [self.tabBar addSubview:self.secondTabBarView];
    
    _thirdTabBarView = [[UIView alloc]initWithFrame:CGRectMake(self.tabBarWidth * 2.0, 0.0, 0.0, self.tabBar.frame.size.height)];
    
    self.thirdTabBarView.backgroundColor = [UIColor greenColor];
    self.thirdTabBarView.alpha = 0.5;
    self.thirdTabBarView.userInteractionEnabled = NO;
    
    [self.tabBar addSubview:self.thirdTabBarView];
    */
    
    
}

- (void)rectForInitialItem {
    UIView *initialView = [self.viewsArray objectAtIndex:[self.tabBar.items indexOfObject:self.tabBar.selectedItem]];
    CGRect initialRect = initialView.frame;
    initialRect.size.width = self.tabBarWidth;
    initialView.frame = initialRect;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"selected item is %@", item);
    [self animateToItem:item];
    
}

- (void)animateToItem:(UITabBarItem *)item {
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CALayer *layer = [CALayer new];
        UIView *viewToMove = self.actualView;
        UIView *correspondingView = [self.viewsArray objectAtIndex:[self.tabBar.items indexOfObject:item]];
        CGRect rectToMoveTo = viewToMove.frame;
        rectToMoveTo.origin.x = correspondingView.frame.origin.x;
        rectToMoveTo.size.width = self.tabBarWidth;
        viewToMove.frame = rectToMoveTo;
        self.actualView.frame = viewToMove.frame;
    } completion:nil];
}

- (void)clickAction {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect firstRect = self.firstTabBarView.frame;
        firstRect.origin.x = self.tabBarWidth;
        firstRect.size.width = 0.0;
        self.firstTabBarView.frame = firstRect;
        CGRect secondRect = self.secondTabBarView.frame;
        secondRect.size.width = self.tabBarWidth;
        self.secondTabBarView.frame = secondRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect secondRect = self.secondTabBarView.frame;
            secondRect.origin.x = self.tabBarWidth * 2.0;
            secondRect.size.width = 0.0;
            self.secondTabBarView.frame = secondRect;
            CGRect thirdRect = self.thirdTabBarView.frame;
            thirdRect.size.width = self.tabBarWidth;
            self.thirdTabBarView.frame = thirdRect;
        } completion:nil];
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
