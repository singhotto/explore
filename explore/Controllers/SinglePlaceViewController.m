//
//  SinglePlaceViewController.m
//  explore
//
//  Created by sahil singh on 05/08/23.
//

#import "SinglePlaceViewController.h"

@interface SinglePlaceViewController ()

@property (strong, nonatomic) UITextView *descView;

@end

@implementation SinglePlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:self.place.placeName];
    [self setModifedDate:[self.place valueForKey:@"lastModified"]];
    [self setDescription:self.place.placeDescription];
    [self setImage:self.place.imagePath];
    
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.imageView.bounds.size.height + self.descView.bounds.size.height + self.titleLabel.bounds.size.height + self.dateLabel.bounds.size.height + 120);
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.dateLabel];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.descView];
}

- (void)setImage:(NSString *)path{
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
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
    
    CGSize sizeThatFits = [self.descView sizeThatFits:CGSizeMake(self.descView.frame.size.width, self.descView.bounds.size.height)];
    CGRect newFrame = self.descView.frame;
    newFrame.size = CGSizeMake(self.descView.frame.size.width, sizeThatFits.height);
    newFrame.origin.x = 20;
    newFrame.origin.y = self.imageView.bounds.size.height + self.titleLabel.bounds.size.height + self.dateLabel.bounds.size.height + 100;
    self.descView.frame = newFrame;
}

@end
