//
//  MapViewController.h
//  explore
//
//  Created by sahil singh on 24/07/23.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, MKLocalSearchCompleterDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CLLocationCoordinate2D passedCoordinate;
@property (nonatomic, assign) BOOL tabSwitchedByButton;
@end

NS_ASSUME_NONNULL_END
