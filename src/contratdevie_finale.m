function [label, p,k_reel] = contratdevie_finale(image, k, m)
    % Conversion LAB 
    lab = rgb2lab(image);
    [ligne, colonne, ~] = size(lab);
    N=ligne*colonne;
    L=lab(:,:,1);
    A=lab(:,:,2);
    B=lab(:,:,3);
    seuil= 0.05;

    %Taille d'un superpixel
    S=max(1, floor(sqrt(N / k)));

    %Initialisation des centres sur la grille
    centre=initialiser_centres(lab, k);
    k_reel=size(centre, 1);

    %Affiner les centres vers le min de gradient
    centre=affiner_centres(centre, L, A, B, k_reel, ligne, colonne);

    %La Boucle de traitement 
    label=zeros(ligne, colonne);
    distance=inf * ones(ligne, colonne);
    E =inf;
    while E > seuil
        %assigner chaque pixel au superpixel le plus proche
        [label, distance]=assigner_pixels(label, distance, centre, k_reel,L, A, B, S, m, ligne, colonne);

        %recalculer les centres comme moyenne des pixels assignés
        nouveau=recalculer_centres(label, L, A, B, k_reel, ligne, colonne);

        %verification de la convergence
        E=sum(sqrt(sum((nouveau - centre).^2, 2)));
        centre=nouveau;
    end
    k_reel=max(label(:));
    
    % post traitement
    label=ges_connexite(label, k_reel);
    label= combler_orphelins(label);
    label=supprimer_petits(label,10);
    p = centre;
    
end