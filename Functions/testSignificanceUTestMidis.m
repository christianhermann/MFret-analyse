function [testCell] =  testSignificanceUTestMidis(BALData, Midi1, MidiList, Variable)
thresholds = [0.001, 0.01, 0.05];

testData1 = BALData(BALData.newMidi == Midi1,:).(Variable);

for i = 1:length(MidiList)
    testData{i,:} = BALData(BALData.newMidi == MidiList(i),:).(Variable);
    p(i) = ranksum(testData1, testData{i,:});
    s(i) = string(repelem('*', nnz(p(i) < thresholds)));
    disp('----------------------------------------------------------------------------------------');
    disp(['Mann-Whitney U-test: ' Midi1 ' vs ' MidiList(i) ':']);
    disp(['p = ' num2str(p(i))]);
    if p(i) < 0.05; disp('Significant!'); else disp('Not signficant!');end
    disp('----------------------------------------------------------------------------------------');

    testCell{1,i} = strjoin([Midi1 ' vs ' MidiList(i)]);
    testCell{2,i} = p(i);
    testCell{3,i} = s(i);

end




end
