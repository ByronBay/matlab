%% Data import

im9l=imread('9 links 13210 Gain.png');
im9r=imread('9 rechts 13200 Gain.png');
figure
imagesc([im9l,im9r])
colormap gray

%% Image preprocessing

% same intensoity (mean-value subtract)
% background brighjtness distribution subtract (homomoprhisches Filter)

% References
% https://blogs.mathworks.com/steve/2013/07/10/homomorphic-filtering-part-2/
% https://blogs.mathworks.com/steve/2013/06/25/homomorphic-filtering-part-1/
% https://www.amazon.de/Digital-Image-Processing-3Rd-Edn/dp/9332570329/ref=sr_1_1?ie=UTF8&qid=1521721420&sr=8-1&keywords=gonzales+woods+image+processing
% https://www.amazon.de/Image-Processing-Handbook-Gebundene-Ausgabe/dp/B011DCFU4O/ref=sr_1_1?s=books&ie=UTF8&qid=1521721541&sr=1-1&keywords=image+processing+handbook


%% Control parameter

% dimensions of the "shadow-Template"
T_halfsize_y = 30;
T_halfsize_x = 30;

% controls the cutoff for the normalized-cross-correlation coefficients
% (images correlated wiht shadow-template)
correlation_threshold = 0.7;

%% Experimental imge arithmetic

imagesc([im9l + im9r])
imagesc([im9l > im9r])
imagesc([im9l < im9r])
imagesc(and(im9l < im9r , im9l > im9r))
imagesc(or(im9l < im9r , im9l > im9r))
imagesc([im9l > im9r])
imagesc([im9l < im9r])
imagesc([im9l > im9r])
imagesc([im9l > im9r + im9l < im9r])
imagesc([im9l > im9r + im9l < im9r]),colormap jet
imagesc([(im9l > im9r) + (im9l < im9r)]),colormap jet
imagesc(im9l)
imagesc(abs(im9l-im9r))
imagesc(abs(im9r-im9l))
imagesc(im9l)

im_9rgb= cat(3,im9l,im9r,zeros(size(im9l)));
figure
imagesc(im_9rgb)
title('im_9rgb');
h_rgb = gca;

%% Matching using "shadow Template"


T_topDown = [zeros(T_halfsize_y,T_halfsize_x*2);ones(T_halfsize_y,T_halfsize_x*2)];
T_bottomUp = flipud(T_topDown);

figure
imagesc([T_topDown, T_bottomUp]);

c_im9l_Ttd = circshift(normxcorr2(T_topDown,im9l),[-T_halfsize_y -T_halfsize_x]);
c_im9l_Tbu = circshift(normxcorr2(T_bottomUp,im9l),[-T_halfsize_y -T_halfsize_x]);

c_im9r_Ttd = circshift(normxcorr2(T_topDown,im9r),[-T_halfsize_y -T_halfsize_x]);
c_im9r_Tbu = circshift(normxcorr2(T_bottomUp,im9r),[-T_halfsize_y -T_halfsize_x]);

figure(100)
imagesc(c_im9l_Ttd);
title('c_im9l_Ttd','Interpreter','none');
h_c_im9l_Ttd = gca;

figure(200)
imagesc(c_im9l_Tbu);
title('c_im9l_Tbu','Interpreter','none');
h_c_im9l_Tbu = gca;

figure(300)
imagesc(c_im9r_Ttd);
title('c_im9r_Ttd','Interpreter','none');
h_c_im9r_Ttd = gca;

figure(400)
imagesc(c_im9r_Tbu);
title('c_im9r_Tbu','Interpreter','none');
h_c_im9r_Tbu = gca;



%% shadow extraction

c1 = c_im9l_Ttd < correlation_threshold;
c2 = c_im9l_Tbu > correlation_threshold;
c3 = c_im9r_Ttd > correlation_threshold;
c4 = c_im9r_Tbu < correlation_threshold;

s = and(and(c1 ,c2) ,and(c3 ,c4));

figure(500);
imagesc(s),colormap gray
title('final match');
h_s =gca;

%% image analysis

linkaxes([h_rgb, h_c_im9l_Tbu, h_c_im9l_Ttd, h_c_im9r_Tbu, h_c_im9r_Ttd, h_s]);
