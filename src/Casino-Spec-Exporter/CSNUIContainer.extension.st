Extension { #name : #CSNUIContainer }

{ #category : #'*Casino-Spec-Exporter' }
CSNUIContainer >> localWidgets [
	"The widget inside this widget except the widgets inside a Business Page"

	^ {(widgets , (widgets collect: #localWidgets)
		, (self layout ifNotNil: [ :lay | {((lay cell collect: #widget thenReject: #isNil) , (lay cell reject: [ :el | el widget isNil ] thenCollect: [ :cell | cell widget localWidgets ]))} ] ifNil: [ {} ]))}
]
