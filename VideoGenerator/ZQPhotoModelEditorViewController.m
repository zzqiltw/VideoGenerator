//
//  ZQPhotoModelEditorViewController.m
//  VideoGenerator
//
//  Created by 郑志勤 on 2017/7/7.
//  Copyright © 2017年 zzqiltw. All rights reserved.
//

#import "ZQPhotoModelEditorViewController.h"
#import <Masonry/Masonry.h>

@interface ZQPhotoModelEditorViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZQPhotoModelEditorViewCell

+ (CGFloat)defaultHeight
{
    return 80;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.photoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [self.contentView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.centerY.offset(0);
                make.left.offset(15);
            }];
            
            imageView;
        });
        
        self.textField = ({
            UITextField *textField = [UITextField new];
            
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textField.returnKeyType = UIReturnKeyDone;
            textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 28)];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            [self.contentView addSubview:textField];
            
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.photoImageView.mas_right).offset(20);
                make.width.equalTo(@200);
                make.centerY.offset(0);
            }];
            
            textField;
        });
    }
    return self;
}


@end

@interface ZQPhotoModelEditorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *inputBar;
@property (nonatomic, strong) UITextField *accessoryTextField;

@end

@implementation ZQPhotoModelEditorViewController

- (void)viewDidLoad
{
    UIBarButtonItem *chooseSome = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:UIBarButtonItemStylePlain target:self action:@selector(onChoose:)];
    
    UIBarButtonItem *chooseAll = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(onChooseAll:)];
    
    UIBarButtonItem *generateVideo = [[UIBarButtonItem alloc] initWithTitle:@"生成视频" style:UIBarButtonItemStylePlain target:self action:@selector(onSure:)];
    
    self.navigationItem.rightBarButtonItems = @[chooseSome, chooseAll, generateVideo];
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [self.view addSubview:tableView];
        
        [tableView registerClass:ZQPhotoModelEditorViewCell.class forCellReuseIdentifier:@"ZQPhotoModelEditorViewCell"];
        
        tableView;
    });
    
    self.inputBar = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 48)];
        
        UITextField *textField = [UITextField new];
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.returnKeyType = UIReturnKeyDone;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 28)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [view addSubview:textField];
        
        self.accessoryTextField = textField;
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.width.equalTo(@200);
            make.centerY.offset(0);
        }];
        
        UIButton *button = [UIButton new];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(onEdited:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"应用到选择项" forState:UIControlStateNormal];
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(textField.mas_right).offset(20);
            make.centerY.offset(0);
        }];
        
        
        view;
    });
}

- (void)onChoose:(id)sender
{
    [self.view endEditing:YES];
    if (self.tableView.isEditing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)onChooseAll:(id)sender
{
    [self.tableView setEditing:YES animated:YES];

    for (NSInteger i = 0; i < self.photoModels.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.photoModels[i].selected = YES;
    }
}

- (void)onEdited:(id)sender
{
    [self.view endEditing:YES];
    [self.tableView setEditing:YES animated:NO];

    for (NSInteger i = 0; i < self.photoModels.count; ++i) {
        if (self.photoModels[i].selected) {
            self.photoModels[i].duration = self.accessoryTextField.text.doubleValue;
        }
    }
    
    [self.tableView reloadData];
}

- (void)onCancelAll:(id)sender
{
    [self.tableView setEditing:YES animated:YES];
    
    for (NSInteger i = 0; i < self.photoModels.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.photoModels[i].selected = NO;
    }
}

- (void)onSure:(id)sender
{
    NSMutableArray *selectedModels = [NSMutableArray array];
    [self.photoModels enumerateObjectsUsingBlock:^(ZQPhotoDurationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected) {
            [selectedModels addObject:obj];
        }
    }];
    if ([self.delegate respondsToSelector:@selector(photoEditorDidFinishPick:photoModels:)]) {
        [self.delegate photoEditorDidFinishPick:self photoModels:[selectedModels copy]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQPhotoModelEditorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQPhotoModelEditorViewCell" forIndexPath:indexPath];
    
    ZQPhotoDurationModel *model = self.photoModels[indexPath.row];
    
    cell.textField.text = [NSString stringWithFormat:@"%.2lf", model.duration];
    cell.textField.inputAccessoryView = self.inputBar;
    
    cell.photoImageView.image = model.image;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQPhotoModelEditorViewCell defaultHeight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQPhotoDurationModel *model = self.photoModels[indexPath.row];
    model.selected = !model.selected;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.photoModels exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

@end
