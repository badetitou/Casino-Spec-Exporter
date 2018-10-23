Extension { #name : #BLWidget }

{ #category : #'*Casino-Spec-Exporter' }
BLWidget >> localWidgets [
	"The widget inside this widget except the widgets inside a Business Page"
	^ {}
	
]

{ #category : #'*Casino-Spec-Exporter' }
BLWidget >> name [
	^ name ifNil: [ 'widget', self mooseID asString  ] 
]
