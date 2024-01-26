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
    for it in ${!arr[@]}
    do
        out_str="$it ${arr[it]}           ${idx[it]}"
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
                flg=0
                for it in ${!idx[@]}
                do
                    if (($((${#arr[@]}*$i+$j)) == ${idx[$it]})); then
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
# clc_str="\033[""$((2*${#arr[@]}+2))""A"
# $((2*${#arr[@]}+2))
function clear_n {
    local clc_str="\033[""$1""A"
    echo -e $clc_str
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
    # echo -e $clc_str
    clear_n $((2*${#arr[@]}+1))
    input="-1"
    ESC=$'\033'
    while true;
    do
        draw_cur $cur_idx
        for it in ${!arr[@]}
        do
            out_str="$it ${arr[it]}"
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
                clear_n $((2*${#arr[@]}+1))
                break
            ;;
        esac
        clear_n $((2*${#arr[@]}+1))
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

for ((;;))
do 
    draw_cur_mons
    read -n1 from
    # if (($from == "q" || $from == "Q"));then
    #     printf "\r\033[K"
    #     break
    # elif [[ ! $from || $from = *[^0-9]* ]];then
        printf "\r\033[K"
        to=0
        choosen_one 
        set_idx $from $to
        
    # fi
done

    # draw_cur_mons
    # read -n1 from
    #     to=0
    #     choosen_one 
    # echo ${idx[@]}