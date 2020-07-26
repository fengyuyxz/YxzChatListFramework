//
//  YxzChatController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzChatController.h"
#import "YxzChatCompleteComponent.h"
#import <Masonry/Masonry.h>
@interface YxzChatController ()
@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@end

@implementation YxzChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    _chatComponentView=[[YxzChatCompleteComponent alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_chatComponentView];
    [self.chatComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (BOOL)shouldAutorotate
{
return YES;
}
@end
