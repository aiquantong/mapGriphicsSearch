//
//  LocationDemoViewController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface LocationDemoViewController : UIViewController<BMKMapViewDelegate> {
	IBOutlet BMKMapView* _mapView;
}

@end
