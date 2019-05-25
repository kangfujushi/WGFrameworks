//
//  YSHtmlEditBaseVCtrl.m
//  ArTreePro
//
//  Created by niexiaobo on 2019/1/16.
//  Copyright © 2019 . All rights reserved.
//

#import "YSHtmlEditBaseVCtrl.h"
#import "WGCommon.h"
//#import "HXPhotoPicker.h"
//#import "HXAlbumListViewController.h"
#define kEditorURL @"richText_editor"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WGImagePickerController/WGImagePickerController.h>

//#define kEditorURL @"z-test"
@interface YSHtmlEditBaseVCtrl ()<UITextViewDelegate, UIWebViewDelegate,
KWEditorBarDelegate, KWFontStyleBarDelegate,
UIAlertViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, assign) BOOL isExitView;

@property(nonatomic, copy) NSString *tempArticleID;

@property(nonatomic, copy) NSString *tempTitle;
@property(nonatomic, copy) NSString *tempContent;

@property(nonatomic, assign) BOOL isLoadFinsh;
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) KWEditorBar *toolBarView;
@property(nonatomic, strong) KWFontStyleBar *fontBar;
//@property(nonatomic, strong) HXPhotoManager *manager;
//@property(nonatomic, strong) HXPhotoView *photoView;

@property(nonatomic, assign) BOOL showHtml;

@property(nonatomic, assign) CGFloat keyboardHeight;  //键盘高度
@property(nonatomic, assign) BOOL showFontBar;  //是否显示设置字体bar
/**
 *  存放所有正在上传及失败的图片model
 */
@property(nonatomic, strong) NSMutableArray *uploadPics;
@property(nonatomic,strong)void (^block)(NSString *);//回调

@end

@implementation YSHtmlEditBaseVCtrl
- (NSMutableArray *)uploadPics {
    if (!_uploadPics) {
        _uploadPics = [NSMutableArray array];
    }
    return _uploadPics;
}
- (KWEditorBar *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [KWEditorBar editorBar];
        _toolBarView.frame =
        CGRectMake(0, SCREEN_HEIGHT-80-52-SCREEN_B_0-KWEditorBar_Height/2,
                   self.view.frame.size.width, KWEditorBar_Height);
        _toolBarView.backgroundColor = COLOR(237, 237, 237, 1);
        _toolBarView.hidden = YES;
    }
    return _toolBarView;
}
- (KWFontStyleBar *)fontBar {
    if (!_fontBar) {
        _fontBar = [[KWFontStyleBar alloc]
                    initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame) -
                                             KWFontBar_Height - KWEditorBar_Height,
                                             self.view.frame.size.width, KWFontBar_Height)];
        _fontBar.delegate = self;
        _fontBar.hidden = YES;
        [_fontBar.heading2Item setSelected:YES];
    }
    return _fontBar;
}
- (UIWebView *)webView {
    if (!_webView) {
        //获取已经初始化完成的webView
        _webView = [WGUIWebViewPool sharedInstance].webView;
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *htmlPath =
        [[NSBundle mainBundle] pathForResource:kEditorURL ofType:@"html"];
        NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        [_webView loadHTMLString:htmlCont baseURL:baseURL];
        _webView.scrollView.bounces = NO;
        _webView.hidesInputAccessoryView = YES;
        //_webView.detectsPhoneNumbers = NO;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// config
    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolBarView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardWillShowFrame:)
     name:UIKeyboardWillShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardDidShowFrame:)
     name:UIKeyboardDidShowNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardWillChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardWillHideFrame:)
     name:UIKeyboardWillHideNotification
     object:nil];
    self.toolBarView.delegate = self;
    [self.toolBarView
     addObserver:self
     forKeyPath:@"transform"
     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
     context:nil];
    
    self.title = @"文章编辑";
    //[self AddLeftItem:YES rightItem:NO];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"HTML"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(getHTMLText)];
}

+ (instancetype)alloc:(void(^)(NSString *content))block {
    YSHtmlEditBaseVCtrl *vc = [[YSHtmlEditBaseVCtrl alloc] init];
    vc.block = block;
    return vc;
}

