function simvar = starter_script(varargin)
global VERBOSE LOGIT TEST

% Each trial is trained on freshly partitioned/ generated data, so that we
% have an unbiased understanding of how the chained-gas is classifying.
%
% They are generated in a way that you can use nnstart to classify them and
% evaluated how much better (or worse) a neural network or some other
% algorithm can separate these datasets. Also, the data for each action
% example has different length, so the partition of datapoints is not
% equitative (there will be some fluctuation in the performance of putting
% every case in one single bin) and it will not be the same in validation
% and training sets. So in case this is annoying to you and you want to run
% always with a similar dataset, set
% simvar.generatenewdataset = false


env = aa_environment; % load environment variables

simvar = struct();

%% Choose dataset
if isempty(varargin)
    simvar.featuresall = 1;
    simvar.realtimeclassifier = false;
    simvar.generatenewdataset = 1; %true;
    simvar.datasettype = 'CAD60'; % datasettypes are 'CAD60', 'tstv2' and 'stickman'
    simvar.sampling_type = 'type1';
    simvar.activity_type = 'act_type'; %'act_type' or 'act'
    simvar.prefilter = 'none'; % 'filter', 'none', 'median?'
    simvar.labels_names = []; % necessary so that same actions keep their order number
    simvar.TrainSubjectIndexes = 'all';%'loo';%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
    simvar.ValSubjectIndexes = [];%[1,2,7];%% comment these out to have random new samples
    simvar.randSubjEachIteration = true;
    simvar.extract = {'rand', 'wantvelocity'};
    simvar.preconditions = {'highhips', 'normal', 'norotatehips','mirrorx'};% {'nohips', 'norotatehips','mirrorx'}; %
    simvar.trialdataname = strcat('skel',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',simvar.prefilter, [simvar.extract{:}],[simvar.preconditions{:}]);
    simvar.trialdatafile = strcat(env.wheretosavestuff,env.SLASH,simvar.trialdataname,'.mat');
else
    simvar.featuresall = 3;%size(varargin{1},2);
    simvar.generatenewdataset = false;
    simvar.datasettype = 'Ext!';
    simvar.sampling_type = '';
    simvar.activity_type = ''; %'act_type' or 'act'
    simvar.prefilter = 'none'; % 'filter', 'none', 'median?'
    simvar.labels_names = []; % necessary so that same actions keep their order number
    simvar.TrainSubjectIndexes = [];%[9,10,11,4,8,5,3,6]; %% comment these out to have random new samples
    simvar.ValSubjectIndexes = [];%[1,2,7];%% comment these out to have random new samples
    simvar.randSubjEachIteration = true;
    simvar.extract = {''};
    simvar.preconditions = {''};
    simvar.trialdataname = strcat('other',simvar.datasettype,'_',simvar.sampling_type,simvar.activity_type,'_',simvar.prefilter, [simvar.extract{:}],[simvar.preconditions{:}]);
    simvar.trialdatafile = strcat(env.wheretosavestuff,env.SLASH,simvar.trialdataname,'.mat');
end

%% Setting up runtime variables

% set other additional simulation variables
simvar.TEST = TEST; %change this in the beginning of the program
simvar.PARA = 0;
simvar.P = 1;
simvar.NODES_VECT = 1500;
simvar.MAX_EPOCHS_VECT = [5];
simvar.ARCH_VECT = [11];
simvar.MAX_NUM_TRIALS = 1;
simvar.MAX_RUNNING_TIME = 1;%3600*10; %%% in seconds, will stop after this

% set parameters for gas:

params.layertype = '';
params.MAX_EPOCHS = [];
params.removepoints = true;
params.PLOTIT = true;
params.RANDOMSTART = true; % if true it overrides the .startingpoint variable
params.RANDOMSET = false; %true; % if true, each sample (either alone or sliding window concatenated sample) will be presented to the gas at random
params.savegas.resume = false; % do not set to true. not working
params.savegas.save = false;
params.savegas.path = env.wheretosavestuff;
params.savegas.parallelgases = true;
params.savegas.parallelgasescount = 0;
params.savegas.accurate_track_epochs = true;
params.savegas.P = simvar.P;
params.startingpoint = [1 2];
params.amax = 50; %greatest allowed age
params.nodes = []; %maximum number of nodes/neurons in the gas
params.en = 0.006; %epsilon subscript n
params.eb = 0.2; %epsilon subscript b
params.gamma = 1; % for the denoising function
params.plottingstep = 0; % zero will make it plot only the end-gas

%Exclusive for gwr
params.STATIC = true;
params.at = 0.95; %activity threshold
params.h0 = 1;
params.ab = 0.95;
params.an = 0.95;
params.tb = 3.33;
params.tn = 3.33;

%Exclusive for gng
params.age_inc                  = 1;
params.lambda                   = 3;
params.alpha                    = .5;     % q and f units error reduction constant.
params.d                           = .99;   % Error reduction factor.


classifier_loop(simvar, params, env)