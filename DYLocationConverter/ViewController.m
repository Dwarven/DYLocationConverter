//
//  ViewController.m
//  DYLocationConverter
//
//  Created by Dwarven on 16/6/6.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "ViewController.h"
#import "DYLocationConverter.h"

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager * _manager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[CLLocationManager alloc]init];
    if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_manager requestAlwaysAuthorization];
    }
    
    if ([_manager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
        [_manager setAllowsBackgroundLocationUpdates:YES];
    }
    _manager.delegate = self;
    [_manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    CLLocationCoordinate2D wgsPt = newLocation.coordinate;
    CLLocationCoordinate2D gcjPt = [DYLocationConverter gcj02FromWgs84:wgsPt];
    CLLocationCoordinate2D bdPt = [DYLocationConverter bd09FromWgs84:wgsPt];
    _label.text = [NSString stringWithFormat:@"WGS84: \n %f,%f\n\nGCJ-02: \n %f,%f\n\nBD-09: \n %f,%f", wgsPt.latitude, wgsPt.longitude, gcjPt.latitude, gcjPt.longitude, bdPt.latitude, bdPt.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
