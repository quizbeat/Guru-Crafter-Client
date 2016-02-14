//
//  AddInstructorViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 07/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "AddInstructorViewController.h"
#import "UIAlertController+ErrorAlert.h"
#import "EntityInfoCell.h"
#import "CoreDataManager.h"
#import "Course+CoreDataProperties.h"


typedef NS_ENUM(NSInteger, InstructorInfoTextFieldTag) {
    InstructorInfoTextFieldFirstName,
    InstructorInfoTextFieldLastName,
};


@interface AddInstructorViewController () <UITextFieldDelegate>

@end


@implementation AddInstructorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewMode == AddMode) {
        self.navigationItem.title = @"Add instructor";
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
        Instructor *instructor = [NSEntityDescription insertNewObjectForEntityForName:@"Instructor" inManagedObjectContext:context];
        self.instructor = instructor;
        
    } else if (self.viewMode == EditMode) {
        self.navigationItem.title = @"Edit instructor";
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



#pragma mark - Data actions

- (void)deleteInstructorWithConfirmation:(BOOL)confirmation
{
    if (confirmation) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete instructor" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteInstructor];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self deleteInstructor];
    }
}

- (void)deleteInstructor
{
    [[[CoreDataManager sharedManager] managedObjectContext] deleteObject:self.instructor];
    [[CoreDataManager sharedManager] saveContext];
}



#pragma mark - Data validation

- (BOOL)instructorInfoIsValid
{
    NSString *firstName = [self firstNameInfo];
    if (firstName == nil || [firstName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *lastName = [self lastNameInfo];
    if (lastName == nil || [lastName isEqualToString:@""]) {
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



#pragma mark - UI Actions

- (IBAction)actionCancellButtonPressed:(UIBarButtonItem *)sender
{
    if (self.viewMode == AddMode) {
        [self deleteInstructorWithConfirmation:NO];
    } else {
        [[[CoreDataManager sharedManager] managedObjectContext] rollback];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender
{
    if ([self instructorInfoIsValid]) {
        self.instructor.firstName = [self firstNameInfo];
        self.instructor.lastName = [self lastNameInfo];
        
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
        return 1;
    } else if (self.viewMode == EditMode) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
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
            cell.infoTextField.tag = InstructorInfoTextFieldFirstName;
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.infoTextField.returnKeyType = UIReturnKeyNext;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.instructor.firstName;
            }
            
        } else if (row == 1) {
            cell.infoTitleLabel.text = @"Last name";
            cell.infoTextField.placeholder = @"Enter last name";
            cell.infoTextField.tag = InstructorInfoTextFieldLastName;
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.infoTextField.returnKeyType = UIReturnKeyDone;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.instructor.lastName;
            }
        }
        
        cell.infoTextField.delegate = self;
        
        return cell;
        
    } else if (indexPath.section == 1) {
        static NSString *identifier = @"DeleteInstructorCell";
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
    } else {
        return @"";
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) { // Delete instructor cell
        [self deleteInstructorWithConfirmation:YES];
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
    if (textField.tag == InstructorInfoTextFieldFirstName) {
        [textField resignFirstResponder];
        EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        [cell.infoTextField becomeFirstResponder];
    } else if (textField.tag == InstructorInfoTextFieldLastName) {
        [textField resignFirstResponder];
        EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        [cell.infoTextField becomeFirstResponder];
    }
    
    return YES;
}

@end
