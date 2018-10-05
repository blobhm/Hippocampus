function [] = plotStackedFFT()
%PLOTSTACKEDFFT Gather all the FFT png in the session01 and sessioneye in
%the current directory, plot the FFT png togther in dirrent figures showing
%each array, referred to certain geometry specified in function
%'assignChannelGeo'
% 
%   Detailed explanation goes here

numRow = 5;
numArray = 4;

channelGeo = assignChannelGeo(numRow,numArray); % a function to get the channel geometry

hpInfo = dir('**/hp.png');

lfpInfo = dir('**/lfp.png');
numLfp = length(lfpInfo);

%% plot stacked hp.png
close all

numCol = size(channelGeo,2);

offsetX = 1/numCol;
offsetY = 1/numRow;
setX = 0 : offsetX : 1;
setY = fliplr(0 : offsetY : 1-offsetY);

[pHp,pEHp,pTHp] = insertFFT(hpInfo,numArray,channelGeo,setX,setY,offsetX,offsetY);
for i = 1:numArray
    saveas(pHp(i,1),['session01',filesep,'array0',num2str(i),filesep,'stackedhp01.png']);
    delete(pHp(i,1));
    
    saveas(pEHp(i,1),['sessioneye',filesep,'array0',num2str(i),filesep,'stackedhpeye.png']);
    delete(pEHp(i,1));

    saveas(pTHp(i,1),['sessiontest',filesep,'array0',num2str(i),filesep,'stackedhptest.png']);
    delete(pTHp(i,1));
end    


[pLfp,pELfp,PTLfp] = insertFFT(lfpInfo,numArray,channelGeo,setX,setY,offsetX,offsetY);
for i = 1:numArray
    saveas(pLfp(i,1),['session01',filesep,'array0',num2str(i),filesep,'stackedlfp01.png']);
    delete(pLfp(i,1));
    
    saveas(pELfp(i,1),['sessioneye',filesep,'array0',num2str(i),filesep,'stackedlfpeye.png']);
    delete(pELfp(i,1));

    saveas(pTLfp(i,1),['sessiontest',filesep,'array0',num2str(i),filesep,'stackedlfptest.png']);
    delete(pTLfp(i,1));
end    

disp('Done...')

end

function channelGeo = assignChannelGeo(numRow,numArray)
%ASSIGNCHANNELGEO To assign the geometry of the channel into each array
% function channelGeo = assignChannelGeo(numRow,numArray)

channelTbl = [7,38; 31,70; 63,102; 95,118];

channelGeo = horzcat(nan, fliplr(1:6), nan); % first array first row of channel is different from others
channelGeo = vertcat(channelGeo, ...
    fliplr(reshape(transpose(reshape(channelTbl(1,1):channelTbl(1,2),[],numRow-1)),numRow-1,[])));

for i = 2 : numArray-1 % second and third array
    channelGeo(:,:,i) = fliplr(reshape(transpose(reshape(channelTbl(i,1):channelTbl(i,2),[],numRow)),numRow,[]));
end

channelGeo(:,:,4) = vertcat( ... % last array
    fliplr(reshape(transpose(reshape(channelTbl(4,1):channelTbl(4,2),[],numRow-2)),numRow-2,[])),...
    horzcat(fliplr(119:125), nan),...
    horzcat(fliplr(126:132), nan));
    %nan(1,size(channelGeo,2)));


end

function [p,pE,pT] = insertFFT(info,numArray,channelGeo,setX,setY,offsetX,offsetY)
%INSERTFFT Insert the png into its corresponding figure
%   Detailed explanation goes here

for i = 1:numArray
    p(i,1) = figure; % for session01
    set(gcf, 'Position', get(0,'Screensize')-[0 0 0 80],'PaperPositionMode', 'auto');
    pE(i,1) = figure; % for sessioneye
    set(gcf, 'Position', get(0,'Screensize')-[0 0 0 80],'PaperPositionMode', 'auto');
    pT(i,1) = figure; % for sessioneye
    set(gcf, 'Position', get(0,'Screensize')-[0 0 0 80],'PaperPositionMode', 'auto');

end

numP = length(info);

for i = 1:numP
    indexArray = strfind(info(i).folder,'array');
    arrayNum = str2num(info(i).folder(indexArray+5:indexArray+6)); % array number
    
    indexChannel = strfind(info(i).folder,'channel');
    channelNum = str2num(info(i).folder(indexChannel+7:indexChannel+9)); % channel number
    
    [y,x] = find(channelGeo(:,:,arrayNum) == channelNum); % location of the channel in channel geometry    
    
    pTemp = fullfile(info(i,1).folder,info(i,1).name);

    if ~isempty(strfind(info(i,1).folder,'01'))
        set(0,'CurrentFigure',p(arrayNum,1)); % change to the target figure of session01
    elseif ~isempty(strfind(info(i,1).folder,'eye'))
        set(0,'CurrentFigure',pE(arrayNum,1)); % change to the target figure of sessiontest
    elseif ~isempty(strfind(info(i,1).folder,'test'))
        set(0,'CurrentFigure',pT(arrayNum,1)); % change to the target figure of sessiontest
    else
      warning('png appeared in inproper directory...') 
    end
    
    axes('pos',[setX(x), setY(y), offsetX, offsetY]);
    imshow(pTemp)
    
end

end

