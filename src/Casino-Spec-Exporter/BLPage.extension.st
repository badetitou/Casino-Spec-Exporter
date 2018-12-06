Extension { #name : #BLPage }

{ #category : #'*Casino-Spec-Exporter' }
BLPage >> localWidgets [
	"The widget inside this widget except the widgets inside a Business Page"
	| entities |
	entities := { widgets. businessPage } flattened.
	^ {(entities , (entities collect: #localWidgets)
		, (self layout ifNotNil: [ :lay | {((lay cell collect: #widget thenReject: #isNil) , (lay cell reject: [ :el | el widget isNil ] thenCollect: [ :cell | cell widget localWidgets ]))} ] ifNil: [ {} ]))}
]
