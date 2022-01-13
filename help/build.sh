ROOT_FILE=index
OUTPUT_FILE=semestralni_prace
PAGE_TEXT=""
x=1
cd build && pdfcsplain -halt-on-error "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..

git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" -)
NORSMOSTRANY=$(echo "$TEXT" | python help/parseText.py)
echo "$NORSMOSTRANY"
PAGE_COUNT_TOTAL=$(pdftk output/"${OUTPUT_FILE}.pdf" dump_data | grep NumberOfPages | awk -F ' ' '{print $2}')

while  [[ ! $PAGE_TEXT =~ .*Chapter.* ]]
do
  PAGE_TEXT=$(pdftotext -f $x -l $x "output/${OUTPUT_FILE}.pdf" -)
  x=$(( $x + 1 ))
done

echo "První strana práce: $x"
echo "Celkem stran: $PAGE_COUNT_TOTAL"
echo "Celkem stran textu: $(( $PAGE_COUNT_TOTAL - $x + 1 ))"