#pragma mark - 导出html
- (NSString *)getHTMLText {
    __block NSString *htmlStr = [self.webView contentHtmlText];
    //过滤掉无效视图
    NSString *divReg = @"<div[^>]*>.*?</div>";
    NSArray *divArray = [self matchString:htmlStr toRegexString:divReg];
    if (divArray.count > 0) {
        [divArray enumerateObjectsUsingBlock:^(
                                               NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (obj.length > 0 && [obj containsString:@"class=\"real-img-f-div\""]) {
                NSString *imgReg = @"<img[^>]*>";
                NSArray *imgArray = [self matchString:obj toRegexString:imgReg];
                [imgArray
                 enumerateObjectsUsingBlock:^(NSString *_Nonnull obj2,
                                              NSUInteger idx, BOOL *_Nonnull stop) {
                     if (obj2.length > 0 &&
                         ![obj2 containsString:@"class=\"real-img-delete\""]) {
                         //删除id
                         NSString *imgIDReg = @"id=\".*?\"";
                         NSString *imgStr = [self matchReplaceHtmlString:obj2
                                                             RegexString:imgIDReg
                                                              withString:@""];
                         htmlStr = [htmlStr stringByReplacingOccurrencesOfString:obj
                                                                      withString:imgStr];
                     }
                 }];
            }
        }];
    }
    //导出结果
    NSLog(@"%@", htmlStr);
    return htmlStr;
}

- (void)reset {
    
}

#pragma mark - 正则匹配
- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr {
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexStr
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    // match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
        }
    }
    return array;
}

/**
 :正则替换
 */
- (NSString *)matchReplaceHtmlString:(NSString *)string
                         RegexString:(NSString *)regexStr
                          withString:(NSString *)replaceStr {
    if (!string || string.length == 0 || regexStr.length == 0 ||
        replaceStr.length == 0) {
        return string;
    }
    
    NSRegularExpression *regularExpretion =
    [NSRegularExpression regularExpressionWithPattern:regexStr
                                              options:0
                                                error:nil];
    string = [regularExpretion
              stringByReplacingMatchesInString:string
              options:NSMatchingReportProgress
              range:NSMakeRange(0, string.length)
              withTemplate:replaceStr];
    
    return string;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"transform"]) {
        CGRect fontBarFrame = self.fontBar.frame;
        fontBarFrame.origin.y = CGRectGetMaxY(self.toolBarView.frame) -
        KWFontBar_Height - KWEditorBar_Height;
        self.fontBar.frame = fontBarFrame;
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                   self.view.frame.size.height);
}

#pragma mark -webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //需要引入头文件 : @import JavaScriptCore;
    WS(weakSelf)
    JSContext *ctx = [webView
                      valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    ctx[@"contentUpdateCallback"] = ^(JSValue *msg) {
        [weakSelf.webView autoScrollTop:[weakSelf.webView getCaretYPosition] -
         [weakSelf editKeyboardHeight] + 60];
    };
    [ctx evaluateScript:@"document.getElementById('article_content')."
     @"addEventListener('input', contentUpdateCallback, "
     @"false);"];
}

- (CGFloat)editKeyboardHeight {
    CGFloat keyBH = self.keyboardHeight + KWEditorBar_Height;
    CGFloat datH =
    IS_IPhoneX ? (self.showFontBar ? 55 : 0) : (self.showFontBar ? 75 : 30);
    return SCREEN_HEIGHT - keyBH - SCREEN_Y - KWEditorBar_Height - datH;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"NSError = %@", error);
    
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
}
//获取IMG标签
- (NSArray *)getImgTags:(NSString *)htmlText {
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regulaStr
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray *arrayOfAllMatches =
    [regex matchesInString:htmlText
                   options:0
                     range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"loadURL = %@", urlString);
    
    [self handleEvent:urlString];
    
    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className =
        [urlString stringByReplacingOccurrencesOfString:@"re-state-content://"
                                             withString:@""];
        
        [self.fontBar updateFontBarWithButtonName:className];
        
        if ([self.webView contentText].length <= 0) {
            [self.webView showContentPlaceholder];
            if ([self getImgTags:[self.webView contentHtmlText]].count > 0) {
                [self.webView clearContentPlaceholder];
            }
        } else {
            [self.webView clearContentPlaceholder];
        }
        
        if ([[className componentsSeparatedByString:@","]
             containsObject:@"unorderedList"]) {
            [self.webView clearContentPlaceholder];
        }
    }
    
    [self handleWithString:urlString];
    return YES;
}
#pragma mar - webView监听处理事件
- (void)handleEvent:(NSString *)urlString {
    if ([urlString hasPrefix:@"re-state-content://"]) {
        //        self.fontBar.hidden = NO;
        //        self.toolBarView.hidden = NO;
        if ([self.webView contentText].length <= 0) {
            [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    if ([urlString hasPrefix:@"re-state-title://"]) {
        self.fontBar.hidden = YES;
        self.toolBarView.hidden = YES;
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
    @try {
        [self.toolBarView removeObserver:self forKeyPath:@"transform"];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        // Added to show finally works as well
    }
    self.timer = nil;
}

/**
 *  是否显示占位文字
 */
- (void)isShowPlaceholder {
    if ([self.webView contentText].length <= 0) {
        [self.webView showContentPlaceholder];
    } else {
        [self.webView clearContentPlaceholder];
    }
}

#pragma mark -editorbarDelegate
- (void)editorBar:(KWEditorBar *)editorBar
    didClickIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //显示或隐藏键盘
            if (self.toolBarView.transform.ty < 0) {
                [self.webView hiddenKeyboard];
            } else {
                [self.webView showKeyboardContent];
            }
            
        } break;
        case 1: {
            //回退
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"document.execCommand('undo')"];
        } break;
        case 2: {
            [self.webView stringByEvaluatingJavaScriptFromString:
             @"document.execCommand('redo')"];
        } break;
        case 3: {
            //显示更多区域
            editorBar.fontButton.selected = !editorBar.fontButton.selected;
            if (editorBar.fontButton.selected) {
                [self.view addSubview:self.fontBar];
                self.showFontBar = YES;
            } else {
                [self.fontBar removeFromSuperview];
                self.showFontBar = NO;
            }
        } break;
        case 4: {//超链接
            [self hyperLink];
            //插入地址
            //[self.webView insertLinkUrl:@"https://www.baidu.com/" title:@"百度"
            //content:@"百度一下"];
        } break;
        case 5: {
            
            //插入图片
            if (!self.toolBarView.keyboardButton.selected) {
                [self.webView showKeyboardContent];
                dispatch_after(
                               dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   [self showPhotos];
                               });
            } else {
                [self showPhotos];
            }
        } break;
        default:
            break;
    }
}

