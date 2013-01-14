//
//  BlueFolderIntervieweeTableViewController.m
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderIntervieweeTableViewController.h"
#import "BlueFolderInterviewerTableViewController.h"
#import "BlueFolderIntervieweeCardView.h"
#import "BlueFolderUtils.h"
#import "BlueFolderRequest.h"

static CGFloat sContactCardHeight = 220;
static CGFloat sTableCellLeftOffset = 40;
static CGFloat sTableCellViewSpacer = 10;
static CGFloat sTableCellyOffset = 20;
static NSUInteger sIntervieweeCardTagOffset = 100;

@interface BlueFolderIntervieweeTableViewController () <EGORefreshTableHeaderDelegate, BlueFolderRequestDelegate>
 
@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) NSString *intervieweeSelected;
@property (nonatomic, retain) NSArray *dataArray;

- (void)refreshTableview;

@end

@implementation BlueFolderIntervieweeTableViewController

@synthesize dataArray;
@synthesize picker;
@synthesize intervieweeSelected;

# pragma mark utility functions
- (void)refreshTableview
{
    if (!request) {
		request = [[BlueFolderRequest alloc] init];
		request.delegate = self;
	}
    [request sendRequestWithURL:[BlueFolderUtils getIntervieweesURL] withParams:nil];
}

- (void)dataLoaded
{
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
}

- (BlueFolderIntervieweeCardView *)intervieweeCardView
{
    UIViewController *cardViewController = [[[UIViewController alloc] initWithNibName:@"BlueFolderIntervieweeCardViewController" bundle:nil] autorelease];
    return (BlueFolderIntervieweeCardView *)[cardViewController view];
}

# pragma mark view functions
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		refreshHeaderView = view;
		[view release];
        
        //  update the last update date
        [refreshHeaderView refreshLastUpdatedDate];
    }

    self.navigationItem.title = @"Who are you interviewing?";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:122.0/255.0 blue:222.0/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.parentViewController.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:251.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intervieweeSelected:) name:[BlueFolderUtils intervieweeSelectedNotification] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeIntervieweePicture:) name:[BlueFolderUtils takeIntervieweePictureNotification] object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTableview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void)dealloc
{
    [refreshHeaderView release];
    [dataArray release];
    [picker release];
    [intervieweeSelected release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:request];
    request.delegate = nil;
    [super dealloc];
}

# pragma mark notification callback
- (void)intervieweeSelected:(NSNotification *)notification
{
    NSDictionary *content = [notification userInfo];
    NSArray *interviewers = [content objectForKey:@"interviewers"];
    NSString *intervieweeName = [content objectForKey:@"intervieweeName"];
    NSString *intervieweePosition = [content objectForKey:@"intervieweePosition"];
    NSString *intervieweeResume = [content objectForKey:@"intervieweeResume"];
    UIImage *intervieweeImage = [content objectForKey:@"intervieweeImage"];
    NSArray *questions = [content objectForKey:@"questions"];
    BlueFolderInterviewerTableViewController *interviewerTableViewController = [[[BlueFolderInterviewerTableViewController alloc] initWithIntervieweeName:intervieweeName intervieweePosition:intervieweePosition intervieweeResume:intervieweeResume intervieweeImage:intervieweeImage andInterviewers:interviewers questions:questions] autorelease];
    [self.navigationController pushViewController:interviewerTableViewController animated:YES];
}

