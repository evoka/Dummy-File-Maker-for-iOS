//
//  dfViewController.m
//  dummyfile
//
//  Created by DONG WOO SON on 11. 12. 20..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "dfViewController.h"

@implementation dfViewController
@synthesize btn;
@synthesize slider;
@synthesize label;
@synthesize labelSlider;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)resetFreeSpace
{
    float totalSpace = 0.0f;
    float totalFreeSpace = 0.0f;
    NSError *error = nil;  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];  
    
    if (dictionary) {  
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];  
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %f MiB with %f MiB Free memory available.", ((totalSpace/1024.0f)/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f));
    } else {  
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %@", [error domain], [error code]);  
    }  
    
    [slider setMaximumValue:totalFreeSpace];
    [label setText:[NSString stringWithFormat:@"Free : %.2fMB / Total : %.2fMB",((totalFreeSpace/1024.0f)/1024.0f),((totalSpace/1024.0f)/1024.0f)]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetFreeSpace];
    [labelSlider setText:[NSString stringWithFormat:@"%.2fMB",slider.value/1024.f/1024.f]];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
    [self.view addSubview:spinner]; // spinner is not visible until started

    remain = -1;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSlider:nil];
    [self setLabel:nil];
    [self setLabelSlider:nil];
    [self setBtn:nil];
    spinner = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(NSString*) getLocalFileName:(NSString*)toBeAddedString
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];
	NSString* ret = [documentDir stringByAppendingFormat:@"/%@", toBeAddedString ];
	return ret;
}

- (void)makeDummyFile:(NSNumber*)ss{
    int s = [ss intValue];
    if(s==0) return;
    NSString* filename = [self getLocalFileName:[NSString stringWithFormat:@"%d",arc4random()]];
    
    if ( [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil] )    
    {
        NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:filename];
        if ( file != nil )
        {
            unsigned long long leftByte = s;
            if(leftByte>10*1024*1024)
                leftByte = 10*1024*1024;
            
            int defBufferSize = leftByte;
            while( TRUE )
            {
                void* raw = malloc(defBufferSize);
                int needByte = MIN(defBufferSize, leftByte);
                NSData* data = [[NSData alloc] initWithBytes:raw length:needByte];
                [file writeData:data];
                data = nil;
                
                leftByte -= needByte;
                NSLog(@"needByte: %llu", leftByte );
                free(raw);
                if ( leftByte <= 0 )
                    break;
            }
            [file closeFile];
            file = nil;
            [self performSelectorOnMainThread:@selector(resetFreeSpace) withObject:nil waitUntilDone:NO];
        }
    }
    s-=10*1024*1024;
    if(s>0)
    {
        [self performSelectorInBackground:@selector(makeDummyFile:) withObject:[NSNumber numberWithInt:s]];
    }
    else
    {
        [btn setEnabled:YES];
        [spinner stopAnimating];
    }
}
- (IBAction)pressMake:(id)sender {    
    [btn setEnabled:NO];
    [spinner startAnimating];

   [self performSelectorInBackground:@selector(makeDummyFile:) withObject:[NSNumber numberWithInt:slider.value]];
}

- (IBAction)sliderChanged:(id)sender {
    [labelSlider setText:[NSString stringWithFormat:@"%.2fMB",slider.value/1024.f/1024.f]];
}
- (IBAction)pressDelete:(id)sender {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];

    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDir error:nil];
    for (NSString *tString in dirContents) {
        NSString *path = [NSString stringWithFormat:@"%@/%@",documentDir,tString];
        NSLog(@"%@",path);
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        break;
    }
        [self performSelectorOnMainThread:@selector(resetFreeSpace) withObject:nil waitUntilDone:NO];
    
}
@end
