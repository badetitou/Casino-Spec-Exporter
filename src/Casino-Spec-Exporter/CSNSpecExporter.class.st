Class {
	#name : #CSNSpecExporter,
	#superclass : #BLModelExporter,
	#instVars : [
		'initializeWidgetsExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #'private - utilities' }
CSNSpecExporter >> computeAcceptedNameForClassFrom: aString [
	^ (aString capitalized copyReplaceAll: ' ' with: '') copyReplaceAll: '-' with: '_' 
]

{ #category : #'private - utilities' }
CSNSpecExporter >> computeAcceptedNameForVariableFrom: aString [
	^ (aString uncapitalized copyReplaceAll: '(' with: '') copyReplaceAll: ')' with: ''
]

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

{ #category : #'private - utilities' }
CSNSpecExporter >> protectString: aString [
	^ aString copyReplaceAll: '''' with: ''''''
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfBLBusinessPage: aBLBuisinessPage [
	^ (self recursiveLocalWidgetOfBLBusinessPage: aBLBuisinessPage) collect: [ :widget | self computeAcceptedNameForVariableFrom: widget name ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetNameOfPage: aBLPage [
	^ (self recursiveLocalWidgetOfPage: aBLPage) reject: #isNil thenCollect: [:widget | self computeAcceptedNameForVariableFrom: widget name ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBusinessPage [
	^ (aBLBusinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: BLUIPanel ]
]

{ #category : #visiting }
CSNSpecExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: BLUIPanel ]
]

{ #category : #visiting }
CSNSpecExporter >> visitBLAttribute: aBLAttribute [
	^ ''
]

{ #category : #visiting }
CSNSpecExporter >> visitBLCell: aBLCell [
 	^ aBLCell widget ifNil: [ '' ] ifNotNil: [ self visit: aBLCell widget ] 
]

{ #category : #visiting }
CSNSpecExporter >> visitBLLayout: aBLLayout [

	^ self visitBLUIVerticalLayout: aBLLayout
]

{ #category : #visiting }
CSNSpecExporter >> visitBLPage: aBLPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , (self computeAcceptedNameForClassFrom: aBLPage name)
		instanceVariableNames: '' , ((self recursiveLocalWidgetNameOfPage: aBLPage) flatCollect: [ :name | name uncapitalized , ' ' ])
		classVariableNames: ''
		package: self exportedPackageName , '-Page'.
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
				,
					({aBLPage widgets.
					aBLPage businessPage} flatten flatCollect: [ :widget | ('' , (self visit: widget) removeSuffix: ';') ifEmpty: [ '' ] ifNotEmpty: [ :result | result , ';' , String crlf ] ])
				,
					'
				yourself'.
	class compile: 'title' , String crlf , String tab , '^ ' , ('''' , (self protectString: (aBLPage title ifNil: [ '' ])) , '''').
	class instanceVariables do: [ :each | self createAccessorForVariable: each inClass: class ].
	initializeWidgetsExporter exportInitializeWidgetOfPage: aBLPage inClass: class.
	^ self visitBLWidget: aBLPage
]

{ #category : #visiting }
CSNSpecExporter >> visitBLPageMetier: aBLBusinessPage [
	| class |
	class := ComposablePresenter
		subclass: self prefix , (aBLBusinessPage name capitalized , aBLBusinessPage mooseID asString)
		instanceVariableNames: '' , ((self recursiveLocalWidgetNameOfBLBusinessPage: aBLBusinessPage) flatCollect: [ :name | name uncapitalized , ' ' ])
		classVariableNames: ''
		package: self exportedPackageName , '-Components'.
	class class
		compile:
			'open
	<example>
	^ self new openWithSpec'.
	class class
		compile:
			'defaultSpec
	<spec: #default>
	^ SpecLayout composed ' , (aBLBusinessPage widgets flatCollect: [ :widget | ('' , (self visit: widget) removeSuffix: ';') ifEmpty: [ '' ] ifNotEmpty: [ :result | result, ';', String crlf ] ])
				,
					'
				yourself'.
	class instanceVariables do: [ :each | self createAccessorForVariable: each inClass: class ].
	class compile: 'title' , String crlf , String tab , '^ ' , ('''' , (self protectString: (aBLBusinessPage title ifNil: [ '' ])) , '''').
	initializeWidgetsExporter exportInitializeWidgetOfBusinessPage: aBLBusinessPage inClass: class.
	^ self visitBLWidget: aBLBusinessPage
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIAbsoluteHeight: aBLUIAbsoluteHeight [
	^ aBLUIAbsoluteHeight attributeValue onlyNumbers
		ifEmpty: [ self visitBLAttribute: aBLUIAbsoluteHeight ]
		ifNotEmpty: [ aBLUIAbsoluteHeight name , ': ' , aBLUIAbsoluteHeight attributeValue onlyNumbers , ';' ]
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIAbsoluteWidth: aBLUIAbsoluteWidth [
	^ aBLUIAbsoluteWidth attributeValue onlyNumbers
		ifEmpty: [ self visitBLAttribute: aBLUIAbsoluteWidth ]
		ifNotEmpty: [ aBLUIAbsoluteWidth name , ': ' , aBLUIAbsoluteWidth attributeValue onlyNumbers , ';' ]
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIContainer: aBLUIContainer [
	^ (aBLUIContainer layout
		ifNotNil: [ self visit: aBLUIContainer layout ]
		ifNil: [ aBLUIContainer widgets flatCollect: [ :widget | '',(self visit: widget) removeSuffix: ';' ] ])
		,
			(aBLUIContainer attributes
				ifEmpty: [ '' ]
				ifNotEmpty: [ :attributes | 
					(attributes flatCollect: [ :attribute | self visit: attribute ])
						ifNotEmpty: [ :od | 
							od
								removeLast;
								yourself ] ])
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIHorizontalLayout: aBLUIHorizontalLayout [
	| localVariableName |
	localVariableName := 'row'
		, (self computeAcceptedNameForVariableFrom: aBLUIHorizontalLayout mooseName , aBLUIHorizontalLayout mooseID asString).
	^ 'newRow: [ :' , localVariableName
		,
			' |
		'
		,
			(aBLUIHorizontalLayout cell
				flatCollect: [ :cell | 
					localVariableName , ' ' , ('' , (self visit: cell) removeSuffix: ';')
						,
							'.
			' indentBy: 4 ])
		,
			'
			]
		'
]

{ #category : #visiting }
CSNSpecExporter >> visitBLUIVerticalLayout: aBLUIVerticalLayout [
	| localVariableName |
	localVariableName := 'col' , (self computeAcceptedNameForVariableFrom: (aBLUIVerticalLayout mooseName, aBLUIVerticalLayout mooseID asString)).
	^ 'newColumn: [ :' , localVariableName
		,
			' |
		'
		,
			(aBLUIVerticalLayout cell
				flatCollect: [ :cell | 
					localVariableName , ' ' , ('',(self visit: cell)removeSuffix: ';')
						,
							'.
			' indentBy: 4 ])
		,
			'
		]
	'
]

{ #category : #visiting }
CSNSpecExporter >> visitBLWidget: aBLWidget [
	^ ' add: #' , (self computeAcceptedNameForVariableFrom: aBLWidget name uncapitalized) , ' ' , (aBLWidget attributes flatCollect: [ :attribute | self visit: attribute ])
]

{ #category : #visiting }
CSNSpecExporter >> visitMooseModel: aMooseModel [
	aMooseModel allBLPage do: [ :phase | self visit: phase ]
]
