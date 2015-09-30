#!/bin/bash


# The dimension tables in the EDW need to be pre-loaded.
# This script "copies" records from CSV files into corresponding tables.
# If a target table already contain data, then it is first truncated. Hence the 
# "initial data load designation."
#
# It works by first obtaining a lit of all the user-owned tables in the database. Then
# Then it looks for a CSV file matching the table name. If one exists, then it copies 
# it content into the table. So if you don't want a table truncated and re-loaded, then don't
# include a CSV file for it. (Sure, a control file/table might be better, but this is fine for now.)
# 
# At the bottom of the script, an extra step loads the date dimension table from a function call.
# (Normally, I'd think this step should be handled separately, but its fine here for now.)
#
# Note that this scrpt is to using pg_admin to manually load each table. With a lot of tables, pg_admin
# is not practical.



# cd /Users/MacDesktop/Documents/shellscripts
# source ~/documents/shellscripts/initial_data_load.sh

# include files of commonly used functions, etc
source script_include_functions.sh
source script_connection_info.sh

clear
# set -e
# set -u

declare script_header="Starting COPY of CSVs"
declare script_footer="Ended COPY of CSVs" 
printf "\n$script_header at `date`.\n"
echo -e "\n$script_header at `date`.\n" >> $log_file


# FYI, the following repetive snippet cant be a function because "cmd" cannot be passed as a parameter, due to whitespaces.
# if [ $debug ]; then printf "\n  (Debug: Function 'table_row_count', command value: $cmd)\n\n"; fi
#
# Also note the g_psql_message global variable. This is to enable writing the status messages to the logging file.


# option to show values, to help with debugging.
declare readonly debug=0

# Script file name  (Everyone's favorite solution, "$(basename "$0")", does not work)
PROGNAME=$(basename $BASH_SOURCE) 
printf "Shell file \"$PROGNAME\" started at `date`.\n" 
echo -e "Shell file \"$PROGNAME\" started at `date`.\n" >> $log_file



# location of CSV files
declare data_source_path=$HOME"/Documents/pg_datasource/"
printf "Data source path \"$data_source_path\"\n" 
echo -e "Data source path \"$data_source_path\"\n" >> $log_file

# where to put the looging file 
declare log_file=$data_source_path$PROGNAME"_log_$(date +%Y%m%d%H%M).txt"
printf "Log file \"$log_file\"\n" 
echo -e "This log file is named: \"$log_file\"\n" >> $log_file

# globals
declare -a table_list
declare -a schema_list
declare current_schema=""
declare current_table=""
declare current_schema_table=""
declare current_file=""
declare -i table_counter=0
declare -i file_counter=0


# FYI:
# declare connection_string="-Xqw -h $hostname -d $database -U $user"
# if [ $debug ]; then debug_print "Connection string" $connection_string; fi
# 	a single "connection string" like the above simplifies the function call, but I cant say its a "best practice."
# 	to make it work you have to override whitespace as a deimiter - in every function.  And that can be a mess.

# 
# potential list of database objects to load (owner by the current user)

schema_list=$(psql $connection --pset tuples_only=on -c "select distinct schemaname from pg_tables where tableowner='$user';") 

		# alternatively
		# schema_list=$(psql $connection --pset tuples_only=on -c "select table_name from information_schema.tables where table_schema not in ('information_schema','pg_catalog');") 

# loop through the schemas looking for tables to load

for s in ${schema_list[@]};
do

	current_schema=$s
	echo -e "\nCurrent schema: $current_schema\n" >> $log_file

	# list of tables in the current schema (and for the database user)
	table_list=$(psql $connection --pset tuples_only=on -c "select tablename from pg_tables where tableowner='$user' and schemaname='$current_schema';") 

		# alternatively
		# table_list=$(psql $connection --pset tuples_only=on -c "select table_name from information_schema.tables where table_schema='$current_schema';") 

	# Loop through the tables in the current schema

	for t in ${table_list[@]}; 
	do 

		# progress indicator
		printf ". "

		((table_counter+=1))

		current_table=$t

		current_schema_table=$current_schema"."$current_table

		echo -e "\tCurrent table (#$table_counter): \"$current_schema_table\"\n" >> $log_file

		# assume file containing the data to load has the same name as the target table, and within a folder named for the schema
		current_file="$data_source_path$current_schema/$t"."csv"

		# increment attemted file counter
		((file_counter+=1))

		if [[ -f $current_file ]];		# note the double brackets. that's the current way to do a comparison. single brackets deprecated.
			then

					echo -e "\t\tCSV file \"$current_file\" (#$file_counter) exists. Continuing to load attempt...\n" >> $log_file

				# if the target table empty?  If so, assume it can be emptied since this is an IDL.
				g_table_row_count_return=-1
				table_row_count $hostname $database $user $debug $current_schema_table $g_table_row_count_return

				# empty table if its not empty (and restart the identity)
				if [ $g_table_row_count_return > 0 ]; then

						echo -e "\t\tTarget table \"$current_schema_table\" already contains $g_table_row_count_return records. Table will be forcibly truncated.\n" >> $log_file
					unset g_psql_message						
					truncate_a_table $hostname $database $user $debug $current_schema_table 
						echo -e "\t\tFunction call \"truncate_a_table\" returned the Postgres message \"$g_psql_message\"\n" >> $log_file

				fi

				# Load (or reload) the emtpy table from the current CSV file (using the Copy command)
				unset g_psql_message
				copy_from_csv $hostname $database $user $debug $current_schema_table $current_file
						echo -e "\t\tFunction call \"truncate_a_table\" returned the Postgres message \"$g_psql_message\"\n" >> $log_file

				g_table_row_count_return=-1
				table_row_count $hostname $database $user $debug $current_schema_table $g_table_row_count_return
					echo -e "\t\tAfter load, table \"$current_schema_table\" contains $g_table_row_count_return records.\n" >> $log_file

		else
					echo -e "\t\tFile \"$current_file\" does not exists. Skipping table \"$current_schema_table\"\n" >> $log_file

		fi 

	# next table
	done
	unset table_list

# next schema
done

printf "\n$script_footer at `date`.\n"
echo -e "\n$script_footer at `date`.\n" >> $log_file

# exit 0

