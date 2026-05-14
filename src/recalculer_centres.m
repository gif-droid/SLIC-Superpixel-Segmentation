function nouveau = recalculer_centres(label, L, A, B, k_reel, ligne, colonne)
% Recalcule chaque centre comme la moyenne des pixels qui lui sont assignes
    nouveau=zeros(k_reel, 5);
    comptage=zeros(k_reel, 1);
    for x=1:colonne
        for y=1:ligne
                idx=label(y,x);
            if idx > 0
                nouveau(idx,:)=nouveau(idx,:)+[L(y,x), A(y,x), B(y,x), x, y];
                    comptage(idx)=comptage(idx)+1;
            end
        end
    end
    for i=1:k_reel
        if comptage(i)> 0
            nouveau(i,:)=nouveau(i,:)/comptage(i);
        end
    end
end