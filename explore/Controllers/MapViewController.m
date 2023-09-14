//
//  MapViewController.m
//  explore
//
//  Created by sahil singh on 24/07/23.
//

#import "MapViewController.h"
#import "AddPlaceViewController.h"
#import "SinglePlaceViewController.h"
#import "CustomTabBarViewController.h"
#import "TempMsg.h"
#import "Place+MapAnnotation.h"
#import "PlaceList.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) MKLocalSearch *locationSearch;
@property (nonatomic, strong) MKLocalSearchCompleter *searchCompleter;
@property (nonatomic, strong) NSArray<MKLocalSearchCompletion *> *searchResults;
@property (nonatomic, strong) PlaceList *places;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.places = [[PlaceList alloc] init];
    
    if(self.tabSwitchedByButton){
        // Access the existing tab bar controller
        CustomTabBarViewController *tabBarController = (CustomTabBarViewController *)self.tabBarController;
        [tabBarController updateTabBarItemsAppearance];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.passedCoordinate, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self updateAnnotations];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabSwitchedByButton = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGesture];
    
    self.searchBar.delegate = self;
    
    self.mapView.delegate = self;
    
    self.tableView.delaysContentTouches = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.userInteractionEnabled = YES;
    
    // Initialize the location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    //[self.locationManager setAllowsBackgroundLocationUpdates:YES];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
    }else{
        NSLog(@"failed authorization!!!");
    }
    
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MKMapTypeHybrid;
    
    
    
    //auto complete
    self.searchCompleter = [[MKLocalSearchCompleter alloc] init];
    self.searchCompleter.delegate = self;
    [self.mapView addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)addGesture{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

- (void)addTapGestureRecognizerToTableView {
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:self.tapGesture];
}

- (void)removeTapGestureRecognizerFromTableView {
    [self.tableView removeGestureRecognizer:self.tapGesture];
    self.tapGesture = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGesture) {
        if ([touch.view isKindOfClass:[UISearchBar class]]) {
            return NO; // Don't recognize the tap gesture if the touch is on the search bar
        }
        if ([touch.view isKindOfClass:[UITableView class]]) {
            return NO; // Don't recognize the tap gesture if the touch is on the table view
        }
    }
    return YES;
}

- (void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapGesture];
       self.tapGesture = nil;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // Allow multiple gesture recognizers to work simultaneously
}
- (void)addPlace:(UIButton *)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIView *view = sender;
        while (view != nil && ![view isKindOfClass:[MKAnnotationView class]]) {
            view = view.superview;
        }
            
        if ([view isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *annotationView = (MKAnnotationView *)view;
            [self performSegueWithIdentifier:@"segueToAddPlace" sender:annotationView];
            [self.mapView removeAnnotation:((MKPointAnnotation *)annotationView)];
        }
    }
}

#pragma mark - SearchBar And Suggetions


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self addTapGestureRecognizerToTableView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self removeTapGestureRecognizerFromTableView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self.locationSearch cancel];
    
    MKLocalSearchRequest *req = [[MKLocalSearchRequest alloc] init];
    req.naturalLanguageQuery = searchBar.text;
    
    self.locationSearch = [[MKLocalSearch alloc] initWithRequest:req];
    [self.locationSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error location Search");
        }else{
            [self handleSearchResults:response.mapItems[0].placemark.coordinate];
            self.tableView.hidden = YES;
        }
    }];
}

- (void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer{
    self.searchResults = completer.results;
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText isEqualToString:@""]){
        self.tableView.hidden = YES;
    }else{
        self.searchCompleter.queryFragment = searchText;
        self.tableView.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchResults.count < 6){
        return self.searchResults.count;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestCell" forIndexPath:indexPath];
    
    MKLocalSearchCompletion *completion = self.searchResults[indexPath.row];
    cell.textLabel.text = completion.title;
    cell.detailTextLabel.text = completion.subtitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    MKLocalSearchCompletion *completion = self.searchResults[indexPath.row];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] initWithCompletion:completion];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error && response.mapItems.count > 0) {
            MKPlacemark *placemark = response.mapItems.firstObject.placemark;
            CLLocationCoordinate2D coordinate = placemark.coordinate;
            [self handleSearchResults:coordinate];
        }
    }];
        
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tableView.hidden = YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        annotation.title = @"Add Place";
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

