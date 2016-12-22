job('madcore.kubectl.create') {
    parameters {
	    stringParam('FILENAME', '', '')
    }

    steps {
        def command = """#!/bin/bash
pushd /opt/madcore/kubernetes/kubectl
    bash create.sh "/opt/plugins/pods/\$FILENAME"
popd
"""
        shell(command)
    }
}
