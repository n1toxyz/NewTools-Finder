"
I am a presenter for `StFinderResult`s. For a given `StFinderResult` I will be a
complimenting presentation of it.
"
Class {
	#name : #StFinderResultPresenterProvider,
	#superclass : #Object,
	#instVars : [
		'codePresenter',
		'nullPresenter'
	],
	#category : #'NewTools-Finder-Result'
}

{ #category : #construction }
StFinderResultPresenterProvider >> classResultPresenterFor: aStFinderResult [

	| class |
	class := aStFinderResult content.
	aStFinderResult hasSelectorParent
		ifTrue: [
			| selector |
			selector := aStFinderResult parent content.
			self codePresenter
				beForMethod: (class methodNamed: selector);
				text: (class sourceCodeAt: selector) ]
		ifFalse: [
			self codePresenter
				beForBehavior: class;
				text: class definitionString ].

	^ self codePresenter
]

{ #category : #accessing }
StFinderResultPresenterProvider >> codePresenter [

	^ codePresenter ifNil: [ codePresenter := SpCodePresenter new ]
]

{ #category : #initialization }
StFinderResultPresenterProvider >> initialize [

	nullPresenter := SpNullPresenter new
]

{ #category : #accessing }
StFinderResultPresenterProvider >> nullPresenter [

	^ nullPresenter
]

{ #category : #construction }
StFinderResultPresenterProvider >> pragmaResultPresenterFor: aStFinderResult [

	self notYetImplemented
]

{ #category : #construction }
StFinderResultPresenterProvider >> presenterFor: aStFinderResult [
	"Returns a suitable SpPresenter for aStFinderResult.

	The returned presenter when displayed will show the contents of aStFinderResult."

	aStFinderResult isClassResult ifTrue: [
		^ self classResultPresenterFor: aStFinderResult ].
	aStFinderResult isSelectorResult ifTrue: [
		^ self selectorResultPresenterFor: aStFinderResult ].
	aStFinderResult isPragmaResult ifTrue: [
		^ self pragmaResultPresenterFor: aStFinderResult ].

	^ self nullPresenter
]

{ #category : #construction }
StFinderResultPresenterProvider >> selectorResultPresenterFor: aStFinderResult [

	| selector |
	selector := aStFinderResult content.

	aStFinderResult hasClassParent
		ifTrue: [
			| class |
			class := aStFinderResult parent content.
			self codePresenter
				beForMethod: (class methodNamed: selector);
				text: (class sourceCodeAt: selector).

			^ self codePresenter ].

	^ self nullPresenter
]
