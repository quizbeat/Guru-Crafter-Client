//
//  InstructorProfileViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 07/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "InstructorProfileViewController.h"
#import "AddInstructorViewController.h"
#import "Course+CoreDataProperties.h"


@interface InstructorProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation InstructorProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (self.instructor.isDeleted || self.instructor.managedObjectContext == nil) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    self.firstNameLabel.text = self.instructor.firstName;
    self.lastNameLabel.text = self.instructor.lastName;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionEditButtonPressed
{ // need to present edit profile screen
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddInstructorNavigationController"];
    AddInstructorViewController *vc = (AddInstructorViewController *)navController.topViewController;
    vc.viewMode = EditMode;
    vc.instructor = self.instructor;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.instructor.courses count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    if (section == 0) {
        title = @"Courses";
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CourseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Course *course = [[self.instructor.courses allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = course.name;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
