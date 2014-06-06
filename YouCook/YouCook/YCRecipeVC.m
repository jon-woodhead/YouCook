//
//  YCRecipeVC.m
//  YouCook
//
//  Created by Jon Woodhead on 15/04/2014.
//  Copyright (c) 2014 Jon Woodhead. All rights reserved.
//

#import "YCRecipeVC.h"
#import "YCIngredientCell.h"
#import "YCSubmitVC.h"





@interface YCRecipeVC (){
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    YCUserData *_userData;
    YCCommentSearchService *_commentService;
    YCCommentVC *_commentVC;
    NSMutableArray *_textViews;
     NSMutableArray *_backgroundImages;
    
}

@end

@implementation YCRecipeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _moreArrow.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
        UIImageView *imageView = [self randomBgImageView];
          [_scrollView insertSubview:imageView atIndex:0];
}

-(void)viewDidAppear:(BOOL)animated{
    if (self.recipe) [self configureWithRecipe];
}
-(void)setRecipe:(YCRecipe*)recipe{
    _recipe = recipe;
     if (_scrollView) [self configureWithRecipe];
}
-(YCUserData*)userData{
    if (_userData) return _userData;
    _userData = [YCUserData new];
    return _userData;
}
-(void)configureWithRecipe{
    if (! _recipe){
        NSLog(@"ERROR YCRecipe configureWithRecipe called before recipe was defined");
        return;
    }
    self.title = _recipe.title;
   
    _recipeChef.text = [NSString stringWithFormat:@"Recipe by %@",_recipe.chef];
    
    //in ios7 there is a silly bug that resets the font on setText if the UITextField is not selectable
    //this is a work around
    _outline.selectable = YES;
    _outline.text = _recipe.outline;
    _outline.selectable = NO;
    
    //resize outline to fit the content
       CGRect beforeFrame = _outline.frame;
    _outline.scrollEnabled = YES;
    [_outline sizeToFit];
    CGRect afterFrame = _outline.frame;
    int change = beforeFrame.size.height - afterFrame.size.height;
    if (change >0 ){
        _outline.scrollEnabled = NO;
        CGRect frame = _column0.frame;
        frame.origin.y -= change;
        frame.size.height += change;
        _column0.frame = frame;

    }
    else
        _outline.frame = beforeFrame;
    
    [_ingredientTable reloadData];
    
    
    
    _editBtn = [[UIBarButtonItem alloc] initWithTitle:@" Edit " style:UIBarButtonItemStylePlain target:self action:@selector(editRecipe:)];
    _saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"      " style:UIBarButtonItemStylePlain target:self action:@selector(saveUnsaveRecipe:)];
    
    _shareBtn = [[UIBarButtonItem alloc] initWithTitle:@" Share " style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
     _commentBtn = [[UIBarButtonItem alloc] initWithTitle:@" Comment " style:UIBarButtonItemStylePlain target:self action:@selector(comment:)];
    
    
   
    BOOL isMyRecipe = [[self userData] isThisMyUUID:_recipe.chefCode];
    if (isMyRecipe){
        self.navigationItem.rightBarButtonItems = @[_editBtn,_shareBtn,_saveBtn];
    }
    else{
        self.navigationItem.rightBarButtonItems = @[_commentBtn,_shareBtn,_saveBtn];
    }

    
    BOOL wasSaved = [[self userData] isItASavedRecipe:_recipe];
     [self setSavedButtonSelected: wasSaved];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20,20,50,50);
    
    
        
        
        
        //Ultimately the deployment target for this app is 7.0.
        //However, I need to able to test on a 6.0 device
        //this if will prevent a crash on that device
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            //clear out the old stuff if necessary
            if (_textViews){
                for (UITextView *tv in _textViews)
                    [tv removeFromSuperview];
            }
            _textViews = [NSMutableArray new];
            //Build the attributed string that will be displayed as the recipe.
            //This will comprise the instructions and comments.
            
            NSMutableAttributedString *enhancedInstructions = [[NSMutableAttributedString alloc]
                                                               initWithString:_recipe.instructions
                                                               attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]                                                                                                                                                }];
            
            for (YCComment *comment in _recipe.comments){
                NSMutableAttributedString *cUser = [[NSMutableAttributedString alloc]
                                                    initWithString:[NSString stringWithFormat:@"\n\n\n%@",comment.user]
                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:18],                                                                                                                                                NSForegroundColorAttributeName:[UIColor colorWithRed:85/255.0 green:125/255.0 blue:85/255.0 alpha:1]}];
                NSMutableAttributedString *cDate = [[NSMutableAttributedString alloc]
                                                    initWithString:[NSString stringWithFormat:@"\n%@",[comment getDateString]]
                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14],                                                                                                                                                NSForegroundColorAttributeName:[UIColor lightGrayColor]                                                                                                                                          }];
                
                NSMutableAttributedString *cBody = [[NSMutableAttributedString alloc]
                                                    initWithString:[NSString stringWithFormat:@"\n%@",comment.body]
                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16]                                                                                                                                                }];
                
                 [enhancedInstructions appendAttributedString:cUser];
                [enhancedInstructions appendAttributedString:cDate];
                [enhancedInstructions appendAttributedString:cBody];
                
            }
            
            
            
            _textStorage = [[NSTextStorage alloc] initWithAttributedString:enhancedInstructions];
            
            
            // Create a layout manager
            _layoutManager = [[NSLayoutManager alloc] init];
            [_textStorage addLayoutManager:_layoutManager];
            
            
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:_column0.frame.size];
            UITextView *column0Text = [[UITextView alloc] initWithFrame:_column0.bounds textContainer:textContainer];
            column0Text.scrollEnabled = NO;
            column0Text.editable = NO;
            column0Text.backgroundColor = [UIColor clearColor];
            
            [_column0 addSubview:column0Text];
            column0Text.textContainerInset = insets;
            
            [_textViews addObject:column0Text];
            [_layoutManager addTextContainer:textContainer];
            
            
            CGFloat currentColumn = 0; //to keep track of how many columns we have added
            CGSize columnSize = CGSizeMake(_column0.bounds.size.width, self.scrollView.frame.size.height);
            CGPoint columnOffset = CGPointMake(_column0.frame.origin.x, 0);
            
            //Normally column0 will not be big enough to hold all the instructions.
            //So here we use textKit to add text containers until all the text is contained.
            NSUInteger lastRenderedGlyph = NSMaxRange([_layoutManager glyphRangeForTextContainer:textContainer]);
            while (lastRenderedGlyph < _layoutManager.numberOfGlyphs) {
                
                currentColumn ++;
                
                CGRect textViewFrame = CGRectMake(columnOffset.x + currentColumn * CGRectGetWidth(self.scrollView.bounds) / 2,
                                                  columnOffset.y,
                                                  columnSize.width,
                                                  columnSize.height);
                
                textContainer = [[NSTextContainer alloc] initWithSize:columnSize];
                [_layoutManager addTextContainer:textContainer];
                
                // And a text view to render it
                UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                                           textContainer:textContainer];
                textView.scrollEnabled = NO;
                textView.textContainerInset = insets;
                textView.editable = 0;
                textView.backgroundColor = [UIColor clearColor];
                [self.scrollView addSubview:textView];
                [_textViews addObject:textView];
                
                // And find the index of the glyph we've just rendered
                lastRenderedGlyph = NSMaxRange([_layoutManager glyphRangeForTextContainer:textContainer]);
                
            }
            currentColumn ++;
            int pages = ceil((1+currentColumn)/2);
            CGSize contentSize = CGSizeMake(pages * CGRectGetWidth(self.scrollView.bounds),
                                            CGRectGetHeight(self.scrollView.bounds));
            self.scrollView.contentSize = contentSize;
            self.scrollView.pagingEnabled = YES;
            [self addBackgroundImages];
            if (currentColumn >1) _moreArrow.hidden = NO;
        }
        
    if (! _recipe.comments){
        //we don't yet have the comments from the database
        //so set up a service to go get them
        _commentService = [YCCommentSearchService new];
        __weak YCRecipeVC* weakSelf = self;
        [_commentService retrieveCommentsForRecipe:_recipe.ID completionBlock:^(BOOL success, NSArray *results){
            if (success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.recipe.comments = [NSArray arrayWithArray:results];
                    [weakSelf configureWithRecipe];
                });
            }
            
        }];
    }
    
    _photo.image = _recipe.photo;
    //round the corners of the photo
    CALayer * l = [_photo layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    //make the photo slightly transparent so we see the bg through it.
    _photo.alpha = 0.8;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table delegate calls
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"IngredientCell";
    static NSString * CellNib = @"YCIngredientCell";
    YCIngredientCell *cell = (YCIngredientCell *)[_ingredientTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (YCIngredientCell *)[nib objectAtIndex:0];
        
        
    }
    NSUInteger row =[indexPath row];
    NSString *ing = _recipe.ingredients[row];
    [cell displayDataForIngredient:ing];
    
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return _recipe.ingredients.count;
    
}
#pragma mark - button actions
-(IBAction)comment:(id)sender{
    _commentVC = [YCCommentVC new];
    
    _commentVC.recipe = _recipe;
    _commentVC.delegate = self;
    _commentVC.view.frame = self.view.bounds;
   
     [self presentViewController:_commentVC animated:YES completion: nil];
    }
