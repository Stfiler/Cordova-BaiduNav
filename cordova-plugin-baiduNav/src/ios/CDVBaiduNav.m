//
//  CDVBaiduNav.m
//  example
//
//  Created by xudesong on 16/9/22.
//
//

#import "CDVBaiduNav.h"
#import "PhoneGPSViewController.h"


@implementation CDVBaiduNav

- (void)initBaiDuNav: (CDVInvokedUrlCommand *)command
{
    NSLog(@"成功到原生环境: %@",[command.arguments objectAtIndex: 0]);
    //  将传入的参数传给百度导航需要的参数
    
    //  百度原生地图导航需要的参数是[出发点以及目的经纬度]
    
        // 在Appdelegate中初始化导航SDK
//    [BNCoreServices_Instance initServices: @"appkey"];
//    [BNCoreServices_Instance startServicesAsyn: nil fail: nil];
    
    PhoneGPSViewController *gpsVC = [[PhoneGPSViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: gpsVC];
    [self.viewController presentViewController: nav animated: NO completion: nil];
}

@end
