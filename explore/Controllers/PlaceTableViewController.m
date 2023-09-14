//
//  PlaceTableViewController.m
//  explore
//
//  Created by sahil singh on 24/07/23.
//

#import "PlaceTableViewController.h"
#import <CoreData/CoreData.h>
#import "PlaceList.h"
#import "TempMsg.h"
#import "PlaceTableViewCell.h"

//#import "PlaceViewController.h"
#import "SinglePlaceViewController.h"

@interface PlaceTableViewController ()
@property (nonatomic, strong) PlaceList *places;
@end

@implementation PlaceTableViewController

- (void)viewWillAppear:(BOOL)animated{
    self.places = [[PlaceList alloc] init];
    [self.tableView registerClass:[PlaceTableViewCell class] forCellReuseIdentifier:@"placeCell"];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.places size];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];
    Place *place = [self.places getAtIndex:indexPath.row];
    
    cell.placeName.text = place.placeName;
    
    NSDateFormatter *fdate = [[NSDateFormatter alloc] init];
    [fdate setDateFormat:@"dd-MM-yyyy"];
    cell.lastModified.text =  [fdate stringFromDate:[place valueForKey:@"lastModified"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueToPlace" sender:self];
}

- (void)didDeleteItem {
    TempMsg *temp = [[TempMsg alloc] initWthMessage:@"Place Removed" type:@"danger"];
    [temp showMsgInView:self.view];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToPlace"]) {
        if ([segue.destinationViewController isKindOfClass:[SinglePlaceViewController class]]) {
            SinglePlaceViewController *sVC = (SinglePlaceViewController *)segue.destinationViewController;
            sVC.delegate = self;
            NSIndexPath *idxPath = [self.tableView indexPathForSelectedRow];
            sVC.place = [self.places getAtIndex:idxPath.row];
        }
    } else {
        NSLog(@"Unknown segue identifier: %@", segue.identifier);
    }
}

@end
