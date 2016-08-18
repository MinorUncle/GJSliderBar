//
//  GJSliderBar.m
//  GJSliderBar
//
//  Created by tongguan on 16/7/26.
//  Copyright © 2016年 MinorUncle. All rights reserved.
//

#import "GJSliderBar.h"
#define DEFAULT_SELECT_COLOR [UIColor orangeColor]
#define DEFAULT_COLOR [UIColor blackColor]

#define BOTTON_LINE_HEIGHT 2
#define DEFAULT_ITEM_MARGGIN 2

@interface GJSliderBarCell : UICollectionViewCell
{
    
}
@property(strong,nonatomic)NSString * title;
@property(strong,nonatomic)UILabel * titleLab;


@end
@implementation GJSliderBarCell

-(UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:_titleLab];
        
    }
    return _titleLab;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = _title;
}
-(void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
    _titleLab.frame = bounds;
}


@end
@interface GJSliderBar ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray<NSValue*>* _itemSizeCache;
}
@property(strong,nonatomic)UICollectionView* collectionView;
@property(strong,nonatomic)UIView* bottomLine;

@end

@implementation GJSliderBar

static NSString * const reuseIdentifier = @"GJSliderBarCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enabled = YES;
        self.itemFont = [UIFont systemFontOfSize:20];
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = DEFAULT_ITEM_MARGGIN;

        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView addSubview:self.bottomLine];
        
        [self.collectionView registerClass:[GJSliderBarCell class] forCellWithReuseIdentifier:reuseIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
    [self updateCache];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self selectItemWithIndex:_currentIndex animated:NO];

}

-(UIColor *)itemSelectColor{
    if (_itemSelectColor == nil) {
        _itemSelectColor = DEFAULT_SELECT_COLOR;
    }
    return _itemSelectColor;
}
-(UIColor *)itemColor{
    if (_itemColor == nil) {
        _itemColor = DEFAULT_COLOR;
    }
    return _itemColor;
}
-(void)setTitleNames:(NSArray<NSString *> *)titleNames{
    _titleNames = titleNames;
    [self updateCache];
    [self selectItemWithIndex:_currentIndex animated:NO];
    [self.collectionView reloadData];
}
-(void)updateCache{
    if (_titleNames.count == 0) {
        return;
    }
    _itemSizeCache = [[NSMutableArray alloc]initWithCapacity:_titleNames.count];
    CGFloat totalW = 0;
    for (int i =0 ; i < _titleNames.count; i++) {
        CGSize size = [_titleNames[i] sizeWithAttributes:_itemFont == nil?nil:@{NSFontAttributeName:self.itemFont}];
        size.height = self.bounds.size.height;
        size.width += 4;
        totalW += size.width;
        [_itemSizeCache addObject:[NSValue valueWithCGSize:size]];
    }
}



-(UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = DEFAULT_SELECT_COLOR;
        [self.collectionView addSubview:_bottomLine];
    }

    return _bottomLine;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GJSliderBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.title = self.titleNames[indexPath.row];
    cell.titleLab.font = self.itemFont;
    cell.titleLab.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == _currentIndex) {
        cell.titleLab.textColor = self.itemSelectColor;
    }else{
        cell.titleLab.textColor = self.itemColor;
    }
    // Configure the cell
    
    return cell;
}
-(void)selectItemWithIndex:(NSInteger)index animated:(BOOL)animated{
    if (index>=_itemSizeCache.count) {
        NSLog(@"index 索引错误");
        return;
    }
    
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CGRect rect = CGRectZero;
    rect.size.width = [_itemSizeCache[index] CGSizeValue].width;
    rect.size.height = BOTTON_LINE_HEIGHT;
    rect.origin.y = self.bounds.size.height - BOTTON_LINE_HEIGHT;
    
    CGFloat totalW = 0;
    for (int i = 0; i<_itemSizeCache.count; i++) {
        totalW += _itemSizeCache[i].CGSizeValue.width;
    }
    CGFloat margin = 0;
    if (_itemSizeCache.count > 1) {
        margin = (self.collectionView.collectionViewLayout.collectionViewContentSize.width - totalW)/(_itemSizeCache.count - 1);
    }
    for (int i = 0; i<index; i++) {
        rect.origin.x += _itemSizeCache[i].CGSizeValue.width+margin;
    }
    GJSliderBarCell* beforeCell = (GJSliderBarCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    beforeCell.titleLab.textColor = self.itemColor;
    
    GJSliderBarCell* cell = (GJSliderBarCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
//    rect.origin.x = cell.frame.origin.x;
//    rect.size.width = cell.frame.size.width;
    CGSize size = [self.collectionView.collectionViewLayout collectionViewContentSize];
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomLine.frame = rect;
            cell.titleLab.textColor = self.itemSelectColor;
        }];
    }else{
        self.bottomLine.frame = rect;
        cell.titleLab.textColor = self.itemSelectColor;
    }

    _currentIndex = index;
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

#pragma mark <UICollectionViewDelegate>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_itemSizeCache[indexPath.row] CGSizeValue];
}
-(void)setEnabled:(BOOL)enabled{
    _enabled = enabled;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!_enabled) {
        return;
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self selectItemWithIndex:indexPath.row animated:YES];
    
    if (self.slideBarItemSelectedCallback != nil) {
        self.slideBarItemSelectedCallback(indexPath.row);
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
