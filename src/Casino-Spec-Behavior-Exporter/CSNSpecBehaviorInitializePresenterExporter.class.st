Class {
	#name : #CSNSpecBehaviorInitializePresenterExporter,
	#superclass : #CSNSpecMethodExporter,
	#traits : 'TCSNExporter + TCSNBehaviorVisitor',
	#classTraits : 'TCSNExporter classTrait + TCSNBehaviorVisitor classTrait',
	#instVars : [
		'initializeWidgetsExporter',
		'behaviorModelExporter',
		'writeStream'
	],
	#category : #'Casino-Spec-Behavior-Exporter'
}

{ #category : #export }
CSNSpecBehaviorInitializePresenterExporter >> exportInitializePresenterOfBusinessPage: aCSNBuisinessPage inClass: aClass [
	aClass
		compile:
			(String
				streamContents: [ :aStream | 
					self currentWriteStream: aStream.
					self
						<<< 'initializePresenter';
						cr;
						indent.
					(self recursiveLocalWidgetOfBLBusinessPage: aCSNBuisinessPage)
						reject: [ :widget | widget actions isEmpty ]
						thenDo: [ :widget | 
							self visit: widget.
							self
								<<< '.';
								cr ] ])
]

{ #category : #export }
CSNSpecBehaviorInitializePresenterExporter >> exportInitializePresenterOfPage: aCSNPage inClass: aClass [
	aClass
		compile:
			(String
				streamContents: [ :aStream | 
					self currentWriteStream: aStream.
					self
						<<< 'initializePresenter';
						cr.
					(self recursiveLocalWidgetOfPage: aCSNPage)
						reject: [ :widget | widget actions isEmpty ]
						thenDo: [ :widget | 
							self visit: widget.
							self
								<<< '.';
								cr ] ])
]

{ #category : #initialization }
CSNSpecBehaviorInitializePresenterExporter >> initialize [
	super initialize.
	behaviorModelExporter := self specBehaviorModelExporterClass new
]

{ #category : #accesing }
CSNSpecBehaviorInitializePresenterExporter >> specBehaviorModelExporterClass [
	^ CSNSpecBehaviorModelExporter
]

{ #category : #visiting }
CSNSpecBehaviorInitializePresenterExporter >> visitCSNAction: anAction [
	self <<< '"' <<< anAction name <<< '" yourself'
]

{ #category : #visiting }
CSNSpecBehaviorInitializePresenterExporter >> visitCSNBOnClick: aCSNBOnClick [
	self <<< 'action: ['.
	aCSNBOnClick behavior
		ifNotNil: [  ]
		ifNil: [ self <<< '"behavior not extracted"' ].
	self <<< ']'
]

{ #category : #visiting }
CSNSpecBehaviorInitializePresenterExporter >> visitCSNWidget: aCSNWidget [
	self indentPlus.
	self << (self computeWidgetName: aCSNWidget) <<< ' '.
	aCSNWidget actions do: [ :action | self visit: action ] separatedBy: [ self <<< ';' ].
	self <<< ';';
		cr;
		<< 'yourself';
		indentMinus
]

{ #category : #visiting }
CSNSpecBehaviorInitializePresenterExporter >> visitMooseModel: aMooseModel [
	self shouldNotImplement 
]
