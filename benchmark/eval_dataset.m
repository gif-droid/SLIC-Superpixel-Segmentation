function [BR_moyen, ASA_moyen] = eval_dataset(chemin_images, chemin_gt, k, m, tolerance)
% evalue SLIC sur tout un dossier d'images avec un seul K et un seul m
% entrees:
%   chemin_images: chemin vers le dossier d'images .jpg
%   chemin_gt: chemin vers le dossier des fichiers GT .mat
%   k : nombre de superpixels
%   m : compacite
%   tolerance :distance en pixels pour BR (ex: 2)
% sortis:
%   BR_moyen:BR moyen sur tout le dataset
%   ASA_moyen:ASA moyen sur tout le dataset

    % Lister toutes les images du dossier
    liste_images = dir(fullfile(chemin_images, '*.jpg'));
    nb_images = length(liste_images);
    BR_total =zeros(nb_images, 1);
    ASA_total= zeros(nb_images, 1);
    
    for i= 1:nb_images
        % charge l'image
        img = imread(fullfile(chemin_images, liste_images(i).name));
        
        % converti en RGB si image en niveaux de gris
        if size(img, 3) == 1
            img = cat(3, img, img, img);
        end
        
        % trouver le fichier GT correspondant
        [~, nom, ~]  = fileparts(liste_images(i).name);
        gt_fichier   = fullfile(chemin_gt, [nom '.mat']);
        
        % Evaluer cette image
        [BR_total(i), ASA_total(i), ~] = eval_image(img, gt_fichier, k, m, tolerance);
        
        fprintf('Image %d/%d — %s → BR=%.3f, ASA=%.3f\n', ...
                 i, nb_images, nom, BR_total(i), ASA_total(i));
    end
    
    %moyenne sur tout le dataset
    BR_moyen = mean(BR_total);
    ASA_moyen= mean(ASA_total);
    
    fprintf('\nRESULTATS GLOBAUX — BR=%.3f, ASA=%.3f\n', BR_moyen, ASA_moyen);
end