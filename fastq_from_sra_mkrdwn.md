#This script is designed to go collect sequencing reads from the SRA, download them as F and R fastqs and then
#zip (compress) them into fastq.gz files. 

# BACKGROUND
    The SRA is the "Sequence Read Archives" a public online repository for sequencing data run by the NIH. No account
     is needed to download sequences from the SRA (one is required for data upload) and it is free! Within the SRA
    there are projects, experiments, and runs all with metadata about where, when, and on what instruments sequencing
     was done. Make sure to be familiar with any project you are pulling sequencing from! 

    There are multiple types of SRA accession number prefixes (a unique number assigned to each run/experiment/paper etc...) 
    so familiarize yourself with the differences here https://www.ncbi.nlm.nih.gov/books/NBK569234/#srch_Understand_SRA.what_do_the_differen
    The most common accession prefixes seen in downloaded sequence are SRR####### and SRX#######. SRX represents an 
    experiment accession whereas SRR represents a run accession. SRR's are the actual runs with sequencing data whereas 
    SRX accessions may contain multliple SRR runs (i.e., multiple sequencing runs for one experiment). 

# GENERAL QUALITY CONTROL ADVICE###    Always know where the sequence is coming from! Check that the SRA project you are pulling from is actually the
    paper/experiment you think it is, sometimes accessions aren't reported accurately.

    Ensure you have a solid internet connection or make sure you have set up the download process in such a way
    that it wont be disturbed. Downloading hundreds of sequences for a new analysis can take a while so if you 
    are running a batch of sequence downloading overnight, make sure you can safely close/shut down your computer
    without disturbing the download (i.e., submit job to server node, or run in a screen).
    
    Check file sizes before and after download. Triple check to make sure that the entire file was downloaded, having
    truncated sequencing files can cause downstream problems very quickly. If you are running a large batch overnight
    be sure to check the downloaded file sizes the next morning to ensure nothing shorted out/stopped. 

# ABOUT THE SCRIPT###
    This script is a "for loop" with three commands. For each item in the list (your SRA accession numbers of interest) this 
    script will retrieve the sequence data, split it into F and R reads, and compress the files so you will be left with
    SRR#######_1.fastq.gz (forward read) and SRR#######_2.fastq.gz (reverse read) files for each accession number in the list.
    The "fasterq-dump" command from the SRA toolkit (manual here https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump)
    is the command that retrieves the sequencing data, then two gzip commands compress the _1.fastq.gz and _2.fastq.gz files
    individually. 

`directory= path/to/where/fastq-dump/lives/`
    #The first step is the directory variable. This is where you put the path to the fasterq-dump program. It is common that 
    #bioinformatic servers have the SRA toolkit already installed. If this is the case, the directory part is not necessary
    #and the command can be called simply by typing 'fasterq-dump' in the command line. If you have downloaded your own copy
    #then use the directory variable to direct your computer where to look for the program files. 
        num="
      	SAMN05852518
      	SAMN05852485
      	SRX021073
      	SRX021074
      	SAMN05852520
      	SAMN05852487
      	SAMN05852522
      	SAMN05852490
      	SAMN05852491
		SAMN05852492
		SAMN05852495
		SAMN05852496
		SAMN05852497
		SAMN05852499
		SAMN05852502
		SAMN05852503
		SRX021077
		SAMN05852504
		SAMN05852505
		SRX021072
		SRX021075
		SAMN05852507
		SAMN04517335
		SAMN05852509
		SRX021078
		SAMN05852510 
        "
        #This is a list of the SRA accessions you wish to download. The SRA Run Selector page will have a table with
        #all SRR runs from an experiment in a table format. It is easy to copy that table into an excel doc, and then
        #paste the accession # column into this list (you may have to remove some hyperlinks). 

for n in `${num}` #this is the setup for a "for loop", computer talk saying "for everything in this list do...."
do echo ${n}; #This first step echos the accession number the program is currently working on. It acts as a way to
#check progress while the script is running. 
${directory}fasterq-dump ${n} --split-files; #This is the command that
#fetches the sequence data. The usage for fasterq-dump is 'fasterq-dump SRAaccession options'. The ${n} represents 
#the current SRA accession number the program is working on, and will be auto filled as it runs. For this script 
#the only option called is the '--split-files' option. This option splits sequencing data into F and R reads.
#It works best on SRA submissions where there are 2 reads per spot. Metadata on the SRA (click the hyperlink
#on the SRR number of interest) will show how many reads there are per spot. Most high quality sequencing data
#uploaded these days has only 2 reads per spot so this option works well. If there are more than 2 reads per 
#spot those extra reads will be lost and options such as split-3 may be more useful, read the manual for more
#information.  
gzip ${n}_1.fastq; gzip ${n}_2.fastq #this line occurs after reads are fully downloded and individually
#zips the F and R reads. This step is strongly recommended as it helps save overall space but is not strictly
#necessary. 
done #the script is done and has downloaded and zipped all sequencing data. 

###General Notes###
    #this script will download the sequences in the directory from which it is ran. So make sure to run the
    #script in the folder that you want the sequences in or else you will have to spend time moving them. 

    #The SRA toolkit is constantly being updated and tweaked so check that there isn't a new command
    #(even-fasterq-dump maybe??) that has replaced fasterq-dump. There are also lots of resources online for
    #help as this is a very popular toolkit to use so google any and all error messages that may pop up. 

#Happy downloading!!
#Made by ESD 2022

#Full script without comments

directory= path/to/where/fastq-dump/lives/
        num="
      	SAMN05852518
      	SAMN05852485
      	SRX021073
      	SRX021074
      	SAMN05852520
      	SAMN05852487
      	SAMN05852522
      	SAMN05852490
      	SAMN05852491
		SAMN05852492
		SAMN05852495
		SAMN05852496
		SAMN05852497
		SAMN05852499
		SAMN05852502
		SAMN05852503
		SRX021077
		SAMN05852504
		SAMN05852505
		SRX021072
		SRX021075
		SAMN05852507
		SAMN04517335
		SAMN05852509
		SRX021078
		SAMN05852510 
        "
for n in ${num}
do echo ${n}; ${directory}fasterq-dump ${n} --split-files; gzip ${n}_1.fastq; gzip ${n}_2.fastq
done
