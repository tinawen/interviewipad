//
//  BlueFolderInterviewingViewController.m
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderInterviewingViewController.h"
#import "BlueFolderFeedbackViewController.h"
#import "BlueFolderUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "BlueFolderRequest.h"
@interface BlueFolderInterviewingViewController () <UITableViewDataSource, UITableViewDelegate, BlueFolderRequestDelegate>

@property (nonatomic, retain) NSString *interviewer;
@property (nonatomic, retain) NSString *intervieweeName;
@property (nonatomic, retain) NSString *intervieweePosition;
@property (nonatomic, retain) NSString *intervieweeResume;
@property (nonatomic, retain) UIImage *intervieweeImage;
@property (nonatomic, retain) NSArray *questions;

@end

@implementation BlueFolderInterviewingViewController

@synthesize interviewer;
@synthesize intervieweeName;
@synthesize intervieweePosition;
@synthesize intervieweeResume;
@synthesize intervieweeImage;
@synthesize questions;

- (id)initWithInterviewer:(NSString *)curInterviewer andIntervieweeName:(NSString *)curIntervieweeName intervieweePosition:(NSString *)curIntervieweePos intervieweeResume:(NSString *)curIntervieweeResume intervieweeImage:(UIImage *)curIntervieweeImage questions:(NSArray *)qs
{
    self = [super init];
    if (self)
    {
        [self setIntervieweeName:curIntervieweeName];
        [self setIntervieweePosition:curIntervieweePos];
        [self setInterviewer:curInterviewer];
        [self setIntervieweeResume:curIntervieweeResume];
        [self setIntervieweeImage:curIntervieweeImage];
        [self setQuestions:qs];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Interviewing";
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithTitle:@"End Interview" style:UIBarButtonItemStyleBordered target:self action:@selector(interviewCompleted)] autorelease];
    [barButton setTintColor:[UIColor colorWithRed:140.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = barButton;

    if (![[self intervieweeImage] isKindOfClass:[NSNull class]] && [self intervieweeImage])
    {
        [intervieweeImageView setImage:[self intervieweeImage]];
    }
        
    [contactButton setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:251.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [[contactButton layer] setBorderWidth:1.0f];
    [[contactButton layer] setCornerRadius:7.0f];
    [[contactButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [candidateNameLabel setText:[self intervieweeName]];
    [positionLabel setText:[self intervieweePosition]];
    
    //load resume
    if ([self intervieweeResume])
    {
        NSURL *targetURL = [NSURL URLWithString:[self intervieweeResume]];
        NSURLRequest *webviewRequest = [NSURLRequest requestWithURL:targetURL];
        [webview loadRequest:webviewRequest];
    }
    
    //update session status
    if (!request) {
		request = [[BlueFolderRequest alloc] init];
		request.delegate = self;
	}
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self interviewer], @"interviewer", [self intervieweeName], @"interviewee", [NSNumber numberWithInt:1], @"status", nil];
    if([NSJSONSerialization isValidJSONObject:paramDictionary])
    {
        [request sendRequestWithURL:[NSString stringWithFormat:@"%@update_session_status", [BlueFolderUtils serverAddress]] withParams:paramDictionary];
    }
    questionsTableView.delegate = self;
    questionsTableView.dataSource = self;
}

- (void)dealloc {
    [intervieweeName release];
    [intervieweePosition release];
    [intervieweeResume release];
    [intervieweeImage release];
    [interviewer release];
    [questions release];
    [NSObject cancelPreviousPerformRequestsWithTarget:request];
    request.delegate = nil;
    [super dealloc];
}

# pragma mark BlueFolderRequestDelegate methods
- (void)restClientFailedWithError:(NSError *)error forRequest:(NSURLRequest *)request
{
    [BlueFolderUtils displayAlertWithMessage:@"Updating session status failed"];
}

- (void)restClientLoadedData:(NSDictionary *)data forRequest:(NSURLRequest *)request
{

}

# pragma mark button selector methods
- (IBAction)contactNextInterviewer:(id)sender
{
    //contact the next interviewer
    [BlueFolderUtils informNextInterviewerWithCurrentInterviewer:[self interviewer] interviewee:[self intervieweeName]];
}
    
- (void)interviewCompleted
{
   BlueFolderFeedbackViewController *feedbackController = [[[BlueFolderFeedbackViewController alloc] initWithIntervieweeName:[self intervieweeName] intervieweePosition:[self intervieweePosition] currentInterviewerName:[self interviewer] intervieweeImage:[self intervieweeImage]] autorelease];
    [self.navigationController pushViewController:feedbackController animated:YES];
}

# pragma mark table view delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"questionsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self questions] objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL hidden = ([self.questions count] == 0);
    [questionLabel setHidden:hidden];
    [tableView setHidden:hidden];
    return [self.questions count];
}

@end