- (void)finishedComment:(YCCommentVC*)comment{
    if (comment == _commentVC) _commentVC = nil;
    [self configureWithRecipe];
}
-(IBAction)saveUnsaveRecipe:(id)sender{
    if ([self savedButtonSelected]) [[self userData] unsaveRecipe:_recipe];
    else [[self userData] saveRecipe:_recipe];
    [self setSavedButtonSelected:![self savedButtonSelected]];
}

-(IBAction)editRecipe:(id)sender{
    YCSubmitVC *submitVC = [YCSubmitVC new];
    [self.navigationController pushViewController:submitVC animated:YES];
    submitVC.recipe = _recipe;
    NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [allControllers removeObject:self];
    [self.navigationController setViewControllers:allControllers animated:NO];
}

-(IBAction)share:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share"
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Facebook",
								  @"Twitter", nil];
    
	//[actionSheet showFromRect:CGRectMake (sharePoint.x,sharePoint.y,1200,25) inView:self.view animated:YES];
    [actionSheet showFromBarButtonItem:_shareBtn animated:YES];
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    if (buttonIndex == 0) [self shareToFacebook];
    if (buttonIndex == 1) [self shareToTwitter];
}
- (void)shareToTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"SHARE_MESSAGE", @"Twitter Failed"),self.recipe.title]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else{
         UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TWITTER_FAILED_TITLE", @"Twitter Failed") message:NSLocalizedString(@"TWITTER_FAILED_MESSAGE", @"Twitter Failed") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)shareToFacebook{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"SHARE_MESSAGE", @"Twitter Failed"),self.recipe.title]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FB_FAILED_TITLE", @"Facebook Failed") message:NSLocalizedString(@"FB_FAILED_MESSAGE", @"Facebook Failed") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
//BarButtonItemss don't have a selected state, so here we fake that by setting and checking the title
-(void)setSavedButtonSelected:(BOOL)selected{
    if (selected) _saveBtn.title = @"Unsave";
    else _saveBtn.title = @"Save";
}
-(BOOL)savedButtonSelected{
    BOOL isSelected = ([_saveBtn.title isEqualToString:@"Unsave"]);
    return isSelected;
}
#pragma mark -  set the background images for the various "pages"
-(void)addBackgroundImages{
    NSUInteger imagesToLoad = _scrollView.contentSize.width/_scrollView.frame.size.width;
    for (int i = 1; i < imagesToLoad+1; i++){
        UIImageView *imageView = [self randomBgImageView];
        CGRect frame = imageView.frame;
        frame.origin.x = i*_scrollView.frame.size.width;
        imageView.frame = frame;
        
        [_scrollView insertSubview:imageView atIndex:0];
    }
}
//returns a random UIImageView suitable for a page of the "book"
-(UIImageView*)randomBgImageView{
    int random =  arc4random() % 11;
    UIImage *bg = [UIImage imageNamed:[NSString stringWithFormat:@"pageBg%i.png",random]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bg];
    imageView.alpha = 0.5;
    return imageView;
}
@end
