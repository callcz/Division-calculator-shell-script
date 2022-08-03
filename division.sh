#!/bin/bash
## This is a division shell script, Calculate decimals using 'expr'.
## Writen by callcz 20220801
if [[ $1 == '--help' || $1 == '-h' || ! $1 ]]
then
	head -n3 $0
	echo "  Usage: $0 [DIVIDEND] [DIVISOR] [SCALE]"
	echo "  Default SCALE val is '10'"
	exit
fi
#检查参数格式是否数字
if [[ $4 ]];then echo Unknow option - \"$4\"&&exit 1;fi
div_proto=($*)
div=(${div_proto[@]})
for ((i=0;i<${#div[@]};i++))
do
	for j in ${div[$i]}
	do
		if [[ ${j:0:1} == '-' ]]
		then
			minus_n=$(expr $minus_n + 1)
			div[$i]=${j#-}
		fi
	done
done
#echo ${div[@]}
if [[ $(expr ${minus_n:-0} % 2) -ne 0 ]]
then
	minus=1
else
	minus=0
fi
#echo $minus
for ((i=0;i<${#div[@]};i++))
do
#	echo $i
	for j in ${div[$i]}
	do
		unset check_1
#		echo $j
#		echo ${#j}
		for ((k=0;k<${#j};k++))
		do
			l=${j:$k:1}
			check=0
			for m in {0..9} '.'
			do
#				echo $m
#				echo $l
				if [[ $l == '.' && ${#j} == '1' ]]
				then
					check=0
				elif [[ $m == $l ]]
				then
					check=1
					if [[ $l == '.' ]]
					then
						check_1=$(expr $check_1 + 1)
					fi
				fi
			done
			if [[ $check == 0 ]]
			then
				echo \"${div_proto[$i]}\" is no a figure.
				exit $(expr $i + 2)
			fi
			if [[ $check_1 -gt 1 ]]
			then
				echo "There are more then one '.' in '${div_proto[$i]}'"
				exit $(expr $i + 1)
			fi
		done
	done
done

dividend=${div[0]}
divisor=${div[1]}
scale=${div[2]}
beichu=$dividend
chu=$divisor
if [[ ! $3 ]]
then
	scale=10
fi
#去掉小数点
if [[ ${beichu#*.} != $beichu ]]
then
	beichu_zhengshu=${beichu%.*}
	beichu_xiaoshu=${beichu#*.}
	beichu=$beichu_zhengshu$beichu_xiaoshu
else
	beichu_xiaoshu=
fi
if [[ ${chu#*.} != $chu ]]
then
	chu_zhengshu=${chu%.*}
	chu_xiaoshu=${chu#*.}
	chu=$chu_zhengshu$chu_xiaoshu
else
	chu_xiaoshu=
fi
if [[ ${#beichu_xiaoshu} -ge ${#chu_xiaoshu} ]]
then
	p=${#beichu_xiaoshu}
else
	p=${#chu_xiaoshu}
fi
for ((i=0;i<$p;i++))
do
	if [[ ! ${beichu_xiaoshu:$i} ]]
	then
		beichu=${beichu}0
	fi
	if [[ ! ${chu_xiaoshu:$i} ]]
	then
		chu=${chu}0
	fi
done
#去掉前面的零
if [[ $beichu -eq 0 ]]
then
	deshu=0
	echo $deshu
	exit 0
fi
while [[ ${beichu:0:1} -eq 0 ]]
do
	beichu=${beichu:1}
done
if [[ $chu -eq 0 ]]
then
	deshu="[DIVISOR] can't be ZERO!"
	echo $deshu
	exit 3
fi
while [[ ${chu:0:1}  -eq 0 ]]
do
	chu=${chu:1}
done

#echo $beichu $chu
#D/d
shang=$(expr $beichu \/ $chu)
yu=$(expr $beichu % $chu)
#echo shang=$shang yu=$yu
#余数为0，可以被整除
if [[ $yu -eq 0 ]]
then
	deshu=$shang
#	echo $deshu
#	exit
fi
#余数不为0
while [[ $yu -ne 0 ]]
do
#余数小于除数需要借位
	jiewei=0
	while [[ $yu -lt $chu ]]
	do
		jiewei=$(expr $jiewei + 1)
		yu=$(expr $yu \* 10)
	done
#小数后面补零，每次补零n+1
	for ((i=1;i<$jiewei;i++))
	do
		xiaoshu=${xiaoshu}0
		n=$(expr $n + 1)
#		echo n=$n
#		echo z=$xiaoshu
		if [[ $n -gt $scale ]]
		then
			break
		fi
	done
#计算小数，每增加一位n+1
	if [[ $n -le $scale ]]
	then
		zhi=$(expr $yu \/ $chu)
#		echo zhi=$zhi
		yu=$(expr $yu % $chu)
#		echo yu2=$yu
		xiaoshu=$xiaoshu$zhi
#		echo xiaoshu=$xiaoshu
		n=$(expr $n + 1)
#		echo n=$n
#		echo $xiaoshu
#		echo $zhi
	fi
#如小数位到达小数点后保留位数
	if [[ ${#xiaoshu} -gt $scale ]]
	then
		xiaoshu=${xiaoshu:0:$(expr $scale + 1)}
#计算四舍五入
		if [[ ${xiaoshu:0-1:1} -ge 5 ]]
		then
			if [[ ${xiaoshu:0:1} -eq 0 ]]
			then
				kz_xiaoshu=$xiaoshu
				while [[ ${kz_xiaoshu:0:1} -eq 0 ]]
				do
					kz_xiaoshu=${kz_xiaoshu:1}
					wc=$(expr $wc + 1)
				done
				kz_xiaoshu=$(expr ${kz_xiaoshu:0:$(expr ${#kz_xiaoshu} - 1)} + 1)
#				echo $kz_xiaoshu
				for ((j=0;j<$wc;j++))
				do
					kz_xiaoshu=0${kz_xiaoshu}
				done
				xiaoshu=$kz_xiaoshu
			else
				wl_xiaoshu=$(expr ${xiaoshu:0:$(expr ${#xiaoshu} - 1)} + 1)
				if [[ ${#wl_xiaoshu} -eq ${#xiaoshu} ]]
				then
					shang=$(expr $shang + 1)
					xiaoshu=${wl_xiaoshu:1}
				else
					xiaoshu=$wl_xiaoshu
				fi
			fi
		else
			xiaoshu=${xiaoshu:0:$(expr ${#xiaoshu} - 1)}
		fi
#		echo $xiaoshu
		if [[ $scale -eq 0 ]]
		then
			deshu=$shang
		else
			deshu=$shang.$xiaoshu
		fi
		break
	fi
#如小数位可以除尽
	if [[ $yu -eq 0 ]]
	then
		deshu=$shang.$xiaoshu
	fi
done
#输出得数
echo scale=$scale
if [[ $minus -eq 1 ]]
then
	deshu='-'$deshu
fi
echo $deshu
exit
