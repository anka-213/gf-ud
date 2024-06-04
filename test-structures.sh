cd grammars
gf -make StructuresEng.gf
echo "gr -probs=Structures.probs -number=10000 -cat=Top -depth=12 | wf -file=\"../out/1-structures-test.gft\"" | gf -run Structures.pgf
sort -u ../out/1-structures-test.gft >../out/2-structures-test.gft
echo "created out/2-structures-test.gft"
cd ..
cat out/2-structures-test.gft | gf-ud -gf2ud grammars/Structures Eng Top ud >out/1-structures-test.conllu
echo "created out/1-structures-test.conllu"
gf-ud cosine-similarity-sort ud/UD_English-EWT/en_ewt-ud-train.conllu out/1-structures-test.conllu -threshold 64 SUBTREETYPE >out/2-structures-test.conllu
echo "created out/2-structures-test.conllu"
##cat out/2-structures-test.conllu | gf-ud conll2pdf
cat out/2-structures-test.conllu | gf-ud statistics DEPREL
echo "POS not covered:"
gf-ud not-covered ud/UD_English-EWT/en_ewt-ud-test.conllu out/2-structures-test.conllu POS
echo "DEPREL not covered:"
gf-ud not-covered ud/UD_English-EWT/en_ewt-ud-test.conllu out/2-structures-test.conllu DEPREL
echo "DEPREL similarity:"
gf-ud cosine-similarity ud/UD_English-EWT/en_ewt-ud-test.conllu out/2-structures-test.conllu DEPREL
echo "SUBTREETYPE similarity:"
gf-ud cosine-similarity ud/UD_English-EWT/en_ewt-ud-test.conllu out/2-structures-test.conllu SUBTREETYPE

