#<center>IMOAutocompletionViewController</center>




 
<center>Suggestions appear in a UITableView underneath the UITextField  
<center>


<center>
![screenshot]  
(https://github.com/fredericcormier/IMOAutocompletionViewController/blob/master/media/IMOACBackground.png?raw=true)
</center>



##How to use:

####Your calling controller should conform to these protocols  
```objective-c
	@interface MyCallingController : UIViewController <IMOAutocompletionViewDataSouce, IMOAutocompletionViewDelegate>
	
	//Whatever...	

	@end
```
####Then call the IMOAutocompletionViewController like this

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

* pass the default string to the UITextfield   
* set the textfield caption label
* set yourself as  datasource and delegate for the controller
* pass a backgroundimage (optional)  

### ***A navigation controller is required since the cancel button is the*** `navigationItem rightBarButtonItem`   




####As a delegate and datasource you will need to implement those 2 methods

provide a list of possible completions

	- (NSArray *)sourceForAutoCompletionTextField:(IMOAutocompletionViewController *)asViewController 
	{
    	return myListOfPossibleCompletionWords;
    }


And intercept the controller completion word  

	- (void)IMOAutocompletionViewControllerReturnedCompletion:(NSString *)completion 
	{
    	[self setTheItem:completion];
    }
