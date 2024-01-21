#! /bin/bash
arr=("aaaa" "bbbb" "cccc")

matrix=()

for ((it=1; it<=$((${#arr[*]}*${#arr[*]}));it++))
do
    matrix+={$it}
done

echo ${arr[2]}
echo "Array size: ${#arr[*]}"
echo ${matrix[0]}
