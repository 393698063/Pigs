//
//  CHCBaseAppDef.h
//  NewHopeForAgency
//
//  Created by HEcom-PC on 15/7/14.
//  Copyright (c) 2015年 Hecom. All rights reserved.
//


typedef void(^THC_VCActionCompletionBlock)(NSString *aDesc, BOOL isSucceed);
typedef void(^THC_ReqCompletionBlock)(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData);
