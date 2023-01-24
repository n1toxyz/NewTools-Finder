"
A SearchEnded is an announcement raised when a search has ended.
"
Class {
	#name : #StFinderSearchEnded,
	#superclass : #Announcement,
	#instVars : [
		'results'
	],
	#category : #'NewTools-Finder-Announcement'
}

{ #category : #accessing }
StFinderSearchEnded class >> results: anObject [

	^ self new results: anObject; yourself
]

{ #category : #accessing }
StFinderSearchEnded >> results [

	^ results
]

{ #category : #accessing }
StFinderSearchEnded >> results: anObject [

	results := anObject
]