#pragma mark - Annotations

- (MKMarkerAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
        static NSString *annotationIdentifier = @"ViewController";
        MKMarkerAnnotationView *view = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if(!view){
            view = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            view.canShowCallout = YES;
        }
        view.annotation = (MKPointAnnotation *)annotation;
        Place *place = [self findPlaceForAnnotation:(MKPointAnnotation *)annotation];
        if(place != nil){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
            imageView.image = [UIImage imageWithContentsOfFile:place.imagePath];
            view.leftCalloutAccessoryView = imageView;
            
            UIButton *addPlaceBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [addPlaceBtn addTarget:self action:@selector(showPlaceDetail:) forControlEvents:UIControlEventTouchUpInside];
            view.rightCalloutAccessoryView = addPlaceBtn;
            addPlaceBtn.tag = [self.places indexOfPlace:place];
        }else{
            UIButton *addPlaceBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [addPlaceBtn addTarget:self action:@selector(addPlace:) forControlEvents:UIControlEventTouchUpInside];
            view.rightCalloutAccessoryView = addPlaceBtn;
        }
        
        return view;
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(nonnull MKAnnotationView *)view{
    if([view.annotation isKindOfClass:[MKPointAnnotation class]]){
        if([self findPlaceForAnnotation:view.annotation]!= nil)return;
        [mapView removeAnnotation:view.annotation];
    }
}

- (void)updateAnnotations{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.places.getAll enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[Place class]]){
            Place *p = (Place *)obj;
            [self.mapView addAnnotation:p];
        }
    }];
}

- (Place *)findPlaceForAnnotation:(id<MKAnnotation>)annotation {
        for (Place *place in self.places.getAll) {
                if (annotation.coordinate.latitude == place.location.latitude && annotation.coordinate.longitude == place.location.longitude) {
                    return place;
                }
        }
    return nil;
}

#pragma mark - MKMapViewDelegate

- (void)handleSearchResults:(CLLocationCoordinate2D)coordinates{
    [self updateAnnotations];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinates;
    annotation.title = @"Add Place";
    [self.mapView addAnnotation:annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if(!self.tabSwitchedByButton){
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToAddPlace"]){
        if([segue.destinationViewController isKindOfClass:[AddPlaceViewController class]]){
            if ([sender isKindOfClass:[MKAnnotationView class]]) {
                MKAnnotationView *annotationView = (MKAnnotationView *)sender;
                AddPlaceViewController *sVC = (AddPlaceViewController *)segue.destinationViewController;
                sVC.coordinates = ((MKPointAnnotation *)annotationView).coordinate;
            }
        }
    }
}

- (IBAction)unwindForSegue:(UIStoryboardSegue *)segue{
    if([segue.identifier isEqualToString:@"backToMaps"]){
        TempMsg *temp = [[TempMsg alloc] initWthMessage:@"Place Saved" type:@"success"];
        [temp showMsgInView:self.view];
    }
}

- (void)showPlaceDetail:(UIButton *)sender {
    UITabBarController *tabController = (UITabBarController *)self.tabBarController;
    UINavigationController *navigationController = tabController.viewControllers[0];
    if (navigationController.viewControllers.count > 1) {
            [navigationController popToRootViewControllerAnimated:YES];
    }
    
    tabController.selectedIndex = 0;
    CustomTabBarViewController *tabBarController = (CustomTabBarViewController *)self.tabBarController;
    [tabBarController updateTabBarItemsAppearance];
    
    SinglePlaceViewController *singlePlace = [self.storyboard instantiateViewControllerWithIdentifier:@"singlePlace"];
    singlePlace.place = [self.places getAtIndex:sender.tag];
    [navigationController pushViewController:singlePlace animated:YES];
}

@end
