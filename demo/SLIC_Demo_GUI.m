function SLIC_Demo_GUI()
% SLIC_Demo_GUI - Interface graphique enrichie pour la demonstration de SLIC
% Etapes affichees :
%   1. Centres initiaux (grille carree)
%   2. Deplacement de gradient (affinage)
%   3. Superpixels carres apres 1ere assignation
%   4. Evolution iteration par iteration
%   5. Resultat final avec contours fins

%% ======= CREATION DE LA FIGURE =======
fig = figure('Name', 'SLIC Demo - Segmentation en Superpixels', ...
    'NumberTitle', 'off', ...
    'Position', [80, 60, 1200, 750], ...
    'Color', [0.13 0.13 0.13], ...
    'Resize', 'on', ...
    'CloseRequestFcn', @fermer_app);

%% ======= PANNEAU GAUCHE - CONTROLES =======
panneau_ctrl = uipanel(fig, ...
    'Title', 'Parametres', ...
    'FontSize', 12, 'FontWeight', 'bold', ...
    'ForegroundColor', [1 1 1], ...
    'BackgroundColor', [0.18 0.18 0.18], ...
    'Position', [0.01 0.01 0.21 0.98]);

% --- Image ---
uicontrol(panneau_ctrl, 'Style','text', 'String','Image :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.91 0.9 0.04]);

btn_image = uicontrol(panneau_ctrl, 'Style','pushbutton', ...
    'String','  Choisir une image', ...
    'FontSize',10,'BackgroundColor',[0.25 0.55 0.95], ...
    'ForegroundColor',[1 1 1],'Units','normalized', ...
    'Position',[0.05 0.85 0.9 0.055],'Callback',@choisir_image);

lbl_image = uicontrol(panneau_ctrl,'Style','text', ...
    'String','Aucune image selectionnee', ...
    'FontSize',8,'ForegroundColor',[0.65 0.65 0.65], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.80 0.9 0.04]);

% --- Separateur ---
uicontrol(panneau_ctrl,'Style','text','String','', ...
    'BackgroundColor',[0.35 0.35 0.35],'Units','normalized', ...
    'Position',[0.05 0.785 0.9 0.003]);

% --- K ---
uicontrol(panneau_ctrl,'Style','text','String','Nombre de superpixels K :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.73 0.9 0.04]);

slider_k = uicontrol(panneau_ctrl,'Style','slider', ...
    'Min',50,'Max',1500,'Value',300, ...
    'SliderStep',[50/1450 100/1450],'Units','normalized', ...
    'Position',[0.05 0.685 0.9 0.035],'Callback',@maj_k);

lbl_k = uicontrol(panneau_ctrl,'Style','text','String','K = 300', ...
    'FontSize',12,'FontWeight','bold', ...
    'ForegroundColor',[0.3 0.95 0.5], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.25 0.64 0.5 0.04]);

% --- m ---
uicontrol(panneau_ctrl,'Style','text','String','Compacite m :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.59 0.9 0.04]);

slider_m = uicontrol(panneau_ctrl,'Style','slider', ...
    'Min',1,'Max',40,'Value',15, ...
    'SliderStep',[1/39 5/39],'Units','normalized', ...
    'Position',[0.05 0.545 0.9 0.035],'Callback',@maj_m);

lbl_m = uicontrol(panneau_ctrl,'Style','text','String','m = 15', ...
    'FontSize',12,'FontWeight','bold', ...
    'ForegroundColor',[1 0.6 0.2], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.25 0.50 0.5 0.04]);

