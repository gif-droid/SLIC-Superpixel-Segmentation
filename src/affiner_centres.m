function centre = affiner_centres(centre, L,A,B,k_reel, ligne, colonne)
% On deplace chaque centre vers le pixel de gradient minimal dans son voisinage 3x3

  grad =imgradient(L);
  for i = 1:k_reel
     cx= round(centre(i,  4));
     cy= round(centre(i,5));
     grad_min  = inf;
     meilleurx= cx;
     meilleury = cy;

     for dx = -1:1
        for dy = -1:1
         nx =cx +dx;
            ny = cy+ dy;
              if nx >= 1 && nx <=colonne && ny >= 1 && ny <= ligne
                if grad(ny,nx) <grad_min
                  grad_min= grad(ny,nx);
                      meilleurx= nx ;
                      meilleury= ny;
                  end
               end
            end
        end

        centre(i,:) = [L(meilleury,meilleurx), A(meilleury,meilleurx),B(meilleury,meilleurx), meilleurx, meilleury];
    end
end