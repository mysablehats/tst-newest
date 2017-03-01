function plotconf(mt)
al = length(mt);
if isfield(mt(1).conffig, 'val')&&~isempty(mt(1).conffig.val)
    figset = cell(6*al,1);
    for i = 1:al
        figset((i*6-5):i*6) = [mt(i).conffig.val mt(i).conffig.train];
    end
else
    figset = cell(3*al,1);
    for i = 1:al
        figset((i*3-2):i*3) = mt(i).conffig.train;
    end
    
end
plotconfusion(figset{:})

end