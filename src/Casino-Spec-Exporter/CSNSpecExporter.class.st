Class {
	#name : #CSNSpecExporter,
	#superclass : #BLModelExporter,
	#instVars : [
		'initializeWidgetsExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #visiting }
CSNSpecExporter >> createAccessorForVariable: each inClass: class [
	"generate the getter and the setter"

	"getter"

	class compile: '' , each , String crlf , String tab , '^ ' , each.
	"setter"
	class compile: '' , each, ': anObject' , String crlf , String tab , each, ' := anObject'.
]

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
	RPackageOrganizer default createPackageNamed: self exportedPackageName.
	initializeWidgetsExporter := CSNSpecInitializeWidgetsExporter new mainExporter: self; yourself
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfBLBusinessPage: aBLBuisinessPage [
	^  (self recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage) collect: #name
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfPage: aBLPage [
	^ (self recursiveLocalWidgetOfPage: aBLPage) collect: #name.
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage [
	^ (aBLBuisinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: BLUIPanel ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: BLUIPanel ]
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
		instanceVariableNames:
			''
				,
					((self recursiveLocalWidgetNameOfPage: aBLPage)
						flatCollect: [ :name | name uncapitalized , ' ' ])
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
	^ SpecLayout composed ' , (aBLPage widgets flatCollect: [ :widget | self visit: widget ])
				,
					'; 
				yourself'.
	class
		compile: 'title' , String crlf , String tab , '^ ' , (aBLPage title ifNil: [ '''''' ]).
	class instanceVariables
		do: [ :each | self createAccessorForVariable: each inClass: class ].
	initializeWidgetsExporter exportInitializeWidgetOfPage: aBLPage inClass: class
]

{ #category : #visiting }
CSNSpecExporter >> visitBLPageMetier: aBLBusinessPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , aBLBusinessPage name capitalized
		instanceVariableNames:
			''
				,
					((self recursiveLocalWidgetNameOfBLBusinessPage: aBLBusinessPage)
						flatCollect: [ :name | name uncapitalized , ' ' ])
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
				, (aBLBusinessPage widgets flatCollect: [ :widget | self visit: widget ])
				,
					'; 
				yourself'.
	class instanceVariables
		do: [ :each | self createAccessorForVariable: each inClass: class ].
	class
		compile: 'title' , String crlf , String tab , '^ ' , (aBLBusinessPage title ifNil: [ '''''' ]).
	initializeWidgetsExporter
		exportInitializeWidgetOfBusinessPage: aBLBusinessPage
		inClass: class.
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
	^ 'add: #' , (aBLWidget name uncapitalized) 
]

{ #category : #visiting }
CSNSpecExporter >> visitMooseModel: aMooseModel [
	aMooseModel allBLPhase do: [ :phase | self visit: phase ]
]
