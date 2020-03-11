//
//  MapPaintSearchViewController.h
//  BaiduMapApiDemo
//
//  Created by andy on 13-5-30.
//
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BMKMapPaint.h"
#import "BMKMapPaintView.h"
#import "MapPaintSearchView.h"


typedef NS_ENUM(NSInteger, MapSearchAreaType) {
    MapSearchRect = 0,
    MapSearchCircle = 1,
    MapSearchNoClosureArea = 2,
};


@interface MapPaintSearchViewController : UIViewController <BMKMapViewDelegate, MapPaintSearchDelegate>
{
    BMKMapView *mapView;
    BMKMapPaint *mapPaintOverplay;
    
    UIView *waitView;
    MapPaintSearchView *mapPaintSearchView;
    
    NSMutableArray *annotationArray;
}

@property (nonatomic, retain) UIView *waitView;
@property (nonatomic, retain) BMKMapPaint *mapPaintOverplay;

@property (nonatomic, retain) BMKMapView *mapView;
@property (nonatomic, retain) MapPaintSearchView *mapPaintSearchView;

@property (nonatomic, retain) NSMutableArray *annotationArray;

@end
