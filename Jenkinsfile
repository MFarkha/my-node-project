node {
    def mybuild
    def AWS_REGISTRY = 'https://146966035049.dkr.ecr.ca-central-1.amazonaws.com'
    def DOCKER_GROUP_ID = sh (returnStdout: true, script: "stat -c %g /var/run/docker.sock")
 
    stage('init and prepare build environment'){
        checkout scm
        mybuild = docker.build 'mybuild:1.0'
    }

    stage ('increment version'){
        mybuild.inside {
            checkout scm
            dir("app") {
                sh "npm version minor"
                def packageJson = readJSON file: 'package.json'
                def version = packageJson.version
                // def version = sh (returnStdout: true, script: "grep 'version' package.json | cut -d '\"' -f4 | tr '\\n' '\\0'")
                env.IMAGE_NAME = "my-node-app-${version}-${BUILD_NUMBER}"
            }
        }
    }

    stage ('run tests and install') {
        mybuild.inside {
            dir("app") {
                sh 'npm install'
            }
        }
    }

    stage('build and push docker image into AWS ECR') {
        mybuild.inside("--group-add=${DOCKER_GROUP_ID} -v /var/run/docker.sock:/var/run/docker.sock -e AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION} -e AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY} -e AWS_ACCESS_KEY=${env.AWS_ACCESS_KEY}") {
            dir("app") {
                docker.withRegistry("${AWS_REGISTRY}") {
                    docker.build("famaten:${IMAGE_NAME}").push()
                }
            }
        }
    }

    stage('increment version') {
        mybuild.inside {
            withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                sh 'git config --global user.email "jenkins@example.com"'
                sh 'git config --global user.name "jenkins"'
                sh 'git remote set-url origin https://$USER:$PASS@github.com/MFarkha/my-node-project.git'
                sh 'git add .'
                sh 'git commit -m "ci: version bump"'
                sh 'git push origin HEAD:alt_groovy-Jenkinsfile'
            }
        }
    }
}