FIRST_PAGE_TO_COUNT=9
ROOT_FILE=index
OUTPUT_FILE=semestralni_prace
cd build && pdfcsplain "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..
git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" - | grep -o 'Chapter 1.*' )
CHAR_COUNT=$(echo $TEXT | wc -m)
WORD_COUNT=$(echo $TEXT | cut -f1 -d"References" | wc -w)
NORSMOSTRANY=$(echo "$TEXT" | python3 parseText.py)