- (void)takeIntervieweePicture:(NSNotification *)notification
{
    NSDictionary *content = [notification userInfo];
    [self setIntervieweeSelected:[content objectForKey:@"interviewee"]];
    [self setPicker:[[[UIImagePickerController alloc] init] autorelease]];
    [self picker].delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self picker].sourceType = UIImagePickerControllerSourceTypeCamera;
    else
    {
        return;
    }
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark - Table view data source methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cardsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BlueFolderIntervieweeCardView *firstCard = [self intervieweeCardView];
        [firstCard setFrame:CGRectMake(sTableCellLeftOffset, sTableCellyOffset, sContactCardHeight, sContactCardHeight)];
        [cell addSubview:firstCard];
        [firstCard setTag:sIntervieweeCardTagOffset];
        BlueFolderIntervieweeCardView *secondCard = [self intervieweeCardView];
        [secondCard setFrame:CGRectMake(sTableCellLeftOffset + sTableCellViewSpacer + sContactCardHeight, sTableCellyOffset, sContactCardHeight, sContactCardHeight)];
        [cell addSubview:secondCard];
        [secondCard setTag:(sIntervieweeCardTagOffset + 1)];
        BlueFolderIntervieweeCardView *thirdCard = [self intervieweeCardView];
        [thirdCard setFrame:CGRectMake(sTableCellLeftOffset + 2 * sTableCellViewSpacer + 2 * sContactCardHeight, sTableCellyOffset, sContactCardHeight, sContactCardHeight)];
        [cell addSubview:thirdCard];
        [thirdCard setTag:(sIntervieweeCardTagOffset + 2)];
    }
    
    NSUInteger row = indexPath.row;
    NSUInteger i;
    NSUInteger start = row * [self cardsPerRow];
    for (i = start; i < (start + [self cardsPerRow]); i++)
    {
        BlueFolderIntervieweeCardView *contactCard = (BlueFolderIntervieweeCardView *)[cell viewWithTag:(sIntervieweeCardTagOffset + i % [self cardsPerRow])];
        if (i < [[self dataArray] count])
        {
            NSString *contactName = [[[self dataArray] objectAtIndex:i] firstObject];
            NSString *position = [[[self dataArray] objectAtIndex:i] objectAtIndex:1];
            NSString *resume = [[[self dataArray] objectAtIndex:i] objectAtIndex:2];
            NSString *imageURL = [[[self dataArray] objectAtIndex:i] objectAtIndex:3];
            if ([[[self dataArray] objectAtIndex:i] count] == 5)
            {
                NSArray *questions = [[[self dataArray] objectAtIndex:i] objectAtIndex:4];
                [contactCard setQuestions:questions];
            }
            [contactCard setHidden:NO];
            [contactCard setIntervieweeName:contactName];
            [contactCard setIntervieweePosition:position];
            [contactCard setIntervieweeResume:resume];
            [contactCard setIntervieweeImageURL:imageURL];
        }
        else
            [contactCard setHidden:YES];
    }
    
    return cell;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

# pragma mark table view delegate methods
- (NSUInteger)cardsPerRow
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil((CGFloat)[[self dataArray] count] / (CGFloat)[self cardsPerRow]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sContactCardHeight + 2 * sTableCellyOffset;
}

#pragma BlueFolderRequestDelegate methods
- (void)restClientLoadedData:(NSDictionary *)data forRequest:(NSURLRequest *)urlRequest
{
    if ([[[urlRequest URL] absoluteString] isEqualToString:[BlueFolderUtils getIntervieweesURL]])
    {
        [self setDataArray:[data objectForKey:@"interviewees"]];
        [self performSelectorOnMainThread:@selector(dataLoaded) withObject:nil waitUntilDone:NO];
    }
    else
        [self refreshTableview];
}

- (void)restClientFailedWithError:(NSError *)error forRequest:(NSURLRequest *)urlRequest
{
    if ([[[urlRequest URL] absoluteString] isEqualToString:[BlueFolderUtils getIntervieweesURL]])
        [BlueFolderUtils displayAlertWithMessage:@"Error loading interviewee data"];
    else
        [BlueFolderUtils displayAlertWithMessage:@"Error uploading interviewee picture"];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

# pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	reloading = YES;
	[self refreshTableview];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
	
}

# pragma image picker delegate callback
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker
{
    [[self picker] dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *intervieweeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(intervieweeImage, 0.5f);
    NSString *string = [BlueFolderUtils base64forData:data];
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self intervieweeSelected], @"interviewee", string, @"picture", nil];
    if([NSJSONSerialization isValidJSONObject:paramDictionary])
    {
        [request sendRequestWithURL:[NSString stringWithFormat:@"%@add_interviewee_pic", [BlueFolderUtils serverAddress]] withParams:paramDictionary];
    }
            
    [[self picker] dismissViewControllerAnimated:YES completion:NULL];
}

@end