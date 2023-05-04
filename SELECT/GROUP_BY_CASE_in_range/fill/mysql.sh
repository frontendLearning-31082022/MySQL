#!/bin/bash
function normalRegex_PyScript() {
[ -e regex_matches_array.py ] && return
echo  "import re
import sys

regex= sys.argv[1] 
test_str= sys.argv[2] 

#print(regex)
#print(test_str)

matches = re.finditer(regex, test_str, re.MULTILINE)

for matchNum, match in enumerate(matches, start=1):
    print(match.group())" > regex_matches_array.py
}
normalRegex_PyScript

user=$(head -n 1 user)
db=$(head -n 1 dbName)

table=$(head -n 1 CreateTable)
[[ $table =~ (^[^\`]*.{1}(.*?)\`) ]] && table="${BASH_REMATCH[2]}"

create_table="use $db; $(cat CreateTable)"

columns_schema=$(cat CreateTable)
columns_string=$(python3 regex_matches_array.py '^\s*[^CREATE][A-z]+\s.*' "$columns_schema" )

readarray -t columns_all <<<"$columns_string"

columns=()
not_insert=("AUTO_INCREMENT" "AS")
for column_string in "${columns_all[@]}"
do
	stopword=false
	
	#echo "column name - $column_string $stopword"
	#echo "column name - $column_string"
	
	for word in "${not_insert[@]}"
	do
		#echo "word $word"
		[[ $column_string =~ (.*$word.*) ]] && stopword=true
	done
	#echo $stopword
	column_string=$(python3 regex_matches_array.py '^\s*([A-z_]*)' "$column_string" )
	#echo "result $columns_string"
   ! $stopword && columns+=($column_string)
done


#printf '%s ' "${columns[@]}"

#exit 0

#echo "colls $columns"

count_columns="$(echo "$columns" | wc -l)"
#autoincrement_colums=$(python3 regex_matches_array.py 'AUTO_INCREMENT' "$columns_schema" )
#count_auto_increment=${#autoincrement_colums[*]}
#input_data_columns_count=$(($count_columns-$count_auto_increment+1))
input_data_columns_count=$((${#columns[*]}+1))
#echo "input_data_columns_count -- $input_data_columns_count"

validated_input_data=true
line_num=0
while IFS= read -r line; do
    [[ line_num%input_data_columns_count!=0 ]] && continue
    #echo $line || 
    [[ ${#line}>0 ]] && validated_input_data=false && \
    echo "incorrect input data structure" && exit 1
    line_num=$((line_num++))
done < data

mysql -e "CREATE DATABASE IF NOT EXISTS ${db}"
mysql -u$user -p -e "$create_table"

#TODO no autoincrement - NULL

first_part="use $db; INSERT INTO $table ( $(printf '%s, ' "${columns[@]}")"
first_part=${first_part::-2}
first_part="$first_part ) VALUES("

list_inserts=""
value_to_insert=$first_part
#echo " novii insert $value_to_insert"
echo "input_data_columns_count -- $input_data_columns_count"
#exit 0
line_num=0
while IFS= read -r line; do
    line_num=$((line_num+1))
    #echo "line -- $line"
    if [ $(($line_num % $input_data_columns_count)) == 0 ] 
    then
    	value_to_insert=${value_to_insert::-2}
    	value_to_insert="$value_to_insert);"
	#echo "$value_to_insert
    	
    	list_inserts="$list_inserts\n$value_to_insert"
    	echo -e "$value_to_insert"

	value_to_insert=$first_part
    	continue;
    fi
    value_to_insert="$value_to_insert '$line', "
    #echo "value_to_insert -- $value_to_insert"
done < data

#TODO to funcMove
value_to_insert=${value_to_insert::-2}
value_to_insert="$value_to_insert);"
list_inserts="$list_inserts\n$value_to_insert"
echo -e "$value_to_insert"

#exit 0
#echo -e $list_inserts
mysql -u$user -p -e "$list_inserts"
