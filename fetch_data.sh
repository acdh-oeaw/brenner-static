# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data/
curl -LO https://github.com/acdh-oeaw/brenner-data/archive/refs/heads/main.zip
unzip main

mv ./brenner-data-main/data/ .

rm main.zip
rm -rf ./brenner-data-main

echo "flattening data/edtitions/BR-*/*.xml into data/editions/*.xml"
python pyscripts/organize.py

echo "fetch imprint"
./shellscripts/dl_imprint.sh
