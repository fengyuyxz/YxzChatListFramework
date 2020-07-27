//
//  YxzLiveVideoSuspensionView.h
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomBaseInfo.h"
#import "YXZConstant.h"
#import "YxzChatController.h"
NS_ASSUME_NONNULL_BEGIN
//外层界面
@protocol LiveRoomOutPageDelegate <NSObject>

-(void)zoomRotatStyle:(YxzLiveVideoScreenStyle)style;

@end


@interface YxzLiveVideoSuspensionView : UIView
@property(nonatomic,weak)UIViewController *parentController;
@property(nonatomic,strong)YxzChatController *chatController;
@property(nonatomic,weak)id<LiveRoomOutPageDelegate> delegate;

-(void)showSuspension;
@end

NS_ASSUME_NONNULL_END
