green () {
  echo -e "\u001b[32m$1\u001b[0m"
}

yellow () {
  echo -e "\u001b[33m$1\u001b[0m" 
}

red () {
  echo -e "\u001b[31m$1\u001b[0m" 
}

Ram_usage () {

total=$((  $(cat /proc/meminfo | grep MemTotal: | sed 's|.* \([0-9]*\) kB|\1|' ) + $(cat /proc/meminfo | grep SwapTotal: | sed 's|.* \([0-9]*\) kB|\1|' ) ))

free=$(( $(cat /proc/meminfo | grep MemFree: | sed 's|.* \([0-9]*\) kB|\1|' ) + $(cat /proc/meminfo| grep SwapFree: | sed 's|.* \([0-9].*\) kB|\1|') ))

cache_buffer=$(( $(cat /proc/meminfo| grep ^Cached: | sed 's|.* \([0-9].*\) kB|\1|') + $(cat /proc/meminfo| grep Buffers: | sed 's|.* \([0-9].*\) kB|\1|') + $(cat /proc/meminfo | grep SReclaimable: | sed 's|.* \([0-9].*\) kB|\1|' ) ))


use=$(( ( $total - ( $free + $cache_buffer ) ) /1000 ))

total=$(( $total / 1000  ))

suff_t="MB"
suff_u="MB"

percent=$(( ( ( ( $use * 1000 ) / total ) +5 ) / 10 ))


if [ "${#total}" -gt 3 ]
then
	total=$(( $total / 1000 ))
	suff_t="GB"
fi

if [ "${#use}" -gt 3 ]
then
	free=$(( $use / 1000 ))
	suff_u="GB"
fi

i=0
bar=""


while [ $(( $percent /10 )) -gt $i ]   
do
	bar="$bar■"
	i=$(($i+1))
done

if [ $percent -gt 66 ]
then
	bar=$(red $bar)
else
	if [ $percent -gt 33 ]
	then
		bar=$(yellow $bar)
	else
		bar=$(green $bar)
	fi
fi

i=0

while [ $(( 10 - ( $percent / 10 ) )) -gt $i ]   
do
	bar="$bar "
	i=$(($i+1))
done

echo RAM use: $percent% \["$bar"\] $use $suff_u/$total $suff_t

}

white=$(echo -e "\u001b[0m")

echo $white

Ram_usage

