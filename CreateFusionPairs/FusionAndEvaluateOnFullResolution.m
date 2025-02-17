function [MatrixImage, MatrixResults] = FusionAndEvaluateOnFullResolution (I_MS, I_MS_LR, I_PAN, Params)
%UNTITLED3 Summary of this function goes here
%   
% Inputs:
%          Fused Image;
%           I_MS_LR:            MS image;
%           I_PAN:              Panchromatic image;
%           L:                  Image radiometric resolution; 
%           th_values:          Flag. If th_values == 1, apply an hard threshold to the dynamic range;
%           I_MS:               MS image upsampled to the PAN size;
%           sensor:             String for type of sensor (e.g. 'WV2','IKONOS');
%           tag:                Image tag. Often equal to the field sensor. It makes sense when sensor is 'none'. It indicates the band number;
%           ratio:              Scale ratio between MS and PAN. Pre-condition: Integer value.
%
% Outputs:
%           D_lambda:           D_lambda index;
%           D_S:                D_S index;
%           QNR_index:          QNR index;
%           SAM_index:          Spectral Angle Mapper (SAM) index between fused and MS image;
%           sCC:                spatial Correlation Coefficient between fused and PAN images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  RUN AND FULL RESOLUTION VALIDATION  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd  './Toolbox\Pansharpening Tool ver 1.3/'
%% Initialization of the Matrix of Results
NumAlgs = 19;
NumIndexes = 5;
MatrixResults = zeros(NumAlgs,NumIndexes);
%% Initialization of the function parameters
% Threshold values out of dynamic range
thvalues = 0;

