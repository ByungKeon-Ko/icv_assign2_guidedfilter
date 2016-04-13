function psnr = ComputePSNR( img_clean, target_result)

	tmp_size = size(target_result);

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
			MSE = MSE + ( target_result(y,x) - img_clean_gray(y,x) )^2. ;
		end
	end
	MSE = MSE / tmp_size(1) / tmp_size(2);

	psnr = 20. * log10(MAX_i / sqrt(MSE) );

end


