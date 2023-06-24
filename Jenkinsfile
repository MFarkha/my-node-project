node {
    def mybuild = docker.build 'mybuild:1.0'
    
    stage 'increment version'{
        mybuild.inside {
            checkout scm
            dir("app") {
                sh "npm version minor"
                def packageJson = readJSON file: 'package.json'
                def version = packageJson.version
                env.IMAGE_NAME = "my-node-app-${version}-${BUILD_NUMBER}"
            }
        }
    }
    stage 'run tests and install' {
        mybuild.inside {
            sh 'ls -la .'
            // sh 'npm install'
        }
    }
}
//     def maven = docker.image('maven:3.3.9-jdk-8'); // https://registry.hub.docker.com/_/maven/

//     stage('Mirror') {
//     // First make sure the slave has this image.
//     // (If you could set your registry below to mirror Docker Hub,
//     // this would be unnecessary as maven.inside would pull the image.)
//         maven.pull()
//     }

//   // We are pushing to a private secure Docker registry in this demo.
//   // 'docker-registry-login' is the username/password credentials ID as defined in Jenkins Credentials.
//   // This is used to authenticate the Docker client to the registry.
//     docker.withRegistry('https://localhost/', 'docker-registry-login') {

//     stage('Build') {
//       // Spin up a Maven container to build the petclinic app from source.
//       // First set up a shared Maven repo so we don't need to download all dependencies on every build.
//       maven.inside {
//         sh "mvn -o -Dmaven.repo.local=${pwd tmp: true}/m2repo -f app -B -DskipTests clean package"
//         // The app .war and Dockerfile are now available in the workspace. See below.
//       }
//     }

//     def pcImg
//     stage('Bake Docker image') {
//       // Use the spring-petclinic Dockerfile (see above 'maven.inside()' block)
//       // to build a container that can run the app.
//       // The Dockerfile is in the app subdir of the active workspace
//       // (see above maven.inside() block), so we specify that.
//       // The Dockerfile expects the petclinic.war file to be in the 'target' dir
//       // relative to its own directory, which will be the case.
//       pcImg = docker.build("examplecorp/spring-petclinic:${env.BUILD_TAG}", 'app')

//       // Let us tag and push the newly built image. Will tag using the image name provided
//       // in the 'docker.build' call above (which included the build number on the tag).
//       pcImg.push();
//     }

//     stage('Test Image') {
//       // Spin up a Maven + Xvnc test container, linking it to the petclinic app container
//       // allowing the Maven tests to send HTTP requests between the containers.
//       def testImg = docker.build('examplecorp/spring-petclinic-tests:snapshot', 'test')
//       // Run the petclinic app in its own Docker container.
//       pcImg.withRun {petclinic ->
//         testImg.inside("--link=${petclinic.id}:petclinic") {
//           // https://github.com/jenkinsci/workflow-plugin/blob/master/basic-steps/CORE-STEPS.md#build-wrappers
//           wrap([$class: 'Xvnc', takeScreenshot: true, useXauthority: true]) {
//             sh "mvn -o -Dmaven.repo.local=${pwd tmp: true}/m2repo -f test -B clean test"
//           }
//         }
//       }
//       input "How do you like ${env.BUILD_URL}artifact/screenshot.jpg?"
//     }

//     stage('Promote Image') {
//       // All the tests passed. We can now retag and push the 'latest' image.
//       pcImg.push('latest')
//     }
//   }
// }



// pipeline {
//     // script {
//     //     node {
//     //         sh 'sudo chmod 666 /var/run/docker.sock'
//     //     }
//     // }
//     agent {
//         dockerfile {
//             // label 'agent5'
//             args "--group-add=115 -v /var/run/docker.sock:/var/run/docker.sock -e AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION} -e AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY} -e AWS_ACCESS_KEY=${env.AWS_ACCESS_KEY}"
//         }
//     }
//     stages {
//         stage('increment version') {
//             steps {
//                 script {
//                     // # enter app directory, because that's where package.json is located
//                     dir("app") {
//                     //     // # update application version in the package.json file with one of these release types: patch, minor or major
//                     //     // # this will commit the version update
//                         sh "npm version minor"
//                         // # read the updated version from the package.json file
//                         def packageJson = readJSON file: 'package.json'
//                         def version = packageJson.version
//                         // # set the new version as part of IMAGE_NAME
//                     //     env.IMAGE_NAME = "my-node-app-$version-$BUILD_NUMBER"
//                     // alternative solution without Pipeline Utility Steps plugin: 
//                         // def version = sh (returnStdout: true, script: "grep 'version' package.json | cut -d '\"' -f4 | tr '\\n' '\\0'")
//                         env.IMAGE_NAME = "my-node-app-${version}-${BUILD_NUMBER}"
//                     }
//                 }
//             }
//         }
//         stage('Run tests') {
//             steps {
//                script {
//                     // # enter app directory, because that's where package.json and tests are located
//                     dir("app") {
//                         // # install all dependencies needed for running tests
//                         // sh "export npm_config_cache=npm-cache"
//                         sh "npm install"
//                         // sh "npm run test"
//                     }
//                }
//             }
//         }
//         stage('Build and Push docker image into AWS ECR') {
//             steps {
//                 script {
//                     // sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'
//                     // docker.withRegistry('https://146966035049.dkr.ecr.ca-central-1.amazonaws.com', 'ecr-credentials') {
//                     //     dir("app"){
//                     //         docker.build("famaten:${IMAGE_NAME}").push()
//                     //     }
//                     // }
//                     // sh 'printenv | grep AWS'
//                     // sh 'aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 146966035049.dkr.ecr.ca-central-1.amazonaws.com'
//                     // dir("app") {
//                     //     sh "docker build -t 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME} ."
//                     //     sh "docker push 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME}"
//                     // }
//                     docker.withRegistry('https://146966035049.dkr.ecr.ca-central-1.amazonaws.com') {
//                         dir("app"){
//                             docker.build("famaten:${IMAGE_NAME}").push()
//                         }
//                     }
//                     // withCredentials([usernamePassword(credentialsId: 'ecr-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]){
//                     //     sh "docker build -t 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME} ."
//                     //     sh 'echo $PASS | docker login --username AWS --password-stdin 146966035049.dkr.ecr.ca-central-1.amazonaws.com'
//                     //     sh "docker push 146966035049.dkr.ecr.ca-central-1.amazonaws.com/famaten:${IMAGE_NAME}"
//                     // }
//                 }
//             }
//         }
//         stage('commit version update') {
//             steps {
//                 script {
//                     withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
//                         // # git config here for the first time run
//                         sh 'git config --global user.email "jenkins@example.com"'
//                         sh 'git config --global user.name "jenkins"'
//                         sh 'git remote set-url origin https://$USER:$PASS@github.com/MFarkha/my-node-project.git'
//                         sh 'git add .'
//                         sh 'git commit -m "ci: version bump"'
//                         // sh 'git push origin HEAD:jenkins-jobs'
//                         sh 'git push origin HEAD:master'
//                     }
//                 }
//             }
//         }
//     }
// }