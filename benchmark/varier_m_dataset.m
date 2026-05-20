function [BR_vect, ASA_vect] = varier_m_dataset(chemin_images, chemin_gt, k, valeurs_m, tolerance)
% Evalue SLIC sur tout un dossier en faisant varier m, K fixe
%
% INPUTS:
%   chemin_images : chemin vers le dossier d'images .jpg
%   chemin_gt     : chemin vers le dossier des fichiers GT .mat
%   k             : nombre de superpixels (fixe)
%   valeurs_m     : vecteur de valeurs de m (ex: [1, 5, 10, 20, 40])
%   tolerance     : distance en pixels pour BR (ex: 2)
%
% OUTPUTS:
%   BR_vect  : vecteur de BR moyen, un par valeur de m
%   ASA_vect : vecteur de ASA moyen, un par valeur de m

    nb_m = length(valeurs_m);
    BR_vect  = zeros(1, nb_m);
    ASA_vect = zeros(1, nb_m);
    
    for im = 1:nb_m
        m = valeurs_m(im);
        fprintf('\n--- m=%d ---\n', m);
        
        [BR_vect(im), ASA_vect(im)] = eval_dataset(chemin_images, chemin_gt, k, m, tolerance);
        
        fprintf('m=%d → BR_moy=%.3f, ASA_moy=%.3f\n', m, BR_vect(im), ASA_vect(im));
    end
    
    fprintf('\nTRAITEMENT TERMINE\n');
end