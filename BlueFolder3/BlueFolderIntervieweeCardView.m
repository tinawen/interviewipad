//
//  BlueFolderIntervieweeCardView.m
//  BlueFolder3
//
//  Created by tina on 1/9/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import "BlueFolderIntervieweeCardView.h"
#import "BlueFolderInterviewerTableViewController.h"
#import "BlueFolderUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "BlueFolderRequest.h"

@interface BlueFolderIntervieweeCardView () <BlueFolderRequestDelegate>
@end

@implementation BlueFolderIntervieweeCardView
;
@synthesize intervieweeName;
@synthesize intervieweePosition;
@synthesize intervieweeResume;
@synthesize intervieweeImageURL;
@synthesize questions;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactCardSelected:)];
        [self addGestureRecognizer:singleFingerTap];
        [singleFingerTap release];
    }
    return self;
}

- (void)dealloc
{
    [intervieweeName release];
    [intervieweePosition release];
    [intervieweeResume release];
    [intervieweeImageURL release];
    [questions release];
    [NSObject cancelPreviousPerformRequestsWithTarget:request];
    request.delegate = nil;
    [super dealloc];
}

# pragma mark overriding the setters
- (void)setIntervieweeName:(NSString *)iName
{
    [intervieweeNameLabel setText:iName];
    [intervieweeName release];
    intervieweeName = [iName retain];
}

- (void)setIntervieweePosition:(NSString *)iPosition
{
    [intervieweePositionLabel setText:iPosition];
    [intervieweePosition release];
    intervieweePosition = [iPosition retain];
}

- (void)setIntervieweeImageURL:(NSString *)imageURL
{
    if ([imageURL isKindOfClass:[NSNull class]] || [imageURL isEqualToString:intervieweeImageURL])
    {
        [spinner stopAnimating];
        return;
    }
     
    [intervieweeImageURL release];
    intervieweeImageURL = [imageURL retain];
    if ([imageURL length])
    {
        [spinner startAnimating];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doDelayedImageLoad:) object:[self intervieweeImageURL]];
        [self performSelectorInBackground:@selector(doDelayedImageLoad:) withObject:[self intervieweeImageURL]];
    }
    else
        [spinner stopAnimating];
}

- (void)doDelayedImageLoad:(NSString *)imageURL
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(updateIntervieweeImage:) withObject:image waitUntilDone:NO];
}

- (void)updateIntervieweeImage:(UIImage *)newImage
{
    [spinner stopAnimating];
    [intervieweeImageView setImage:newImage];
}

# pragma mark action selector methods
- (void)contactCardSelected:(UITapGestureRecognizer *)recognizer
{
    if (![self intervieweeImageURL])
    {
        CGPoint location = [recognizer locationInView:recognizer.view];
        
        if (location.x > 60 && location.x < 160 && location.y > 31 && location.y < 131)
        {
            //inside image
            [[NSNotificationCenter defaultCenter] postNotificationName:[BlueFolderUtils takeIntervieweePictureNotification] object:self userInfo:[NSDictionary dictionaryWithObject:[self intervieweeName] forKey:@"interviewee"]];
            return;
        }
    }
    //set highlight style
    [intervieweeNameLabel setTextColor:[UIColor whiteColor]];
    [intervieweePositionLabel setTextColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor colorWithRed:87.0/255.0 green:170.0/255.0 blue:238.0/255.0 alpha:1.0]];
    self.layer.borderColor = [UIColor colorWithRed:0/255.0 green:117.0/255.0 blue:212.0/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 3.0f;
    self.layer.cornerRadius = 7.0f;
    [self performSelectorOnMainThread:@selector(getInterviewers) withObject:nil waitUntilDone:NO];
}

- (void)getInterviewers
{
    if (!request) {
		request = [[BlueFolderRequest alloc] init];
		request.delegate = self;
	}
    //get the next interviewer
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObject:[self intervieweeName] forKey:@"interviewee"];
    
    if([NSJSONSerialization isValidJSONObject:paramDictionary])
    {
        [request sendRequestWithURL:[NSString stringWithFormat:@"%@get_interviewers", [BlueFolderUtils serverAddress]] withParams:paramDictionary];
    }
}

# pragma mark BlueFolderRequestDelegate methods
- (void)restClientLoadedData:(NSDictionary *)data forRequest:(NSURLRequest *)urlRequest
{
    NSArray *interviewers = [data objectForKey:@"interviewers"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:interviewers, @"interviewers", [self intervieweeName], @"intervieweeName", [self intervieweePosition], @"intervieweePosition", nil];
    if ([self intervieweeResume])
        [dict setObject:[self intervieweeResume] forKey:@"intervieweeResume"];
    if ([self intervieweeImageURL])
        [dict setObject:[intervieweeImageView image] forKey:@"intervieweeImage"];
    if ([self questions])
        [dict setObject:[self questions] forKey:@"questions"];
    [[NSNotificationCenter defaultCenter] postNotificationName:[BlueFolderUtils intervieweeSelectedNotification] object:self userInfo:dict];
    [self revertIntervieweeCardStyleToDefault];
}

- (void)restClientFailedWithError:(NSError *)error forRequest:(NSURLRequest *)urlRequest
{
    [self revertIntervieweeCardStyleToDefault];
    [BlueFolderUtils displayAlertWithMessage:@"Something went wrong when retrieving interviewers"];
}

- (void)revertIntervieweeCardStyleToDefault
{
    //unset the style
    [intervieweeNameLabel setTextColor:[UIColor blackColor]];
    [intervieweePositionLabel setTextColor:[UIColor grayColor]];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderWidth = 0.0f;
}

@end
