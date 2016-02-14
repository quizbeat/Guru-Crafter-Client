//
//  CoursesViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 24/01/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "CoursesViewController.h"
#import "AddCourseViewController.h"
#import "CourseProfileViewController.h"
#import "Course+CoreDataProperties.h"


@interface CoursesViewController ()

@end

@implementation CoursesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [NSFetchedResultsController deleteCacheWithName:@"Courses"];
}


#pragma mark - Core Data support

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.fetchBatchSize = 100;
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Courses"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"CourseProfileSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld students", [course.students count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddCourseSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddCourseViewController *addCourseVC = (AddCourseViewController *)navigationController.topViewController;
        addCourseVC.viewMode = AddMode;
    } else if ([segue.identifier isEqualToString:@"CourseProfileSegue"]) {
        CourseProfileViewController *profileVC = (CourseProfileViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.course = course;
    }
}

@end
