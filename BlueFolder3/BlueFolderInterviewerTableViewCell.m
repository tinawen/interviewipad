//
//  BlueFolderInterviewerTableViewCell.m
//  BlueFolder3
//
//  Created by tina on 1/9/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import "BlueFolderInterviewerTableViewCell.h"

@implementation BlueFolderInterviewerTableViewCell

@synthesize name;
@synthesize imageLink;
@synthesize time;

- (void)dealloc
{
    [name release];
    [imageLink release];
    [time release];
    [super dealloc];
}

# pragma mark delayed load images
- (void)loadImage:(NSString *)imageURL
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *image = [UIImage imageWithData:data];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)newImage
{
    [spinner stopAnimating];
    [pictureView setImage:newImage];
}

# pragma mark overriding the setters
- (void)setName:(NSString *)newName
{
    [nameLabel setText:newName];
    [name release];
    name = [newName retain];
}

- (void)setImageLink:(NSString *)link
{
    if ([link isKindOfClass:[NSNull class]] || ![link length])
    {
        [spinner stopAnimating];
        return;
    }

    [self performSelectorInBackground:@selector(loadImage:) withObject:link];
    [imageLink release];
    imageLink = [link retain];
}

- (void)setTime:(NSString *)newTime
{
    [timeLabel setText:[NSString stringWithFormat:@"starting today at %@", newTime]];
    [time release];
    time = [newTime retain];
}

@end
