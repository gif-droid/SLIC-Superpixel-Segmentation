function [BR_vect, ASA_vect, segs] = eval_image_multiM(img, gt_fichier, k, valeurs_m, tolerance)
% Evalue SLIC sur une seule image en faisant varier m, K fixe
%
% INPUTS:
%   img        : image RGB (matrice uint8)
%   gt_fichier : chemin vers le fichier .mat GT
%   k          : nombre de superpixels (fixe)
%   valeurs_m  : vecteur de valeurs de m (ex: [1, 5, 10, 20, 40])
%   tolerance  : distance en pixels pour BR (ex: 2)
%
% OUTPUTS:
%   BR_vect  : vecteur de BR, un par valeur de m
%   ASA_vect : vecteur de ASA, un par valeur de m
%   segs     : cell array des segmentations, segs{i} = label pour valeurs_m(i)

    nb_m = length(valeurs_m);
    BR_vect  = zeros(1, nb_m);
    ASA_vect = zeros(1, nb_m);
    segs     = cell(1, nb_m);
    
    % Charger le GT une seule fois
    gt_data = load(gt_fichier);
    
    for im = 1:nb_m
        m = valeurs_m(im);
        
        % Segmentation SLIC
        label = SLIC_SIA2(img, k, m);
        
        % Stocker la segmentation
        segs{im} = label;
        
        % Calculer les metriques
        BR_vect(im)  = boundary_recall(label, gt_data.groundTruth, tolerance);
        ASA_vect(im) = calculer_ASA(label, gt_data.groundTruth);
        
        fprintf('m=%d → BR=%.3f, ASA=%.3f\n', m, BR_vect(im), ASA_vect(im));
    end
end