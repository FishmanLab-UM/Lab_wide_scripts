for i in *.sam; do samtools view -b -F 4 -F 256 $i > ${i:0:-16}.filtered.bam; done
