//
//  MapDetailViewController.m
//  segues
//
//  Created by Chris Chares on 8/28/14.
//  Copyright (c) 2014 eunoia. All rights reserved.
//

#import "MapDetailViewController.h"
#import <MapKit/MapKit.h>
#import "UIViewController+EmergentView.h"
#import "UIView+Explore.h"
#import "UIView+TouchJacker.h"

@interface MapDetailViewController ()

@property (weak, nonatomic) MKMapView *mapView;

@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView = (MKMapView *)self.emergentView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.view.superview logSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
