%% ======= 1. Guided Filter =========== %%

img_clean_file = './../../images/afghan_clean.png';
img_input_file = './../../images/afghan_noise2.png';

org_I = imread(img_input_file);

q = GuidedFilter( org_I );

figure(1);
imshow(q);

tmp_size = size(org_I);

%% Compute PSNR
if nCOLOR == 1
	img_clean = imread( img_clean_file );
	for y = 1:1:tmp_size(1);
		for x = 1:1:tmp_size(2);
			img_clean_gray(y,x) = sum(img_clean(y,x,:)) /3. /255.0;
		end
	end
	MAX_tmp = max(img_clean_gray) ;
	MAX_i = max(MAX_tmp);
	MSE = 0 ;

	for y = 1:1:tmp_size(1);
		for x = 1:1:tmp_size(2);
			MSE = MSE + ( q(y,x) - img_clean_gray(y,x) )^2. ;
		end
	end
	MSE = MSE / tmp_size(1) / tmp_size(2);

	PSNR = 20. * log10(MAX_i / sqrt(MSE) );
	disp( PSNR );

end

%% ======= 2. Weight Median Filter =========== %%
W_function = 'guided';

h = zeros( tmp_size(1), tmp_size(2), 256 );

for y = 1:1:tmp_size(1);
	for x = 1:1:tmp_size(2);
		org_I_gray(y,x) = sum(org_I(y,x,:)) /3;
	end
end

% Histogram 3D map
for y = 1:1:tmp_size(1);
	for x = 1:1:tmp_size(2);
		h(y,x,org_I_gray(y,x)) = h(y,x,org_I_gray(y,x)) +1;
	end
end

if W_function == 'guided'
	


