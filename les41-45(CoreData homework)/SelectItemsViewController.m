//
//  SelectItemsViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 08/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "SelectItemsViewController.h"

static NSString * const kSelectItemsNavigationItemTitle = @"SelectItemsNavigationItemTitle";
static NSString * const kSelectItemsCacheName = @"SelectItemsCacheNameKey";
static NSString * const kSelectItemsEntityName = @"SelectItemsEntityNameKey";
static NSString * const kSelectItemsCellTextLabelKeyPath = @"SelectItemsCellTextLabelKeyPathKey";
static NSString * const kSelectItemsSortDescriptors = @"SelectItemsSortDescriptorsKey";


@interface SelectItemsViewController ()

@property (strong, nonatomic) NSMutableDictionary *dataInfo;
@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;

@end

@implementation SelectItemsViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataInfo = [NSMutableDictionary dictionary];
    [self setupDataInfo];
    
    if (self.selectedItems) {
        self.selectedItems = [self.selectedItems mutableCopy]; // just in case
    } else {
        self.selectedItems = [NSMutableSet set];
    }
    
    self.navigationItem.title = self.dataInfo[kSelectItemsNavigationItemTitle];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDoneButtonPressed)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSString *cacheName = self.dataInfo[kSelectItemsCacheName];
    [NSFetchedResultsController deleteCacheWithName:cacheName];
}

- (void)setupDataInfo
{
    NSString *navigationItemTitle;
    NSString *cacheName;
    NSString *entityName;
    NSString *cellTextLabelKeyPath;
    
    NSArray *sortDescriptors;
    
    if (self.itemsKind == ItemsKindStudent) {
        navigationItemTitle = @"Select student";
        cacheName = @"Students";
        entityName = @"Student";
        cellTextLabelKeyPath = @"fullName";
        NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
        
    } else if (self.itemsKind == ItemsKindInstructor) {
        navigationItemTitle = @"Select instructor";
        cacheName = @"Instructors";
        entityName = @"Instructor";
        cellTextLabelKeyPath = @"fullName";
        NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        sortDescriptors = @[firstNameDescriptor, lastNameDescriptor];
        
    } else if (self.itemsKind == ItemsKindCourse) {
        navigationItemTitle = @"Select course";
        cacheName = @"Courses";
        entityName = @"Course";
        cellTextLabelKeyPath = @"name";
        NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        sortDescriptors = @[nameDescriptor];
    }
    
    if (self.selectionType == SelectionTypeMultiple) {
        navigationItemTitle = [navigationItemTitle stringByAppendingString:@"s"];
    }
    
    self.dataInfo[kSelectItemsNavigationItemTitle] = navigationItemTitle;
    self.dataInfo[kSelectItemsCacheName] = cacheName;
    self.dataInfo[kSelectItemsEntityName] = entityName;
    self.dataInfo[kSelectItemsCellTextLabelKeyPath] = cellTextLabelKeyPath;
    self.dataInfo[kSelectItemsSortDescriptors] = sortDescriptors;
}

- (void)actionDoneButtonPressed
{
    id items = nil;
    if (self.selectionType == SelectionTypeSingle) {
        items = [self.selectedItems anyObject];
    } else {
        items = self.selectedItems;
    }
    [self.delegate selectItemsViewController:self didDoneSelectionForItemsKind:self.itemsKind items:items];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCancelButtonPressed
{
    id items = nil;
    if (self.selectionType == SelectionTypeSingle) {
        items = [self.selectedItems anyObject];
    } else {
        items = self.selectedItems;
    }
    [self.delegate selectItemsViewController:self didCancelSelectionForItemsKind:self.itemsKind items:items];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSelectedItem:(id)item
{
    if (self.selectionType == SelectionTypeSingle) {
        [self.selectedItems removeAllObjects];
    }
    [self.selectedItems addObject:item];
}

- (void)removeSelectedItem:(id)item
{
    [self.selectedItems removeObject:item];
}

- (void)updateSelectedCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (self.lastSelectedIndexPath) {
        UITableViewCell *lastSelectedCell = [tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
        lastSelectedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.lastSelectedIndexPath = indexPath;
}


#pragma mark - Core Data support

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:self.dataInfo[kSelectItemsEntityName] inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    [request setSortDescriptors:self.dataInfo[kSelectItemsSortDescriptors]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:self.dataInfo[kSelectItemsCacheName]];
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self removeSelectedItem:item];
        
    } else if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (self.selectionType == SelectionTypeSingle) {
            [self updateSelectedCellForTableView:tableView atIndexPath:indexPath];
        }
        [self addSelectedItem:item];
    }
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [item valueForKey:self.dataInfo[kSelectItemsCellTextLabelKeyPath]];
    
    if ([self.selectedItems containsObject:item]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastSelectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
