"
I implement a search for in the source in a given environment.

I am a subclass of ̀StFinderSelectorSearch̀ and am used by ̀StFinderModel̀ to perform searches
for selectors.

"
Class {
	#name : #StFinderSourceSearch,
	#superclass : #StFinderSelectorSearch,
	#category : #'NewTools-Finder-Search'
}

{ #category : #information }
StFinderSourceSearch >> name [
	"Returns the name of the search."

	^ 'Source'
]

{ #category : #searching }
StFinderSourceSearch >> searchByRegex: aRegex in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	^ self buildResult: (self
			   searchMethods: [ :method | aRegex search: method sourceCode ]
			   in: anEnvironment)
]

{ #category : #searching }
StFinderSourceSearch >> searchByString: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self
			   searchMethods: [ :method |
				   method sourceCode includesSubstring: aString caseSensitive: false ]
			   in: anEnvironment)
]
