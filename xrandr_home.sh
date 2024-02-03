#!/bin/bash

function draw_cur_mons {
    for i in ${!mons[@]}
    do
        out_str="|"
        for j in ${!mons[@]}
        do
            flg=0
            for it in ${!idx[@]}
            do
                if (($((${#mons[@]}*$i+$j)) == ${idx[$it]})); then
                    out_str+="_""$it""_|"
                    flg=1
                    break 1
                fi
            done
            [[ $flg = 1 ]] && continue
            out_str+="___|"        
        done
        echo $out_str
    done    
    for it in ${!mons[@]}
    do
        out_str="$it ${mons[it]}"
        echo $out_str
    done
}

function draw_cur {
    for i in ${!mons[@]}
    do
        out_str="|"
        for j in ${!mons[@]}
        do
            if ((${matrix[$((${#mons[@]}*$i+$j))]} == $1)); then
                out_str+="_+_|"
            else
                flg=0
                for it in ${!idx[@]}
                do
                    if (($((${#mons[@]}*$i+$j)) == ${idx[$it]})); then
                        out_str+="_""$it""_|"
                        flg=1
                        break 1
                    fi
                done
                [[ $flg = 1 ]] && continue
                out_str+="___|" 
            fi        
        done
        echo $out_str
    done    
}
# TODO сделать, чтоб решётка не ехала
# clc_str="\033[""$((2*${#mons[@]}+2))""A"
# $((2*${#mons[@]}+2))
function clear_n {
    # local clc_str="\033[""$1""A"
    # echo -e $clc_str
    local num_str=$(($1))
    for it in `seq 0 1 $num_str`
    do
        echo -e "\033[2A"
        printf "\r\033[K"
    done
}


function mod() {
    if (($1 < 0)); then
        local res=$(($2 + ($1 % $2)))
    else
        local res=$(($1 % $2))
    fi
    echo $res
}

function UP {
    local res=$(mod $(($1 - ${#mons[@]})) $((${#mons[@]}*${#mons[@]})))
    echo $res
}
function DOWN {
    local res=$(mod $(($1 + ${#mons[@]})) $((${#mons[@]}*${#mons[@]})))
    echo $res
}
function LEFT {
    local res=$(mod $(($1 % ${#mons[@]} - 1)) ${#mons[@]})
    res=$((($1 / ${#mons[@]}) * ${#mons[@]} + res ))
    echo $res
}
function RIGHT {
    local res=$(mod $(($1 % ${#mons[@]} + 1)) ${#mons[@]})
    res=$((($1 / ${#mons[@]}) * ${#mons[@]} + res ))
    echo $res
}

function choosen_one {
    cur_idx=$(((${#mons[@]}>>1) * ${#mons[@]} + (${#mons[@]}>>1)))
    # echo -e $clc_str
    clear_n $((2*${#mons[@]}-1))
    input="-1"

    while true;
    do
        draw_cur $cur_idx
        for it in ${!mons[@]}
        do
            out_str="$it ${mons[it]}"
            echo $out_str
        done
        
        read -rsn1 input
        case $input in
            "w" | "W" | A) # "[D"
                cur_idx=$(UP $cur_idx)
            ;;
            "a" | "A" | D) # "[C"
                cur_idx=$(LEFT $cur_idx)
            ;;
            "s" | "S" | B)
                cur_idx=$(DOWN $cur_idx)
            ;;
            "d" | "D" | C)
                cur_idx=$(RIGHT $cur_idx)
            ;;
            "")
                clear_n $((2*${#mons[@]}-1))
                break
            ;;
        esac
        clear_n $((2*${#mons[@]}-1))
    done
    to=$cur_idx
}

function set_idx {
    local from_idx=$1   #from
    local disp_idx=$2   #to
    local flag=0
    local similar_idx=-1
    for it in ${!idx[@]}
    do
        if [ ${idx[it]} -eq $disp_idx ];then
            flag=1
            similar_idx=$it
            break 1
        fi
    done    

    if [ $flag -eq 1 ];then
        if [ $from_idx -ne $similar_idx ];then
            let "idx[$from_idx]=${idx[$from_idx]}^${idx[$similar_idx]}"
            let "idx[$similar_idx]=${idx[$from_idx]}^${idx[$similar_idx]}"
            let "idx[$from_idx]=${idx[$from_idx]}^${idx[$similar_idx]}"
        fi
    else
        idx[$from_idx]=$disp_idx
    fi
}

mons=($(xrandr | grep -aoP ".+?\s(?=connected)" | tr " " "\n"))
primary=$(xrandr | grep -aoP ".+?\s(?=connected primary)")
last_mon=$primary
idx=${!mons[@]}

for it in `seq 0 1 ${#idx[@]}`
do
	idx[it]=-1
done

mons=("aaa" "bbb" "ccc" "ddd")

declare -a matrix

len_mat=$((${#mons[@]}*${#mons[@]}))

for it in `seq 0 1 $len_mat`
do
    matrix[$it]=$it
done

    #TODO сделать проверку на конфигурацию и выбор шаблона
echo -e "Unknown configuration :( \n Entering manual mode...\n"
for ((;;))
do
    echo -e "Choose Wisely... \n 1) Save configuration and exit \n 2) Manual configuration \n 3) Off all exept primary"

    read checker
    clear_n 0
    case $checker in
    1)
        echo "dsdsdss"
    ;;
    2)
        for ((;;))
        do 
            draw_cur_mons
            read -n1 from
            printf "\r\033[K"
            re='^[0-9]'
            if ! [[ $from =~ $re ]] ; then
                clear_n $((2*${#mons[@]}-1))
                case $from in
                    'q'|'Q')
                        break
                    ;;
                    *)
                        continue
                    ;;
                esac
            fi
            to=0
            choosen_one 
            set_idx $from $to
        done
    ;;
    3)
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
        break
    ;;

    esac
    clear_n 6
done
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
