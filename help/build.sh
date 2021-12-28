cd build && pdfcsplain index && mv index.pdf ../output && cd ..
git add .
git rm --cached index.pdf
git commit -m "date"