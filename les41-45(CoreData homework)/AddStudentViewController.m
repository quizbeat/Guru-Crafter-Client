//
//  AddStudentViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 02/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "AddStudentViewController.h"
#import "SelectItemsViewController.h"
#import "UIAlertController+ErrorAlert.h"
#import "EntityInfoCell.h"

#import "CoreDataManager.h"
#import "Student+CoreDataProperties.h"


typedef NS_ENUM(NSInteger, StudentInfoTextFieldTag) {
    StudentInfoTextFieldFirstName,
    StudentInfoTextFieldLastName,
    StudentInfoTextFieldEmail,
};


@interface AddStudentViewController () <SelectItemsDelegate, UITextFieldDelegate>

@end


@implementation AddStudentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewMode == AddMode) {
        self.navigationItem.title = @"Add student";
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        self.student = student;
        
    } else if (self.viewMode == EditMode) {
        self.navigationItem.title = @"Edit student";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addCourses
{
    SelectItemsViewController *vc = [[SelectItemsViewController alloc] init];
    vc.selectedItems = [self.student.courses copy];
    vc.selectionType = SelectionTypeMultiple;
    vc.itemsKind = ItemsKindCourse;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteStudentWithConfirmation:(BOOL)confirmation
{
    if (confirmation) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete student" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteStudent];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self deleteStudent];
    }
}

- (void)deleteStudent
{
    [[[CoreDataManager sharedManager] managedObjectContext] deleteObject:self.student];
    [[CoreDataManager sharedManager] saveContext];
}



#pragma mark - Data validation

- (BOOL)studentInfoIsValid
{
    NSString *firstName = [self firstNameInfo];
    if (firstName == nil || [firstName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *lastName = [self lastNameInfo];
    if (lastName == nil || [lastName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *email = [self emailInfo];
    if (email == nil || [email isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (NSString *)firstNameInfo
{
    EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *firstName = cell.infoTextField.text;
    return firstName;
}

- (NSString *)lastNameInfo
{
    EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    NSString *lastName = cell.infoTextField.text;
    return lastName;
}

- (NSString *)emailInfo
{
    EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    NSString *email = cell.infoTextField.text;
    return email;
}



#pragma mark - UI Actions

- (IBAction)actionCancelButtonPressed:(UIBarButtonItem *)sender
{
    if (self.viewMode == AddMode) {
        [self deleteStudentWithConfirmation:NO];
    } else {
        [[[CoreDataManager sharedManager] managedObjectContext] rollback];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender
{
    if ([self studentInfoIsValid]) {
        self.student.firstName = [self firstNameInfo];
        self.student.lastName = [self lastNameInfo];
        self.student.email = [self emailInfo];
        
        [[CoreDataManager sharedManager] saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController errorAlertWithTitle:@"Error" message:@"Please enter all info"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewMode == AddMode) {
        return 2;
    } else if (self.viewMode == EditMode) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1 + [self.student.courses count];
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EntityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EntityInfoCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EntityInfoCell class]) owner:nil options:nil];
            cell = [nib firstObject];
        }
        
        NSInteger row = indexPath.row;
        if (row == 0) {
            cell.infoTitleLabel.text = @"First name";
            cell.infoTextField.placeholder = @"Enter first name";
            cell.infoTextField.tag = StudentInfoTextFieldFirstName;
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.infoTextField.returnKeyType = UIReturnKeyNext;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.student.firstName;
            }
            
        } else if (row == 1) {
            cell.infoTitleLabel.text = @"Last name";
            cell.infoTextField.placeholder = @"Enter last name";
            cell.infoTextField.tag = StudentInfoTextFieldLastName;
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.infoTextField.returnKeyType = UIReturnKeyNext;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.student.lastName;
            }
            
        } else if (row == 2) {
            cell.infoTitleLabel.text = @"Email";
            cell.infoTextField.placeholder = @"Enter email";
            cell.infoTextField.tag = StudentInfoTextFieldEmail;
            cell.infoTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.infoTextField.returnKeyType = UIReturnKeyDone;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.student.email;
            }
        }
        
        cell.infoTextField.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *addCourseCellIdentifier = @"AddCoursesCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCourseCellIdentifier];
            return cell;
            
        } else {
            static NSString *courseCellIdentifier = @"CourseCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:courseCellIdentifier];
            }
            Course *course = [[self.student.courses allObjects] objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = course.name;
            return cell;
        }
        
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"DeleteStudentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
        
    } else {
        return nil;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Main info";
    } else if (section == 1) {
        return @"Courses";
    } else {
        return @"";
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) { // Add courses cell
        [self addCourses];
    } else if (indexPath.section == 2 && indexPath.row == 0) { // Delete student cell
        [self deleteStudentWithConfirmation:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == StudentInfoTextFieldFirstName) {
        [textField resignFirstResponder];
        EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell.infoTextField becomeFirstResponder];
    } else if (textField.tag == StudentInfoTextFieldLastName) {
        [textField resignFirstResponder];
        EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        [cell.infoTextField becomeFirstResponder];
    } else if (textField.tag == StudentInfoTextFieldEmail) {
        [textField resignFirstResponder];
    }
    
    return YES;
}



#pragma mark - SelectItemsDelegate

- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didDoneSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items
{
    [self.student setCourses:items];
}

- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didCancelSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items
{
    NSLog(@"cancel");
}

@end
