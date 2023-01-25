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

{ #category : #initialization }
StFinderPresenter >> connectPresenters [

	searchBar
		whenSubmitSearchDo: [ :text | self model searchBy: text ];
		whenAllPackagesSelectedDo: [ self searchInAllPackages ];
		whenPackagesSelectedDo: [ self openPackageChooserDialog ];
		whenRegexActivatedDo: [ self model useRegex: true ];
		whenRegexDeactivatedDo: [ self model useRegex: false ];
		whenSearchModeChangedDo: [ :new | self model currentSearch: new ].

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

	self flag: #todo. "Add Statusbar back again"
	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: searchBar
		  expand: false;
		  add: resultTree;
		  "add: resultStatusBar expand: false;"add: resultButtonBar
		  expand: false;
		  yourself
]

{ #category : #initialization }
StFinderPresenter >> initializePresenters [

	searchBar := self instantiate: StFinderSearchBar.
	searchBar searchModes: self model availableSearches.

	resultTree := self newTree display: [ :result | result displayString ].

	resultButtonBar := self instantiate: StFinderResultButtonBar.

	self flag: #toImplement. "StatusBar with info about nr of packages searched and results."
	self initializeStatusBar
]

{ #category : #initialization }
StFinderPresenter >> initializeStatusBar [

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
		okAction: [ :dialog | 
		self searchInPackages: dialog presenter chosenItems ]
]

{ #category : #accessing }
StFinderPresenter >> resultButtonBar [

	^ resultButtonBar
]

{ #category : #accessing }
StFinderPresenter >> resultStatusBar [

	^ resultStatusBar
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
	searchBar activateAllPackages
]

{ #category : #private }
StFinderPresenter >> searchInPackages: aCollection [
	"Sets the search environment in the model to the package names given in aCollection."

	self model selectedPackagesByName: aCollection.
	searchBar activateChosenPackages
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
StFinderPresenter >> updateResults [
	"Call to update resultTree from the model."

	self updateResultsWith: self model results
]

{ #category : #'updating - widgets' }
StFinderPresenter >> updateResultsWith: results [
	"Call to update resultTree with results."

	resultTree
		roots: results;
		children: [ :result | result children ]
]
