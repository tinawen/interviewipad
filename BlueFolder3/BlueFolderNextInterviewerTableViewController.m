//
//  BlueFolderNextInterviewerTableViewController.m
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderNextInterviewerTableViewController.h"
#import "BlueFolderInterviewingViewController.h"

@interface BlueFolderNextInterviewerTableViewController ()

@property (readwrite, retain) BlueFolderInterviewingViewController *interviewingController;

@end

@implementation BlueFolderNextInterviewerTableViewController

@synthesize interviewingController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self setCanAddEntry:NO];
        [self setRefreshRequestURL:[NSURL URLWithString:@"http://interview.dev.corp.dropbox.com:8080/interviewers"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Who's interviewing after you?";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"I'm the last interviewer" style:UIBarButtonItemStyleBordered target:self action:@selector(noNextInterviewer)] autorelease];
}

- (void)dealloc
{
    [interviewingController release];
    [super dealloc];
}

- (void)refreshTableviewWithData:(NSData *)data
{
    NSError *error = NULL;
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error];
    if (error)
        NSLog(@"error serializing JSON objects");
    [self setDataArray:[content objectForKey:@"interviewers"]];
    [self.tableView reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

- (void)loadInterviewingView
{
    if (![self interviewingController])
        [self setInterviewingController:[[[BlueFolderInterviewingViewController alloc] init] autorelease]];
    [self.navigationController pushViewController:[self interviewingController] animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    //remember who the next interviewer is
    NSString *interviewer = [self.dataArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:interviewer forKey:@"next_interviewer"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadInterviewingView];
}

- (void)noNextInterviewer
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"next_interviewer"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self loadInterviewingView];
}
@end
