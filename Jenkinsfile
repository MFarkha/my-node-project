pipeline {
    agent any
    tools {
        nodejs "node"
    }
    stages {
        // stage('increment version') {
        //     steps {
        //         script {
        //             // # enter app directory, because that's where package.json is located
        //             dir("app") {
        //                 // # update application version in the package.json file with one of these release types: patch, minor or major
        //                 // # this will commit the version update
        //                 npm version minor

        //                 // # read the updated version from the package.json file
        //                 def packageJson = readJSON file: 'package.json'
        //                 def version = packageJson.version

        //                 // # set the new version as part of IMAGE_NAME
        //                 env.IMAGE_NAME = "my-node-app-$version-$BUILD_NUMBER"
        //             }

        //             // # alternative solution without Pipeline Utility Steps plugin: 
        //             // # def version = sh (returnStdout: true, script: "grep 'version' package.json | cut -d '\"' -f4 | tr '\\n' '\\0'")
        //             // # env.IMAGE_NAME = "$version-$BUILD_NUMBER"
        //         }
        //     }
        // }
        stage('Run tests') {
            steps {
               script {
                    // # enter app directory, because that's where package.json and tests are located
                    dir("app") {
                        // # install all dependencies needed for running tests
                        env.IMAGE_NAME = "my-node-app-1.1.0-$BUILD_NUMBER"
                        sh "npm install"
                        // sh "npm run test"
                    } 
               }
            }
        }
        stage('Build and Push docker image into AWS ECR') {
            steps {
                // sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'
                // // configure registry
                // docker.withRegistry('https://146966035049.dkr.ecr.ca-central-1.amazonaws.com', 'ecr:eu-west-1:86c8f5ec-1ce1-4e94-80c2-18e23bbd724a') {

                //     // build image
                //     def customImage = docker.build("${IMAGE_NAME}")

                //     // push image
                //     customImage.push()
                // }

                withCredentials([usernamePassword(credentialsId: 'ecr-credentials', usernameVariable: 'USER', passwordVariable: 'PWD')]){
                    sh 'echo ${PWD} | docker login --username AWS --password-stdin 146966035049.dkr.ecr.ca-central-1.amazonaws.com'
                    sh "docker build -t 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME} ."
                    sh "docker push 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME}"
                }
            }
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PWD')]) {
                        // # git config here for the first time run
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${USER}:${PWD}@https://github.com/MFarkha/my-node-project.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}