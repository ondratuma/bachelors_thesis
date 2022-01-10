cd build && pdfcsplain index && mv index.pdf ../output && cd ..
git add .
git rm --cached index.pdf
git commit -m "date"
CHAR_COUNT=$(pdftotext output/index.pdf - | wc -m)
WORD_COUNT=$(pdftotext output/index.pdf - | wc -w)
echo "WORD COUNT: $WORD_COUNT"
echo "CHAR COUNT: $CHAR_COUNT"