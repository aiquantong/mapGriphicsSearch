//
//  BMKMapPaintView.h
//  BaiduMapApiDemo
//
//  Created by andy on 13-6-3.
//
//

#import <Foundation/Foundation.h>
#import "BMKMapPaint.h"
#import "BMKOverlayPathView.h"
#import "BMKMapView.h"


@interface BMKMapPaintView : BMKOverlayPathView
{
   BMKMapPaint *mapPaint;
    BMKMapView *mapView;
    UIImageView *imageView;
}

@property (nonatomic, retain) BMKMapPaint *mapPaint;
@property (nonatomic, retain) BMKMapView *mapView;
@property (nonatomic, retain) UIImageView *imageView;
/**
 *@return 生成的View
 */
- (id)initWithMapPaint:(BMKMapPaint *)_mapPaint mapView:(BMKMapView *)_mapView;

@end
