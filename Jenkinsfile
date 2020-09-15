#! groovy
library 'pipeline-library'

stage('Build') {
	node('osx && xcode-12') {
		checkout scm
		sh './build.sh'
		dir('build/zxing-universal') {
			archiveArtifacts 'ZXingObjC.xcframework/'
		}
	}
}
