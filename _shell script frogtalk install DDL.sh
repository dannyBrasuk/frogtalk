#!/bin/bash
#
#
# cd "/Users/MacDesktop/Documents/GitHub Repository/frogtalk"
# cd "/Users/MacDesktop/Documents/shellscripts/frog"
#
clear

# exit bash script if any statement returns a non-true return value. prevents errors snowballing  Again, for readability you may want to use set -o errexit.
set -e

# exit your script if you try to use an uninitialised variable. You can also use the slightly more readable set -o nounset. (Good idea, but doesn't like $PATHNAME)
# set -u

# need to test this
trap error_exit INT

#
# initialize stuff.  
#

# function return code (to generate the status code messages at the end
return_code=99

psql_exit_status=0

# where to put the looging file
DOCPATH=$HOME"/Documents/"
output_file=$DOCPATH"frogtalk_installation_log_$(date +%Y%m%d%H%M).txt"
printf "Output file: $output_file\n\n"

# Script file name  (Everyone's favorite solution, "$(basename "$0")", does not work)
PROGNAME=$(basename $BASH_SOURCE) 
printf "\n\nShell file \"$PROGNAME\" started at `date`.\n\n"
echo -e "Shell file \""$PROGNAME"\" started at `date`.\n\n" >> $output_file

# needed in elapsed time function  (which I do just to do)
START_sec=$(date +%s)

# add an input for the host IP
HOSTNAME="192.168.1.44"	

# GitHub repository and Document path  ($PATHNAME preserves the whitespace in the directory)
GITPATH=$HOME$PATHNAME"/Documents/GitHub Repository/"

search_path=$GITPATH"frogtalk/"
printf "Search Path: $search_path\n"

# Declare array of DDL types, and get the array count.
DDL_list=( 'schemas' 'table' 'constraints' 'view' 'function' )
DDL_count=${#DDL_list[@]}

#
# log a few parameters, 1 per line
#
( echo "Parameters:" ; echo "Host name: " $HOSTNAME ; echo "GIT Path: " $search_path ; echo "Output Path: " $DOCPATH ) >>$output_file


# Terminate on CTRL-C
function error_exit {

	# echo "CTRL+C Detected. Terminating..."
	
	# Display error message and exit
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2 >> $output_file
	status_report -1
}

function elased_time {

	local start_sec=$1
	local stop_sec=$(date +%s)
	DIFF=$((stop_sec-start_sec))
	printf "\nDone! Batch ended at `date`. Elasped time: $((DIFF/60)) min $((DIFF%60)) sec.\n\n\a"
	echo -e "\nDone! Batch ended at `date`. Elasped time: $((DIFF/60)) min $((DIFF%60)) sec.\n\n\a" >> $output_file

}

function exit_report {

	local filename=$1
	local message=""

	 case "$2" in
		-1)
			message="CTRL+C Detected. "$filename" Terminated." 
			;;
		0)
			message="Completed execution of "$filename". No Bash errors."
			;;
		1)
			message="Script "$filename" failed. Directory "$search_path" does not exist."
			;;
		2)
			message="Script "$filename" completed, but with Bash errors in a DDL step."
			;;	
		*)
			message="Undocumented Bash error in "$filename"."
			;;
	esac;

	echo -e "\nExit status: $message (`date`)" >> $output_file

}

