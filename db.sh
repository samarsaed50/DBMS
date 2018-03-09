#!/bin/bash
add_record(){
read -p "Enter table name:" tableName
  if  [ ! -f $tableName ]
     then
    echo "Table $tableName does not  existed ,choose another Table"
  fi
colsNum=`awk 'END{print NR}' .$tableName`
i=2
separete="|"
newln="\n"
while [ $i -le $colsNum ]
do
colName=`awk 'BEGIN{FS="|"} {if(NR=='$i') print $1}' .$tableName`
colType=`awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName`
colKey=`awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName`
read -p "Enter the value of $colName ($colType):"  val

if [[ $colType == "int" ]]
 then
 while ! [[ $val =~ ^[0-9]*$  ]]
do
echo "invalid datatype"
read -p "Enter the value of $colName ($colType):" val
done
else
 while ! [[ $val =~ ^[A-Za-z][A-Za-z0-9]*$  ]]
do
echo "invalid datatype"
read -p "Enter the value of $colName ($colType):" val
done
fi
if [[ $colKey == "PK" ]] 
 then
fieldsNum=`awk 'BEGIN{FS="|"} {if(NR=='1') print NF}' $tableName`
j=1
while [ $j -le $fieldsNum ]
do
colname=`awk -v var="$j" 'BEGIN{FS="|"} {if(NR=='1') print $var}' $tableName`
if [[ $colName == $colname ]]
then
k=2
linesNum=`awk 'END{print NR}' $tableName`
while [ $k -le $linesNum ]
do
oldVal=`awk -v varr="$j" 'BEGIN{FS="|";ORS="\n"} {if(NR=='$k') print $varr}' $tableName`
if [[ $val == $oldVal ]]
then
echo "sorry it is primary key, dublicated value"
read -p "Enter the value of $colName ($colType):" val
fi
((k++))
done
fi
((j++))
done 
fi
if [ $i == $colsNum ]
 then
 rowVal=$rowVal$val
 else
 rowVal=$rowVal$val$separete
fi
((i++))
done
echo  $rowVal >> $tableName
if [[ $? == 0 ]]
  then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tableName"
  fi
rowVal=""
}
add_record
updateTable() {
 read -p "Enter table name:" tableName
 if  [ ! -f $tableName ]
     then
    echo "Table $tableName does not  existed ,choose another Table"
  fi
fieldsNum=`awk 'BEGIN{FS="|"} {if(NR=='1') print NF}' $tableName`
 j=1
while [ $j -le $fieldsNum ]
do
colname=`awk -v var="$j" 'BEGIN{FS="|"} {if(NR=='1') print $var}' $tableName`
fNo=$j
k=2
linesNum=`awk 'END{print NR}' $tableName`
while [ $k -le $linesNum ]
do
val=`awk -v varr="$j" 'BEGIN{FS="|";ORS="\n"} {if(NR=='$k') print $varr}' $tableName`
read -p  "Enter Column name to set: " colSet
 colsNum=`awk 'END{print NR}' .$tableName`
l=2
while [ $l -le $colsNum ]
do
colName=`awk 'BEGIN{FS="|"} {if(NR=='$l') print $1}' .$tableName`
colType=`awk 'BEGIN{FS="|"}{if(NR=='$l') print $2}' .$tableName`
colKey=`awk 'BEGIN{FS="|"}{if(NR=='$l') print $3}' .$tableName`
if [[ $colSet == $colName ]]
then
setfNo=$l
read -p "Enter new value to set $colName ($colType): " newVal
if [[ $colType == "int" ]]
 then
 while ! [[ $newVal =~ ^[0-9]*$  ]]
do
echo "invalid datatype"
read -p "Enter new value to set $colName ($colType): " newVal
done
else
 while ! [[ $newVal =~ ^[A-Za-z][A-Za-z0-9]*$  ]]
do
echo "invalid datatype"
read -p "Enter new value to set $colName ($colType): " newVal
done
fi
if [[ $colKey == "PK" ]]
 then
fieldsNo=`awk 'BEGIN{FS="|"} {if(NR=='1') print NF}' $tableName`
n=1
while [ $n -le $fieldsNo ]
do
colnamee=`awk -v var="$n" 'BEGIN{FS="|"} {if(NR=='1') print $var}' $tableName`
if [[ $colName == $colnamee ]]
then
x=2
linesNo=`awk 'END{print NR}' $tableName`
while [ $x -le $linesNo ]
do
oldVal=`awk -v varr="$n" 'BEGIN{FS="|";ORS="\n"} {if(NR=='$x') print $varr}' $tableName`
if [[ $newVal == $oldVal ]]
then
echo "sorry it is primary key, dublicated value"
read -p "Enter new value to set $colName ($colType): " newVal
fi
((x++))
done
fi
((n++))
done
fi
read -p "Enter value to be updated: " old_val
result=$(cat $tableName | grep "$old_val")
update=$(sed -i 's/'$old_val'/'$newVal'/g' $tableName)
fi
((l++))
done
((k++))
done
((j++))
done
}
updateTable
