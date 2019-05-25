//
//  WGWebView.h
//  Jiayou
//
//  Created by 赵宁 on 2019/3/11.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGWebView : UIView

- (void)loadHTMLString:(NSString *)htmlStr;
- (void)loadHTMLUrl:(NSString *)url;

- (void)webViewBackgroundColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
