//
//  YxzLiveVideoContainerView.h
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/26.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXZConstant.h"
NS_ASSUME_NONNULL_BEGIN

//外层界面
@protocol LiveRoomOutPageDelegate <NSObject>

-(void)zoomRotatStyle:(YxzLiveVideoScreenStyle)style;

@end


@interface YxzLiveVideoContainerView : UIView
@property(nonatomic,weak)id<LiveRoomOutPageDelegate> delegate;
@property(nonatomic,strong)UIView *videoContainerView;
@end

NS_ASSUME_NONNULL_END
