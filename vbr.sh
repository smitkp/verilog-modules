#/bin/bash
echo '---------- VERILOG BUILD and RUN ----------'
iverilog  -o simv  -i $@
echo '---------- BUILD COMPLETE ----------'
vvp simv
echo '---------- RUN COMPLETE ----------'

