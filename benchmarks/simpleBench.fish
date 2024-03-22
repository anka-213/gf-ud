for n in (seq 20); gawk -v n=$n '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at fastKeepTrying fastAllFunsLocal -- +RTS -s -H10M > /dev/null 2>| grep Total; end

for n in (seq 20); gawk -v n=$n '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at fastKeepTrying -- +RTS -s -H10M > /dev/null 2>| grep Total; end
for n in (seq 20); gawk -v n=$n '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at fastAllFunsLocal -- +RTS -s -H10M > /dev/null 2>| grep Total; end
for n in (seq 20); gawk -v n=$n '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at -- +RTS -s -H10M > /dev/null 2>| grep Total; end


gawk -v n=131 '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at  -- +RTS -s -H256M > /dev/null
gawk -v n=131 '/^$/{l++} l>=n{exit} {print}' upto12eng.conllu | stack run gf-ud ud2gf grammars/ShallowParse Eng Text at  -- +RTS -s -H10M > /dev/null
