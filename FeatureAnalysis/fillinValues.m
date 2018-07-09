clear all, clc

PdxIndices = [29, 41, 42, 46, 48, 70, 71, 77, 86, 87, 94:102, 103:118, 119, 126, 225];
[disValue, disHeader] = xlsread('mcginnisdissertation8.2.16.xlsx');
[missValue, missHeader] = xlsread('EllenData_6.19.18.xlsx');

for y=1:length(disHeader)
    DissertationHeaders{y} = disHeader{1,y};
end
strValsToExtract = string(DissertationHeaders);
missHeader = string(missHeader);
k=1;
for x=1:length(strValsToExtract)
    for j=1:length(missHeader(1,:))
        if missHeader(1,j) == strValsToExtract(x)
            indMisVal(k) = j;
            k = k + 1;
        end
    end
end

oldDisValue = disValue;
indMisVal = [2, indMisVal];
MisVal = missValue(:,indMisVal);
headerMisVal = missHeader(1,indMisVal);

for i=1:length(disValue(:,1))
    PID = disValue(i,1);
    for j=1:length(disValue(1,:))
        if(isnan(disValue(i,j)) == 1)
            Header = strValsToExtract(j);
            row = find(MisVal(:,1) == PID);
            column = find(headerMisVal == Header);
            if ((isempty(row) == 0) && (isempty(column) == 0))
                disValue(i,j) = MisVal(row,column);
            end
            clear Header row column
        end
    end
    clear PID
end

T = table(disValue);

writetable(T, 'mcginnisdissertation8.2.16.UPDATED.VALUES.xlsx')