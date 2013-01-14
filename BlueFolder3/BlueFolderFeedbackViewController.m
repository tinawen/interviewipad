//
//  BlueFolderFeedbackViewController.m
//  BlueFolder3
//
//  Created by tina on 10/8/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderFeedbackViewController.h"
#import "BlueFolderIntervieweeTableViewController.h"
#import "BlueFolderUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "BlueFolderRequest.h"

@interface BlueFolderFeedbackViewController () <UITextViewDelegate, BlueFolderRequestDelegate>

@property (nonatomic, retain) NSString *intervieweeName;
@property (nonatomic, retain) NSString *intervieweePosition;
@property (nonatomic, retain) NSString *interviewerName;
@property (nonatomic, retain) UIImage *intervieweeImage;
@property (nonatomic, retain) UIImageView *yesButtonImageView;
@property (nonatomic, retain) UIImageView *noButtonImageView;
@property (nonatomic, assign) BOOL yesSelected;
@property (nonatomic, assign) BOOL noSelected;
@property (nonatomic, retain) UIButton *submitButton;

@end

@implementation BlueFolderFeedbackViewController

@synthesize intervieweeName;
@synthesize intervieweePosition;
@synthesize interviewerName;
@synthesize yesButtonImageView;
@synthesize noButtonImageView;
@synthesize yesSelected;
@synthesize noSelected;
@synthesize submitButton;
@synthesize intervieweeImage;

# pragma mark utility functions
// this function returns back the handle for the image, so the image can be updated later
- (UIImageView *)makeButtronWithFrame:(CGRect)frame actionSelector:(SEL)selector superView:(UIView *)superview backgroundColor:(UIColor *)backgroundColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius imageViewFrame:(CGRect)imageViewFrame image:(UIImage *)image labelFrame:(CGRect)labelFrame labelText:(NSString *)labelText
{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    [button setBackgroundColor:backgroundColor];
    button.layer.borderColor = borderColor.CGColor;
    button.layer.borderWidth = borderWidth;
    button.layer.cornerRadius = cornerRadius;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = image;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button addSubview:imageView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:labelFrame];
    label.textAlignment= NSTextAlignmentLeft;
    label.text = labelText;
    [label setBackgroundColor:[UIColor clearColor]];
    [button addSubview:label];
    return imageView;
}

