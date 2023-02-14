"
I am a widget for the ̀Finder̀ tool. I contain all widgets regarding the search bar.
"
Class {
	#name : #StFinderSearchBar,
	#superclass : #SpPresenter,
	#instVars : [
		'searchInput',
		'searchButton',
		'searchModeDropList'
	],
	#category : #'NewTools-Finder-Widgets'
}

{ #category : #layout }
StFinderSearchBar >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  spacing: 2;
		  add: searchModeDropList expand: false;
		  add: searchInput;
		  yourself
]

{ #category : #initialization }
StFinderSearchBar >> initializePresenters [

	searchInput := self newSearchInput
		               placeholder: 'Search... Hit return to accept';
		               yourself.
	searchButton := self newButton label: 'Search'.
	searchModeDropList := self newDropList
		                      display: [ :search | search name ];
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
StFinderSearchBar >> whenSearchModeChangedDo: aOneArgumentBlock [
	"aOneArgumentBlock gets the new search mode passed as the argument."

	searchModeDropList whenSelectedItemChangedDo: aOneArgumentBlock
]

{ #category : #events }
StFinderSearchBar >> whenSubmitSearchDo: aOneArgumentBlock [
	"aOneArgumentBlock gets the search text passed as the argument."

	searchInput whenSubmitDo: aOneArgumentBlock
]
