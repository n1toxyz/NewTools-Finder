"
I am the model for the `Finder` tool.

I am responsible for holding the search environment, executing searches and
returning search results.

For searching I use the interface defined by ̀FinderSearch̀ and all searches
should therefor be subclasses of ̀FinderSearch̀.

"
Class {
	#name : #StFinderModel,
	#superclass : #Model,
	#instVars : [
		'searchString',
		'useRegex',
		'environment',
		'searchEnvironment',
		'availableSearches',
		'currentSearch',
		'results'
	],
	#category : #'NewTools-Finder-Core'
}

{ #category : #'default values' }
StFinderModel class >> defaultSearches [
	"Returns a list of supported searches. Each item in the list is a subclass of `FinderSearch`."

	"The first element is used as the default search mode."

	^ {
		  StFinderSelectorSearch.
		  StFinderClassSearch.
		StFinderPragmaSearch }
]

{ #category : #adding }
StFinderModel >> addSearch: aFinderSearch [
	"Add aFinderSearch to the availableSearches."

	availableSearches add: aFinderSearch.
	self searchTypesChanged
]

{ #category : #information }
StFinderModel >> availablePackages [

	"Returns for searching available packages by name."

	^ environment packages
		  collect: [ :package | package name ]
		  as: OrderedCollection
]

{ #category : #accessing }
StFinderModel >> availableSearches [

	"Returns the searches available to the model. The first one is used as the default search mode."

	^ availableSearches
]

{ #category : #accessing }
StFinderModel >> currentSearch [

	"Returns the current search used by the model."

	^ currentSearch
]

{ #category : #accessing }
StFinderModel >> currentSearch: aSearch [

	"Sets the search used by the model to aSearch. aSearch should be one of the availableSearches."

	currentSearch := aSearch
]

{ #category : #initialization }
StFinderModel >> initialize [

	super initialize.
	searchString := ''.
	results := StFinderResult new.
	useRegex := false.

	availableSearches := self class defaultSearches
		                     collect: [ :search | search new ]
		                     as: OrderedCollection.
	currentSearch := availableSearches first.

	environment := RBBrowserEnvironment new.
	self selectAllPackages
]

{ #category : #removing }
StFinderModel >> removeSearchByName: aString [
	"Removes a search from availableSearches by its name."

	availableSearches removeAllSuchThat: [ :each | each name = aString ].
	self searchTypesChanged
]

{ #category : #accessing }
StFinderModel >> results [

	^ results
]

{ #category : #searching }
StFinderModel >> search [
	"Performs a search and stores the results in `self resultsDictionary`."

	searchString isEmpty ifTrue: [ ^ self ].

	[ :job |
	self searchStarted.
	job title: 'Searching...' translated.
	results := useRegex
		                     ifTrue: [
		                     currentSearch
			                     searchByRegex: searchString asRegex
			                     in: environment ]
		                     ifFalse: [
		                     currentSearch
			                     searchByString: searchString
			                     in: environment ].
	self searchEnded ] asJob run
]

{ #category : #searching }
StFinderModel >> searchBy: aString [

	"Perform a search by aString."

	self searchString: aString.
	self search
]

{ #category : #announcing }
StFinderModel >> searchEnded [
	"Announce the start of a new search."

	"This method is used internally and called whenever a search has finished."

	self announcer announce:
		(StFinderSearchEnded results: self results)
]

{ #category : #announcing }
StFinderModel >> searchStarted [
	"Announce the start of a new search."

	"This method is used internally and called whenever a search is started."

	self announcer announce: StFinderSearchStarted new
]

{ #category : #accessing }
StFinderModel >> searchString [

	"Return the current search string."

	^ searchString
]

{ #category : #accessing }
StFinderModel >> searchString: aString [

	"Set the search string, which is to be used for further searches."

	searchString := aString
]

{ #category : #announcing }
StFinderModel >> searchTypesChanged [
	"Announce a modification of availableSearches."

	"This method is used internally and called whenever a availableSearches modified."

	self announcer announce:
		(StFinderSearchTypesChanged newValue: self availableSearches)
]

{ #category : #selection }
StFinderModel >> selectAllPackages [

	"Selects all packages for searching."

	searchEnvironment := environment forPackages: environment packages
]

{ #category : #information }
StFinderModel >> selectedPackages [

	"Returns for searching selected packages by name."

	^ searchEnvironment packageNames asOrderedCollection
]

{ #category : #selection }
StFinderModel >> selectedPackagesByName: aCollection [

	"Selects all packages given in aCollection by their names for searching."

	searchEnvironment := environment forPackageNames: aCollection
]

{ #category : #information }
StFinderModel >> unselectedPackages [

	"Returns for searching unselected packages by name."

	^ self availablePackages removeAllFoundIn: self selectedPackages
]

{ #category : #accessing }
StFinderModel >> useRegex [

	^ useRegex
]

{ #category : #accessing }
StFinderModel >> useRegex: aBoolean [

	useRegex := aBoolean
]

{ #category : #announcing }
StFinderModel >> whenSearchEnded: aBlock [
	"Calls aBlock everytime a search has ended and passes the results to it."

	"Culled block [ :results :announcement :announcer | ... ]"

	| block |
	block := [ :announcement :ann |
	         aBlock
		         cull: announcement results
		         cull: announcement
		         cull: ann ].
	self announcer when: StFinderSearchEnded do: block
]

{ #category : #announcing }
StFinderModel >> whenSearchStarted: aBlock [
	"Calls aBlock everytime a search is started."

	"aBlock [ :announcement :announcer | ... ]"

	self announcer when: StFinderSearchStarted do: aBlock
]

{ #category : #announcing }
StFinderModel >> whenSearchTypesChanged: aBlock [
	"Calls aBlock everytime a search has been added or removed from availableSearches."

	"Culled block [ :newValue oldValue :announcement :announcer | ... ]"

	| block |
	block := [ :announcement :ann |
	         aBlock
		         cull: announcement newValue
		         cull: announcement oldValue
		         cull: announcement
		         cull: ann ].
	self announcer when: StFinderSearchTypesChanged do: aBlock
]
