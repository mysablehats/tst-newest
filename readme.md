### What you should do ###

This should just work with the data you've given me. 

But maybe you want to change some parameters, so:



    load('DataALL.mat')

    a = starter_script(DataF)                        % or DataXXX

    for i =1:size(a); plotconf(a(i).metrics);figure;end
