
function q = GuidedFilter( org_I, nCOLOR, mode )

org_P = org_I;

etha = 0.1;
radius = 8;
hsize = 2*radius + 1;
sigma = radius/4.;
% hsize = 10;
% sigma = 0.5;
% sigma = 2.0;
% hsize = 5;
% sigma = 0.2;

tmp_size = size(org_I);

I = zeros( tmp_size(1), tmp_size(2), 1 );
P = zeros( tmp_size(1), tmp_size(2), 1 );

if nCOLOR == 1
	if mode == 0 
		I(:,:) = double( sum( permute(org_I, [3,1,2]) ) ) /3. /255.;
		P(:,:) = double( sum( permute(org_P, [3,1,2]) ) ) /3. /255.;
	else
		I(:,:) = double( org_I ) /255. ;
		P(:,:) = double( org_P ) /255. ;
	end
	
	W = fspecial('gaussian', hsize, sigma);
	
	mean_I = imfilter(I, W, 'replicate');
	mean_P = imfilter(P, W, 'replicate');
	
	corr_I = imfilter(I.*I, W, 'replicate');
	corr_IP = imfilter(I.*P, W, 'replicate');
	
	var_I = corr_I - mean_I.*mean_I;
	cov_IP = corr_IP - mean_I.*mean_P;
	
	a = cov_IP ./ ( var_I + etha );
	b = mean_P - a.*mean_I;
	
	mean_a = imfilter(a, W, 'replicate');
	mean_b = imfilter(b, W, 'replicate');
	
	q_tmp = mean_a.*I + mean_b;
	
	q(:,:) = q_tmp;

else 
	q = zeros( tmp_size(1), tmp_size(2), 3 );
	for color = 1:1:3;
		I(:,:) = double( org_I(:,:,color) ) /255.;
		P(:,:) = double( org_P(:,:,color) ) /255.;
		
		W = fspecial('gaussian', hsize, sigma);
		
		mean_I = imfilter(I, W, 'replicate');
		mean_P = imfilter(P, W, 'replicate');
		
		corr_I = imfilter(I.*I, W, 'replicate');
		corr_IP = imfilter(I.*P, W, 'replicate');
		
		var_I = corr_I - mean_I.*mean_I;
		cov_IP = corr_IP - mean_I.*mean_P;
		
		a = cov_IP ./ ( var_I + etha );
		b = mean_P - a.*mean_I;
		
		mean_a = imfilter(a, W, 'replicate');
		mean_b = imfilter(b, W, 'replicate');
		
		q_tmp = mean_a.*I + mean_b;
	
		q(:,:,color) = q_tmp;
	end
end

end

