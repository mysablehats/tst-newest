function arq_connect = baq(allconn)
%%%% building arq_connect
arq_connect = struct;
%arq_connect(1:length(allconn)) = struct('name','','method','','sourcelayer','', 'layertype','','q',[1 0],'params',struct([]));
for i = 1:length(allconn)
    arq_connect(i).name = allconn{i}{1};
    arq_connect(i).method = allconn{i}{2};
    arq_connect(i).sourcelayer = allconn{i}{3};
    arq_connect(i).layertype = allconn{i}{4};
    arq_connect(i).q = allconn{i}{5};
    arq_connect(i).params = allconn{i}{6};
    %%% hack I need this info in params as well
    arq_connect(i).params.q = arq_connect(i).q;
end