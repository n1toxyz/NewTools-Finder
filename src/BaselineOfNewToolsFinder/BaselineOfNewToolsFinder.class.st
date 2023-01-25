Class {
	#name : #BaselineOfNewToolsFinder,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewToolsFinder
}

{ #category : #baselines }
BaselineOfNewToolsFinder >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: #'NewTools-Finder';
			package: #'NewTools-Finder-Tests'
			with: [ spec requires: #( #'NewTool-Finder' ) ] ]
]
