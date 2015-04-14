//
//  ACDelegateTableViewController.m
//  0414WKInternetNetworking
//
//  Created by NEIL on 2015/4/14.
//  Copyright (c) 2015年 NEIL. All rights reserved.
//

#import "ACDelegateTableViewController.h"
#import "ACCityTableViewCell.h"
#import "NSDictionary+ACCheckNull.h"

@interface ACDelegateTableViewController ()<
NSURLConnectionDataDelegate>


@property (strong,nonatomic)NSMutableArray *Citydata;
@property (nonatomic, strong) UIRefreshControl *refreshLoadingControl;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ACDelegateTableViewController

#define kOpenDataCityAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NkZBQ0E0MEEtNDU4Mi00NTI4LTkzMDgtRjBCQzUyQkEwODY4"
-(void)awakeFromNib{
    _Citydata = [[NSMutableArray alloc]init];
    _responseData = [[NSMutableData alloc]init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareAPICall];
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)prepareAPICall {
    
    // Step 0. Prepare loading view.
  //  [self.refreshLoadingControl beginRefreshing];
    
    // Step 1. Prepare API URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOpenDataCityAPI]];
    
    // Step 2. Prepare URL Connection, with request from step 1. inside. Also setup delegate target.
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Step 3. Start connection call.
    [connection start];
    
    // Step 4. Clear response data
    [self.responseData setLength:0];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Remove loading view
 //   [self.refreshLoadingControl endRefreshing];
    
    NSError *e = nil;
    // Serialize from data to json object.
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.responseData options: NSJSONReadingMutableContainers error: &e];
    // Remove all previous data.
    [_Citydata removeAllObjects];
    
    // Add all data into info array.
    [_Citydata addObjectsFromArray:jsonArray];
    
    // Reload Table View.
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _Citydata.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citydatacell" forIndexPath:indexPath];
     NSDictionary *eachParkData = [_Citydata objectAtIndex:indexPath.row];
    if ([eachParkData Checknumber:@"District"]) {
        cell.DistrictLabel.text = [_Citydata [indexPath.row] objectForKey:@"District"];
    }
    
    if ([eachParkData Checknumber:@"Project Name"]) {
        cell.ContentLabel.text =[_Citydata [indexPath.row] objectForKey:@"Project Name"];
    }
    if ([eachParkData Checknumber:@"Stage of Urban Renewal"]) {
        cell.StageLabel.text =[_Citydata [indexPath.row] objectForKey:@"Stage of Urban Renewal"];
    }

    
    

    return cell;
}


@end
