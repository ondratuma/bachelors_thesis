args=()

presentation=0

for argument in "$@"
do

    key=$(echo $argument | cut -f1 -d=)
    value=$(echo $argument | cut -f2 -d=)   

    if [[ $key == *"--"* ]]; then
        v="${key/--/}"
        declare $v=1 
   fi
done

if [ ${presentation}=="1" ]; then
   echo "Generating presentation"
   ROOT_FILE=prezentace_semestralni_projekt
   OUTPUT_FILE=prezentace_semestralni_projekt
else
   echo "Generating PDF work"
   ROOT_FILE=index
   OUTPUT_FILE=semestralni_prace
fi

cd build && pdfcsplain -halt-on-error "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..

git add .
git commit -m "date"

if [ ${presentation}=="1" ]; then
   echo "Done"
   exit
fi

PAGE_TEXT=""
x=1
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" -)
PAGE_COUNT_TOTAL=$(pdftk output/"${OUTPUT_FILE}.pdf" dump_data | grep NumberOfPages | awk -F ' ' '{print $2}')

while  [[ ! $PAGE_TEXT =~ .*Chapter.* ]]
do
  PAGE_TEXT=$(pdftotext -f $x -l $x "output/${OUTPUT_FILE}.pdf" -)
  x=$(( $x + 1 ))
done
NUMBER_OF_PRE_WORK_SIDES=$(( $x - 2 ))

x=$PAGE_COUNT_TOTAL
while  [[ ! $PAGE_TEXT =~ .*Reference.* ]]
do
  PAGE_TEXT=$(pdftotext -f $x -l $x "output/${OUTPUT_FILE}.pdf" -)
  x=$(( $x - 1 ))
done
PAGE_WITH_REFERENCES=$x

PAGE_TEXT=$(pdftotext -f $((NUMBER_OF_PRE_WORK_SIDES + 1)) -l $(($PAGE_WITH_REFERENCES - 1)) "output/${OUTPUT_FILE}.pdf" - | sed -E "s/^https:.*$//")

NUMBER_OF_WORDS=$(echo "$PAGE_TEXT" | wc -w)
NUMBER_OF_CHARS=$(echo "$PAGE_TEXT" | sed 's///g' | sed 's/\n//g' | wc -c)

NORMOSTRAN=$(echo "print(\"{:.2f}\".format($NUMBER_OF_CHARS/1800))" | python)
TEXT_PAGES=$(( $PAGE_WITH_REFERENCES - $NUMBER_OF_PRE_WORK_SIDES ))
NUMBER_OF_CHARS_TOTAL=$(pdftotext "output/${OUTPUT_FILE}.pdf" - | wc -c)



echo "------------------------------------"
echo "Celkem stran             : $PAGE_COUNT_TOTAL"
echo "Celkem znaků             : $NUMBER_OF_CHARS_TOTAL"
echo "Z toho generované strany : $(($PAGE_COUNT_TOTAL - $TEXT_PAGES))"
echo "Z toho nepočítané znaky  : $(($NUMBER_OF_CHARS_TOTAL - $NUMBER_OF_CHARS))"
echo "------------------------------------"
echo "Celkem slov textu        : $NUMBER_OF_WORDS"
echo "Celkem stran textu       : $TEXT_PAGES"
echo "------------------------------------"
echo "Znaků textu              : $NUMBER_OF_CHARS"
echo "Normostrany              : $NORMOSTRAN"




