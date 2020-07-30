//
//  YxzChatCompleteComponent.h
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YxzChatCompleteComponent : UIView
typedef void(^HiddenKeyboardAndFaceViewCompletion)(void);
-(void)hiddenTheKeyboardAndFace:(HiddenKeyboardAndFaceViewCompletion)block;
@end

NS_ASSUME_NONNULL_END
