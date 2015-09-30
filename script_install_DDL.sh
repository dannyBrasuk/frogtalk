#!/bin/bash
#
# Frogtalk EDW database
# Use this script to install the database objects, pulling the SQL files from the local Git repository.
#    (FYI.  This is )
#
# cd "/Users/MacDesktop/Documents/GitHub Repository/frogtalk"
# source script_install_DDL.sh
#

clear

# exit bash script if any statement returns a non-true return value. prevents errors snowballing  Again, for readability you may want to use set -o errexit.
set -e

# exit your script if you try to use an uninitialised variable. You can also use the slightly more readable set -o nounset. (Good idea, but doesn't like $PATHNAME)
# set -u

# include files of commonly used functions, etc
source script_include_functions.sh
source script_connection_info.sh 			# edit the Postgres server host when needed.


# need to test this
# trap error_exit INT

#
# initialize stuff.  
#

declare OLD_IFS=""
declare IFS=""

# function return code (to generate the status code messages at the end
declare -i return_code=99
declare -i psql_exit_status=0

# needed in elapsed time function  (which I do just to do)
declare -i start_sec=$(date +%s)

# get name of shell program and its path
unset f_program_name 
unset f_shellfilename 
unset f_directory

shell_program_name_and_directory $BASH_SOURCE $f_program_name $f_shellfilename $f_directory

# where to put the looging file

declare log_file_path="$HOME/Documents/frog_logs/"
declare output_file="$log_file_path$f_shellfilename_$(date +%Y%m%d%H%M).txt"							

# GitHub repository and Document path  ($PATHNAME preserves the whitespace in the directory)
declare git_repo_directory=""
git_repo_directory="$HOME$PATHNAME/Documents/GitHub Repository/frogtalk/"

declare target=""

# Declare array of DDL types, and get the array count.
#	The Git repo contains scripts that install these object types.
#	Note that the order of the array elements is important.
declare -a DDL_list=( 'schemas' 'table' 'constraints' 'view' 'function' )
declare -i DDL_count=${#DDL_list[@]}
declare -i i=0
declare -i file_counter=0
	
#
# log a few parameters, 1 per line
#
( echo "Parameters:" ; echo "Host name: " $hostname ; echo "GIT Path: " $git_repo_directory ; echo "Log File: " $output_file ) >> $output_file

printf "Output file: $output_file\n\n"			# Lesson: that printf directs to STDOUT

# 
# functions unique to this task
#

function exit_report {

	local l_filename=$1
	local l_message=""

	 case "$2" in
		-1)
			l_message="CTRL+C Detected. "$l_filename" Terminated." 
			;;
		0)
			l_message="Completed execution of "$l_filename". No Bash errors."
			;;
		1)
			l_message="Script "$l_filename" failed. Directory "$git_repo_directory" does not exist."
			;;
		2)
			l_message="Script "$l_filename" completed, but with Bash errors in a DDL step."
			;;	
		*)
			l_message="Undocumented Bash error in "$l_filename"."
			;;
	esac;

	echo -e "\nExit status: $l_message (`date`)" >> $output_file

}

