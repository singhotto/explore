//
//  SinglePlaceViewController.m
//  explore
//
//  Created by sahil singh on 05/08/23.
//

#import "SinglePlaceViewController.h"
#import "ModifyPlaceViewController.h"
#import "CustomTabBarViewController.h"
#import "MapViewController.h"
#import "TempMsg.h"
#import "PlaceList.h"

@interface SinglePlaceViewController ()

@property (strong, nonatomic) UITextView *descView;

@end

@implementation SinglePlaceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.place = [[[PlaceList alloc] init] placeWithLocation:self.place.location];
    [self updatePlace];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDescription:self.place.placeDescription];
    [self updatePlace];
    
    CGFloat totHeight = self.imageView.bounds.size.height + self.descView.bounds.size.height + self.titleLabel.bounds.size.height + self.dateLabel.bounds.size.height + 80;
    
    CGFloat btnWidth = 120.0;
    CGFloat parentWidth = CGRectGetWidth(self.view.bounds);
    CGFloat totalButtonsWidth = btnWidth * 2 + 20; // Combined width of both buttons plus padding
    CGFloat buttonsX = (parentWidth - totalButtonsWidth) / 2.0;
    
    UIButton *modifyButton = [self createButtonWithImageNamed:@"modify8" frame:CGRectMake(buttonsX, totHeight, btnWidth, 80) action:@selector(modify:)];
    UIButton *deleteButton = [self createButtonWithImageNamed:@"delete8" frame:CGRectMake(buttonsX + btnWidth + 20, totHeight, btnWidth, 80) action:@selector(delete:)];
    
    [self.view addSubview:modifyButton];
    [self.view addSubview:deleteButton];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, totHeight + modifyButton.bounds.size.height + 60);
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.descView];
    [self.scrollView addSubview:modifyButton];
    [self.scrollView addSubview:deleteButton];
}

- (UIButton *)createButtonWithImageNamed:(NSString *)imageName frame:(CGRect)frame action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    [button setFrame:frame];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)updatePlace{
    [self setTitle:self.place.placeName];
    self.descView.text = self.place.placeDescription;
    [self setImage:self.place.imagePath];
    [self setModifedDate:[self.place valueForKey:@"lastModified"]];
}

- (void)setImage:(NSString *)path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
        self.imageView.image = [UIImage imageWithContentsOfFile:path];
    }else{
        self.imageView.image = [UIImage imageNamed:@"no-image"];
    }
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setModifedDate:(NSDate *)date{
    NSDateFormatter *fdate = [[NSDateFormatter alloc] init];
    [fdate setDateFormat:@"E, d MMM yyyy"];
    self.dateLabel.text = [fdate stringFromDate:date];
}

- (void)setDescription:(NSString *)description{
    self.descView = [[UITextView alloc] initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width - 40, 1)];
    self.descView.editable = NO;
    self.descView.scrollEnabled = NO;
    self.descView.text = description;
    
    // Increase the font size
    UIFont *font = [UIFont systemFontOfSize:18]; // Change the font size as needed
    self.descView.font = font;
    
    CGSize sizeThatFits = [self.descView sizeThatFits:CGSizeMake(self.descView.frame.size.width, self.descView.bounds.size.height)];
    CGRect newFrame = self.descView.frame;
    newFrame.size = CGSizeMake(self.descView.frame.size.width, sizeThatFits.height);
    newFrame.origin.x = 20;
    newFrame.origin.y = self.imageView.bounds.size.height + self.titleLabel.bounds.size.height + self.dateLabel.bounds.size.height + 20;
    self.descView.frame = newFrame;
}


- (void)modify:(UIButton *)sender{
    [self performSegueWithIdentifier:@"segueToUpdate" sender:self];
}

- (IBAction)showOnMaps:(id)sender {
    UINavigationController *mapsController = self.tabBarController.viewControllers[1];
    MapViewController *mapVC = (MapViewController *)mapsController.topViewController;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.place.location.latitude;
    coordinate.longitude = self.place.location.longitude;
    mapVC.passedCoordinate = coordinate;
    mapVC.tabSwitchedByButton = YES;
    
    self.tabBarController.selectedIndex = 1;
    // Access the existing tab bar controller
    CustomTabBarViewController *tabBarController = (CustomTabBarViewController *)self.tabBarController;
    [tabBarController updateTabBarItemsAppearance];
    
}

- (void)delete:(UIButton *)sender{
    PlaceList *list = [[PlaceList alloc] init];
    [list removePlaceWithLocation:self.place.location];
    
    [self.delegate didDeleteItem];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToUpdate"]) {
        if ([segue.destinationViewController isKindOfClass:[ModifyPlaceViewController class]]) {
            ModifyPlaceViewController *sVC = (ModifyPlaceViewController *)segue.destinationViewController;
            NSLog(@"Place: %@", self.place);
            sVC.place = self.place;
        }
    } else {
        NSLog(@"Unknown segue identifier: %@", segue.identifier);
    }
}

- (IBAction)unwindForSegue:(UIStoryboardSegue *)segue{
    if([segue.identifier isEqualToString:@"placeUpdated"]){
        TempMsg *temp = [[TempMsg alloc] initWthMessage:@"Place Updated" type:@"info"];
        [temp showMsgInView:self.view];
    }
}

@end
