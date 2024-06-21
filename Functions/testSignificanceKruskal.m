function [testStruct] =  testSignificanceKruskal(BALData, values, category)



[p,tbl,stats] = kruskalwallis(BALData{:,values}, categorical(string(BALData{:,category})), 'off');

[c,~,~,gnames] = multcompare(stats, CriticalValueType="dunn-sidak", Display= "off");


resultMult = array2table(c,"VariableNames", ["Group_A","Group_B","Lower Limit","A-B","Upper Limit","P-value"]);

resultMult.Group_A = gnames(resultMult.Group_A);
resultMult.Group_B = gnames(resultMult.Group_B);

testStruct = struct;
testStruct.kruskal.p  = p;
testStruct.kruskal.tbl  = tbl;
testStruct.kruskal.stats  = stats;
testStruct.multcompare.result = resultMult;


disp('----------------------------------------------------------------------------------------');
disp('Kruskal-Wallis:');
disp(['p = ' num2str(p)]);
if p < 0.05; disp('Significant!'); else disp('Not signficant!');end
disp('----------------------------------------------------------------------------------------');

end
