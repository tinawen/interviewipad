//
//  BlueFolderInterviewerTableViewCell.h
//  BlueFolder3
//
//  Created by tina on 1/9/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueFolderInterviewerTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *pictureView;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIActivityIndicatorView *spinner;
    NSString *name;
    NSString *imageLink;
    NSString *time;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageLink;
@property (nonatomic, retain) NSString *time;
@end
