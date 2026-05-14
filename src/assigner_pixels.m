function [label, distance]= assigner_pixels(label,distance,centre,k_reel,L, A, B, S, m,ligne,colonne)
% pour chaque superpixel,on assigne les pixels de la fenetre 2S×2S
% au superpixel qui est a une distance minimale

    for i=1:k_reel
        cx= round(centre(i,4));
        cy= round(centre(i,5));
        x_min=max(1,cx - S);
        x_max=min(colonne,cx + S);
        y_min=max(1, cy - S);
        y_max=min(ligne,cy + S);

        for x = x_min:x_max
            for y= y_min:y_max
                D= calculer_distance(L(y,x), A(y,x), B(y,x), x, y, centre(i,:), m, S);
                if D < distance(y,x)
                    distance(y,x)= D;
                    label(y,x)= i;
                end
            end
        end
    end
end