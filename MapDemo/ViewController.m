//
//  ViewController.m
//  MapDemo
//
//  Created by 张玥 on 2019/1/30.
//  Copyright © 2019 张玥. All rights reserved.
//

#import "ViewController.h"
#import <BMKLocationKit/BMKLocationComponent.h>


@interface ViewController ()<BMKLocationManagerDelegate>
@property(nonatomic, strong) BMKLocationManager *locationManager;
//@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;
@property (weak, nonatomic) IBOutlet UILabel *LocLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoc];
}

//初始化
-(void)initLoc {
    _locationManager = [[BMKLocationManager alloc] init];
    _locationManager.delegate = self;
    
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
    
}

//点击获取定位结果
-(IBAction)getLoc:(id)sender {
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        //得到定位信息
        if (location) {
            if (location.location) {
                NSLog(@"当前位置信息： \n经度：%.6f,纬度%.6f ",location.location.coordinate.latitude, location.location.coordinate.longitude);
            }
            if (location.rgcData) {
                NSLog(@"城市 = %@",location.rgcData.province);
                NSLog(@"区镇 = %@",location.rgcData.district);
                NSLog(@"街道 = %@",location.rgcData.street);
                NSLog(@"街道号 = %@",location.rgcData.streetNumber);
                NSLog(@"具体描述 = %@",location.rgcData.locationDescribe);
                
                self.LocLabel.text =[NSString stringWithFormat:@"定位地址：%@%@%@%@%@", location.rgcData.province, location.rgcData.district, location.rgcData.street,location.rgcData.streetNumber,location.rgcData.locationDescribe];
            }
        }
        //判断网络
        if (state==0) {
            NSLog(@"无网络");
        }
        else if (state==1) {
            NSLog(@"有网络");
        }
    }];
}


@end
