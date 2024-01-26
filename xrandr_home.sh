#!/bin/bash
mons=($(xrandr | grep -aoP ".+?\s(?=connected)" | tr " " "\n"))
primary=$(xrandr | grep -aoP ".+?\s(?=connected primary)")
last_mon=$primary
idx=$mons

for it in $idx
do
	it=0
done

#TODO сделать проверку на конфигурацию и выбор шаблона
echo -e "Unknown configuration :( \n Entering manual mode..."

echo -e "\n Choose Wisely... \n 1) Save configuration and exit \n 2) Manual configuration \n 3) Off all exept primary"

read checker

case $checker in

 1 )
 echo "dsdsdss"
 ;;

 2 )
 echo "iijihjhijh"
 ;;

 3 )
    for mon in ${mons[@]}
    do
        echo $mon
        if [ $mon != $primary ];
            then
                pwd
               # xrandr --output $mon --off
        fi
    done
 ;;

 *)

 ;;

esac

echo "All Done! Quiting..."


# Первичное выстраивание в ряд
#for mon in $mons
#do
#	if [ $mon != $primary ];
#		then
#			xrandr --output $mon --off
#			xrandr --output $mon --mode 1920x1080 --right-of $last_mon
#			last_mon=$mon
#	fi
#done

# matrix=()

# for ((it=1; it<=$((${#mons[@]}*${#mons[@]}));it++))
# do
#     matrix[$it]={$it}
# done

# function draw_matrix {
#     for i in ${!mons[@]}
#     do
#         out_str="|"
#         for j in ${!mons[@]}
#         do
#             flg=0
#             for it in ${!idx[@]}
#             do
#                 if (($((${#mons[@]}*$i+$j+1)) == ${idx[it]})); then
#                     out_str+=" ${mons[$it]} |"
#                     flg=1
#                     break 1
#                 fi
#             done
#             [[ $flg = 1 ]] && continue
#             out_str+=" ${matrix[$((${#mons[@]}*$i+$j+1))]} |"        
#         done
#         echo $out_str
#     done    
#     for it in ${!mons[@]}
#     do
#         out_str="$it ${mons[it]}"
#         echo $out_str
#     done
# }
# # TODO сделать, чтоб решётка не ехала

# clc_str="\033[""$((2*${#mons[@]}+2))""A"
# for ((;;))
# do
#     draw_matrix
#     printf "\r\033[K" 
#     read from to
#     idx[$from]=$to
#     echo -e $clc_str
# done



