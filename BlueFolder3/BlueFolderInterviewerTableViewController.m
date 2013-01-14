//
//  BlueFolderInterviewerTableViewController.m
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderInterviewerTableViewController.h"
#import "BlueFolderInterviewingViewController.h"
#import "BlueFolderInterviewerTableViewCell.h"

@interface BlueFolderInterviewerTableViewController ()

@property (readwrite, retain) NSArray *interviewers;
@property (readwrite, retain) NSString *intervieweeName;
@property (readwrite, retain) NSString *intervieweePosition;
@property (readwrite, retain) NSString *intervieweeResume;
@property (readwrite, retain) BlueFolderInterviewingViewController *interviewingViewController;
@property (nonatomic, retain) UIImage *intervieweeImage;
@property (nonatomic, retain) NSArray *questions;

@end

@implementation BlueFolderInterviewerTableViewController

@synthesize interviewers;
@synthesize intervieweeName;
@synthesize intervieweePosition;
@synthesize intervieweeResume;
@synthesize interviewingViewController;
@synthesize intervieweeImage;
@synthesize questions;

- (id)initWithIntervieweeName:(NSString *)intweeName intervieweePosition:(NSString *)intweePos intervieweeResume:(NSString *)intweeResume intervieweeImage:(UIImage *)intweeImage andInterviewers:(NSArray *)ints questions:(NSArray *)qs
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.intervieweeName = intweeName;
        self.intervieweePosition = intweePos;
        self.intervieweeResume = intweeResume;
        self.interviewers = ints;
        self.intervieweeImage = intweeImage;
        self.questions = qs;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Who are you?";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.parentViewController.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:251.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.sectionHeaderHeight = 5.0;
    self.tableView.sectionFooterHeight = 5.0;
}

- (void)dealloc
{
    [interviewers release];
    [intervieweeName release];
    [intervieweePosition release];
    [intervieweeResume release];
    [interviewingViewController release];
    [intervieweeImage release];
    [questions release];
    [super dealloc];
}

# pragma mark - Table view delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *interviewer_info = [[self interviewers] objectAtIndex:indexPath.section];
    [self setInterviewingViewController:[[BlueFolderInterviewingViewController alloc] initWithInterviewer:[interviewer_info objectAtIndex:0] andIntervieweeName:[self intervieweeName] intervieweePosition:[self intervieweePosition] intervieweeResume:[self intervieweeResume] intervieweeImage:[self intervieweeImage] questions:[self questions]]];
    [self.navigationController pushViewController:[self interviewingViewController] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.interviewers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

# pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"interviewersCell";
    BlueFolderInterviewerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BlueFolderInterviewerTableViewCell" owner:self options:nil];
    	cell = (BlueFolderInterviewerTableViewCell *)[nib objectAtIndex:0];
    }
    
    NSUInteger row = indexPath.section;
    cell.name = [[[self interviewers] objectAtIndex:row] firstObject];
    if (![[[[self interviewers] objectAtIndex:row] lastObject] isKindOfClass:[NSNull class]])
        cell.imageLink = [[[self interviewers] objectAtIndex:row] objectAtIndex:1];
    cell.time = [[[self interviewers] objectAtIndex:row] lastObject];
       
    return cell;
}

@end
