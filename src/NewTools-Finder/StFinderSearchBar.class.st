"
I am a widget for the ̀Finder̀ tool. I contain all widgets regarding the search bar.
"
Class {
	#name : #StFinderSearchBar,
	#superclass : #SpPresenter,
	#instVars : [
		'searchInput',
		'searchButton',
		'searchModeDropList',
		'helpButton',
		'enableRegexpCheckBox',
		'chosenPackagesButton',
		'allPackagesButton'
	],
	#category : #'NewTools-Finder-Widgets'
}

{ #category : #'updating - widgets' }
StFinderSearchBar >> activateAllPackages [

	allPackagesButton iconName: #radioButtonSelected.
	chosenPackagesButton iconName: #radioButtonUnselected
]

{ #category : #'updating - widgets' }
StFinderSearchBar >> activateChosenPackages [

	allPackagesButton iconName: #radioButtonUnselected.
	chosenPackagesButton iconName: #radioButtonSelected
]

{ #category : #accessing }
StFinderSearchBar >> allPackagesButton [

	^ allPackagesButton
]

{ #category : #accessing }
StFinderSearchBar >> chosenPackagesButton [

	^ chosenPackagesButton
]

{ #category : #initialization }
StFinderSearchBar >> connectPresenters [

	helpButton action: [
		self flag: #todo. "Make better help text dialog."
		(self newText
			 beNotEditable;
			 withoutEditionContextMenu;
			 text: self owner class defaultExplanation;
			 openDialog) title: 'Finder Help' ]
]

{ #category : #layout }
StFinderSearchBar >> defaultLayout [

	^ SpBoxLayout newTopToBottom
				   spacing: 2;
				   add: (SpBoxLayout newLeftToRight
						    spacing: 2;
						    add: searchModeDropList expand: false;
						    add: searchInput;
						    yourself);
				   add: (SpBoxLayout newLeftToRight
						    spacing: 2;
						    add: allPackagesButton expand: false;
						    add: chosenPackagesButton expand: false;
						    add: enableRegexpCheckBox expand: false;
						    addLast: helpButton;
						    yourself);
				   yourself
]

{ #category : #accessing }
StFinderSearchBar >> enableRegexpCheckBox [

	^ enableRegexpCheckBox
]

{ #category : #accessing }
StFinderSearchBar >> helpButton [

	^ helpButton
]

{ #category : #initialization }
StFinderSearchBar >> initializePresenters [

	searchInput := self newSearchInput
		               placeholder: 'Search... Hit return to accept';
		               yourself.
	searchButton := self newButton label: 'Search'.
	enableRegexpCheckBox := self newCheckBox label: 'Regexp'.
	searchModeDropList := self newDropList
		                      display: [ :search | search name ];
		                      yourself.
	chosenPackagesButton := self newButton
		                        label: 'Packages…';
		                        iconName: #radioButtonUnselected;
		                        yourself.
	allPackagesButton := self newButton
		                     label: 'All Packages';
		                     iconName: #radioButtonSelected;
		                     yourself.
	helpButton := self newButton
		              icon: (Smalltalk ui icons iconNamed: #help);
		              yourself
]

{ #category : #accessing }
StFinderSearchBar >> searchButton [

	^ searchButton
]

{ #category : #accessing }
StFinderSearchBar >> searchInput [

	^ searchInput
]

{ #category : #accessing }
StFinderSearchBar >> searchModeDropList [

	^ searchModeDropList
]

{ #category : #'updating - widgets' }
StFinderSearchBar >> searchModes: aListOfSearches [

	searchModeDropList items: aListOfSearches
]

{ #category : #'updating - widgets' }
StFinderSearchBar >> updateSearchModes [

	searchModeDropList items: self owner model availableSearches
]

{ #category : #events }
StFinderSearchBar >> whenAllPackagesSelectedDo: aBlock [

	allPackagesButton action: aBlock
]

{ #category : #events }
StFinderSearchBar >> whenPackagesSelectedDo: aBlock [

	chosenPackagesButton action: aBlock
]

{ #category : #events }
StFinderSearchBar >> whenRegexActivatedDo: aBlock [

		enableRegexpCheckBox whenActivatedDo: aBlock
]

{ #category : #events }
StFinderSearchBar >> whenRegexDeactivatedDo: aBlock [

	enableRegexpCheckBox whenDeactivatedDo: aBlock
]

{ #category : #events }
StFinderSearchBar >> whenSearchModeChangedDo: aOneArgumentBlock [
	"aOneArgumentBlock gets the new search mode passed as the argument."

	searchModeDropList whenSelectedItemChangedDo: aOneArgumentBlock
]

{ #category : #events }
StFinderSearchBar >> whenSubmitSearchDo: aOneArgumentBlock [
	"aOneArgumentBlock gets the search text passed as the argument."

	searchInput whenSubmitDo: aOneArgumentBlock
]
