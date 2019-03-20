//
//  WGPayView.h
//  Jiayou
//
//  Created by 赵宁 on 2019/1/21.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGPayView : UIView

+ (void)showPayView:(NSString *)title Price:(CGFloat)price Block:(void(^)(NSInteger selectIndex))block;

@end

NS_ASSUME_NONNULL_END
