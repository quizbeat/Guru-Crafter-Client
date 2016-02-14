//
//  InstructorsViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 24/01/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "InstructorsViewController.h"
#import "AddInstructorViewController.h"
#import "InstructorProfileViewController.h"

#import "Instructor+CoreDataProperties.h"


@interface InstructorsViewController ()

@end


@implementation InstructorsViewController

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
    [NSFetchedResultsController deleteCacheWithName:@"Instructors"];
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
    [NSEntityDescription entityForName:@"Instructor" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Instructors"];
    
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
    [self performSegueWithIdentifier:@"InstructorProfileSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}



#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Instructor *instructor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", instructor.firstName, instructor.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld courses", [instructor.courses count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInstructorSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddInstructorViewController *addInstructorVC = (AddInstructorViewController *)navigationController.topViewController;
        addInstructorVC.viewMode = AddMode;
    } else if ([segue.identifier isEqualToString:@"InstructorProfileSegue"]) {
        InstructorProfileViewController *profileVC = (InstructorProfileViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Instructor *instructor = [self.fetchedResultsController objectAtIndexPath:indexPath];
        profileVC.instructor = instructor;
    }
}


@end
