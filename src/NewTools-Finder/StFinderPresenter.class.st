"
I am the presenter for the ̀Finder̀ tool.

I define the user interface of the finder tool.
"
Class {
	#name : #StFinderPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'searchBar',
		'resultTree',
		'resultButtonBar',
		'environmentBar',
		'searchOptions',
		'helpButton',
		'resultStatusBar'
	],
	#category : #'NewTools-Finder-Core'
}

{ #category : #'default values' }
StFinderPresenter class >> defaultExplanation [

	^ 'The Finder can be used by default in 4 different ways:
	- Selectors: your research is done among selectors
	- Classes : your research is done among classes names
	- Source : your research is done among all the source code
	- Pragmas: your research is done among pragmas
	- Examples : your research uses the Method Finder behavior 
			   (for further informations, print ''FinderUI methodFinderExplanation'')
	
			
In these four modes, you can also tick the ''Use RegEx'' checkbox.
If you pick this box, your search will be done using regular expressions instead of just matching.

The ''Select classes'' button opened a dialog window  to select which classes will be used for the search.
The ''All classes'' button is used to reset the classes selection.'
]

{ #category : #'default values' }
StFinderPresenter class >> methodFinderExplanation [
	"MethodFinder new findMethodsByExampleInput: #( 1 2 ) andExpectedResult: 3."
	"may be this method can be moved to the corresponding search "

	^ 'Use an example to find a method in the system.  
	
   ''a''. ''b''. ''ab''       will find the message #, for strings concatenation
   2. -2                will find the message #negated
   3. 6                 will find the message #factorial
   20. 10. 15. 15       will find the message #min:max:

It works on collections too:

   {2. 4. 5. 1}. 5. 3   will find the message #indexOf:
   {2. 5. 1}. 5. true   will find the message #includes:
	
An example is made up of the following two or more items separated by a period: 
	
	receiver. answer
	receiver. argument1. answer
	receiver. argument1. argument2. answer
	etc...
	
For example, type: 3. 4. 7. into the search box and click <Search>

Take care on separating spaces because of floating point numbers.

 	3.4.7      will find nothing, it is interpreted two numbers, 3.4 and. 7
	3. 4. 7    will find you the message #+
	
The examples array should contain one object for the receiver, one object per expected argument and then a final object with the expected result.	

In other words 
 - a unary method example expects an array of input objects #( receiver ) and an expected result
 - a binary method example expects an array with two input objects #( receiver argument ) and an expected result
 - a keyword method example expects an array with at least two elements  #( receiver argument1 argument2 ... ) and an expected results

The method finder will take the input objects (receiver and arguments) and perform their permutation to be able to find more results.
Then, it will lookup in the receiver''s hierarchy the approved and forbidden methods to run on the hierarchy and run them on the permutation of objects.

Receiver and arguments do not have to be in the right order.

Alternatively, in this bottom pane or in the Playground, use #findMethodsByExampleInput:andExpectedResult: directly to find a method in the system.  Select this line of code and choose "print it" or "inspect it.  

	MethodFinder new findMethodsByExampleInput: #( 1 2 ) andExpectedResult: 3.

It is useful when you want to look for computed objects:
	
	MethodFinder new 
		findMethodsByExampleInput: {''29 Apr 1999'' asDate} 
		andExpectedResult: ''30 Apr 1999'' asDate.

This will find the message #next.

	MethodFinder new 
		findMethodsByExampleInput: {''30 Apr 1999'' asDate} 
		andExpectedResult: ''Friday''. 

This will find the message #dayOfWeekName

The Method Finder is not trying all methods in the system so if it will find nothing, a method with requested behavior may still exist. '

		

]

{ #category : #'instance creation' }
StFinderPresenter class >> open [
	<script>
	
	(self on: StFinderModel new) open
]

{ #category : #initialization }
StFinderPresenter >> connectPresenters [

	searchBar
		whenSubmitSearchDo: [ :text | self model searchBy: text ];
		whenSearchModeChangedDo: [ :new | self model currentSearch: new ].

	helpButton action: [
		self flag: #todo. "Make better help text dialog."
		(self newText
			 beNotEditable;
			 withoutEditionContextMenu;
			 text: self class defaultExplanation;
			 openDialog) title: 'Finder Help' ].

	searchOptions
		whenRegexActivatedDo: [ self model useRegex: true ];
		whenRegexDeactivatedDo: [ self model useRegex: false ].

	environmentBar
		whenAllPackagesSelectedDo: [ self searchInAllPackages ];
		whenPackagesSelectedDo: [ self openPackageChooserDialog ].

	resultTree whenSelectedItemChangedDo: [ :newResult |
		newResult
			ifNil: [ self resultButtonBar disableAll ]
			ifNotNil: [ self resultButtonBar enableButtonsFor: newResult ] ].

	self connectResultButtons.

	self subscribeToAnnouncements
]

{ #category : #initialization }
StFinderPresenter >> connectResultButtons [

	resultButtonBar browseAction: [ self selectedResult ifNotNil: [ :result | result browseAction ] ].
	resultButtonBar sendersAction: [ self selectedResult ifNotNil: [ :result | result sendersAction ] ].
	resultButtonBar implementersAction: [ self selectedResult ifNotNil: [ :result | result implementersAction ] ].
	resultButtonBar versionsAction: [ self selectedResult ifNotNil: [ :result | result versionsAction ] ].
	resultButtonBar inheritanceAction: [ self selectedResult ifNotNil: [ :result | result inheritanceAction ] ].
	resultButtonBar hierarchyAction: [ self selectedResult ifNotNil: [ :result | result hierarchyAction ] ]
]

{ #category : #layout }
StFinderPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 2;
				   add: searchBar;
				   addLast: helpButton;
				   yourself)
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 2;
				   add: searchOptions expand: false;
				   add: SpNullPresenter new;
				   add: environmentBar expand: false;
				   yourself)
		  expand: false;
		  add: resultTree;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 2;
				   add: resultButtonBar expand: false;
				   addLast: resultStatusBar;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #initialization }
StFinderPresenter >> initializePresenters [

	searchBar := self instantiate: StFinderSearchBar.
	searchBar searchModes: self model availableSearches.

	helpButton := self newButton
		              icon: (Smalltalk ui icons iconNamed: #help);
		              yourself.

	searchOptions := self instantiate: StFinderSearchOptions.

	environmentBar := self instantiate: StFinderEnvironmentBar.
	self updateEnvironmentStatusFor: self model selectedPackages.

	resultTree := self newTree
		display: [ :result | result displayString ];
		displayIcon: [ :result | result displayIcon ].

	resultButtonBar := self instantiate: StFinderResultButtonBar.

	resultStatusBar := self newStatusBar
]

{ #category : #initialization }
StFinderPresenter >> initializeWindow: aWindowPresenter [

	self flag: #todo. "Find a way to set minimal needed extent for contents."
	aWindowPresenter
		title: 'Finder';
		initialExtent: 800 @ 600;
		windowIcon: (self iconNamed: #smallFind)
]

{ #category : #private }
StFinderPresenter >> openPackageChooserDialog [
	"Opens a `SpChooserPresenter` dialog to allow the user to choose the packages to search in."

	((SpChooserPresenter
		  sourceItems: self model unselectedPackages
		  chosenItems: self model selectedPackages)
		 sourceLabel: 'Available packages';
		 targetLabel: 'Selected packages';
		 openDialog)
		title: 'Select packages for searching';
		okAction: [ :dialog | self searchInPackages: dialog presenter chosenItems ]
]

{ #category : #accessing }
StFinderPresenter >> resultButtonBar [

	^ resultButtonBar
]

{ #category : #accessing }
StFinderPresenter >> resultTree [

	^ resultTree
]

{ #category : #accessing }
StFinderPresenter >> searchBar [

	^ searchBar
]

{ #category : #private }
StFinderPresenter >> searchInAllPackages [
	"Selects all packages for searching."

	self model selectAllPackages.
	environmentBar activateAllPackages.
	self updateEnvironmentStatusFor: self model selectedPackages
]

{ #category : #private }
StFinderPresenter >> searchInPackages: aCollection [
	"Sets the search environment in the model to the package names given in aCollection."

	self model selectedPackagesByName: aCollection.
	environmentBar activateChosenPackages.
	self updateEnvironmentStatusFor: aCollection
]

{ #category : #information }
StFinderPresenter >> selectedResult [

	^ resultTree selectedItem
]

{ #category : #initialization }
StFinderPresenter >> subscribeToAnnouncements [

	self model whenSearchStarted: [  ].
	self model whenSearchEnded: [ :results |
		self updateResultsWith: results ].
	self model whenSearchTypesChanged: [ self searchBar updateSearchModes ]
]

{ #category : #'updating - widgets' }
StFinderPresenter >> updateEnvironmentStatusFor: packages [

	environmentBar status: packages size asString , ' Packages selected'
]

{ #category : #'updating - widgets' }
StFinderPresenter >> updateResults [
	"Call to update resultTree from the model."

	self updateResultsWith: self model results
]

{ #category : #'updating - widgets' }
StFinderPresenter >> updateResultsWith: results [
	"Call to update resultTree with results."

	resultTree
		roots: results;
		children: [ :result | result children ].
	resultStatusBar pushMessage: 'Found ',results size asString,' results'
]
