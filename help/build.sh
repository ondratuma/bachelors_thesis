FIRST_PAGE_TO_COUNT=9
ROOT_FILE=index
OUTPUT_FILE=semestralni_prace
cd build && pdfcsplain "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..
git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" -)
CHAR_COUNT=$(echo $TEXT | wc -m)
WORD_COUNT=$(echo $TEXT | cut -f1 -d"References" | wc -w)
NORSMOSTRANY=$(echo "print(\"{:.2f}\".format(float(${CHAR_COUNT})/1800))" | python3)
echo "---------------------------------------------------------------"
echo "CONVERTED"
echo "---------------------------------------------------------------"
echo "WORD COUNT: $WORD_COUNT"
echo "CHAR COUNT: $CHAR_COUNT"
echo "Normostrany: $NORSMOSTRANY"