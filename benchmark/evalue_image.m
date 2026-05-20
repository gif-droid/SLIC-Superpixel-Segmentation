function [BR, ASA, label] = evalue_image(img, gt_fichier, k, m, tolerance)
% evalue SLIC avec un seul k et m sur une seule image 

% entrees:
%   img: image RGB (matrice uint8)
%   gt_fichier: chemin vers le fichier .mat GT
%   k: nombre de superpixels souhaite
%   m: compacite
%   tolerance: distance en pixels pour BR (ex: 2)

% sorties:
%   BR: boundary recall(valeur entre 0 et 1)
%   ASA: Achievable Segmentation Accuracy (valeur entre 0 et 1)
%   label: carte de labels produite par SLIC (optionnel, utile pour affichage)

    %segmentation SLIC
    label = SLIC_SIA2(img, k, m);
    % charger le GT
    gt_data = load(gt_fichier);
    % gt : groundtruth, verite terrain

    % 3. Calculer les metriques
    BR= boundary_recall(label, gt_data.groundTruth, tolerance);
    ASA=calcule_ASA(label, gt_data.groundTruth);
end