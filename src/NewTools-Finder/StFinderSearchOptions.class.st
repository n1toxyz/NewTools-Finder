"
I am a widget for the ̀Finder̀ tool. I contain all widgets regarding the search options.
"
Class {
	#name : #StFinderSearchOptions,
	#superclass : #SpPresenter,
	#instVars : [
		'regexpCheckBox'
	],
	#category : #'NewTools-Finder-Widgets'
}

{ #category : #layout }
StFinderSearchOptions >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  spacing: 2;
		  vAlignCenter;
		  add: regexpCheckBox;
		  yourself
]

{ #category : #initialization }
StFinderSearchOptions >> initializePresenters [

	regexpCheckBox := self newCheckBox label: 'Regexp'
]

{ #category : #events }
StFinderSearchOptions >> whenRegexActivatedDo: aBlock [

	regexpCheckBox whenActivatedDo: aBlock
]

{ #category : #events }
StFinderSearchOptions >> whenRegexDeactivatedDo: aBlock [

	regexpCheckBox whenDeactivatedDo: aBlock
]