function run_scripts
{
		# $1 and $2 are: $git_repo_directory and $target 

		local -a l_target=$1$2"*.sql"		# Lesson: equivalent command: list=$(ls $1$2"*.sql) 
		local l_output_file=$3
		local l_hostname=$4
		local l_database=$5
		local l_user=$6
		local l_tempfile=""
		local l_f=""
		local -i l_file_counter=0

		# pessimistic return code (error assumed).  global
		return_code=2

		# Handle whitespace in file name by changing the delimiter temporarily
		local l_OLD_IFS=$IFS
		local l_IFS=";"

		# array of script files in the current folder
		for l_f in $l_target
		do 	
			if [ -f $l_f ];
				then

					# use temp file to hold output of each iternation of PSQL (then append it to the main output file)
					# then immediately after, create an EXIT handler to clean up this directory when the script exits.
					l_tempfile="mktemp temp.$$"
					trap "rm -rf $l_tempfile" EXIT

					# if file exists, then do:  (global)
		    		((l_file_counter+=1))

		    		# Use the command 'basename' to strip off path   (Note: printf goes to shell; echo to file.)
					printf "Script file #$l_file_counter: \t`basename $l_f` ... \n"
					echo -e "Script file #$l_file_counter: `basename $l_f` ($(date +%T))..." >> $l_output_file
							
					# PSQL options:
						# (Good site: http://petereisentraut.blogspot.com/2010/03/running-sql-scripts-with-psql.html	)
					# -X ignores the psql profile, so that in my case, items like "timing" are not sent to the file.	
					# -q means quiet, as in suppressing output from DDL commands.  Doesn't have any impact when directing the output to file
					# -w reads the password from the PGPASS file. OK for testing convenience.  (Uppercase would force a prompt)
					# -a (not included) would echo all SQL to the file.  LOG and Debug messages do similar.
					# -P pager off  (or --pset pager off). 
							# The -p option controls the output format. For output to the screen, "off" prevents a scroll from holding up processing.
					# client_min_messages: Valid values are (in order) DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, LOG, NOTICE, WARNING, ERROR, FATAL, and PANIC
					# output file:  &> $TEMPFILE redirects STDERR stream of PSQL into STDOUT, and then to file. (> $TEMPFILE sends STDERR stream it to terminal, STDOUT to file)
						# > is stdout, 2> is stderr, &> is both
						# The ">" sign is used for redirecting the output of a program to something other than stdout (standard output, which is the terminal by default).
						# The >> appends to a file or creates the file if it doesn't exist. The > overwrites the file if it exists or creates it if it doesn't exist.

					PGOPTIONS='--client_min_messages=NOTICE' \
					psql -X -q \
					-P pager=off \
					-h $l_hostname -d $l_database -U $l_user -w -f $l_f \
					&> $l_tempfile
					
					psql_exit_status=$?


					# -v ON_ERROR_STOP=1 \
					# psql returns (as exit status):
					#		 	0 to the shell if it finished normally, 
					#			1 if a fatal error of its own occurs (e.g. out of memory, file not found), 
					#			2 if the connection to the server went bad and the session was not interactive, 
					# 			3 if an error occurred in a script and the variable ON_ERROR_STOP was set.
					# With the option -v ON_ERROR_STOP=1 \   "will return the correct return code even foobar.sql file doesn't enable ON_ERROR_STOP at the top of the file.""
					# Maybe maybe not.  Because the psql error causes the bash script to terminate immediately, I cannot get the value of psql_exit_status or do anything else.

					cat $l_tempfile >> $l_output_file
					rm -rf $l_tempfile

					if [ $psql_exit_status != 0 ]; then
					    echo -e "\n ****** psql exited with value of $psql_exit_status while trying to run this sql script\n" >> $l_output_file	
					    return_code=1
					   	break
					   	# exit $psql_exit_status
					else
						printf "\t\t\t\t...psql exit status = $psql_exit_status. (($(date +%T))\n"
						echo -e "\t...No errors detected. PSQL exited with value of $psql_exit_status \n" >> $l_output_file
						continue
					fi					
				else
					printf "\n\nProblem! #$l_file_counter. $l_f does not exist. Skipping.\n\n"
					echo  -e "\n\nProblem! #$l_file_counter. $l_f does not exist. Skipping.\n\n"	>> $l_output_file					
					break
			fi
		done
 

		printf "\nScripts executed: $l_file_counter.\n\n"
		echo -e "\n"$(date +%r)" ("$(date +%D)") Scripts executed: $l_file_counter.\n"	>> $l_output_file

		# restore delimiter
		l_IFS=$l_OLD_IFS

		# success
		return_code=0
}

#
# Body of script
#
# Loop though the files in the Git directory, retrieving just the ones that meet naming conventions.
# 

# Search path exist? If so, continue with DDL script files
if ! [ -d "$git_repo_directory" ];
	then
		print 
		echo -e "\nFailed! Directory \"$git_repo_directory\n does not exist.\n" >> $output_file
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

 			run_scripts $git_repo_directory $target $output_file $hostname $database $user

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
			trap "run_scripts $git_repo_directory $target; exit" SIGINT

		done

		IFS=$OLD_IFS

		exit_report $f_program_name $return_code
fi

# test elasped timing calculation and Ctrl-C
# sleep 1

elased_time $start_sec $output_file

# exit 0

