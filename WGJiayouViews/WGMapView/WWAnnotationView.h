//
//  WWAnnotationView.h
//  WKMapViewDemo
//
//  Created by 莫晓卉 on 2018/5/1.
//  Copyright © 2018年 莫晓卉. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WWAnnotationView : MKAnnotationView
@property (nonatomic, strong) UIButton *touchBtn;

- (void)show;

- (void)updateNewDistance:(CGFloat)newDistance;

@end
