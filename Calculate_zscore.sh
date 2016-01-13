#!/bin/bash
  while read motif;do
    bsub << EOF
     #BSUB -L /bin/bash
     #BSUB -W 50:00
     #BSUB -M 8000
     #BSUB -n 1
     #BSUB -e error/%J.err
     #BSUB -o error/%J.out
      sd=`awk '{x[NR]=\$2; s+=\$2; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); print sd}' $motif"_sum.txt"`
      #The above step calculates standard deviation for each RNA Binding Protein over all exons
      mean=`awk '{ total += \$2; count++ } END { print total/count }' $motif"_sum.txt"`
      #The above step calculates the mean for each RNA Binding proteing over all exons
      awk "{print \$2-\$mean/\$sd}" $motif"_sum.txt" > $motif".tmp"
      zscore=`awk '{ ttl += \$0; cnt++ } END { print ttl/cnt }' $motif".tmp"`
      #The above step calculates zscore from the mean and standard deviation calculated in the previous steps
      #print $motif \$zscore >> Zscore_calculation.txt
    EOF
    rm *.tmp
done < list_proteins.txt  
