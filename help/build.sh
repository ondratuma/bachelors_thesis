cd build && pdfcsplain index && mv index.pdf ../output && cd ..
git add .
git rm --cached index.pdf
git commit -m "date"
WORD_COUNT=$(pdftotext output/index.pdf - | wc -w)
echo "WORD COUNT: $WORD_COUNT"