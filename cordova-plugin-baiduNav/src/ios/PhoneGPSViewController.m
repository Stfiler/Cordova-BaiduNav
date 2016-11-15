//
//  PhoneGPSViewController.m
//  example
//
//  Created by xudesong on 16/9/22.
//
//

#import "PhoneGPSViewController.h"

#import "BNCoreServices.h"
#import "BNRoutePlanModel.h"

@interface PhoneGPSViewController ()<BNNaviRoutePlanDelegate, BNNaviUIManagerDelegate>

@end

@implementation PhoneGPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavOptions];
    
    //  设置白天黑夜模式
    [BNCoreServices_Strategy setDayNightType: BNDayNight_CFG_Type_Auto];
    
    //assign your coordinate
    CLLocationCoordinate2D wgs84llCoordinate;
    
    //the coordinate in bd09standard ,which can be used to show poi on baidu map
    CLLocationCoordinate2D bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
}


#pragma mark -Navigation
- (void)setNavOptions
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"手机GPS导航";
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle: @"开始导航" style: UIBarButtonItemStylePlain target: self action: @selector(btnAction)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
}

#pragma mark -检验导航引擎
- (BOOL)checkServiceEngine
{
    if (![BNCoreServices_Instance isServicesInited]) {
        NSLog(@"引擎初始化失败");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"提示" message: @"引擎初始化失败，请稍后重试" delegate: nil cancelButtonTitle: @"我知道了" otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    
    NSLog(@"引擎初始化成功");
    return YES;
}

#pragma mark -触发方法
- (void)btnAction
{
    if ([self checkServiceEngine]) {
        [self startNav];
    }
}

- (void)startNav
{
    //获取最后一次定位的位置
    CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    
    NSLog(@"当前经度: %f",myLocation.coordinate.longitude);
    NSLog(@"当前纬度: %f",myLocation.coordinate.latitude);
    
    
    
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = 113.948222;
    startNode.pos.y = 22.549555;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    
    NSMutableArray *nodesArray = [[NSMutableArray alloc] init];
    [nodesArray addObject: startNode];
    
    //也可以添加途经点
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = 114.089863;
    endNode.pos.y = 22.546236;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    //发起算路
    [BNCoreServices_RoutePlan startNaviRoutePlan: BNRoutePlanMode_Recommend naviNodes: nodesArray time: nil delegete: self userInfo: nil];
}


#pragma mark -BNNaviRoutePlanDelegate
/**
 *  算路成功回调
 *
 *  @param userInfo 用户信息
 */
- (void)routePlanDidFinished:(NSDictionary*)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage: BNaviUI_NormalNavi delegate: self extParams: nil];
}

/**
 *  检索成功回调
 *
 *  @param userInfo 用户信息
 */
- (void)searchDidFinished:(NSDictionary*)userInfo
{
    NSLog(@"索引成功");
}

/**
 *  算路失败回调
 *
 *  @param error    失败信息
 *  @param userInfo 用户信息
 */
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"起终点距离起终点太近");
            break;
        default:
            NSLog(@"算路失败");
            break;
    }
}


/**
 *  算路取消
 *
 *  @param userInfo 用户信息
 */
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo
{
    NSLog(@"算路取消");
}

/**
 *  更新路况成功回调
 *
 *  @param pbData pb数据
 */
- (void)updateRoadConditionDidFinished:(NSData *)pbData
{
    
}

/**
 *  更新路况成功失败
 *
 *  @param pbData pb数据
 */
- (void)updateRoadConditionFailed:(NSData *)pbData
{
    
}



#pragma mark -BNNaviUIManagerDelegate
/**
 *  退出UI的回调
 *
 *  @param pageType  UI类型
 *  @param extraInfo 额外参数
 */
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi) {
        NSLog(@"退出导航页面");
    } else if (pageType == BNaviUI_Declaration) {
        NSLog(@"退出导航声明页面");
    }
}


#pragma mark -不允许屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
