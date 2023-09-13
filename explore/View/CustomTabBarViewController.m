//
//  CustomTabBarControllerViewController.m
//  explore
//
//  Created by sahil singh on 20/08/23.
//

#import "CustomTabBarViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Loop through each tab bar item and customize their appearance
    for (UITabBarItem *tabBarItem in self.tabBar.items) {
        // Set the inactive icon image
        UIImage *inactiveImage = [[UIImage imageNamed:@"inactiveIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setImage:inactiveImage];
        
        // Set the active icon image
        UIImage *activeImage = [[UIImage imageNamed:@"activeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setSelectedImage:activeImage];
        
        // Customize the title color for active and inactive states
        NSDictionary *titleAttributesActive = @{ NSForegroundColorAttributeName : [UIColor blueColor] }; // Change to your desired active color
        NSDictionary *titleAttributesInactive = @{ NSForegroundColorAttributeName : [UIColor grayColor] }; // Change to your desired inactive color
        
        [tabBarItem setTitleTextAttributes:titleAttributesActive forState:UIControlStateSelected];
        [tabBarItem setTitleTextAttributes:titleAttributesInactive forState:UIControlStateNormal];
    }
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
