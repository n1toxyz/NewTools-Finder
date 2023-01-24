"
I implement a search for selectors in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for selectors.

"
Class {
	#name : #StFinderSelectorSearch,
	#superclass : #StFinderSearch,
	#category : #'NewTools-Finder-Search'
}

{ #category : #private }
StFinderSelectorSearch >> buildResult: aListOfMethods [

	| results |
	results := OrderedCollection new.

	aListOfMethods do: [ :method |
		| classResult |
		classResult := StFinderClassResult new content: method methodClass.
		results
			detect: [ :elem | elem content = method selector ]
			ifFound: [ :elem | elem addChild: classResult ]
			ifNone: [
				| newResult |
				newResult := StFinderSelectorResult new
					             content: method selector;
					             addChild: classResult;
					             yourself.
				results add: newResult ] ].

	^ results
]

{ #category : #information }
StFinderSelectorSearch >> name [
	"Returns the name of the search."

	^ 'Selectors'
]

{ #category : #searching }
StFinderSelectorSearch >> searchByRegex: aRegex in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	^ self buildResult: (self searchMethods: [ :method |
			   aRegex search: method selector asString ] in: anEnvironment)
]

{ #category : #searching }
StFinderSelectorSearch >> searchByString: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self searchMethods: [ :method |
			   method selector includesSubstring: aString caseSensitive: false ] in: anEnvironment)
]

{ #category : #private }
StFinderSelectorSearch >> searchMethods: aSelectBlock in: anEnvironment [

	^ OrderedCollection streamContents: [ :stream |
		  anEnvironment classesAndTraitsDo: [ :class |
			  class methodsDo: [ :method |
				  (aSelectBlock value: method) ifTrue: [ stream nextPut: method ] ].
			  class classSide methodsDo: [ :method |
				  (aSelectBlock value: method) ifTrue: [ stream nextPut: method ] ] ] ]
]
