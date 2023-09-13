//
//  PlaceTableViewCell.m
//  explore
//
//  Created by sahil singh on 30/07/23.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.placeName = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
        [self.contentView addSubview:self.placeName];
        
        self.lastModified = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.bounds.size.width - 160, 10, 200, 30)];
        self.lastModified.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.lastModified];
    }
    return self;
}

@end
