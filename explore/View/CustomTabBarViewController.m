//
//  CustomTabBarControllerViewController.m
//  explore
//
//  Created by sahil singh on 20/08/23.
//
#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation CustomTabBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.delegate = self; // Set the delegate to self
    [self updateTabBarItemsAppearance]; // Call this to initially set the appearance
}

- (void)updateTabBarItemsAppearance {
    // Customize the title color for active and inactive states
    NSDictionary *titleAttributesActive = @{ NSForegroundColorAttributeName : [UIColor blueColor] }; // Active color
    NSDictionary *titleAttributesInactive = @{ NSForegroundColorAttributeName : [UIColor whiteColor] }; // Inactive color
    
    for (NSInteger i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        UIImage *image;
        
        if (i == 0) {
            if (i == self.selectedIndex) {
                image = [[UIImage imageNamed:@"home8-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else {
                image = [[UIImage imageNamed:@"home8"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        } else if (i == 1) {
            if (i == self.selectedIndex) {
                image = [[UIImage imageNamed:@"map8-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            } else {
                image = [[UIImage imageNamed:@"map8"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }
        
        [tabBarItem setImage:image];
        
        if (i == self.selectedIndex) {
            [tabBarItem setTitleTextAttributes:titleAttributesActive forState:UIControlStateNormal];
        } else {
            [tabBarItem setTitleTextAttributes:titleAttributesInactive forState:UIControlStateNormal];
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self updateTabBarItemsAppearance]; // Update appearance when selection changes
}

@end
