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

function clear_n {
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

function check_index {
    local idx_for_check=$1
    local flag=0
    for ids in ${idx[@]}
    do 
        if [ $idx_for_check -eq $ids ]; then
            flag=1
            break
        fi
    done
    echo $flag
}

function find_mon_idx {
    local matrix_idx=$1
    local out_idx=-1

    for it in ${!idx[@]}
    do
        if [ $matrix_idx -eq ${idx[it]} ]; then
            out_idx=$it
            break
        fi
    done
    echo $out_idx
}


function set_monitor_position {
    local prev_idx=$1
    local curr_idx=$2
    local curr_idx_up=$(check_index $(UP $curr_idx))
    local curr_idx_down=$(check_index $(DOWN $curr_idx))
    local curr_idx_left=$(check_index $(LEFT $curr_idx))
    local curr_idx_right=$(check_index $(RIGHT $curr_idx))
    local monitor_idx=0
    local curr_monitor_idx=$(find_mon_idx $curr_idx)

    if [ $curr_idx_up -eq 1 ]; then
        if [ $(($curr_idx/${#mons[@]})) -ne 0 ]; then
            if [ $(UP $curr_idx) -ne $prev_idx ]; then
                monitor_idx=$(find_mon_idx $(UP $curr_idx))
                conf_str+="xrandr --output ${mons[monitor_idx]} --above ${mons[curr_monitor_idx]};"
                set_monitor_position $curr_idx $(UP $curr_idx)
            fi
        fi
    fi
    if [ $curr_idx_down -eq 1 ]; then
        if [ $(($curr_idx/${#mons[@]})) -ne $((${#mons[@]}-1)) ]; then
            if [ $(DOWN $curr_idx) -ne $prev_idx ]; then
                monitor_idx=$(find_mon_idx $(DOWN $curr_idx))
                conf_str+="xrandr --output ${mons[monitor_idx]} --below ${mons[curr_monitor_idx]};"
                set_monitor_position $curr_idx $(DOWN $curr_idx)
            fi
        fi
    fi
    if [ $curr_idx_left -eq 1 ]; then
        if [ $(($curr_idx%${#mons[@]})) -ne 0 ]; then
            if [ $(LEFT $curr_idx) -ne $prev_idx ]; then
                monitor_idx=$(find_mon_idx $(LEFT $curr_idx))
                conf_str+="xrandr --output ${mons[monitor_idx]} --left-of ${mons[curr_monitor_idx]};"
                set_monitor_position $curr_idx $(LEFT $curr_idx)
            fi
        fi
    fi
    if [ $curr_idx_right -eq 1 ]; then
        if [ $(($curr_idx%${#mons[@]})) -ne $((${#mons[@]}-1)) ]; then
            if [ $(RIGHT $curr_idx) -ne $prev_idx ]; then
                monitor_idx=$(find_mon_idx $(RIGHT $curr_idx))
                conf_str+="xrandr --output ${mons[monitor_idx]} --right-of ${mons[curr_monitor_idx]};"
                set_monitor_position $curr_idx $(RIGHT $curr_idx)
            fi
        fi
    fi

}

function check_configs {
    local has_config=-1
    local hasdir=$(ls -la ~ | grep .xrandrs | wc -l)
    if [ $hasdir -eq 1 ]; then
        has_config=0
        local current_display_state_hash=$1
        local config_names=($(ls ~/.xrandrs | cut -d " " -f 1))
        for files_idx in ${config_names[@]}
        do
            if [ $current_display_state_hash = $files_idx ]; then
                has_config=1
                break
            fi
        done
    fi
    echo $has_config
}

function write_config {
    local name=$1
    eval `local mons=$$2`
    local idxs=$3
    local flag=$4
    local current_display_state_hash=$5

    if [ $flag -eq -1 ]; then
      mkdir ~/.xrandrs
    fi

    echo -e "name=$name\nscreens=${mons[@]}\nidx=${idx[@]}" > ~/.xrandrs/$current_display_state_hash
}

function read_config {
    local current_display_state_hash=$1
    conf_name=$(cat ~/.xrandrs/$current_display_state_hash | grep -aoP "(?<=name=).*")
    conf_idx=($(cat ~/.xrandrs/$current_display_state_hash | grep -aoP "(?<=idx=).*" | tr " " "\n"))
}

function resolve_config {
    for it in `seq 1 1 $((${#mons[@]}-1))`
    do
        conf_str+="xrandr --output ${mons[it]} --mode 1920x1080;"
    done
    set_monitor_position ${idx[0]} ${idx[0]}

    eval $conf_str
}


mons=($(xrandr | grep -aoP ".+?\s(?=connected)" | tr " " "\n"))
primary=$(xrandr | grep -aoP ".+?\s(?=connected primary)")
last_mon=$primary
idx=${!mons[@]}
name="default"
conf_str=""
current_display_state_hash=$(echo -n ${mons[@]} | md5sum | cut -d' ' -f1)
conf_is_finded=$(check_configs $current_display_state_hash)

for it in `seq 0 1 ${#idx[@]}`
do
	idx[it]=-1
done

declare -a matrix

len_mat=$((${#mons[@]}*${#mons[@]}))

for it in `seq 0 1 $len_mat`
do
    matrix[$it]=$it
done

if [ $conf_is_finded -eq 1 ]; then
    conf_name=""
    conf_idx=""
    read_config $current_display_state_hash

    echo -e "Config \`$conf_name\` is detected."
    read -r -p "Enable config? (yes/edit/no) " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo -e "Enabling \`$conf_name\`..."
            for it in ${!conf_idx[@]}
            do
                idx[it]=${conf_idx[it]}
            done
            name=$conf_name
            resolve_config
            exit
        ;;
        [eE][dD][iI][tT]|[eE])
            echo -e "Enabling \`$conf_name\`..."
            for it in ${!conf_idx[@]}
            do
                idx[it]=${conf_idx[it]}
            done

            name=$conf_name
        ;;
        *)
            echo -e "Entering manual mode...\n"
        ;;
    esac

else
    echo -e "Unknown configuration :( \n Entering manual mode...\n"
fi


for ((;;))
do
    echo -e "Choose Wisely... \n 1) Save configuration and exit \n 2) Manual configuration \n 3) Off all exept primary"

    read checker
    clear_n 0
    case $checker in
    1)
        read -r -p "Enter config name: " name
        resolve_config
        write_config $name mons $idx $conf_is_finded $current_display_state_hash
        break
    ;;
    2)
        re="^[0-$((${#mons[@]}-1))]"
        for ((;;))
        do 
            draw_cur_mons
            read -n1 from
            if [ -z "$from" ]; then
                printf "\r\033[K"
                clear_n $((2*${#mons[@]}))
                continue
            fi
            printf "\r\033[K"
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
                 xrandr --output $mon --off
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
