//
//  LivePlayerController.h
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXLiteAVSDK_Professional/TXLivePlayer.h"
//#import "TXLiteAVSDK_Professional/TXLivePlayListener.h"

@interface LivePlayerController : NSObject
@property(nonatomic,strong,readonly)TXLivePlayer *livePlayer;
-(void)setPlayerViewToContainerView:(UIView *)containerView;
-(void)play:(NSString *)playUrlStr;
-(void)stop;
@end


