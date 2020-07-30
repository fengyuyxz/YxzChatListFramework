//
//  FirstVC.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "FirstVC.h"
#import "RoomBaseInfo.h"
#import "YxzChatController.h"
@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    // Do any additional setup after loading the view.
}
- (IBAction)pushRoom:(id)sender {
    RoomBaseInfo *info=[[RoomBaseInfo alloc]init];
    info.payLiveUrl=@"http://200024424.vod.myqcloud.com/200024424_810ea00ebdf811e6ad39991f76a4df69.f30.mp4";
    YxzChatController *vc=[[YxzChatController alloc]init];
    vc.modalPresentationStyle=UIModalPresentationFullScreen;
    vc.roomBaseInfo=info;
    
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
