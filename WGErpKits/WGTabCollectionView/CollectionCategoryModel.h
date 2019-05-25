//
//  CategoryModel.h
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import <Foundation/Foundation.h>

@interface CollectionCategoryModel : NSObject

@property (nonatomic, copy) NSString *menu_name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSArray *menus;
@property (nonatomic, copy) NSString *menu_id;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSArray *subcategories;

@property (nonatomic, assign) BOOL isHeader;

@end

@interface SubCategoryModel : NSObject

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *menu_name;

@end
