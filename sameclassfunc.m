function [gas, ssvot] = sameclassfunc(gas, ssvot, vot, whatIlabel, arq_connect)
%% Gas-chain Classifier
% This part executes the chain of interlinked gases. Each iteration is one
% gas, and currently it works as follows:
% 1. Function setinput() chooses based on the input defined in allconn
% 2. Run either a Growing When Required (gwr) or Growing Neural Gas (GNG)
% on this data
% 3. Generate matrix of best matching units to be used by the next gas
% architecture

dbgmsg('Starting chain structure for GWR and GNG for nodes:',num2str(labindex),0)
dbgmsg('###Using multilayer GWR and GNG ###',0)


for j = 1:length(arq_connect)
    if size(ssvot.data,1)>0&&strcmp(vot,'train')
        [gas(j), ssvot] = gas_method(gas, ssvot,vot, arq_connect(j),j, size(ssvot.data,1)); % I had to separate it to debug it.
    elseif ~isempty(ssvot.data)
        [~, ssvot ]= gas_method(gas, ssvot, vot, arq_connect(j),j, size(ssvot.data,1)); %%%hmmm, this will not work
    end
end



%% Gas Outcomes
if strcmp(vot,'train')
    if arq_connect(j).params.PLOTIT
        figure
        for j = 1:length(arq_connect)
            subplot(1,length(arq_connect),j)
            hist(gas(j).outparams.graph.errorvect)
            title((gas(j).name))
        end
    end
end
%% Labelling
% The current labelling procedure for both the validation and training datasets. As of this moment I label all the gases
% to see how adding each part increases the overall performance of the
% structure, but since this is slow, the variable whatIlabel can be changed
% to contain only the last gas.
%
% The labelling procedure is simple. It basically picks the label of the
% closest point and assigns to that. In a sense the gas can be seen as a
% dimensional (as opposed to temporal) filter, encoding prototypical
% action-lets.
% Specific part on what I want to label
for j = whatIlabel
    dbgmsg('Applying labels for gas: ''',gas(j).name,''' (', num2str(j),') for process:',num2str(labindex),0)
    if strcmp(vot,'train')
        gas(j).nodesl = labeling(gas(j).nodes,ssvot.gas(j).inputs.input,ssvot.gas(j).y);
    end
    if isfield(ssvot,'gas')&&j<=length(ssvot.gas)
        ssvot.gas(j).class = labeller(gas(j).nodesl, ssvot.gas(j).bestmatchbyindex);
    end
    
end

end