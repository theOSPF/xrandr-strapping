#! /bin/bash
read yournumber
re='^[0-9]+$'
if ! [[ $yournumber =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi


mons=("dsds" "dsdsd" "dsdsds")

echo ${#mons[@]}

read var
if [ -z "$var" ]
then
     echo "\$var Пустая"
else
     echo "\$var не пустая"
fi