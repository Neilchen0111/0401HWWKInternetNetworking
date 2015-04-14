//
//  ACSessionTableViewController.m
//  0414WKInternetNetworking
//
//  Created by NEIL on 2015/4/14.
//  Copyright (c) 2015年 NEIL. All rights reserved.
//

#import "ACSessionTableViewController.h"
#import "ACCityTableViewCell.h"
#import "NSDictionary+ACCheckNull.h"

@interface ACSessionTableViewController ()


@property (strong,nonatomic)NSMutableArray *Citydata;

@end

@implementation ACSessionTableViewController

#define kOpenDataCityAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NkZBQ0E0MEEtNDU4Mi00NTI4LTkzMDgtRjBCQzUyQkEwODY4"

-(void)awakeFromNib{
    _Citydata = [[NSMutableArray alloc]init];
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
//    [self.refreshLoadingControl beginRefreshing];
    
    // Step 1. Prepare session
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Step 2. Setup session with task url.
    NSURLSessionDataTask * sessionDataTask = [session dataTaskWithURL:[NSURL URLWithString:kOpenDataCityAPI]
                                                    completionHandler:^(NSData *data,
                                                                        NSURLResponse *response,
                                                                        NSError *error) {
                                                        
                                                        // Step 3. Handle call back
                                                        
                                                        // End of loading view
//                                                        [self.refreshLoadingControl endRefreshing];
                                                        
                                                        // Check if have error.
                                                        if (!error) {
                                                            NSError *jsonSerializationError;
                                                            
                                                            // Serialize data into JSONObject.
                                                            id unknowObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonSerializationError];
                                                            
                                                            if ([unknowObject isKindOfClass:[NSArray class]]) {
                                                                NSArray *jsonArray = unknowObject;
                                                                
                                                                // Remove all previous data.
                                                                [_Citydata removeAllObjects];
                                                                
                                                                // Add all data into info array.
                                                                [_Citydata addObjectsFromArray:jsonArray];
                                                                
                                                                // Reload Table View.
                                                                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                            }
                                                            
                                                            
                                                        } else {
                                                            NSLog(@"Connection with: %@", error);
                                                        }
                                                        
                                                    }];
    [sessionDataTask resume];
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
