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
    
    NSArray *sortedByDate = [[NSArray alloc] init];
    sortedByDate = self.studentsArray;
    
    self.superDateSorted = [self sortStudentsByDate:sortedByDate];
    
    self.groupArray = [self generateSectionsFromArray:self.superDateSorted withFilter:self.searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - Private Methods

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

- (NSArray*) generateSectionsFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    NSMutableArray *groupsArray = [NSMutableArray array];
    
    NSString *currentNameMonth = nil;
    
    for (EGBStudent *student in self.superDateSorted) {
        
        if ([filterString length] > 0 && (([student.firstName rangeOfString:filterString].location == NSNotFound) && ([student.lastName rangeOfString:filterString].location == NSNotFound))) {
            
            continue;
        }
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:student.dateOfBirth];
        NSInteger month = [components month];
        
        EGBGroup *group = nil;
        
        NSString *firstMonth = self.monthNames[month-1];
        
        if (![currentNameMonth isEqualToString:firstMonth]) {
            
            group = [[EGBGroup alloc] init];
            group.groupName = firstMonth;
            group.students = [NSMutableArray array];
            currentNameMonth = firstMonth;
            [groupsArray addObject:group];
            
        } else {
            
            group = [groupsArray lastObject];
        }
        
        [group.students addObject:student];
    }
    
    NSLog(@"groupArray count: %ld", [self.groupArray count]);
    for (int i = 0; i < [self.groupArray count]; i++) {
        
        NSLog(@"%@", [self.groupArray[i] groupName]);
    }
    
    return groupsArray;
}

#pragma mark - UITableViewDataSourse

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (EGBGroup *group in self.groupArray) {
        
        [array addObject:[group.groupName substringToIndex:3]];
    }
    
    return array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.groupArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *month = [self.monthNames objectAtIndex:section];

    return month;
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
    
    self.groupArray = [self generateSectionsFromArray:self.superDateSorted withFilter:self.searchBar.text];
    [self.tableView reloadData];
 
    NSLog(@"textDidChange: %@", searchText);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
