#!/bin/bash

# 
# Pre-load the date dim in the EDW via a function call.
#
# IMPORTANT.  Note that the script will fail if the table is not empty.

# Also set the holiday schedule (whch of course is not really relevant to frogs but included anyway 
# 	because its a normal thing to do with dates)

# cd "/Users/MacDesktop/Documents/GitHub Repository/frogtalk"
# source script_initial_data_load_date_dim.sh
# source ~"/documents/GitHub Repository/frogtalk/script_initial_data_load_date_dim.sh"

# include files of commonly used functions, etc
source script_include_functions.sh
source script_connection_info.sh


# C method also works
# . /script_include_functions.sh
# . /script_connection_info.sh


clear
# set -e
# set -u

declare script_header="Starting initialization of \"edw.date_dim\"\n"
declare script_footer="Ended initialization of \"edw.date_dim\""


# option to show values, to help with debugging.
declare debug=0			

declare program_name=""
declare shellfilename=""
declare directory=""
declare log_file=""
declare csv_file=""

declare cmd=""

# Script file name  
# Manual:  BASH_SOURCE:  An array variable whose members are the source filenames where the corresponding shell 
#	function names in the FUNCNAME array variable are defined. The shell function ${FUNCNAME[$i]} is defined in 
# 	the file ${BASH_SOURCE[$i]} and called from ${BASH_SOURCE[$i+1]}
# (Everyone's favorite solution, "$(basename "$0")", does not work)

unset f_program_name 
unset f_shellfilename 
unset f_directory

shell_program_name_and_directory $BASH_SOURCE $f_program_name $f_shellfilename $f_directory

# program_name=$(basename $BASH_SOURCE) 

# printf "Shell file \"$program_name\" started at `date`.\n" 

# # remove file extension (.sh) from name
# shellfilename=${program_name%%.*}

# # Current directory   (This might now always work.  See "scribbles.sh")
# directory="$( cd -P "$( dirname "$program_name" )" && pwd )"


# where to put the logging file 
declare log_file=$data_source_path$f_shellfilename"_log_$(date +%Y%m%d%H%M).txt"



# output path
declare data_source_path=$HOME"/Documents/pg_datasource/"

# where to put the sample file of date records
declare csv_file=$data_source_path$f_shellfilename"_sampling_$(date +%Y%m%d%H%M).csv"
echo -e "CSV file of table sample sent to \"$csv_file\"\n" >> $log_file

# Parameters

# set the date range of date table  (this could be read from console)
declare start_date='01/01/2014'
declare end_date='01/01/2016'

# echo "For the Date Dim table, enter the starting date (as MM/DD/YYYY)."
# read start_date
# echo "Also, enter the ending date (as MM/DD/YYYY)."
# read end_date

printf "\n$script_header at `date`.\n"
printf "Log file \"$log_file\"\n" 

echo -e "Shell file \"$f_program_name\" started at `date`.\n\n" >> $log_file
echo -e "\n$script_header at `date`.\n\n" >> $log_file
echo -e "This log file is named: \"$log_file\"\n\n" >> $log_file
echo -e "For the date dim table, the starting and ending date range is: \"$start_date\" to \"$end_date\".\n\n" >> $log_file


# NOTE:
# a) The method of casting of the date values to the function call.
# b) That the postgreSQL commands need to be within an EOF block.
# c) The use of <<-EOF instead of <<EOF.  The <<- allows the commands to be indented
#		within the EOF block. Otherwise, with <<EOF together with indentation throws and error.
# d) The option -e to echo the commands executed; and the lack of the -q option, so that it doesn't execute quietly.
# e) The snippet immediately below will NOT run quietly. Apparently, PGOPTIONS must be declared *before* psql.

	# g_psql_message=$(psql -X -e -w -h $hostname -d $database -U $user <<-EOF 
	# 	set client_min_messages='LOG';
	# 	truncate table edw.date_dim CASCADE;
	# 	SELECT edw.date_dim_insert ('$start_date'::date, '$end_date'::date, '$debug'::boolean);
	# 	EOF
	# 2>&1)

unset g_psql_message
# PGOPTIONS='--client_min_messages=LOG' \
g_psql_message=$(psql -Xq -w -e -h $hostname -d $database -U $user  <<-EOF 
	set client_min_messages='NOTICE';
	truncate table edw.date_dim CASCADE;
	SELECT edw.date_dim_insert ('$start_date'::date, '$end_date'::date, '$debug'::boolean);
	EOF
2>&1)

echo -e "Postgres returned:\n"__________________"\n$g_psql_message\n__________________\n" >> $log_file

# FYI, this also is OK. In this case, I simplied changed it up. Admittedly through, this way is better for documentation as its more transparent.
# declare cmd="truncate table edw.date_dim CASCADE; SELECT edw.date_dim_insert ( '$start_date'::date, '$end_date'::date, '$debug'::boolean);"
# echo -e "Command: $cmd\n"
# psql_message=$(echo $cmd | PGOPTIONS='--client_min_messages=ERROR' psql -Xqw -h $hostname -d $database -U $user  2>&1)
# echo -e "Postgres returned:\n"__________________"\n$psql_message\n__________________n" >> $log_file

# 
# if insert succeeds, do the holiday update too

table_row_count $hostname $database $user $debug "edw.date_dim" $f_table_row_count_return

if [ $f_table_row_count_return > 0 ]; then

	unset g_psql_message
	g_psql_message=$(PGOPTIONS='--client_min_messages=ERROR' \
		psql -Xq -e -h $hostname -d $database -U $user -w <<-EOF 
		SELECT edw.date_dim_update_holiday ('$debug'::boolean);
		EOF
	2>&1)

	echo -e "Postgres returned:\n"__________________"\n$g_psql_message\n__________________\n" >> $log_file

fi


# When all done, send a random sampling of the table to a CSV file.

cmd="WITH selection AS (SELECT * FROM edw.date_dim  OFFSET floor(random()* (SELECT COUNT(*) FROM edw.date_dim ) ) LIMIT 100 )
	SELECT * FROM selection
	UNION SELECT * FROM edw.date_dim  WHERE holiday_text <> ''
	UNION SELECT * FROM edw.date_dim WHERE open_flag = FALSE  AND day_of_week <> 'Sunday'
	ORDER BY date_pk"
	

printf "\nSampling of the edw.date_dim table sent to CSV file using the following Select:\n$cmd\n" >> $log_file

psql -Xw -h $hostname -d $database -U $user -c "copy ($cmd) to STDOUT WITH CSV HEADER NULL AS '(null)'"  > $csv_file


printf "\n$script_footer at `date`.\n"
echo -e "\n$script_footer at `date`.\n" >> $log_file

# exit 0
