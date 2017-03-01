function env = aa_environment()
[env.SLASH, env.pathtodata] = OS_VARS();
global logpath
if ismac
    env.wheretosavestuff = '/Volumes/Elements/savesave';
    env.homepath = '~/matlabprogs/classifier';
    %disp('reached ismac')
elseif isunix
    env.wheretosavestuff = '/media/fbklein/Elements/fall_detection_datasets/var';
    env.homepath = '/home/fbklein/Documents/classifier';
    %disp('reached isunix')
elseif ispc
    list_dir = {'d', 'e', 'f', 'g', 'h'};
    list_ind = 1;
    while (~exist([list_dir{list_ind} ':\savesave'],'dir')) 
        list_ind = list_ind +1;
        if list_ind > length(list_dir)
            error('Could not find suitable save directory')
        end
    end
    %env.wheretosavestuff = 'd:\'; %%% should check if there is permission for saving!!!
    %env.wheretosavestuff = 'e:\'; %%% should check if there is permission for saving!!!
    env.wheretosavestuff = [list_dir{list_ind} ':\\savesave']; %%% should check if there is permission for saving!!!
    env.homepath = 'C:\\Users\\Frederico\\Documents\\GitHub\\classifier';
else
    disp('oh-oh')
end
%addpath(genpath(homepath))
%open dialog box?
%have to see how to do it

if ispc
    logpath = strcat(env.homepath, env.SLASH , env.SLASH ,'var',env.SLASH ,env.SLASH,'log.txt');
else
    logpath = strcat(env.homepath, env.SLASH ,'var',env.SLASH,'log.txt');
end
if ~exist(logpath,'file')
    %if this fails there may be a broken path,,, usually happens when I
    %change the computer I am using
    fid = fopen( logpath, 'wt' );
    fprintf( fid, 'New logfile created.');
    fclose(fid);
end
end