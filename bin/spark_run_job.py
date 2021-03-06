from __future__ import print_function
import sys
import os
from utils import run_cmd

NAMESPACE = 'spark-cluster'
SPARK_PATH = '/opt/spark/spark-bin'

# TODO@geo validate this
sparks_args = sys.argv[1]
# this can be
app_file_name = sys.argv[2]
app_args = sys.argv[3]

example_subfold = None
if app_file_name.endswith('.py'):
    example_file_path = os.path.join(SPARK_PATH, 'examples/src/main/python', app_file_name)
else:
    # Load jar files with examples
    example_file_path = os.path.join(SPARK_PATH, 'lib', app_file_name)

spark_example_file_path = '/tmp/%s' % app_file_name

zepplin_controller = run_cmd(
    "kubectl get pods --namespace=%s | grep zeppelin-controller | awk '{print $1}'" % (NAMESPACE,))

# copy example file that we want to run on the machine
copy_spark_file_cmd = "kubectl exec -i {0} --namespace={1} -- /bin/bash -c 'cat > {2}' < {3}".format(
    zepplin_controller, NAMESPACE, spark_example_file_path, example_file_path)

run_spark_job = "kubectl exec -i {0} --namespace={1} -ti -- spark-submit --master=spark://spark-master:7077 {2} {3} {4}".format(
    zepplin_controller, NAMESPACE, sparks_args, spark_example_file_path, app_args)

if __name__ == '__main__':
    run_cmd(copy_spark_file_cmd)
    print(run_cmd(run_spark_job))
