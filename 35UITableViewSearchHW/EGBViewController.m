//
//  EGBViewController.m
//  35UITableViewSearchHW
//
//  Created by Eduard Galchenko on 2/12/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBViewController.h"
#import "EGBStudent.h"
#import "EGBGroup.h"

typedef enum {
    
    EGBDateSortedType,
    EGBNameSortedType,
    EGBSurnameSortedType
    
} EGBStudentsSortedType;

@interface EGBViewController ()

@property (strong, nonatomic) NSMutableArray *studentsArray;
@property (strong, nonatomic) NSArray *groupArray;
@property (strong, nonatomic) NSArray *monthNames;
@property (strong, nonatomic) NSArray *superDateSorted;

@end

@implementation EGBViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.studentsArray = [NSMutableArray array];
    self.groupArray = [NSMutableArray array];
    
    self.monthNames = [[NSArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
    
    for (int i = 0; i < arc4random() % 500 + 300; i++) {
        
        [self.studentsArray addObject:[EGBStudent randomStudent]];
    }
  
   
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = self.studentsArray;

    self.superDateSorted = [self sortStudentsByDate:sortedArray];

    self.groupArray = [self generateSectionsFromArrayByNamesAndSurnames:self.superDateSorted withFilter:self.searchBar.text];
    [self.tableView reloadData];
    
    
    self.sortedTypeControl.selectedSegmentIndex = EGBDateSortedType;
}

#pragma mark - Private Methods

- (IBAction)actionControl:(UISegmentedControl *)sender {
 
    NSArray *sortedByDate = [[NSArray alloc] init];
    sortedByDate = self.studentsArray;
    
    switch (sender.selectedSegmentIndex) {
            
        case EGBDateSortedType:
            self.superDateSorted = [self sortStudentsByDate:sortedByDate];
            self.groupArray = [self generateSectionsFromArrayByNamesAndSurnames:self.superDateSorted withFilter:self.searchBar.text];
            break;
            
        case EGBNameSortedType:
            self.superDateSorted = [self sortStudentsByName:sortedByDate];
            self.groupArray = [self generateSectionsFromArrayByNamesAndSurnames:self.superDateSorted withFilter:self.searchBar.text];
            break;
            
        case EGBSurnameSortedType:
            self.superDateSorted = [self sortStudentsByLastName:sortedByDate];
            self.groupArray = [self generateSectionsFromArrayByNamesAndSurnames:self.superDateSorted withFilter:self.searchBar.text];
            break;
            
        default:
            self.sortedTypeControl.selectedSegmentIndex = EGBDateSortedType;
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Sorting Methods

- (NSArray*) sortStudentsByDate:(NSArray*) array {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
 
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(EGBStudent *stud1, EGBStudent *stud2) {
        
        NSString *month1 = [dateFormatter stringFromDate:stud1.dateOfBirth];
        NSString *month2 = [dateFormatter stringFromDate:stud2.dateOfBirth];
        
        if ([month1 isEqualToString:month2]) {
            
            if ([stud1.firstName isEqualToString:stud2.firstName]) {
                
                return [stud1.lastName compare:stud2.lastName];
            }
            
            return [stud1.firstName compare:stud2.firstName];
        }
        
        return [month1 compare:month2];
    }];
    
    return sorted;
}

- (NSArray*) sortStudentsByName:(NSArray*) array {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(EGBStudent *stud1, EGBStudent *stud2) {
        
        NSString *month1 = [dateFormatter stringFromDate:stud1.dateOfBirth];
        NSString *month2 = [dateFormatter stringFromDate:stud2.dateOfBirth];
        
        if ([stud1.firstName isEqualToString:stud2.firstName]) {
            
            if ([stud1.lastName isEqualToString:stud2.lastName]) {
                
                [month1 compare:month2];
            }
            
            return [stud1.lastName compare:stud2.lastName];
        }
        
        return [stud1.firstName compare:stud2.firstName];
    }];
    
    return sorted;
}

- (NSArray*) sortStudentsByLastName:(NSArray*) array {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSArray *sorted = [array sortedArrayUsingComparator:^NSComparisonResult(EGBStudent *stud1, EGBStudent *stud2) {
        
        NSString *month1 = [dateFormatter stringFromDate:stud1.dateOfBirth];
        NSString *month2 = [dateFormatter stringFromDate:stud2.dateOfBirth];
        
        if ([stud1.lastName isEqualToString:stud2.lastName]) {
            
            if ([month1 isEqualToString:month2]) {
                
                [stud1.firstName compare:stud2.firstName];
            }
            
            return [month1 compare:month2];
        }
        
        return [stud1.lastName compare:stud2.lastName];
    }];
    
    return sorted;
}

#pragma mark - Generating Section Method

- (NSArray*) generateSectionsFromArrayByNamesAndSurnames:(NSArray*) array withFilter:(NSString*) filterString {
    
    NSMutableArray *groupsArray = [NSMutableArray array];
    
    NSString *currentLetter = nil;
    
    for (EGBStudent *student in self.superDateSorted) {
        
        if ([filterString length] > 0 && (([student.firstName rangeOfString:filterString].location == NSNotFound) && ([student.lastName rangeOfString:filterString].location == NSNotFound))) {
            
            continue;
        }
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:student.dateOfBirth];
        NSInteger month = [components month];
        
        EGBGroup *group = nil;
        
        NSString *studentData = nil;
        
        if (self.sortedTypeControl.selectedSegmentIndex == EGBNameSortedType) {
            
            studentData = student.firstName;
            
        } else if (self.sortedTypeControl.selectedSegmentIndex == EGBSurnameSortedType) {
            
            studentData = student.lastName;
            
        } else if (self.sortedTypeControl.selectedSegmentIndex == EGBDateSortedType) {
            
            studentData = self.monthNames[month-1];
        }
        
        NSString *firstLetter = [studentData substringToIndex:1];
        
        if (![currentLetter isEqualToString:firstLetter]) {
            
            group = [[EGBGroup alloc] init];
            group.groupName = firstLetter;
            group.students = [NSMutableArray array];
            currentLetter = firstLetter;
            [groupsArray addObject:group];
            
        } else {
            
            group = [groupsArray lastObject];
        }
        
        [group.students addObject:student];
    }
    
    return groupsArray;
}


#pragma mark - UITableViewDataSourse

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (EGBGroup *group in self.groupArray) {
        
        [array addObject:[group.groupName substringToIndex:1]];
    }
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [[self.groupArray objectAtIndex:section] groupName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    EGBGroup *group = [self.groupArray objectAtIndex:section];

    return [group.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    EGBGroup *group = [self.groupArray objectAtIndex:indexPath.section];
    EGBStudent *student = [group.students objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [student firstName], [student lastName]];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[student dateOfBirth]];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.groupArray = [self generateSectionsFromArrayByNamesAndSurnames:self.superDateSorted withFilter:self.searchBar.text];
    
    [self.tableView reloadData];
 
    NSLog(@"textDidChange: %@", searchText);
}

@end