% --- Couleur contours ---
uicontrol(panneau_ctrl,'Style','text','String','Couleur des contours :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.455 0.9 0.04]);

popup_couleur = uicontrol(panneau_ctrl,'Style','popupmenu', ...
    'String',{'Rouge','Vert','Bleu','Jaune','Blanc','Noir'},'Value',1, ...
    'FontSize',10,'Units','normalized', ...
    'Position',[0.05 0.41 0.9 0.04]);

% --- Vitesse ---
uicontrol(panneau_ctrl,'Style','text','String','Pause entre etapes (s) :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.36 0.9 0.04]);

slider_pause = uicontrol(panneau_ctrl,'Style','slider', ...
    'Min',0.1,'Max',3.0,'Value',0.8, ...
    'SliderStep',[0.1/2.9 0.5/2.9],'Units','normalized', ...
    'Position',[0.05 0.315 0.9 0.035],'Callback',@maj_pause);

lbl_pause = uicontrol(panneau_ctrl,'Style','text','String','pause = 0.8s', ...
    'FontSize',10,'ForegroundColor',[0.8 0.8 0.8], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.2 0.275 0.6 0.035]);

% --- Separateur ---
uicontrol(panneau_ctrl,'Style','text','String','', ...
    'BackgroundColor',[0.35 0.35 0.35],'Units','normalized', ...
    'Position',[0.05 0.255 0.9 0.003]);

% --- Iterations max ---
uicontrol(panneau_ctrl,'Style','text','String','Iterations max :', ...
    'FontSize',10,'FontWeight','bold','ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.18 0.18 0.18],'Units','normalized', ...
    'Position',[0.05 0.215 0.9 0.035]);

edit_itermax = uicontrol(panneau_ctrl,'Style','edit','String','20', ...
    'FontSize',11,'BackgroundColor',[0.25 0.25 0.25], ...
    'ForegroundColor',[1 1 1],'Units','normalized', ...
    'Position',[0.25 0.175 0.5 0.035]);

% --- Bouton LANCER ---
btn_lancer = uicontrol(panneau_ctrl,'Style','pushbutton', ...
    'String','   LANCER SLIC', ...
    'FontSize',13,'FontWeight','bold', ...
    'BackgroundColor',[0.08 0.72 0.28], ...
    'ForegroundColor',[1 1 1],'Units','normalized', ...
    'Position',[0.05 0.09 0.9 0.07],'Callback',@lancer_slic);

% --- Bouton ARRETER ---
btn_stop = uicontrol(panneau_ctrl,'Style','pushbutton', ...
    'String','   ARRETER', ...
    'FontSize',11,'FontWeight','bold', ...
    'BackgroundColor',[0.75 0.1 0.1], ...
    'ForegroundColor',[1 1 1],'Units','normalized', ...
    'Position',[0.05 0.015 0.9 0.06], ...
    'Callback',@arreter_slic,'Enable','off');

%% ======= PANNEAU DROIT - AFFICHAGE =======
panneau_img = uipanel(fig, ...
    'Title','Visualisation', ...
    'FontSize',12,'FontWeight','bold', ...
    'ForegroundColor',[1 1 1], ...
    'BackgroundColor',[0.10 0.10 0.10], ...
    'Position',[0.23 0.09 0.76 0.90]);

ax = axes(panneau_img, ...
    'Position',[0.01 0.01 0.98 0.98], ...
    'Color',[0.08 0.08 0.08]);
axis(ax,'off');

% --- Barre de statut ---
lbl_statut = uicontrol(fig,'Style','text', ...
    'String','  En attente... Choisissez une image et lancez SLIC.', ...
    'FontSize',10,'ForegroundColor',[0.9 0.9 0.9], ...
    'BackgroundColor',[0.08 0.08 0.08], ...
    'HorizontalAlignment','left','Units','normalized', ...
    'Position',[0.23 0.01 0.76 0.055]);

%% ======= VARIABLES PARTAGEES =======
image_data = [];
stopper    = false;

%% ======= CALLBACKS =======

    function choisir_image(~,~)
        [f,d] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tif','Images'},'Choisir une image');
        if f ~= 0
            image_data = imread(fullfile(d,f));
            set(lbl_image,'String',f);
            axes(ax); imshow(image_data,'Parent',ax);
            title(ax,'Image chargee - Prete','Color',[1 1 1],'FontSize',12);
            set(lbl_statut,'String',['  Image chargee : ' f]);
        end
    end

    function maj_k(~,~)
        set(lbl_k,'String',['K = ' num2str(round(get(slider_k,'Value')))]);
    end
    function maj_m(~,~)
        set(lbl_m,'String',['m = ' num2str(round(get(slider_m,'Value')))]);
    end
    function maj_pause(~,~)
        set(lbl_pause,'String',['pause = ' num2str(get(slider_pause,'Value'),'%.1f') 's']);
    end
    function arreter_slic(~,~)
        stopper = true;
    end
    function fermer_app(~,~)
        stopper = true;
        delete(fig);
    end

    % ============================================================
    function lancer_slic(~,~)
        if isempty(image_data)
            set(lbl_statut,'String','  Veuillez choisir une image dabord !');
            return;
        end

        stopper = false;
        set(btn_lancer,'Enable','off','String','  En cours...');
        set(btn_image, 'Enable','off');
        set(btn_stop,  'Enable','on');

        k        = round(get(slider_k,'Value'));
        m        = round(get(slider_m,'Value'));
        vitesse  = get(slider_pause,'Value');
        iter_max = str2double(get(edit_itermax,'String'));
        if isnan(iter_max) || iter_max < 1, iter_max = 20; end

        couleurs = {[1 0 0],[0 1 0],[0 0 1],[1 1 0],[1 1 1],[0 0 0]};
        couleur  = couleurs{get(popup_couleur,'Value')};

        img_d = im2double(image_data);

        try
            %% --- 0. Preparation ---
            lab  = rgb2lab(image_data);
            [ligne, colonne, ~] = size(lab);
            N    = ligne * colonne;
            L    = lab(:,:,1);
            A    = lab(:,:,2);
            B    = lab(:,:,3);
            seuil = 0.05;
            S    = max(1, floor(sqrt(N/k)));

            %% ============================================================
            %% ETAPE 1 : Centres initiaux (grille carree)
            %% ============================================================
            set(lbl_statut,'String','  ETAPE 1/5 : Initialisation des centres (grille carree)...');
            drawnow;

            centre  = initialiser_centres(lab, k);
            k_reel  = size(centre, 1);

            % Afficher image + centres + grille carree
            axes(ax);
            imshow(img_d,'Parent',ax); hold(ax,'on');

            % Tracer la grille carree representant les regions initiales
            for cx_g = floor(S/2):S:colonne
                line(ax,[cx_g cx_g],[1 ligne],'Color',[0.4 0.4 1.0],'LineWidth',0.5,'LineStyle',':');
            end
            for cy_g = floor(S/2):S:ligne
                line(ax,[1 colonne],[cy_g cy_g],'Color',[0.4 0.4 1.0],'LineWidth',0.5,'LineStyle',':');
            end

            % Points des centres
            scatter(ax, centre(:,4), centre(:,5), 30, [1 1 0], 'filled', ...
                'MarkerEdgeColor','k','LineWidth',0.5);

            title(ax, sprintf('ETAPE 1 : %d centres initialises sur grille carree (S=%d px)', k_reel, S), ...
                'Color',[1 1 0.3],'FontSize',12,'FontWeight','bold');
            hold(ax,'off');
            pause(vitesse * 1.5);
            if stopper, nettoyer(); return; end

            %% ============================================================
            %% ETAPE 2 : Affinage par gradient (deplacement des centres)
            %% ============================================================
            set(lbl_statut,'String','  ETAPE 2/5 : Affinage des centres vers gradient minimal...');
            drawnow;

            centres_avant = centre;
            centre = affiner_centres(centre, L, A, B, k_reel, ligne, colonne);

            axes(ax);
            imshow(img_d,'Parent',ax); hold(ax,'on');

            % Afficher gradient en transparence
            grad = imgradient(L);
            grad_norm = mat2gray(grad);
            grad_rgb  = cat(3, grad_norm*0.0, grad_norm*0.4, grad_norm*0.8);
            h_grad = image(ax, grad_rgb);
            set(h_grad,'AlphaData', grad_norm * 0.45);

            % Fleches du deplacement
            dx = centre(:,4) - centres_avant(:,4);
            dy = centre(:,5) - centres_avant(:,5);
            deplaces = (dx.^2 + dy.^2) > 0;
            if any(deplaces)
                quiver(ax, centres_avant(deplaces,4), centres_avant(deplaces,5), ...
                    dx(deplaces), dy(deplaces), 0, ...
                    'Color',[1 0.5 0],'LineWidth',1.2,'MaxHeadSize',2);
            end

            % Anciens centres (jaune) et nouveaux (rouge)
            scatter(ax, centres_avant(:,4), centres_avant(:,5), 20, [1 1 0], 'filled','MarkerEdgeColor','none');
            scatter(ax, centre(:,4),        centre(:,5),        25, [1 0.2 0.2], 'filled','MarkerEdgeColor','none');

            nb_dep = sum(deplaces);
            title(ax, sprintf('ETAPE 2 : Affinage gradient - %d centres deplaces / %d', nb_dep, k_reel), ...
                'Color',[1 0.7 0.2],'FontSize',12,'FontWeight','bold');
            hold(ax,'off');
            pause(vitesse * 1.5);
            if stopper, nettoyer(); return; end

            %% ============================================================
            %% ETAPE 3 : Premiere assignation -> superpixels carres
            %% ============================================================
            set(lbl_statut,'String','  ETAPE 3/5 : Premiere assignation (superpixels carres)...');
            drawnow;

            label    = zeros(ligne, colonne);
            distance = inf(ligne, colonne);

            % Une seule passe d'assignation
            [label, distance] = assigner_pixels(label, distance, centre, ...
                k_reel, L, A, B, S, m, ligne, colonne);

            % Afficher contours fins des superpixels
            contours1 = boundarymask(label);
            img_step3 = imoverlay(img_d, imdilate(contours1, strel('square',1)), couleur);

            axes(ax);
            imshow(img_step3,'Parent',ax); hold(ax,'on');
            scatter(ax, centre(:,4), centre(:,5), 15, [1 1 0.3], 'filled','MarkerEdgeColor','none');
            hold(ax,'off');
            title(ax, 'ETAPE 3 : Premiere assignation - Superpixels carres (avant convergence)', ...
                'Color',[0.4 0.9 1.0],'FontSize',12,'FontWeight','bold');
            pause(vitesse * 1.5);
            if stopper, nettoyer(); return; end

            %% ============================================================
            %% ETAPE 4 : Boucle iterative
            %% ============================================================
            E    = inf;
            iter = 1;

            while E > seuil && iter <= iter_max && ~stopper && ishandle(fig)

                nouveau = recalculer_centres(label, L, A, B, k_reel, ligne, colonne);
                E       = sum(sqrt(sum((nouveau - centre).^2, 2)));
                centre  = nouveau;

                % Reassigner
                distance = inf(ligne, colonne);
                [label, distance] = assigner_pixels(label, distance, centre, ...
                    k_reel, L, A, B, S, m, ligne, colonne);

                % Contours fins : boundarymask seul (1 px)
                contours_iter = boundarymask(label);
                img_iter = imoverlay(img_d, contours_iter, couleur);

                axes(ax);
                imshow(img_iter,'Parent',ax);
                title(ax, sprintf('ETAPE 4 : Iteration %d / %d  |  Erreur E = %.4f  |  Seuil = %.4f', ...
                    iter, iter_max, E, seuil), ...
                    'Color',[1 1 1],'FontSize',12);

                set(lbl_statut,'String', ...
                    sprintf('  Iteration %d | E = %.5f | K_reel = %d', iter, E, k_reel));
                drawnow;
                pause(vitesse);
                iter = iter + 1;
            end

            if stopper, nettoyer(); return; end

            %% ============================================================
            %% ETAPE 5 : Post-traitement + resultat final
            %% ============================================================
            set(lbl_statut,'String','  ETAPE 5/5 : Post-traitement final...');
            drawnow;

            label = ges_connexite(label, max(label(:)));
            label = combler_orphelins(label);
            label = supprimer_petits(label, 10);

            % Contours ultra-fins : boundarymask sans dilatation
            contours_fin = boundarymask(label);
            img_final    = imoverlay(img_d, contours_fin, couleur);

            axes(ax);
            imshow(img_final,'Parent',ax);
            title(ax, sprintf('RESULTAT FINAL  |  K=%d  |  m=%d  |  %d iterations', ...
                k, m, iter-1), ...
                'Color',[0.3 1 0.5],'FontSize',13,'FontWeight','bold');

            set(lbl_statut,'String', ...
                sprintf('  Segmentation terminee en %d iterations | K=%d | m=%d', ...
                iter-1, k, m));

        catch err
            set(lbl_statut,'String',['  Erreur : ' err.message]);
            disp(getReport(err));
        end

        nettoyer();
    end % lancer_slic

    function nettoyer()
        if ishandle(fig)
            set(btn_lancer,'Enable','on','String','   LANCER SLIC');
            set(btn_image, 'Enable','on');
            set(btn_stop,  'Enable','off');
        end
    end

end % SLIC_Demo_GUI
