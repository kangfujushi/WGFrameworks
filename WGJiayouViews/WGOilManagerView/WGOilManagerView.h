//
//  WGOilManagerView.h
//  Jiayou
//
//  Created by 赵宁 on 2019/3/7.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGOilManagerView : UIView

+ (void)showOilManagerView:(NSString *)title Index:(NSInteger)index Price:(NSString *)price Size:(NSString *)size Block:(void(^)(NSDictionary *info))block;

@end

NS_ASSUME_NONNULL_END
