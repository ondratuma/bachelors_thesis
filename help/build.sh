FIRST_PAGE_TO_COUNT=9
ROOT_FILE=index
OUTPUT_FILE=index
cd build && pdfcsplain "$ROOT_FILE" && mv "${OUTPUT_FILE}.pdf" ../output && cd ..
git add .
git rm --cached "${OUTPUT_FILE}.pdf"
git commit -m "date"
CHAR_COUNT=$(pdftotext -f $FIRST_PAGE_TO_COUNT "output/${OUTPUT_FILE}.pdf" - | wc -m)
WORD_COUNT=$(pdftotext -f $FIRST_PAGE_TO_COUNT "output/${OUTPUT_FILE}.pdf" - | wc -w)
NORSMOSTRANY=$(( $CHAR_COUNT  ) * 100)
echo "---------------------------------------------------------------"
echo "CONVERTED"
echo "---------------------------------------------------------------"
echo "WORD COUNT: $WORD_COUNT"
echo "CHAR COUNT: $CHAR_COUNT"
scale=2;
echo "Normostrany: $NORSMOSTRANY"