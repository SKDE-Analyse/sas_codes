A combination of "all" the SAS code repositories at SKDE


## Which repositories have been combined

This repository is a combination of the following (now obsolete) repositores:
- https://github.com/SKDE-Analyse/sas_figurer
- https://github.com/SKDE-Analyse/sas_formater
- https://github.com/SKDE-Analyse/sas_makroer
- https://github.com/SKDE-Analyse/tilrettelegging
- https://github.com/SKDE-Analyse/rateprogram

They have been combined using [this method](https://stackoverflow.com/a/618113):
```
mkdir sas_codes
cd sas_codes
git clone git@github.com:SKDE-Analyse/sas_figurer include
git clone git@github.com:SKDE-Analyse/sas_formater formater
git clone git@github.com:SKDE-Analyse/sas_makroer makroer
git clone git@github.com:SKDE-Analyse/tilrettelegging tilrettelegging
git clone git@github.com:SKDE-Analyse/rateprogram rateprogram

# Do the following for makroer tilrettelegging include formater rateprogram
cd makroer
git filter-branch --index-filter \
    'git ls-files -s | sed "s-\t-&makroer/-" |
     GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
     git update-index --index-info &&
     mv $GIT_INDEX_FILE.new $GIT_INDEX_FILE' HEAD
cd ..


git init

for i in makroer tilrettelegging include formater rateprogram; do
git pull $i --allow-unrelated-histories
rm -rf ${i}/${i}
rm ${i}/.git
done
```

