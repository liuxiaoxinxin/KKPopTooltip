//
//  ViewController.m
//  KKPopTooltip
//
//  Created by 刘继新 on 2017/7/26.
//  Copyright © 2017年 刘继新. All rights reserved.
//

#import "ViewController.h"
#import "KKPopTooltip.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    [self performSelector:@selector(startTooltip) withObject:nil afterDelay:0.5];
    [_messageButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightClick:(id)sender {
    [KKPopTooltip showAtBarButtonItem:_rightBarButton message:@"发消息" arrowPosition:TooltipArrowPositionTop];
}

- (IBAction)bottomClick:(id)sender {
    [KKPopTooltip showPointingAtView:sender inView:self.view message:@"发送即阅照片或视频" arrowPosition:TooltipArrowPositionBottom];
}

- (IBAction)bottomRightClick:(id)sender {
    [KKPopTooltip showPointingAtView:sender inView:self.view message:@"发送即阅照片或视频" arrowPosition:TooltipArrowPositionBottom];
}

- (void)startTooltip {
    [KKPopTooltip showPointing:CGPointMake(self.view.width/2, 66) inView:self.view message:@"将私人照片、视频和消息发送至个人或群" arrowPosition:TooltipArrowPositionTop];
}

- (void)buttonClick {
    [KKPopTooltip showPointingAtView:self.messageButton inView:self.view message:@"将私人照片、视频和消息发送至个人或群" arrowPosition:TooltipArrowPositionTop];
}

#pragma mark - DZNEmptyDataSetSource & Delegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"TopsTech Direct";
    UIFont *font = [UIFont boldSystemFontOfSize:20.0];
    UIColor *textColor = [UIColor blackColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"将私人照片、视频和消息发送至个人或群。";
    UIFont *font = [UIFont systemFontOfSize:15.0];
    UIColor *textColor = [UIColor blackColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"message.png"];
}


@end
