//
//  StudentProfileViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 04/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "StudentProfileViewController.h"
#import "Course+CoreDataProperties.h"
#import "AddStudentViewController.h"


@interface StudentProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation StudentProfileViewController

- (void)viewDidLoad
{
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
    
    if (self.student.isDeleted || self.student.managedObjectContext == nil) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    self.firstNameLabel.text = self.student.firstName;
    self.lastNameLable.text = self.student.lastName;
    self.emailLabel.text = self.student.email;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)actionEditButtonPressed
{ // need to present edit profile screen
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddStudentNavigationController"];
    AddStudentViewController *vc = (AddStudentViewController *)navController.topViewController;
    vc.viewMode = EditMode;
    vc.student = self.student;
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.student.courses count];
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
    
    Course *course = [[self.student.courses allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = course.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
