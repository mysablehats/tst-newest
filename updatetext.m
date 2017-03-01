function updatetext(chunk)
persistent statictexthandle
if isempty(statictexthandle)||~isvalid(statictexthandle)
    statictexthandle = findobj('Tag','text5');
end

set(statictexthandle, 'String',['Frames acquired: ' num2str(chunk.counter)])