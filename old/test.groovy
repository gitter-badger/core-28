job('test_job') {
    parameters {
        stringParam('InstanceId', '', '')
        stringParam('StateName', '', '')        
    }
    triggers {
        cron("@minutes")
    }
    steps {
        def command = """#!/bin/bash
pushd /var/lib/jenkins/workspace/seed-dsl/madcore
    bash test.sh
popd
"""
        shell(command)
    }
}
