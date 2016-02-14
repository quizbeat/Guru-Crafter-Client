//
//  Person+CoreDataProperties.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 07/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

@dynamic firstName;
@dynamic lastName;

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"fullName"]) {
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        return fullName;
    }
    return nil;
}

@end
