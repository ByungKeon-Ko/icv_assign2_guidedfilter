
full_path = './../images/';

clean_file_name = dir([full_path '*_clean.png']);
clean_img = imread(clean_file_name);
[h,w] = size(clean_img);

file_name = dir([full_path '*.png'] );
total_images = numel(file_name);
Nimages = numel(file_names);

for j = 1:Nimages
	m = findstr
end


file1 = '../../images/afghan_claen.png'

tmp_im = imread(file1)

imshow( tmp_in )


