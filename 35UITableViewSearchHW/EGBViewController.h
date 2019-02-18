//
//  EGBViewController.h
//  35UITableViewSearchHW
//
//  Created by Eduard Galchenko on 2/12/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGBViewController : UITableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortedTypeControl;

- (IBAction)actionControl:(UISegmentedControl *)sender;


@end

NS_ASSUME_NONNULL_END
