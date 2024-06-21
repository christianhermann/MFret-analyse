function [testCell] =  testSignificanceUTestReceptor(BALData, Midi1,Variable)
Midi2 = [Midi1 '+122'];
Midi3 = [Midi1 '+362'];

testData1 = BALData(BALData.newMidi == Midi1,:).(Variable);
testData2 = BALData(BALData.newMidi == Midi2,:).(Variable);
testData3 = BALData(BALData.newMidi == Midi3,:).(Variable);

p1 = ranksum(testData1, testData2);
p2= ranksum(testData1, testData3);
p3= ranksum(testData2, testData3);
% Define thresholds
thresholds = [0.001, 0.01, 0.05];
% Compare p1, p2, and p3 to the thresholds and assign the corresponding values to s1, s2, and s3
s1 = repelem('*', nnz(p1 < thresholds));
s2 = repelem('*', nnz(p2 < thresholds));
s3 = repelem('*', nnz(p3 < thresholds));

disp('----------------------------------------------------------------------------------------');
disp(['Mann-Whitney U-test: ' Midi1 ' vs ' Midi2 ':']);
disp(['p = ' num2str(p1)]);
if p1 < 0.05; disp('Significant!'); else disp('Not signficant!');end
disp('----------------------------------------------------------------------------------------');
disp(['Mann-Whitney U-test: ' Midi1 ' vs ' Midi3 ':']);
disp(['p = ' num2str(p2)]);
if p2 < 0.05; disp('Significant!'); else disp('Not signficant!');end
disp('----------------------------------------------------------------------------------------');
disp(['Mann-Whitney U-test: ' Midi2 ' vs ' Midi3 ':']);
disp(['p = ' num2str(p3)]);
if p3 < 0.05; disp('Significant!'); else disp('Not signficant!');end
disp('----------------------------------------------------------------------------------------');

testCell{1,1} = [Midi1 ' vs ' Midi2];
testCell{1,2} = [Midi1 ' vs ' Midi3];
testCell{1,3} = [Midi2 ' vs ' Midi3];
testCell{2,1} = p1;
testCell{2,2} = p2;
testCell{2,3} = p3;
testCell{3,1} = s1;
testCell{3,2} = s2;
testCell{3,3} = s3;

end