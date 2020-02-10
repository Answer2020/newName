function deepnet=ThreeAE(xTrainImages,hiddenUnitNumbers,pretrainingIterations,fineTuningIterations,tTrain1, tTrain)

hiddenSize1 = hiddenUnitNumbers;
autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',pretrainingIterations, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',2, ...
    'SparsityProportion',0.8, ...
    'ScaleData', true);
feat1 = encode(autoenc1,xTrainImages);
%%

%SECOND AE
hiddenSize2 = hiddenUnitNumbers;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',pretrainingIterations, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',2, ...
    'SparsityProportion',0.85, ...
    'ScaleData', true);
feat2 = encode(autoenc2,feat1);
%%
%THIRD AE
hiddenSize3 = hiddenUnitNumbers;
autoenc3 = trainAutoencoder(feat2,hiddenSize3, ...
    'MaxEpochs',pretrainingIterations, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',2, ...
    'SparsityProportion',0.85, ...
    'ScaleData', true);
feat3 = encode(autoenc3,feat2);

%%
softnet = trainSoftmaxLayer(feat3,tTrain1,'MaxEpochs',fineTuningIterations);
deepnet = stack(autoenc1,autoenc2,autoenc3,softnet);

deepnet = train(deepnet,xTrainImages,tTrain);