- (void)layoutAllViews
{
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Feedback for %@", [self intervieweeName]]];
    if (![[self intervieweeImage] isKindOfClass:[NSNull class]] && [self intervieweeImage])
    {
        [intervieweeImageView setImage:[self intervieweeImage]];
    }
    
    [nextInterviewerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth];
    //get current time
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [timeStampLabel setText:[dateFormatter stringFromDate:date]];
    [callLabel setHidden:YES];
    [intervieweeNameLabel setText:[self intervieweeName]];
    [intervieweePositionLabel setText:[self intervieweePosition]];
    
    [self makeButtronWithFrame:CGRectMake(46, 123, 150, 50) actionSelector:@selector(contactButtonSelected) superView:nextInterviewerView backgroundColor:[UIColor colorWithRed:247.0/255.0 green:252.0/255.0 blue:255.0/255.0 alpha:1.0] borderColor:[UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0] borderWidth:1.0f cornerRadius:25.0f imageViewFrame:CGRectMake(20, 9, 26, 33) image:[UIImage imageNamed:@"icon-email.png"] labelFrame:CGRectMake(60, 13, 73, 25) labelText:@"Contact"];
    
    [self setYesButtonImageView:[self makeButtronWithFrame:CGRectMake(260, 325, 120, 45) actionSelector:@selector(yesButtonPressed) superView:self.view  backgroundColor:[UIColor colorWithRed:247.0/255.0 green:252.0/255.0 blue:255.0/255.0 alpha:1.0] borderColor:[UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0] borderWidth:1.0f cornerRadius:25.0f imageViewFrame:CGRectMake(34, 13, 20, 20) image:[UIImage imageNamed:@"notchecked.png"] labelFrame:CGRectMake(60, 9, 73, 25) labelText:@"Yes"]];
    
    [self setNoButtonImageView:[self makeButtronWithFrame:CGRectMake(390, 325, 120, 45) actionSelector:@selector(noButtonPressed) superView:self.view  backgroundColor:[UIColor colorWithRed:247.0/255.0 green:252.0/255.0 blue:255.0/255.0 alpha:1.0] borderColor:[UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0] borderWidth:1.0f cornerRadius:25.0f imageViewFrame:CGRectMake(34, 13, 20, 20) image:[UIImage imageNamed:@"notchecked.png"] labelFrame:CGRectMake(60, 9, 73, 25) labelText:@"No"]];
    
    questionTextView.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    questionTextView.layer.borderWidth = 1.0f;
    questionTextView.layer.cornerRadius = 10.0f;
    
    [self setSubmitButton:[UIButton buttonWithType:UIButtonTypeCustom]];
    [self submitButton].frame = CGRectMake(244, 702, 280, 90);
    [[self submitButton] addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:[self submitButton]];
    [[self submitButton] setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [[self submitButton] setEnabled:NO];
    [self submitButton].layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:80.0/255.0 blue:145.0/255.0 alpha:1.0].CGColor;
    [self submitButton].layer.borderWidth = 1.0f;
    [self submitButton].layer.cornerRadius = 5.0f;
    
    UIImageView *submitButtonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 34, 20, 20)];
    submitButtonImageView.image =[UIImage imageNamed:@"icon-submitbutton.png"];
    [submitButtonImageView setContentMode:UIViewContentModeScaleAspectFit];
    [[self submitButton] addSubview:submitButtonImageView];
    
    UILabel *submitButtonLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 34, 150, 20)];
    submitButtonLabel.textAlignment= NSTextAlignmentLeft;
    submitButtonLabel.textColor = [UIColor whiteColor];
    submitButtonLabel.text = @"Submit Feedback";
    submitButtonLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [submitButtonLabel setBackgroundColor:[UIColor clearColor]];
    [[self submitButton] addSubview:submitButtonLabel];
    [questionTextView setDelegate:self];
    [self layoutSubmitButtonBasedOnNewOrientation:[self interfaceOrientation]];
}

- (void)layoutSubmitButtonBasedOnNewOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        [[self submitButton] setFrame:CGRectMake(680, 330, 280, 90)];
    }
    else
        [self submitButton].frame = CGRectMake(244, 702, 280, 90);
}

- (void)validateViews
{
    if (self.yesSelected)
    {
        [[self yesButtonImageView] setImage:[UIImage imageNamed:@"icon-checkmark.png"]];
        [[self noButtonImageView] setImage:[UIImage imageNamed:@"notchecked.png"]];
    }
    if (self.noSelected)
    {
        [[self noButtonImageView] setImage:[UIImage imageNamed:@"icon-checkmark.png"]];
        [[self yesButtonImageView] setImage:[UIImage imageNamed:@"notchecked.png"]];
    }
    if ((self.yesSelected || self.noSelected) && [[questionTextView text] length])
    {
        [[self submitButton] setEnabled:YES];
        [[self submitButton] setBackgroundColor:[UIColor colorWithRed:4.0/255.0 green:124.0/255.0 blue:222.0/255.0 alpha:1.0]];
    }
    else
    {
        [[self submitButton] setEnabled:NO];
        [[self submitButton] setBackgroundColor:[UIColor colorWithRed:196.0/255.0 green:210.0/255.0 blue:220.0/255.0 alpha:1.0]];
    }
}

# pragma mark view fucntions
- (id)initWithIntervieweeName:(NSString *)intName intervieweePosition:(NSString *)intPosition currentInterviewerName:(NSString *)intwerName intervieweeImage:(UIImage *)intweeImage
{
    self = [super init];
    if (self)
    {
        self.interviewerName = intwerName;
        self.intervieweePosition = intPosition;
        self.intervieweeName = intName;
        self.intervieweeImage = intweeImage;
    }
    return self;
}

