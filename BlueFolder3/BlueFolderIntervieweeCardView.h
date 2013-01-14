//
//  BlueFolderIntervieweeCardView.h
//  BlueFolder3
//
//  Created by tina on 1/9/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlueFolderRequest;
@interface BlueFolderIntervieweeCardView : UIView <UIImagePickerControllerDelegate>
{
    IBOutlet UILabel *intervieweeNameLabel;
    IBOutlet UILabel *intervieweePositionLabel;
    IBOutlet UIImageView *intervieweeImageView;
    IBOutlet UIActivityIndicatorView *spinner;
    NSString *intervieweeName;
    NSString *intervieweePosition;
    NSString *intervieweeResume;
    NSString *intervieweeImageURL;
    NSArray *questions;
    BlueFolderRequest *request;
}

@property (nonatomic, retain) NSString *intervieweeName;
@property (nonatomic, retain) NSString *intervieweePosition;
@property (nonatomic, retain) NSString *intervieweeResume;
@property (nonatomic, retain) NSString *intervieweeImageURL;
@property (nonatomic, retain) NSArray *questions;

@end
