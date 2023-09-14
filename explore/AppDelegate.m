//
//  AppDelegate.m
//  explore
//
//  Created by sahil singh on 24/07/23.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "CustomTabBarViewController.h"
#import "PlaceList.h"
#import "Place.h"

@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupCoreDataStack];
    
    //Custom Tab Bar
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CustomTabBarViewController *tabBarController = [[CustomTabBarViewController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    //Notification Authorization
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted){
            NSLog(@"We can send local notifications now");
        }
    }];
    
    //location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
        
    //Place to monitor
    PlaceList *list = [[PlaceList alloc] init];
    for(Place *place in list.getAll){
        CLLocationCoordinate2D geofenceCenter = CLLocationCoordinate2DMake(place.location.latitude, place.location.longitude);
        CLLocationDistance geofenceRadius = 100;
        CLCircularRegion *geofenceRegion = [[CLCircularRegion alloc] initWithCenter:geofenceCenter radius:geofenceRadius identifier:@"YourGeofenceIdentifier"];
        [self.locationManager startMonitoringForRegion:geofenceRegion];
    }
    
    return YES;
}

#pragma mark - DataBase

- (void)setupCoreDataStack {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PlaceModel"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error) {
            NSLog(@"Error Core Data Stack: %@, %@", error, error.userInfo);
        }else{
            self.managedObjectContext = self.persistentContainer.viewContext;
        }
    }];
}

#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        CLCircularRegion *circularRegion = (CLCircularRegion *)region;
        NSString *uniqueIdentifier = [NSString stringWithFormat:@"Geofence_%f_%f", circularRegion.center.latitude, circularRegion.center.longitude];
        
        if ([circularRegion.identifier isEqualToString:uniqueIdentifier]) {
            [self sendLocalNotificationForGeofenceEntry];
        }
    }
}


#pragma mark - Notification

- (void)sendLocalNotificationForGeofenceEntry {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Geofence Alert";
    content.body = @"You have entered the geofence area.";

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"GeofenceNotification" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
