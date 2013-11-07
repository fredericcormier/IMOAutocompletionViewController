#<center>IMOAutocompletionViewController</center>




 
###<center>For iOS6 and iOS7 </center>



<center>
![screenshot]  
(https://github.com/fredericcormier/IMOAutocompletionViewController/blob/master/media/IMOAutocompletionDEMO7.png?raw=true)
![screenshot]  
(https://github.com/fredericcormier/IMOAutocompletionViewController/blob/master/media/IMOAucompletionDEMO.png?raw=true)
</center>



##How to use:

####Your calling controller should implement these 2 protocols  
```objective-c
	@interface MyCallingController : UIViewController <IMOAutocompletionViewDataSouce, IMOAutocompletionViewDelegate>
	
	//Whatever...	

	@end
```
####Then call the IMOAutocompletionViewController like this
```objective-c
	IMOAutocompletionViewController *acvc = [[IMOAutocompletionViewController alloc]
                                             initWithLabelString:@"Label:" 
                                             textFieldString:[self theItem] 
                                             backgroundImageName:@"sandpaperthin.png"
                                             cellColors:nil];
                                             
    [acvc setDataSource:(id<IMOAutocompletionViewDataSouce>)self];
    [acvc setDelegate:(id<IMOAutocompletionViewDelegate>)self];

    
 	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:acvc];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [acvc release];
    [navController release];
```
Initializer arguments:
* labelString is the textfield caption label
* textFieldString is to populate the UITextfield 
* pass a background image (pass nil for default background) 
* cell color dictionary (pass nil for default colors) 

Other initializer are overriden and call the designated initializer with default arguments (nil).  
Old version's designated initializer calls the new version's one.
* set yourself as  datasource and delegate for the controller



### ***A navigation controller is required since the cancel button is the*** `navigationItem rightBarButtonItem`   




####You then need need to implement those 2 methods

 1 - provide a list of possible completions
```objective-c
	- (NSArray *)sourceForAutoCompletionTextField:(IMOAutocompletionViewController *)asViewController 
	{
    	return myListOfPossibleCompletionWords;
    }

```
2 -  intercept back the controller completion word  
```objective-c
	- (void)IMOAutocompletionViewControllerReturnedCompletion:(NSString *)completion 
	{
    	[self setTheThingThatNeedsCompletion:completion];
    }
```

###If you want to provide your own cell colors, just pass a dictionary like this to the cellColors argument
```objective-c 
	 NSDictionary *cellColors = @{
                IMOCompletionCellTopSeparatorColor: [UIColor whiteColor],
             IMOCompletionCellBottomSeparatorColor: [UIColor colorWithRed:0.885 green:0.788 blue:0.767 alpha:1.000],
                  IMOCompletionCellBackgroundColor: [UIColor colorWithRed:0.961 green:0.914 blue:0.864 alpha:1.000]};
    

```
#LICENSE 
----
Copyright (C) 2013 Frederic Cormier

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