L = ceil(log2(double(max(I_PAN(:)))+1));% Radiometric Resolution
sensor = Params.sensor;
im_tag =  Params.sensor;
ratio = Params.ratio;
%% EXP
[D_lambda_EXP,D_S_EXP,QNRI_EXP,SAM_EXP,SCC_EXP] = indexes_evaluation_FS(I_MS,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(1,:) = [D_lambda_EXP,D_S_EXP,QNRI_EXP,SAM_EXP,SCC_EXP];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Component Substitution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PCA
%
cd PCA
t2=tic;
I_PCA = PCA(I_MS,I_PAN);
time_PCA=toc(t2);
fprintf('Elaboration time PCA: %.2f [sec]\n',time_PCA);
cd ..

[D_lambda_PCA,D_S_PCA,QNRI_PCA,SAM_PCA,SCC_PCA] = indexes_evaluation_FS(I_PCA,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(2,:) = [D_lambda_PCA,D_S_PCA,QNRI_PCA,SAM_PCA,SCC_PCA];
%% IHS

cd IHS
t2=tic;
I_IHS = IHS(I_MS,I_PAN);
time_IHS=toc(t2);
fprintf('Elaboration time IHS: %.2f [sec]\n',time_IHS);
cd ..

[D_lambda_IHS,D_S_IHS,QNRI_IHS,SAM_IHS,SCC_IHS] = indexes_evaluation_FS(I_IHS,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(3,:) = [D_lambda_IHS,D_S_IHS,QNRI_IHS,SAM_IHS,SCC_IHS];
%% Brovey

cd Brovey
t2=tic;
I_Brovey = Brovey(I_MS,I_PAN);
time_Brovey=toc(t2);
fprintf('Elaboration time Brovey: %.2f [sec]\n',time_Brovey);
cd ..

[D_lambda_Brovey,D_S_Brovey,QNRI_Brovey,SAM_Brovey,SCC_Brovey] = indexes_evaluation_FS(I_Brovey,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(4,:) = [D_lambda_Brovey,D_S_Brovey,QNRI_Brovey,SAM_Brovey,SCC_Brovey];
%% BDSD

cd BDSD
t2=tic;

I_BDSD = BDSD(I_MS,I_PAN,ratio,128,sensor);

time_BDSD = toc(t2);
fprintf('Elaboration time BDSD: %.2f [sec]\n',time_BDSD);
cd ..

[D_lambda_BDSD,D_S_BDSD,QNRI_BDSD,SAM_BDSD,SCC_BDSD] = indexes_evaluation_FS(I_BDSD,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(5,:) = [D_lambda_BDSD,D_S_BDSD,QNRI_BDSD,SAM_BDSD,SCC_BDSD];
%% GS

cd GS
t2=tic;
I_GS = GS(I_MS,I_PAN);
time_GS = toc(t2);
fprintf('Elaboration time GS: %.2f [sec]\n',time_GS);
cd ..

[D_lambda_GS,D_S_GS,QNRI_GS,SAM_GS,SCC_GS] = indexes_evaluation_FS(I_GS,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(6,:) = [D_lambda_GS,D_S_GS,QNRI_GS,SAM_GS,SCC_GS];
%% GSA

cd GS
t2=tic;
I_GSA = GSA(I_MS,I_PAN,I_MS_LR,ratio);
time_GSA = toc(t2);
fprintf('Elaboration time GSA: %.2f [sec]\n',time_GSA);
cd ..

[D_lambda_GSA,D_S_GSA,QNRI_GSA,SAM_GSA,SCC_GSA] = indexes_evaluation_FS(I_GSA,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(7,:) = [D_lambda_GSA,D_S_GSA,QNRI_GSA,SAM_GSA,SCC_GSA];
%% PRACS

cd PRACS
t2=tic;
I_PRACS = PRACS(I_MS,I_PAN,ratio);
time_PRACS = toc(t2);
fprintf('Elaboration time PRACS: %.2f [sec]\n',time_PRACS);
cd ..

[D_lambda_PRACS,D_S_PRACS,QNRI_PRACS,SAM_PRACS,SCC_PRACS] = indexes_evaluation_FS(I_PRACS,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(8,:) = [D_lambda_PRACS,D_S_PRACS,QNRI_PRACS,SAM_PRACS,SCC_PRACS];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MultiResolution Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% HPF

cd HPF
t2=tic;
I_HPF = HPF(I_MS,I_PAN,ratio);
time_HPF = toc(t2);
fprintf('Elaboration time HPF: %.2f [sec]\n',time_HPF);
cd ..

[D_lambda_HPF,D_S_HPF,QNRI_HPF,SAM_HPF,SCC_HPF] = indexes_evaluation_FS(I_HPF,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(9,:) = [D_lambda_HPF,D_S_HPF,QNRI_HPF,SAM_HPF,SCC_HPF];
%% SFIM

cd SFIM
t2=tic;
I_SFIM = SFIM(I_MS,I_PAN,ratio);
time_SFIM = toc(t2);
fprintf('Elaboration time SFIM: %.2f [sec]\n',time_SFIM);
cd ..

[D_lambda_SFIM,D_S_SFIM,QNRI_SFIM,SAM_SFIM,SCC_SFIM] = indexes_evaluation_FS(I_SFIM,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(10,:) = [D_lambda_SFIM,D_S_SFIM,QNRI_SFIM,SAM_SFIM,SCC_SFIM];
%% Indusion

cd Indusion
t2=tic;
I_Indusion = Indusion(I_PAN,I_MS_LR,ratio);
time_Indusion = toc(t2);
fprintf('Elaboration time Indusion: %.2f [sec]\n',time_Indusion);
cd ..

[D_lambda_Indusion,D_S_Indusion,QNRI_Indusion,SAM_Indusion,SCC_Indusion] = indexes_evaluation_FS(I_Indusion,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);

MatrixResults(11,:) = [D_lambda_Indusion,D_S_Indusion,QNRI_Indusion,SAM_Indusion,SCC_Indusion];
%% ATWT

cd Wavelet
t2=tic;
I_ATWT = ATWT(I_MS,I_PAN,ratio);

time_ATWT = toc(t2);
fprintf('Elaboration time ATWT: %.2f [sec]\n',time_ATWT);
cd ..

[D_lambda_ATWT,D_S_ATWT,QNRI_ATWT,SAM_ATWT,SCC_ATWT] = indexes_evaluation_FS(I_ATWT,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(12,:) = [D_lambda_ATWT,D_S_ATWT,QNRI_ATWT,SAM_ATWT,SCC_ATWT];
%% AWLP

cd Wavelet
t2=tic;
I_AWLP = AWLP(I_MS,I_PAN,ratio);
time_AWLP = toc(t2);
fprintf('Elaboration time AWLP: %.2f [sec]\n',time_AWLP);
cd ..

[D_lambda_AWLP,D_S_AWLP,QNRI_AWLP,SAM_AWLP,SCC_AWLP] = indexes_evaluation_FS(I_AWLP,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(13,:) = [D_lambda_AWLP,D_S_AWLP,QNRI_AWLP,SAM_AWLP,SCC_AWLP];
%% ATWT-M2

cd Wavelet
t2=tic;

I_ATWTM2 = ATWT_M2(I_MS,I_PAN,ratio);

time_ATWTM2 = toc(t2);
fprintf('Elaboration time ATWTM2: %.2f [sec]\n',time_ATWTM2);
cd ..

[D_lambda_ATWTM2,D_S_ATWTM2,QNRI_ATWTM2,SAM_ATWTM2,SCC_ATWTM2] = indexes_evaluation_FS(I_ATWTM2,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(14,:) = [D_lambda_ATWTM2,D_S_ATWTM2,QNRI_ATWTM2,SAM_ATWTM2,SCC_ATWTM2];

%% ATWT-M3

cd Wavelet
t2=tic;

I_ATWTM3 = ATWT_M3(I_MS,I_PAN,ratio);

time_ATWTM3 = toc(t2);
fprintf('Elaboration time ATWTM3: %.2f [sec]\n',time_ATWTM3);
cd ..

[D_lambda_ATWTM3,D_S_ATWTM3,QNRI_ATWTM3,SAM_ATWTM3,SCC_ATWTM3] = indexes_evaluation_FS(I_ATWTM3,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(15,:) = [D_lambda_ATWTM3,D_S_ATWTM3,QNRI_ATWTM3,SAM_ATWTM3,SCC_ATWTM3];
%% MTF-GLP

cd GLP
t2=tic;
I_MTF_GLP = MTF_GLP(I_PAN,I_MS,sensor,im_tag,ratio);
% I_MTF_GLP = MTF_GLP_ECB(I_MS,I_PAN,ratio,[9 9],2.5,sensor,im_tag);
% I_MTF_GLP = MTF_GLP_CBD(I_MS,I_PAN,ratio,[55 55],-Inf,sensor,im_tag);

time_MTF_GLP=toc(t2);
fprintf('Elaboration time CBD: %.2f [sec]\n',time_MTF_GLP);
cd ..

[D_lambda_MTF_GLP,D_S_MTF_GLP,QNRI_MTF_GLP,SAM_MTF_GLP,SCC_MTF_GLP] = indexes_evaluation_FS(I_MTF_GLP,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(16,:) = [D_lambda_MTF_GLP,D_S_MTF_GLP,QNRI_MTF_GLP,SAM_MTF_GLP,SCC_MTF_GLP];
%% MTF-GLP-HPM-PP

cd GLP
t2=tic;
I_MTF_GLP_HPM_PP = MTF_GLP_HPM_PP(I_PAN,I_MS_LR,sensor,im_tag,ratio);
tempo_MTF_GLP_HPM_PP = toc(t2);
fprintf('Elaboration time MTF-GLP-HPM-PP: %.2f [sec]\n',tempo_MTF_GLP_HPM_PP);
cd ..

[D_lambda_MTF_GLP_HPM_PP,D_S_MTF_GLP_HPM_PP,QNRI_MTF_GLP_HPM_PP,SAM_MTF_GLP_HPM_PP,SCC_MTF_GLP_HPM_PP] = indexes_evaluation_FS(I_MTF_GLP_HPM_PP,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(17,:) = [D_lambda_MTF_GLP_HPM_PP,D_S_MTF_GLP_HPM_PP,QNRI_MTF_GLP_HPM_PP,SAM_MTF_GLP_HPM_PP,SCC_MTF_GLP_HPM_PP];
%% MTF-GLP-HPM

cd GLP
t2=tic;
I_MTF_GLP_HPM = MTF_GLP_HPM(I_PAN,I_MS,sensor,im_tag,ratio);
tempo_MTF_GLP_HPM = toc(t2);
fprintf('Elaboration time MTF-GLP-HPM: %.2f [sec]\n',tempo_MTF_GLP_HPM);
cd ..

[D_lambda_MTF_GLP_HPM,D_S_MTF_GLP_HPM,QNRI_MTF_GLP_HPM,SAM_MTF_GLP_HPM,SCC_MTF_GLP_HPM] = indexes_evaluation_FS(I_MTF_GLP_HPM,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(18,:) = [D_lambda_MTF_GLP_HPM,D_S_MTF_GLP_HPM,QNRI_MTF_GLP_HPM,SAM_MTF_GLP_HPM,SCC_MTF_GLP_HPM];
%% MTF-GLP-CBD

cd GS
t2=tic;
I_MTF_GLP_CBD = GS2_GLP(I_MS,I_PAN,ratio,sensor,im_tag);
tempo_MTF_GLP_CBD = toc(t2);
fprintf('Elaboration time MTF-GLP-CBD: %.2f [sec]\n',tempo_MTF_GLP_CBD);
cd ..

[D_lambda_MTF_GLP_CBD,D_S_MTF_GLP_CBD,QNRI_MTF_GLP_CBD,SAM_MTF_GLP_CBD,SCC_MTF_GLP_CBD] = indexes_evaluation_FS(I_MTF_GLP_CBD,I_MS_LR,I_PAN,L,thvalues,I_MS,sensor,im_tag,ratio);
MatrixResults(19,:) = [D_lambda_MTF_GLP_CBD,D_S_MTF_GLP_CBD,QNRI_MTF_GLP_CBD,SAM_MTF_GLP_CBD,SCC_MTF_GLP_CBD];

%% Print in LATEX
% matrix2latex(MatrixResults,'Real_Dataset.tex', 'rowLabels',[{'EXP'},{'PCA'},{'IHS'},{'Brovey'},{'BDSD'},{'GS'},{'GSA'},{'PRACS'},{'HPF'},{'SFIM'},{'Indusion'},{'ATWT'},{'AWLP'},...
%         {'ATWT-M2'},{'ATWT-M3'},{'MTF-GLP'},{'MTF-GLP-HPM-PP'},{'MTF-GLP-HPM'},{'MTF-GLP-CBD'}],'columnLabels',[{'D_{\lambda}'},{'D_{S}'},{'QNR'}],'alignment','c','format', '%.4f'); 
    matrix2latex(MatrixResults,'Real_Dataset.tex', 'rowLabels',[{'EXP'},{'PCA'},{'IHS'},{'Brovey'},{'BDSD'},{'GS'},{'GSA'},{'PRACS'},{'HPF'},{'SFIM'},{'Indusion'},{'ATWT'},{'AWLP'},...
        {'ATWT-M2'},{'ATWT-M3'},{'MTF-GLP'},{'MTF-GLP-HPM-PP'},{'MTF-GLP-HPM'},{'MTF-GLP-CBD'}],'columnLabels',[{'D_{\lambda}'},{'D_{S}'},{'QNR'},{'SAM'},{'SCC'}],'alignment','c','format', '%.4f'); 
%% View All
MatrixImage(:,:,:,1) = repmat(I_PAN,[1 1 size(I_MS,3)]);
MatrixImage(:,:,:,2) = I_MS;
MatrixImage(:,:,:,3) = I_PCA;
MatrixImage(:,:,:,4) = I_IHS;
MatrixImage(:,:,:,5) = I_Brovey;
MatrixImage(:,:,:,6) = I_BDSD;
MatrixImage(:,:,:,7) = I_GS;
MatrixImage(:,:,:,8) = I_GSA;
MatrixImage(:,:,:,9) = I_PRACS;
MatrixImage(:,:,:,10) = I_HPF;
MatrixImage(:,:,:,11) = I_SFIM;
MatrixImage(:,:,:,12) = I_Indusion;
MatrixImage(:,:,:,13) = I_ATWT;
MatrixImage(:,:,:,14) = I_AWLP;
MatrixImage(:,:,:,15) = I_ATWTM2;
MatrixImage(:,:,:,16) = I_ATWTM3;
MatrixImage(:,:,:,17) = I_MTF_GLP;
MatrixImage(:,:,:,18) = I_MTF_GLP_HPM_PP;
MatrixImage(:,:,:,19) = I_MTF_GLP_HPM;
MatrixImage(:,:,:,20) = I_MTF_GLP_CBD;
%% 显示
%{
if size(I_MS,3) == 4
    vect_index_RGB = [3,2,1];
else
    vect_index_RGB = [5,3,1];
end

flag_cut_bounds = 0;
dim_cut = 0;
titleImages = {'PAN','EXP','PCA','IHS','Brovey','BDSD','GS','GSA','PRACS','HPF','SFIM','Indusion','ATWT','AWLP','ATWT M2','ATWT M3','MTF GLP','MTF GLP HPM PP','MTF GLP HPM','MTF GLP CBD'};
figure, showImagesAll(MatrixImage,titleImages,vect_index_RGB,flag_cut_bounds,dim_cut,1);
%}
cd ../../ %返回主文件夹
end

