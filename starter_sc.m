function [ss, metrics, gases] = starter_sc(ss, arq_connect)
%gases = [];
%% starter_sc
% This is the main function to run the chained classifier, label and
% generate confusion matrices and recall, precision and F1 values for the
% skeleton classifier of activities using an architecture of chained neural
% gases on skeleton activities data (the STS V2 Dataset). This work is an
% attempt to implement Parisi, 2015's paper.

%%
global VERBOSE LOGIT
VERBOSE = true;
LOGIT = true;
dbgmsg('ENTERING MAIN LOOP',0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% making metrics structure

metrics = struct('confusions',[],'conffig',[],'outparams',[]);

whatIlabel = 1:length(ss.gas); %change this series for only the last value to label only the last gas

%%% end of gas structures region

[ss.gas, ss.train] = sameclassfunc(ss.gas, ss.train, 'train', whatIlabel, arq_connect);
[ss.gas, ss.val] = sameclassfunc(ss.gas, ss.val, 'val', whatIlabel, arq_connect);
for j = 1:length(arq_connect)
        metrics(j).outparams = ss.gas(j).outparams;
end
%% Displaying multiple confusion matrices for GWR and GNG for nodes
% This part creates the matrices that can later be shown with the
% plotconfusion() function.

[ss, metrics] = plotconfmaker(ss, metrics,whatIlabel);


%% Actual display of the confusion matrices:
metitems = [];
for j = whatIlabel
    if arq_connect(j).params.PLOTIT
        metitems = [metitems j*arq_connect(j).params.PLOTIT];
    end
end
if ~isempty(metitems)
    figure
    plotconf(metrics(metitems))
end
%plotconf(ss.figset{:})
if isfield(ss.gas(end).fig, 'val')&&~isempty(ss.gas(end).fig.val)
    figure
    plotconfusion(ss.gas(end).fig.val{:})
end
gases = ss.gas;
end