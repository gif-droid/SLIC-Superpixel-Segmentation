function label = combler_orphelins(label)
% la fonction nous permet d,eviter d,avoir de pixel non assigner lors de la
% l'assignation ou de la reassignation des pixels
    pixels_orphelins=find(label <= 0 | isnan(label));
    if isempty(pixels_orphelins)
        return;  
    end
    fprintf('%d pixels orphelins corriges\n', length(pixels_orphelins));

    [H, W] = size(label);
    [ligne, colonne] = ind2sub([H, W], pixels_orphelins);

    for i=1:length(pixels_orphelins)
        r=ligne(i);
        c=colonne(i);

        for rayon=1:max(H, W)
            r1=max(1, r-rayon); 
            r2=min(H, r+rayon);
            c1=max(1, c-rayon); 
            c2=min(W, c+rayon);

            voisins=label(r1:r2, c1:c2);
            voisins=voisins(voisins > 0);

            if ~isempty(voisins)
                label(r, c)=mode(voisins);
                break;
            end
        end
    end
  
end