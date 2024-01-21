#! /bin/bash

arr=("aaa" "bbbbb" "ccc")
idx=(-1 4 -1)
declare -a matrix

len_mat=$((${#arr[@]}*${#arr[@]}))

for it in `seq 0 1 $len_mat`
do
    matrix[$it]=$it
done

function draw_cur_mons {
    for i in ${!arr[@]}
    do
        out_str="|"
        for j in ${!arr[@]}
        do
            flg=0
            for it in ${!idx[@]}
            do
                if (($((${#arr[@]}*$i+$j)) == ${idx[$it]})); then
                    out_str+="_$it_|"
                    flg=1
                    break 1
                fi
            done
            [[ $flg = 1 ]] && continue
            out_str+="___|"        
        done
        echo $out_str
    done    
    for it in ${!arr[@]}
    do
        out_str="$it ${arr[it]}"
        echo $out_str
    done
}

function draw_cur {
    for i in ${!arr[@]}
    do
        out_str="|"
        for j in ${!arr[@]}
        do
            if ((${matrix[$((${#arr[@]}*$i+$j))]} == $1)); then
                out_str+="_+_|"
            else
                out_str+="___|"
            fi        
        done
        echo $out_str
    done    
    echo ${arr[@]}
}
# TODO сделать, чтоб решётка не ехала
clc_str="\033[""$((2*${#arr[@]}))""A"



function mod() {
    if (($1 < 0)); then
        local res=$(($2 + ($1 % $2)))
    else
        local res=$(($1 % $2))
    fi
    echo $res
}

function UP {
    local res=$(mod $(($1 - ${#arr[@]})) $((${#arr[@]}*${#arr[@]})))
    echo $res
}
function DOWN {
    local res=$(mod $(($1 + ${#arr[@]})) $((${#arr[@]}*${#arr[@]})))
    echo $res
}
function LEFT {
    local res=$(mod $(($1 % ${#arr[@]} - 1)) ${#arr[@]})
    res=$((($1 / ${#arr[@]}) * ${#arr[@]} + res ))
    echo $res
}
function RIGHT {
    local res=$(mod $(($1 % ${#arr[@]} + 1)) ${#arr[@]})
    res=$((($1 / ${#arr[@]}) * ${#arr[@]} + res ))
    echo $res
}

function choosen_one {
    cur_idx=$(((${#arr[@]}>>1) * ${#arr[@]} + (${#arr[@]}>>1)))
    echo $cur_idx
    input="-1"
    while true;
    do
        draw_cur $cur_idx
        echo ${idx[@]}
        
        read -rsn1 input
        case $input in
            "w" | "W")
                cur_idx=$(UP $cur_idx)
            ;;
            "a" | "A")
                cur_idx=$(LEFT $cur_idx)
            ;;
            "s" | "S")
                cur_idx=$(DOWN $cur_idx)
            ;;
            "d" | "D")
                cur_idx=$(RIGHT $cur_idx)
            ;;
            "")
                break
            ;;
        esac
        echo -e $clc_str
    done
    echo $cur_idx
}


choosen_one
# for ((;;))
# do 
#     draw_cur_mons
#     read from
#     to=$(choosen_one)
#     idx[$from]=$to
#     echo -e "\033[2A"
# done