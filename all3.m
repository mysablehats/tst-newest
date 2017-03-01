function [data,labels_names, skelldef] = all3(allskel, simvar)
[allskel] = conformactions(allskel, simvar.prefilter);
for i= 1:length(allskel)
    allskel(i).indexact = i;
end
[data, labels_names] = extractdata(allskel, simvar.activity_type, simvar.labels_names,simvar.extract{:});
if 0 %isfield(simvar, 'notzeroedaction')
    
    
    a.train = data;
    pld = data.data.';
    figure
    plot(pld)
    %error('stops!')
    showdataset(a,simvar)
    disp('hello')
else
    [data, skelldef] = conformskel(data, simvar.preconditions{:});
end
end