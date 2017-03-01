function newmt = mtmodefilter(mt,numnum)
%%%

newmt(size(mt)) = struct();
for i = 1:size(newmt,1)
    for j = 1:size(newmt,2)
        newmt(i,j).conffig.val{1} = mt(i,j).conffig.val{1};
        newmt(i,j).conffig.val{2} = modefilter(mt(i,j).conffig.val{2},numnum);
        newmt(i,j).conffig.val{3} = strcat(mt(i,j).conffig.val{3},'m',num2str(numnum)); % so that I remember this is after the mode filter
        
        %%%% and same thing for training set
        newmt(i,j).conffig.train{1} = mt(i,j).conffig.train{1};
        newmt(i,j).conffig.train{2} = modefilter(mt(i,j).conffig.train{2},numnum);
        newmt(i,j).conffig.train{3} = strcat(mt(i,j).conffig.train{3},'m',num2str(numnum)); % so that I remember this is after the mode filter
        
    end
end
function bigx= modefilter(series,numnum)

%%%first we need to transfor the large matriz into a vector
num_classes = size(series,1);
serieslength = size(series,2);
diagmat = diag(1:num_classes);

newseries = sum(diagmat*series,1);

x = zeros(1,serieslength);

for ii = numnum:serieslength
     x((ii-numnum+1):ii) = mode(newseries((ii-numnum+1):ii));
end

if num_classes == 1 %%% if it is onedimensional thing, then it is done
    bigx = x;
else
    
    %%%Otherwise we need to go back to were came from
    bigx = zeros(num_classes,serieslength);
    
    for ii = 1:serieslength
        bigx(x(ii),ii) = 1;
    end

end