/**
 :插入超链接
 */
- (void)hyperLink {
    //[self.webView hiddenKeyboard];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加链接" message:@"请输入链接名称和地址" preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入名称";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"链接地址:http";
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTextField = alertController.textFields.firstObject;
        UITextField *addrTextField = alertController.textFields.lastObject;
        if (nameTextField.text.length > 0 && addrTextField.text.length > 0) {
            [self.webView insertLinkUrl:addrTextField.text title:nameTextField.text content:nameTextField.text];
            [self.webView showKeyboardContent];
        } else {
            //输入信息不全
        }
        
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - fontbardelegate
- (void)fontBar:(KWFontStyleBar *)fontBar didClickBtn:(UIButton *)button {
    if (self.toolBarView.transform.ty >= 0) {
        [self.webView showKeyboardContent];
    }
    switch (button.tag) {
        case 0: {
            //粗体
            [self.webView bold];
        } break;
        case 1: {  //下划线
            [self.webView underline];
        } break;
        case 2: {  //斜体
            [self.webView italic];
        } break;
        case 3: {  // 14号字体
            [self.webView setFontSize:@"2"];
        } break;
        case 4: {  // 16号字体
            [self.webView setFontSize:@"3"];
        } break;
        case 5: {  // 18号字体
            [self.webView setFontSize:@"4"];
        } break;
        case 6: {  //左对齐
            [self.webView justifyLeft];
        } break;
        case 7: {  //居中对齐
            [self.webView justifyCenter];
        } break;
        case 8: {  //右对齐
            [self.webView justifyRight];
        } break;
        case 9: {  //无序
            [self.webView unorderlist];
        } break;
        case 10: {
            //缩进
            button.selected = !button.selected;
            if (button.selected) {
                [self.webView indent];
            } else {
                [self.webView outdent];
            }
        } break;
        case 11: {
        } break;
        default:
            break;
    }
}
- (void)fontBarResetNormalFontSize {
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.webView normalFontSize];
                   });
}

#pragma mark -keyboard
- (void)keyBoardWillShowFrame:(NSNotification *)notification {
    self.fontBar.hidden = NO;
    self.toolBarView.hidden = NO;
}

- (void)keyBoardDidShowFrame:(NSNotification *)notification {
    //重新定位光标位置
    /*
     getCaretYPosition方法有时候
     */
    [self.webView autoScrollTop:[self.webView getCaretYPosition] -
     [self editKeyboardHeight]];
}

- (void)keyBoardWillHideFrame:(NSNotification *)notification {
    self.fontBar.hidden = YES;
    self.toolBarView.hidden = YES;
}

- (void)keyBoardWillChangeFrame:(NSNotification *)notification {
    CGRect frame =
    [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.keyboardHeight < 10) {
        self.keyboardHeight = frame.size.height;
    }
    
    CGFloat duration =
    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]
     doubleValue];
    if (frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:duration
                         animations:^{
                             self.toolBarView.transform = CGAffineTransformIdentity;
                             self.toolBarView.keyboardButton.selected = NO;
                         }];
    } else {
        [UIView
         animateWithDuration:duration
         animations:^{
             self.toolBarView.transform =
             CGAffineTransformMakeTranslation(0, -frame.size.height);
             self.toolBarView.keyboardButton.selected = YES;
             
         }];
    }
}

