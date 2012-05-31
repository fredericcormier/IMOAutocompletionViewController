#<center>IMOAutocompletionViewController</center>




 
Suggestions appear in a UITableView underneath the UITextField  



<center>
![screenshot]  
(https://github.com/fredericcormier/IMOAutocompletionViewController/blob/master/media/IMOAucompletionDEMO.png?raw=true)
</center>



##How to use:

####Your calling controller should conform to these protocols  
```objective-c
	@interface MyCallingController : UIViewController <IMOAutocompletionViewDataSouce, IMOAutocompletionViewDelegate>
	
	//Whatever...	

	@end
```
####Then call the IMOAutocompletionViewController like this
```objective-c
	IMOAutocompletionViewController *acvc = [[IMOAutocompletionViewController alloc] initWithNibName:nil bundle:nil]; 
    [acvc setItem:@"Stratocaster"];
    [acvc setItemLabel:@"New Product:"];
    [acvc setDataSource:(id<IMOAutocompletionViewDataSouce>)self];
    [acvc setDelegate:(id<IMOAutocompletionViewDelegate>)self];
    [acvc setBackgroundImageName:@"sandpaperthin.png"];
    
 	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:acvc];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [acvc release];
    [navController release];
```
* pass the default string to the UITextfield   
* set the textfield caption label
* set yourself as  datasource and delegate for the controller
* pass a backgroundimage (optional)  

### ***A navigation controller is required since the cancel button is the*** `navigationItem rightBarButtonItem`   




####Being the delegate and the datasource you will need to implement those 2 methods

provide a list of possible completions
```objective-c
	- (NSArray *)sourceForAutoCompletionTextField:(IMOAutocompletionViewController *)asViewController 
	{
    	return myListOfPossibleCompletionWords;
    }

```
And intercept back the controller completion word  
```objective-c
	- (void)IMOAutocompletionViewControllerReturnedCompletion:(NSString *)completion 
	{
    	[self setTheThingThatNeedsCompletion:completion];
    }
```



#LICENSE 
----
Copyright (C) 2012 Frederic Cormier

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.