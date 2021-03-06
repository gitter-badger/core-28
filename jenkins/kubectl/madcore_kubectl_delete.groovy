job('madcore.kubectl.delete') {
    parameters {
	    stringParam('FILENAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash delete.sh "/opt/plugins/pods/\$FILENAME"
popd
"""
        shell(command)
    }
}
