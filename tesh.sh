mons=($(xrandr | grep -aoP ".+?\s(?=connected)" | tr " " "\n"))
idx=${!mons[@]}
conf_str=""
name="kometa"

for it in `seq 0 1 ${#idx[@]}`
do
	idx[it]=-1
done

function check_configs {
    local mons=$1
    local has_config=-1
    if [ -d "xrandr_configs" ]; then
        has_config=0
        local current_display_state_hash=$(echo -n $mons | md5sum | cut -d' ' -f1)
        local config_names=($(ls xrandr_configs | cut -d " " -f 1))
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
    local current_display_state_hash=$(echo -n $mons | md5sum | cut -d' ' -f1)


    if [ $flag -eq -1 ]; then
      mkdir xrandr_configs

    fi

    echo -e "name=$name \nscreens=${mons[@]} \nidx=${idx[@]}" > xrandr_configs/$current_display_state_hash

}

function read_config {
    eval `local mons=$$1`
    local current_display_state_hash=$(echo -n $mons | md5sum | cut -d' ' -f1)
    local conf_name=$(cat xrandr_configs/$current_display_state_hash | grep -aoP "(?<=name=).*")
    local conf_idx=($(cat xrandr_configs/$current_display_state_hash | grep -aoP "(?<=idx=).*" | tr " " "\n"))
    idx=${conf_idx[@]}
    echo ${idx[@]}
}

a=$(check_configs $mons)

#echo ${mons[@]}

#write_config $name $mons $idx $a

read_config $mons
