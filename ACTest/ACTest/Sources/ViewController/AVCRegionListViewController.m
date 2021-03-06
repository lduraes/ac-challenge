//
//  AVCRegionListViewController.m
//  ACTest
//
//  Created by Luiz Duraes on 3/12/16.
//  Copyright © 2016 Mob4U IT Solutions. All rights reserved.
//

#import "AVCRegionListViewController.h"
#import "AVCGMapItem+AVCBusiness.h"
#import "AVCMapViewController.h"
#import "SVProgressHUD.h"
#import "UIView+AVCExtensions.h"

static CGFloat const kRegionCellHeight = 44.0;
static NSString *const kSegueRegionListToMap = @"segueRegionListToMap";
static NSString *const kRegionCell = @"regionCell";

typedef NS_ENUM(NSInteger, TableViewSection) {
     TableViewSectionAll = 1
    ,TableViewSectionRecords
};

@interface AVCRegionListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) NSArray *arrayItems;
@property (strong, nonatomic) NSMutableArray *arraySelectedItems;

@end

@implementation AVCRegionListViewController

#pragma mark - Private

-(void)clearTableViewRecords {
    NSString *searchString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(searchString.length == 0) {
        [self loadTableViewWithArrayItems:@[@[], @[]]];
        [self.tableView hideViewNoRecordsFound];
    }
}

-(void)configComponents {
    [self.searchBar becomeFirstResponder];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)loadTableViewWithArrayItems:(NSArray *)arrayItems {
    [self setArrayItems:arrayItems];
    [self.tableView reloadData];
    
    if([self.arrayItems[TableViewSectionAll] count] == 0) {
        [self.tableView showViewNoRecordsFound];
    }
}

-(void)performSearch {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"infMsgLoadingRecords", nil)];
    
    [AVCGMapItem searchAddress:self.searchBar.text withCompletionHandler:^(NSArray *arrayItems, NSError *error) {
        [SVProgressHUD dismiss];
        if(error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        [weakSelf loadTableViewWithArrayItems:arrayItems];
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayItems[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *regionCell = [tableView dequeueReusableCellWithIdentifier:kRegionCell forIndexPath:indexPath];
    AVCGMapItem *item = (self.arrayItems.count > 1) ? self.arrayItems[indexPath.section][indexPath.row] : self.arrayItems[indexPath.row];
    [regionCell.textLabel setText:item.address];
    
    return regionCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setArraySelectedItems:[NSMutableArray array]];
    
    if(indexPath.section == TableViewSectionRecords) {          // just an item
        AVCGMapItem *item = (AVCGMapItem *)self.arrayItems[indexPath.section][indexPath.row];
        [self.arraySelectedItems addObject:item];
    } else {
        if(self.arrayItems.count > 2) {                         // table with display all on map & other items
            [self setArraySelectedItems:self.arrayItems[TableViewSectionRecords]];
        } else {                                                // table with just one item
            [self setArraySelectedItems:self.arrayItems[TableViewSectionAll]];
        }
    }
    
    [self performSegueWithIdentifier:kSegueRegionListToMap sender:self];
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRegionCellHeight;
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self performSearch];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self clearTableViewRecords];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self clearTableViewRecords];
}

#pragma mark - Override

-(void)viewDidLoad {
    [super viewDidLoad];
    [self configComponents];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender {
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    AVCMapViewController *mapViewController = (AVCMapViewController *)segue.destinationViewController;
    [mapViewController setArrayItems:self.arraySelectedItems];
}

@end
