function [Y,Xf,Af] = myCrabNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 28-Dec-2017 16:40:50.
% 
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 6xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 2xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [0;7.2;6.5;14.7;17.1;6.1];
  x1_step1_gain = [2;0.125786163522013;0.145985401459854;0.060790273556231;0.0533333333333333;0.129032258064516];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [-0.55509922058526051;-1.3680029189075884;1.0315767421915778;0.091461422545151522;-0.64380457135049085;0.75940816804983413;1.8274448554213831];
  IW1_1 = [0.28553148393236133 0.84858173320647279 -4.1610818396903948 1.0784832473791555 1.1128964332062901 0.97823489950091036;0.82130646163150389 -0.67808594361756636 -0.032150986013098334 -1.3743358330918276 0.76400105720650224 -0.14762432150603114;-0.88692505915036923 0.81385472242428425 -0.30572433909121499 -0.36060928289656191 1.5829468883045514 -0.27191894704447978;-0.17196031451915686 -0.41702655152052454 5.2840221139715053 -0.030509945424322029 1.052307869495003 0.0097595447570726079;-1.3195014220009167 -0.32637426141837056 -0.94398150907326506 0.26137975658174528 -0.56051890119489156 -1.0168017399553806;2.1797075781026654 -1.0629509732934432 -0.99636009657581326 0.2928884048879361 -1.3898686226176376 -0.76090700446124615;1.2820306846941247 -1.6311175683741479 0.089059193201627751 -0.7281237513074349 -0.041267075299425665 -0.576936977218513];
  
  % Layer 2
  b2 = [0.26595786855984827;-0.48221235288397712];
  LW2_1 = [-4.4504782047474354 -0.12096708077965594 -1.5257238111973805 1.9315026237663784 -0.84608640864025786 -0.29611469701971921 0.33985943760231901;4.4196124196440882 0.90781449471023401 2.6883872564385043 -1.5347006731228918 0.77646015971671478 1.0300120269516253 -1.6942935874682881];
  
  % ===== SIMULATION ========
  
  % Format Input Arguments
  isCellX = iscell(X);
  if ~isCellX, X = {X}; end;
  
  % Dimensions
  TS = size(X,2); % timesteps
  if ~isempty(X)
    Q = size(X{1},2); % samples/series
  else
    Q = 0;
  end
  
  % Allocate Outputs
  Y = cell(1,TS);
  
  % Time loop
  for ts=1:TS
  
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = softmax_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Output 1
    Y{1,ts} = a2;
  end
  
  % Final Delay States
  Xf = cell(1,0);
  Af = cell(2,0);
  
  % Format Output Arguments
  if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
  y = bsxfun(@minus,x,settings_xoffset);
  y = bsxfun(@times,y,settings_gain);
  y = bsxfun(@plus,y,settings_ymin);
end

% Competitive Soft Transfer Function
function a = softmax_apply(n)
  nmax = max(n,[],1);
  n = bsxfun(@minus,n,nmax);
  numer = exp(n);
  denom = sum(numer,1); 
  denom(denom == 0) = 1;
  a = bsxfun(@rdivide,numer,denom);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end
