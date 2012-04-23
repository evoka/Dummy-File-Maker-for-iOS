//
//  dfViewController.h
//  dummyfile
//
//  Created by DONG WOO SON on 11. 12. 20..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dfViewController : UIViewController
{
    int remain;
    UIActivityIndicatorView* spinner;
}
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *labelSlider;
- (IBAction)pressMake:(id)sender;
- (IBAction)sliderChanged:(id)sender;
-(NSString*) getLocalFileName:(NSString*)toBeAddedString;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btn;
- (IBAction)pressDelete:(id)sender;

@end
