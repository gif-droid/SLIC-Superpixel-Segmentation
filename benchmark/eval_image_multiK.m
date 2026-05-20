function [BR_vecteur, ASA_vecteur, segs] = eval_image_multiK(img, gt_fichier, valeurs_k, m, tolerance)
% evalue SLIC sur une seule image en faisant varier K

% Entrees:
%   img: image RGB (matrice uint8)
%   gt_fichier: chemin vers le fichier .mat GT
%   valeurs_k :vecteur de valeurs de K (ex: [50, 100, 200, 500])
%   m: compacite (fixe)
%   tolerance: distance en pixels pour BR (ex: 2)

% sories:
%   BR_vecteur: vecteur de BR, un par valeur de K
%   ASA_vecteur: vecteur de ASA, un par valeur de K
%   segs: cell array des segmentations, segs{i} = label pour valeurs_k(i)

    nb_k= length(valeurs_k);
    BR_vecteur= zeros(1, nb_k);
    ASA_vecteur= zeros(1, nb_k);
    segs = cell(1, nb_k);
    
    % charger le GT une seule fois
    gt_data = load(gt_fichier);
    for ik = 1:nb_k
        k = valeurs_k(ik);
        % Segmentation SLIC
        label = SLIC_SIA2(img, k, m);
        % Stocker la segmentation
        segs{ik} = label;
        % Calculer les metriques
        BR_vecteur(ik)  = boundary_recall(label, gt_data.groundTruth, tolerance);
        ASA_vecteur(ik) = calculer_ASA(label, gt_data.groundTruth);
        
        fprintf('K=%d → BR=%.3f, ASA=%.3f\n', k, BR_vecteur(ik), ASA_vecteur(ik));
    end
end