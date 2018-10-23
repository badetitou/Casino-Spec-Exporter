Extension { #name : #BLUIContainer }

{ #category : #'*Casino-Spec-Exporter' }
BLUIContainer >> localWidgets [
	"The widget inside this widget except the widgets inside a Business Page"

	^ {widgets, (widgets collect: #localWidgets) , (self layout ifNotNil: [ :lay | {(lay cell collect: #widget), (lay cell collect: [:cell | cell widget localWidgets ])} ] ifNil: [ {} ])}
]