#pragma mark -图片点击操作
- (BOOL)handleWithString:(NSString *)urlString {
    //点击的图片标记URL（自定义）
    NSString *preStr = @"protocol://iOS?code=uploadResult&data=";
    
    if ([urlString hasPrefix:preStr]) {
        
        if (!self.toolBarView.keyboardButton.selected) {
            [self.webView showKeyboardContent];
        }
        
        NSString *result =
        [urlString stringByReplacingOccurrencesOfString:preStr withString:@" "];
        
        NSString *jsonString = [result
                                stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        
        NSDictionary *dict =
        [NSJSONSerialization JSONObjectWithData:jsonData
                                        options:NSJSONReadingMutableContainers
                                          error:&err];
        
        NSString *meg =
        [NSString stringWithFormat:@"上传的图片ID为%@", dict[@"imgId"]];
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:meg
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        
        //上传状态 - 默认上传成功
        BOOL uploadState = YES;
        
        for (WGUploadPictureModel *upPic in self.uploadPics) {
            if (upPic.type == WGUploadImageModelTypeError) {
                //上传失败的
                uploadState = false;
            }
        }
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:uploadState ? @"删除图片" : @"重新上传"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *_Nonnull action) {
                                 //根据自身业务需要处理图片操作：如删除、重新上传图片操作等
                                 if (uploadState) {
                                     //例如删除图片执行函数imgID=key;
                                     [self.webView deleteImageKey:dict[@"imgId"]];
                                 } else {
                                     //见387行代码 上传片段 。。。
                                     for (WGUploadPictureModel *uploadM in self.uploadPics) {
                                         if (uploadM.type == WGUploadImageModelTypeError) {
                                             NSString *picUrl = @"http://pic27.nipic.com/20130225/"
                                             @"4746571_081826094000_2.jpg";
                                             [self.webView inserImageKey:uploadM.key progress:1];
                                             // BOOL error = false; //上传成功样式
                                             [self.webView inserSuccessImageKey:uploadM.key
                                                                         imgUrl:picUrl];
                                             uploadM.type = WGUploadImageModelTypeError;
                                             if ([self.uploadPics containsObject:uploadM]) {
                                                 [self.uploadPics removeObject:uploadM];
                                             }
                                             [self.webView setupEditEnable:YES];  //恢复可编辑状态
                                             //                                [self.webView
                                             //                                showKeyboardContent];
                                             [self.webView hiddenKeyboard];
                                             //                            }
                                             //                        }];
                                         }
                                     }
                                 }
                             }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"取消"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self.webView setupEditEnable:YES];  //恢复可编辑状态
                                     [self.webView hiddenKeyboard];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        [self.webView setupEditEnable:YES];  //恢复可编辑状态
    }
    return YES;
}

#pragma mark -图片选择器
- (void)showPhotos {
    
    [WGImagePickerController manyImagePicker:self Count:9 Block:^(NSArray * _Nonnull images) {
        NSArray * photoList = images;
        if (photoList.count > 0) {
            for (int i = 0; i < photoList.count; i++) {
                WGUploadPictureModel *uploadM = [[WGUploadPictureModel alloc] init];
                uploadM.image = images[i];
                uploadM.key = [NSString uuid];
                uploadM.imageData = UIImageJPEGRepresentation(images[i], 0.8f);
                
                // 1、插入本地图片
                [self.webView inserImage:uploadM.imageData key:uploadM.key];
                
//                [[LXHTTPClient shareHTTPClient] POST:@"/api/erp/file/uploadpicture" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                    if (uploadM.imageData) {
//                        NSString *fileName=@"file.png";
//                        [formData appendPartWithFileData:uploadM.imageData name:@"attachment" fileName:fileName mimeType:@"image/jpeg"];
//                    }
//                } progress:^(NSProgress * _Nonnull uploadProgress) {
//                    // 2、模拟网络请求上传图片 更新进度
//                    dis_main(^{
//                        [self.webView inserImageKey:uploadM.key progress:uploadProgress.localizedDescription.floatValue/100.];
//                    });
//                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSString *picUrl = responseObject[@"realPath"];
//                    [self.webView inserImageKey:uploadM.key progress:1];
//                    // BOOL error = false; //上传成功样式
//                    [self.webView inserSuccessImageKey:uploadM.key imgUrl:picUrl];
//                    uploadM.type = WGUploadImageModelTypeError;
//                    if ([self.uploadPics containsObject:uploadM]) {
//                        [self.uploadPics removeObject:uploadM];
//                    }
//                    [self.webView setupEditEnable:YES];  //恢复可编辑状态
//                    //[self.webView showKeyboardContent];
//                    [self.webView hiddenKeyboard];
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    [LXProgressHUD error:@"图片上传失败"];
//                }];
            }
        }
    }];
}

@end
