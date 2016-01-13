#!/bin/bash
file=Exons_negative.txt
file1=list_proteins.txt
while read motif;do
bsub << EOF
#BSUB -L /bin/bash
#BSUB -W 50:00
#BSUB -M 8000
#BSUB -n 1
#BSUB -e error/%J.err
#BSUB -o error/%J.out
while read line; do
block=\$(echo \$line | awk '{print \$1}')
#sum_of_score=\$(grep \$block Positive_Strand/$motif"_PARCLIP.txt" | awk '{s+=\$5} END {print s}')
max_of_score=\$(grep \$block Negative_Strand/chr*.cons | grep $motif | awk 'BEGIN {max = 0} {if ($5>max) max=$5} END {print max}')
echo \$block \$max_of_score >> $motif"_max.txt"  
done < $file
EOF
done < $file1
