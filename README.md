#IMOAutocompletionViewController




Suggestions appear in a UITableView underneath the UITextField 



##How to use:

####Your calling controller should conform to these protocols  

	@interface MyCallingController : UIViewController <IMOAutocompletionViewDataSouce, IMOAutocompletionViewDelegate>
	
	//Whatever...	

	@end

####Then call the IMOAutocompletionViewController like this

	IMOAutocompletionViewController *asvc = [[IMOAutocompletionViewController alloc] initWithNibName:nil bundle:nil]; 
    [asvc setItem:@"Stratocaster"];
    [asvc setItemLabel:@"New Product:"];
    [asvc setDataSource:(id<IMOAutocompletionViewDataSouce>)self];
    [asvc setDelegate:(id<IMOAutocompletionViewDelegate>)self];
    [asvc setBackgroundImageName:@"sandpaperthin.png"];
    
 	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:asvc];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [asvc release];
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
