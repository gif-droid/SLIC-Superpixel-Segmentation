
function BR = boundary_recall(label, verite_terrain, toleranc)
% calcule le boundary Recall d'une segmentation par rapport a tous les GT
%
% entree:
%   label       : matrice 2D de labels (sortie de SLIC_SIA2)
%   verite_terrain : cell array complete du fichier .mat GT
%   toleranc   : distance en pixels acceptee (ex: 2)
%
% sortie:
%   BR : valeur entre 0 et 1

    % Convertir labels en carte de contours binaire
    contours_slic = double(boundarymask(label));
    
    % Dilater selon la toleranc
    se = strel('disk', toleranc);
    contours_dilates = imdilate(contours_slic, se);
    
    % Initialisation des compteurs
    numerateur=0;  % numerateur   : pixels GT trouves par SLIC
    denominateur=0;  % denominateur : total pixels GT
    
    % boucle sur tous les annotateurs de la verite terrain
    for i = 1:numel(verite_terrain)
        gt_bdry = double(verite_terrain{i}.Boundaries);
        
        % Pixels GT couverts par les contours SLIC dilates
        pixels_couverts = sum(gt_bdry(:) & contours_dilates(:));
        pixels_gt       = sum(gt_bdry(:));
        
        numerateur = numerateur + pixels_couverts;
        denominateur = denominateur + pixels_gt;
    end
    
    % BR global sur tous les GT
    BR = numerateur / (denominateur + (denominateur == 0));
end