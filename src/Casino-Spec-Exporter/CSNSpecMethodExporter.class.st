Class {
	#name : #CSNSpecMethodExporter,
	#superclass : #CSNModelExporter,
	#instVars : [
		'mainExporter'
	],
	#category : #'Casino-Spec-Exporter-Exporter'
}

{ #category : #accessing }
CSNSpecMethodExporter >> computeWidgetName: aWidget [
	^ self mainExporter computeAcceptedNameForVariableFrom: aWidget name
]

{ #category : #accessing }
CSNSpecMethodExporter >> mainExporter [
	^ mainExporter
]

{ #category : #accessing }
CSNSpecMethodExporter >> mainExporter: anObject [
	mainExporter := anObject
]

{ #category : #'private - utilities' }
CSNSpecMethodExporter >> protectString: aString [
	^ self mainExporter protectString: aString
]

{ #category : #accessing }
CSNSpecMethodExporter >> recursiveLocalWidgetOfBLBusinessPage: aBLBusinessPage [
	^ (aBLBusinessPage widgets collect: #localWidgets) flattened
		reject: [ :widget | widget isKindOf: CSNUIPanel ]
]

{ #category : #accessing }
CSNSpecMethodExporter >> recursiveLocalWidgetOfPage: aBLPage [
	^ aBLPage localWidgets flattened reject: [:widget | widget isKindOf: CSNUIPanel ]
]
