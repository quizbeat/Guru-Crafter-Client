//
//  StudentsViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 24/01/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "StudentsViewController.h"
#import "AddStudentViewController.h"
#import "StudentProfileViewController.h"

#import "CoreDataManager.h"
#import "Student+CoreDataProperties.h"
#import "Course+CoreDataProperties.h"


@interface StudentsViewController ()

@end

@implementation StudentsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)dealloc
{
    [NSFetchedResultsController deleteCacheWithName:@"Students"];
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
    [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Students"];
    
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
    [self performSegueWithIdentifier:@"StudentProfileSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.detailTextLabel.text = student.email;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddNewStudentSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddStudentViewController *addStudentVC = (AddStudentViewController *)navigationController.topViewController;
        addStudentVC.viewMode = AddMode;
    } else if ([segue.identifier isEqualToString:@"StudentProfileSegue"]) {
        StudentProfileViewController *profileVC = (StudentProfileViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.student = student;
    }
}

@end