function run_scripts() 
{
		local target=$1$2"*.sql"
		local output_file=$3
		local file_number=$4
		local hostname=$5

		# pessimistic return code (error assumed). global
		return_code=2

		local file_counter=0

		# Handle whitespace in file name by changing the delimiter temporarily
		local OLD_IFS=$IFS
		local IFS=";"

		for f in $target
		do 	
			if [ -f $f ];
				then

					# use temp file to hold output of each iternation of PSQL (then append it to the main output file)
					# then immediately after, create an EXIT handler to clean up this directory when the script exits.
					TEMPFILE="mktemp temp.$$"
					trap "rm -rf $TEMPFILE" EXIT

					# file exists
		    		((file_counter+=1))		    		
		    		# Use the command 'basename' to strip off path   (Note: printf goes to shell; echo to file.)
					printf "Script file #$file_counter: \t`basename $f` ... \n"
					echo -e "Script file #$file_counter: `basename $f` ($(date +%T))..." >> $output_file
							
					# PSQL options, (Good site: http://petereisentraut.blogspot.com/2010/03/running-sql-scripts-with-psql.html	)
					# -X ignores the psql profile, so that in my case, the timing is not printed.	
					# the log_line_prefix is having no impact, in either system log or mine
					# client_min_messages: Valid values are (in order) DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, LOG, NOTICE, WARNING, ERROR, FATAL, and PANIC
					# &> $TEMPFILE redirects PSQL output to file.   >> $TEMPFILE sends it to screen

					# PGOPTIONS='--debug_pretty_print=TRUE --client-min-messages=INFO' psql -X -q -a -v ON_ERROR_STOP=1 -v log_line_prefix='%p %m> %%' --pset pager=off -h $hostname -d frogtalk -U bigfrog -f $f &> $TEMPFILE	

					PGOPTIONS='--client_min_messages=NOTICE' \
					psql -X -q \
					--pset pager=off \
					-h $hostname -d frogtalk -U bigfrog -w -f $f \
					&> $TEMPFILE
					
					psql_exit_status=$?


					# -v ON_ERROR_STOP=1 \
					# psql returns (as exit status):
					#		 	0 to the shell if it finished normally, 
					#			1 if a fatal error of its own occurs (e.g. out of memory, file not found), 
					#			2 if the connection to the server went bad and the session was not interactive, 
					# 			3 if an error occurred in a script and the variable ON_ERROR_STOP was set.
					# With the option -v ON_ERROR_STOP=1 \   "will return the correct return code even foobar.sql file doesn't enable ON_ERROR_STOP at the top of the file.""
					# Maybe maybe not.  Because the psql error causes the bash script to terminate immediately, I cannot get the value of psql_exit_status or do anything else.

					cat $TEMPFILE >> $output_file
					rm -rf $TEMPFILE

					if [ $psql_exit_status != 0 ]; then
					    echo -e "\n ****** psql exited with value of $psql_exit_status while trying to run this sql script\n" >> $output_file	
					    return_code=1
					   	break
					   	# exit $psql_exit_status
					else
						printf "\t\t\t\t...psql exit status = $psql_exit_status. (($(date +%T))\n"
						echo -e "\t...No errors detected. PSQL exited with value of $psql_exit_status \n" >> $output_file
						continue
					fi					
				else
					printf "\n\nProblem! #$file_number. $f does not exist. Skipping.\n\n"
					echo  -e "\n\nProblem! #$file_number. $f does not exist. Skipping.\n\n"	>> $output_file					
					break
			fi
		done
		IFS=$OLD_IFS

		printf "\nScripts executed: $file_counter.\n\n"
		echo -e "\n"$(date +%r)" ("$(date +%D)") Scripts executed: $file_counter.\n"	>> $output_file

		# success
		return_code=0
}


# Search path exist? If so, continue with DDLs
if ! [ -d "$search_path" ];
	then
		print 
		echo -e "\nFailed! Directory"$search_path" does not exist.\n" >> $output_file
else
	# execute the script files within the directory
		OLD_IFS=$IFS
		IFS=";"

		for (( i=0;i<$DDL_count;i++))
		do

			target="create "${DDL_list[${i}]}

			# shell message
			printf "\nRun scripts to \" $target\"...\n\n"
			echo -e "\nRun scripts to \"$target\"... $(date +%T): \n" >> $output_file 

			run_scripts $search_path $target $output_file ${i} $HOSTNAME

			# Capture the function return.  (There is no better way I know of. Bash knows only 
			# status codes (integers) and strings written to the stdout. (outside of global)

			# if any script fails, terminate processing of all others.
			# echo "return "$return_code
			if [ $return_code -eq 0 ]; then 
				continue
			else
				break
			fi			

			# terminate on Ctrl C
			trap "run_scripts $search_path $target; exit" SIGINT

		done

		IFS=$OLD_IFS

		exit_report $PROGNAME $return_code
fi

# test elasped timing calculation and Ctrl-C
# sleep 1

elased_time $START_sec

#exit 0

