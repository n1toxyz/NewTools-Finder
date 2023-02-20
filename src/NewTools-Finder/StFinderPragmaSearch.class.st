"
I implement a search for pragmas in a given environment.

I am a subclass of ̀FinderSearch̀ and am used by ̀FinderModel̀ to perform searches
for selectors.

"
Class {
	#name : #StFinderPragmaSearch,
	#superclass : #StFinderSearch,
	#category : #'NewTools-Finder-Search'
}

{ #category : #private }
StFinderPragmaSearch >> buildResult: aDictionary [
	"PragmaResult
		|
		\-> n SelectorResults
				|
				\-> 1 ClassResults."

	| results isNewResult |
	results := OrderedCollection new.
	isNewResult := true.

	aDictionary keysAndValuesDo: [ :pragma :methods |
		| pragmaResult |
		"Sadly Pragmas with the same selector are not unique keys in a Dictionary."
		pragmaResult := results
			                detect: [ :result |
			                result content selector = pragma selector ]
			                ifFound: [ :result |
				                isNewResult := false.
				                result ]
			                ifNone: [ StFinderPragmaResult new content: pragma ].

		methods do: [ :method |
			| classResult |
			classResult := StFinderClassResult new content: method methodClass.
			pragmaResult children
				detect: [ :elem | elem content = method selector ]
				ifFound: [ :elem | elem addChild: classResult ]
				ifNone: [
					| selectorResult |
					selectorResult := StFinderSelectorResult new
						                  content: method selector;
						                  addChild: classResult;
						                  yourself.
					pragmaResult addChild: selectorResult ] ].

		isNewResult ifTrue: [ results add: pragmaResult ] ].

	^ results
]

{ #category : #information }
StFinderPragmaSearch >> name [
	"Returns the name of the search."

	^ 'Pragmas'
]

{ #category : #searching }
StFinderPragmaSearch >> searchByRegex: aRegex in: anEnvironment [
	"Perform a search given aRegex in anEnvironment."

	^ self buildResult: (self
			   searchPragmas: [ :pragma | aRegex search: pragma selector ]
			   in: anEnvironment)
]

{ #category : #searching }
StFinderPragmaSearch >> searchByString: aString in: anEnvironment [
	"Perform a search given aString in anEnvironment."

	^ self buildResult: (self
			   searchPragmas: [ :pragma |
				   pragma selector
					   includesSubstring:
					   (aString trimBoth: [ :c | { $< .$> } includes: c ])
					   caseSensitive: false ]
			   in: anEnvironment)
]

{ #category : #private }
StFinderPragmaSearch >> searchPragmas: aSelectBlock in: anEnvironment [

	| findings |
	findings := Dictionary new.

	anEnvironment classesAndTraitsDo: [ :class |
		class pragmasDo: [ :pragma |
			(aSelectBlock value: pragma) ifTrue: [
				(findings at: pragma selector ifAbsentPut: OrderedCollection new)
					add: pragma method ] ].
		"Include Metaclasses too, since a lot of pragmas are only found there."
		class class pragmasDo: [ :pragma |
			(aSelectBlock value: pragma) ifTrue: [
				(findings at: pragma ifAbsentPut: OrderedCollection new)
					add: pragma method ] ] ].

	^ findings
]