- (void)dealloc
{
    [intervieweeName release];
    [intervieweePosition release];
    [interviewerName release];
    [yesButtonImageView release];
    [noButtonImageView release];
    [intervieweeImage release];
    [submitButton release];
    [NSObject cancelPreviousPerformRequestsWithTarget:request];
    request.delegate = nil;
    [super dealloc];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration 
{
    [self layoutSubmitButtonBasedOnNewOrientation:orientation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutAllViews];
    
    //get next interviewer info
    if (!request) {
		request = [[BlueFolderRequest alloc] init];
		request.delegate = self;
	}
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self interviewerName], @"interviewer", [self intervieweeName], @"interviewee", nil];
    if([NSJSONSerialization isValidJSONObject:paramDictionary])
    {
        [request sendRequestWithURL:[NSString stringWithFormat:@"%@next_interviewer_info", [BlueFolderUtils serverAddress]] withParams:paramDictionary];
    }
}

# pragma mark BlueFolderRequestDelegate functions
- (void)restClientLoadedData:(NSDictionary *)data forRequest:(NSURLRequest *)urlRequest
{
    if ([[[urlRequest URL] absoluteString] isEqualToString:[BlueFolderUtils nextInterviewerInfoURL]])
    {
        NSUInteger status = (NSUInteger)[data objectForKey:@"status"];
        if (status == 500)
        {
            [BlueFolderUtils displayAlertWithMessage:@"Something went wrong when getting the next interviewer info"];
            [nextInterviewerView setHidden:YES];
        }
        else if (!data || ![data objectForKey:@"next_interviewer_info"])
            [nextInterviewerView setHidden:YES];
        else
        {
            [nextInterviewerView setHidden:NO];
            NSDictionary *nextInterviewer = [data objectForKey:@"next_interviewer_info"];
            NSString *nextInterviewerName = [nextInterviewer objectForKey:@"name"];
            [nextInterviewerNameLabel setText:nextInterviewerName];
            NSString *nextInterviewerCell = [nextInterviewer objectForKey:@"cell"];
            if ([nextInterviewerCell length])
            {
                [nextInterviewerCellLabel setText:nextInterviewerCell];
                [callLabel setHidden:NO];
            }
            else
                [callLabel setHidden:YES];
            NSString *nextInterviewerPicture = [nextInterviewer objectForKey:@"picture"];
            if (![nextInterviewerPicture isKindOfClass:[NSNull class]])
            {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nextInterviewerPicture]];
                UIImage *image = [UIImage imageWithData:data];
                [nextInterviewerImage setImage:image];
            }
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        BlueFolderIntervieweeTableViewController *intervieweeViewController = [[[BlueFolderIntervieweeTableViewController alloc] init] autorelease];
        [self.navigationController pushViewController:intervieweeViewController animated:NO];
    }
}

- (void)restClientFailedWithError:(NSError *)error forRequest:(NSURLRequest *)urlRequest
{
    if ([[[urlRequest URL] absoluteString] isEqualToString:[BlueFolderUtils nextInterviewerInfoURL]])
        [BlueFolderUtils displayAlertWithMessage:@"Something went wrong loading next interviewer info"];
    else
        [BlueFolderUtils displayAlertWithMessage:@"Something went wrong when submitting your interview feedback"];
}

# pragma action selector methods
- (void)contactButtonSelected
{
    [BlueFolderUtils informNextInterviewerWithCurrentInterviewer:[self interviewerName] interviewee:[self intervieweeName]];
}

- (void)yesButtonPressed
{
    self.yesSelected = YES;
    self.noSelected = NO;
    [self validateViews];
}

- (void)noButtonPressed
{
    self.noSelected = YES;
    self.yesSelected = NO;
    [self validateViews];
}

- (void)submitButtonPressed
{
    BOOL hiringDecision = [self yesSelected];
    NSString *questionAsked = [questionTextView text];
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self intervieweeName], @"interviewee", [self interviewerName], @"interviewer", [NSNumber numberWithBool:hiringDecision], @"hire", questionAsked, @"question", nil];
    if([NSJSONSerialization isValidJSONObject:paramDictionary])
    {
        [request sendRequestWithURL:[NSString stringWithFormat: @"%@submit_feedback", [BlueFolderUtils serverAddress]] withParams:paramDictionary];
    }
}

# pragma mark text view delegate methods
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self validateViews];
}
@end
