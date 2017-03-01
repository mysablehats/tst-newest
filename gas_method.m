function [sstgasj, sstv] = gas_method(sstgas, sstv, vot, arq_connect,j, dimdim)
%% Gas Method
% This is a function to go over a gas of the classifier, populate it with the apropriate input and generate the best matching units for the next layer.
%% Setting up some labels
sstgasj = sstgas(j);
sstgasj.name = arq_connect.name;
sstgasj.method = arq_connect.method;
sstgasj.layertype = arq_connect.layertype;
arq_connect.params.layertype = arq_connect.layertype;

%% Choosing the right input for this layer
% This calls the function set input that chooses what will be written on the .inputs variable. It also handles the sliding window concatenations and saves the .input_ends properties, so that this can be done recursevely.
% After some consideration, I have decided that all of the long inputing
% will be done inside setinput, because it it would be easier.
dbgmsg('Working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,' for process:',num2str(labindex),0)

[sstv.gas(j).inputs.input_clip, sstv.gas(j).inputs.input, sstv.gas(j).inputs.input_ends, sstv.gas(j).y, sstv.gas(j).inputs.oldwhotokill, sstv.gas(j).inputs.index, sstv.gas(j).inputs.awk ]  = setinput(arq_connect, sstgas, dimdim, sstv); %%%%%%

%%
% After setting the input, we can actually run the gas, either a GNG or the
% GWR function we wrote.
if strcmp(vot, 'train')
    %DO GNG OR GWR
    [sstgasj.nodes, sstgasj.edges, sstgasj.outparams] = gas_wrapper(sstv.gas(j).inputs.input_clip,arq_connect);
    %%%% POS-MESSAGE
    dbgmsg('Finished working on gas: ''',sstgasj.name,''' (', num2str(j),') with method: ',sstgasj.method ,'.Num of nodes reached:',num2str(sstgasj.outparams.graph.nodesvect(end)),' for process:',num2str(labindex),0)
    
end

%% Best-matching units
% The last part is actually finding the best matching units for the gas.
% This is a simple procedure where we just find from the gas units (nodes
% or vectors, as you wish to call them), which one is more like our input.
% It is a filter of sorts, and the bestmatch matrix is highly repetitive.

% I questioned if I actually need to compute this matrix here or maybe
% inside the setinput function. But I think this doesnt really matter.
% Well, for the last gas it does make a difference, since these units will
% not be used... Still I will  not fix it unless I have to.
%PRE MESSAGE
dbgmsg('Finding best matching units for gas: ''',sstgasj.name,''' (', num2str(j),') for process:',num2str(labindex),0)
[~, sstv.gas(j).bestmatchbyindex] = genbestmmatrix(sstgasj.nodes, sstv.gas(j).inputs.input, arq_connect.layertype, arq_connect.q); %assuming the best matching node always comes from initial dataset!

%% Post-conditioning function
%This will be the noise removing function. I want this to be optional or allow other things to be done to the data and I
%am still thinking about how to do it. Right now I will just create the
%whattokill property and let setinput deal with it.
if arq_connect.params.removepoints
    dbgmsg('Flagging noisy input for removal from gas: ''',sstgasj.name,''' (', num2str(j),') with points with more than',num2str(arq_connect.params.gamma),' standard deviations, for process:',num2str(labindex),0)
    sstv.gas(j).whotokill = removenoise(sstgasj.nodes, sstv.gas(j).inputs.input, sstv.gas(j).inputs.oldwhotokill, arq_connect.params.gamma, sstv.gas(j).inputs.index);
else
    dbgmsg('Skipping removal of noisy input for gas:',sstgasj.name,0)
end
end
function [ matmat, matmat_byindex] = genbestmmatrix(nodes, data, ~,~)
%matmat = zeros(size(nodes,1),size(data,2));
%matmat_byindex = zeros(1,size(data,2));
[~,matmat_byindex] = pdist2(nodes',data','euclidean','Smallest',1);
matmat = nodes(:,matmat_byindex);

%%%this makes a nice graph:
%maybe a gfc and restore stuff later...
currfig = gcf;
figure
a = reshape(data(:,1),45,[]); %%% it is going be a rubish skeleton for all layers that are not with positions... maybe it will mix nice and rubish for the last one...
b = reshape(nodes(:,1),45,[]);
skeldraw(a)
skeldraw(b)
%%% or you can get the closest to the first one, like
figure
getskel = nodes(:,matmat_byindex(1));
c = reshape(getskel,45,[]);
skeldraw(a)
skeldraw(c);

figure(currfig)

%
% for i = 1:size(data,2)
%        [ matmat(:,i), matmat_byindex(i)] = bestmatchingunit(data(:,i),gwr_nodes,whichisit,q);
% end

% % old genbestmatch. I figured out it is the other way around, which makes
% more sense, so I should just filter spatially my data, so the
% bestmatching data should have the same dimension as the initial dataset,
% duh...
% matmat = zeros(size(data,1),size(gwr_nodes,2));
% for i = 1:size(gwr_nodes,2) %%%%%%%%%% it is actually the other way around!!!!!
%         matmat(:,i) = bestmatchingunit(gwr_nodes(:,i),data,whichisit);
% end
% end
end
