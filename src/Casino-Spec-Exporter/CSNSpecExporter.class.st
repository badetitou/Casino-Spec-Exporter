Class {
	#name : #CSNSpecExporter,
	#superclass : #BLModelExporter,
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #visiting }
CSNSpecExporter >> exportedPackageName [
	^ 'Casino-Exported'
]

{ #category : #visiting }
CSNSpecExporter >> prefix [
	^ 'CSNExported'
]

{ #category : #visiting }
CSNSpecExporter >> prepareExport [
	RPackageOrganizer default createPackageNamed: self exportedPackageName
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: BLUIPanel ] thenCollect: #name.
]

{ #category : #visiting }
CSNSpecExporter >> visitBLCell: aBLCell [
	^ self visit: aBLCell widget
]

{ #category : #visiting }
CSNSpecExporter >> visitBLLayout: aBLLayout [
	^ aBLLayout cell flatCollect: [ :cell | self visit: cell ]
]

{ #category : #visiting }
CSNSpecExporter >> visitBLPage: aBLPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , aBLPage name
		instanceVariableNames: '', ((self recursiveLocalWidgetNameOfPage: aBLPage) flatCollect: [:name | name uncapitalized, ' '])
		classVariableNames: ''
		package: self exportedPackageName.
	class class
		compile:
			'open
	<example>
	^ self new openWithSpec'.
	class class
		compile:
			'defaultSpec
	<spec: #default>
	^ SpecLayout composed '
				, (aBLPage widgets flatCollect: [ :widget | self visit: widget ])
				,
					'; 
				yourself'
]

{ #category : #visiting }
CSNSpecExporter >> visitBLPageMetier: aBLBusinessPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , aBLBusinessPage name
		instanceVariableNames: '' , ((self recursiveLocalWidgetNameOfPage: aBLBusinessPage) flatCollect: [ :name | name uncapitalized , ' ' ])
		classVariableNames: ''
		package: self exportedPackageName.
	class class
		compile:
			'open
	<example>
	^ self new openWithSpec'.
	class class
		compile:
			'defaultSpec
	<spec: #default>
	^ SpecLayout composed ' , (aBLBusinessPage widgets flatCollect: [ :widget | self visit: widget ])
				,
					'; 
				yourself'.
	^ self visitBLWidget: aBLBusinessPage
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIHorizontalLayout: aBLUIHorizontalLayout [
	| localVariableName |
	localVariableName := 'row' , aBLUIHorizontalLayout mooseName.
	^ 'newRow: [ :' , localVariableName
		,
			' |
		'
		,
			(aBLUIHorizontalLayout cell
				flatCollect: [ :cell | localVariableName ,' ', (self visit: cell) , '.' ])
		,
			'
		]'
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIPanel: aBLUIPanel [
	^ aBLUIPanel layout ifNotNil: [ self visit: aBLUIPanel layout ] ifNil: [ '' ]
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIVerticalLayout: aBLUIVerticalLayout [
	| localVariableName |
	localVariableName := 'col' , aBLUIVerticalLayout mooseName.
	^ 'newColumn: [ :' , localVariableName
		,
			' |
		'
		,
			(aBLUIVerticalLayout cell
				flatCollect: [ :cell | localVariableName , ' ', (self visit: cell) , '.' ])
		,
			'
		]'
]

{ #category : #visiting }
CSNSpecExporter >> visitBLWidget: aBLWidget [
	^ 'add: #', (aBLWidget name ifNil: [ 'widget', aBLWidget mooseID asString] ifNotNil: [ aBLWidget name ])
]

{ #category : #visiting }
CSNSpecExporter >> visitMooseModel: aMooseModel [
	aMooseModel allBLPhase do: [ :phase | self visit: phase ]
]
