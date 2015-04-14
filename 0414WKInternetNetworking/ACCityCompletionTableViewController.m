//
//  ACCityTableViewController.m
//  0414WKInternetNetworking
//
//  Created by NEIL on 2015/4/14.
//  Copyright (c) 2015年 NEIL. All rights reserved.
//

#import "ACCityCompletionTableViewController.h"
#import "ACCityTableViewCell.h"

@interface ACCityCompletionTableViewController ()
@property (strong,nonatomic)NSMutableArray *Citydata;
@property (nonatomic, strong) UIRefreshControl *refreshLoadingControl;



@end

@implementation ACCityCompletionTableViewController



#define kOpenDataCityAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NkZBQ0E0MEEtNDU4Mi00NTI4LTkzMDgtRjBCQzUyQkEwODY4"

-(void)awakeFromNib{
    _Citydata = [[NSMutableArray alloc]init];
}


- (void)viewDidLoad {
    [super viewDidLoad];  
    [self prepareAPICall];
    
    
}


- (void)prepareAPICall {
    
    // Step 0. Prepare loading view.
    [self.refreshLoadingControl beginRefreshing];
    
    // Step 1. Prepare API URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOpenDataCityAPI] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    // Step 2. Use URL Connection so send async request call.
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Step 3. Handle call back
        
        // End of loading view
        [self.refreshLoadingControl endRefreshing];
        
        // Check if have error.
        if (!connectionError) {
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
            NSLog(@"Connection with: %@", connectionError);
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    cell.DistrictLabel.text = [_Citydata [indexPath.row] objectForKey:@"District"];
    cell.ContentLabel.text =[_Citydata [indexPath.row] objectForKey:@"Project Name"];
    cell.StageLabel.text =[_Citydata [indexPath.row] objectForKey:@"Stage of Urban Renewal"];

    
    return cell;
}



@end
