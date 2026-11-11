pipeline {
  agent  {
    label 'build-jenkins-base'
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    CI = 'true'
  }

  stages {
    stage('Bash Syntax') {
      steps {
        sh 'chmod +x .ci/*.sh && .ci/lint-bash-syntax.sh'
      }
    }

    stage('ShellCheck') {
      steps {
        sh '.ci/lint-shellcheck.sh'
      }
    }

    stage('Policy Validation') {
      steps {
        sh '.ci/verify-workshop-policy.sh'
      }
    }

    stage('Lifecycle Smoke Tests') {
      steps {
        sh '.ci/smoke-local-lifecycle.sh'
      }
    }

    stage('Optional External Checks') {
      when {
        expression { env.RUN_EXTERNAL_SKILL_CHECKS == 'true' }
      }
      steps {
        sh '.ci/smoke-external-references.sh'
      }
    }
  }

  post {
    always {
      echo 'Pipeline completed.'
    }
  }
}
