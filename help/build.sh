ROOT_FILE=index
OUTPUT_FILE=semestralni_prace
cd build && pdfcsplain "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..
git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" -)
NORSMOSTRANY=$(echo "$TEXT" | python help/parseText.py)
echo $NORSMOSTRANY