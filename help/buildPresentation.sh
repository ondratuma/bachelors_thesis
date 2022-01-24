ROOT_FILE=prezentace_semestralni_projekt
OUTPUT_FILE=prezentace_semestralni_projekt
PAGE_TEXT=""
x=1
cd build && pdfcsplain -halt-on-error "$ROOT_FILE" && mv "${ROOT_FILE}.pdf" ../output/"${OUTPUT_FILE}.pdf" && cd ..

git add .
git commit -m "date"




