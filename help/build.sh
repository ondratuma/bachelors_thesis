ROOT_FILE=index
OUTPUT_FILE=semestralni_prace
PAGE_TEXT=""
x=1
cd build && pdfcsplain -halt-on-error "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..

git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
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
NUMBER_OF_CHARS=$(echo "$PAGE_TEXT" | sed 's/ //g' | sed 's/\n//g' | wc -c)

NORMOSTRAN=$("python print($NUMBER_OF_CHARS/1800)")

echo "------------------------------------"
echo "Celkem slov       : $NUMBER_OF_WORDS"
echo "Celkem znaků      : $NUMBER_OF_CHARS"
echo "Celkem stran      : $PAGE_COUNT_TOTAL"
echo "Strany úvodu      : $NUMBER_OF_PRE_WORK_SIDES"
echo "Celkem stran textu: $(( $PAGE_WITH_REFERENCES - $NUMBER_OF_PRE_WORK_SIDES ))"
echo "Celkem normostran : $NORMOSTRAN"




