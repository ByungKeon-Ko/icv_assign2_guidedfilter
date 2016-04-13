%% ======= 1. Guided Filter =========== %%
nCOLOR = 1;

% img_clean_file = './../../images/afghan_clean.png';
% img_input_file = './../../images/afghan_noise2.png';

img_clean_file = './../../images/monkey_clean.png';
img_input_file = './../../images/monkey_noise2.png';

org_I = imread(img_input_file);
% sub_img_annot = [100,100,200,200];
% org_I = imcrop( org_I, sub_img_annot);

figure(1);
imshow(org_I, 'DisplayRange', [0,255]);
figure(1);
title('original');

tic
q = GuidedFilter( org_I, nCOLOR, 0 );
toc

figure(2);
imshow(q, 'DisplayRange', [0,1]);
figure(2);
title('GuidedFilter');

tmp_size = size(org_I);

%% Compute PSNR
if nCOLOR == 1
	img_clean = imread( img_clean_file );
	PSNR = ComputePSNR( img_clean, q);
	fprintf('PNSR = %f\n', PSNR);
end

%% ======= 2. Weight Median Filter =========== %%
if nCOLOR == 1
	tic;
	W_function = 'guided';
	% W_function = 'box';
	box_radius = 8;
	box_hsize = 2*box_radius + 1;
	
	h = zeros( tmp_size(1), tmp_size(2), 256 );
	
	for y = 1:1:tmp_size(1);
		for x = 1:1:tmp_size(2);
			org_I_gray(y,x) = sum(org_I(y,x,:)) /3;
		end
	end
	
	% Histogram 3D map
	for y = 1:1:tmp_size(1);
		for x = 1:1:tmp_size(2);
			h(y,x,uint8( org_I_gray(y,x) ) +1 ) = h(y,x,uint8( org_I_gray(y,x) ) +1 ) +1;
		end
	end
	
	h_filt = zeros(tmp_size(1), tmp_size(2), 256);
	for level = 1:1:256;
		if strcmp(W_function, 'guided')
			if mod( level, 64 ) == 0
				fprintf('current level = %d\n', level);
			end
			h_filt(:,:,level) = GuidedFilter(h(:,:,level), 1, 1 );
		else 
			if mod( level, 64 ) == 0
				fprintf('current level = %d\n', level);
			end
			W = fspecial('average', box_hsize);
			h_filt(:,:,level) = imfilter(h(:,:,level), W, 'replicate')*box_hsize*box_hsize;
		end
	end
	
	img_medi = zeros( tmp_size(1), tmp_size(2)) -1; 
	for y = 1:1:tmp_size(1);
		if mod( y, 64 ) == 0
			fprintf('current y = %d\n', y);
		end
		for x = 1:1:tmp_size(2);
			tmp_sum = sum( h_filt(y,x,:) )/2.;
			for level = 1:1:256;
				tmp_sum = tmp_sum - h_filt(y,x,level);
				if (tmp_sum <= 0) & ( img_medi(y,x) < 0 ) ;
					img_medi(y,x) = uint8(level-1);
                endㄹ
			end
		end
	end
	toc
	
	figure(3);
	imshow( img_medi, 'DisplayRange', [0, 255] )
	title('Weigted Median');
end

%% Compute PSNR
if nCOLOR == 1
	img_clean = imread( img_clean_file );
	PSNR = ComputePSNR( img_clean, img_medi);
	fprintf('PNSR = %f\n', PSNR);
end



