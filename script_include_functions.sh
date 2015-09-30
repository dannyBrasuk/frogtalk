#!/bin/bash

#
#  standard collection of functions to include in a bash script
#

declare g_psql_message=""
declare -i f_table_row_count_return

declare f_program_name=""
declare f_shellfilename=""
declare f_directory=""

function formatted_timestamp()
{
    echo '['$(date +'%a %Y-%m-%d %H:%M:%S %z')']'
}

# Terminate on CTRL-C

function error_exit {

	# echo "CTRL+C Detected. Terminating..."
	
	# Display error message and exit
	echo "${f_program_name}: ${1:-"Unknown Error"}" 1>&2
	status_report -1
}

function elased_time {

	local l_start_sec=$1
	local l_stop_sec=$(date +%s)
	local l_outputfile=$2

	DIFF=$((l_stop_sec-l_start_sec))

	printf "\nDone! Batch ended at `date`. Elasped time: $((DIFF/60)) min $((DIFF%60)) sec.\n\n\a"

	if [[ $l_output_file ]]; then
		echo -e "\nDone! Batch ended at `date`. Elasped time: $((DIFF/60)) min $((DIFF%60)) sec.\n\n\a" >> $l_output_file
	fi
}

# shell_program_name_and_directory $f_program_name $f_shellfilename $f_directory

function shell_program_name_and_directory 
{

	local l_bash_source=$1
	local l_program_name=$2
	local l_shellfilename=$3
	local l_directory=$4

	l_program_name=$(basename $l_bash_source) 

	# remove file extension (.sh) from name
	l_shellfilename=${l_program_name%%.*}

	# Current directory   (This might now always work.  See "scribbles.sh")
	l_directory="$( cd -P "$( dirname "$l_program_name" )" && pwd )"

	# returns via globals
	f_program_name=$l_program_name
	f_shellfilename=$l_shellfilename
	f_directory=$l_directory

	printf "Shell file: \"$f_program_name\"; Minus extension: \"$f_shellfilename\"; Directory: \"$f_directory\".\n" 

}

function table_row_count
{
	local h=$1; local d=$2; local U=$3; local l_debug=$4;
	local l_target_table=$5
	local l_record_count=$6

	local l_cmd="select count(*) from $l_target_table;"

	if [[ $l_debug == 1 ]]; then printf "\n  (Debug: Function 'table_row_count', command value: $l_cmd)\n"; fi

	# update the local value of record count, which in turn is passed back to the calling point.
	l_record_count=$(echo $l_cmd | psql -Xqwt -h $h -d $d -U $U)

	f_table_row_count_return=$l_record_count

	# Bash knows only status codes (integers) and strings written to the stdout. Bash functions can only return exit / success 
	# status or, in other words, integer values of a certain range.
	# Hence this use of the global variable "record count."
}

function truncate_a_table
{
	local h=$1; local d=$2; local U=$3; local l_debug=$4;
	local l_target_table=$5

	local l_cmd="TRUNCATE TABLE ONLY $l_target_table RESTART IDENTITY CASCADE;"

	if [[ $l_debug == 1 ]]; then printf "\n  (Debug: Function 'truncate_a_table', command value: $l_cmd)\n"; fi

	g_psql_message=$(echo $l_cmd | PGOPTIONS='--client_min_messages=LOG' psql -Xqw -h $h -d $d -U $U 2>&1)

}

function copy_from_csv
{
	local h=$1; local d=$2; local U=$3; local l_debug=$4;
	local l_target_table=$5
	local l_csv_source=$6

	local l_cmd="\COPY $l_target_table FROM '$l_csv_source' WITH DELIMITER '|' CSV HEADER"

	if [[ $l_debug == 1 ]]; then printf "\n  (Debug: Function 'copy_from_csv', command value: $l_cmd)\n"; fi

	g_psql_message=$(echo $l_cmd | PGOPTIONS='--client_min_messages=LOG' psql -Xqw -h $h -d $d -U $U 2>&1)

}

function select_all_from_a_table
{
	local h=$1; local d=$2; local U=$3; local l_debug=$4;
	local l_target_table=$5

	local l_cmd="select * from $l_target_table order by 1;"

	if [[ $l_debug == 1 ]]; then printf "\n  (Debug: Function 'select_all_from_a_table', command value: $l_cmd)\n"; fi

	echo $l_cmd | psql --pset pager=off -Xqw -h $h -d $d -U $U
}

# TD:  THIS FAILS

function select_random_topN_from_a_table
{
	local h=$1; local d=$2; local U=$3; local l_debug=$4;
	local l_target_table=$5
	local l_N=$6				# N is sample size
	local l_record_count=0

	# l_record_count=$(table_row_count -h $h -d $d -U $U $l_debug $l_target_table $l_record_count)
	table_row_count -h $h -d $d -U $U $l_debug $l_target_table $l_record_count

	local l_cmd="SELECT * FROM $l_target_table OFFSET random()*$l_record_count LIMIT $l_N;"

	if [[ $l_debug == 1 ]]; then printf "\n  (Debug: Function 'select_random_topN_from_a_table', command value: $l_cmd)\n"; fi

	echo $l_cmd | psql --pset pager=off -Xqw -h $h -d $d -U $U

}