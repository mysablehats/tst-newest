function ss = makess(lenlen)
inputs = struct('input_clip',[],'input',[],'input_ends',[],'oldwhotokill',struct([]), 'index', []);
gas_data = struct('name','','class',[],'y',[],'inputs',inputs,'bestmatch',[],'bestmatchbyindex',[],'whotokill',struct([]));
%gas_methodss = struct;
gas_methodss = struct('name','','edges',[],'nodes',[],'fig',[],'nodesl',[], 'method',[],'layertype',[],'outparams',[]); %bestmatch will have the training matrix for subsequent layers
for i =1:lenlen
    gas_methods(i) = gas_methodss;
end
ss.gas = gas_methods;
ss.train.indexes = [];
ss.train.gas = gas_data;
ss.val.indexes = [];
ss.val.gas = gas_data;
ss.test.indexes = [];
ss.test.gas = gas_data;


for i = 1:length(ss) % oh, I don't know how to do it elegantly
    ss.figset = {};
end
end
