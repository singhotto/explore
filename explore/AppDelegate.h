//
//  AppDelegate.h
//  explore
//
//  Created by sahil singh on 24/07/23.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIWindow *window;
@end

