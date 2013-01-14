//
//  BlueFolderTableViewController.m
//  BlueFolder3
//
//  Created by tina on 10/6/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderTableViewController.h"

@interface BlueFolderTableViewController () <EGORefreshTableHeaderDelegate, UITextFieldDelegate>

- (void)refreshTableview;

@end

@implementation BlueFolderTableViewController

@synthesize dataArray;
@synthesize addEntryText;
@synthesize addEntryPlaceholderText;
@synthesize refreshRequestURL;
@synthesize addEntryRequestURL;
@synthesize canAddEntry;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		refreshHeaderView = view;
		[view release];
        
        [self refreshTableview];
        //  update the last update date
        [refreshHeaderView refreshLastUpdatedDate];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self canAddEntry])
        [textField removeFromSuperview];
}

- (void)viewDidUnload
{
	refreshHeaderView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)refreshTableview
{
    [self refreshTableviewWithData:[NSData dataWithContentsOfURL:[self refreshRequestURL]]];
}

- (void)refreshTableviewWithData:(NSData *)data
{
    //subclass should complete the implementation
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [refreshHeaderView release];
    [dataArray release];
    [addEntryText release];
    [addEntryPlaceholderText release];
    [addEntryRequestURL release];
    [refreshRequestURL release];
    [super dealloc];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self canAddEntry] ? [[self dataArray] count] + 1 : [[self dataArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    //first row is add new interviewee row
    if ([self canAddEntry] && indexPath.row == 0)
    {
        cell.textLabel.text = [self addEntryText];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell.textLabel.text = [[self dataArray] objectAtIndex:[self canAddEntry] ? (indexPath.row - 1) : indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self canAddEntry])
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!textField)
            {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y - 16, cell.frame.size.width, cell.frame.size.height)];
                [textField setPlaceholder:[self addEntryPlaceholderText]];
                [textField setTextAlignment:NSTextAlignmentCenter];
                [textField setReturnKeyType:UIReturnKeyDone];
                textField.delegate = self;
            }
            cell.textLabel.text = @"";
            [cell addSubview:textField];
            [textField becomeFirstResponder];
        }
        else
            [textField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)doneLoadingTableViewData
{	
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark UITextFieldDelegateProtocol  
- (void)textFieldDidBeginEditing:(UITextField *)aTextField
{
    [aTextField setText:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObject:aTextField.text forKey:@"interviewee"];
    
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self addEntryRequestURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        NSHTTPURLResponse *response = NULL;
        NSError *error = NULL;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if ([response statusCode] == 200)
            [self refreshTableviewWithData:data];
        else
            [self.tableView reloadData];
    }
    
    [textField removeFromSuperview];
    return YES;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

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

@end
