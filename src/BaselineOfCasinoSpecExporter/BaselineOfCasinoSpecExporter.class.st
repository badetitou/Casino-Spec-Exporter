Class {
	#name : #BaselineOfCasinoSpecExporter,
	#superclass : #BaselineOf,
	#category : #BaselineOfCasinoSpecExporter
}

{ #category : #baselines }
BaselineOfCasinoSpecExporter >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfCasinoSpecExporter >> defineDependencies: spec [
	spec
		baseline: 'Casino'
		with: [ spec
				loads: 'core-extented';
				repository: 'github://badetitou/Casino:master/src' ]
]

{ #category : #baselines }
BaselineOfCasinoSpecExporter >> defineGroups: spec [
	spec
		group: 'default'
		with: #('Casino-Spec-Exporter')
]

{ #category : #baselines }
BaselineOfCasinoSpecExporter >> definePackages: spec [
	spec
		repository: 'https://github.com/badetitou/Casino-Spec-Exporter';
		package: 'BaselineOfCasinoSpecExporter';
		package: 'Casino-Spec-Exporter'
			with: [ spec requires: #('Casino') ]
]
