//
//  SelectItemsViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 08/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataViewController.h"

typedef NS_ENUM(NSInteger, SelectionType) {
    SelectionTypeSingle,
    SelectionTypeMultiple,
};

typedef NS_ENUM(NSInteger, ItemsKind) {
    ItemsKindStudent,
    ItemsKindInstructor,
    ItemsKindCourse,
};

@protocol SelectItemsDelegate;

@interface SelectItemsViewController : CoreDataViewController

@property (weak, nonatomic) id<SelectItemsDelegate> delegate;

@property (strong, nonatomic) NSMutableSet *selectedItems;
@property (assign, nonatomic) ItemsKind itemsKind;
@property (assign, nonatomic) SelectionType selectionType;

@end


@protocol SelectItemsDelegate <NSObject>

- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didCancelSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items;
- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didDoneSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items;

@end