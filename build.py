BUILD_EXE = 'iverilog'
RUN_EXE   = 'vvp'


# import the necessary packages
import argparse
import os

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--inputs", required=False, nargs='+', help="Input files separated by space")
ap.add_argument("-o", "--output", required=True, help="Output name")
ap.add_argument("-build_only", "--build_only", required=False, default=False, help="Build only")
ap.add_argument("-run_only", "--run_only", required=False, default=False, help="Run simulation only")

args = vars(ap.parse_args())

input_files = args['inputs']
output      = str(args['output']) + '.simv'
build_only  = args['build_only']
run_only    = args['run_only']

##### Check for what to do #####
BUILD=True
RUN=True

if build_only in [True, 'True', 'TRUE', 1, '1']:
    RUN=False

if run_only in [True, 'True', 'TRUE', 1, '1']:
    BUILD=False

##### Do all tasks #####
if BUILD:
    if not isinstance(input_files,dict):
        if input_files is None:
            print "ERROR: Must provide atleast 1 input verilog file."
            exit()
    inputs = ' '
    for each in input_files:
        inputs += each + ' '
    build_cmd = BUILD_EXE + '  -o ' + output + '  ' + inputs
    print build_cmd
    os.system(build_cmd)
    print 'Build Complete...'

if RUN:
    run_cmd = RUN_EXE + '  ' + output
    print run_cmd
    os.system(run_cmd)
    print 'Simulation Complete...'







