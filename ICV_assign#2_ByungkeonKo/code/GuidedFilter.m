
function q = GuidedFilter( org_I )

org_P = org_I;

etha = 0.1;
hsize = 10;
sigma = 0.5;
nCOLOR = 1;

tmp_size = size(org_I);

I = zeros( tmp_size(1), tmp_size(2), 1 );
P = zeros( tmp_size(1), tmp_size(2), 1 );

if nCOLOR == 1
	for y = 1:1:tmp_size(1);
		for x = 1:1:tmp_size(2);
			I(y,x) = sum(org_I(y,x,:)) /3. /255.0;
			P(y,x) = sum(org_P(y,x,:)) /3. /255.0;
		end
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
	for color = 1:1:3
		for y = 1:1:tmp_size(1);
			for x = 1:1:tmp_size(2);
				% I(y,x) = sum(org_I(y,x,:)) /3. /255.0;
				% P(y,x) = sum(org_P(y,x,:)) /3. /255.0;
				I(y,x) = org_I(y,x,color) /255.0;
				P(y,x) = org_P(y,x,color) /255.0;
			end
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
	
		q(:,:,color) = q_tmp;
	end
end

end

