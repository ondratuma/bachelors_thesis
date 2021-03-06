set -e

args=()

if [ $1 == "presentation" ]; then
   echo "Generating presentation"
   ROOT_FILE=prezentace_semestralni_projekt
   OUTPUT_FILE=prezentace_semestralni_projekt
elif [ $1 == "defense" ]; then
   echo "Generating presentation"
   ROOT_FILE=obhajoba
   OUTPUT_FILE=obhajoba
else
   echo "Generating PDF work"
   ROOT_FILE=index
   OUTPUT_FILE=bakalarska_prace
fi

rm -rf output/*
cd build
pdfcsplain -halt-on-error "$ROOT_FILE" 
pdfcsplain -halt-on-error "$ROOT_FILE" 
pdfcsplain -halt-on-error "$ROOT_FILE" 
mv "${ROOT_FILE}.pdf" ../output/temp.pdf
cp ../output/temp.pdf  ../output/"${OUTPUT_FILE}.pdf" 
gs -dPDFSETTINGS=/ebook -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dCompatibilityLevel=1.7 -dPrinted=false -o ../output/"${OUTPUT_FILE}_print.pdf" ../output/temp.pdf
rm -rf ./output/temp.pdf
cd ..

if [ [ $1 == "defense" ] || [ $1 == "presentation" ] ]; then
   echo "Done"
   exit
fi

git add .
git commit -m "date"

if [[ ! -f "output/${OUTPUT_FILE}.pdf" ]] ; then
    echo file does not exists.
    exit 1
fi

PAGE_TEXT=""
x=1
TEXT=$(pdftotext "output/${OUTPUT_FILE}.pdf" -)
PAGE_COUNT_TOTAL=$(pdftk output/"${OUTPUT_FILE}.pdf" dump_data | grep NumberOfPages | awk -F ' ' '{print $2}')
echo $TEXT > output/"${OUTPUT_FILE}.txt"
ORIGINAL_FILE_SIZE=$(du -h "output/${OUTPUT_FILE}.pdf" | awk -F ' ' '{print $1}')
PRINT_FILE_SIZE=$(du -h "output/${OUTPUT_FILE}_print.pdf" | awk -F ' ' '{print $1}')

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
NUMBER_OF_CHARS=$(echo "$PAGE_TEXT" | sed 's/\n//g' | wc -c)

NORMOSTRAN=$(echo "print(\"{:.2f}\".format($NUMBER_OF_CHARS/1800))" | python)
TEXT_PAGES=$(( $PAGE_WITH_REFERENCES - $NUMBER_OF_PRE_WORK_SIDES ))
NUMBER_OF_CHARS_TOTAL=$(pdftotext "output/${OUTPUT_FILE}.pdf" - | wc -c)



echo "------------------------------------"
echo "Celkem stran             : $PAGE_COUNT_TOTAL"
echo "Celkem znak??             : $NUMBER_OF_CHARS_TOTAL"
echo "Z toho generovan?? strany : $(($PAGE_COUNT_TOTAL - $TEXT_PAGES))"
echo "Z toho nepo????tan?? znaky  : $(($NUMBER_OF_CHARS_TOTAL - $NUMBER_OF_CHARS))"
echo "------------------------------------"
echo "Celkem slov textu        : $NUMBER_OF_WORDS"
echo "Celkem stran textu       : $TEXT_PAGES"
echo "------------------------------------"
echo "Znak?? textu              : $NUMBER_OF_CHARS"
echo "Normostrany              : $NORMOSTRAN"
echo "Velikost souboru         : $ORIGINAL_FILE_SIZE"
echo "Velikost souboru k tisku : $PRINT_FILE_SIZE"




