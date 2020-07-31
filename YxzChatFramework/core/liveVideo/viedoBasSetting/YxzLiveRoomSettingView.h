//
//  YxzLiveRoomSettingView.h
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/30.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomSettingModel : NSObject
@property(nonatomic,copy)NSString *logImg;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;
@end

@interface LiveRoomSettingCell : UITableViewCell
@property(nonatomic,strong)RoomSettingModel *settingModel;
@end


@interface YxzLiveRoomSettingView : UIView
@property(nonatomic,strong)NSMutableArray<RoomSettingModel *> *dataSouce;
-(void)setPlayRate:(NSString *)playRate sharpness:(NSString *)sharpness;
@end



