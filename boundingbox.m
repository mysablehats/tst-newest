function skelldefo = boundingbox(data, skelldef)
skelldefo = skelldef;
skelldefo.upperbound = max(data,[],2);
skelldefo.lowerbound = min(data,[],2); % these are the vertices of the box. you need to make interpolations to get the real box. do I need a real box?
end