#!/bin/bash

nohup jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token='' --NotebookApp.notebook_dir='/root/workdir' --no-browser >> jupyter.log 2>&1 &


# How to kill
<< COMMENTOUT
ps -ef | grep jupyter
kill 2075
<<
