//
//  WGWebView.m
//  Jiayou
//
//  Created by 赵宁 on 2019/3/11.
//  Copyright © 2019 赵宁. All rights reserved.
//

#import "WGWebView.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface WGWebView ()<WKNavigationDelegate>

@property (nonatomic ,strong) WKWebView *webView;

@end

@implementation WGWebView

- (void)awakeFromNib {
    [super awakeFromNib];
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _webView.scrollView.showsVerticalScrollIndicator   = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
}

- (instancetype)init {
    self = [super init];
    [self awakeFromNib];
    return self;
}

- (void)loadHTMLString:(NSString *)htmlStr {
    if (htmlStr) {
        [_webView loadHTMLString:[[NSString stringWithFormat:@"<body width=%fpx style=\"word-wrap:break-word; font-family:Arial\">",[UIScreen mainScreen].bounds.size.width-16] stringByAppendingString:[self HTMLPercentEscapeString:htmlStr]] baseURL:[NSURL URLWithString:@""]];
    }
}

- (NSString *)HTMLPercentEscapeString:(NSString *)url {
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    return [headerString stringByAppendingString:url];
}

- (void)loadHTMLUrl:(NSString *)url {
    if (url) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (void)webViewBackgroundColor:(UIColor *)color {
    self.webView.scrollView.backgroundColor = color;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType != WKNavigationTypeOther) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [ webView evaluateJavaScript:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                  "script.type = 'text/javascript';"
                                  "script.text = \"function ResizeImages() { "
                                  "var myimg,oldwidth;"
                                  "var maxwidth = %f;" // WKWebView中显示的图片宽度
                                  "for(i=0;i <document.images.length;i++){"
                                  "myimg = document.images[i];"
                                  "oldwidth = myimg.width;"
                                  "if (oldwidth > maxwidth) {myimg.width = maxwidth;}"
                                  "}"
                                  "}\";"
                                  "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();",[UIScreen mainScreen].bounds.size.width-16] completionHandler:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.zoom=%lf",[UIScreen mainScreen].bounds.size.width/webView.scrollView.contentSize.width-0.00001]];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.textAlign = 'center';"];
}

@end
