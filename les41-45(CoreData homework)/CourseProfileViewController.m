//
//  CourseProfileViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 06/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "CourseProfileViewController.h"
#import "AddCourseViewController.h"
#import "StudentProfileViewController.h"

#import "CoreDataManager.h"
#import "Person+CoreDataProperties.h"
#import "Student+CoreDataProperties.h"
#import "Instructor+CoreDataProperties.h"


@interface CourseProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation CourseProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.course.isDeleted || self.course.managedObjectContext == nil) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    self.courseNameLabel.text = self.course.name;
    
    if (self.course.instructor) {
        self.instructorNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.course.instructor.firstName, self.course.instructor.lastName];
    } else {
        self.instructorNameLabel.text = @"nobody :(";
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.tableView reloadData];
}


- (void)actionEditButtonPressed
{ // need to present edit profile screen
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCourseNavigationController"];
    AddCourseViewController *vc = (AddCourseViewController *)navController.topViewController;
    vc.viewMode = EditMode;
    vc.course = self.course;
    [self presentViewController:navController animated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.course.students count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    if (section == 0) {
        title = @"Students";
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"StudentsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Student *student = [[self.course.students allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentProfileView"];
    Student *student = [[self.course.students allObjects] objectAtIndex:indexPath.row];
    vc.student = student;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
